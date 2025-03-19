import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

export type UserDocument = HydratedDocument<User>;

@Schema({ timestamps: true })
export class User {
  _id: string;  // Thêm dòng này
  
  @Prop({ required: true, unique: true })
  email: string;

  @Prop({ required: true })
  password: string;

  @Prop()
  fullName: string;

  @Prop({ default: 'user' })  // Có thể là 'user' hoặc 'admin'
  role: string;

  @Prop()
  resetCode?: string; // Mã xác nhận đặt lại mật khẩu

  @Prop()
  resetExpires?: Date; // Thời gian hết hạn của mã xác nhận
}

export const UserSchema = SchemaFactory.createForClass(User);
