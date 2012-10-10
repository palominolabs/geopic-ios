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
    }
    return self;
}

#pragma mark UITableViewDataSource

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellReuseIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:kCellReuseIdentifier] autorelease];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = NSLocalizedString(@"Category", @"Category");
            cell.detailTextLabel.text = _venue.category;
            break;
        case 1:
            cell.textLabel.text = NSLocalizedString(@"Checkins", @"Checkins");
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", _venue.checkinsCount];
            break;
        case 2:
            cell.textLabel.text = NSLocalizedString(@"Phone", @"Phone");
            cell.detailTextLabel.text = _venue.formattedPhone;
            break;
    }
    
    return cell;
}


@end
