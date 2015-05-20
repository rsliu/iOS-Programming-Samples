//
//  ChatViewController.h
//  GossipChannel
//
//  Created by Ren-Shiou Liu on 5/19/15.
//  Copyright (c) 2015 National Cheng Kung University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController
@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* address;
@property (nonatomic) NSUInteger port;
@end
