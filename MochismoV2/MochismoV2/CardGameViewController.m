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
#import "PlayingCard.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label; // label for displaying score
@property (strong, nonatomic) CardMatchingGame* game; // need a property for the model
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *historyLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
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
    NSUInteger choosenIndex = [self.cardButtons indexOfObject:sender];
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
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        // Get the card object
        //Card* card = [self.game cardAtIndex:cardIndex];
        //[cardButton setTitle:((card.isChosen)? card.contents:@"") forState:UIControlStateNormal];
        // Lab #3
        id obj = [self.game cardAtIndex:cardIndex];
        if ([obj isKindOfClass:[PlayingCard class]]) {
            PlayingCard* card = (PlayingCard*) obj;
            [cardButton setAttributedTitle:((card.isChosen)? card.attributedContents:[[NSAttributedString alloc] initWithString:@""]) forState:UIControlStateNormal];
        
            UIImage* image = [UIImage imageNamed:((card.isChosen)? @"BlankCard":@"stanford")];
            [cardButton setBackgroundImage:image forState:UIControlStateNormal];
            cardButton.enabled = !card.isMatched;
        }
        [self.label setText:[NSString stringWithFormat:@"Score: %d", (int)self.game.score]];
    }
    
    // ### Lab 3 ###
    self.slider.maximumValue = [self.game.history count];
    [self.slider setValue: self.slider.maximumValue animated:true];
    [self updateHistoryLabel:(self.slider.maximumValue - 1)];
}

// ### Lab 2 ###
- (IBAction)restartGame:(UIButton *)sender {
    self.game = nil;
    [self updateUI];
    self.modeSwitcher.enabled= YES;
}

- (IBAction)modeChanged:(UISwitch *)sender {
    self.game.matching3Cards = !self.game.matching3Cards;
}

// ### Lab 3 ###
- (void) updateHistoryLabel:(int) recordIndex {
    if (recordIndex >= 0) {
        NSAttributedString* messageToDisplay = [self.game.history objectAtIndex:recordIndex];
        // Grey out historical records
        CGFloat alpha = (recordIndex < self.slider.maximumValue - 1)? 0.5:1.0;
        self.historyLabel.alpha = alpha;
        [self.historyLabel setAttributedText:messageToDisplay];
    } else {
        [self.historyLabel setText:@""];
    }
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    [self updateHistoryLabel:(int) sender.value - 1];
}
@end
