import { IsNotEmpty, IsArray, IsNumber, IsMongoId } from 'class-validator';

export class CreateInvoiceDto {
  @IsMongoId()
  @IsNotEmpty()
  userId: string;

  @IsArray()
  items: { productId: string; quantity: number; price: number }[];

  @IsNumber()
  @IsNotEmpty()
  totalAmount: number;
}
