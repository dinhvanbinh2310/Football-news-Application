import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { News } from './schemas/new.schema';
import { CreateNewsDto } from './dto/create-new.dto';
import { UpdateNewsDto } from './dto/update-new.dto';

@Injectable()
export class NewsService {
  constructor(@InjectModel(News.name) private newsModel: Model<News>) {}

  // Tạo mới bài viết
  async create(createNewsDto: CreateNewsDto): Promise<News> {
    const createdNews = new this.newsModel(createNewsDto);
    return createdNews.save();
  }

  // Lấy tất cả bài viết
  async findAll(): Promise<News[]> {
    return this.newsModel.find().exec();
  }

  // Lấy bài viết theo ID
  async findOne(id: string): Promise<News> {
    const news = await this.newsModel.findById(id).exec();
    if (!news) {
      throw new NotFoundException(`News with id ${id} not found`);
    }
    return news;
  }

  // Cập nhật bài viết
  async update(id: string, updateNewsDto: UpdateNewsDto): Promise<News> {
    const updatedNews = await this.newsModel.findByIdAndUpdate(id, updateNewsDto, {
      new: true,
    }).exec();
    if (!updatedNews) {
      throw new NotFoundException(`News with id ${id} not found`);
    }
    return updatedNews;
  }

  // Xóa bài viết
  async remove(id: string): Promise<void> {
    const result = await this.newsModel.findByIdAndDelete(id).exec();
    if (!result) {
      throw new NotFoundException(`News with id ${id} not found`);
    }
  }
}
