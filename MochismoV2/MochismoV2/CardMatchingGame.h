//
//  CardMatchingGame.h
//  MochismoV2
//
//  Created by Ren-Shiou Liu on 1/21/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

@property (nonatomic, readonly) NSUInteger score; // Make sure no one can change this public property
- (instancetype) initWithCardCount:(NSUInteger) count usingDeck:(Deck*) deck; // Dedicated initializer must be public
- (void) chooseCardAtIndex:(NSUInteger) index; // Method for choosing a card
- (Card*) cardAtIndex:(NSUInteger) index; // Method for accessing a card
@property (nonatomic, getter = isMatching3Cards) BOOL matching3Cards;

@property (strong, nonatomic) NSMutableArray* history; // Lab #3
@end
