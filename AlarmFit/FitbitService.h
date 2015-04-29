//
//  FitbitService.h
//  AlarmFit
//
//  Created by Chrysanthi Vandera on 4/29/15.
//  Copyright (c) 2015 chrysanthicodes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuth1Controller.h"

@interface FitbitService : NSObject

+ (NSData *) getSleepData:(NSDate *)date withToken:(NSString *)oauthToken andSecret:(NSString *)oauthTokenSecret;
+ (NSData *) getUserData:(NSString *)user withToken:(NSString *)oauthToken andSecret:(NSString *)oauthTokenSecret;
+ (NSData *) getDeviceDataWithToken:(NSString *)oauthToken andSecret:(NSString *)oauthTokenSecret;
@end
