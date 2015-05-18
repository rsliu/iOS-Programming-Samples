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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UIButton *btnConnect;
@end

@implementation GossipViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.username.delegate = self;
    [self registerForKeyboardNotifications];
}

// To make text field dismissable
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    //[textField resignFirstResponder];
    [self performSegueWithIdentifier:@"connect" sender:self];
    return YES;
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

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*) aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // UIEdgeInsetMake(top, left, bottom, right)
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    if (!CGRectContainsPoint(aRect, self.btnConnect.frame.origin) ) {
        // setting animated to yes will not show the connect button
        [self.scrollView scrollRectToVisible:self.btnConnect.frame animated:NO];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*) aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

@end
