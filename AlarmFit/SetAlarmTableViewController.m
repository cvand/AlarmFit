//
//  SetAlarmTableViewController.m
//  AlarmFit
//
//  Created by Archana Iyer on 2/19/15.
//  Copyright (c) 2015 chrysanthicodes. All rights reserved.
//

#import "SetAlarmTableViewController.h"
#import "Alarm.h"
#import "AddEditAlarmViewController.h"
#import "SwitchTableViewCell.h"
#import "Preferences.h"

static NSString *CellIdentifier = @"ListPrototypeCell";


@interface SetAlarmTableViewController ()
@property NSMutableArray *alarms;
@property UILocalNotification *notification;
@property NSIndexPath *indexPathForSelectedRow;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBtn;

@end


@implementation SetAlarmTableViewController

- (void)loadInitialData {
    
    self.alarms = [NSMutableArray arrayWithArray:[self getSavedAlarms]];
    
    if (self.alarms == nil) {
        self.alarms = [[NSMutableArray alloc] init];
        NSLog(@"No alarms saved");
    }
}

- (NSArray *)getSavedAlarms {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[Preferences getUserPreference:SAVED_ALARMS]];
}

- (void) saveAlarms:(NSArray *)array {
    NSData *encodedAlarms = [NSKeyedArchiver archivedDataWithRootObject:array];
    [Preferences setUserPreference:encodedAlarms forKey:SAVED_ALARMS];
}

- (void) scheduleAlarm:(Alarm *) alarm {
    
    if (self.notification != nil) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    self.notification = [[UILocalNotification alloc] init];
    
    NSDate *date = [alarm getAlarmTimeAsDateObject];
    
    self.notification.repeatInterval = NSDayCalendarUnit;
    [self.notification setFireDate:date];
    [self.notification setTimeZone:[NSTimeZone defaultTimeZone]];
    [self.notification setAlertAction:@"Show"];
    [self.notification setAlertBody:@"Waky waky!"];
    [self.notification setHasAction:YES];
    [self.notification setSoundName:UILocalNotificationDefaultSoundName];
    
    NSNumber* uidToStore = [NSNumber numberWithInt:0];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:uidToStore forKey:@"notificationID"];
    self.notification.userInfo = userInfo;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:self.notification];
}

- (IBAction)unwindToAlarms:(UIStoryboardSegue *)segue {
    AddEditAlarmViewController *source = [segue sourceViewController];
    Alarm *alarm = source.alarm;
    NSInteger indexOfAlarmToEdit = source.indexOfAlarmToEdit;
    BOOL editMode = source.editMode;
    BOOL delete = source.deleteMode;
    
    if (delete) {
        [self.alarms removeObjectAtIndex: indexOfAlarmToEdit];
        [self saveAlarms:self.alarms];
        [self.tableView reloadData];
    }
    if (alarm != nil) {
        alarm.isSet = YES;
        if (editMode) {
            [self.alarms replaceObjectAtIndex:indexOfAlarmToEdit withObject:alarm];
        } else {
            [self.alarms addObject:alarm];
            
        }
        [self saveAlarms:self.alarms];
        [self unsetAlarms];
        [self scheduleAlarm:alarm];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.alarms count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Alarm *alarm = [self.alarms objectAtIndex:indexPath.row];
    cell.label.text = alarm.alarmTime;
    [cell.toggleSwitch setOn:alarm.isSet animated:YES];
    
    [cell.toggleSwitch addTarget:self action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.indexPathForSelectedRow = indexPath;
    [self performSegueWithIdentifier:@"SetAlarmToEditAlarm" sender:self];
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)toggleAlarm:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
    Alarm *alarm = [self.alarms objectAtIndex:indexPath.row];
    if ( !alarm.isSet ) {
        [self unsetAlarms];
    }
    alarm.isSet = !alarm.isSet;
    [self setSwitch:alarm.isSet forElementAtIndex:indexPath inTableView:tableView];
}

- (void)unsetAlarms {
    for (Alarm *al in _alarms) {
        if (al.isSet) {
            al.isSet = NO;
            NSInteger index = [_alarms indexOfObject:al];
            NSIndexPath *path = [NSIndexPath indexPathForItem:index inSection:0];
            [self setSwitch:NO forElementAtIndex:path inTableView:self.tableView];
            
            if (self.notification != nil) {
                [[UIApplication sharedApplication] cancelAllLocalNotifications];
                self.notification = nil;
            }
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"SetAlarmToEditAlarm"])
    {
        AddEditAlarmViewController *controller = (AddEditAlarmViewController *)segue.destinationViewController;
        if (sender == self.addBtn) {
            controller.editMode = NO;
        } else {
            controller.editMode = YES;
            controller.indexOfAlarmToEdit = self.indexPathForSelectedRow.row;
        }
    }
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


@end
