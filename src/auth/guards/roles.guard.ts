import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Request } from 'express';

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRole = this.reflector.get<string>('role', context.getHandler());
    if (!requiredRole) return true;

    const request = context.switchToHttp().getRequest<Request & { user?: any }>(); // Ép kiểu cho request
    const user = request.user; // Lấy từ JWT token

    return user?.role === requiredRole;
  }
}
