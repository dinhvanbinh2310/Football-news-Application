import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

export type TicketDocument = HydratedDocument<Ticket>;

@Schema({ timestamps: true })
export class Ticket {
  @Prop({ required: true })
  eventName: string;

  @Prop({ required: true })
  price: number;

  @Prop({ required: true })
  seat: string;

  @Prop({ default: 'available' })
  status: string;
}

export const TicketSchema = SchemaFactory.createForClass(Ticket);
