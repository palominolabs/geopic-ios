//
//  GPNearbyVenuesViewController.m
//  GeoPic
//
//  Created by Manuel Wudka-Robles on 10/8/12.
//  Copyright (c) 2012 Palomino Labs, Inc. All rights reserved.
//

#import "GPNearbyVenuesViewController.h"

@interface GPNearbyVenuesViewController ()

@end

@implementation GPNearbyVenuesViewController {
    MKMapView *_mapView;
}

- (void)loadView {
    [super loadView];
    
    _mapView = [MKMapView new];
    [self.view addSubview:_mapView];
}

- (void) dealloc {
    [_mapView release];
    
    [super dealloc];
}



@end
