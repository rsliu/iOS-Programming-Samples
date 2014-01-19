//
//  Card.m
//  Mochismo
//
//  Created by Ren-Shiou Liu on 1/20/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int) match:(Card *)card {
    int score = 0;
    
    if ([self.contents isEqualToString:card.contents]) {
        score = 1;
    }
    return score;
}

@end
