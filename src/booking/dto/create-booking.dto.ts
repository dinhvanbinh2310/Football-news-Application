import { IsString, IsNumber, IsOptional } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateBookingDto {
    @IsString()
    merchandiseId: string;

    @Type(() => Number)
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
