//
//  SetCardGameViewController.m
//  MochismoV3
//
//  Created by Ren-Shiou Liu on 3/25/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetCardView.h"

@interface SetCardGameViewController ()
@property (strong, nonatomic) CardMatchingGame* game;
@end

@implementation SetCardGameViewController



-(Deck*) createDeck {
    return [[SetCardDeck alloc] init];
}

-(CardMatchingGame*) game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                usingDeck:[self createDeck]
                                                matchingCards:3];
    }
    
    return _game;
}

-(void) updateCardButtons {
    for(UIView* cardButton in self.cardButtons) {
        // Find out card index
        if ([cardButton isKindOfClass:[SetCardView class]]) {
            SetCardView* setCardButton = (SetCardView*) cardButton;
            
            NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
            
            // Get the card object
            SetCard* card = (SetCard*)[self.game cardAtIndex:cardIndex];
            setCardButton.number = card.number;
            setCardButton.color = card.color;
            setCardButton.symbol = card.symbol;
            setCardButton.shading = card.shading;
        }
    }
}

-(NSAttributedString*) attributedContentOfCard:(Card*) card
{
    NSMutableAttributedString* attributedContent;
    NSArray* symbols = @[@"▲", @"◼︎", @"✣"];
    NSArray* colors = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor]];
    double shadings[] = {0.2, 0.7, 1.0};

    if ([card isKindOfClass:[SetCard class]]) {
        SetCard* setCard = (SetCard*)card;
        NSAttributedString* symbol = [[NSAttributedString alloc] initWithString:[symbols objectAtIndex:setCard.symbol - 1]];
        attributedContent = [[NSMutableAttributedString alloc] initWithAttributedString:symbol];
        for(NSUInteger i = 1; i < setCard.number; i++) {
            [attributedContent appendAttributedString:symbol];
        }
        UIColor* color = [colors objectAtIndex:setCard.color - 1];
        color = [color colorWithAlphaComponent:shadings[setCard.shading - 1]];
        [attributedContent addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [attributedContent length])];
    }
    
    return attributedContent;
}
@end
