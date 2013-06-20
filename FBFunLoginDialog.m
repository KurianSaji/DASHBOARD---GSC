//
//  FBFunLoginDialog.m
//  FBFun
//
//  Created by Ray Wenderlich on 7/13/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "FBFunLoginDialog.h"
#import "epubstore_svcAppDelegate.h"

@implementation FBFunLoginDialog
@synthesize webView = _webView;
@synthesize apiKey = _apiKey;
@synthesize requestedPermissions = _requestedPermissions;
@synthesize delegate = _delegate;

#pragma mark Main

- (id)initWithAppId:(NSString *)apiKey requestedPermissions:(NSString *)requestedPermissions delegate:(id<FBFunLoginDialogDelegate>)delegate {
    if ((self = [super initWithNibName:@"FBLoginipad" bundle:[NSBundle mainBundle]])) {
        self.apiKey = apiKey;
        self.requestedPermissions = requestedPermissions;
        self.delegate = delegate;
    }
    return self;    
}

- (void)dealloc {
    self.webView = nil;
    self.apiKey = nil;
    self.requestedPermissions = nil;
    [super dealloc];
}

#pragma mark Login / Logout functions

- (void)login {
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
       
    NSString *redirectUrlString = @"http://www.facebook.com/connect/login_success.html";
    NSString *authFormatString = @"https://graph.facebook.com/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@&type=user_agent&display=touch";
       
    NSString *urlString = [NSString stringWithFormat:authFormatString, _apiKey, redirectUrlString, _requestedPermissions];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];	   
}

-(void)logout {    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookies deleteCookie:cookie];
    }
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlString = request.URL.absoluteString;
    
    [self checkForAccessToken:urlString];    
    [self checkLoginRequired:urlString];
    
    return TRUE;
}

#pragma mark Helper functions

-(void)checkForAccessToken:(NSString *)urlString {
    //NSError *error;
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"access_token=(.*)&" options:0 error:&error];
	NSLog(@"Access Token==%@",urlString);
	NSArray *arr= [urlString componentsSeparatedByString:@"access_token="];
	if ([arr count]>1)
	{
		NSLog(@"First %@",arr);
		NSString *str=[arr objectAtIndex:1];
		NSArray *arr1= [str componentsSeparatedByString:@"&expires_in"];
		if ([arr count]>1)
		{
			NSString *accessToken=[arr1 objectAtIndex:0];
			NSLog(@"Second %@",accessToken);
			//[_delegate accessTokenFound:accessToken]; 
			epubstore_svcAppDelegate *appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
			[appDelegate accessTokenFound:accessToken]; 
		}
	}
	else {
		NSLog(@"Cancel checking==>%@",urlString);
		NSArray *arrCancel= [urlString componentsSeparatedByString:@"error_reason=user_denied"];
		if ([arrCancel count]>1)
		{
			epubstore_svcAppDelegate *appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
			[appDelegate closeTapped]; 
		}
		
	}

	
//	NSString *emailRegex = @"access_token=(.*)&"; 
//	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"%@", emailRegex]; 
//	BOOL notAValidEmail = ![emailTest evaluateWithObject:urlString];
//	
//    if (notAValidEmail) {
//        NSTextCheckingResult *firstMatch = [regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
//		NSRange range = [urlString rangeOfString:emailRegex];
		
		// Did we find the string "IPA" ?
//		if (range.location != NSNotFound)
//		{
            //NSRange accessTokenRange = [range  rangeAtIndex:1];
//            NSString *accessToken = [urlString substringWithRange:accessTokenRange];
//            accessToken = [accessToken stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            [_delegate accessTokenFound:accessToken];               
//        }
//    }
}

-(void)checkLoginRequired:(NSString *)urlString {
    if ([urlString rangeOfString:@"login.php"].location != NSNotFound) {
		epubstore_svcAppDelegate *appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate displayRequired];
    }
}

- (IBAction)closeTapped:(id)sender {
    [_delegate closeTapped];
}

@end
