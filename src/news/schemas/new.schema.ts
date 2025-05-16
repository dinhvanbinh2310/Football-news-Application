// news.schema.ts
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

@Schema({ timestamps: true })
export class News extends Document {
  @Prop({ required: true })
  title: string;

  @Prop({ required: true })
  content: string;

  @Prop()
  imageUrl?: string;

  @Prop()
  description?: string;

  @Prop({ type: [String], default: [] })
  category: string[];

  @Prop({ default: Date.now })
  createdAt: Date;
}

export const NewsSchema = SchemaFactory.createForClass(News);
