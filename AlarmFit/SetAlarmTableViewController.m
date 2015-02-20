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

@interface SetAlarmTableViewController ()
@property NSMutableArray *alarms;
@end

@implementation SetAlarmTableViewController
- (void)loadInitialData {
    Alarm *alarm1 = [[Alarm alloc] init];
    alarm1.alarmTime=@"08:15";
    [self.alarms addObject:alarm1];
    Alarm *alarm2 = [[Alarm alloc] init];
    alarm2.alarmTime=@"08:45";
    [self.alarms addObject:alarm2];
    Alarm *alarm3 = [[Alarm alloc] init];
    alarm3.alarmTime=@"10:15";
    [self.alarms addObject:alarm3];
    Alarm *alarm4 = [[Alarm alloc] init];
    alarm4.alarmTime=@"11:15";
    [self.alarms addObject:alarm4];
    Alarm *alarm5 = [[Alarm alloc] init];
    alarm5.alarmTime=@"10:15";
    [self.alarms addObject:alarm5];
}

- (IBAction)unwindToAlarms:(UIStoryboardSegue *)segue {
    NewAlarmViewController *source = [segue sourceViewController];
    Alarm *alarm = source.alarm;
    if (alarm != nil) {
        [self.alarms addObject:alarm];
        [self.tableView reloadData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.alarms = [[NSMutableArray alloc] init];
    [self loadInitialData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.alarms count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    Alarm *alarm = [self.alarms objectAtIndex:indexPath.row];
    cell.textLabel.text = alarm.alarmTime;
    if (alarm.set) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Alarm *tappedItem = [self.alarms objectAtIndex:indexPath.row];
    tappedItem.set = !tappedItem.set;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
