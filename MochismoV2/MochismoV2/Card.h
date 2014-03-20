//
//  Card.h
//  Mochismo
//
//  Created by Ren-Shiou Liu on 1/20/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString* contents;
@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;

- (int) match:(NSArray*) otherCard;

@end
