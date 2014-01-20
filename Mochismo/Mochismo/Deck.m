//
//  Deck.m
//  Mochismo
//
//  Created by Ren-Shiou Liu on 1/20/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "Deck.h"

@interface Deck()
// Array for holding the cards
@property (strong, nonatomic) NSMutableArray *cards;
@end

@implementation Deck

// Override the getter of the cards array (lazy instantiation)
- (NSMutableArray*) cards {
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

// Add a card to the top of the deck
// Parameter atTop controls whether the new card is added to the top or to the bottom
- (void) addCard:(Card *)card atTop:(BOOL)atTop {
    if (atTop) {
        [self.cards insertObject:card atIndex:0];
    } else {
        [self.cards addObject:card];
    }
}

// Another version of addCard that add a card to the top by default. No parameter is needed.
- (void) addCard:(Card *)card {
    [self addCard:card atTop:NO];
}

// Draw a random card from the deck
- (Card*) drawRandomCard {
    // Generate a random card index first between 0 to count - 1
    unsigned int index = arc4random() % [self.cards count];
    // Get the card at the index
    Card* randomCard = self.cards[index];
    // Remove the card from the deck
    [self.cards removeObjectAtIndex:index];
    // Finally, return the card object
    return randomCard;
}

@end
