import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Booking, BookingDocument } from './schemas/booking.schema';
import { CreateBookingDto } from './dto/create-booking.dto';
import { MerchandiseService } from '../merchandise/merchandise.service';

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
            throw new NotFoundException('Sản phẩm không tồn tại');
        }

        // Kiểm tra size và color có hợp lệ
        if (!merchandise.size.includes(size)) {
            throw new BadRequestException('Size không hợp lệ');
        }
        if (!merchandise.color.includes(color)) {
            throw new BadRequestException('Màu sắc không hợp lệ');
        }

        // Kiểm tra số lượng tồn kho
        if (merchandise.stock < quantity) {
            throw new BadRequestException('Số lượng sản phẩm không đủ');
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
            // Hoàn trả số lượng tồn kho
            await this.merchandiseService.updateStock(
                booking.merchandise.toString(),
                -booking.quantity
            );
        }

        booking.status = status;
        return booking.save();
    }
} 