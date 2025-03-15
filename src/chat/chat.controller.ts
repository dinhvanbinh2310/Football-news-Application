import { Controller, Post, Body } from '@nestjs/common';
import { ChatService } from './chat.service';

@Controller('chat')
export class ChatController {
  constructor(private readonly huggingFaceService: ChatService) {}

  @Post('ask')
  async generateText(@Body('prompt') prompt: string) {
    return this.huggingFaceService.generateText(prompt);
  }
}
