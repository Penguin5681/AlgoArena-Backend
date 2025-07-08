# AlgoArena Backend API Documentation

This document provides an overview of the RESTful API endpoints for the AlgoArena backend.

## Base URL

The base URL for all API endpoints is not explicitly defined here, but typically it would be something like `http://localhost:3000/api` in development.

## Authentication

Most protected endpoints require a JSON Web Token (JWT) passed in the `Authorization` header as a Bearer token:

`Authorization: Bearer <your_jwt_token>`

## API Endpoints

| Method | Endpoint | Description | Authentication |
|---|---|---|---|
| POST | /api/auth/signup | Registers a new user. | None |
| POST | /api/auth/login | Authenticates a user and returns a JWT token. | None |
| POST | /api/auth/firebase-login | Authenticates a user using Firebase ID token. If the user doesn't exist, a new account is created. | None |
| GET | /api/auth/check/username/:username | Checks if a username is already taken. | None |
| GET | /api/auth/check/email/:email | Checks if an email is already registered. | None |
| GET | /api/auth/check/availability | Checks the availability of a username and/or email. | None |
| GET | /api/auth/account/deletion-info | Retrieves information about the impact of account deletion, including team memberships and learning progress. | Required |
| DELETE | /api/auth/account | Deletes the authenticated user's account and associated data. If the user is the sole admin of any team, those teams will also be deleted. | Required |
| POST | /api/profile/upload-profile-picture | Uploads a profile picture for a user. | None (email is sent in body) |
| GET | /api/profile/get-profile/:email | Retrieves a user's public profile information. | None |
| PATCH | /api/profile/update | Updates multiple fields of the authenticated user's profile. | Required |
| PATCH | /api/profile/update-bio | Updates the bio of the authenticated user's profile. | Required |
| PATCH | /api/profile/update-role | Updates the role of the authenticated user's profile. | Required |
| PATCH | /api/profile/update-tech-stack | Updates the tech stack of the authenticated user's profile. | Required |
| PATCH | /api/profile/update-programming-languages | Updates the programming languages of the authenticated user's profile. | Required |
| PATCH | /api/profile/update-social-links | Updates the social links of the authenticated user's profile. | Required |
| POST | /api/code/submit | Submits code for execution against a problem (or for general compilation). | None (userId is sent in body) |
| GET | /api/code/result/:submissionId | Retrieves the result of a code submission. | None |
| POST | /api/code-execution/problems/:problemId/submit | Submits code for a specific coding problem to be tested against its test cases. | Required |
| POST | /api/code-execution/compile | Submits code for compilation only (no test cases). | Required |
| GET | /api/code-execution/submissions/:submissionId | Retrieves the detailed result of a code submission, including test results if applicable. | Required |
| GET | /api/code-execution/submissions | Retrieves all code submissions for the authenticated user, with optional filtering and pagination. | Required |
| GET | /api/code-execution/problems/:problemId/test-cases | Retrieves sample test cases for a given coding problem. | None |
| GET | /api/code-execution/problems/:problemId/templates/:language | Retrieves a code template for a specific problem and programming language. | None |
| GET | /api/code-execution/problems/:problemId/templates | Retrieves all available code templates for a specific problem. | None |
| POST | /api/code-execution/problems/:problemId/templates/:language | Creates or updates a code template for a specific problem and language. | None |
| POST | /api/code-execution/templates/seed/file | Seeds code templates from a JSON file. | None |
| POST | /api/code-execution/templates/seed/body | Seeds code templates directly from the request body. | None |
| DELETE | /api/code-execution/problems/:problemId/templates/:language | Deletes a code template for a specific problem and language. | None |
| POST | /api/code-execution/problems/:problemId/submit-raw | Submits raw code for a specific coding problem to be tested against its test cases. | Required |
| GET | /api/learn/summary | Retrieves a summary of all learning topics, including user's progress. | None (user_id is sent in body) |
| GET | /api/learn/topic/:id | Retrieves detailed information about a specific learning topic, including code examples. | None |
| GET | /api/learn/topic/:id/questions | Retrieves coding questions associated with a specific learning topic, including user's progress. | None (user_id is sent in query) |
| GET | /api/learn/topic/:id/mcqs | Retrieves multiple-choice questions (MCQs) associated with a specific learning topic. | None |
| POST | /api/learn/xp | Retrieves the total XP for a user. | None (user_id is sent in body) |
| POST | /api/learn/progress/topic | Updates a user's progress on a specific learning topic. | None (user_id is sent in body) |
| POST | /api/learn/progress/question | Updates a user's progress on a specific coding question. | None (user_id is sent in body) |
| GET | /api/learn/progress/topics | Retrieves a user's progress for all topics. | None (user_id is sent in query) |
| GET | /api/learn/progress | Retrieves a user's overall learning progress, including topic and question progress. | None (user_id is sent in query) |
| POST | /api/seed-problems/seed-problems | Seeds coding problems from a JSON file. | None |
| GET | /api/seed-problems/status | Retrieves the status of seeded problems, including counts of test cases. | None |
| GET | /api/seed-problems/problems | Retrieves all coding problems with optional filtering, sorting, and pagination. | None |
| GET | /api/seed-problems/problems/:id | Retrieves detailed information about a specific coding problem, including all test cases. | None |
| GET | /api/seed-problems/topics/:topicId/problems | Retrieves coding problems associated with a specific topic. | None |
| GET | /api/seed-problems/topics | Retrieves all problem topics with counts of problems by difficulty. | None |
| POST | /api/team/create | Creates a new team and sets the creating user as an admin. | Required |
| POST | /api/team/join | Allows a user to join an existing team using a join code. | Required |
| POST | /api/team/leave | Allows a user to leave their current team. Admins cannot leave and must delete the team instead. | Required |
| DELETE | /api/team/delete | Deletes the team that the authenticated user is an admin of. | Required |
| GET | /api/team/teamInfo | Retrieves detailed information about the authenticated user's team, including members. | Required |
| GET | /api/team/current | Retrieves information about the authenticated user's current team. | Required |
| POST | /api/team/promote | Promotes a team member to an admin. | Required (must be an admin) |
| POST | /api/team/demote | Demotes a team admin to a regular member. | Required (must be an admin) |
| GET | /api/xp/user | Retrieves the authenticated user's total XP and recent solved problems. | Required |
| GET | /api/xp/solved-problems | Retrieves a list of all problems solved by the authenticated user, including a breakdown by difficulty. | Required |
| GET | /api/xp/problem/:problemId/solved | Checks if a specific problem has been solved by the authenticated user and provides details if solved. | Required |
| DELETE | /api/admin/delete-user/:userId | Deletes all data associated with a specific user ID. This is a destructive operation. | None (Assumed to be an admin-only endpoint, but no middleware shown in route file) |
| POST | /api/analysis/complexity | Analyzes the complexity of provided code using an external service (OpenAI). | None |
| GET | /api/health/debug | A simple debug endpoint. | None |
| GET | /api/health/health | Checks the health of the server and database connection. | None |
| POST | /api/seed/seed-learning | Seeds learning materials (topics, questions, MCQs, code examples) from an uploaded ZIP file. | None |
| DELETE | /api/seed/seed-learning | Deletes all learning materials (topics, questions, MCQs, code examples) from the database. | None |

---

### 1. Authentication & User Management

#### `POST /api/auth/signup`
*   **Description:** Registers a new user.
*   **Authentication:** None
*   **Request Body:**
    ```json
    {
        "username": "string",
        "email": "string (email format)",
        "password": "string"
    }
    ```
*   **Response Body (Success 201):**
    ```json
    {
        "message": "User created"
    }
    ```
*   **Response Body (Error 500):**
    ```json
    {
        "message": "Error message"
    }
    ```

#### `POST /api/auth/login`
*   **Description:** Authenticates a user and returns a JWT token.
*   **Authentication:** None
*   **Request Body:**
    ```json
    {
        "identifier": "string (username or email)",
        "password": "string"
    }
    ```
*   **Response Body (Success 200):**
    ```json
    {
        "token": "string (JWT)",
        "user": {
            "id": "number",
            "username": "string",
            "email": "string",
            "profile_picture": "string (URL or null)"
        }
    }
    ```
*   **Response Body (Error 401):**
    ```json
    {
        "error": "Invalid credentials"
    }
    ```
*   **Response Body (Error 500):**
    ```json
    {
        "error": "Server error: message"
    }
    ```

#### `POST /api/auth/firebase-login`
*   **Description:** Authenticates a user using Firebase ID token. If the user doesn't exist, a new account is created.
*   **Authentication:** None
*   **Request Body:**
    ```json
    {
        "idToken": "string (Firebase ID token)",
        "email": "string (user's email)",
        "name": "string (user's display name, optional)",
        "photoURL": "string (user's photo URL, optional)",
        "uid": "string (Firebase user ID)"
    }
    ```
*   **Response Body (Success 200):**
    ```json
    {
        "token": "string (JWT)",
        "user": {
            "id": "number",
            "username": "string",
            "email": "string",
            "profilePicture": "string (URL or null)"
        }
    }
    ```
*   **Response Body (Error 400):**
    ```json
    {
        "error": "ID token is required"
    }
    ```
*   **Response Body (Error 401):**
    ```json
    {
        "error": "Invalid Firebase token: message"
    }
    ```

#### `GET /api/auth/check/username/:username`
*   **Description:** Checks if a username is already taken.
*   **Authentication:** None
*   **Parameters:**
    *   `username`: `string` (Path parameter) - The username to check.
*   **Response Body (Success 200):**
    ```json
    {
        "username": "string",
        "exists": "boolean",
        "available": "boolean"
    }
    ```
*   **Response Body (Error 400):**
    ```json
    {
        "error": "Username is required"
    }
    ```

#### `GET /api/auth/check/email/:email`
*   **Description:** Checks if an email is already registered.
*   **Authentication:** None
*   **Parameters:**
    *   `email`: `string` (Path parameter) - The email to check.
*   **Response Body (Success 200):**
    ```json
    {
        "email": "string",
        "exists": "boolean",
        "available": "boolean"
    }
    ```
*   **Response Body (Error 400):**
    ```json
    {
        "error": "Email is required"
    }
    ```

#### `GET /api/auth/check/availability`
*   **Description:** Checks the availability of a username and/or email.
*   **Authentication:** None
*   **Parameters:**
    *   `username`: `string` (Query parameter, optional) - The username to check.
    *   `email`: `string` (Query parameter, optional) - The email to check.
*   **Response Body (Success 200):**
    ```json
    {
        "username": {
            "value": "string",
            "exists": "boolean",
            "available": "boolean"
        },
        "email": {
            "value": "string",
            "exists": "boolean",
            "available": "boolean"
        }
    }
    ```
*   **Response Body (Error 400):**
    ```json
    {
        "error": "Username or email is required"
    }
    ```

#### `GET /api/auth/account/deletion-info`
*   **Description:** Retrieves information about the impact of account deletion, including team memberships and learning progress.
*   **Authentication:** Required
*   **Response Body (Success 200):**
    ```json
    {
        "user": {
            "username": "string",
            "email": "string",
            "isFirebaseUser": "boolean"
        },
        "impact": {
            "teamsAsOnlyAdmin": ["string (team name)"],
            "teamsAsMember": ["string (team name)"],
            "teamsAsCoAdmin": ["string (team name)"],
            "completedTopics": "number",
            "attemptedQuestions": "number",
            "totalXP": "number"
        },
        "warning": "string (warning message if user is sole admin of any team) or null"
    }
    ```

#### `DELETE /api/auth/account`
*   **Description:** Deletes the authenticated user's account and associated data. If the user is the sole admin of any team, those teams will also be deleted.
*   **Authentication:** Required
*   **Request Body:**
    ```json
    {
        "password": "string (required for non-Firebase users)",
        "confirmDelete": "string (must be 'DELETE_MY_ACCOUNT')"
    }
    ```
*   **Response Body (Success 200):**
    ```json
    {
        "message": "Account deleted successfully",
        "deletedTeams": ["string (team name)"]
    }
    ```
*   **Response Body (Error 400):**
    ```json
    {
        "error": "Error message"
    }
    ```
*   **Response Body (Error 401):**
    ```json
    {
        "error": "Invalid password"
    }
    ```
*   **Response Body (Error 404):**
    ```json
    {
        "error": "User not found"
    }
    ```

---

### 2. Profile Management

#### `POST /api/profile/upload-profile-picture`
*   **Description:** Uploads a profile picture for a user.
*   **Authentication:** None (email is sent in body)
*   **Request Body (multipart/form-data):**
    *   `file`: `file` (The image file to upload)
    *   `email`: `string` (The email of the user)
*   **Response Body (Success 200):**
    ```json
    {
        "url": "string (URL of the uploaded picture)"
    }
    ```
*   **Response Body (Error 400):**
    ```json
    {
        "message": "Email is required"
    }
    ```

#### `GET /api/profile/get-profile/:email`
*   **Description:** Retrieves a user's public profile information.
*   **Authentication:** None
*   **Parameters:**
    *   `email`: `string` (Path parameter) - The email of the user.
*   **Response Body (Success 200):**
    ```json
    {
        "email": "string",
        "username": "string",
        "github_link": "string | null",
        "linkedin_link": "string | null",
        "facebook_link": "string | null",
        "profile_picture": "string | null",
        "rank": "number | null",
        "bio": "string | null",
        "tech_stack": "string[] | null",
        "programming_languages": "string[] | null",
        "role": "string | null",
        "badges": "string[] | null"
    }
    ```
*   **Response Body (Error 400):**
    ```json
    {
        "error": "Email is required"
    }
    ```
*   **Response Body (Error 404):**
    ```json
    {
        "error": "User not found"
    }
    ```

#### `PATCH /api/profile/update`
*   **Description:** Updates multiple fields of the authenticated user's profile.
*   **Authentication:** Required
*   **Request Body:**
    ```json
    {
        "email": "string",
        "github_link": "string (optional)",
        "linkedin_link": "string (optional)",
        "facebook_link": "string (optional)",
        "tech_stack": "string[] (optional)",
        "programming_languages": "string[] (optional)",
        "profile_picture": "string (URL, optional)"
    }
    ```
*   **Response Body (Success 200):**
    ```json
    {
        "message": "Profile updated",
        "user": {
            // Updated user object
        }
    }
    ```

#### `PATCH /api/profile/update-bio`
*   **Description:** Updates the bio of the authenticated user's profile.
*   **Authentication:** Required
*   **Request Body:**
    ```json
    {
        "email": "string",
        "bio": "string"
    }
    ```
*   **Response Body (Success 200):**
    ```json
    {
        "message": "Bio updated",
        "user": {
            // Updated user object
        }
    }
    ```

#### `PATCH /api/profile/update-role`
*   **Description:** Updates the role of the authenticated user's profile.
*   **Authentication:** Required
*   **Request Body:**
    ```json
    {
        "email": "string",
        "role": "string"
    }
    ```
*   **Response Body (Success 200):**
    ```json
    {
        "message": "Role updated",
        "user": {
            // Updated user object
        }
    }
    ```

#### `PATCH /api/profile/update-tech-stack`
*   **Description:** Updates the tech stack of the authenticated user's profile.
*   **Authentication:** Required
*   **Request Body:**
    ```json
    {
        "email": "string",
        "tech_stack": "string[]"
    }
    ```
*   **Response Body (Success 200):**
    ```json
    {
        "message": "Tech stack updated",
        "user": {
            // Updated user object
        }
    }
    ```

#### `PATCH /api/profile/update-programming-languages`
*   **Description:** Updates the programming languages of the authenticated user's profile.
*   **Authentication:** Required
*   **Request Body:**
    ```json
    {
        "email": "string",
        "programming_languages": "string[]"
    }
    ```
*   **Response Body (Success 200):**
    ```json
    {
        "message": "Programming languages updated",
        "user": {
            // Updated user object
        }
    }
    ```

#### `PATCH /api/profile/update-social-links`
*   **Description:** Updates the social links of the authenticated user's profile.
*   **Authentication:** Required
*   **Request Body:**
    ```json
    {
        "email": "string",
        "github_link": "string (optional)",
        "linkedin_link": "string (optional)",
        "facebook_link": "string (optional)"
    }
    ```
*   **Response Body (Success 200):**
    ```json
    {
        "message": "Social links updated",
        "user": {
            // Updated user object
        }
    }
    ```

---

### 3. Code Submission & Execution

#### `POST /api/code/submit`
*   **Description:** Submits code for execution against a problem (or for general compilation).
*   **Authentication:** None (userId is sent in body)
*   **Request Body:**
    ```json
    {
        "code": "string",
        "language": "string",
        "stdin": "string (optional)",
        "userId": "number"
    }
    ```
*   **Response Body (Success 201):**
    ```json
    {
        "submissionId": "string"
    }
    ```

#### `GET /api/code/result/:submissionId`
*   **Description:** Retrieves the result of a code submission.
*   **Authentication:** None
*   **Parameters:**
    *   `submissionId`: `string` (Path parameter) - The ID of the submission.
*   **Response Body (Success 200):**
    ```json
    {
        "id": "string",
        "status": "string (e.g., 'queued', 'processing', 'completed', 'error')",
        "stdout": "string | null",
        "stderr": "string | null",
        "executionTime": "number | null (in milliseconds)",
        "memoryUsage": "number | null (in bytes)",
        "createdAt": "string (ISO date)",
        "updatedAt": "string (ISO date)"
    }
    ```

#### `POST /api/code-execution/problems/:problemId/submit`
*   **Description:** Submits code for a specific coding problem to be tested against its test cases.
*   **Authentication:** Required
*   **Parameters:**
    *   `problemId`: `string` (Path parameter) - The ID of the coding problem.
*   **Request Body:**
    ```json
    {
        "language": "string",
        "code": "string"
    }
    ```
*   **Response Body (Success 200):**
    ```json
    {
        "success": true,
        "data": {
            "submissionId": "string",
            "status": "string (e.g., 'pending')",
            "message": "Code submitted for testing"
        }
    }
    ```

#### `POST /api/code-execution/compile`
*   **Description:** Submits code for compilation only (no test cases).
*   **Authentication:** Required
*   **Request Body:**
    ```json
    {
        "language": "string",
        "code": "string",
        "stdin": "string (optional)"
    }
    ```
*   **Response Body (Success 200):**
    ```json
    {
        "success": true,
        "data": {
            "submissionId": "string",
            "status": "string (e.g., 'pending')",
            "message": "Code submitted for compilation"
        }
    }
    ```

#### `GET /api/code-execution/submissions/:submissionId`
*   **Description:** Retrieves the detailed result of a code submission, including test results if applicable.
*   **Authentication:** Required
*   **Parameters:**
    *   `submissionId`: `string` (Path parameter) - The ID of the submission.
*   **Response Body (Success 200):**
    ```json
    {
        "success": true,
        "data": {
            "submissionId": "string",
            "language": "string",
            "status": "string",
            "stdout": "string | null",
            "stderr": "string | null",
            "executionTime": "number | null",
            "problemTitle": "string | null",
            "testResults": "array | null",
            "testsPassed": "number | null",
            "totalTests": "number | null",
            "createdAt": "string (ISO date)",
            "updatedAt": "string (ISO date)"
        }
    }
    ```

#### `GET /api/code-execution/submissions`
*   **Description:** Retrieves all code submissions for the authenticated user, with optional filtering and pagination.
*   **Authentication:** Required
*   **Parameters:**
    *   `problemId`: `string` (Query parameter, optional) - Filter by problem ID.
    *   `status`: `string` (Query parameter, optional) - Filter by submission status.
    *   `limit`: `number` (Query parameter, optional, default: 20) - Maximum number of submissions to return.
    *   `offset`: `number` (Query parameter, optional, default: 0) - Number of submissions to skip.
*   **Response Body (Success 200):**
    ```json
    {
        "success": true,
        "data": {
            "submissions": [
                {
                    // Submission object (similar to GET /api/code-execution/submissions/:submissionId)
                }
            ],
            "pagination": {
                "limit": "number",
                "offset": "number"
            }
        }
    }
    ```

#### `GET /api/code-execution/problems/:problemId/test-cases`
*   **Description:** Retrieves sample test cases for a given coding problem.
*   **Authentication:** None
*   **Parameters:**
    *   `problemId`: `string` (Path parameter) - The ID of the coding problem.
*   **Response Body (Success 200):**
    ```json
    {
        "success": true,
        "data": {
            "testCases": [
                {
                    "id": "number",
                    "input": "string",
                    "expected_output": "string"
                }
            ]
        }
    }
    ```

#### `GET /api/code-execution/problems/:problemId/templates/:language`
*   **Description:** Retrieves a code template for a specific problem and programming language.
*   **Authentication:** None
*   **Parameters:**
    *   `problemId`: `string` (Path parameter) - The ID of the coding problem.
    *   `language`: `string` (Path parameter) - The programming language (e.g., 'javascript', 'python').
*   **Response Body (Success 200):**
    ```json
    {
        "success": true,
        "data": {
            "id": "number",
            "problemId": "string",
            "language": "string",
            "template": "string (base64 encoded code)",
            "isBase64Encoded": true,
            "createdAt": "string (ISO date)"
        }
    }
    ```

#### `GET /api/code-execution/problems/:problemId/templates`
*   **Description:** Retrieves all available code templates for a specific problem.
*   **Authentication:** None
*   **Parameters:**
    *   `problemId`: `string` (Path parameter) - The ID of the coding problem.
*   **Response Body (Success 200):**
    ```json
    {
        "success": true,
        "data": {
            "templates": [
                {
                    "id": "number",
                    "problemId": "string",
                    "language": "string",
                    "template": "string (base64 encoded code)",
                    "isBase64Encoded": true,
                    "createdAt": "string (ISO date)"
                }
            ]
        }
    }
    ```

#### `POST /api/code-execution/problems/:problemId/templates/:language`
*   **Description:** Creates or updates a code template for a specific problem and language.
*   **Authentication:** None
*   **Parameters:**
    *   `problemId`: `string` (Path parameter) - The ID of the coding problem.
    *   `language`: `string` (Path parameter) - The programming language.
*   **Request Body:**
    ```json
    {
        "template": "string (the code template, can be base64 encoded)",
        "isBase64Encoded": "boolean (optional, default: false)"
    }
    ```
*   **Response Body (Success 200):**
    ```json
    {
        "success": true,
        "data": {
            "id": "number",
            "problemId": "string",
            "language": "string",
            "template": "string (base64 encoded code)",
            "isBase64Encoded": true,
            "createdAt": "string (ISO date)"
        }
    }
    ```

#### `POST /api/code-execution/templates/seed/file`
*   **Description:** Seeds code templates from a JSON file.
*   **Authentication:** None
*   **Request Body:**
    ```json
    {
        "filePath": "string (absolute path to the JSON file)"
    }
    ```
*   **Response Body (Success 200):**
    ```json
    {
        "success": true,
        "data": {
            "message": "Templates seeded successfully",
            "summary": {
                "successful": "number",
                "failed": "number",
                "errors": ["string"]
            }
        }
    }
    ```

#### `POST /api/code-execution/templates/seed/body`
*   **Description:** Seeds code templates directly from the request body.
*   **Authentication:** None
*   **Request Body:**
    ```json
    {
        "templates": [
            {
                "problemId": "string",
                "language": "string",
                "template": "string (the code template, can be base64 encoded)",
                "isBase64Encoded": "boolean (optional, default: false)"
            }
        ]
    }
    ```
*   **Response Body (Success 200):**
    ```json
    {
        "success": true,
        "data": {
            "message": "Templates seeded successfully",
            "summary": {
                "successful": "number",
                "failed": "number",
                "errors": ["string"]
            }
        }
    ```

#### `DELETE /api/code-execution/problems/:problemId/templates/:language`
*   **Description:** Deletes a code template for a specific problem and language.
*   **Authentication:** None
*   **Parameters:**
    *   `problemId`: `string` (Path parameter) - The ID of the coding problem.
    *   `language`: `string` (Path parameter) - The programming language.
*   **Response Body (Success 200):**
    ```json
    {
        "success": true,
        "message": "Template deleted successfully"
    }
    ```

#### `POST /api/code-execution/problems/:problemId/submit-raw`
*   **Description:** Submits raw code for a specific coding problem to be tested against its test cases.
*   **Authentication:** Required
*   **Parameters:**
    *   `problemId`: `string` (Path parameter) - The ID of the coding problem.
*   **Request Body:**
    ```json
    {
        "code": "string",
        "language": "string"
    }
    ```
*   **Response Body (Success 200):**
    ```json
    {
        "success": true,
        "data": {
            "submissionId": "string",
            "status": "string (e.g., 'pending')",
            "message": "Raw code submitted for testing"
        }
    }
    ```

---

### 4. Learning Module

#### `GET /api/learn/summary`
*   **Description:** Retrieves a summary of all learning topics, including user's progress.
*   **Authentication:** None (user_id is sent in body)
*   **Request Body:**
    ```json
    {
        "user_id": "number"
    }
    ```
*   **Response Body (Success 200):**
    ```json
    [
        {
            "id": "number",
            "title": "string",
            "section": "string",
            "xp": "number",
            "status": "string ('not_started', 'in_progress', 'completed')"
        }
    ]
    ```

#### `GET /api/learn/topic/:id`
*   **Description:** Retrieves detailed information about a specific learning topic, including code examples.
*   **Authentication:** None
*   **Parameters:**
    *   `id`: `number` (Path parameter) - The ID of the topic.
*   **Response Body (Success 200):**
    ```json
    {
        "id": "number",
        "title": "string",
        "slug": "string",
        "section": "string",
        "difficulty": "string",
        "markdown": "string (content of the explanation)",
        "diagrams": "array | null (array of [filename, base64_image_data])",
        "xp": "number",
        "code_examples": [
            {
                "language": "string",
                "code": "string"
            }
        ]
    }
    ```

#### `GET /api/learn/topic/:id/questions`
*   **Description:** Retrieves coding questions associated with a specific learning topic, including user's progress.
*   **Authentication:** None (user_id is sent in query)
*   **Parameters:**
    *   `id`: `number` (Path parameter) - The ID of the topic.
    *   `user_id`: `number` (Query parameter) - The ID of the user.
*   **Response Body (Success 200):**
    ```json
    [
        {
            "id": "string",
            "topic_id": "number",
            "title": "string",
            "description": "string",
            "difficulty": "string",
            "xp": "number",
            "is_passed": "boolean | null",
            "duration_sec": "number | null"
        }
    ]
    ```

#### `GET /api/learn/topic/:id/mcqs`
*   **Description:** Retrieves multiple-choice questions (MCQs) associated with a specific learning topic.
*   **Authentication:** None
*   **Parameters:**
    *   `id`: `number` (Path parameter) - The ID of the topic.
*   **Response Body (Success 200):**
    ```json
    [
        {
            "id": "string",
            "topic_id": "number",
            "question": "string",
            "options": ["string"],
            "correct_index": "number"
        }
    ]
    ```

#### `POST /api/learn/xp`
*   **Description:** Retrieves the total XP for a user.
*   **Authentication:** None (user_id is sent in body)
*   **Request Body:**
    ```json
    {
        "user_id": "number"
    }
    ```
*   **Response Body (Success 200):**
    ```json
    {
        "total_xp": "number"
    }
    ```

#### `POST /api/learn/progress/topic`
*   **Description:** Updates a user's progress on a specific learning topic.
*   **Authentication:** None (user_id is sent in body)
*   **Request Body:**
    ```json
    {
        "user_id": "number",
        "topic_id": "number",
        "status": "string ('in_progress', 'completed')"
    }
    ```
*   **Response Body (Success 200):**
    ```json
    {
        "message": "Topic progress updated."
    }
    ```

#### `POST /api/learn/progress/question`
*   **Description:** Updates a user's progress on a specific coding question.
*   **Authentication:** None (user_id is sent in body)
*   **Request Body:**
    ```json
    {
        "user_id": "number",
        "question_id": "string",
        "is_passed": "boolean",
        "duration_sec": "number",
        "status": "string ('attempted', 'passed')"
    }
    ```
*   **Response Body (Success 200):**
    ```json
    {
        "message": "Question progress updated."
    }
    ```

#### `GET /api/learn/progress/topics`
*   **Description:** Retrieves a user's progress for all topics.
*   **Authentication:** None (user_id is sent in query)
*   **Parameters:**
    *   `user_id`: `number` (Query parameter) - The ID of the user.
*   **Response Body (Success 200):**
    ```json
    {
        "progress": [
            {
                "topic_id": "number",
                "status": "string",
                "completed_at": "string | null (ISO date)"
            }
        ]
    }
    ```

#### `GET /api/learn/progress`
*   **Description:** Retrieves a user's overall learning progress, including topic and question progress.
*   **Authentication:** None (user_id is sent in query)
*   **Parameters:**
    *   `user_id`: `number` (Query parameter) - The ID of the user.
*   **Response Body (Success 200):**
    ```json
    {
        "topic_progress": [
            {
                "topic_id": "number",
                "status": "string",
                "completed_at": "string | null (ISO date)"
            }
        ],
        "question_progress": [
            {
                "question_id": "string",
                "is_passed": "boolean",
                "duration_sec": "number",
                "status": "string",
                "updated_at": "string (ISO date)"
            }
        ]
    }
    ```

---

### 5. Problem Seeding & Retrieval

#### `POST /api/seed-problems/seed-problems`
*   **Description:** Seeds coding problems from a JSON file.
*   **Authentication:** None
*   **Request Body:**
    ```json
    {
        "filePath": "string (absolute path to the JSON file)"
    }
    ```
*   **Response Body (Success 200):**
    ```json
    {
        "success": true,
        "message": "Successfully seeded X problems",
        "seededProblems": [
            {
                "id": "string",
                "title": "string",
                "difficulty": "string",
                "topic": "string"
            }
        ]
    }
    ```

#### `GET /api/seed-problems/status`
*   **Description:** Retrieves the status of seeded problems, including counts of test cases.
*   **Authentication:** None
*   **Response Body (Success 200):**
    ```json
    {
        "totalProblems": "number",
        "problems": [
            {
                "id": "string",
                "title": "string",
                "difficulty": "string",
                "topic": "string",
                "test_case_count": "string (number as string)"
            }
        ]
    }
    ```

#### `GET /api/seed-problems/problems`
*   **Description:** Retrieves all coding problems with optional filtering, sorting, and pagination.
*   **Authentication:** None
*   **Parameters:**
    *   `difficulty`: `string` (Query parameter, optional) - Filter by difficulty ('easy', 'medium', 'hard').
    *   `topic`: `string` (Query parameter, optional) - Filter by topic name (case-insensitive, partial match).
    *   `limit`: `number` (Query parameter, optional, default: 50) - Maximum number of problems to return.
    *   `offset`: `number` (Query parameter, optional, default: 0) - Number of problems to skip.
    *   `sortBy`: `string` (Query parameter, optional, default: 'created_at') - Field to sort by.
    *   `sortOrder`: `string` (Query parameter, optional, default: 'DESC') - Sort order ('ASC' or 'DESC').
*   **Response Body (Success 200):**
    ```json
    {
        "success": true,
        "data": {
            "problems": [
                {
                    "id": "string",
                    "title": "string",
                    "description": "string",
                    "constraints": "string",
                    "difficulty": "string",
                    "time_complexity": "string",
                    "space_complexity": "string",
                    "hints": "string[]",
                    "xp": "number",
                    "created_at": "string (ISO date)",
                    "topic": "string",
                    "topic_id": "number",
                    "test_case_count": "string (number as string)",
                    "sample_test_case_count": "string (number as string)"
                }
            ],
            "pagination": {
                "total": "number",
                "limit": "number",
                "offset": "number",
                "hasMore": "boolean"
            }
        }
    }
    ```

#### `GET /api/seed-problems/problems/:id`
*   **Description:** Retrieves detailed information about a specific coding problem, including all test cases.
*   **Authentication:** None
*   **Parameters:**
    *   `id`: `string` (Path parameter) - The ID of the coding problem.
*   **Response Body (Success 200):**
    ```json
    {
        "success": true,
        "data": {
            "id": "string",
            "title": "string",
            "description": "string",
            "constraints": "string",
            "difficulty": "string",
            "time_complexity": "string",
            "space_complexity": "string",
            "hints": "string[]",
            "xp": "number",
            "created_at": "string (ISO date)",
            "topic": "string",
            "topic_id": "number",
            "testCases": [
                {
                    "id": "number",
                    "input": "string",
                    "expected_output": "string",
                    "is_sample": "boolean"
                }
            ],
            "sampleTestCases": [
                {
                    "id": "number",
                    "input": "string",
                    "expected_output": "string",
                    "is_sample": "boolean"
                }
            ],
            "totalTestCases": "number"
        }
    }
    ```

#### `GET /api/seed-problems/topics/:topicId/problems`
*   **Description:** Retrieves coding problems associated with a specific topic.
*   **Authentication:** None
*   **Parameters:**
    *   `topicId`: `number` (Path parameter) - The ID of the problem topic.
    *   `limit`: `number` (Query parameter, optional, default: 20)
    *   `offset`: `number` (Query parameter, optional, default: 0)
*   **Response Body (Success 200):**
    ```json
    {
        "success": true,
        "data": {
            "problems": [
                {
                    "id": "string",
                    "title": "string",
                    "difficulty": "string",
                    "xp": "number",
                    "created_at": "string (ISO date)",
                    "topic": "string",
                    "test_case_count": "string (number as string)"
                }
            ],
            "topicId": "number",
            "pagination": {
                "limit": "number",
                "offset": "number"
            }
        }
    }
    ```

#### `GET /api/seed-problems/topics`
*   **Description:** Retrieves all problem topics with counts of problems by difficulty.
*   **Authentication:** None
*   **Response Body (Success 200):**
    ```json
    {
        "success": true,
        "data": {
            "topics": [
                {
                    "id": "number",
                    "name": "string",
                    "problem_count": "string (number as string)",
                    "easy_count": "string (number as string)",
                    "medium_count": "string (number as string)",
                    "hard_count": "string (number as string)"
                }
            ]
        }
    }
    ```

---

### 6. Team Management

#### `POST /api/team/create`
*   **Description:** Creates a new team and sets the creating user as an admin.
*   **Authentication:** Required
*   **Request Body:**
    ```json
    {
        "name": "string (team name)"
    }
    ```
*   **Response Body (Success 201):**
    ```json
    {
        "teamId": "number",
        "joinCode": "string"
    }
    ```
*   **Response Body (Error 400):**
    ```json
    {
        "error": "User already in a team"
    }
    ```

#### `POST /api/team/join`
*   **Description:** Allows a user to join an existing team using a join code.
*   **Authentication:** Required
*   **Request Body:**
    ```json
    {
        "joinCode": "string"
    }
    ```
*   **Response Body (Success 200):**
    ```json
    {
        "message": "Joined team"
    }
    ```
*   **Response Body (Error 400):**
    ```json
    {
        "error": "User already in a team"
    }
    ```
*   **Response Body (Error 404):**
    ```json
    {
        "error": "Team not found"
    }
    ```

#### `POST /api/team/leave`
*   **Description:** Allows a user to leave their current team. Admins cannot leave and must delete the team instead.
*   **Authentication:** Required
*   **Response Body (Success 200):**
    ```json
    {
        "message": "Left the team successfully"
    }
    ```
*   **Response Body (Error 403):**
    ```json
    {
        "error": "Admins cannot leave the team. You can delete the team instead."
    }
    ```
*   **Response Body (Error 404):**
    ```json
    {
        "error": "User not in a team"
    }
    ```

#### `DELETE /api/team/delete`
*   **Description:** Deletes the team that the authenticated user is an admin of.
*   **Authentication:** Required
*   **Response Body (Success 200):**
    ```json
    {
        "message": "Team deleted and all members removed"
    }
    ```
*   **Response Body (Error 403):**
    ```json
    {
        "error": "Only admins can delete the team"
    }
    ```

#### `GET /api/team/teamInfo`
*   **Description:** Retrieves detailed information about the authenticated user's team, including members.
*   **Authentication:** Required
*   **Response Body (Success 200):**
    ```json
    {
        "id": "number",
        "name": "string",
        "join_code": "string",
        "created_at": "string (ISO date)",
        "members": [
            {
                "username": "string",
                "email": "string",
                "profile_picture": "string | null",
                "is_admin": "boolean"
            }
        ]
    }
    ```
*   **Response Body (Error 404):**
    ```json
    {
        "error": "User not in a team"
    }
    ```

#### `GET /api/team/current`
*   **Description:** Retrieves information about the authenticated user's current team.
*   **Authentication:** Required
*   **Response Body (Success 200):**
    ```json
    {
        "id": "number",
        "name": "string",
        "join_code": "string",
        "created_at": "string (ISO date)",
        "members": [
            {
                "username": "string",
                "email": "string",
                "profile_picture": "string | null",
                "is_admin": "boolean"
            }
        ]
    }
    ```
*   **Response Body (Error 404):**
    ```json
    {
        "error": "User is not in a team"
    }
    ```

#### `POST /api/team/promote`
*   **Description:** Promotes a team member to an admin.
*   **Authentication:** Required (must be an admin)
*   **Request Body:**
    ```json
    {
        "targetUserEmail": "string (email of the user to promote)"
    }
    ```
*   **Response Body (Success 200):**
    ```json
    {
        "message": "User promoted to admin successfully",
        "user": "string (email of the promoted user)"
    }
    ```
*   **Response Body (Error 400):**
    ```json
    {
        "error": "Error message"
    }
    ```
*   **Response Body (Error 403):**
    ```json
    {
        "error": "Only admins can promote others"
    }
    ```
*   **Response Body (Error 404):**
    ```json
    {
        "error": "User with this email not found"
    }
    ```

#### `POST /api/team/demote`
*   **Description:** Demotes a team admin to a regular member.
*   **Authentication:** Required (must be an admin)
*   **Request Body:**
    ```json
    {
        "targetUserEmail": "string (email of the user to demote)"
    }
    ```
*   **Response Body (Success 200):**
    ```json
    {
        "message": "User demoted from admin successfully"
    }
    ```
*   **Response Body (Error 400):**
    ```json
    {
        "error": "Error message"
    }
    ```
*   **Response Body (Error 403):**
    ```json
    {
        "error": "Only admins can perform this action"
    }
    ```
*   **Response Body (Error 404):**
    ```json
    {
        "error": "Target user not found"
    }
    ```

---

### 7. XP & Solved Problems

#### `GET /api/xp/user`
*   **Description:** Retrieves the authenticated user's total XP and recent solved problems.
*   **Authentication:** Required
*   **Response Body (Success 200):**
    ```json
    {
        "success": true,
        "data": {
            "userId": "number",
            "totalXP": "number",
            "solvedProblems": "number (count)",
            "recentSolves": [
                {
                    "problem_id": "string",
                    "title": "string",
                    "difficulty": "string",
                    "xp_earned": "number",
                    "solved_at": "string (ISO date)"
                }
            ]
        }
    }
    ```

#### `GET /api/xp/solved-problems`
*   **Description:** Retrieves a list of all problems solved by the authenticated user, including a breakdown by difficulty.
*   **Authentication:** Required
*   **Response Body (Success 200):**
    ```json
    {
        "success": true,
        "data": {
            "solvedProblems": [
                {
                    "problem_id": "string",
                    "title": "string",
                    "difficulty": "string",
                    "xp_earned": "number",
                    "solved_at": "string (ISO date)"
                }
            ],
            "totalSolved": "number",
            "difficultyBreakdown": {
                "easy": "number",
                "medium": "number",
                "hard": "number"
            }
        }
    }
    ```

#### `GET /api/xp/problem/:problemId/solved`
*   **Description:** Checks if a specific problem has been solved by the authenticated user and provides details if solved.
*   **Authentication:** Required
*   **Parameters:**
    *   `problemId`: `string` (Path parameter) - The ID of the problem to check.
*   **Response Body (Success 200):**
    ```json
    {
        "success": true,
        "data": {
            "problemId": "string",
            "isSolved": "boolean",
            "solvedDetails": {
                "problem_id": "string",
                "title": "string",
                "difficulty": "string",
                "xp_earned": "number",
                "solved_at": "string (ISO date)"
            } | null
        }
    }
    ```

---

### 8. Admin Endpoints

#### `DELETE /api/admin/delete-user/:userId`
*   **Description:** Deletes all data associated with a specific user ID. This is a destructive operation.
*   **Authentication:** None (Assumed to be an admin-only endpoint, but no middleware shown in route file)
*   **Parameters:**
    *   `userId`: `number` (Path parameter) - The ID of the user to delete.
*   **Response Body (Success 200):**
    ```json
    {
        "message": "All data for user ID X has been deleted."
    }
    ```
*   **Response Body (Error 400):**
    ```json
    {
        "error": "Invalid user ID"
    }
    ```

---

### 9. Analysis

#### `POST /api/analysis/complexity`
*   **Description:** Analyzes the complexity of provided code using an external service (OpenAI).
*   **Authentication:** None
*   **Request Body:**
    ```json
    {
        "code": "string",
        "language": "string",
        "submissionId": "string (optional)"
    }
    ```
*   **Response Body (Success 200):**
    ```json
    {
        "analysis": "string (the analysis result from OpenAI)"
    }
    ```

---

### 10. Health Checks & Seeding (Learning Materials)

#### `GET /api/health/debug`
*   **Description:** A simple debug endpoint.
*   **Authentication:** None
*   **Response Body (Success 200):**
    ```json
    {
        "status": "debug endpoint reached",
        "timestamp": "string (ISO date)"
    }
    ```

#### `GET /api/health/health`
*   **Description:** Checks the health of the server and database connection.
*   **Authentication:** None
*   **Response Body (Success 200):**
    ```json
    {
        "status": "healthy",
        "timestamp": "string (ISO date)",
        "services": {
            "database": "connected",
            "server": "running"
        }
    }
    ```
*   **Response Body (Error 503):**
    ```json
    {
        "status": "unhealthy",
        "timestamp": "string (ISO date)",
        "error": "Error message"
    }
    ```

#### `POST /api/seed/seed-learning`
*   **Description:** Seeds learning materials (topics, questions, MCQs, code examples) from an uploaded ZIP file.
*   **Authentication:** None
*   **Request Body (multipart/form-data):**
    *   `zip`: `file` (The ZIP file containing learning materials)
*   **Response Body (Success 200):**
    ```json
    {
        "message": "Learning materials seeded successfully."
    }
    ```

#### `DELETE /api/seed/seed-learning`
*   **Description:** Deletes all learning materials (topics, questions, MCQs, code examples) from the database.
*   **Authentication:** None
*   **Response Body (Success 200):**
    ```json
    {
        "message": "All learning materials deleted successfully."
    }
    ```
