//
//  SetAlarmTableViewController.h
//  AlarmFit
//
//  Created by Archana Iyer on 2/19/15.
//  Copyright (c) 2015 chrysanthicodes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetAlarmTableViewController : UITableViewController
- (IBAction)unwindToAlarms:(UIStoryboardSegue *)segue;


- (IBAction) scheduleAlarm:(id) sender;

@end
