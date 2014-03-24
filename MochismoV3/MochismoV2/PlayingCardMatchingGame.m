//
//  PlayingCardMatchingGame.m
//  MochismoV3
//
//  Created by Ren-Shiou Liu on 3/24/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "PlayingCardMatchingGame.h"

@implementation PlayingCardMatchingGame


- (NSUInteger) matchingCards {
    return 2; // matches two cards in playingcard game
}

-(NSUInteger) calculateMatchScore:(NSArray*) chosenCards {
    NSUInteger matchScore = 0;
    
    for(int i = 0; i < [chosenCards count]; i++) {
        Card* card = [chosenCards objectAtIndex:i];
        NSArray* cardsToMatch = [chosenCards subarrayWithRange:NSMakeRange(i+1, [chosenCards count] - i - 1)];
        matchScore += [card match:cardsToMatch];
    }
    
    return matchScore;
}

@end
