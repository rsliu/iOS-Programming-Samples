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
    NSArray* keys = @[@"number", @"symbol", @"color", @"shading"];

    SetCard* card2 = [otherCards objectAtIndex:0];
    SetCard* card3 = [otherCards objectAtIndex:1];
    
    for(NSString* key in keys) {
        if (!(([self valueForKey:key] == [card2 valueForKey:key] && [self valueForKey:key] == [card3 valueForKey:key] && [card2 valueForKey:key] == [card3 valueForKey:key]) ||
              ([self valueForKey:key] != [card2 valueForKey:key] && [self valueForKey:key] != [card3 valueForKey:key] && [card2 valueForKey:key] != [card3 valueForKey:key]))) {
            return 0;
        }
    }
   
    return 1;
}

@end
