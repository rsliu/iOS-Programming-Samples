//
//  Photo.h
//  Photomania
//
//  Created by Ren-Shiou Liu on 6/9/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photographer;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * thumnailURL;
@property (nonatomic, retain) Photographer *whoTook;

@end
