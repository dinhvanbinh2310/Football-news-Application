import { Controller, Post, Body, UseGuards, SetMetadata, Put, Param } from '@nestjs/common';
import { UserService } from './user.service';
import { CreateUserDto } from './dto/create-user.dto';
import { RolesGuard } from '../auth/guards/roles.guard';
import { AuthGuard } from '@nestjs/passport';
import { Roles } from '../auth/decorators/roles.decorator';
import { Get, Delete } from '@nestjs/common';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) { }

  @Post('register')
  async register(@Body() createUserDto: CreateUserDto) {
    return this.userService.createUser(createUserDto);
  }

  @Post('create-admin')
  @UseGuards(AuthGuard('jwt'), RolesGuard)
  @Roles('admin')
  async createAdmin(@Body() body: { email: string; password: string }) {
    return this.userService.createAdmin(body.email, body.password);
  }

  @Put(':id/role')
  @UseGuards(AuthGuard('jwt'), RolesGuard)
  @Roles('admin')
  async updateUserRole(
    @Param('id') id: string,
    @Body() body: { role: 'admin' | 'user' }
  ) {
    return this.userService.updateUserRole(id, body.role);
  }
  @Get()
  @UseGuards(AuthGuard('jwt'), RolesGuard)
  @Roles('admin')
  async getAllUsers() {
    console.log('GET /user hit');
    return this.userService.findAllUsers();
  }
  @Delete(':id')
  @UseGuards(AuthGuard('jwt'), RolesGuard)
  @Roles('admin') // nếu chỉ admin mới được xoá
  async deleteUser(@Param('id') id: string) {
    return this.userService.deleteUser(id);
  }
}

