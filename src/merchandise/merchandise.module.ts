import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { MerchandiseService } from './merchandise.service';
import { MerchandiseController } from './merchandise.controller';
import { Merchandise, MerchandiseSchema } from './schemas/merchandise.schema';

@Module({
    imports: [
        MongooseModule.forFeature([{ name: Merchandise.name, schema: MerchandiseSchema }])
    ],
    controllers: [MerchandiseController],
    providers: [MerchandiseService],
    exports: [MerchandiseService]
})
export class MerchandiseModule { } 