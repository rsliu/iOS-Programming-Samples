//
//  LessBoringFlowLayout.m
//  MochismoV6
//
//  Created by Ren-Shiou Liu on 5/25/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "LessBoringFlowLayout.h"
#import "FrameView.h"

@interface LessBoringFlowLayout()
// Caches for keeping current/previous attributes
// Containers for keeping track of changing items
@property (nonatomic, strong) NSMutableArray *insertedIndexPaths;
@property (nonatomic, strong) NSMutableArray *removedIndexPaths;
@property (nonatomic, strong) NSMutableArray *frameAttributes;
@end

@implementation LessBoringFlowLayout

#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

static NSString * const FrameViewKind  = @"FrameView";

- (void)setup
{
    self.minimumInteritemSpacing = 3.0f;
    self.minimumLineSpacing = 10.0;
    self.sectionInset = UIEdgeInsetsMake(15.0f, 15.0f, 10.0f, 15.0f);
    self.itemSize = CGSizeMake(40.0f, 60.0f);
    
    [self registerClass:[FrameView class] forDecorationViewOfKind:FrameViewKind];
}

#pragma  mark - Track changing items

-(NSMutableArray*) insertedIndexPaths {
    if (!_insertedIndexPaths) {
        _insertedIndexPaths = [[NSMutableArray alloc] init];
    }
    
    return _insertedIndexPaths;
}

-(NSMutableArray*) removedIndexPaths {
    if (!_removedIndexPaths) {
        _removedIndexPaths = [[NSMutableArray alloc] init];
    }
    return _removedIndexPaths;
}

-(NSMutableArray*) frameAttributes {
    if (!_frameAttributes) {
        _frameAttributes = [[NSMutableArray alloc] init];
    }
    return _frameAttributes;
}

#pragma mark - Decolration Views
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    self.frameAttributes = nil;
    return YES;
}

- (CGRect) frameForSide:(NSUInteger) side
{
    CGSize size;
    CGPoint origin;
    
    switch(side) {
        case 0:
        case 2:
            size.width = self.collectionView.bounds.size.width;
            size.height = 10.0f;
            origin.x = 0;
            origin.y = (side == 0)? 0:self.collectionView.bounds.size.height - size.height;
            break;
        case 1:
        case 3:
            size.width = 10.0f;
            size.height = self.collectionView.bounds.size.height;
            origin.x = (side == 1)? 0:self.collectionView.bounds.size.width - size.width;
            origin.y = 0;
            break;
    }
    
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}

-(void) prepareLayout
{
    [super prepareLayout];

    if ([self.frameAttributes count] == 0) {
        CGRect frame = self.collectionView.frame;
        int itemsPerRow = floorf((frame.size.width + self.minimumInteritemSpacing - self.sectionInset.left - self.sectionInset.right) / (self.itemSize.width + self.minimumInteritemSpacing));
        int rows = [self.collectionView numberOfItemsInSection:0] / itemsPerRow;
        CGFloat interval = self.itemSize.height + self.minimumLineSpacing;
        
        for (int i = 0; i < 4; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            UICollectionViewLayoutAttributes *attribute =
            [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:FrameViewKind withIndexPath:indexPath];
            attribute.frame = [self frameForSide:i];
            [self.frameAttributes addObject:attribute];
        }
    
        for (int i = 0; i < rows - 1; i++) {
            CGSize size;
            CGPoint origin;

            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i+4 inSection:0];
            UICollectionViewLayoutAttributes *attribute =
            [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:FrameViewKind withIndexPath:indexPath];
            
            size.width = self.collectionView.bounds.size.width;
            size.height = 5;
            origin.x = 0;
            origin.y = self.sectionInset.top + (i + 1) * interval - self.minimumLineSpacing;
            attribute.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
            //attribute.zIndex = 0;
            [self.frameAttributes addObject:attribute];
        }
    }
}

// Return attributes of all items (cells, supplementary views, decoration views) that appear within this rect
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // call super so flow layout can return default attributes for all cells, headers, and footers
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // Add our decoration views (shelves)
    array = [array arrayByAddingObjectsFromArray:self.frameAttributes];
    
    return array;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item < [self.frameAttributes count]) {
        return self.frameAttributes[indexPath.item];
    }

    return nil;
}

#pragma mark - Animations

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    
    // Keep track of updates to items and sections so we can use this information to create nifty animations
    [updateItems enumerateObjectsUsingBlock:^(UICollectionViewUpdateItem *updateItem, NSUInteger idx, BOOL *stop) {
        if (updateItem.updateAction == UICollectionUpdateActionInsert) {
            [self.insertedIndexPaths addObject:updateItem.indexPathAfterUpdate];
        }
        else if (updateItem.updateAction == UICollectionUpdateActionDelete) {
            [self.removedIndexPaths addObject:updateItem.indexPathBeforeUpdate];
        }
    }];
}



- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [[super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath] copy];
    
    //if ([self.insertedIndexPaths containsObject:itemIndexPath]) {
        attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
    //}

    return attributes;
}

- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [[super layoutAttributesForItemAtIndexPath:itemIndexPath] copy];
 
    if ([self.removedIndexPaths containsObject:itemIndexPath]) {
        CATransform3D transform = CATransform3DMakeTranslation(0, self.collectionView.bounds.size.height, 0);
        transform = CATransform3DRotate(transform, M_PI * 0.7, 0, 0, 1);
        attributes.transform3D = transform;
        attributes.alpha = 0.0f;
        [self.removedIndexPaths removeObject:itemIndexPath];
    }

    return attributes;
}

@end
