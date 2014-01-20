//
//  CardGameViewController.m
//  Mochismo
//
//  Created by Ren-Shiou Liu on 1/19/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel*label;
@property (nonatomic) int count;
@property (strong, nonatomic) PlayingCardDeck* deck;
@end

@implementation CardGameViewController

// Override getter for the deck property (lazy instantiation)
- (PlayingCardDeck*) deck {
    if (!_deck) {
        _deck = [[PlayingCardDeck alloc] init];
    }
    
    return _deck;
}

// Button click event handler
- (IBAction)doFlipCard:(UIButton *)sender {
    if ([sender.currentTitle length]) {
        // If the title of the button is greater than 0 (meaning, it is displaying a card, then
        // flip it to the back side.
        [sender setBackgroundImage:[UIImage imageNamed:@"stanford"] forState:UIControlStateNormal];
    
        [sender setTitle:@"" forState:UIControlStateNormal];
    } else {
        // If the title of the button is 0, then flip it to the front side (i.e. displaying the suit
        // and the rank
        
        // Demo part
        //[sender setBackgroundImage:[UIImage imageNamed:@"BlankCard"] forState:UIControlStateNormal];
        //[sender setTitle:@"A♣︎" forState:UIControlStateNormal];
        
        // Homework part
        Card* card = [self.deck drawRandomCard];
        if (card) {
            [sender setBackgroundImage:[UIImage imageNamed:@"BlankCard"] forState:UIControlStateNormal];
            [sender setTitle:card.contents forState:UIControlStateNormal];
            self.count++;
        }
    }
    
    // Demo part
    //self.count++;
}

// Setter: update flip count and the UI
- (void) setCount:(int)count {
   _count = count;
    [self.label setText:[NSString stringWithFormat:@"Flips: %d", self.count]];
}
@end
