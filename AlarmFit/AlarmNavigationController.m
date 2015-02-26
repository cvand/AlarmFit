//
//  AlarmNavigationController.m
//  AlarmFit
//
//  Created by Chrysanthi Vandera on 2/25/15.
//  Copyright (c) 2015 chrysanthicodes. All rights reserved.
//

#import "AlarmNavigationController.h"

@implementation AlarmNavigationController


- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"background.jpg"] forBarMetrics:UIBarMetricsDefault];
}
@end
