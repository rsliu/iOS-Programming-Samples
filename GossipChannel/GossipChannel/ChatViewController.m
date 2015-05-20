//
//  ChatViewController.m
//  GossipChannel
//
//  Created by Ren-Shiou Liu on 5/19/15.
//  Copyright (c) 2015 National Cheng Kung University. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController () <UITextFieldDelegate, NSStreamDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) NSInputStream *iStream;
@property (nonatomic) NSOutputStream *oStream;
@property (strong, nonatomic) NSOperationQueue *queue;
@end

@implementation ChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textField.delegate = self;
    [self registerForKeyboardNotifications];
    self.textField.enabled = false;
    [self.queue addOperationWithBlock:^{
        [self setupConnection];
    }];
}

-(NSOperationQueue*) queue {
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    
    return _queue;
}

- (void) setupConnection
{
    if (self.address) {
        NSInputStream* iStream = nil;
        NSOutputStream* oStream = nil;

        [NSStream getStreamsToHostWithName:self.address port:self.port inputStream:&iStream outputStream:&oStream];
        
        if (iStream && oStream) {
            self.iStream = iStream;
            self.iStream.delegate = self;
            [self.iStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            [self.iStream open];
            
            self.oStream = oStream;
            self.oStream.delegate = self;
            [self.oStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            [self.oStream open];
        }
    }
}

#define MAX_BUFFER_SIZE 1024

// Stream event handler
-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
        case NSStreamEventHasBytesAvailable:
        {
            // Data available for read
            [self.queue addOperationWithBlock:^{
                NSInteger length;
                uint8_t buffer[MAX_BUFFER_SIZE];
                NSMutableString *text = [[NSMutableString alloc] initWithString:self.textView.text];
                
                while([(NSInputStream *) aStream hasBytesAvailable]) {
                    length = [(NSInputStream *) aStream read:buffer maxLength:MAX_BUFFER_SIZE];
                    NSString *string = [[NSString alloc] initWithBytes:buffer length:length encoding:NSASCIIStringEncoding];
                    [text appendString:string];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.textView.text = text;
                    NSRange bottom = NSMakeRange(self.textView.text.length -1, 1);
                    [self.textView scrollRangeToVisible:bottom];
                });
            }];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// To make text field dismissable
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.textField.enabled = NO;
    [self.queue addOperationWithBlock:^{
        [self sendMessage];
    }];
    return YES;
}

- (void) sendMessage
{
    if (self.oStream) {
        NSString* messageToSend = [[NSString alloc] initWithFormat:@"%@: %@\r\n", self.username, self.textField.text];
        NSData *data = [[NSData alloc] initWithData:[messageToSend dataUsingEncoding:NSASCIIStringEncoding]];
        [self.oStream write:[data bytes] maxLength:[data length]];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.iStream close];
    [self.oStream close];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
