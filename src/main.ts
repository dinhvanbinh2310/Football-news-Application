import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as bodyParser from 'body-parser';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.use(bodyParser.json()); // ✅ Xử lý JSON body
  app.use(bodyParser.urlencoded({ extended: true })); 

  app.enableCors();
  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
