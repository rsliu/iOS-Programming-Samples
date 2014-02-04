//
//  PlayingCardGameViewController.m
//  MochismoV3
//
//  Created by Ren-Shiou Liu on 2/4/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

-(Deck*) createDeck
{
    return [[PlayingCardDeck alloc] init];
}

@end
