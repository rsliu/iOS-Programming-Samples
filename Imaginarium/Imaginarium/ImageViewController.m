//
//  ImageViewController.m
//  Imaginarium
//
//  Created by Ren-Shiou Liu on 3/9/14.
//  Copyright (c) 2014 Ren-Shiou Liu. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
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
    // The following line is going to block. we need to unblock it
    // We are going to display: http://images.apple.com/v/iphone-5s/gallery/a/images/download/photo_1.jpg
    self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]];
    self.scrollView.contentSize = self.image? self.image.size: CGSizeZero;
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
    self.imageView.image = image;
    [self.imageView sizeToFit];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    // Be sure to set the content size
    
    [self.scrollView addSubview:self.imageView]; // make sure the image view is on screen
}

@end
