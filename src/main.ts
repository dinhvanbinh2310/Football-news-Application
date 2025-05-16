import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as bodyParser from 'body-parser';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.use(bodyParser.json({ limit: '10mb' }));
  app.use(bodyParser.urlencoded({ extended: true, limit: '10mb' }));

  app.enableCors();
  await app.listen(process.env.PORT ?? 3000);
  console.log(`App running on: http://localhost:${process.env.PORT || 3000}`);
}
bootstrap();
