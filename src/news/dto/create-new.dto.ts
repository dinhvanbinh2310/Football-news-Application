import { IsString, IsOptional, IsArray, IsBoolean } from 'class-validator';

export class CreateNewsDto {
  @IsString()
  title: string;

  @IsString()
  content: string;

  @IsOptional()
  @IsString()
  imageUrl?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  category?: string[];

}
