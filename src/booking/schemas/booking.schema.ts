import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Schema as MongooseSchema } from 'mongoose';
import { User } from '../../user/schemas/user.schema';
import { Merchandise } from '../../merchandise/schemas/merchandise.schema';

export type BookingDocument = Booking & Document;

@Schema({ timestamps: true })
export class Booking {
    @Prop({ type: MongooseSchema.Types.ObjectId, ref: 'User', required: true })
    user: User;

    @Prop({ type: MongooseSchema.Types.ObjectId, ref: 'Merchandise', required: true })
    merchandise: Merchandise;

    @Prop({ required: true })
    quantity: number;

    @Prop({ required: true })
    size: string;

    @Prop({ required: true })
    color: string;

    @Prop({ required: true })
    totalPrice: number;

    @Prop({ default: 'pending' })
    status: 'pending' | 'confirmed' | 'cancelled' | 'completed';

    @Prop()
    shippingAddress: string;

    @Prop()
    phoneNumber: string;

    @Prop()
    note: string;
}

export const BookingSchema = SchemaFactory.createForClass(Booking); 