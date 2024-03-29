/*
 * Copyright 2010 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#define CC_MD5_DIGEST_LENGTH	16			/* digest length in bytes */

#import "FacebookMassWave.h"
#import "FBLoginDialog.h"
#import "FBRequest.h"
#import "mmsvViewController.h"

static NSString* kOAuthURL = @"https://graph.facebook.com/oauth/authorize";
static NSString* kOAuthSessionURL = @"https://api.facebook.com/method/authSession.get";
static NSString* kRedirectURL = @"fbconnect://success";
static NSString* kGraphBaseURL = @"https://graph.facebook.com/";
static NSString* kRestApiURL = @"https://api.facebook.com/method/";
static NSString* kUIserverBaseURL = @"http://www.facebook.com/connect/uiserver.php";
static NSString* kCancelURL = @"fbconnect://cancel";
static NSString* kLogin = @"login";
static NSString* kSDKVersion = @"ios";

static NSString* kRestApiVideoURL = @"https://api-video.facebook.com/method/";
static NSString* kRestApiVideoURL1 = @"http://api-video.facebook.com/restserver.php/";

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation FacebookMassWave

@synthesize accessToken = _accessToken, 
         expirationDate = _expirationDate, 
        sessionDelegate = _sessionDelegate,
		token;

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

/**
 * private helper function for send http request to an url with specified
 * http method @"GET" or @"POST" and specified parameters 
 * 
 * @param url
 *            url to send http request
 * @param params
 *            parameters to append to the url
 * @param httpMethod
 *            http method @"GET" or @"POST"
 * @param delegate
 *            Callback interface for notifying the calling application when
 *            the request has received response
 */
- (void) openUrl:(NSString *)url 
          params:(NSMutableDictionary *)params 
      httpMethod:(NSString *)httpMethod 
        delegate:(id<FBRequestDelegate>)delegate {
  
	//BOOL sess =[self isSessionValid] ;
	//NSLog(@"aray------ %@",sess);
  //[params setValue:kSDKVersion forKey:@"sdk"];
	if([self isSessionValid] ){
		if ( !(isVideoUp) ) {
			[params setValue:self.accessToken forKey:@"access_token"];
			NSLog(@"aray------ %@",self.accessToken);
		}else {
			NSArray *numbers = [self.accessToken componentsSeparatedByString:@"|"];
			[params setValue:[numbers objectAtIndex:1] forKey:@"session_key"] ;
			
			NSLog(@"aray------ %@",self.accessToken);
		}
	}
    [params setValue:@"json" forKey:@"format"];
  [_request release];
  _request = [[FBRequest getRequestWithParams:params
                                   httpMethod:httpMethod
                                     delegate:delegate
                                   requestURL:url] retain];
  [_request connect];
}

- (NSString*)md5HexDigest:(NSString*)input {
	const char* str = [input UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(str, strlen(str), result);
	
	NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
	for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
		[ret appendFormat:@"%02x",result[i]];
	}
	return ret;
}

- (NSString*)generateSig {
	NSMutableString* joined = [NSMutableString string]; 
	//if ([self isSpecialMethod]) {
//		if (_session.apiSecret) {
//			[joined appendString:_session.apiSecret];
//		}
//	} else if (_session.sessionSecret) {
//		[joined appendString:_session.sessionSecret];
//	} else if (_session.apiSecret) {
//		[joined appendString:_session.apiSecret];
//	}
	
	return [self md5HexDigest:joined];
}


- (NSString *) getStringFromUrl: (NSString*) url needle:(NSString *) needle {
	NSString * str = nil;
	NSRange start = [url rangeOfString:needle];
	if (start.location != NSNotFound) {
		NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
		NSUInteger offset = start.location+start.length;
		str = end.location == NSNotFound
		? [url substringFromIndex:offset]
		: [url substringWithRange:NSMakeRange(offset, end.location)];  
		str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
	}
	
	return str;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
//public

/**
 * Starts a dialog which prompts the user to log in to Facebook and grant
 * the requested permissions to the given application.
 * 
 * This method implements the OAuth 2.0 User-Agent flow to retrieve an 
 * access token for use in API requests.  In this flow, the user 
 * credentials are handled by Facebook in an embedded WebView, not by the 
 * client application.  As such, the dialog makes a network request and 
 * renders HTML content rather than a native UI.  The access token is 
 * retrieved from a redirect to a special URL that the WebView handles.
 * 
 * Note that User credentials could be handled natively using the 
 * OAuth 2.0 Username and Password Flow, but this is not supported by this
 * SDK.
 * 
 * See http://developers.facebook.com/docs/authentication/ and 
 * http://wiki.oauth.net/OAuth-2 for more details.
 * 
 * Also note that requests may be made to the API without calling 
 * authorize first, in which case only public information is returned.
 * 
 *
 * @param application_id
 *            The Facebook application identifier e.g. "350685531728"
 * @param permissions
 *            A list of permission required for this application: e.g.
 *            "read_stream", "publish_stream", "offline_access", etc. see
 *            http://developers.facebook.com/docs/authentication/permissions
 *            This parameter should not be null -- if you do not require any
 *            permissions, then pass in an empty String array.
 * @param delegate
 *            Callback interface for notifying the calling application when
 *            the application has logged in
 */
- (void) authorize:(NSString*)application_id
       permissions:(NSArray*)permissions
          delegate:(id<FBSessionDelegate>)delegate {
  
  NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								 application_id, @"client_id",
								 @"user_agent", @"type", 
								 kRedirectURL, @"redirect_uri",
								 @"touch", @"display", 
								 kSDKVersion, @"sdk",
								 nil];
  
  if (permissions != nil) {
    NSString* scope = [permissions componentsJoinedByString:@","];
    [params setValue:scope forKey:@"scope"];
  }
	isVideoUp= NO;
 _sessionDelegate = delegate;
  
  //[_loginDialog release];
    
    NSLog(@"params = %@",params);
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"Access_Token = %@",[standardUserDefaults valueForKey:@"Access_Token"]);
    
    
    _loginDialog = [[FBLoginDialog alloc] initWithURL:kOAuthURL 
                                          loginParams:params 
                                             delegate:self];
    
    [_loginDialog show];
    
    if([standardUserDefaults valueForKey:@"Access_Token"] == nil)
    {
       
    }
}

/**
 * Invalidate the current user session by removing the access token in
 * memory, clearing the browser cookie, and calling auth.expireSession
 * through the API.  
 * 
 * @param delegate
 *            Callback interface for notifying the calling application when
 *            the application has logged out
 */
- (void)logout:(id<FBSessionDelegate>)delegate {
 
  _sessionDelegate = delegate;
  
  NSMutableDictionary * params = [[NSMutableDictionary alloc] init]; 
  [self requestWithMethodName:@"auth.expireSession" 
                    andParams:params andHttpMethod:@"GET" 
                  andDelegate:self];
  
  [params release];
  [_accessToken release];
  _accessToken = nil;
  [_expirationDate release];
  _expirationDate = nil;
  isVideoUp= NO;
  NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
  NSArray* facebookCookies = [cookies cookiesForURL:
    [NSURL URLWithString:@"http://login.facebook.com"]];
  
  for (NSHTTPCookie* cookie in facebookCookies) {
    [cookies deleteCookie:cookie];
  }
    
    NSHTTPCookieStorage* cookies1 = [NSHTTPCookieStorage sharedHTTPCookieStorage]; for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) 
    { 
        [cookies1 deleteCookie:cookie]; 
    }
  
  if ([self.sessionDelegate respondsToSelector:@selector(fbDidLogout)]) {
    [_sessionDelegate fbDidLogout];
  }
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setValue:nil forKey:@"Access_Token"];
    [standardUserDefaults setValue:nil forKey:@"FB_URL"];
    [standardUserDefaults synchronize];
    
}


- (void)fbgetSession:(id<FBSessionDelegate>) delegate
		   andParams:(NSMutableDictionary *) params{
	_sessionDelegate = delegate;
	
	 
	
	NSString * fullURL = [kRestApiURL stringByAppendingString:@"auth.getSession"];
	[_request release];
	_request = [[FBRequest getRequestWithParams:params
									 httpMethod:@"GET"
									   delegate:self
									 requestURL:fullURL] retain];
	[_request connect];
}



/**
 * Make a request to Facebook's REST API with the given 
 * parameters. One of the parameter keys must be "method" and its value 
 * should be a valid REST server API method.  
 * 
 * See http://developers.facebook.com/docs/reference/rest/
 *  
 * @param parameters
 *            Key-value pairs of parameters to the request. Refer to the
 *            documentation: one of the parameters must be "method". 
 * @param delegate
 *            Callback interface for notifying the calling application when
 *            the request has received response
 */
- (void) requestWithParams:(NSMutableDictionary *)params 
               andDelegate:(id <FBRequestDelegate>)delegate {
  if ([params objectForKey:@"method"] == nil) {
    NSLog(@"API Method must be specified");
    return;
  }
	isVideoUp= NO;
  
  NSString * methodName = [params objectForKey:@"method"];
  [params removeObjectForKey:@"method"];
  
  [self requestWithMethodName:methodName
                    andParams:params 
                andHttpMethod:@"GET" 
                  andDelegate:delegate];
}

/**
 * Make a request to Facebook's REST API with the given method name and
 * parameters.  
 * 
 * See http://developers.facebook.com/docs/reference/rest/
 *  
 * 
 * @param methodName
 *             a valid REST server API method.
 * @param parameters
 *            Key-value pairs of parameters to the request. Refer to the
 *            documentation: one of the parameters must be "method". To upload
 *            a file, you should specify the httpMethod to be "POST" and the 
 *            “params” you passed in should contain a value of the type 
 *            (UIImage *) or (NSData *) which contains the content that you 
 *            want to upload
 * @param delegate
 *            Callback interface for notifying the calling application when
 *            the request has received response
 */
-(void) requestWithMethodName:(NSString *)methodName 
                    andParams:(NSMutableDictionary *)params 
                andHttpMethod:(NSString *)httpMethod 
                  andDelegate:(id <FBRequestDelegate>)delegate {
  NSString * fullURL = [kRestApiURL stringByAppendingString:methodName];
	isVideoUp= NO;
	//_sessionDelegate = delegate;
  [self openUrl:fullURL params:params httpMethod:httpMethod delegate:delegate];
}

-(void) requestWithMethodName:(NSString *)methodName 
                    andParams:(NSMutableDictionary *)params 
                andHttpMethod:(NSString *)httpMethod 
                  andDelegate:(id <FBRequestDelegate>)delegate 
							isVideo:(BOOL)is{
	isVideoUp = NO;
	NSString * fullURL = [kRestApiVideoURL stringByAppendingString:methodName];
	[self openUrl:fullURL params:params httpMethod:httpMethod delegate:delegate];
}



/**
 * Make a request to the Facebook Graph API without any parameters.
 * 
 * See http://developers.facebook.com/docs/api
 * 
 * @param graphPath
 *            Path to resource in the Facebook graph, e.g., to fetch data
 *            about the currently logged authenticated user, provide "me",
 *            which will fetch http://graph.facebook.com/me
 * @param delegate
 *            Callback interface for notifying the calling application when
 *            the request has received response
 */
- (void) requestWithGraphPath:(NSString *)graphPath 
                  andDelegate:(id <FBRequestDelegate>)delegate {
  
  [self requestWithGraphPath:graphPath 
                   andParams:[NSMutableDictionary dictionary] 
               andHttpMethod:@"GET" 
                 andDelegate:delegate];
  
}

/**
 * Make a request to the Facebook Graph API with the given string 
 * parameters using an HTTP GET (default method).
 * 
 * See http://developers.facebook.com/docs/api
 *  
 * 
 * @param graphPath
 *            Path to resource in the Facebook graph, e.g., to fetch data
 *            about the currently logged authenticated user, provide "me",
 *            which will fetch http://graph.facebook.com/me
 * @param parameters
 *            key-value string parameters, e.g. the path "search" with
 *            parameters "q" : "facebook" would produce a query for the
 *            following graph resource:
 *            https://graph.facebook.com/search?q=facebook
 * @param delegate
 *            Callback interface for notifying the calling application when
 *            the request has received response
 */
-(void) requestWithGraphPath:(NSString *)graphPath 
                   andParams:(NSMutableDictionary *)params  
                 andDelegate:(id <FBRequestDelegate>)delegate {
 
  [self requestWithGraphPath:graphPath 
                   andParams:params 
               andHttpMethod:@"GET" 
                 andDelegate:delegate];  
}

/**
 * Make a request to the Facebook Graph API with the given
 * HTTP method and string parameters. Note that binary data parameters 
 * (e.g. pictures) are not yet supported by this helper function.
 * 
 * See http://developers.facebook.com/docs/api
 *  
 * 
 * @param graphPath
 *            Path to resource in the Facebook graph, e.g., to fetch data
 *            about the currently logged authenticated user, provide "me",
 *            which will fetch http://graph.facebook.com/me
 * @param parameters
 *            key-value string parameters, e.g. the path "search" with
 *            parameters {"q" : "facebook"} would produce a query for the
 *            following graph resource:
 *            https://graph.facebook.com/search?q=facebook
 *            To upload a file, you should specify the httpMethod to be 
 *            "POST" and the “params” you passed in should contain a value 
 *            of the type (UIImage *) or (NSData *) which contains the 
 *            content that you want to upload
 * @param httpMethod
 *            http verb, e.g. "GET", "POST", "DELETE"
 * @param delegate
 *            Callback interface for notifying the calling application when
 *            the request has received response
 */
-(void) requestWithGraphPath:(NSString *)graphPath 
                   andParams:(NSMutableDictionary *)params 
               andHttpMethod:(NSString *)httpMethod 
                 andDelegate:(id <FBRequestDelegate>)delegate {
  NSString * fullURL = [kGraphBaseURL stringByAppendingString:graphPath];
  [self openUrl:fullURL params:params httpMethod:httpMethod delegate:delegate];
}

/**
 * Generate a UI dialog for the request action.
 * 
 * @param action
 *            String representation of the desired method: e.g. "login",
 *            "stream.publish", ...
 * @param delegate
 *            Callback interface to notify the calling application when the 
 *            dialog has completed.
 */
- (void) dialog:(NSString *)action 
    andDelegate:(id<FBDialogDelegate>)delegate {
  NSMutableDictionary * params = [NSMutableDictionary dictionary];
  [self dialog:action andParams:params andDelegate:delegate];
}

/**
 * Generate a UI dialog for the request action with the provided parameters.
 * 
 * @param action
 *            String representation of the desired method: e.g. "login",
 *            "stream.publish", ...
 * @param parameters
 *            key-value string parameters
 * @param delegate
 *            Callback interface to notify the calling application when the 
 *            dialog has completed.
 */
- (void) dialog:(NSString *)action 
      andParams:(NSMutableDictionary *)params 
    andDelegate:(id <FBDialogDelegate>)delegate {
  
  
  [params setObject:@"touch" forKey:@"display"];
  [params setObject: kSDKVersion forKey:@"sdk"];
  
  if (action == kLogin) {
    [params setObject:@"user_agent" forKey:@"type"];
    [params setObject:kRedirectURL forKey:@"redirect_uri"];
    
    [_fbDialog release];
    _fbDialog = [[FBLoginDialog alloc] initWithURL:kOAuthURL loginParams:params delegate:self]; 
                 
  } else {
    [params setObject:action forKey:@"method"];
    [params setObject:kRedirectURL forKey:@"next"];
    [params setObject:kCancelURL forKey:@"cancel_url"];
  
    if ([self isSessionValid]) {
      [params setValue: [self.accessToken stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"access_token"];
    }
   
    [_fbDialog release];
    _fbDialog = [[FBDialog alloc] initWithURL:kUIserverBaseURL params:params delegate:delegate]; 

  }

  [_fbDialog show];  
}

/**
 * @return boolean - whether this object has an non-expired session token
 */
- (BOOL) isSessionValid {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDate* expirationDate = [defaults objectForKey:@"FBSessionExpires"];
    if (!expirationDate || [expirationDate timeIntervalSinceNow] > 0) {
		expirationDate = [expirationDate retain];
	}
		
  //return (self.accessToken != nil && self.expirationDate != nil 
    //       && NSOrderedDescending == [self.expirationDate compare:[NSDate date]]); 
	return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//FBLoginDialogDelegate

/**
 * Set the authToken and expirationDate after login succeed
 */
- (void)fbDialogLogin:(NSString *)token1 expirationDate:(NSDate *)expirationDate {
  self.accessToken = token1;
  self.expirationDate = expirationDate;
  if ([self.sessionDelegate respondsToSelector:@selector(fbDidLogin)]) {
    [_sessionDelegate fbDidLogin];
  }
      
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setValue:token1 forKey:@"Access_Token"];
    [standardUserDefaults synchronize];

}

/**
 * Did not login call the not login delegate
 */
- (void) fbDialogNotLogin:(BOOL)cancelled {
  if ([self.sessionDelegate respondsToSelector:@selector(fbDidNotLogin:)]) {
    [_sessionDelegate fbDidNotLogin:cancelled];
      
  }
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
//FBRequestDelegate

/**
 * Handle the auth.ExpireSession api call failure
 */
- (void)request:(FBRequest*)request didFailWithError:(NSError*)error{
  NSLog(@"Failed to expire the session"); 
}

///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Override NSObject : free the space
 */
- (void)dealloc {
  [_accessToken release];
  [_expirationDate release];
  [_request release];
  [_loginDialog release];
  [_fbDialog release];
  [super dealloc];
}
                 
@end
