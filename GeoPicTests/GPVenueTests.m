//
//  GPVenueTests.m
//  GeoPic
//
//  Created by Manuel Wudka-Robles on 10/4/12.
//  Copyright (c) 2012 Palomino Labs, Inc. All rights reserved.
//

#import "GPVenueTests.h"
#import "GPVenue.h"

@implementation GPVenueTests {
    GPVenue *_venue;
    GPVenue *_otherVenue;
}

- (void)setUp
{
    _venue = [GPVenue new];
    _otherVenue = [GPVenue new];
}

- (void)tearDown
{
    [_venue release];
    [_otherVenue release];
}

- (void)test_isEqual_ReturnsFalse_ForNil
{
    STAssertFalse([_venue isEqual:nil], @"");
}

- (void)test_isEqual_ReturnsFalse_ForNonVenue
{
    STAssertFalse([_venue isEqual:@"foo"], @"");
}

- (void)test_isEqual_ReturnsFalse_ForVenueWithDifferentFoursquareId
{
    _venue.foursquareId = @"A";
    
    _otherVenue.foursquareId = @"B";
    
    STAssertFalse([_venue isEqual:_otherVenue], @"");
}

- (void)test_isEqual_ReturnsTrue_ForVenueWithSameFoursquareId
{
    _venue.foursquareId = @"A";
    
    _otherVenue.foursquareId = @"A";
    
    STAssertTrue([_venue isEqual:_otherVenue], @"");
}

- (void)test_isEqual_ReturnsTrue_ForVenueWithSameFoursquareIdAndDifferentName
{
    _venue.foursquareId = @"A";
    _venue.title = @"foo";
    
    _otherVenue.foursquareId = @"A";
    _otherVenue.title = @"bar";
    
    STAssertTrue([_venue isEqual:_otherVenue], @"");
}

@end
