//
//  ViewController.m
//  BlockDemo
//
//  Created by Ren-Shiou Liu on 4/27/15.
//  Copyright (c) 2015 National Cheng Kung University. All rights reserved.
//

#import "ViewController.h"
#import "CustomActionSheet.h"

@interface ViewController ()
@property (nonatomic, strong) CustomActionSheet *customActionSheet;
@end

@implementation ViewController

- (IBAction)showActionSheet:(UIButton *)sender
{
    _customActionSheet = [[CustomActionSheet alloc] initWithTitle:@"Block Demo"
                            delegate:nil
                            cancelButtonTitle:@"Cancel"
                            destructiveButtonTitle:nil
                            otherButtonTitles:@"Option 1", @"Option 2", @"Option 3", nil];
    
    [_customActionSheet showInView:self.view
             withCompletionHandler:^(NSString *buttonTitle, NSInteger buttonIndex) {
                 NSLog(@"You tapped the button in index: %d", (int)buttonIndex);
                 NSLog(@"Your selection is: %@", buttonTitle);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
