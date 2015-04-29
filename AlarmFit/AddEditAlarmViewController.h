//
//  NewAlarmViewController.h
//  AlarmFit
//
//  Created by Archana Iyer on 2/19/15.
//  Copyright (c) 2015 chrysanthicodes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Alarm.h"

@interface AddEditAlarmViewController : UIViewController

@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property Alarm *alarm;
@property (nonatomic, assign) NSInteger indexOfAlarmToEdit;
@property(nonatomic,assign) BOOL editMode;

@end
