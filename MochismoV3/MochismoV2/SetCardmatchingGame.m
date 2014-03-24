//
//  SetCardmatchingGame.m
//  MochismoV3
//
//  Created by Ren-Shiou Liu on 3/24/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "SetCardmatchingGame.h"

@implementation SetCardmatchingGame

- (NSUInteger) matchingCards {
    return 3; // matches three cards in set game
}

-(NSUInteger) calculateMatchScore:(NSArray*) chosenCards {
    NSUInteger matchScore = 0;
    
    if ([chosenCards count] != 3) return 0; // Need to have three cards
    
    
    return matchScore;
}

@end
