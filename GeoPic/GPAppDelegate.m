//
//  GPAppDelegate.m
//  GeoPic
//
//  Created by Manuel Wudka-Robles on 10/8/12.
//  Copyright (c) 2012 Palomino Labs, Inc. All rights reserved.
//

#import "GPAppDelegate.h"
#import "GPNearbyVenuesViewController.h"

#ifndef STACKMOB_PUBLIC_KEY
#error STACKMOB_PUBLIC_KEY should be defined in the xcconfigs
#endif

@implementation GPAppDelegate {
}

- (void)dealloc
{
    [_window release];
    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[[SMClient alloc] initWithAPIVersion:@"0" publicKey:STACKMOB_PUBLIC_KEY] autorelease];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    GPNearbyVenuesViewController *nearbyVenuesController = [[GPNearbyVenuesViewController new] autorelease];
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:nearbyVenuesController] autorelease];
    
    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
