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

@interface PlayingCardGameViewController ()
@property (strong, nonatomic) CardMatchingGame* game;
@end

@implementation PlayingCardGameViewController

-(Deck*) createDeck {
    return [[PlayingCardDeck alloc] init];
}

-(CardMatchingGame*) game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                              usingDeck:[self createDeck]
                                              matchingCards:2];
    }
    
    return _game;
}


-(void) updateCardButtons {
    for(UIView* cardButton in self.cardButtons) {
        // Find out card index
        if ([cardButton isKindOfClass:[PlayingCardView class]]) {
            PlayingCardView* playingCardButton = (PlayingCardView*) cardButton;
            
            NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
            
            // Get the card object
            PlayingCard* card = [self.game cardAtIndex:cardIndex];
            playingCardButton.rank = card.rank;
            playingCardButton.suit = card.suit;
            playingCardButton.matched = card.isMatched;
            playingCardButton.faceUp = card.isChosen || card.isMatched;
        }
    }
}

-(NSAttributedString*) attributedContentOfCard:(Card*) card
{
    NSMutableAttributedString* attributedContent;
    
    if ([card isKindOfClass:[PlayingCard class]]) {
        PlayingCard* playingCard = (PlayingCard*) card;
        attributedContent = [[NSMutableAttributedString alloc] initWithString:playingCard.contents attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        
        if ([playingCard.suit isEqualToString:@"♥︎"] || [playingCard.suit isEqualToString:@"♦︎"]) {
            NSRange range = [[attributedContent string] rangeOfString:playingCard.suit];
            [attributedContent addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:.498 green:0 blue:.0 alpha:1] range:range];
        }
    }
    
    return attributedContent;
}
@end
