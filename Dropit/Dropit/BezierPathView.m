//
//  BezierPathView.m
//  Dropit
//
//  Created by Ren-Shiou Liu on 3/3/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "BezierPathView.h"

@implementation BezierPathView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setPath:(UIBezierPath *)path
{
    _path = path;
    // This will make the system call drawRect and update the view
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self.path stroke];
}


@end
