import { Controller, Post, Body, UseGuards, SetMetadata } from '@nestjs/common';
import { UserService } from './user.service';
import { CreateUserDto } from './dto/create-user.dto';
import { RolesGuard } from '../auth/guards/roles.guard';
import { AuthGuard } from '@nestjs/passport';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Post('register')
  async register(@Body() createUserDto: CreateUserDto) {
    return this.userService.createUser(createUserDto);
  }
  @Post('create-admin')
  // @UseGuards(AuthGuard('jwt'), RolesGuard) // Bắt buộc đăng nhập và kiểm tra quyền
  // @SetMetadata('role', 'admin')           // Chỉ cho phép admin thực hiện
async createAdmin(@Body() body: { email: string; password: string }) {
  return this.userService.createAdmin(body.email, body.password);
}

}
