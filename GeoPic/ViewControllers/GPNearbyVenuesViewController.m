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
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    [self.view addSubview:_mapView];
    
    
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|[_mapView]|"
                               options:0
                               metrics:nil views:NSDictionaryOfVariableBindings(_mapView)]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[_mapView]|"
                               options:0
                               metrics:nil views:NSDictionaryOfVariableBindings(_mapView)]];
    

}

- (void) dealloc {
    [_mapView release];
    
    [super dealloc];
}



@end
