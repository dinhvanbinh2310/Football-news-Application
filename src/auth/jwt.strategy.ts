import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKey: process.env.JWT_SECRET || 'your_secret_key', // Thay bằng biến môi trường thực tế
    });
  }

  async validate(payload: any) {
    return { userId: payload.sub, email: payload.email, role: payload.role }; // Trả về user để gán vào request.user
  }
}
