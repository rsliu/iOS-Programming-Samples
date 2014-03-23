//
//  CardMatchingGame.m
//  MochismoV2
//
//  Created by Ren-Shiou Liu on 1/21/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray* cards;
@property (nonatomic, readwrite) NSUInteger score; // However, we need to use "readwrite" keyword to make sure the controller itself can do read/write
@end

@implementation CardMatchingGame


// Override getter for the deck property (lazy instantiation)
- (NSMutableArray*) cards {
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    
    return _cards;
}

// Step 1. Dedicated initializer
- (instancetype) initWithCardCount:(NSUInteger) count usingDeck:(Deck*) deck {
    // Again, always call the init of the super class first
    self = [super init];
    
    // Check if the super class is initialized successfully
    if (self) {
        // Draw numberOfCards from the deck of cards
        for(int i = 0; i < count; i++) {
            Card* card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                // If there is no sufficient cards, set self to nil and
                // break out of the loop
                self = nil;
                break;
            }
        }
    }
    
    // Always return self
    return self;
}

// Step 2. This is easy
- (Card*) cardAtIndex:(NSUInteger) index {
    // Note: Check index to prevent index out of array boundary
    return (index < [self.cards count])? [self.cards objectAtIndex:index]:nil;
}

// Step 3. Action when the user chooses a card. Note, this should not involve any UI
static const int MATCH_BONUS = 4;
static const int MISMATCH_PENALTY = 2;
static const int COST_TO_CHOOSE = 1;

- (void) chooseCardAtIndex:(NSUInteger) index
{
    Card* card = [self cardAtIndex:index];
    NSString* matchResult;
    
    if (card) {
        if (!card.isMatched) {
            // Place all chosen cards in an array
            NSMutableArray* chosenCards = [[NSMutableArray alloc] init];
            
            for(Card* otherCard in self.cards) {
                if (!otherCard.isMatched && otherCard.isChosen) {
                    [chosenCards addObject:otherCard];
                }
            }
            
            if (card.isChosen) {
                card.chosen = NO;
                [chosenCards removeObject:card];
            } else {
                [chosenCards addObject:card];
                
                if ([chosenCards count] == self.matchingCards) {
                    int matchScore = 0;
                    
                    for(int i = 0; i < [chosenCards count]; i++) {
                        Card* card = [chosenCards objectAtIndex:i];
                        NSArray* cardsToMatch = [chosenCards subarrayWithRange:NSMakeRange(i+1, [chosenCards count] - i - 1)];
                        matchScore += [card match:cardsToMatch];
                    }
                    
                    if (matchScore) {
                        self.score += MATCH_BONUS * matchScore;
                        [chosenCards setValue:[NSNumber numberWithBool:YES] forKey:@"matched"];
                    } else {
                        self.score -= MISMATCH_PENALTY;
                        [chosenCards setValue:[NSNumber numberWithBool:NO] forKey:@"chosen"];
                    }
                }
                
                self.score -= COST_TO_CHOOSE;
                card.chosen = YES;
            }
        }
    }
}
@end
