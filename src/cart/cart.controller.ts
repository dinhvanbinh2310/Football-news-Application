import { Controller, Post, Get, Patch, Delete, Body, Param } from '@nestjs/common';
import { CartService } from './cart.service';
import { CreateCartDto } from './dto/create-cart.dto';
import { UpdateCartDto } from './dto/update-cart.dto';

@Controller('cart')
export class CartController {
  constructor(private readonly cartService: CartService) {}

  @Post()
  async createCart(@Body() createCartDto: CreateCartDto) {
    return this.cartService.createCart(createCartDto);
  }

  @Get(':userId')
  async getCart(@Param('userId') userId: string) {
    return this.cartService.getCart(userId);
  }

  @Patch(':userId')
  async updateCart(@Param('userId') userId: string, @Body() updateCartDto: UpdateCartDto) {
    return this.cartService.updateCart(userId, updateCartDto);
  }

  @Delete(':userId/:productId')
  async removeItem(@Param('userId') userId: string, @Param('productId') productId: string) {
    return this.cartService.removeItem(userId, productId);
  }
}
