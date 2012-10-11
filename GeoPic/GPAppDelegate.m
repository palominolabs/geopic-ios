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
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"green-nav-bar"] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                UITextAttributeTextColor:[UIColor whiteColor],
                          UITextAttributeTextShadowColor:[[UIColor blackColor] colorWithAlphaComponent:0.8],
                         UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
     }];
    
    
    UIImage *barButtonBackground = [UIImage imageNamed:@"green-nav-button"];
    UIImage *resizableBarButtonBackgroundImage = [barButtonBackground resizableImageWithCapInsets:UIEdgeInsetsMake(15, 21, 15, 21)];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:resizableBarButtonBackgroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *backButton = [UIImage imageNamed:@"green-back-button"];
    UIImage *resizableBackButton = [backButton resizableImageWithCapInsets:UIEdgeInsetsMake(7, 15, 14, 15)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:resizableBackButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    [KISSMetricsAPI sharedAPIWithKey:KISSMETRICS_API_KEY];
    
    [[[SMClient alloc] initWithAPIVersion:@"0" publicKey:STACKMOB_PUBLIC_KEY] autorelease];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    GPNearbyVenuesViewController *nearbyVenuesController = [[GPNearbyVenuesViewController new] autorelease];
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:nearbyVenuesController] autorelease];
    
    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[KISSMetricsAPI sharedAPI] recordEvent:@"launch" withProperties:nil];
}

@end
