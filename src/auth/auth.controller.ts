import { BadRequestException, Body, Controller, Post, Req, Request, UnauthorizedException, UseGuards } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthGuard } from '@nestjs/passport';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  async register(@Body() body: { email: string; password: string }) {
    return this.authService.register(body.email, body.password);
  }

  @UseGuards(AuthGuard('local')) // Dùng LocalStrategy để kiểm tra đăng nhập
  @Post('login')
  async login(@Request() req) {
    return this.authService.login(req.user); // Trả về token sau khi xác thực thành công
  }

  @UseGuards(AuthGuard('jwt')) // Bảo vệ route bằng JWT
  @Post('update-password')
  async updatePassword(@Req() req: Request & { user?: any }, @Body() body: any) {
  
    const userId = req.user['userId']; // Lấy userId từ token
    const { oldPassword, newPassword } = body;

    return await this.authService.updatePassword(userId, oldPassword, newPassword);
  }
}
