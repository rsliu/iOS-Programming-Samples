//
//  CardGameViewController.m
//  Mochismo
//
//  Created by Ren-Shiou Liu on 1/19/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "CardGameViewController.h"
#import "LessBoringFlowLayout.h"

// It is sort of unfortunate that we are importing PlayingCardDeck into this class since it is otherwise a generic card matching game Controller.
//In other words, there’s really nothing that would prevent it from working with other Decks of other kinds of cards than PlayingCards.
//We’ll use polymorphism next week to improve this state of affairs.
#import "CardMatchingGame.h"
#import "Card.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label; // label for displaying score
@property (strong, nonatomic) CardMatchingGame *game; // need a property for the model
@end

@implementation CardGameViewController

#pragma mark - Life Cycle Methods


-(void) viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.allowsMultipleSelection = YES; // default is NO
    [self updateUI];
}

#pragma mark - Game methods

-(void) updateUI
{
    for(NSIndexPath *indexPath in [self.collectionView indexPathsForVisibleItems]) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        [self updateCell:cell usingCardAtIndex:indexPath.item];
    }

    [self.label setText:[NSString stringWithFormat:@"Score: %d", (int)self.game.score]];
}

- (IBAction)restartGame:(UIButton *)sender {
    [self.collectionView performBatchUpdates:^{
        NSMutableArray *indexPathsToDelete = [NSMutableArray array];
        NSMutableArray *indexPathsToInsert = [NSMutableArray array];
        
        for (int i = 0; i < [self.game numberOfCards]; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }

        [self.collectionView deleteItemsAtIndexPaths:indexPathsToDelete];
        
        self.game = nil;
        for (int i = 0; i < [self.game numberOfCards]; i++) {
            [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [self.collectionView insertItemsAtIndexPaths:indexPathsToInsert];
        
    } completion:nil];
}


#pragma mark - UICollectionViewDatasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.game.numberOfCards;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [self updateCell:cell usingCardAtIndex:indexPath.item]; // indexPath.item gives an index number identifying an item in a section of a collection view.
    return cell;
}

-(void) updateCell:(UICollectionViewCell*) cell usingCardAtIndex:(NSUInteger) index
{
    // virtual function
}

#pragma mark - UICollectionViewDelegate

-(BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Card* card = [self.game cardAtIndex:indexPath.item];
    return !card.isMatched;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.game chooseCardAtIndex:indexPath.item];
    [self updateUI];
}

-(BOOL) collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.game chooseCardAtIndex:indexPath.item];
    [self updateUI];
}

@end
