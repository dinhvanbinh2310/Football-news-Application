import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Merchandise, MerchandiseDocument } from './schemas/merchandise.schema';
import { CreateMerchandiseDto } from './dto/create-merchandise.dto';

@Injectable()
export class MerchandiseService {
    constructor(
        @InjectModel(Merchandise.name) private merchandiseModel: Model<MerchandiseDocument>,
    ) { }

    async create(createMerchandiseDto: CreateMerchandiseDto): Promise<Merchandise> {
        const newMerchandise = new this.merchandiseModel(createMerchandiseDto);
        return newMerchandise.save();
    }

    async findAll(): Promise<Merchandise[]> {
        return this.merchandiseModel.find().exec();
    }

    async findById(id: string): Promise<Merchandise> {
        const merchandise = await this.merchandiseModel.findById(id).exec();
        if (!merchandise) {
            throw new NotFoundException(`Merchandise with ID ${id} not found`);
        }
        return merchandise;
    }

    async update(id: string, updateMerchandiseDto: Partial<CreateMerchandiseDto>): Promise<Merchandise> {
        const updatedMerchandise = await this.merchandiseModel
            .findByIdAndUpdate(id, updateMerchandiseDto, { new: true })
            .exec();
        if (!updatedMerchandise) {
            throw new NotFoundException(`Merchandise with ID ${id} not found`);
        }
        return updatedMerchandise;
    }

    async delete(id: string): Promise<void> {
        const result = await this.merchandiseModel.deleteOne({ _id: id }).exec();
        if (result.deletedCount === 0) {
            throw new NotFoundException(`Merchandise with ID ${id} not found`);
        }
    }

    async findByCategory(category: string): Promise<Merchandise[]> {
        return this.merchandiseModel.find({ category }).exec();
    }

    async updateStock(id: string, quantity: number): Promise<Merchandise> {
        const merchandise = await this.findById(id);
        if (merchandise.stock < quantity) {
            throw new Error('Insufficient stock');
        }
        merchandise.stock -= quantity;
        return merchandise.save();
    }
} 