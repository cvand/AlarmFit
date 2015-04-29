//
//  FitbitService.m
//  AlarmFit
//
//  Created by Chrysanthi Vandera on 4/29/15.
//  Copyright (c) 2015 chrysanthicodes. All rights reserved.
//

#import "FitbitService.h"
#import "Preferences.h"

@implementation FitbitService

+ (NSData *) getSleepData:(NSDate *)date withToken:(NSString *)oauthToken andSecret:(NSString *)oauthTokenSecret{
    __block NSData *returnData;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString * dateString = [dateFormatter stringFromDate:date];
    
    NSString *path = [NSString stringWithFormat:@"1/user/-/sleep/date/%@", dateString];
    
    NSURLRequest *preparedRequest = [OAuth1Controller preparedRequestForPath:path
                                                                  parameters:nil
                                                                  HTTPmethod:@"GET"
                                                                  oauthToken:oauthToken
                                                                 oauthSecret:oauthTokenSecret];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:preparedRequest
                                          returningResponse:&response
                                                      error:&error];
    
    if (error == nil) {
        returnData = data;
    }
    return returnData;
}

+ (NSData *) getUserData:(NSString *)user withToken:(NSString *)oauthToken andSecret:(NSString *)oauthTokenSecret {
    __block NSData *returnData;
    
    if (user == nil) {
        user = @"-";
    }
    NSString *path = [NSString stringWithFormat:@"1/user/%@/profile.json", user];
    
    NSURLRequest *preparedRequest = [OAuth1Controller preparedRequestForPath:path
                                                                  parameters:nil
                                                                  HTTPmethod:@"GET"
                                                                  oauthToken:oauthToken
                                                                 oauthSecret:oauthTokenSecret];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:preparedRequest
                                          returningResponse:&response
                                                      error:&error];
    
    if (error == nil) {
        returnData = data;
    }
    return returnData;
}


+ (NSData *) getDeviceDataWithToken:(NSString *)oauthToken andSecret:(NSString *)oauthTokenSecret {
    __block NSData *returnData;
    
    NSString *path = @"1/user/-/devices.json";
    
    NSURLRequest *preparedRequest = [OAuth1Controller preparedRequestForPath:path
                                                                  parameters:nil
                                                                  HTTPmethod:@"GET"
                                                                  oauthToken:oauthToken
                                                                 oauthSecret:oauthTokenSecret];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:preparedRequest
                                          returningResponse:&response
                                                      error:&error];
    
    if (error == nil) {
        returnData = data;
    }
    return returnData;
}

@end
