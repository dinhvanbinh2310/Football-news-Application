import { Injectable, BadRequestException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import * as bcrypt from 'bcryptjs';
import { User, UserDocument } from './schemas/user.schema';
import { CreateUserDto } from './dto/create-user.dto';

@Injectable()
export class UserService {
  constructor(
    @InjectModel(User.name) private userModel: Model<UserDocument>,
  ) {}

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
}
