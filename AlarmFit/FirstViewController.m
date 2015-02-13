//
//  FirstViewController.m
//  AlarmFit
//
//  Created by Chrysanthi Vandera on 2/13/15.
//  Copyright (c) 2015 chrysanthicodes. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateTime];
    
    NSTimer* timer = [NSTimer timerWithTimeInterval:60.0f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void)updateTime {
    NSDate *now = [[NSDate alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *currentTime = [dateFormatter stringFromDate:now];
    
//    NSString *time = [hourString stringByAppendingString:@" : "];
//    time = [time stringByAppendingString:minuteString];
    
    [_timeView setText:currentTime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
