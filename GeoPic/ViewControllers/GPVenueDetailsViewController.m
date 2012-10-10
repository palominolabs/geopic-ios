//
//  GPVenueDetailsViewController.m
//  GeoPic
//
//  Created by Manuel Wudka-Robles on 10/10/12.
//  Copyright (c) 2012 Palomino Labs, Inc. All rights reserved.
//

#import "GPVenueDetailsViewController.h"


@interface GPVenueDetailsViewController ()

@end

@implementation GPVenueDetailsViewController {
    GPVenue *_venue;
}

- (id)initWithVenue:(GPVenue *)venue {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        _venue = venue;
        
        self.navigationItem.title = _venue.title;
        
        DLOG(@"Viewing details for venue %@", _venue.title);
    }
    return self;
}

@end
