import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor(private configService: ConfigService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKey: configService.get<string>('JWT_SECRET') || 'my_super_secret_key', // Thay bằng biến môi trường thực tế
    });
  }

  async validate(payload: any) {
    return { userId: payload.sub, email: payload.email, role: payload.role }; // Trả về user để gán vào request.user
  }
}
