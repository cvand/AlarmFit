//
//  Preferences.m
//  AlarmFit
//
//  Created by Chrysanthi Vandera on 4/6/15.
//  Copyright (c) 2015 chrysanthicodes. All rights reserved.
//

#import "Preferences.h"

@implementation Preferences

+(id)getUserPreference:(NSString*)forKey
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:forKey];
}

+(void)setUserPreference:(id)value forKey:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

@end
