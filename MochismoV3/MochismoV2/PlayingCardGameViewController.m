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

@interface PlayingCardGameViewController ()
@property (strong, nonatomic) CardMatchingGame* game;
@end

@implementation PlayingCardGameViewController

-(void) viewDidLoad {
    [super viewDidLoad];
}

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
    for(UIButton* cardButton in self.cardButtons) {
        // Find out card index
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        
        // Get the card object
        Card* card = [self.game cardAtIndex:cardIndex];
        //[cardButton setTitle:((card.isChosen)? card.contents:@"") forState:UIControlStateNormal];
        
        // Lab #3
        NSAttributedString* content = (card.isChosen)? [self attributedContentOfCard:card]: nil;
        [cardButton setAttributedTitle:content forState:UIControlStateNormal];
        
        UIImage* image = [UIImage imageNamed:((card.isChosen)? @"BlankCard":@"stanford")];
        [cardButton setBackgroundImage:image forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
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
