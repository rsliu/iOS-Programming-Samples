//
//  ViewController.m
//  AlertDemo
//
//  Created by Ren-Shiou Liu on 4/27/15.
//  Copyright (c) 2015 National Cheng Kung University. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UIAlertController * alert;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)showAlert:(UIButton *)sender {
    self.alert = [UIAlertController
                         alertControllerWithTitle:@"Info"
                         message:@"You are using UIAlertController"
                         preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self.alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    UIAlertAction* cancel = [UIAlertAction
                         actionWithTitle:@"Cancel"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self.alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [self.alert addAction:ok];
    [self.alert addAction:cancel];
    
    [self presentViewController:self.alert animated:YES completion:nil];
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* username = textField.text;
    ((UIAlertAction*)self.alert.actions.firstObject).enabled =
        (username.length > 0);
    
    return true;
}

- (IBAction)showLogin:(id)sender {
    self.alert = [UIAlertController
                        alertControllerWithTitle:@"Login"
                        message:@"Enter User Credentials"
                        preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok =
        [UIAlertAction actionWithTitle:@"OK"
                style:UIAlertActionStyleDefault
                handler:^(UIAlertAction * action) {
                    NSString* username =
                        ((UITextField*) [self.alert.textFields objectAtIndex:0]).text;
                    NSString* passwd =
                        ((UITextField*) [self.alert.textFields objectAtIndex:1]).text;
                    NSLog(@"Login using name: %@ and passwd: %@", username, passwd);
                }];
    ok.enabled = false;
    
    UIAlertAction* destructive =
        [UIAlertAction actionWithTitle:@"Forgot Password"
                style:UIAlertActionStyleDestructive
                handler:^(UIAlertAction * action) {
                    NSLog(@"User forgot her password!");
                }];
    
    UIAlertAction* cancel =
        [UIAlertAction actionWithTitle:@"Cancel"
                style:UIAlertActionStyleDefault
                handler:nil];
    
    [self.alert addAction:ok];
    [self.alert addAction:destructive];
    [self.alert addAction:cancel];
    
    __weak id<UITextFieldDelegate> weakSelf = self;
    [self.alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Username";
        textField.delegate = weakSelf;
    }];

    [self.alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
    }];
    
    [self presentViewController:self.alert animated:YES completion:nil];
}

- (IBAction)showAction:(UIButton *)sender {
    self.alert = [UIAlertController
                  alertControllerWithTitle:@"Actions"
                  message:@"Choose an action"
                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 1; i <= 5; i++) {
        UIAlertAction* action = [UIAlertAction
                actionWithTitle:[NSString stringWithFormat:@"Option %d", i]
                style:UIAlertActionStyleDefault
                handler:^(UIAlertAction * action)
                {
                     [self.alert dismissViewControllerAnimated:YES completion:nil];
                     
                }];
        [self.alert addAction:action];
    }
    
    [self presentViewController:self.alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
