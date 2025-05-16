import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Booking, BookingDocument } from './schemas/booking.schema';
import { CreateBookingDto } from './dto/create-booking.dto';
import { MerchandiseService } from '../merchandise/merchandise.service';
import { InternalServerErrorException } from '@nestjs/common';


@Injectable()
export class BookingService {
    constructor(
        @InjectModel(Booking.name) private bookingModel: Model<BookingDocument>,
        private merchandiseService: MerchandiseService,
    ) { }

    async create(userId: string, createBookingDto: CreateBookingDto): Promise<Booking> {
        const { merchandiseId, quantity, size, color } = createBookingDto;

        // Kiểm tra sản phẩm tồn tại
        const merchandise = await this.merchandiseService.findById(merchandiseId);
        if (!merchandise) {
            console.log('Merchandise not found');
            throw new NotFoundException('Sản phẩm không tồn tại');
        }



        // Tính tổng tiền
        const totalPrice = merchandise.price * quantity;

        // Tạo booking mới
        const newBooking = new this.bookingModel({
            user: userId,
            merchandise: merchandiseId,
            quantity,
            size,
            color,
            totalPrice,
            shippingAddress: createBookingDto.shippingAddress,
            phoneNumber: createBookingDto.phoneNumber,
            note: createBookingDto.note,
        });

        // Cập nhật số lượng tồn kho
        await this.merchandiseService.updateStock(merchandiseId, quantity);

        return newBooking.save();
    }

    async findAll(): Promise<Booking[]> {
        return this.bookingModel
            .find()
            .populate('user', 'email fullName')
            .populate('merchandise', 'name price')
            .exec();
    }

    async findById(id: string): Promise<BookingDocument> {
        const booking = await this.bookingModel
            .findById(id)
            .populate('user', 'email fullName')
            .populate('merchandise', 'name price')
            .exec();

        if (!booking) {
            throw new NotFoundException('Booking không tồn tại');
        }

        return booking;
    }

    async findByUser(userId: string): Promise<Booking[]> {
        return this.bookingModel
            .find({ user: userId })
            .populate('merchandise', 'name price')
            .exec();
    }

    async updateStatus(id: string, status: 'confirmed' | 'cancelled' | 'completed'): Promise<Booking> {
        const booking = await this.findById(id);

        if (booking.status === 'cancelled') {
            throw new BadRequestException('Không thể cập nhật trạng thái của booking đã hủy');
        }

        if (status === 'cancelled') {
            const merchId =
                typeof booking.merchandise === 'string'
                    ? booking.merchandise
                    : booking.merchandise?._id?.toString(); // ✅ gọi hàm đầy đủ

            if (!merchId) {
                throw new InternalServerErrorException('Không tìm thấy ID sản phẩm để hoàn trả hàng');
            }

            await this.merchandiseService.updateStock(merchId, -booking.quantity);
        }


        booking.status = status;
        return booking.save();
    }
} 