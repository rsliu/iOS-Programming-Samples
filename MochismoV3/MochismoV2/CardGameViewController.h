//
//  CardGameViewController.h
//  Mochismo
//
//  Created by Ren-Shiou Liu on 1/19/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game; // need a property for the model
@end
