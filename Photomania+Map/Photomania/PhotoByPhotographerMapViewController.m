//
//  PhotoByPhotographerMapViewController.m
//  Photomania
//
//  Created by Ren-Shiou Liu on 6/9/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import "PhotoByPhotographerMapViewController.h"
#import <MapKit/MapKit.h>
#import "Photo.h"
#import "ImageViewController.h"

@interface PhotoByPhotographerMapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSArray *photosByPhotographer;
@end

@implementation PhotoByPhotographerMapViewController

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *reusedId = @"PhotoByPhotographerMapViewController";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:reusedId];
    
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reusedId];
        view.canShowCallout = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
        view.leftCalloutAccessoryView = imageView;
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundImage:[UIImage imageNamed:@"disclosure"] forState:UIControlStateNormal];
        [button sizeToFit];
        view.rightCalloutAccessoryView = button;
    }
    
    view.annotation = annotation;
    
    return view;
}

-(void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [self updateLeftCalloutAccessoryViewInAnnotationView:view];
}

-(void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"Show Photo" sender:view];
}

-(void) prepareViewController:(id) vc forSegue:(NSString*) segueId toShowAnnotation:(id<MKAnnotation>) annotation
{
    Photo *photo = nil;
    
    if ([annotation isKindOfClass:[Photo class]]) {
        photo = (Photo*) annotation;
    }
    
    if (photo) {
        if (![segueId length] || [segueId isEqualToString:@"Show Photo"]) {
            if ([vc isKindOfClass:[ImageViewController class]]) {
                ImageViewController *ivc = (ImageViewController *) vc;
                ivc.imageURL = [NSURL URLWithString:photo.imageURL];
                ivc.title = photo.title;
            }
        }
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[MKAnnotationView class]]) {
        [self prepareViewController:segue.destinationViewController
                           forSegue:segue.identifier
                   toShowAnnotation:((MKAnnotationView*)sender).annotation];
    }
}

-(void) updateLeftCalloutAccessoryViewInAnnotationView:(MKAnnotationView *) annotationView
{
    UIImageView *imageView = nil;
    
    if ([annotationView.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
        imageView = (UIImageView *) annotationView.leftCalloutAccessoryView;
    }
    
    if (imageView) {
        Photo *photo = nil;
        
        if ([annotationView.annotation isKindOfClass:[Photo class]]) {
            photo = (Photo*) annotationView.annotation;
        }
        if (photo) {
            imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo.thumnailURL]]];
        }
    }
}

-(void) updateMapViewAnnotations
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.photosByPhotographer];
    [self.mapView showAnnotations:self.photosByPhotographer animated:YES];
}

-(void) setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    self.mapView.delegate = self;
    [self updateMapViewAnnotations];
}

-(void) setPhotographer:(Photographer *)photographer
{
    _photographer = photographer;
    self.title = photographer.name;
    self.photosByPhotographer = nil;
    [self updateMapViewAnnotations];
}

-(NSArray*) photosByPhotographer
{
    if (!_photosByPhotographer) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.predicate = [NSPredicate predicateWithFormat:@"whoTook = %@", self.photographer];
        _photosByPhotographer = [self.photographer.managedObjectContext executeFetchRequest:request error:NULL];
    }
    
    return _photosByPhotographer;
}
@end
