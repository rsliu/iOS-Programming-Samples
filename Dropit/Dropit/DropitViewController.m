//
//  DropitViewController.m
//  Dropit
//
//  Created by Ren-Shiou Liu on 2/21/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "DropitViewController.h"
#import "DropitBehavior.h"

@interface DropitViewController () <UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) DropitBehavior *dropit;
@end

@implementation DropitViewController
- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self drop];
}

- (void) dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self removeCompletedRows];
}

- (BOOL) removeCompletedRows
{
    NSMutableArray *dropsToRemove = [[NSMutableArray alloc] init];
    
    for (CGFloat y = self.gameView.bounds.size.height-DROP_SIZE.height/2; y > 0; y-= DROP_SIZE.height) {
        
        BOOL rowsCompleted = YES;
        NSMutableArray* dropsFound = [[NSMutableArray alloc] init];
       
        for (CGFloat x = DROP_SIZE.width/2; x <= self.gameView.bounds.size.width- DROP_SIZE.width/2; x+= DROP_SIZE.width) {
            UIView *hitView = [self.gameView hitTest:CGPointMake(x,y) withEvent:NULL];
            if ([hitView superview] == self.gameView) {
                [dropsFound addObject:hitView];
            } else {
                rowsCompleted = NO;
                break;
            }
        }
        
        if (![dropsFound count]) break;
        if (rowsCompleted) [dropsToRemove addObjectsFromArray:dropsFound];
    }
    
    // Remove the squares
    if ([dropsToRemove count]) {
        for(UIView *drop in dropsToRemove) {
            [self.dropit removeItem:drop];
        }
        [self animateRemovingDrops: dropsToRemove];
    }
    
    return NO;
}

- (void) animateRemovingDrops:(NSArray*) dropsToRemove
{
    [UIView animateWithDuration:1.0 animations:^{
        for(UIView *drop in dropsToRemove) {
            int x = (arc4random()%(int)(self.gameView.bounds.size.width*5)) - (int) self.gameView.bounds.size.width*2;
            int y = self.gameView.bounds.size.height;
            drop.center = CGPointMake(x, -y);
        }
    }
    completion:^(BOOL finished) {
        [dropsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }];
}

- (void) dynamicAnimatorWillResume:(UIDynamicAnimator *)animator
{
    
}

- (UIDynamicAnimator*) animator
{
    // Init the animator with the reference view
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.gameView];
        _animator.delegate = self;
    }
    
    return _animator;
}

-(DropitBehavior*) dropit
{
    if (!_dropit) {
        _dropit = [[DropitBehavior alloc] init];
        [self.animator addBehavior:_dropit];
    }
    
    return _dropit;
}

static const CGSize DROP_SIZE = {40, 40};

- (void) drop
{
    // Create the frame first
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = DROP_SIZE;
    
    // Pick a random place
    int x = (arc4random()%(int)self.gameView.bounds.size.width)/DROP_SIZE.width;
    frame.origin.x = x * DROP_SIZE.width;
    
    // Create a view using the frame
    UIView *dropView = [[UIView alloc] initWithFrame:frame];
    dropView.backgroundColor = [self randomColor];
    [self.gameView addSubview:dropView];
    
    [self.dropit addItem:dropView];
}

- (UIColor*) randomColor
{
    switch (arc4random()%5) {
        case 0: return [UIColor greenColor];
        case 1: return [UIColor blueColor];
        case 2: return [UIColor orangeColor];
        case 3: return [UIColor redColor];
        case 4: return [UIColor purpleColor];
    }
    return [UIColor blackColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
