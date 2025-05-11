import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { BookingService } from './booking.service';
import { BookingController } from './booking.controller';
import { Booking, BookingSchema } from './schemas/booking.schema';
import { MerchandiseModule } from '../merchandise/merchandise.module';

@Module({
    imports: [
        MongooseModule.forFeature([{ name: Booking.name, schema: BookingSchema }]),
        MerchandiseModule,
    ],
    controllers: [BookingController],
    providers: [BookingService],
    exports: [BookingService],
})
export class BookingModule { } 