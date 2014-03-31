//
//  ImageViewController.m
//  Imaginarium
//
//  Created by Ren-Shiou Liu on 3/9/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation ImageViewController

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    // To allow zooming
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;
    
    // We need to do this because the view is not ready when doing preparingSegue
    self.scrollView.contentSize = self.image? self.image.size: CGSizeZero;
}

- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void) setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self startDownloadingImage];
}

- (void) startDownloadingImage
{
    self.image = nil;
    if (self.imageURL) {
        [self.spinner startAnimating];
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                          completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                              if (!error) {
                                                  if ([request.URL isEqual:self.imageURL]) {
                                                      // in case we change URL before the previous task is outstanding
                                                      UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                                                      dispatch_async(dispatch_get_main_queue(), ^{ self.image = image;});
                                                  }
                                              }
                                          }];
        [task resume];
    }
}


- (UIImageView*) imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] init];
    return _imageView;
}

- (UIImage*) image
{
    return self.imageView.image;
}

- (void) setImage:(UIImage *)image
{
    // Note we don't have to synthesize to an instance variable
    self.scrollView.zoomScale = 1.0;
    
    self.imageView.image = image;
    // [self.imageView sizeToFit];
    self.imageView.frame = CGRectMake(0,0,image.size.width, image.size.height);
    
    [self.spinner stopAnimating];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // make sure the image view is on screen
    [self.scrollView addSubview:self.imageView];
}

#pragma mark - UISplitViewControllerDelegate

-(void) awakeFromNib
{
    self.splitViewController.delegate = self;
}

-(BOOL) splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

-(void) splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = aViewController.title;
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

-(void) splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.leftBarButtonItem = nil;
}
@end
