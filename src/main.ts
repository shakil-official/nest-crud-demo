import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

import * as dotenv from 'dotenv';

dotenv.config(); // <-- load .env variables

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  console.log(process.env.PORT , "env");
  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
