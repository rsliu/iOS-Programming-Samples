//
//  PlayingCardView.m
//  SuperCard
//
//  Created by Ren-Shiou Liu on 2/5/14.
//  Copyright (c) 2014 National Cheng Kung University. All rights reserved.
//

#import "PlayingCardView.h"

@interface PlayingCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;
@end

@implementation PlayingCardView

#pragma mark - Properties

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

-(CGFloat)faceCardScaleFactor
{
    if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    return _faceCardScaleFactor;
}

-(void) setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor
{
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

-(void)setRank:(NSUInteger)rank
{
    _rank = rank;
    // Redraw the view when rank is changed
    [self setNeedsDisplay];
}

-(void)setSuit:(NSString *)suit
{
    _suit = suit;
    [self setNeedsDisplay];
}

-(void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)pinch:(UIPinchGestureRecognizer* )gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded) {
        self.faceCardScaleFactor *= gesture.scale;
        gesture.scale = 1.0;
    }
}

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

-(CGFloat) cornerScaleFactor {return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
-(CGFloat) cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
-(CGFloat) cornerOffset {return [self cornerRadius] / 3.0; }

- (NSString*) rankAsString
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"][self.rank];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    // Create a UIBezierPath and make it as big as possible and with a dynamic corner radius
    UIBezierPath* roundedRect =
        [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    // We don't want to draw outside of the rect
    [roundedRect addClip];
    
    // Set the background to white
    [[[UIColor whiteColor] colorWithAlphaComponent:(self.isMatched)?0.8:1.0] setFill]; // Set fill color
    UIRectFill(self.bounds); // Fill the rectangle
    
    // Draw boundary of the card
    [[UIColor blackColor] setStroke]; // Stroke
    [roundedRect stroke];
    
    // Load the image
    if (self.faceUp) {
        NSString* faceImageName =[NSString stringWithFormat:@"%@%@", [self rankAsString], self.suit];
        UIImage* faceImage = [UIImage imageNamed:faceImageName];
        if (faceImage) {
            // Create a rectangle to scale the image
            CGRect imageRect = CGRectInset(self.bounds,
                                           self.bounds.size.width * (1.0-self.faceCardScaleFactor),
                                           self.bounds.size.height * (1.0-self.faceCardScaleFactor));
            // Draw the image in the specified rect
            [faceImage drawInRect:imageRect blendMode:kCGBlendModeNormal alpha:(self.isMatched)? 0.3:1.0];
        } else {
            [self drawPips];
        }
        // Draw the corner
        [self drawCorners];
    } else {
        [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
    }
}

#pragma mark - Corners

-(void) drawCorners
{
    // Setup text alignment
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    // Setup the font
    UIFont* cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];
    
    // Create an attributed text for display at corners
    NSAttributedString* cornerText = [[NSAttributedString alloc]
                    initWithString:[NSString stringWithFormat:@"%@\n%@", [self rankAsString], self.suit]
                    attributes:@{NSFontAttributeName: cornerFont, NSParagraphStyleAttributeName: paragraphStyle}];
    
    // Create a rectangle to draw inside
    CGRect textBounds;
    textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    textBounds.size = [cornerText size];
    
    // Finally draw the text on the corner (upper left)
    [cornerText drawInRect:textBounds];
    
    // Draw the bottom right corner
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Changes the origin of the user coordinate system to the bottom right of the view
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    // Rotates the user coordinate system by 180 degree
    CGContextRotateCTM(context, M_PI);
    // Finally draw the corner again
    [cornerText drawInRect:textBounds];
}

#pragma mark - Pips

#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270

- (void)drawPips
{
    if ((self.rank == 1) || (self.rank == 5) || (self.rank == 9) || (self.rank == 3)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    if ((self.rank == 6) || (self.rank == 7) || (self.rank == 8)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    if ((self.rank == 2) || (self.rank == 3) || (self.rank == 7) || (self.rank == 8) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:PIP_VOFFSET2_PERCENTAGE
                        mirroredVertically:(self.rank != 7)];
    }
    if ((self.rank == 4) || (self.rank == 5) || (self.rank == 6) || (self.rank == 7) || (self.rank == 8) || (self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET3_PERCENTAGE
                        mirroredVertically:YES];
    }
    if ((self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET1_PERCENTAGE
                        mirroredVertically:YES];
    }
}

#define PIP_FONT_SCALE_FACTOR 0.012

- (void)pushContextAndRotateUpsideDown
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                          upsideDown:(BOOL)upsideDown
{
    // If we need to mirror, save the current context and translate the coordinate
    if (upsideDown) [self pushContextAndRotateUpsideDown];
    // Calculate the middle point of the view
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    // Create the font and stretch according to the view size
    UIFont *pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    pipFont = [pipFont fontWithSize:[pipFont pointSize] * self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
    // Create the attributed string for display
    NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:self.suit attributes:@{ NSFontAttributeName : pipFont }];
    // Compute the size of the attributed string
    CGSize pipSize = [attributedSuit size];
    // Compute where to display the pip
    CGPoint pipOrigin = CGPointMake(
                                    middle.x-pipSize.width/2.0-hoffset*self.bounds.size.width,
                                    middle.y-pipSize.height/2.0-voffset*self.bounds.size.height
                                    );
    // Draw the attributed string at the computed origin
    [attributedSuit drawAtPoint:pipOrigin];
    if (hoffset) {
        pipOrigin.x += hoffset*2.0*self.bounds.size.width;
        [attributedSuit drawAtPoint:pipOrigin];
    }
    // Finally, pop the saved context if any
    if (upsideDown) [self popContext];
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                  mirroredVertically:(BOOL)mirroredVertically
{
    [self drawPipsWithHorizontalOffset:hoffset
                        verticalOffset:voffset
                            upsideDown:NO];
    if (mirroredVertically) {
        [self drawPipsWithHorizontalOffset:hoffset
                            verticalOffset:voffset
                                upsideDown:YES];
    }
}


#pragma mark - Initialization // Group setup codes

-(void) setup
{
    // Stop the background from being white and opaque
    // including the rounded corners
    self.backgroundColor = nil;
    self.opaque = NO;
    // A flag used to determine how a view lays out its content when its bounds change
    // The UIViewContentModeRedraw option means that redisplay the view when the bounds
    // change by invoking the setNeedsDisplay method.
    self.contentMode = UIViewContentModeRedraw;
    
}

// We are gonna create the view from the storyboard
// So do the setup here in the awakeFromNib
-(void) awakeFromNib
{
    [self setup];
}
@end
