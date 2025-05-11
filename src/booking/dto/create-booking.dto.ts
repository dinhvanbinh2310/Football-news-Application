import { IsString, IsNumber, IsEnum, IsOptional } from 'class-validator';

export class CreateBookingDto {
    @IsString()
    merchandiseId: string;

    @IsNumber()
    quantity: number;

    @IsString()
    size: string;

    @IsString()
    color: string;

    @IsString()
    shippingAddress: string;

    @IsString()
    phoneNumber: string;

    @IsString()
    @IsOptional()
    note?: string;
} 