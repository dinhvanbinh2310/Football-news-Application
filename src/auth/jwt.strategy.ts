import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor(private configService: ConfigService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKey: configService.get<string>('JWT_SECRET', 'my_super_secret_key'), 
    });
  
    if (!configService.get<string>('JWT_SECRET')) {
      console.warn('⚠️ Warning: JWT_SECRET is missing. Using default secret!');
    }
  }
  

  async validate(payload: any) {
    const userId = payload.sub || payload._id; 
  
    if (!userId) {
      throw new UnauthorizedException('Invalid token');
    }
  
    return { userId, email: payload.email, role: payload.role };
  }
}
