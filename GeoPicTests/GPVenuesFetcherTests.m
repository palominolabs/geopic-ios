//
// GPVenuesFetcherTests.m
//  GeoPic
//
//  Created by Manuel Wudka-Robles on 10/4/12.
//  Copyright (c) 2012 Palomino Labs, Inc. All rights reserved.
//

#import "GPVenuesFetcherTests.h"
#import "GPVenuesFetcher.h"
#import "GPVenue.h"

@implementation GPVenuesFetcherTests {
    GPVenuesFetcher *_venuesFetcher;
}

- (void)setUp
{
    _venuesFetcher = [GPVenuesFetcher new];
}

- (void)tearDown
{
    [_venuesFetcher release];
}

- (void)test_processResponse_ReturnsEmptyArray_ForEmptyResponse
{
    NSArray *result = [_venuesFetcher processResponse:nil];
    
    STAssertEqualObjects(@[], result, @"");
}

- (void)test_processResponse_ReturnsEmptyArray_ForNoMatches
{
    NSArray *result = [_venuesFetcher processResponse:@{@"response":@{@"groups":@[]}}];
    
    STAssertEqualObjects(@[], result, @"");
}

- (void)test_processResponse_ReturnsVenues_ForTypicalResponse
{
    NSArray *result = [_venuesFetcher processResponse:@{@"response": @{
                       @"groups":@[
                       @{@"items":@[
                       @{@"venue":@{
                       @"id":@"venue_1",
                       @"name":@"The Venue Name",
                       @"stats":@{@"checkinsCount":@1234},
                       @"url":@"example.com",
                       @"location":@{
                       @"lat":@123,
                       @"lng":@456
                       },
                       @"contact":@{@"formattedPhone":@"123-456-7777"},
                       @"categories":@[@{@"shortName":@"Snacks"}]
                       }},
                       ]
                       }]}}];
    
    STAssertEquals((NSUInteger)1, result.count, @"");
    GPVenue *v = result[0];
    STAssertEqualObjects(@"venue_1", v.foursquareId, @"");
    STAssertEquals(1234, v.checkinsCount, @"");
    STAssertEqualObjects(@"The Venue Name", v.title, @"");
    STAssertEqualObjects(@"Snacks", v.category, @"");
    STAssertEqualObjects(@"example.com", v.website, @"");
    STAssertEquals(123.0, v.coordinate.latitude, @"");
    STAssertEquals(456.0, v.coordinate.longitude, @"");
    STAssertEqualObjects(@"123-456-7777", v.formattedPhone, @"");
}

- (void)test_processResponse_ReturnsVenue_IfNoURL
{
    NSArray *result = [_venuesFetcher processResponse:@{@"response": @{
                       @"groups":@[
                       @{@"items":@[
                       @{@"venue":@{
                       @"id":@"venue_1",
                       @"name":@"The Venue Name",
                       @"stats":@{@"checkinsCount":@1234},
                       @"location":@{
                       @"lat":@123,
                       @"lng":@456
                       },
                       @"contact":@{@"formattedPhone":@"123-456-7777"},
                       @"categories":@[@{@"shortName":@"Snacks"}]
                       }},
                       ]
                       }]}}];
    
    STAssertEquals((NSUInteger)1, result.count, @"");
    GPVenue *v = result[0];
    STAssertEqualObjects(@"venue_1", v.foursquareId, @"");
    STAssertEquals(1234, v.checkinsCount, @"");
    STAssertEqualObjects(@"The Venue Name", v.title, @"");
    STAssertEqualObjects(@"Snacks", v.category, @"");
    STAssertNil(v.website, @"");
    STAssertEquals(123.0, v.coordinate.latitude, @"");
    STAssertEquals(456.0, v.coordinate.longitude, @"");
    STAssertEqualObjects(@"123-456-7777", v.formattedPhone, @"");
}

- (void)test_processResponse_ReturnsVenue_IfNoPhone
{
    NSArray *result = [_venuesFetcher processResponse:@{@"response": @{
                       @"groups":@[
                       @{@"items":@[
                       @{@"venue":@{
                       @"id":@"venue_1",
                       @"name":@"The Venue Name",
                       @"stats":@{@"checkinsCount":@1234},
                       @"url":@"example.com",
                       @"location":@{
                       @"lat":@123,
                       @"lng":@456
                       },
                       @"categories":@[@{@"shortName":@"Snacks"}]
                       }},
                       ]
                       }]}}];
    
    STAssertEquals((NSUInteger)1, result.count, @"");
    GPVenue *v = result[0];
    STAssertEqualObjects(@"venue_1", v.foursquareId, @"");
    STAssertEquals(1234, v.checkinsCount, @"");
    STAssertEqualObjects(@"The Venue Name", v.title, @"");
    STAssertEqualObjects(@"Snacks", v.category, @"");
    STAssertEqualObjects(@"example.com", v.website, @"");
    STAssertEquals(123.0, v.coordinate.latitude, @"");
    STAssertEquals(456.0, v.coordinate.longitude, @"");
    STAssertNil(v.formattedPhone, @"");
}





@end
