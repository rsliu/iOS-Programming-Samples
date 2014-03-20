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
@property (strong, nonatomic) CardMatchingGame *game; // need a property for the model
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISwitch *modeSwitcher;
@property (weak, nonatomic) IBOutlet UILabel *historyLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) NSMutableArray *gameHistory;
@property (strong, nonatomic) NSMutableArray* chosenCards;
@end

@implementation CardGameViewController


-(Deck*) createDeck {
    return [[PlayingCardDeck alloc] init];
}

-(CardMatchingGame*) game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
        _game.matchingCards = (self.modeSwitcher.on)? 3:2;
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
    
    // Lab #2 Solution
    self.modeSwitcher.enabled= NO;
}

// ### Lab 3 ###
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
// ###

-(void) updateUI
{
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
        [self.label setText:[NSString stringWithFormat:@"Score: %d", (int)self.game.score]];
    }
    
    // ### Lab 3 ###
    self.slider.maximumValue = [self.gameHistory count];
    [self.slider setValue: self.slider.maximumValue animated:true];
    [self updateHistoryLabel:(self.slider.maximumValue - 1)];
}

// ### Lab 2 ###
- (IBAction)restartGame:(UIButton *)sender {
    self.game = nil;
    self.gameHistory = nil;
    self.chosenCards = nil;
    [self updateUI];
    self.modeSwitcher.enabled= YES;
}

- (IBAction)modeChanged:(UISwitch *)sender {
    self.game.matchingCards = (sender.on)? 3:2;
}

// ### Lab 3 ###
- (void) updateHistoryLabel:(int) recordIndex {
    NSAttributedString* messageToDisplay;
    
    if (recordIndex >= 0) {
        messageToDisplay = [self.gameHistory objectAtIndex:recordIndex];
        self.historyLabel.alpha = (recordIndex < self.slider.maximumValue - 1)? 0.5:1.0;
    }
    [self.historyLabel setAttributedText:messageToDisplay];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    [self updateHistoryLabel:(int) sender.value - 1];
}
@end
