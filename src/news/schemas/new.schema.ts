import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

@Schema()
export class New extends Document {
  
}

export const NewSchema = SchemaFactory.createForClass(New);


// Lam trang tin tuc, them tim kiem san pham, 