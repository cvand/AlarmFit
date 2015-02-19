//
//  SecondViewController.m
//  AlarmFit
//
//  Created by Chrysanthi Vandera on 2/13/15.
//  Copyright (c) 2015 chrysanthicodes. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateTime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    _timeView.text = [dateFormatter stringFromDate:[NSDate date]];
    [self performSelector:@selector(updateTime) withObject:self afterDelay:1.0];
}
@end
