import { BadRequestException, Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcryptjs';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User, UserDocument } from '../user/schemas/user.schema';
import { LoginUserDto } from './dto/login-user.dto';
import * as nodemailer from 'nodemailer';


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

  async resetPassword(email: string, resetCode: string, newPassword: string) {
    const user = await this.userModel.findOne({ email });
  
    if (!user || !user.resetExpires?.getTime() || user.resetCode !== resetCode || user.resetExpires.getTime() < Date.now()) {
      throw new BadRequestException('Mã xác nhận không hợp lệ hoặc đã hết hạn');
    }
  
    // Hash mật khẩu mới
    const hashedPassword = await bcrypt.hash(newPassword, 10);
    user.password = hashedPassword;
  
    // Xóa mã xác nhận sau khi sử dụng
    user.resetCode = undefined;
    user.resetExpires = undefined;
  
    await user.save();
  
    return { message: 'Mật khẩu đã được cập nhật thành công' };
  }
  

  async sendResetPasswordEmail(email: string) {
    const user = await this.userModel.findOne({ email });

    if (!user) {
      throw new BadRequestException('Email không tồn tại trong hệ thống');
    }

    // Tạo mã xác nhận (6 số)
    const resetCode = Math.floor(100000 + Math.random() * 900000).toString();

    // Lưu mã vào database (thêm trường resetCode và resetExpires nếu chưa có)
    user.resetCode = resetCode;
    user.resetExpires = new Date(Date.now() + 15 * 60 * 1000); // Hết hạn sau 15 phút
    await user.save();

    // Cấu hình gửi email
    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
      },
    });

    const mailOptions = {
      from: process.env.EMAIL_USER,
      to: user.email,
      subject: 'Mã xác nhận đặt lại mật khẩu',
      text: `Mã xác nhận của bạn là: ${resetCode}. Mã này sẽ hết hạn sau 15 phút.`,
    };

    await transporter.sendMail(mailOptions);

    return { message: 'Mã xác nhận đã được gửi đến email của bạn' };
  }

}
