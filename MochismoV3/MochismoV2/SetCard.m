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
    int score = 0;
    
    if ([otherCards count]) {
        for (SetCard* otherCard in otherCards) {
            if (otherCard.number == self.number) {
                score += 1;
            }
        }
    }
    
    return score;
}

@end
