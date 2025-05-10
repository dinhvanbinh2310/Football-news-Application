import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type MerchandiseDocument = Merchandise & Document;

@Schema({ timestamps: true })
export class Merchandise {
    @Prop({ required: true })
    name: string;

    @Prop({ required: true })
    description: string;

    @Prop({ required: true })
    price: number;

    @Prop({ required: true })
    size: string[];

    @Prop({ required: true })
    color: string[];

    @Prop({ required: true })
    category: string;

    @Prop({ required: true })
    stock: number;

    @Prop({ required: true })
    image: string[];

    @Prop({ default: true })
    isAvailable: boolean;
}

export const MerchandiseSchema = SchemaFactory.createForClass(Merchandise); 