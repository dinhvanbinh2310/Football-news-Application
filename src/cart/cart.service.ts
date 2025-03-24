import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Cart } from './schemas/cart.schema';
import { CreateCartDto } from './dto/create-cart.dto';
import { UpdateCartDto } from './dto/update-cart.dto';

@Injectable()
export class CartService {
  constructor(@InjectModel(Cart.name) private readonly cartModel: Model<Cart>) {}

  async createCart(createCartDto: CreateCartDto): Promise<Cart> {
    const cart = new this.cartModel(createCartDto);
    return cart.save();
  }

  async getCart(userId: string): Promise<Cart> {
    const cart = await this.cartModel.findOne({ userId }).populate('items.productId');
    if (!cart) throw new NotFoundException('Giỏ hàng không tồn tại');
    return cart;
  }

  async updateCart(userId: string, updateCartDto: UpdateCartDto): Promise<Cart> {
    const cart = await this.cartModel.findOne({ userId: new Types.ObjectId(userId) });
    if (!cart) throw new NotFoundException('Giỏ hàng không tồn tại');
  
    const itemIndex = cart.items.findIndex(
      item => item.productId.toString() === updateCartDto.productId
    );
  
    if (itemIndex !== -1) {
      cart.items[itemIndex].quantity = updateCartDto.quantity;
    } else {
      cart.items.push({
        productId: new Types.ObjectId(updateCartDto.productId),
        quantity: updateCartDto.quantity,
      });
    }
  
    return cart.save();
  }

  async removeItem(userId: string, productId: string): Promise<Cart> {
    const cart = await this.cartModel.findOne({ userId: new Types.ObjectId(userId) });
    if (!cart) throw new NotFoundException('Giỏ hàng không tồn tại');
  
    cart.items = cart.items.filter(
      item => item.productId.toString() !== productId
    );
  
    return cart.save();
  }
}
