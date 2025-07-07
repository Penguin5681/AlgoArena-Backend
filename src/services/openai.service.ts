import OpenAI from 'openai';

export class OpenAIService {
  private readonly openai: OpenAI;
  private readonly model: string;

  constructor() {
    this.openai = new OpenAI({
      apiKey: process.env.OPENAI_API_KEY,
    });
    this.model = process.env.OPENAI_MODEL || 'gpt-4o-mini'; 
  }

  async analyzeComplexity(code: string, language: string): Promise<string> {
    try {
      const prompt = this.generatePrompt(code, language);

      const response = await this.openai.chat.completions.create({
        model: this.model,
        messages: [
          {
            role: 'system',
            content: 'You are a code complexity analyzer. Provide brief, accurate time and space complexity analysis.'
          },
          {
            role: 'user',
            content: prompt
          }
        ],
        max_tokens: 200,
        temperature: 0.1,
      });

      return response.choices[0]?.message?.content || 'Analysis not available';
    } catch (error) {
      console.error('Error analyzing code complexity:', error);
      throw new Error('Failed to analyze code complexity');
    }
  }

  private generatePrompt(code: string, language: string): string {
    return `
Analyze the following ${language} code and provide a brief analysis of its time and space complexity.
Focus only on big O notation with a very concise explanation.

CODE:
\`\`\`${language}
${code}
\`\`\`

Provide your analysis in this format:
Time Complexity: O(?)
Explanation: (brief explanation)

Space Complexity: O(?)
Explanation: (brief explanation)
`;
  }
}

export default new OpenAIService();