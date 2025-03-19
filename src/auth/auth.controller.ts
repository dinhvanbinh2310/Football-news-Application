import { BadRequestException, Body, Controller, Post, Req, Request, UnauthorizedException, UseGuards } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthGuard } from '@nestjs/passport';
import * as bcrypt from 'bcryptjs';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User } from '../user/schemas/user.schema';


@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService,
    @InjectModel(User.name) private readonly userModel: Model<User>, 
  ) {}

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

  @Post('forgot-password')
  async sendResetPasswordEmail(@Body() body: { email: string }) {
    return this.authService.sendResetPasswordEmail(body.email);
  }

  @Post('reset-password')
  async resetPassword(@Body() body) {
    const { email, resetCode, newPassword } = body;

    // Tìm user theo email và mã xác thực
    const user = await this.userModel.findOne({ email, resetCode });

    if (!user || !user.resetExpires || new Date(user.resetExpires).getTime() < Date.now()) {
      throw new BadRequestException('Mã xác thực không hợp lệ hoặc đã hết hạn');
    }

    // Cập nhật mật khẩu mới
    user.password = await bcrypt.hash(newPassword, 10);
    user.resetCode = undefined;
    user.resetExpires = undefined;
    await user.save();

    return { message: 'Mật khẩu đã được đặt lại thành công' };
  }

  
}
