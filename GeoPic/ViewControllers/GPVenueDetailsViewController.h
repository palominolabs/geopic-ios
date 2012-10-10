//
//  GPVenueDetailsViewController.h
//  GeoPic
//
//  Created by Manuel Wudka-Robles on 10/10/12.
//  Copyright (c) 2012 Palomino Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPVenue.h"

@interface GPVenueDetailsViewController : UITableViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (id)initWithVenue:(GPVenue *)venue;

@end
