//
//  Alarm.m
//  AlarmFit
//
//  Created by Archana Iyer on 2/19/15.
//  Copyright (c) 2015 chrysanthicodes. All rights reserved.
//

#import "Alarm.h"

@implementation Alarm

@synthesize alarmTime;
@synthesize isSet;


- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.alarmTime forKey:@"alarmTime"];
    [encoder encodeBool:self.isSet forKey:@"alarmIsSet"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.alarmTime = [decoder decodeObjectForKey:@"alarmTime"];
        self.isSet = [decoder decodeBoolForKey:@"alarmIsSet"];
    }
    return self;
}

- (NSDate *)getAlarmTimeAsDateObject {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    NSDate* date = [dateFormatter dateFromString:self.alarmTime];
       
    return date;
}

@end
