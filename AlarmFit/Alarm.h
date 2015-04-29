//
//  Alarm.h
//  AlarmFit
//
//  Created by Archana Iyer on 2/19/15.
//  Copyright (c) 2015 chrysanthicodes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alarm : NSObject

@property(nonatomic,strong) NSString *alarmTime;
@property (nonatomic, assign) BOOL isSet;

-(NSDate *)getAlarmTimeAsDateObject;
@end

