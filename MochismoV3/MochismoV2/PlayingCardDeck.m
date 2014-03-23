//
//  PlayingCardDeck.m
//  Mochismo
//
//  Created by Ren-Shiou Liu on 1/20/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck


// Init a deck of card
-(instancetype) init {
    // Always call init of the super class first
    self = [super init];
    
    // Always check if super class is initiated successfully
    if (self) {
        // Add all the cards into the deck
        for (NSString* suit in [PlayingCard validSuits]) {
            for (NSUInteger rank = 1; rank < [PlayingCard maxRank]; rank++) {
                PlayingCard* card = [[PlayingCard alloc] init];
                card.suit = suit;
                card.rank = rank;
                [self addCard:card];
            }
        }
    }
    
    // Always return self
    return self;
}
@end
