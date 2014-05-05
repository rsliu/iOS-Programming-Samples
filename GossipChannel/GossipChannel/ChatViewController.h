//
//  ChatViewController.h
//  GossipChannel
//
//  Created by Ren-Shiou Liu on 5/5/14.
//  Copyright (c) 2014 National Cheng Kung University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController :  UIViewController<NSStreamDelegate, UITextFieldDelegate>
@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* address;
@property (nonatomic) NSUInteger port;
@end
