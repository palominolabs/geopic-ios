//
//  GPAuthHelpers.h
//  GeoPic
//
//  Created by Manuel Wudka-Robles on 10/10/12.
//  Copyright (c) 2012 Palomino Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LoggedInUserCallback)(NSString *userId);

void GPWithLoggedInUser(LoggedInUserCallback block);
