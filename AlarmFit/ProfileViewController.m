//
//  ProfileViewController.m
//  AlarmFit
//
//  Created by Chrysanthi Vandera on 4/29/15.
//  Copyright (c) 2015 chrysanthicodes. All rights reserved.
//

#import "ProfileViewController.h"
#import "OAuth1Controller.h"
#import "LoginWebViewController.h"
#import "Preferences.h"
#import "FitbitService.h"

@interface ProfileViewController (){
}

@property (nonatomic, strong) OAuth1Controller *oauth1Controller;
@property (nonatomic, strong) NSString *oauthToken;
@property (nonatomic, strong) NSString *oauthTokenSecret;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *genderLbl;
@property (weak, nonatomic) IBOutlet UILabel *ageLbl;
@property (weak, nonatomic) IBOutlet UILabel *batteryLbl;
@property (weak, nonatomic) IBOutlet UILabel *deviceLbl;
@property (weak, nonatomic) IBOutlet UILabel *badgesLbl;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    if (_oauthToken == nil || [_oauthToken isEqual:@""]) {
        [self login];
        [self loadDataIntoView];
    }
    
}

- (void) loadDataIntoView {
    NSData *data = [FitbitService getUserData:nil withToken:self.oauthToken andSecret:self.oauthTokenSecret];
    
    NSError* error;
    if (data != nil) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        
        NSDictionary* userData = [json objectForKey:@"user"];
        NSString *fullname = [userData objectForKey:@"fullName"];
        NSString *gender = [userData objectForKey:@"gender"];
        NSNumber *age = [userData objectForKey:@"age"];
        NSArray *badges = [userData objectForKey:@"topBadges"];
        
        self.nameLbl.text = fullname;
        self.genderLbl.text = gender;
        self.ageLbl.text = [NSString stringWithFormat:@"%@ years old",[age stringValue]];
        NSUInteger count = [badges count];
        self.badgesLbl.text = [NSString stringWithFormat:@"%lu", (unsigned long)count];
    }
    
    data = [FitbitService getDeviceDataWithToken:self.oauthToken andSecret:self.oauthTokenSecret];
    
    if (data != nil) {
        NSArray* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        
        NSDictionary* deviceData = json[0];
        NSString *battery = [deviceData objectForKey:@"battery"];
        NSString *deviceVersion = [deviceData objectForKey:@"deviceVersion"];
        
        self.batteryLbl.text = battery;
        self.deviceLbl.text = deviceVersion;
        
    }
}
- (IBAction)logoutButton:(id)sender {
    [Preferences setUserPreference:nil forKey:FITBIT_OAUTH_TOKEN];
    [Preferences setUserPreference:nil forKey:FITBIT_OAUTH_TOKEN_SECRET];
    [self login];
}

- (void)login {
    
    NSString *token = [Preferences getUserPreference:FITBIT_OAUTH_TOKEN];
    NSString *secret = [Preferences getUserPreference:FITBIT_OAUTH_TOKEN_SECRET];
    
    if (token != nil && secret != nil) {
        self.oauthToken = token;
        self.oauthTokenSecret = secret;
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
