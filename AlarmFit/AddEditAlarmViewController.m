//
//  NewAlarmViewController.m
//  AlarmFit
//
//  Created by Archana Iyer on 2/19/15.
//  Copyright (c) 2015 chrysanthicodes. All rights reserved.
//

#import "AddEditAlarmViewController.h"
#import "Preferences.h"

@interface AddEditAlarmViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIDatePicker *alarmPicker;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation AddEditAlarmViewController

@synthesize navItem;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _alarmPicker.datePickerMode = UIDatePickerModeTime;
    
    if (self.editMode)
    {
        navItem.title = @"Edit Alarm";

        NSMutableArray *alarmList = [NSKeyedUnarchiver unarchiveObjectWithData:[Preferences getUserPreference:SAVED_ALARMS]];
        Alarm * oldAlarm = [alarmList objectAtIndex:self.indexOfAlarmToEdit];
        NSDate *date = [oldAlarm getAlarmTimeAsDateObject];
        if (date != nil) {
            self.alarmPicker.date = date;
        }
        
    } else {
        self.deleteBtn.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)btnClick:(id)sender
{
    if (sender == self.deleteBtn) {
        NSLog(@"Delete");
        UIAlertView *deleteAlarmAlert = [[UIAlertView alloc] initWithTitle:@"Delete Alarm"
                                                                   message:@"Are you sure you want to delete this alarm?"
                                                                  delegate:self
                                                         cancelButtonTitle:@"Yes"
                                                         otherButtonTitles:@"Cancel", nil];
        [deleteAlarmAlert show];

    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        self.deleteMode = YES;
        [self performSegueWithIdentifier: @"SetAlarmSegue" sender: self];
    }
    else{

    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender == self.saveButton) {
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"HH:mm"];
        
        NSDate *now = [_alarmPicker date];
        NSString *theTime = [timeFormat stringFromDate:now];
        self.alarm = [[Alarm alloc] init];
        
        self.alarm.alarmTime = theTime;
        self.alarm.isSet = NO;
    } else if (sender == self.deleteBtn) {
        NSLog(@"Delete");
    }
}

- (IBAction)cancelTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buttonPress:(id)sender {
}
- (IBAction)saveButton:(id)sender {
}
- (IBAction)deleteButton:(id)sender {
    if (sender == self.deleteBtn) {
        NSLog(@"Delete");
        UIAlertView *deleteAlarmAlert = [[UIAlertView alloc] initWithTitle:@"Delete Alarm"
                                                                   message:@"Are you sure you want to delete this alarm?"
                                                                  delegate:self
                                                         cancelButtonTitle:@"Yes"
                                                         otherButtonTitles:@"Cancel", nil];
        [deleteAlarmAlert show];
        
    }
}

@end
