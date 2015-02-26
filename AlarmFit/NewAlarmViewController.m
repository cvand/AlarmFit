//
//  NewAlarmViewController.m
//  AlarmFit
//
//  Created by Archana Iyer on 2/19/15.
//  Copyright (c) 2015 chrysanthicodes. All rights reserved.
//

#import "NewAlarmViewController.h"

@interface NewAlarmViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIDatePicker *alarmPicker;


@end

@implementation NewAlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _alarmPicker.datePickerMode = UIDatePickerModeTime;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender != self.saveButton) return;
    
 
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    
    NSDate *now = [_alarmPicker date];
    NSString *theTime = [timeFormat stringFromDate:now];
    
    self.alarm = [[Alarm alloc] init];
    self.alarm.alarmTime = theTime;
    self.alarm.set = NO;
}

- (IBAction)cancelTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buttonPress:(id)sender {
}
- (IBAction)saveButton:(id)sender {
}
@end
