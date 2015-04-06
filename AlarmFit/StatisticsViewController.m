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
@property (strong, nonatomic) IBOutlet UITextView *responseText;
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *graphBox;

@property (strong, nonatomic) IBOutlet UISegmentedControl *curveChoice;


@end

@implementation StatisticsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self hydrateDatasets];
    
    /* This is commented out because the graph is created in the interface with this sample app. However, the code remains as an example for creating the graph using code. */
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

- (void)hydrateDatasets {
    
    if(!self.arrayOfValues) self.arrayOfValues = [[NSMutableArray alloc] init];
    if(!self.arrayOfDates) self.arrayOfDates = [[NSMutableArray alloc] init];
    [self.arrayOfValues removeAllObjects];
    [self.arrayOfDates removeAllObjects];
    
    NSDate *baseDate = [NSDate date];
    BOOL showNullValue = true;
    
    
    for (int i = 0; i < 9; i++) {
        [self.arrayOfValues addObject:@([self getRandomFloat])]; // Random values for the graph
        if (i == 0) {
            [self.arrayOfDates addObject:baseDate]; // Dates for the X-Axis of the graph
        } else if (showNullValue && i == 4) {
            [self.arrayOfDates addObject:[self dateForGraphAfterDate:self.arrayOfDates[i-1]]]; // Dates for the X-Axis of the graph
            self.arrayOfValues[i] = @(BEMNullGraphValue);
        } else {
            [self.arrayOfDates addObject:[self dateForGraphAfterDate:self.arrayOfDates[i-1]]]; // Dates for the X-Axis of the graph
        }
        
        
        totalNumber = totalNumber + [[self.arrayOfValues objectAtIndex:i] intValue]; // All of the values added together
    }
}

- (NSDate *)dateForGraphAfterDate:(NSDate *)date {
    NSTimeInterval secondsInTwelveHours = 12 * 60 * 60;
    NSDate *newDate = [date dateByAddingTimeInterval:secondsInTwelveHours];
    return newDate;
}


#pragma mark - Graph Actions

- (IBAction)refresh:(id)sender {
    [self hydrateDatasets];
    
    UIColor *color;
//    if (self.graphColorChoice.selectedSegmentIndex == 0) color = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
//    else if (self.graphColorChoice.selectedSegmentIndex == 1) color = [UIColor colorWithRed:255.0/255.0 green:187.0/255.0 blue:31.0/255.0 alpha:1.0];
//    else if (self.graphColorChoice.selectedSegmentIndex == 2) color = [UIColor colorWithRed:0.0 green:140.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    color = [UIColor colorWithRed:0.0 green:140.0/255.0 blue:255.0/255.0 alpha:1.0];
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
    //if (_oauthToken == nil || [_oauthToken isEqual:@""]) {
        //[self login];
    //}
    
}


//- (IBAction)testGETRequest:(id)sender
//{
//    
//    NSString *path = @"1/user/-/sleep/date/2015-02-20.json";
//    
//    NSURLRequest *preparedRequest = [OAuth1Controller preparedRequestForPath:path
//                                                                  parameters:nil
//                                                                  HTTPmethod:@"GET"
//                                                                  oauthToken:self.oauthToken
//                                                                 oauthSecret:self.oauthTokenSecret];
//    
//    [NSURLConnection sendAsynchronousRequest:preparedRequest
//                                       queue:NSOperationQueue.mainQueue
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//                               
//                               dispatch_async(dispatch_get_main_queue(), ^{
//                                   
//                                   NSLog(@"path35 %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//                                   
//                                   [self.responseText setText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
//                                   
//                                   if (error) NSLog(@"Error in API request: %@", error.localizedDescription);
//                               });
//                           }];
//    
//}

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graphBox {
    return 20; // Number of points in the graph.
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return 5;
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
