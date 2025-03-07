import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

export type MatchDocument = HydratedDocument<Match>;

@Schema({ timestamps: true })
export class Match {
  @Prop({ required: true })
  homeTeam: string;

  @Prop({ required: true })
  awayTeam: string;

  @Prop({ required: true })
  date: Date;

  @Prop({ required: true })
  stadium: string;

  @Prop()
  status: string; // upcoming, live, finished
}

export const MatchSchema = SchemaFactory.createForClass(Match);
