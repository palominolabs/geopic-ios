//
//  GPAuthHelpers.m
//  GeoPic
//
//  Created by Manuel Wudka-Robles on 10/10/12.
//  Copyright (c) 2012 Palomino Labs, Inc. All rights reserved.
//


#import "GPAuthHelpers.h"

NSString *GPGenerateUserIdentifier() {
    uint8_t bytes[64];
    SecRandomCopyBytes(kSecUseItemList, sizeof(bytes), bytes);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:sizeof(bytes)*2];
    for (int i = 0; i < sizeof(bytes); i++) {
        [result appendFormat:@"%02x", bytes[i]];
    }
    return [NSString stringWithString:result];
}

NSString *GPGetUserIdentifier() {
    NSDictionary *searchDictionary = @{
    (id)kSecClass: (id)kSecClassGenericPassword,
    (id)kSecMatchLimit:(id)kSecMatchLimitOne,
    (id)kSecReturnData:(id)kCFBooleanTrue
    };
    
    NSData *result = nil;
    SecItemCopyMatching((CFDictionaryRef)searchDictionary, (CFTypeRef *)&result);
    
    if(!result) {
        return nil;
    }
    
    return [[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] autorelease];
}

void GPSaveUserIdentifier(NSString *userIdentifier) {
    NSDictionary *searchDictionary = @{
    (id)kSecClass: (id)kSecClassGenericPassword,
    (id)kSecValueData:[userIdentifier dataUsingEncoding:NSUTF8StringEncoding],
    };
    
    SecItemAdd((CFDictionaryRef)searchDictionary, NULL);
}

void GPCreateAnonymousUser(LoggedInUserCallback block) {
    NSString *userIdentifier = GPGetUserIdentifier();
    if(!userIdentifier) {
        userIdentifier = GPGenerateUserIdentifier();
        GPSaveUserIdentifier(userIdentifier);
    }
    
    NSDictionary *newUser = @{@"username":userIdentifier, @"password":userIdentifier};
    
    [[[SMClient defaultClient] dataStore] createObject:newUser inSchema:@"user" onSuccess:^(NSDictionary *theObject, NSString *schema) {
        GPWithLoggedInUser(block);
    } onFailure:^(NSError *theError, NSDictionary *theObject, NSString *schema) {
        GPCreateAnonymousUser(block);
    }];
}

void GPWithLoggedInUser(LoggedInUserCallback block)
{
    if ([SMClient defaultClient].isLoggedIn) {
        block(GPGetUserIdentifier());
        return;
    } else {
        [[SMClient defaultClient] loginWithUsername:GPGetUserIdentifier() password:GPGetUserIdentifier() onSuccess:^(NSDictionary *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(GPGetUserIdentifier());
            });            
        } onFailure:^(NSError *error) {
            GPCreateAnonymousUser(block);
        }];
    }
    
    
}