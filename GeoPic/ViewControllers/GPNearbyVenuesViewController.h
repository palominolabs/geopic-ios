//
//  GPNearbyVenuesViewController.h
//  GeoPic
//
//  Created by Manuel Wudka-Robles on 10/8/12.
//  Copyright (c) 2012 Palomino Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPVenuesFetcherDelegate.h"

@interface GPNearbyVenuesViewController : UIViewController<MKMapViewDelegate, GPVenuesFetcherDelegate, UIPopoverControllerDelegate>

@end
