//
//  DropitBehavior.h
//  Dropit
//
//  Created by Ren-Shiou Liu on 2/22/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropitBehavior : UIDynamicBehavior
- (void) addItem: (id<UIDynamicItem>) item;
- (void) removeItem: (id<UIDynamicItem>) item;
@end
