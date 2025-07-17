import { Server, Socket } from "socket.io";
import { Server as HttpServer } from "http";
import jwt from "jsonwebtoken";
import pool from "../config/db";

interface AuthenticatedSocket extends Socket {
  userId?: number;
  username?: string;
}

export const setupSocket = (server: HttpServer) => {
  const io = new Server(server, {
    cors: {
      origin: process.env.FRONTEND_URL || "http://localhost:3000",
      methods: ["GET", "POST"],
    },
  });

  io.use(async (socket: any, next) => {
    try {
      const token = socket.handshake.auth.token;
      if (!token) {
        return next(new Error("Authentication error"));
      }

      const decoded = jwt.verify(
        token,
        process.env.JWT_SECRET as string
      ) as any;

      const userResult = await pool.query(
        "SELECT id, username FROM users WHERE id = $1",
        [decoded.id]
      );

      if (userResult.rows.length === 0) {
        return next(new Error("User not found"));
      }

      socket.userId = decoded.id;
      socket.username = userResult.rows[0].username;
      next();
    } catch (error) {
      next(new Error("Authentication error"));
    }
  });

  io.on("connection", (socket: AuthenticatedSocket) => {
    console.log(`User ${socket.username} (${socket.userId}) connected`);

    socket.on("joinTeam", async (teamId: number) => {
      try {
        const memberCheck = await pool.query(
          "SELECT user_id FROM team_members WHERE user_id = $1 AND team_id = $2",
          [socket.userId, teamId]
        );

        if (memberCheck.rows.length > 0) {
          socket.join(`team-${teamId}`);
          console.log(`User ${socket.username} joined team ${teamId}`);

          socket.to(`team-${teamId}`).emit("userJoined", {
            userId: socket.userId,
            username: socket.username,
            message: `${socket.username} joined the chat`,
          });
        } else {
          socket.emit("error", {
            message: "You are not a member of this team",
          });
        }
      } catch (error) {
        console.error("Error joining team:", error);
        socket.emit("error", { message: "Failed to join team chat" });
      }
    });

    socket.on("leaveTeam", (teamId: number) => {
      socket.leave(`team-${teamId}`);
      console.log(`User ${socket.username} left team ${teamId}`);

      socket.to(`team-${teamId}`).emit("userLeft", {
        userId: socket.userId,
        username: socket.username,
        message: `${socket.username} left the chat`,
      });
    });

    socket.on(
      "sendTeamMessage",
      async (data: { teamId: number; content: string }) => {
        try {
          const { teamId, content } = data;

          if (!content || content.trim().length === 0) {
            socket.emit("error", { message: "Message content is required" });
            return;
          }

          if (content.length > 1000) {
            socket.emit("error", {
              message: "Message content cannot exceed 1000 characters",
            });
            return;
          }

          const memberCheck = await pool.query(
            "SELECT user_id FROM team_members WHERE user_id = $1 AND team_id = $2",
            [socket.userId, teamId]
          );

          if (memberCheck.rows.length === 0) {
            socket.emit("error", {
              message: "You are not a member of this team",
            });
            return;
          }

          const result = await pool.query(
            `INSERT INTO team_chat_messages (team_id, sender_id, content)
           VALUES ($1, $2, $3)
           RETURNING id, team_id, sender_id, content, created_at`,
            [teamId, socket.userId, content.trim()]
          );

          const message = {
            ...result.rows[0],
            sender_username: socket.username,
          };

          io.to(`team-${teamId}`).emit("newTeamMessage", message);

          console.log(`Message sent to team ${teamId} by ${socket.username}`);
        } catch (error) {
          console.error("Error sending team message:", error);
          socket.emit("error", { message: "Failed to send message" });
        }
      }
    );

    socket.on("typing", (data: { teamId: number; isTyping: boolean }) => {
      socket.to(`team-${data.teamId}`).emit("userTyping", {
        userId: socket.userId,
        username: socket.username,
        isTyping: data.isTyping,
      });
    });

    socket.on("disconnect", () => {
      console.log(`User ${socket.username} (${socket.userId}) disconnected`);
    });
  });

  return io;
};
