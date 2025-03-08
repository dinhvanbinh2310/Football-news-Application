import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy } from 'passport-local';
import { AuthService } from './auth.service';
import { User } from '../user/schemas/user.schema';

@Injectable()
export class LocalStrategy extends PassportStrategy(Strategy) {
  constructor(private authService: AuthService) {
    super({ usernameField: 'email' }); // Xác thực bằng email
  }

  async validate(email: string, password: string): Promise<User> {
    console.log(`🟢 Đang validate user: email=${email}, password=${password}`);
    const user = await this.authService.validateUser(email, password);
    if (!user) {
      console.log(`🔴 Sai mật khẩu hoặc tài khoản`);
      throw new UnauthorizedException('Invalid credentials');
    }
    console.log(`✅ User hợp lệ: `, user);
    return user;
  }
}
