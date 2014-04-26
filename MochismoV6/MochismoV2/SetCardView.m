//
//  SetCardView.m
//  MochismoV5
//
//  Created by Ren-Shiou Liu on 4/24/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Setter
-(void) setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

-(void) setSymbol:(NSUInteger)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

-(void) setColor:(NSUInteger)color
{
    _color = color;
    [self setNeedsDisplay];
}

-(void) setShading:(NSUInteger)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

-(CGFloat) cornerScaleFactor {return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
-(CGFloat) cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
-(CGFloat) cornerOffset {return [self cornerRadius] / 3.0; }

- (void)drawRect:(CGRect)rect
{
    // Create a UIBezierPath and make it as big as possible and with a dynamic corner radius
    UIBezierPath* roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    // We don't want to draw outside of the rect
    [roundedRect addClip];
    
    // Set the background to white
    [[[UIColor whiteColor] colorWithAlphaComponent:(self.isChosen)?0.5:1.0] setFill]; // Set fill color
    UIRectFill(self.bounds); // Fill the rectangle
    
    // Draw boundary of the card
    [[UIColor blackColor] setStroke]; // Stroke
    [roundedRect stroke];
    
    [self drawSymbols];
}

#define SYMBOL_VOFFSET1_PERCENTAGE 0.090
#define SYMBOL_VOFFSET2_PERCENTAGE 0.175
#define SYMBOL_VOFFSET3_PERCENTAGE 0.270

#pragma mark - Pips

- (void)drawSymbols
{
    if ((self.number == 1) || (self.number == 3)) {
        [self drawSymbolsWithVerticalOffset:0];
    }
    if ((self.number == 2) || (self.number == 3)) {
        [self drawSymbolsWithVerticalOffset:(self.number == 2)? SYMBOL_VOFFSET2_PERCENTAGE:SYMBOL_VOFFSET3_PERCENTAGE];
    }
}

- (void)pushContext
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (UIColor*) colorAsObject
{
    return @[[UIColor clearColor] , [UIColor redColor], [UIColor greenColor], [UIColor purpleColor]][self.color];
}

- (UIBezierPath*) symbolAsPathInRect:(CGRect) rect
{
    UIBezierPath *path;
    
    if (self.symbol == 1) { // Oval
        path = [UIBezierPath bezierPathWithOvalInRect:rect];
        return path;
    } else if (self.symbol == 2) { // Diamond
        path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y)];
        [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height / 2)];
        [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height)];
        [path addLineToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height / 2)];
        [path closePath];
        return path;
    } else if (self.symbol == 3) { //squiggle
        path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height)];
        [path addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y)
                controlPoint1:CGPointMake(rect.origin.x + rect.size.width / 4, rect.origin.y - rect.size.height)
                controlPoint2:CGPointMake(rect.origin.x + 3 * rect.size.width / 4, rect.origin.y + rect.size.height / 2)];
        
        [path moveToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y)];
        [path addCurveToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height)
                controlPoint1:CGPointMake(rect.origin.x + 3* rect.size.width / 4, rect.origin.y + 2 * rect.size.height)
                controlPoint2:CGPointMake(rect.origin.x + rect.size.width / 4, rect.origin.y + rect.size.height / 2)];
        return path;
    }
    
    return nil;
}

#define SYMBOL_WIDTH_SCALE_FACTOR 0.6
#define SYMBOL_HEIGHT_SCALE_FACTOR 0.125

- (void)drawSymbolsWithVerticalOffset:(CGFloat) voffset
{
    // Calculate symbol width and height
    CGSize size = CGSizeMake(self.bounds.size.width * SYMBOL_WIDTH_SCALE_FACTOR,
                             self.bounds.size.height * SYMBOL_HEIGHT_SCALE_FACTOR);
    
    // Calculate the origin of the symbol
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGRect rect = {CGPointMake(middle.x - size.width / 2, middle.y - size.height / 2 - voffset*self.bounds.size.height), size};
    UIBezierPath *path = [self symbolAsPathInRect:rect];
    
    if (voffset) {
        rect.origin.y += 2.0 * voffset * self.bounds.size.height;
        [path appendPath:[self symbolAsPathInRect:rect]];
    }
    
    [self drawShadingInPath:path];

    // Stroke
    [[[self colorAsObject] colorWithAlphaComponent:(self.isChosen)? 0.5:1] setStroke];
    [path stroke];
}

#define STRIP_DISTANCE_FACTOR 20

-(void) drawShadingInPath:(UIBezierPath*) path
{
    [self pushContext];
    [path addClip];
    
    if (self.shading == 1) {
        // fill with solid color
        [[[self colorAsObject] colorWithAlphaComponent:(self.isChosen)? 0.5:1] setFill];
        [path fill];
    } else if (self.shading == 2) {
        // draw strips
        UIBezierPath* stripPath = [[UIBezierPath alloc] init];
        CGFloat dist = self.bounds.size.width / STRIP_DISTANCE_FACTOR;
        CGPoint point = CGPointMake(0, 0);
        
        while(point.x < self.bounds.size.width) {
            [stripPath moveToPoint:point];
            [stripPath addLineToPoint:CGPointMake(point.x, self.bounds.size.height)];
            point.x += dist;
        }
        
        [[[self colorAsObject] colorWithAlphaComponent:(self.isChosen)? 0.5:1] setStroke];
        [stripPath stroke];
    }
    [self popContext];
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
