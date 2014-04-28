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
#import "Card.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label; // label for displaying score
@property (weak, nonatomic) IBOutlet UILabel *historyLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) CardMatchingGame *game; // need a property for the model
@property (strong, nonatomic) NSMutableArray *gameHistory;
@property (strong, nonatomic) NSMutableArray* chosenCards;
@end

@implementation CardGameViewController

- (NSMutableArray*) gameHistory
{
    if (!_gameHistory) {
        _gameHistory = [[NSMutableArray alloc] init];
    }
    
    return _gameHistory;
}

- (NSMutableArray*) cardButtons
{
    if (!_cardButtons) {
        _cardButtons = [[NSMutableArray alloc] init];
    }
    
    return _cardButtons;
}

- (NSMutableArray*) chosenCards
{
    if (!_chosenCards) {
        _chosenCards = [[NSMutableArray alloc] init];
    }
    
    return _chosenCards;
}

// Must be called after the bounds of the view is set
-(void) createCardButtons
{
    // Create card views
    CGRect rect;
    rect.origin = CGPointMake(self.view.bounds.size.width / 2 - 20, self.view.bounds.size.height / 2 - 30);
    rect.size.width = 40;
    rect.size.height = 60;
    
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 6; j++) {
            UIView* view = [self createCardViewWithFrame:rect];
            [self.cardButtons addObject:view];
            [self.view addSubview:view];
            
            // Setup gesture recognizer
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchCardButton:)];
            [tapRecognizer setNumberOfTouchesRequired:1];
            [tapRecognizer setNumberOfTapsRequired:1];
            [view addGestureRecognizer:tapRecognizer];
        }
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.cardButtons count] == 0) {
        [self createCardButtons];
        // Deal cards with animation
        [self dealCards];
    }
}

// Button click event handler
- (IBAction) touchCardButton:(UITapGestureRecognizer *)sender
{
    // Find out the index of the button being clicked
    NSUInteger chosenIndex = [self.cardButtons indexOfObject:sender.view];
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
    
    if ([self.chosenCards count] == [self.game matchingCards]) {
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
    // Virtual function. Detailed implementation is in subclasses
}

-(void) updateUI
{
    [self updateCardButtons];
    [self.label setText:[NSString stringWithFormat:@"Score: %d", (int)self.game.score]];
    self.slider.maximumValue = [self.gameHistory count];
    [self.slider setValue: self.slider.maximumValue animated:true];
    [self updateHistoryLabel:(self.slider.maximumValue - 1)];
}

-(UIView*) createCardViewWithFrame:(CGRect)rect
{
    // pure virtual
    return nil;
}

-(void) dealCards
{
    CGRect rect;
    
    // Draw card content before starting the animation
    [self updateUI];
    
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 6; j++) {
            UIView* view = [self.cardButtons objectAtIndex:i*6+j];
            rect = view.frame;
            rect.origin.x = 15 + 50 * j;
            rect.origin.y = 50 + 70 * i;

            [UIView animateWithDuration:1 delay:0.1*(i*5+j)
                             options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 view.frame = rect;
                             } completion:nil];
        }
    }
}

- (IBAction)restartGame:(UIButton *)sender {
    self.game = nil;
    self.gameHistory = nil;
    self.chosenCards = nil;
    
    
    // Remove card buttons
    for(UIView* view in self.cardButtons) {
        [view removeFromSuperview];
    }
    [self.cardButtons removeAllObjects];
    
    [self createCardButtons];
    [self dealCards];
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
