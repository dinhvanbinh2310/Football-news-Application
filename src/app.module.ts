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
@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,  // Giúp các module khác sử dụng được biến môi trường
    }),
    MongooseModule.forRoot('mongodb://localhost:27017/football-ticketing'),
    TicketModule,
    UserModule,
    AuthModule,
    MatchModule,
    OrderModule,
  ],
    providers: [AppService],
    controllers: [AppController],
})
export class AppModule {}
