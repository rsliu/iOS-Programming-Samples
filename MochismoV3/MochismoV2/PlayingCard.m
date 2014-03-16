//
//  PlayingCard.m
//  Mochismo
//
//  Created by Ren-Shiou Liu on 1/20/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

// Getter: return the contents (rank and suit) of a playing card
- (NSString*) contents {
    NSArray* rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

// Since we override both the setter and getter of the suit property,
// it is necessary that we synthesize the property manually
@synthesize suit = _suit;

// Getter: return the suit of a playing card
- (NSString*) suit {
    return (_suit)? _suit : @"?";
}

// Setter: set the suit of a playing card
-(void) setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

// Class method for creating/returing valid suits
+(NSArray*) validSuits {
    return @[@"♠︎", @"♣︎", @"♥", @"♦︎"];
}

// Class method for creating/returning valid ranks
+(NSArray*) rankStrings {
    return @[@"?", @"A", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"J", @"Q", @"K"];
}

// Class method for returing the max rank
+(NSUInteger) maxRank {
    return [[self rankStrings] count] - 1 ;
}

// Setter: set the rank of a playing card
-(void) setRank:(NSUInteger)rank {
    // Check the rank before saving
    if (rank < [PlayingCard maxRank]) {
        _rank = rank;
    }
}

// Override Card's match. No need to declare it again in the .h file
-(int) match:(NSArray*) otherCards {
    int score = 0;
    
    // Make sure the otherCards array is not empty first
    if ([otherCards count]) {
        PlayingCard* otherCard = [otherCards firstObject];
        if (otherCard.rank == self.rank) {
            // matching rank is more difficult, therefore a higher score
            score = 4;
        } else if ([otherCard.suit isEqualToString:self.suit]) {
            score = 1;
        }
    }
    
    return score;
}
@end
