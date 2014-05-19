//
//  ChatViewController.m
//  GossipChannel
//
//  Created by Ren-Shiou Liu on 5/5/14.
//  Copyright (c) 2014 National Cheng Kung University. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController()
@property (nonatomic) CFHostRef host;
@property (strong, nonatomic) NSInputStream *iStream;
@property (strong, nonatomic) NSOutputStream *oStream;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation ChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) setupConnection
{
    CFReadStreamRef readStream = NULL;
    CFWriteStreamRef writeStream = NULL;
    
    self.textField.enabled = NO;
    
    if (self.address) {
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           (__bridge CFStringRef) self.address,
                                           self.port,
                                           &readStream,
                                           &writeStream);
        
        if (readStream && writeStream) {
            CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
            CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
            
            self.iStream = (__bridge NSInputStream *)readStream;
            [self.iStream setDelegate:self];
            [self.iStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [self.iStream open];
            
            self.oStream = (__bridge NSOutputStream *)writeStream;
            [self.oStream setDelegate:self];
            [self.oStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [self.oStream open];
        }
    }
}

// Stream event handler
-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    uint8_t buf[1024];
    NSInteger len = 0;
    
    switch (eventCode) {
        case NSStreamEventHasBytesAvailable:
            {
                // Data received
                len = [(NSInputStream *) aStream read:buf maxLength:1024];
                if (len) {
                    NSMutableString *text = [[NSMutableString alloc] initWithString:self.textView.text];
                    NSString *newMessage = [[NSString alloc] initWithBytes:buf length:len encoding:NSASCIIStringEncoding];
                    [text appendString:newMessage];
                    self.textView.text = text;
                    NSRange bottom = NSMakeRange(self.textView.text.length -1, 1);
                    [self.textView scrollRangeToVisible:bottom];
                }
            }
            break;
            
        case NSStreamEventErrorOccurred:
            {
                // Error
                NSLog(@"Cannot connect to the server");
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
            
        case NSStreamEventOpenCompleted:
            break;
            
        case NSStreamEventEndEncountered:
            [aStream close];
            [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            break;
            
        case NSStreamEventHasSpaceAvailable:
            {
                self.textField.text = @"";
                self.textField.enabled = YES;
            }
            break;
        case NSStreamEventNone:
            break;
    }
}

- (void)sendMessage
{
    if (self.oStream) {
        NSString* messageToSend = [[NSString alloc] initWithFormat:@"%@: %@\r\n", self.username, self.textField.text];
        NSData *data = [[NSData alloc] initWithData:[messageToSend dataUsingEncoding:NSASCIIStringEncoding]];
        [self.oStream write:[data bytes] maxLength:[data length]];
        self.textField.enabled = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupConnection];
    [self.textField setEnabled:NO];
    [self.textField setDelegate:self];
}
-(void) viewWillDisappear:(BOOL)animated
{
    [self.iStream close];
    [self.oStream close];
}

// To make text field dismissable
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self sendMessage];
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{ self.view.frame = CGRectOffset(self.view.frame, 0, -240); } completion:nil];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{ self.view.frame = CGRectOffset(self.view.frame, 0, 240); } completion:nil];
}
@end
