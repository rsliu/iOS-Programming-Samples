//
//  CardGameViewController.m
//  Mochismo
//
//  Created by Ren-Shiou Liu on 1/19/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "CardGameViewController.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic) int count;
@end

@implementation CardGameViewController
- (IBAction)doFlipCard:(UIButton *)sender {
    if ([sender.currentTitle length]) {
        [sender setBackgroundImage:[UIImage imageNamed:@"stanford"] forState:UIControlStateNormal];
    
        [sender setTitle:@"" forState:UIControlStateNormal];
    } else {
        [sender setBackgroundImage:[UIImage imageNamed:@"BlankCard"] forState:UIControlStateNormal];
        
        [sender setTitle:@"A♣︎" forState:UIControlStateNormal];
    }
    self.count++;
}

- (void) setCount:(int)count {
   _count = count;
    [self.label setText:[NSString stringWithFormat:@"Flips: %d", self.count]];
}
@end
