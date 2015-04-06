//
//  Preferences.h
//  AlarmFit
//
//  Created by Chrysanthi Vandera on 4/6/15.
//  Copyright (c) 2015 chrysanthicodes. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FITBIT_OAUTH_TOKEN           @"fitbitToken"
#define FITBIT_OAUTH_TOKEN_SECRET         @"fitbitToeknSecret"

@interface Preferences : NSObject

#pragma mark Preferences

+(id)getUserPreference:(NSString*)forKey;
+(void)setUserPreference:(id)value forKey:(NSString*)key;

@end
