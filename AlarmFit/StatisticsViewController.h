//
//  StatisticsViewController.h
//  AlarmFit
//
//  Created by Chrysanthi Vandera on 2/26/15.
//  Copyright (c) 2015 chrysanthicodes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"

@interface StatisticsViewController : UIViewController <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (weak, nonatomic) IBOutlet UILabel *qualityOfSleep;
@property (weak, nonatomic) IBOutlet UILabel *sleepDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *sleepCycleLabel;
@property (strong, nonatomic) NSMutableArray *arrayOfValues;
@property (strong, nonatomic) NSMutableArray *arrayOfDates;

@end
