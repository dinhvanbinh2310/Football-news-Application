import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Order, OrderDocument } from './schemas/order.schema';

@Injectable()
export class OrderService {
  constructor(@InjectModel(Order.name) private orderModel: Model<OrderDocument>) {}

  async create(orderData: Partial<Order>): Promise<Order> {
    const order = new this.orderModel(orderData);
    return order.save();
  }

  async findAll(): Promise<Order[]> {
    return this.orderModel.find().populate('user tickets').exec();
  }

  async findById(id: string): Promise<Order | null> {
    return this.orderModel.findById(id).populate('user tickets').exec();
  }

  async update(id: string, updateData: Partial<Order>): Promise<Order | null> {
    return this.orderModel.findByIdAndUpdate(id, updateData, { new: true }).exec();
  }

  async delete(id: string): Promise<Order | null> {
    return this.orderModel.findByIdAndDelete(id).exec();
  }
}
