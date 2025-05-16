import { PartialType } from '@nestjs/mapped-types';
import { CreateNewsDto } from './create-new.dto';

export class UpdateNewsDto extends PartialType(CreateNewsDto) {}
