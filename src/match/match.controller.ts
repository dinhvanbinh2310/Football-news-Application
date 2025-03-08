import { Controller, Get, Post, Body, Param, Put, Delete } from '@nestjs/common';
import { MatchService } from './match.service';
import { Match } from './schemas/match.schema';

@Controller('matches')
export class MatchController {
  constructor(private readonly matchService: MatchService) {}

  @Post()
  async create(@Body() matchData: Partial<Match>) {
    return this.matchService.create(matchData);
  }

  @Get()
  async findAll() {
    return this.matchService.findAll();
  }

  @Get(':id')
  async findById(@Param('id') id: string) {
    return this.matchService.findById(id);
  }

  @Put(':id')
  async update(@Param('id') id: string, @Body() updateData: Partial<Match>) {
    return this.matchService.update(id, updateData);
  }

  @Delete(':id')
  async delete(@Param('id') id: string) {
    return this.matchService.delete(id);
  }
}
