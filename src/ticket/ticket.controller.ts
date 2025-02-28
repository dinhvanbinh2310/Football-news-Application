import { Body, Controller, Post } from '@nestjs/common';
import { TicketService } from './ticket.service';
import { CreateTicketDto } from './dto/create-ticket.dto';
import { Get, Param } from '@nestjs/common';
import { Ticket } from './schemas/ticket.schema';

@Controller('tickets')
export class TicketController {
  constructor(private readonly ticketService: TicketService) {}

  @Post()
  create(@Body() createTicketDto: CreateTicketDto) {
    return this.ticketService.create(createTicketDto);
  }
   // Lấy tất cả vé
   @Get()
   async getAllTickets(): Promise<Ticket[]> {
     return this.ticketService.getAllTickets();
   }
 
   // Lấy vé theo ID
   @Get(':id')
   async getTicketById(@Param('id') id: string): Promise<Ticket> {
     return this.ticketService.getTicketById(id);
   }
}
