//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Ren-Shiou Liu on 2/5/14.
//  Copyright (c) 2014 National Cheng Kung University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView
@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;
-(void) pinch:(UIPinchGestureRecognizer*) gesture;
@end
