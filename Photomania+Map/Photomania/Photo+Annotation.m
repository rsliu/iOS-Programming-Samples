//
//  Photo+Annotation.m
//  Photomania
//
//  Created by Ren-Shiou Liu on 6/9/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import "Photo+Annotation.h"

@implementation Photo (Annotation)

- (CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D coordinate;
    
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    
    return coordinate;
}

@end
