//
// GPVenue.h
//  GeoPic
//
//  Created by Manuel Wudka-Robles on 9/30/12.
//  Copyright (c) 2012 Palomino Labs, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPVenue : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *foursquareId;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, copy) NSString *category;

@property (nonatomic, assign) int checkinsCount;

@property (nonatomic, copy) NSString *formattedPhone;

@property (nonatomic, copy) NSString *website;

@end
