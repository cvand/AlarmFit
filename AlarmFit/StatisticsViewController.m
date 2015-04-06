//
//  StatisticsViewController.m
//  AlarmFit
//
//  Created by Chrysanthi Vandera on 2/26/15.
//  Copyright (c) 2015 chrysanthicodes. All rights reserved.
//

#import "StatisticsViewController.h"
#import "FirstViewController.h"
#import "OAuth1Controller.h"
#import "LoginWebViewController.h"

@interface StatisticsViewController (){
    int previousStepperValue;
    int totalNumber;
}


@property (nonatomic, strong) OAuth1Controller *oauth1Controller;
@property (nonatomic, strong) NSString *oauthToken;
@property (nonatomic, strong) NSString *oauthTokenSecret;
@property (strong, nonatomic) BEMSimpleLineGraphView *graphBox;

@property (strong, nonatomic) IBOutlet UISegmentedControl *curveChoice;


@end

@implementation StatisticsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadGraph];
}

- (void)loadGraph {
    
    _graphBox = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 60, 320, 250)];
    _graphBox.delegate = self;
    _graphBox.dataSource = self;
    [self.view addSubview:_graphBox];
    
    [self hydrateDatasets];
    
    // Customization of the graph
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    self.graphBox.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    self.graphBox.enableTouchReport = YES;
    self.graphBox.enablePopUpReport = YES;
    self.graphBox.enableYAxisLabel = YES;
    self.graphBox.autoScaleYAxis = YES;
    self.graphBox.alwaysDisplayDots = NO;
    self.graphBox.enableReferenceXAxisLines = YES;
    self.graphBox.enableReferenceYAxisLines = YES;
    self.graphBox.enableReferenceAxisFrame = YES;
    self.graphBox.animationGraphStyle = BEMLineAnimationDraw;
    
    // Dash the y reference lines
    self.graphBox.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    
    // Show the y axis values with this format string
    self.graphBox.formatStringForValues = @"%.1f";
    
    // Setup initial curve selection segment
    self.curveChoice.selectedSegmentIndex = self.graphBox.enableBezierCurve;

}

- (void)hydrateDatasets {
    
    if(!self.arrayOfValues) self.arrayOfValues = [[NSMutableArray alloc] init];
    if(!self.arrayOfDates) self.arrayOfDates = [[NSMutableArray alloc] init];
    [self.arrayOfValues removeAllObjects];
    [self.arrayOfDates removeAllObjects];
    
    NSDate *baseDate = [NSDate date];
    
    NSData *data = [self getSleepDataForDate:baseDate];

    
    [self.arrayOfValues addObject:@(1)];
    [self.arrayOfDates addObject:baseDate];
    [self.arrayOfValues addObject:@(2)];
    [self.arrayOfDates addObject:[self dateForGraphAfterDate:self.arrayOfDates[0]]]; // Dates for the X-Axis of the graph
    [self.arrayOfValues addObject:@(1)];
    [self.arrayOfDates addObject:[self dateForGraphAfterDate:self.arrayOfDates[1]]]; // Dates for the X-Axis of the graph
    [self.arrayOfValues addObject:@(0)];
    [self.arrayOfDates addObject:[self dateForGraphAfterDate:self.arrayOfDates[2]]]; // Dates for the X-Axis of the graph
    [self.arrayOfValues addObject:@(2)];
    [self.arrayOfDates addObject:[self dateForGraphAfterDate:self.arrayOfDates[3]]]; // Dates for the X-Axis of the graph
    [self.arrayOfValues addObject:@(1)];
    [self.arrayOfDates addObject:[self dateForGraphAfterDate:self.arrayOfDates[4]]]; // Dates for the X-Axis of the graph
    [self.arrayOfValues addObject:@(0)];
    [self.arrayOfDates addObject:[self dateForGraphAfterDate:self.arrayOfDates[5]]]; // Dates for the X-Axis of the graph
    
    totalNumber = 7;
}

- (NSDate *)dateForGraphAfterDate:(NSDate *)date {
    NSTimeInterval secondsInTwelveHours = 60;

    NSDate *newDate = [date dateByAddingTimeInterval:secondsInTwelveHours];
    return newDate;
}


#pragma mark - Graph Actions

- (IBAction)refresh:(id)sender {
    [self hydrateDatasets];
    
    UIColor *color = [UIColor colorWithRed:0.0 green:140.0/255.0 blue:255.0/255.0 alpha:1.0];
    self.graphBox.enableBezierCurve = (BOOL) self.curveChoice.selectedSegmentIndex;
    self.graphBox.colorTop = color;
    self.graphBox.colorBottom = color;
    self.graphBox.backgroundColor = color;
    self.view.tintColor = color;

    self.navigationController.navigationBar.tintColor = color;
    
    self.graphBox.animationGraphStyle = BEMLineAnimationFade;
    [self.graphBox reloadGraph];
}

- (float)getRandomFloat {
    float i1 = (float)(arc4random() % 1000000) / 100 ;
    return i1;
}


-(void)viewDidAppear:(BOOL)animated {
    if (_oauthToken == nil || [_oauthToken isEqual:@""]) {
        [self login];
    }

}

- (NSData *)getSleepDataForDate:(NSDate *)date
{
    __block NSData *returnData;
    NSString *path = @"1/user/-/sleep/date/2015-02-20.json";
    
    NSURLRequest *preparedRequest = [OAuth1Controller preparedRequestForPath:path
                                                                  parameters:nil
                                                                  HTTPmethod:@"GET"
                                                                  oauthToken:self.oauthToken
                                                                 oauthSecret:self.oauthTokenSecret];

    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:preparedRequest
                                          returningResponse:&response
                                                      error:&error];
    
    if (error == nil) {
        returnData = data;
    }
    
    

//    [NSURLConnection sendAsynchronousRequest:preparedRequest
//                                       queue:NSOperationQueue.mainQueue
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//                               
//                               dispatch_sync(dispatch_get_main_queue(), ^{
//                                   
//                                   NSLog(@"path35 %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//                                   
//                                   returnData = data;
//                                   [self.responseText setText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
//                                   
//                                   if (error) NSLog(@"Error in API request: %@", error.localizedDescription);
//                               });
//                           }];
    return returnData;
    
}

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graphBox {
    return (int)[self.arrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.arrayOfValues objectAtIndex:index] doubleValue];
}

- (void)login {
    LoginWebViewController *loginWebViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginWebViewController"];
    
    [self presentViewController:loginWebViewController
                       animated:YES
                     completion:^{
                         [self.oauth1Controller loginWithWebView:loginWebViewController.webView completion:^(NSDictionary *oauthTokens, NSError *error) {
                             if (!error) {
                                 // Store your tokens for authenticating your later requests, consider storing the tokens in the Keychain
                                 self.oauthToken = oauthTokens[@"oauth_token"];
                                 self.oauthTokenSecret = oauthTokens[@"oauth_token_secret"];
                             }
                             else
                             {
                                 NSLog(@"Error authenticating: %@", error.localizedDescription);
                             }
                             [self dismissViewControllerAnimated:YES completion: ^{
                                 self.oauth1Controller = nil;
                                 [self loadGraph];
                             }];
                         }];
                     }];
}

- (OAuth1Controller *)oauth1Controller
{
    if (_oauth1Controller == nil) {
        _oauth1Controller = [[OAuth1Controller alloc] init];
    }
    return _oauth1Controller;
}

@end
