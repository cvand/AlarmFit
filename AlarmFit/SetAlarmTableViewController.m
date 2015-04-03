//
//  SetAlarmTableViewController.m
//  AlarmFit
//
//  Created by Archana Iyer on 2/19/15.
//  Copyright (c) 2015 chrysanthicodes. All rights reserved.
//

#import "SetAlarmTableViewController.h"
#import "Alarm.h"
#import "NewAlarmViewController.h"
#import "SwitchTableViewCell.h"

static NSString *CellIdentifier = @"ListPrototypeCell";


@interface SetAlarmTableViewController ()
@property NSMutableArray *alarms;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation SetAlarmTableViewController

- (void)loadInitialData {
    Alarm *alarm1 = [[Alarm alloc] init];
    alarm1.alarmTime=@"08:15";
    alarm1.set = NO;
    [self.alarms addObject:alarm1];
    Alarm *alarm2 = [[Alarm alloc] init];
    alarm2.alarmTime=@"08:45";
    alarm2.set = YES;
    [self.alarms addObject:alarm2];
    Alarm *alarm3 = [[Alarm alloc] init];
    alarm3.alarmTime=@"10:15";
    alarm3.set = NO;
    [self.alarms addObject:alarm3];
    Alarm *alarm4 = [[Alarm alloc] init];
    alarm4.alarmTime=@"11:15";
    alarm4.set = NO;
    [self.alarms addObject:alarm4];
    Alarm *alarm5 = [[Alarm alloc] init];
    alarm5.alarmTime=@"12:15";
    alarm5.set = NO;
    [self.alarms addObject:alarm5];
}

- (IBAction) scheduleAlarm:(id) sender {
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.day = 02;
    comps.month = 04;
    comps.year = 2015;
    comps.hour = 01;
    comps.minute = 29;
    //NSDate * nextAlertTime = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //notification.fireDate = nextAlertTime;
    
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:7];
    notification.timeZone = [NSTimeZone systemTimeZone];
    notification.alertAction = @"Show";
    notification.alertBody = @"Wake up now!";
    notification.soundName = UILocalNotificationDefaultSoundName;
    //notification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (IBAction)unwindToAlarms:(UIStoryboardSegue *)segue {
    NewAlarmViewController *source = [segue sourceViewController];
    Alarm *alarm = source.alarm;
    
    if (alarm != nil) {
        alarm.set = YES;
        [self.alarms addObject:alarm];
        [self unsetAlarms];
        
        [self.tableView reloadData];
        
        NSInteger index = [_alarms indexOfObject:alarm];
        NSIndexPath *path = [NSIndexPath indexPathForItem:index inSection:0];
        [self setSwitch:YES forElementAtIndex:path inTableView:self.tableView];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.alarms = [[NSMutableArray alloc] init];
    [self loadInitialData];
    
//    self.tableView.backgroundColor = [UIColor colorWithRed:88 green:114 blue:161 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.alarms count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Alarm *alarm = [self.alarms objectAtIndex:indexPath.row];
    cell.label.text = alarm.alarmTime;
    [cell.toggleSwitch setOn:alarm.set animated:YES];
    
    [cell.toggleSwitch addTarget:self action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)toggleAlarm:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
    Alarm *alarm = [self.alarms objectAtIndex:indexPath.row];
    
    //clear toggles first
    [self unsetAlarms];
    
    alarm.set = !alarm.set;
    if (alarm.set) {
        [self setSwitch:alarm.set forElementAtIndex:indexPath inTableView:tableView];
    }
}

- (void)unsetAlarms {
    for (Alarm *al in _alarms) {
        if (al.set) {
            al.set = NO;
            NSInteger index = [_alarms indexOfObject:al];
            NSIndexPath *path = [NSIndexPath indexPathForItem:index inSection:0];
            [self setSwitch:NO forElementAtIndex:path inTableView:self.tableView];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)stateChanged:(UISwitch *)switchState {
    UITableViewCell * cell = (UITableViewCell*) switchState.superview;
    CGPoint center= switchState.center;
    CGPoint rootViewPoint = [cell convertPoint:center toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:rootViewPoint];
    if ( indexPath == nil )
        return;
    [self toggleAlarm:indexPath inTableView:self.tableView];
    
}


- (void)setSwitch:(BOOL)set forElementAtIndex:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
    SwitchTableViewCell *cell = (SwitchTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.toggleSwitch setOn:set animated:YES];
}



/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    UIAlertView *notificationAlert = [[UIAlertView alloc] initWithTitle:@"Notification"    message:@"This local notification"
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [notificationAlert show];
    NSLog(@"didReceiveLocalNotification");
}

@end
