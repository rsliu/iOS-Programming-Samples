//
//  CardGameViewController.h
//  Mochismo
//
//  Created by Ren-Shiou Liu on 1/19/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController
-(Deck*) createDeck; // abstract, protected for subclass
@end
