    //
//  login.m
//  maximSocialVideo
//
//  Created by neo on 12/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "login.h"
//static NSString *kAppId=@"247740738612415";
//#define kOAuthConsumerKey @"TT6Z5hPUoIms4v8rkhapag";
//#define kOAuthConsumerSecret @"TBKuAHe2NLYlnleVX64Zko5CQ8NeoDgGmr3GagGe3M";

static NSString *kAppId=@"301875916529255";

static FacebookMassWave *_facebook;


@implementation login

@synthesize lgn_MainView, lgn_bottomView, lgn_LoginView;

@synthesize btnCancel, btnFbLogin;

@synthesize _delegate;

epubstore_svcAppDelegate *appDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        loginDefaults = [NSUserDefaults standardUserDefaults];
        
         lgn_MainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height+20)];
        lgn_MainView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        [self.view addSubview:lgn_MainView];
        
        [self loadLoginButtons];
        [self setbotomTab];
        
            
        
        	if([login initFb]==nil)
        	{
        		_permissions =[[NSArray arrayWithObjects: @"read_stream",@"user_photos",@"user_about_me",@"user_birthday",@"user_location",@"user_hometown",@"email",@"read_friendlists",nil] retain];
              
                
            }
        
      //[self logoutFB];
        
    }
    return self;
}
+(FacebookMassWave*)initFb
{
    if (!_facebook) {
        _facebook = [[FacebookMassWave alloc] init];
    }
  
    return _facebook;
}


+(void)nilFb
{
    
    [_facebook release];
    _facebook = nil;
    
}

-(void)loadLoginButtons
{

//
    
    lgn_LoginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, lgn_MainView.frame.size.width , lgn_MainView.frame.size.height+20)];
    [lgn_MainView addSubview:lgn_LoginView];
    
    int shareX,shareY,shareW,shareH, fontSize;
    
    
    UIImage *tempImage;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        fontSize = 15; 
        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"fb_icon_iphone" ofType:@"png"]];
    }
    else
    {
        fontSize = 30;
        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"fb_icon_ipad" ofType:@"png"]];
    }
    shareX = (lgn_MainView.frame.size.width/2)-(tempImage.size.width/2);
    shareY = (lgn_MainView.frame.size.height/2)-(tempImage.size.height/2);
    shareW = tempImage.size.width ;
    shareH = tempImage.size.height;
    
    
   
    btnFbLogin  = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFbLogin.frame = CGRectMake(shareX,shareY,shareW,shareH);

    //[btnFbLogin setTitle:@"CANCEL" forState:UIControlStateNormal];
    //(btnFbLogin).titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
    [btnFbLogin setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
    //[btnFbLogin setCusImage:tempImage initWithFrame:CGRectMake(0, 0, tempImage.size.width , tempImage.size.height)];
    [btnFbLogin setImage:tempImage forState:UIControlStateNormal];
    
    [btnFbLogin addTarget:self action:@selector(facebtnact:) forControlEvents:UIControlEventTouchUpInside]; 
    [lgn_LoginView addSubview:btnFbLogin];
    
    
    
    
    
    UILabel *_fbText = [[UILabel alloc] initWithFrame:CGRectMake(0, ((tempImage.size.height/3)*2), tempImage.size.width, (tempImage.size.height/3))];
    
    _fbText.text = @"login";
    
    _fbText.font = [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
    
    _fbText.textColor =  [ UIColor colorWithRed:54/255.0 green:50/255.0 blue:47/255.0 alpha:1];
    
    _fbText.textAlignment = UITextAlignmentCenter;
    
    [btnFbLogin addSubview:_fbText];
    
    
    [_fbText release];
    
    [tempImage release];
    

}

-(void)setbotomTab
{
    
    int shareX,shareY,shareW,shareH, fontSize;
    UIImage *tempImage;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"yellow_line_iphone" ofType:@"png"]];
        shareX = 10;
        shareY = 0;
        shareW = tempImage.size.width ;
        shareH = 50;
        fontSize = 15;
        
        
        
    }
    else
    {
        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"yellow_line_ipad" ofType:@"png"]];
        
        shareX = 20;
        shareY = 0;
        shareW = tempImage.size.width ;
        shareH = 50;
        fontSize = 30;
        
    }
    
    
    // vl_bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-30, self.view.frame.size.width , 50)];
    lgn_bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-30, self.view.frame.size.width , 50)];
    lgn_bottomView.backgroundColor = [UIColor blackColor];
    [lgn_MainView addSubview:lgn_bottomView];
    
   
    
    btnCancel  = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(shareX,shareY,shareW,shareH);
    btnCancel.backgroundColor = [UIColor clearColor];
    [btnCancel setTitle:@"CANCEL" forState:UIControlStateNormal];
    (btnCancel).titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
    [btnCancel setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
    [btnCancel setCusImage:tempImage initWithFrame:CGRectMake(0, 0, tempImage.size.width , tempImage.size.height)];
    [btnCancel addTarget:self action:@selector(cancelLogin) forControlEvents:UIControlEventTouchUpInside]; 
    [lgn_bottomView addSubview:btnCancel];
    
    
    
    [tempImage release];
    
}

-(void)cancelLogin
{
    [self dismissModalViewControllerAnimated:NO];
}


-(void)logoutFB
{
    [[login initFb] logout:self];

}

-(void)facebtnact //:(id)sender
{
	
	NSLog(@"facebtnact...");
	
	
//	if(_facebook==nil)
//	{
//		_permissions =[[NSArray arrayWithObjects: @"read_stream",@"user_photos",@"read_friendlists",nil] retain];
		
		[[login initFb] authorize:kAppId permissions:_permissions delegate:self];
//	}
	

	
	
}
-(void) fbDidLogin 
{
	NSLog(@"did  login");	
    
   
	
    [[login initFb] requestWithGraphPath:@"me" andDelegate:self]; 
    //[[login initFb] requestWithGraphPath:@"me/friends" andDelegate:self];
    //[self performSelectorInBackground:@selector(fetchfFriends) withObject:nil];
     dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
         [[login initFb] requestWithGraphPath:@"me/friends" andDelegate:self];
     });
	
    
}


-(void)fetchfFriends
{
    
    NSLog(@"me/friendsme/friendsme/friendsme/friendsme/friendsme/friendsme/friends");

    [[login initFb] requestWithGraphPath:@"me/friends" andDelegate:self];
}


- (void)request:(FBRequest*)request didLoad:(id)result {

    NSLog(@"request.url--- %@",request.url);
    NSLog(@"request.url--- %@",result);
    
    if ([request.url isEqualToString:@"https://graph.facebook.com/me"]) 
    {
        NSLog(@"result is ---- %@",result);
        NSLog(@"email is ---- %@",[result objectForKey:@"email"]);
        NSLog(@"first_name is ---- %@",[result objectForKey:@"first_name"]);
        NSLog(@"last_name is ---- %@",[result objectForKey:@"last_name"]);
        NSLog(@"id is ---- %@",[result objectForKey:@"id"]);
        NSLog(@"username is ---- %@",[result objectForKey:@"username"]);
        NSLog(@"gender is ---- %@",[result objectForKey:@"gender"]);
        username = [[NSString alloc] init];
        userId = [result objectForKey:@"id"];
        email = [result objectForKey:@"email"];
        first_name = [result objectForKey:@"first_name"];
        last_name = [result objectForKey:@"last_name"];
        //username = [result objectForKey:@"username"];
        gender = [result objectForKey:@"gender"];
        
        username = [NSString stringWithFormat:@"%@",[result objectForKey:@"username"]];

        
        [self loginToWeb];
        
    }
    else if([request.url isEqualToString:@"https://graph.facebook.com/me/friends"])
    {
        friendsCount = [[result objectForKey:@"data"] count];
        
        appDelegate.FBfriendsList = [result objectForKey:@"data"];
                
        NSLog(@"result Count--- %d",friendsCount);
        
         NSLog(@"appDelegate.FBfriendsList--- %@",appDelegate.FBfriendsList);
        //friendsCount = 1;
        for(NSInteger i=0;i< friendsCount;i++) 
        {
            
            NSLog(@"result--- %@",[[[result objectForKey:@"data"] objectAtIndex:i] objectForKey:@"id"]);
            if (i==0) {
                    appDelegate.FBfriendsIds = [NSString stringWithFormat:@"%@",[[[result objectForKey:@"data"] objectAtIndex:i] objectForKey:@"id"]];
            }else
            {
            appDelegate.FBfriendsIds = [NSString stringWithFormat:@"%@,%@",appDelegate.FBfriendsIds, [[[result objectForKey:@"data"] objectAtIndex:i] objectForKey:@"id"]];
            
            }
            
            
            
        }
        
        NSLog(@"appDelegate.FBfriendsIds---%@",appDelegate.FBfriendsIds);
        
    }
    
}

-(void)loginToWeb
{
    
    //UIDevice *myDevice = [UIDevice currentDevice];
	
	//NSString *deviceUDID = [myDevice uniqueIdentifier];
	
    
 	//NSString *urlString =[NSString stringWithFormat:@"http://122.183.212.56/maximsocialmedia/user/add"];
   // NSString *urlString =[NSString stringWithFormat:@"http://newtoybox.com/maximsocialmedia/user/add"];
    
    NSString *urlString =[NSString stringWithFormat:@"%@users/add",ServerIp];
    
    
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
    [request setURL:[NSURL URLWithString:urlString]];
    
    NSLog(@"urlString----%@",urlString);
	
    NSLog(@"username  = %@",username);
    
    if ([username isEqualToString:@"(null)"])
    {
        username = @"";
    }
    
    NSString *myParameters = [NSString stringWithFormat:@"app_id=%@&user_id=%@&uname=%@&fname=%@&lname=%@&email=%@&gender=%@&method=user.add", kAppId, userId, username, first_name, last_name, email, gender];
    
    NSLog(@"%@",myParameters);
    
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    // now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"%@",returnString);
    
    
    
    
	
    
        
    if (returnString) 
    {
        // [[[[UIAlertView alloc] initWithTitle:@"Success" message:returnString delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] autorelease] show]; 
        
        NSString *success = [self GetValueInXML:returnString SearchStr:@"success"];
        if ([success isEqualToString:@"1"]) {
            NSString *message = [self GetValueInXML:returnString SearchStr:@"message"];
          
            NSString *strRank = [self GetValueInXML:returnString SearchStr:@"user_rank"];
            
            NSLog(@"str rank = %@",strRank);
            
            rankDefaults = [NSUserDefaults standardUserDefaults];
            
            [rankDefaults setObject:strRank forKey:@"rank"];
            
            [rankDefaults synchronize];
            
            appDelegate.userID  = [self GetValueInXML:returnString SearchStr:@"user_id"];
            //NSLog(@"appDelegate.userID",appDelegate.userID);
            
            appDelegate.logedUserFLName = [NSString stringWithFormat:@"%@ %@", first_name, last_name];
            appDelegate.logedUserImg = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",username];
            
            if (![[loginDefaults valueForKey:@"login"] isEqualToString:@"1"])
            {
            [[[[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] autorelease] show]; 
            }
            
            appDelegate.loginBool = 1;

            [_delegate fbLogedIn];
            
            [self dismissModalViewControllerAnimated:YES];
        }
        
    }
    
   // [[[[UIAlertView alloc] initWithTitle:@"error" message:returnString delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] autorelease] show];
    
    [returnString release];
    
}



-(NSString *) GetValueInXML:(NSString *)xmlString SearchStr:(NSString *)SearchStr
{
	NSString *str2;
	NSArray *arr=[xmlString componentsSeparatedByString:[NSString stringWithFormat:@"<%@>",SearchStr]];
	if ([arr count]>1)
	{
		NSString *str1=[arr objectAtIndex:1];
		NSArray *arr1=[str1 componentsSeparatedByString:[NSString stringWithFormat:@"</%@>",SearchStr]];
		if ([arr1 count]>0)
		{
			str2=[arr1 objectAtIndex:0];
			
		}
	}	
	return str2;
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
