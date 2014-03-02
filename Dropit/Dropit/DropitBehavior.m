//
//  DropitBehavior.m
//  Dropit
//
//  Created by Ren-Shiou Liu on 2/22/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "DropitBehavior.h"

@interface DropitBehavior() 
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UICollisionBehavior *collider;
@property (strong, nonatomic) UIDynamicItemBehavior *animationOptions;
@end

@implementation DropitBehavior

- (UIGravityBehavior*) gravity
{
    // Init the gravity behavior
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc] init];
        _gravity.magnitude = 0.9;
    }
    
    return _gravity;
}

-(UICollisionBehavior*) collider
{
    if (!_collider) {
        _collider = [[UICollisionBehavior alloc] init];
        _collider.translatesReferenceBoundsIntoBoundary = YES;
    }
    
    return _collider;
}

- (UIDynamicItemBehavior*) animationOptions
{
    if (!_animationOptions) {
        _animationOptions = [[UIDynamicItemBehavior alloc] init];
        
        // Do not allow rotation so that those blocks can sit
        // right on top of each other
        _animationOptions.allowsRotation = NO;
    }
    return _animationOptions;
}

- (void) addItem:(id<UIDynamicItem>)item
{
    [self.gravity addItem:item];
    [self.collider addItem:item];
    [self.animationOptions addItem:item];
}

- (void) removeItem:(id<UIDynamicItem>)item
{
    [self.gravity removeItem:item];
    [self.collider removeItem:item];
    [self.animationOptions removeItem:item];
}

- (instancetype) init
{
    self = [super init];
    
    [self addChildBehavior:self.gravity];
    [self addChildBehavior:self.collider];
    [self addChildBehavior:self.animationOptions];
    
    return self;
}

@end
