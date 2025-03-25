import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Invoice } from './schemas/invoice.schema';
import { Product } from 'src/product/schemas/product.schema';
import { CreateInvoiceDto } from './dto/create-invoice.dto';

@Injectable()
export class InvoiceService {
  constructor(
    @InjectModel(Invoice.name) private readonly invoiceModel: Model<Invoice>,
    @InjectModel(Product.name) private readonly productModel: Model<Product>,
  ) {}

  async createInvoice(createInvoiceDto: CreateInvoiceDto): Promise<Invoice> {
    const { userId, items, totalAmount } = createInvoiceDto;

    for (const item of items) {
      const product = await this.productModel.findById(item.productId);
      if (!product) {
        throw new NotFoundException(`Sản phẩm ${item.productId} không tồn tại`);
      }
      if (product.stock < item.quantity) {
        throw new BadRequestException(`Sản phẩm ${product.name} không đủ hàng`);
      }

      // 🚀 Giảm số lượng sản phẩm
      product.stock -= item.quantity;
      await product.save();
    }

    // Tạo hóa đơn
    const newInvoice = new this.invoiceModel({
      userId: new Types.ObjectId(userId),
      items,
      totalAmount,
      status: 'completed',
    });

    return newInvoice.save();
  }
}
