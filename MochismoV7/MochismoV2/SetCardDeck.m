//
//  SetCardDeck.m
//  MochismoV3
//
//  Created by Ren-Shiou Liu on 3/24/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

// Init a deck of card
-(instancetype) init {
    // Always call init of the super class first
    self = [super init];
    
    // Always check if super class is initiated successfully
    if (self) {
        for (NSUInteger number = 1; number <= 3; number++) {
            for (NSUInteger symbol = 1; symbol <= 3; symbol++) {
                for (NSUInteger shading = 1; shading <= 3; shading++) {
                    for (NSUInteger color = 1; color <= 3; color++) {
                        SetCard* card = [[SetCard alloc] init];
                        card.number = number;
                        card.symbol = symbol;
                        card.shading = shading;
                        card.color = color;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    
    // Always return self
    return self;
}
@end
