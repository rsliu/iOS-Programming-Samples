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
@property (nonatomic) NSUInteger mode; // Lab 2
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

/* Demo
- (void) chooseCardAtIndex:(NSUInteger) index {
    // Only react to non-matched cards
    Card* card = [self cardAtIndex:index];
    
    if (card) {
        // We only allot unmatched card to be chosen
        if (!card.isMatched) {
            if (card.isChosen) {
                // If the card has been chosen, unchoose it
                card.chosen = NO;
            } else {
                // Otherwise, we need to match it with other chosen cards
                for(Card* otherCard in self.cards) {
                    if (!otherCard.isMatched && otherCard.isChosen) {
                        // Match method of the card class takes an array
                        // of other cards in case a subclass can match multiple cards
                        // Since out game is only a 2-card matching game, we just create an array with one card in it
                        int matchScore = [card match:@[otherCard]];
                        if (matchScore) {
                            self.score += MATCH_BONUS;
                            // Set matched flag to YES for both cards
                            otherCard.matched = YES;
                            card.matched = YES;
                        } else {
                            self.score -= MISMATCH_PENALTY;
                            // Flip the other card that is not a match
                            otherCard.chosen = NO;
                        }
                        break; // Only 2 cards for now, so we can break out the loop
                    }
                }
                // Cost to choose (to prevent from cheating)
                self.score -= COST_TO_CHOOSE;
                
                // Choose the card
                card.chosen = YES;
            }
        }
    }
}
*/

// Lab 2 solution
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
