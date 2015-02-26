//
//  SwitchTableViewCell.h
//  AlarmFit
//
//  Created by Chrysanthi Vandera on 2/25/15.
//  Copyright (c) 2015 chrysanthicodes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;

@end
