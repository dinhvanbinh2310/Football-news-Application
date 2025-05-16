import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import * as bcrypt from 'bcryptjs';
import { User, UserDocument } from './schemas/user.schema';
import { CreateUserDto } from './dto/create-user.dto';

@Injectable()
export class UserService {
  constructor(
    @InjectModel(User.name) private userModel: Model<UserDocument>,
  ) { }

  async createUser(createUserDto: CreateUserDto): Promise<User> {
    const { email, password, fullName } = createUserDto;

    // Kiểm tra email đã tồn tại chưa
    const existingUser = await this.userModel.findOne({ email });
    if (existingUser) {
      throw new BadRequestException('Email đã được sử dụng');
    }

    // Mã hóa password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Tạo tài khoản mới
    const newUser = new this.userModel({
      email,
      password: hashedPassword,
      fullName,
    });

    return newUser.save();
  }

  async createAdmin(email: string, password: string) {
    const adminExists = await this.userModel.findOne({ email });
    if (adminExists) {
      throw new Error('Admin already exists');
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const admin = new this.userModel({ email, password: hashedPassword, role: 'admin' });
    await admin.save();
    return { message: 'Admin created successfully' };
  }

  async updateUserRole(userId: string, newRole: 'admin' | 'user') {
    const user = await this.userModel.findById(userId);
    if (!user) {
      throw new NotFoundException('User not found');
    }

    user.role = newRole;
    await user.save();

    return {
      message: `User role updated to ${newRole}`,
      user: {
        id: user._id,
        email: user.email,
        role: user.role
      }
    };
  }
  async findAllUsers(): Promise<User[]> {
    return this.userModel.find().select('-password'); // ẩn password
  }
  async deleteUser(id: string): Promise<any> {
    const user = await this.userModel.findByIdAndDelete(id);
    if (!user) {
      throw new NotFoundException('Người dùng không tồn tại');
    }
    return { message: 'Xóa thành công' };
  }

}
