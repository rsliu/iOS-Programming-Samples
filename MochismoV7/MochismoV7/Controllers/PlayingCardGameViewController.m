//
//  PlayingCardGameViewController.m
//  MochismoV3
//
//  Created by Ren-Shiou Liu on 3/24/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "PlayingCardView.h"
#import "PlayingCardViewCell.h"

@interface PlayingCardGameViewController ()
@property (strong, nonatomic) CardMatchingGame* game;
@end

@implementation PlayingCardGameViewController

-(Deck*) createDeck {
    return [[PlayingCardDeck alloc] init];
}

-(CardMatchingGame*) game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:30
                                              usingDeck:[self createDeck]
                                              matchingCards:2];
    }
    
    return _game;
}

-(void) updateCell:(UICollectionViewCell*) cell usingCardAtIndex:(NSUInteger) index
{
    
    if ([cell isKindOfClass:[PlayingCardViewCell class]])
    {
        PlayingCardView* cardView = ((PlayingCardViewCell*) cell).cardView;
        PlayingCard* card = (PlayingCard*)[self.game cardAtIndex:index];
        cardView.rank = card.rank;
        cardView.suit = card.suit;
        cardView.matched = card.isMatched;
        cardView.faceUp = card.isChosen || card.isMatched;
    }
}

@end
