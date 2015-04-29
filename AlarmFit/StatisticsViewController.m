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
#import "Preferences.h"
#import "FitbitService.h"

@interface StatisticsViewController (){
    int previousStepperValue;
    int totalNumber;
}


@property (nonatomic, strong) OAuth1Controller *oauth1Controller;
@property (nonatomic, strong) NSString *oauthToken;
@property (nonatomic, strong) NSString *oauthTokenSecret;
@property (strong, nonatomic) BEMSimpleLineGraphView *graphBox;

@property (strong, nonatomic) IBOutlet UISegmentedControl *curveChoice;
@property (strong, nonatomic) IBOutlet UIView *parentView;
@property (weak, nonatomic) IBOutlet UILabel *qualityLbl;
@property (weak, nonatomic) IBOutlet UILabel *durationLbl;
@property (weak, nonatomic) IBOutlet UILabel *cycleLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;


@end

@implementation StatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadGraph {
    
    float y = self.parentView.frame.size.height;
    _graphBox = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, y-230, 320, 180)];
    _graphBox.delegate = self;
    _graphBox.dataSource = self;
    [self.view addSubview:_graphBox];
    
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

- (void)hydrateDatasets:(NSArray *)sleep {
    
    if(!self.arrayOfValues) self.arrayOfValues = [[NSMutableArray alloc] init];
    if(!self.arrayOfDates) self.arrayOfDates = [[NSMutableArray alloc] init];
    [self.arrayOfValues removeAllObjects];
    [self.arrayOfDates removeAllObjects];
    
    for (NSDictionary* minute in sleep) {
        NSString *time = [minute objectForKey:@"dateTime"];
        NSString *value = [minute objectForKey:@"value"];
        NSLog(@"minute: %@", value);
        [self.arrayOfValues addObject:value];
        [self.arrayOfDates addObject:time];
    }
    
    totalNumber = [sleep count];
}

- (NSDate *)dateForGraphAfterDate:(NSDate *)date {
    NSTimeInterval secondsInTwelveHours = 60;

    NSDate *newDate = [date dateByAddingTimeInterval:secondsInTwelveHours];
    return newDate;
}


#pragma mark - Graph Actions

- (IBAction)refresh:(id)sender {
    [self loadDataIntoView];
    
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

-(void)viewDidAppear:(BOOL)animated {
    if (_oauthToken == nil || [_oauthToken isEqual:@""]) {
        [self login];
    }

}

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graphBox {
    return (int)[self.arrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.arrayOfValues objectAtIndex:index] doubleValue];
}

- (void) loadDataIntoView {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *baseDate = [formatter dateFromString:@"2015-04-28"];
    
    NSData *data = [FitbitService getSleepData:baseDate withToken:self.oauthToken andSecret:self.oauthTokenSecret];
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    
    NSArray* sleepData = [json objectForKey:@"sleep"];
    NSDictionary *sleepD = sleepData[0];
    NSNumber *efficiency = [sleepD objectForKey:@"efficiency"];
    NSNumber *duration = [sleepD objectForKey:@"duration"];
    NSArray *sleep = [sleepD objectForKey:@"minuteData"];
    
    [formatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
    NSString *dateString = [formatter stringFromDate:baseDate];
    self.dateLbl.text = dateString;
    self.qualityLbl.text = [NSString stringWithFormat:@"%@ %%", efficiency];
    
    NSDate *dureationDate = [NSDate dateWithTimeIntervalSince1970:[duration doubleValue]];
    [formatter setDateFormat:@"HH'h 'mm'm'"];
    self.durationLbl.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:dureationDate]];
    
    [self hydrateDatasets:sleep];
    [self loadGraph];
}

- (void)login {
    
    NSString *token = [Preferences getUserPreference:FITBIT_OAUTH_TOKEN];
    NSString *secret = [Preferences getUserPreference:FITBIT_OAUTH_TOKEN_SECRET];
    
    if (token != nil && secret != nil) {
        self.oauthToken = token;
        self.oauthTokenSecret = secret;
        [self loadDataIntoView];
        return;
    }
    
    LoginWebViewController *loginWebViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginWebViewController"];
    
    [self presentViewController:loginWebViewController
                       animated:YES
                     completion:^{
                         [self.oauth1Controller loginWithWebView:loginWebViewController.webView completion:^(NSDictionary *oauthTokens, NSError *error) {
                             if (!error) {
                                 // Store your tokens for authenticating your later requests, consider storing the tokens in the Keychain
                                 self.oauthToken = oauthTokens[@"oauth_token"];
                                 self.oauthTokenSecret = oauthTokens[@"oauth_token_secret"];
                                 
                                 [Preferences setUserPreference:self.oauthToken forKey:FITBIT_OAUTH_TOKEN];
                                 
                                 [Preferences setUserPreference:self.oauthTokenSecret forKey:FITBIT_OAUTH_TOKEN_SECRET];
                             }
                             else
                             {
                                 NSLog(@"Error authenticating: %@", error.localizedDescription);
                             }
                             [self dismissViewControllerAnimated:YES completion: ^{
                                 self.oauth1Controller = nil;
                                 [self loadDataIntoView];
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
