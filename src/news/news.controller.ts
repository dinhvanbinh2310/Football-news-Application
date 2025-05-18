import { Controller, Get, Post, Body, Param, Put, Delete } from '@nestjs/common';
import { NewsService } from './news.service';
import { CreateNewsDto } from './dto/create-new.dto';
import { UpdateNewsDto } from './dto/update-new.dto';
import { News } from './schemas/new.schema';

@Controller('news')
export class NewsController {
  constructor(private readonly newsService: NewsService) {}

  // Tạo mới bài viết
  @Post()
  create(@Body() createNewsDto: CreateNewsDto): Promise<News> {
    return this.newsService.create(createNewsDto);
  }

  // Lấy tất cả bài viết
  @Get()
  findAll(): Promise<News[]> {
    return this.newsService.findAll();
  }

  // Lấy bài viết theo ID
  @Get(':id')
  findOne(@Param('id') id: string): Promise<News> {
    return this.newsService.findOne(id);
  }

  // Cập nhật bài viết
  @Put(':id')
  update(
    @Param('id') id: string,
    @Body() updateNewsDto: UpdateNewsDto,
  ): Promise<News> {
    return this.newsService.update(id, updateNewsDto);
  }

  // Xóa bài viết
  @Delete(':id')
  remove(@Param('id') id: string): Promise<void> {
    return this.newsService.remove(id);
  }
}
