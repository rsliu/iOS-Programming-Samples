//
//  CustomActionSheet.h
//  BlockDemo
//
//  Created by Ren-Shiou Liu on 4/27/15.
//  Copyright (c) 2015 National Cheng Kung University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomActionSheet : NSObject <UIActionSheetDelegate>
-(void) actionSheet:(UIActionSheet *)actionSheet
        clickedButtonAtIndex:(NSInteger)buttonIndex;
-(id)initWithTitle:(NSString *)title delegate:(id)delegate
        cancelButtonTitle:(NSString *)cancelButtonTitle
        destructiveButtonTitle:(NSString*)destructiveButtonTitle
        otherButtonTitles:(NSString *)otherButtonTitles, ...;
-(void)showInView:(UIView *)view
        withCompletionHandler:(void(^)(NSString *buttonTitle, NSInteger buttonIndex))handler;
@end
