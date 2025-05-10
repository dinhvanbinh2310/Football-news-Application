import { IsString, IsNumber, IsArray, IsBoolean, IsOptional } from 'class-validator';

export class CreateMerchandiseDto {
    @IsString()
    name: string;

    @IsString()
    description: string;

    @IsNumber()
    price: number;

    @IsArray()
    @IsString({ each: true })
    size: string[];

    @IsArray()
    @IsString({ each: true })
    color: string[];

    @IsString()
    category: string;

    @IsNumber()
    stock: number;

    @IsArray()
    @IsString({ each: true })
    image: string[];

    @IsBoolean()
    @IsOptional()
    isAvailable?: boolean;
} 