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

@interface StatisticsViewController ()


@property (nonatomic, strong) OAuth1Controller *oauth1Controller;
@property (nonatomic, strong) NSString *oauthToken;
@property (nonatomic, strong) NSString *oauthTokenSecret;
@property (strong, nonatomic) IBOutlet UITextView *responseText;

@end

@implementation StatisticsViewController


-(void)viewDidAppear:(BOOL)animated {
    if (_oauthToken == nil || [_oauthToken isEqual:@""]) {
        [self login];
    }
    
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


- (IBAction)testGETRequest:(id)sender
{
    
    NSString *path = @"1/user/-/sleep/date/2015-02-20.json";
    
    NSURLRequest *preparedRequest = [OAuth1Controller preparedRequestForPath:path
                                                                  parameters:nil
                                                                  HTTPmethod:@"GET"
                                                                  oauthToken:self.oauthToken
                                                                 oauthSecret:self.oauthTokenSecret];
    
    [NSURLConnection sendAsynchronousRequest:preparedRequest
                                       queue:NSOperationQueue.mainQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   
                                   NSLog(@"path35 %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                   
                                   [self.responseText setText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
                                   
                                   if (error) NSLog(@"Error in API request: %@", error.localizedDescription);
                               });
                           }];
    
}

@end
