//
//  Preferences.h
//  AlarmFit
//
//  Created by Chrysanthi Vandera on 4/6/15.
//  Copyright (c) 2015 chrysanthicodes. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FITBIT_OAUTH_TOKEN           @"alarmFit_FitbitToken"
#define FITBIT_OAUTH_TOKEN_SECRET         @"alarmFit_FitbitTokenSecret"
#define SAVED_ALARMS         @"alarmFit_SavedAlarms"


@interface Preferences : NSObject

#pragma mark Preferences

+(id)getUserPreference:(NSString*)forKey;
+(void)setUserPreference:(id)value forKey:(NSString*)key;

@end
