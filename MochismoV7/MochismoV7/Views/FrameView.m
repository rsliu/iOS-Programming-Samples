//
//  FrameView.m
//  MochismoV7
//
//  Created by Ren-Shiou Liu on 5/29/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "FrameView.h"

@implementation FrameView

static NSString * const FrameBorderImageName = @"FrameBorder";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:FrameBorderImageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = self.bounds;
        [self addSubview:imageView];
    }
    return self;
}

@end
