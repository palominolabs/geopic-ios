//
//  GPNearbyVenuesViewController.m
//  GeoPic
//
//  Created by Manuel Wudka-Robles on 10/8/12.
//  Copyright (c) 2012 Palomino Labs, Inc. All rights reserved.
//

#import "GPNearbyVenuesViewController.h"
#import "GPVenuesFetcher.h"
#import "GPVenue.h"
#import "GPVenueDetailsViewController.h"

@interface GPNearbyVenuesViewController ()

@end

@implementation GPNearbyVenuesViewController {
    MKMapView *_mapView;
    GPVenuesFetcher *_venueFetcher;
}

- (void)loadView {
    [super loadView];
    
    self.navigationItem.title = NSLocalizedString(@"Nearby Places", @"Nearby Places");
    
    _venueFetcher = [[GPVenuesFetcher alloc] initWithDelegate:self];
    
    _mapView = [MKMapView new];
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    _mapView.delegate = self;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[KISSMetricsAPI sharedAPI] recordEvent:@"view_nearby_venues" withProperties:nil];
}

- (void) dealloc {
    [_mapView release];
    
    [super dealloc];
}


#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [_venueFetcher findVenuesNear:mapView.centerCoordinate];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (![annotation isKindOfClass:[GPVenue class]]) {
        return nil;
    }
    
    static NSString *kMapViewIdentifier = @"mapViewAnnotation";
    
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:kMapViewIdentifier];
    
    if (!annotationView) {
        annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:kMapViewIdentifier] autorelease];
        annotationView.canShowCallout = YES;
        
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    annotationView.annotation = annotation;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    GPVenue *venue = view.annotation;

    
    [self.navigationController pushViewController:[[[GPVenueDetailsViewController alloc] initWithVenue:venue] autorelease] animated:YES];
}


#pragma mark GPVenuesFetcherDelegate

- (void)venusFetcher:(GPVenuesFetcher *)venuesFetcher didFetchVenues:(NSArray *)venues {
    @synchronized(_mapView) {
        for (id<MKAnnotation> oldAnnotation in _mapView.annotations) {
            if ([oldAnnotation isKindOfClass:[GPVenue class]] && ![venues containsObject:oldAnnotation]) {
                [_mapView removeAnnotation:oldAnnotation];
            }
        }
        
        for(GPVenue *venue in venues) {
            if (![_mapView.annotations containsObject:venue]) {
                [_mapView addAnnotation:venue];
            }
        }
    }
}

@end
