import { Controller, Get, Post, Body, Param, Put, UseGuards, Request } from '@nestjs/common';
import { BookingService } from './booking.service';
import { CreateBookingDto } from './dto/create-booking.dto';
import { AuthGuard } from '@nestjs/passport';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';

@Controller('bookings')
@UseGuards(AuthGuard('jwt'))
export class BookingController {
    constructor(private readonly bookingService: BookingService) { }

    @Post()
    create(@Request() req, @Body() createBookingDto: CreateBookingDto) {
        console.log('Received booking:', createBookingDto); // 🪵 debug
        return this.bookingService.create(req.user.userId, createBookingDto);
    }

    @Get()
    @UseGuards(RolesGuard)
    @Roles('admin')
    findAll() {
        return this.bookingService.findAll();
    }

    @Get('my-bookings')
    findMyBookings(@Request() req) {
        return this.bookingService.findByUser(req.user.userId);
    }

    @Get(':id')
    findOne(@Param('id') id: string) {
        return this.bookingService.findById(id);
    }

    @Put(':id/status')
    @UseGuards(RolesGuard)
    @Roles('admin')
    updateStatus(
        @Param('id') id: string,
        @Body('status') status: 'confirmed' | 'cancelled' | 'completed',
    ) {
        return this.bookingService.updateStatus(id, status);
    }
} 