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
    [[[UIColor whiteColor] colorWithAlphaComponent:(self.isMatched)?0.8:1.0] setFill]; // Set fill color
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

- (UIColor*) colorAsObject
{
    return @[[UIColor clearColor] , [UIColor redColor], [UIColor greenColor], [UIColor purpleColor]][self.color];
}

- (UIBezierPath*) symbolAsPathInRect:(CGRect) rect
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    
    if (self.symbol == 1) {

    } else if (self.symbol == 2) {

    } else if (self.symbol == 3) {
        
    }
    
    return nil;
}

- (void)drawSymbolsWithVerticalOffset:(CGFloat)voffset
{
    // Calculate symbol width and height
    CGSize size;
    
    // Calculate the origin of the symbol
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGRect rect = {CGPointMake(middle.x - size.width / 2, middle.y - size.height / 2 - voffset*self.bounds.size.height), size};
    UIBezierPath *path = [self symbolAsPathInRect:rect];
    
    if (voffset) {
        rect.origin.y += 2.0 * voffset * self.bounds.size.height;
        [path moveToPoint:rect.origin];
    }

    // Set fill and stroke colors
    [[UIColor whiteColor] setFill];
    [[self colorAsObject] setStroke];
    
    // Fill and stroke the path
    [path fill];
    [path stroke];
}

@end
