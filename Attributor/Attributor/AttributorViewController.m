//
//  AttributorViewController.m
//  Attributor
//
//  Created by Ren-Shiou Liu on 1/23/14.
//  Copyright (c) 2014 National Cheng Kung University. All rights reserved.
//

#import "AttributorViewController.h"

@interface AttributorViewController ()
@property (weak, nonatomic) IBOutlet UITextView *body;
@property (weak, nonatomic) IBOutlet UILabel *headline;
@property (weak, nonatomic) IBOutlet UIButton *outlineButton;

@end

@implementation AttributorViewController

// Part 1
- (IBAction)changeBodySelectionColorToMatchBackgoundOfButton:(UIButton *)sender {
    [self.body.textStorage addAttribute:NSForegroundColorAttributeName value:sender.backgroundColor range:self.body.selectedRange];
}

- (IBAction)outlineBodySelection {
    [self.body.textStorage addAttributes:@{NSStrokeWidthAttributeName: @-3, NSStrokeColorAttributeName: [UIColor blackColor]} range:self.body.selectedRange];
}

- (IBAction)unoutlineBodySelection {
    [self.body.textStorage removeAttribute:NSStrokeWidthAttributeName range:self.body.selectedRange];
}


// Part 2 - view controller life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Add outline to the title
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:self.outlineButton.currentTitle ];
    [title setAttributes: @{NSStrokeWidthAttributeName: @3,
                    NSStrokeColorAttributeName: self.outlineButton.tintColor}
                    range:NSMakeRange(0, [title length])];
    [self.outlineButton setAttributedTitle:title forState:UIControlStateNormal]; // Change font to bold to make the outline more obvious
}

// Part 3 - radio thing
-(void) viewWillAppear:(BOOL)animated {
    // Let's tune in radio in viewWillAppear
    [super viewWillAppear:animated];
    [self usePreferredFonts]; // Make sure we are using the preferred fonts after reappearing
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferredFontsChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

-(void) preferredFontsChanged:(NSNotification*) notification {
    [self usePreferredFonts];
}

-(void) usePreferredFonts {
    self.body.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.headline.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
}

-(void) viewWillDisappear:(BOOL)animated {
    // Remove observer in viewWillDisapper
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
}

@end
