//
//  PlayingCard.h
//  Mochismo
//
//  Created by Ren-Shiou Liu on 1/20/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card
@property (strong, nonatomic) NSString* suit;
@property (nonatomic) NSUInteger rank;
+(NSArray*) validSuits;
+(NSUInteger) maxRank;
-(void) setRank:(NSUInteger)rank;
@end
