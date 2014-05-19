//
//  GossipViewController.m
//  GossipChannel
//
//  Created by Ren-Shiou Liu on 5/5/14.
//  Copyright (c) 2014 National Cheng Kung University. All rights reserved.
//

#import "GossipViewController.h"
#import "ChatViewController.h"

@interface GossipViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@end

@implementation GossipViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.username setDelegate:self];
}

// To make text field dismissable
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    //[textField resignFirstResponder];
    [self performSegueWithIdentifier:@"connect" sender:self];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{ self.view.frame = CGRectOffset(self.view.frame, 0, -80); } completion:nil];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{ self.view.frame = CGRectOffset(self.view.frame, 0, 80); } completion:nil];
}

-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return (![self.username.text isEqualToString:@""]);
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"connect"]) {
        if ([segue.destinationViewController isKindOfClass:[ChatViewController class]]) {
            ChatViewController* cmvc = (ChatViewController*) segue.destinationViewController;
            cmvc.username = self.username.text;
            cmvc.address = [[NSString alloc] initWithFormat:@"127.0.0.1"];
            cmvc.port = 8888;
        }
    }
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self.username resignFirstResponder];
}

@end
