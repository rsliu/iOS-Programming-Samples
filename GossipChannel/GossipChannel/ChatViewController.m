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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSThread *thread;
@end

@implementation ChatViewController

- (void) setupConnection
{
    CFReadStreamRef readStream = NULL;
    CFWriteStreamRef writeStream = NULL;
    if (self.address) {
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           (__bridge CFStringRef) self.address,
                                           (UInt32) self.port,
                                           &readStream,
                                           &writeStream);
        
        if (readStream && writeStream) {
            CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
            CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
            
            self.iStream = (__bridge NSInputStream *)readStream;
            self.iStream.delegate = self;
            [self.iStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [self.iStream open];
            self.oStream = (__bridge NSOutputStream *)writeStream;
            self.oStream.delegate = self;
            [self.oStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [self.oStream open];
        }

        while ([[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
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
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.textView.text = text;
                        NSRange bottom = NSMakeRange(self.textView.text.length -1, 1);
                        [self.textView scrollRangeToVisible:bottom];
                    });
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
            {
                if (aStream == self.oStream) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.textField.enabled = YES;
                    });
                }
            }
            break;
            
        case NSStreamEventEndEncountered:
            [aStream close];
            [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            break;
            
        case NSStreamEventHasSpaceAvailable:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.textField.text = @"";
                    self.textField.enabled = YES;
                });
            }
            break;
            
        case NSStreamEventNone:
            break;
    }
}

- (void) sendMessage
{
    if (self.oStream) {
        NSString* messageToSend = [[NSString alloc] initWithFormat:@"%@: %@\r\n", self.username, self.textField.text];
        NSData *data = [[NSData alloc] initWithData:[messageToSend dataUsingEncoding:NSASCIIStringEncoding]];
        [self.oStream write:[data bytes] maxLength:[data length]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textField.enabled = NO;
    self.textField.delegate = self;
    [self registerForKeyboardNotifications];
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(setupConnection) object:nil];
    [self.thread start];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.iStream close];
    [self.oStream close];
}

// To make text field dismissable
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    self.textField.enabled = NO;
    [self performSelector:@selector(sendMessage) onThread:self.thread withObject:nil waitUntilDone:false];
    return YES;
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.textField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.textField.frame animated:NO];
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
