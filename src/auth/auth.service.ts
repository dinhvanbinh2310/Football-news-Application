import { BadRequestException, Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcryptjs';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User, UserDocument } from '../user/schemas/user.schema';
import { LoginUserDto } from './dto/login-user.dto';
@Injectable()
export class AuthService {
  constructor(
    @InjectModel(User.name) private userModel: Model<UserDocument>,
    private jwtService: JwtService,
    private configService: ConfigService,
  ) {}

  async register(email: string, password: string) {
    const existingUser = await this.userModel.findOne({ email });
    if (existingUser) {
      throw new BadRequestException('Email đã được sử dụng');
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = new this.userModel({ email, password: hashedPassword });
    await newUser.save();

    return { message: 'Đăng ký thành công' };
  }

  async validateUser(email: string, password: string): Promise<User> {
    const user = await this.userModel.findOne({ email });
    if (!user) {
      throw new UnauthorizedException('Tài khoản không tồn tại');
    }

    
    return user;
  }

  async login(loginUserDto: LoginUserDto) {
    const user = await this.validateUser(
      loginUserDto.email,
      loginUserDto.password,
    );

    const payload = { sub: user._id, email: user.email, role: user.role };
    const secret = this.configService.get<string>('JWT_SECRET');
    console.log("JWT_SECRET:", secret);

    return {
      access_token: this.jwtService.sign(payload),
    };
  }

  async updatePassword(userId: string, oldPassword: string, newPassword: string) {
    // Đảm bảo truy vấn đúng
    const user = await this.userModel.findById(userId);

    if (!user) {
        throw new UnauthorizedException('Người dùng không tồn tại');
    }

    // Log kiểm tra giá trị thực tế
    console.log("🔍 Mật khẩu nhập vào (sau trim):", `"${oldPassword.trim()}"`);
    console.log("🔍 Mật khẩu trong DB:", `"${user.password}"`);

    // Kiểm tra mật khẩu cũ
    const isMatch = await bcrypt.compare(oldPassword.trim(), user.password);
    console.log("✅ Kết quả bcrypt.compare:", isMatch);

    if (!isMatch) {
        throw new BadRequestException('Mật khẩu cũ không đúng');
    }

    // Hash mật khẩu mới trước khi lưu
    const hashedPassword = await bcrypt.hash(newPassword.trim(), 10);
    user.password = hashedPassword;

    await user.save();

    return { message: 'Mật khẩu đã được cập nhật thành công' };
}

}
