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
#import "CardMatchingGame.h"
#import "PlayingCard.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label; // label for displaying score
@property (weak, nonatomic) IBOutlet UILabel *historyLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) NSMutableArray *gameHistory;
@property (strong, nonatomic) NSMutableArray* chosenCards;
@end

@implementation CardGameViewController


-(Deck*) createDeck {
    return nil;
}

-(CardMatchingGame*) game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
        _game.matchingCards = 2;
    }
    
    return _game;
}

- (NSMutableArray*) gameHistory {
    if (!_gameHistory) {
        _gameHistory = [[NSMutableArray alloc] init];
    }
    
    return _gameHistory;
}

- (NSMutableArray*) chosenCards {
    if (!_chosenCards) {
        _chosenCards = [[NSMutableArray alloc] init];
    }
    
    return _chosenCards;
}

// Button click event handler
- (IBAction) touchCardButton:(UIButton *)sender {
    // Find out the index of the button being clicked
    NSUInteger chosenIndex = [self.cardButtons indexOfObject:sender];
    Card* card = [self.game cardAtIndex:chosenIndex];
    
    NSUInteger score = self.game.score;
    NSMutableAttributedString* history = [[NSMutableAttributedString alloc] init];
    
    
    // Call the model to choose the card at that index
    [self.game chooseCardAtIndex:chosenIndex];
    
    if (card.isChosen) {
        [self.chosenCards addObject:card];
    } else {
        [self.chosenCards removeObject:card];
    }
    
    for (Card* chosenCard in self.chosenCards) {
        [history appendAttributedString:[self attributedContentOfCard:chosenCard]];
    }
    
    if ([self.chosenCards count] == self.game.matchingCards) {
        NSString* matchResult;
        
        if (card.isMatched) {
            matchResult = [NSString stringWithFormat:@" matched for %lu points!", (self.game.score - score)];
            [self.chosenCards removeAllObjects];
        } else {
            matchResult = [NSString stringWithFormat:@" do not match! %lu point penalty!", (score - self.game.score)];
            [self.chosenCards removeObjectsInRange:NSMakeRange(0, [self.chosenCards count] - 1)];
        }
        [history appendAttributedString:[[NSAttributedString alloc] initWithString:matchResult attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}]];
    }
    
    [self.gameHistory addObject:history];
    
    // Update the UI according to the new state of the model
    [self updateUI];
}

-(NSAttributedString*) attributedContentOfCard:(Card*) card
{
    return nil;
}

-(void) updateCardButtons
{
}

-(void) updateUI
{
    [self updateCardButtons];
    [self.label setText:[NSString stringWithFormat:@"Score: %d", (int)self.game.score]];
    self.slider.maximumValue = [self.gameHistory count];
    [self.slider setValue: self.slider.maximumValue animated:true];
    [self updateHistoryLabel:(self.slider.maximumValue - 1)];
}

- (IBAction)restartGame:(UIButton *)sender {
    self.game = nil;
    self.gameHistory = nil;
    self.chosenCards = nil;
    [self updateUI];
}

- (IBAction)modeChanged:(UISwitch *)sender {
    self.game.matchingCards = (sender.on)? 3:2;
}

- (void) updateHistoryLabel:(int) recordIndex {
    NSAttributedString* messageToDisplay;
    
    if (recordIndex >= 0 && recordIndex < [self.gameHistory count]) {
        messageToDisplay = [self.gameHistory objectAtIndex:recordIndex];
        self.historyLabel.alpha = (recordIndex < self.slider.maximumValue - 1)? 0.5:1.0;
    }
    [self.historyLabel setAttributedText:messageToDisplay];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    [self updateHistoryLabel:(int) sender.value - 1];
}
@end
