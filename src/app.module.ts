import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { MongooseModule } from '@nestjs/mongoose';
import { TicketModule } from './ticket/ticket.module';
import { UserModule } from './user/user.module';
import { AuthModule } from './auth/auth.module';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MatchModule } from './match/match.module';
import { OrderModule } from './order/order.module';
import { ChatModule } from './chat/chat.module';
import { ProductModule } from './product/product.module';
import { CartModule } from './cart/cart.module';
import { InvoiceModule } from './invoice/invoice.module';
@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,  // Giúp các module khác sử dụng được biến môi trường
    }),
    MongooseModule.forRoot(process.env.MONGODB_URI || 'mongodb://localhost:27017/football-ticketing'),
    TicketModule,
    UserModule,
    AuthModule,
    MatchModule,
    OrderModule,
    ChatModule,
    ProductModule,
    CartModule,
    InvoiceModule,
  ],
    providers: [AppService],
    controllers: [AppController],
})
export class AppModule {}
