import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';
import { Product } from 'src/product/schemas/product.schema';

@Schema()
export class Invoice extends Document {
  @Prop({ required: true, type: Types.ObjectId, ref: 'User' })
  userId: Types.ObjectId;

  @Prop({
    type: [
      {
        productId: { type: Types.ObjectId, ref: 'Product', required: true },
        quantity: { type: Number, required: true },
        price: { type: Number, required: true }, 
      },
    ],
    required: true,
  })
  items: { productId: Types.ObjectId; quantity: number; price: number }[];

  @Prop({ required: true })
  totalAmount: number;

  @Prop({ default: 'pending' }) // pending, completed, cancelled
  status: string;

  @Prop({ default: Date.now })
  createdAt: Date;
}

export const InvoiceSchema = SchemaFactory.createForClass(Invoice);
