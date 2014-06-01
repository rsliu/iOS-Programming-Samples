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
#import "SetCardViewCell.h"
#import "LessBoringFlowLayout.h"

@interface SetCardGameViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (strong, nonatomic) CardMatchingGame* game;
@end

@implementation SetCardGameViewController


-(void) viewDidLoad
{
    [super viewDidLoad];
    
    //LessBoringFlowLayout *layout = [[LessBoringFlowLayout alloc] init];
    UIImage *patternImage = [UIImage imageNamed:@"FrameBackground"];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:patternImage];    
    [self.collectionView.viewForBaselineLayout.layer setSpeed:0.2f];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.collectionView.collectionViewLayout isKindOfClass:[LessBoringFlowLayout class]]) {
        LessBoringFlowLayout* layout = (LessBoringFlowLayout*) self.collectionView.collectionViewLayout;
        CGRect frame = self.collectionView.frame;
        int itemsPerRow = floorf((frame.size.width + layout.minimumInteritemSpacing - layout.sectionInset.left - layout.sectionInset.right) / (layout.itemSize.width + layout.minimumInteritemSpacing));
        int rows = [self.collectionView numberOfItemsInSection:0] / itemsPerRow;
        CGFloat height = (layout.itemSize.height + layout.minimumLineSpacing) * rows - layout.minimumLineSpacing + layout.sectionInset.top + layout.sectionInset.bottom;
        
        self.heightConstraint.constant = height;
    }
}


-(Deck*) createDeck {
    return [[SetCardDeck alloc] init];
}

-(CardMatchingGame*) game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:25
                                                usingDeck:[self createDeck]
                                                matchingCards:3];
    }
    
    return _game;
}

-(void) updateCell:(UICollectionViewCell*) cell usingCardAtIndex:(NSUInteger) index
{
    
    if ([cell isKindOfClass:[SetCardViewCell class]])
    {
        SetCardView* cardView = ((SetCardViewCell*) cell).cardView;
        SetCard* card = (SetCard*)[self.game cardAtIndex:index];
        cardView.number = card.number;
        cardView.color = card.color;
        cardView.symbol = card.symbol;
        cardView.shading = card.shading;
        cardView.chosen = card.isChosen;
    }
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    
    SetCard* card = (SetCard* ) [self.game cardAtIndex:indexPath.item];
    if (card.isMatched) {
        NSMutableIndexSet *cardsToRemove = [[NSMutableIndexSet alloc] init];

        for (int i = 0; i < [self.game numberOfCards]; i++) {
            SetCard* setCard = (SetCard*)[self.game cardAtIndex:i];
            if (setCard.isMatched) {
                [cardsToRemove addIndex:i];
                NSLog(@"Matched: %d", i);
            }
        }
        
        [self.game removeCardsAtIndexes:cardsToRemove];
        [self.collectionView deleteItemsAtIndexPaths:[self.collectionView indexPathsForSelectedItems]];
    }
}

@end
