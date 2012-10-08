//
//  GPAppDelegate.m
//  GeoPic
//
//  Created by Manuel Wudka-Robles on 10/8/12.
//  Copyright (c) 2012 Palomino Labs, Inc. All rights reserved.
//

#import "GPAppDelegate.h"
#import "GPNearbyVenuesViewController.h"

@implementation GPAppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    self.window.rootViewController = [[GPNearbyVenuesViewController new] autorelease];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
