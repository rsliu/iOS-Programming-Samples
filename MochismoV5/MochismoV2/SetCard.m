//
//  SetCard.m
//  MochismoV3
//
//  Created by Ren-Shiou Liu on 3/24/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

-(int) match:(NSArray*) otherCards {
    int numberOfMatches = 0;
    NSArray* keys = @[@"number", @"symbol", @"color", @"shading"];

    NSMutableArray* cardsToMatch = [otherCards mutableCopy];
    [cardsToMatch addObject:self];

    
    for(NSString* key in keys) {
        for(NSUInteger j = 0; j < [cardsToMatch count]; j++) {
            SetCard* card = [cardsToMatch objectAtIndex:j];
            
            numberOfMatches = 0;
            for (NSUInteger k = j+1; k < [cardsToMatch count]; k++) {
                SetCard* anotherCard = [cardsToMatch objectAtIndex:k];
                if ([card valueForKey:key] == [anotherCard valueForKey:key]) {
                    numberOfMatches++;
                }
            }
            
            if (numberOfMatches != 0 && numberOfMatches != ([otherCards count] - j - 2)) return 0;
        }
    }
    
    return 1;
}

@end
