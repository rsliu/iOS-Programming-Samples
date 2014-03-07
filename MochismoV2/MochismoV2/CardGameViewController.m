//
//  CardGameViewController.m
//  Mochismo
//
//  Created by Ren-Shiou Liu on 1/19/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "CardGameViewController.h"

// It is sort of unfortunate that we are importing PlayingCardDeck into this class since it is otherwise a generic card matching game Controller.
//In other words, there’s really nothing that would prevent it from working with other Decks of other kinds of cards than PlayingCards.
//We’ll use polymorphism next week to improve this state of affairs.
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label; // label for displaying score
@property (strong, nonatomic) CardMatchingGame* game; // need a property for the model
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISwitch *modeSwitcher;
@end

@implementation CardGameViewController


-(Deck*) createDeck {
    return [[PlayingCardDeck alloc] init];
}

-(CardMatchingGame*) game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    }
    
    return _game;
}

// Button click event handler
- (IBAction)doFlipCard:(UIButton *)sender {
    // Find out the index of the button being clicked
    int choosenIndex = [self.cardButtons indexOfObject:sender];
    // Call the model to choose the card at that index
    [self.game chooseCardAtIndex:choosenIndex];
    // Update the UI according to the new state of the model
    [self updateUI];
    
    // Solution
    self.modeSwitcher.enabled= NO;
}

-(void) updateUI {
    for(UIButton* cardButton in self.cardButtons) {
        // Find out card index
        int cardIndex = [self.cardButtons indexOfObject:cardButton];
        // Get the card object
        Card* card = [self.game cardAtIndex:cardIndex];
        [cardButton setTitle:((card.isChosen)? card.contents:@"") forState:UIControlStateNormal];
        UIImage* image = [UIImage imageNamed:((card.isChosen)? @"BlankCard":@"stanford")];
        [cardButton setBackgroundImage:image forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        [self.label setText:[NSString stringWithFormat:@"Score: %d", self.game.score]];
    }
}

// Lab #2 solution
- (IBAction)restartGame:(UIButton *)sender {
    self.game = nil;
    [self updateUI];
    self.modeSwitcher.enabled= YES;
}

- (IBAction)modeChanged:(UISwitch *)sender {
    self.game.matching3Cards = !self.game.matching3Cards;
}
@end
