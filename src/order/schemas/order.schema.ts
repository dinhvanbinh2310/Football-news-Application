import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { User } from '../../user/schemas/user.schema';
import { Ticket } from '../../ticket/schemas/ticket.schema';

export type OrderDocument = HydratedDocument<Order>;

@Schema({ timestamps: true })
export class Order {
  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  user: User;

  @Prop([{ type: Types.ObjectId, ref: 'Ticket', required: true }])
  tickets: Ticket[];

  @Prop({ required: true })
  totalAmount: number;

  @Prop({ default: 'pending' })  // pending, paid, cancelled
  status: string;
}

export const OrderSchema = SchemaFactory.createForClass(Order);
