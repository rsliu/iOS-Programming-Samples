//
//  TextStatsViewController.m
//  AttributorV2
//
//  Created by Ren-Shiou Liu on 2/4/14.
//  Copyright (c) 2014 National Cheng Kung University. All rights reserved.
//

#import "TextStatsViewController.h"

@interface TextStatsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *colorfulCharactersLabel;
@property (weak, nonatomic) IBOutlet UILabel *outlinedCharactersLabel;
@end

@implementation TextStatsViewController

// for testing
/*-(void) viewDidLoad
{
    [super viewDidLoad];
    self.textToAnalyze = [[NSAttributedString alloc] initWithString:@"test" attributes:@{NSForegroundColorAttributeName: [UIColor greenColor],                                                                                                                                                            NSStrokeWidthAttributeName: @-3}];
}*/

-(void)setTextToAnalyze:(NSAttributedString *)textToAnalyze
{
    _textToAnalyze = textToAnalyze;
    if (self.view.window) [self updateUI]; // only if I am on screen
}

// Another place where we should update the UI
// This is because textToAnalyze might be set while we are invisible
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

-(void) updateUI
{
    self.colorfulCharactersLabel.text = [NSString stringWithFormat:@"%d colorful characters", [[self charactersWithAttributes:NSForegroundColorAttributeName] length]];
    self.outlinedCharactersLabel.text = [NSString stringWithFormat:@"%d outlined characters", [[self charactersWithAttributes:NSStrokeWidthAttributeName] length]];
}

// Method that really does the analysis
-(NSAttributedString*) charactersWithAttributes:(NSString*) attributeName
{
    NSMutableAttributedString* characters = [[NSMutableAttributedString alloc] init];
    
    int index = 0;
    while(index < [self.textToAnalyze length]) {
        NSRange range;
        // an id because it could be font/color/etc...
        id value = [self.textToAnalyze
                    attribute:attributeName atIndex:index
                    effectiveRange:&range];
        if (value) {
            [characters appendAttributedString:[self.textToAnalyze attributedSubstringFromRange:range]];
            index = range.location + range.length;
        } else {
            index++;
        }
    }
    return characters;
}

@end
