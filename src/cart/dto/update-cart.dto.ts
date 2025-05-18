import { IsNotEmpty, IsMongoId, IsNumber } from 'class-validator';

export class UpdateCartDto {
  @IsMongoId()
  @IsNotEmpty()
  productId: string;

  @IsNumber()
  @IsNotEmpty()
  quantity: number;
}
