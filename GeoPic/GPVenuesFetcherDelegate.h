//
// GPVenuesFetcherDelegate.h
//  GeoPic
//
//  Created by Manuel Wudka-Robles on 9/30/12.
//  Copyright (c) 2012 Palomino Labs, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GPVenuesFetcher;

@protocol GPVenuesFetcherDelegate

- (void)venusFetcher:(GPVenuesFetcher*)venuesFetcher didFetchVenues:(NSArray*)venues;

@end
