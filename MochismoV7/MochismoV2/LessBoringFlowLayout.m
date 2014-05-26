//
//  LessBoringFlowLayout.m
//  MochismoV6
//
//  Created by Ren-Shiou Liu on 5/25/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "LessBoringFlowLayout.h"

@interface LessBoringFlowLayout()
// Caches for keeping current/previous attributes
// Containers for keeping track of changing items
@property (nonatomic, strong) NSMutableArray *insertedIndexPaths;
@property (nonatomic, strong) NSMutableArray *removedIndexPaths;
@end

@implementation LessBoringFlowLayout

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

#pragma mark - Animations

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
