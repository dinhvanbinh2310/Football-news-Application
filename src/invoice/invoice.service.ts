import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Invoice } from './schemas/invoice.schema';
import { Product } from '../product/schemas/product.schema';
import { CreateInvoiceDto } from './dto/create-invoice.dto';

@Injectable()
export class InvoiceService {
  constructor(
    @InjectModel(Invoice.name) private readonly invoiceModel: Model<Invoice>,
    @InjectModel(Product.name) private readonly productModel: Model<Product>,
  ) {}

  async createInvoice(createInvoiceDto: CreateInvoiceDto): Promise<Invoice> {
    const { userId, items } = createInvoiceDto;

    // Lấy giá sản phẩm từ database
    const itemsWithPrice = await Promise.all(
      items.map(async (item) => {
        const product = await this.productModel.findById(item.productId);
        if (!product) throw new NotFoundException(`Không tìm thấy sản phẩm ${item.productId}`);
        
        return {
          productId: item.productId,
          quantity: item.quantity,
          price: product.price, 
        };
      }),
    );

    const totalAmount = itemsWithPrice.reduce((sum, item) => sum + item.quantity * item.price, 0);

    const invoice = new this.invoiceModel({
      userId,
      items: itemsWithPrice,
      totalAmount,
    });

    return invoice.save();
  }
}
