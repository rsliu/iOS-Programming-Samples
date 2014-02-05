//
//  ViewController.m
//  SuperCard
//
//  Created by Ren-Shiou Liu on 2/5/14.
//  Copyright (c) 2014 National Cheng Kung University. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardView.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@property (strong, nonatomic) Deck *deck;
@end

@implementation ViewController

-(Deck*) deck
{
    if (!_deck) _deck = [[PlayingCardDeck alloc] init];
    return _deck;
}

-(void)drawRandomPlayingCard
{
    Card *card = [self.deck drawRandomCard];
    if ([card isKindOfClass:[PlayingCard class]]) {
        PlayingCard* playingCard = (PlayingCard*) card;
        self.playingCardView.rank = playingCard.rank;
        self.playingCardView.suit = playingCard.suit;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.playingCardView.rank = 13;
    self.playingCardView.suit = @"♥";
    [self.playingCardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.playingCardView
                                                                                         action:@selector(pinch:)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)swipe:(id)sender {
    if (!self.playingCardView.faceUp) [self drawRandomPlayingCard];
    self.playingCardView.faceUp = !self.playingCardView.faceUp;
}

@end
