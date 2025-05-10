import { Controller, Get, Post, Body, Param, Put, Delete, Query, UseGuards } from '@nestjs/common';
import { MerchandiseService } from './merchandise.service';
import { CreateMerchandiseDto } from './dto/create-merchandise.dto';
import { AuthGuard } from '@nestjs/passport';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';

@Controller('merchandise')
export class MerchandiseController {
    constructor(private readonly merchandiseService: MerchandiseService) { }

    @Post()
    @UseGuards(AuthGuard('jwt'), RolesGuard)
    @Roles('admin')
    create(@Body() createMerchandiseDto: CreateMerchandiseDto) {
        return this.merchandiseService.create(createMerchandiseDto);
    }

    @Get()
    findAll() {
        return this.merchandiseService.findAll();
    }

    @Get('category/:category')
    findByCategory(@Param('category') category: string) {
        return this.merchandiseService.findByCategory(category);
    }

    @Get(':id')
    findOne(@Param('id') id: string) {
        return this.merchandiseService.findById(id);
    }

    @Put(':id')
    @UseGuards(AuthGuard('jwt'), RolesGuard)
    @Roles('admin')
    update(@Param('id') id: string, @Body() updateMerchandiseDto: Partial<CreateMerchandiseDto>) {
        return this.merchandiseService.update(id, updateMerchandiseDto);
    }

    @Delete(':id')
    @UseGuards(AuthGuard('jwt'), RolesGuard)
    @Roles('admin')
    remove(@Param('id') id: string) {
        return this.merchandiseService.delete(id);
    }
} 