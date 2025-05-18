export class CreateProductDto {
    name: string;
    price: number;
    description?: string;
    imageUrl?: string;
    status?: string;
  }