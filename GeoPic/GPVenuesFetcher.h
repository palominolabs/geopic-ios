//
// GPVenuesFetcher.h
//  GeoPic
//
//  Created by Manuel Wudka-Robles on 9/30/12.
//  Copyright (c) 2012 Palomino Labs, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPVenuesFetcherDelegate.h"

@interface GPVenuesFetcher : NSObject<NSURLConnectionDataDelegate>

- (id)initWithDelegate:(id<GPVenuesFetcherDelegate>)delegate;

- (void)findVenuesNear:(CLLocationCoordinate2D)location;

- (NSArray *)processResponse:(id)JSON;

@end
