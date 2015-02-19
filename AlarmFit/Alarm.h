//
//  Alarm.h
//  AlarmFit
//
//  Created by Archana Iyer on 2/19/15.
//  Copyright (c) 2015 chrysanthicodes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alarm : NSObject

@property NSString *alarmTime;
@property BOOL set;
@property (readonly) NSDate *creationDate;

@end

