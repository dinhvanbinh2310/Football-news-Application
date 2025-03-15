import { Injectable } from '@nestjs/common';
import { HfInference } from '@huggingface/inference';
import * as dotenv from 'dotenv';

dotenv.config();

@Injectable()
export class ChatService {
  private hf: HfInference;

  constructor() {
    this.hf = new HfInference(process.env.HUGGING_FACE_API_TOKEN);
  }

  async generateText(prompt: string): Promise<string> {
    try {
      const response = await this.hf.textGeneration({
        model: 'microsoft/Phi-3.5-mini-instruct', // Model chuyên tiếng Việt
        inputs: prompt,
        parameters: { max_new_tokens: 100, temperature: 0.1  },
      });

      return response.generated_text;
    } catch (error) {
      console.error('Error generating text:', error);
      throw new Error('Failed to generate text');
    }
  }
}
