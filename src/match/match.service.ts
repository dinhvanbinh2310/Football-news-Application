import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Match, MatchDocument } from './schemas/match.schema';

@Injectable()
export class MatchService {
  constructor(@InjectModel(Match.name) private matchModel: Model<MatchDocument>) {}

  async create(matchData: Partial<Match>): Promise<Match> {
    const match = new this.matchModel(matchData);
    return match.save();
  }

  async findAll(): Promise<Match[]> {
    return this.matchModel.find().exec();
  }

  async findById(id: string): Promise<Match | null> {
    return this.matchModel.findById(id).exec();
  }

  async update(id: string, updateData: Partial<Match>): Promise<Match | null> {
    return this.matchModel.findByIdAndUpdate(id, updateData, { new: true }).exec();
  }

  async delete(id: string): Promise<Match | null> {
    return this.matchModel.findByIdAndDelete(id).exec();
  }
}
