//
// GPVenue.m
//  GeoPic
//
//  Created by Manuel Wudka-Robles on 9/30/12.
//  Copyright (c) 2012 Palomino Labs, Inc. All rights reserved.
//

#import "GPVenue.h"

@implementation GPVenue

@synthesize coordinate;
@synthesize foursquareId;
@synthesize title;
@synthesize subtitle;
@synthesize category;
@synthesize website;

#pragma mark NSObject

- (NSUInteger)hash
{
    return [self.foursquareId hash];
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[GPVenue class]]) {
        return false;
    }
    
    return [self.foursquareId isEqual:[object foursquareId]];
}

@end
