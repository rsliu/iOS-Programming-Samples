//
//  SetCardView.h
//  MochismoV5
//
//  Created by Ren-Shiou Liu on 4/24/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView
@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger symbol;
@property (nonatomic) NSUInteger shading;
@property (nonatomic) NSUInteger color;
@property (nonatomic, getter = isMatched) BOOL matched;
@end
