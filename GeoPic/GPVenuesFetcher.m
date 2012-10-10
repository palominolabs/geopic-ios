//
// GPVenuesFetcher.m
//  GeoPic
//
//  Created by Manuel Wudka-Robles on 9/30/12.
//  Copyright (c) 2012 Palomino Labs, Inc. All rights reserved.
//

#import "GPVenuesFetcher.h"
#import "GPVenue.h"

@implementation GPVenuesFetcher {
    NSString *_foursquareClientId;
    NSString *_foursquareSecretId;
    __weak id<GPVenuesFetcherDelegate> _delegate;
}

-(id)initWithDelegate:(id<GPVenuesFetcherDelegate>)delegate
{
    if(self = [super init]) {
        _delegate = delegate;
        
        _foursquareClientId = @"G1VAOKQBO0ALOV0WJ0F0CVRLQUABQN51VSCH5SDMHQ2KCHG5";
        _foursquareSecretId = @"B3IJ4NOQXQY1R2CMLN4Q5DY1TG210YS433TXD4EAWN5O5BKT";
        
    }
    return self;
}

- (void)dealloc
{
    [_foursquareClientId release];
    [_foursquareSecretId release];
    
    [super dealloc];
}

-(void)findVenuesNear:(CLLocationCoordinate2D)location
{
    NSString *queryURL = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?v=20120930&&limit=10&client_id=%@&client_secret=%@&ll=%f,%f", _foursquareClientId, _foursquareSecretId, location.latitude, location.longitude];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:queryURL]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [_delegate venusFetcher:self didFetchVenues:[self processResponse:JSON]];
    } failure:nil];
    
    [operation start];
}

-(NSArray *)processResponse:(id)JSON
{
    NSMutableArray *venues = [NSMutableArray array];
    NSArray *rawGroups = [JSON valueForKeyPath:@"response.groups.items.venue"];
    if (rawGroups.count > 0) {
        NSArray *rawVenues = rawGroups[0];
        for (NSDictionary *venueObject in rawVenues) {
            GPVenue *venue = [[GPVenue new] autorelease];
            venue.foursquareId = [venueObject valueForKeyPath:@"id"];
            venue.title = [venueObject valueForKey:@"name"];
            venue.subtitle = [NSString stringWithFormat:@"%d here now", [[venueObject valueForKeyPath:@"hereNow.count"] intValue]];
            venue.coordinate = CLLocationCoordinate2DMake([[venueObject valueForKeyPath:@"location.lat"] doubleValue], [[venueObject valueForKeyPath:@"location.lng"] doubleValue]);
            venue.category = [venueObject valueForKeyPath:@"categories.shortName"][0];
            venue.formattedPhone = [venueObject valueForKeyPath:@"contact.formattedPhone"];
            venue.checkinsCount = [[venueObject valueForKeyPath:@"stats.checkinsCount"] intValue];
            venue.website = venueObject[@"url"];
            [venues addObject:venue];
        }
    }
    return venues;
    
}

@end
