//
//  userSettings.m
//  maximSocialVideo
//
//  Created by neo on 03/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "userSettings.h"

@implementation userSettings

epubstore_svcAppDelegate *appDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)fetchUserSettings
{

    NSString *urlString =[NSString stringWithFormat:@"%@media/list",ServerIp];
    
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
    [request setURL:[NSURL URLWithString:urlString]];
    
    NSLog(@"urlString----%@",urlString);
	
    NSString *myParameters = [NSString stringWithFormat:@"method=user.profile&user_id=%@",appDelegate.userID];
    
    NSLog(@"myParameters -- %@",myParameters);
    
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    // now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"fetchVideoDetails ---- %@",returnString);
    
    
    NSLog(@"return string = %@",returnString);
    
    if (returnString) 
    {
        
        
      
       userFname    = [self GetValueInXML:returnString SearchStr:@"fname"];
      
       userLname    = [self GetValueInXML:returnString SearchStr:@"lname"]; 
        
      
       userName     = [self GetValueInXML:returnString SearchStr:@"uname"];
        
       email        = [self GetValueInXML:returnString SearchStr:@"email"];
        
         
        
    }
    
    // [[[[UIAlertView alloc] initWithTitle:@"error" message:returnString delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] autorelease] show];
    
    [returnString release];


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

 
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    loginDefaults = [NSUserDefaults standardUserDefaults];
    
    vl_MainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height+20)];
    vl_MainView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:vl_MainView];
    
    backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height+20)];
    
    backgroundImageView.image = [UIImage imageNamed:@"bg_1_blue.png"];
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];

    
    [self fetchUserSettings];
    
    [self setTabbuttons];
    
    [self buildInfo];
    
    [self buildBottomTab];
    
    
}


-(void)backtoHome
{

    [self dismissModalViewControllerAnimated:YES];

}


-(void)buildInfo
{

    
    
    UILabel *tempLabel;
    
    tempLabel= [[UILabel alloc]initWithFrame:CGRectMake((18.0/320)*curSW, (60.0/320)*curSW,(81.0/320)*curSW, (18.0/480)*curSH )];
    tempLabel.text = @"Personal";
    [tempLabel setFont:[UIFont fontWithName:@"BigNoodleTitling" size:22]];
    [tempLabel setTextColor:[UIColor whiteColor]];
    [tempLabel setTextAlignment:UITextAlignmentLeft];
    tempLabel.backgroundColor = [UIColor clearColor];
    [vl_MainView addSubview:tempLabel];
    [tempLabel release];

    
    
    
    vl_InfoView = [[UIView alloc] initWithFrame:CGRectMake((18.0/320)*curSW , (83.0/480)*curSH, (281.0/320)*curSW , (142.0/480)*curSH  )];
    vl_InfoView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    [vl_MainView addSubview:vl_InfoView];
    
    
    //vl_InfoView.layer.borderColor = [UIColor redColor].CGColor;
    //vl_InfoView.layer.borderWidth = 1;
    
    
    
    vl_FNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (281.0/320)*curSW , (33.0/480)*curSH  )];
    vl_FNameView.backgroundColor = [UIColor whiteColor];
    [vl_InfoView addSubview:vl_FNameView];
    
     
    
    tempLabel= [[UILabel alloc]initWithFrame:CGRectMake((11.0/320)*curSW, 0, (82.0/320)*curSW , (33.0/480)*curSH )];
    tempLabel.text = @"First Name";
    [tempLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [tempLabel setTextColor:[UIColor blackColor]];
    [tempLabel setTextAlignment:UITextAlignmentLeft];
     tempLabel.backgroundColor = [UIColor clearColor];
    [vl_FNameView addSubview:tempLabel];
    [tempLabel release];
    
    
    
    
    
    tempLabel= [[UILabel alloc]initWithFrame:CGRectMake((93.0/320)*curSW, 0, (199.0/320)*curSW , (33.0/480)*curSH )];
    tempLabel.text = userFname;
    [tempLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [tempLabel setTextColor:[UIColor colorWithRed:161.0/255.0 green:161.0/255.0 blue:161.0/255.0 alpha:1]];
    [tempLabel setTextAlignment:UITextAlignmentLeft];
    tempLabel.backgroundColor = [UIColor clearColor];
    [vl_FNameView addSubview:tempLabel];
    [tempLabel release];
    [vl_FNameView release];
    
    
    
    
    
    
    vl_LNameView = [[UIView alloc] initWithFrame:CGRectMake(0, (36.0/480)*curSH, (281.0/320)*curSW , (33.0/480)*curSH  )];
    vl_LNameView.backgroundColor = [UIColor whiteColor];
    [vl_InfoView addSubview:vl_LNameView];
    tempLabel= [[UILabel alloc]initWithFrame:CGRectMake((11.0/320)*curSW, 0, (82.0/320)*curSW , (33.0/480)*curSH )];
    tempLabel.text = @"Last Name";
    [tempLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [tempLabel setTextColor:[UIColor blackColor]];
    [tempLabel setTextAlignment:UITextAlignmentLeft];
    tempLabel.backgroundColor = [UIColor clearColor];
    [vl_LNameView addSubview:tempLabel];
    [tempLabel release];
    
    
    
    
    
    tempLabel= [[UILabel alloc]initWithFrame:CGRectMake((93.0/320)*curSW, 0, (199.0/320)*curSW , (33.0/480)*curSH )];
    tempLabel.text = userLname;
    [tempLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [tempLabel setTextColor:[UIColor colorWithRed:161.0/255.0 green:161.0/255.0 blue:161.0/255.0 alpha:1]];
    [tempLabel setTextAlignment:UITextAlignmentLeft];
    tempLabel.backgroundColor = [UIColor clearColor];
    [vl_LNameView addSubview:tempLabel];
    [tempLabel release];
    [vl_LNameView release];
    
    
    
    
    vl_UNameView = [[UIView alloc] initWithFrame:CGRectMake(0, (72.0/480)*curSH, (281.0/320)*curSW , (33.0/480)*curSH  )];
    vl_UNameView.backgroundColor = [UIColor whiteColor];
    [vl_InfoView addSubview:vl_UNameView];
    
    tempLabel= [[UILabel alloc]initWithFrame:CGRectMake((11.0/320)*curSW, 0, (82.0/320)*curSW , (33.0/480)*curSH )];
    tempLabel.text = @"User Name";
    [tempLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [tempLabel setTextColor:[UIColor blackColor]];
    [tempLabel setTextAlignment:UITextAlignmentLeft];
    tempLabel.backgroundColor = [UIColor clearColor];
    [vl_UNameView addSubview:tempLabel];
    [tempLabel release];
    
    
    
    
    
    tempLabel= [[UILabel alloc]initWithFrame:CGRectMake((93.0/320)*curSW, 0, (199.0/320)*curSW , (33.0/480)*curSH )];
    NSLog(@"user name = %@",userName);
    if (![userName isEqualToString:@"(null)"])
    {
        tempLabel.text = userName;

    }
    else
    {
        tempLabel.text = @"";
    }
    
    [tempLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [tempLabel setTextColor:[UIColor colorWithRed:161.0/255.0 green:161.0/255.0 blue:161.0/255.0 alpha:1]];
    [tempLabel setTextAlignment:UITextAlignmentLeft];
    tempLabel.backgroundColor = [UIColor clearColor];
    [vl_UNameView addSubview:tempLabel];
    [tempLabel release];
    [vl_UNameView release];
    
    
    vl_EmailView = [[UIView alloc] initWithFrame:CGRectMake(0, (108.0/480)*curSH, (281.0/320)*curSW , (33.0/480)*curSH  )];
    vl_EmailView.backgroundColor = [UIColor whiteColor];
    [vl_InfoView addSubview:vl_EmailView];
    
    
    tempLabel= [[UILabel alloc]initWithFrame:CGRectMake((11.0/320)*curSW, 0, (82.0/320)*curSW , (33.0/480)*curSH )];
    tempLabel.text = @"Email";
    [tempLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [tempLabel setTextColor:[UIColor blackColor]];
    [tempLabel setTextAlignment:UITextAlignmentLeft];
    tempLabel.backgroundColor = [UIColor clearColor];
    [vl_EmailView addSubview:tempLabel];
    [tempLabel release];
    
    
    
    
    
    tempLabel= [[UILabel alloc]initWithFrame:CGRectMake((93.0/320)*curSW, 0, (199.0/320)*curSW , (33.0/480)*curSH )];
    tempLabel.text = email;
    [tempLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [tempLabel setTextColor:[UIColor colorWithRed:161.0/255.0 green:161.0/255.0 blue:161.0/255.0 alpha:1]];
    [tempLabel setTextAlignment:UITextAlignmentLeft];
    tempLabel.backgroundColor = [UIColor clearColor];
    [vl_EmailView addSubview:tempLabel];
    [tempLabel release];    
    
    
    [vl_EmailView release];
    
    
    
    



}


-(void)setTabbuttons
{
    
    curSW = [[UIScreen mainScreen] bounds].size.width;
    curSH = [[UIScreen mainScreen] bounds].size.height;
    
    photoButton *button1;
    
    int tabFontFize, tabheight;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        tabFontFize = 10;
        tabheight = 32;
        /*tabButtonW = 70;
         tabButtonH = 24; */
        
        // button1=[[UIButton alloc]initWithFrame:CGRectMake(15, 0, 26, 32)];
        // button2=[[UIButton alloc]initWithFrame:CGRectMake(280, 0, 26, 32)];
    }
    else
    {
        
        tabFontFize = 25;
        tabheight = 52;
        /*tabButtonW = 161;
         tabButtonH = 52; */
        // button1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 56, 54)];
        // button2=[[UIButton alloc]initWithFrame:CGRectMake(700, 0, 56, 54)];
        
    }    
    
    
    
    button1=[[photoButton alloc]initWithFrame:CGRectMake(10, 25, (20.0/320)*curSW , (20.0/480)*curSH )];
    
    
    
    
    vl_TabsView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, self.view.frame.size.width ,(34.0/480)*curSH )];
    
    vl_TabsView.backgroundColor = [UIColor clearColor];
    [vl_MainView addSubview:vl_TabsView];
    [vl_UserView release];
    
    
    
    [button1 addTarget:self action:@selector(backtoHome) forControlEvents:UIControlEventTouchUpInside]; 
    
    //[button1 setImage:[UIImage imageNamed:@"videoDetailsback.png"] forState:UIControlStateNormal];
    
    [button1 setBackgroundImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:button1];
    [button1 release];
    
    
     
    
    
}


-(void)buildBottomTab
{
    
    curSW = [[UIScreen mainScreen] bounds].size.width;
    curSH = [[UIScreen mainScreen] bounds].size.height;
    
    
    int  tabFontFize, tabheight, tabButtonW, tabButtonH;
    
    UIImage *tempImage, *tempImage2, *tempImage3;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        tabFontFize = 16;
        tabheight = 50;
        tabButtonW = 70;
        tabButtonH = 24; 
        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"green_line_iphone" ofType:@"png"]];
        tempImage2 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"like_iphone" ofType:@"png"]];
        tempImage3 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"like_hand" ofType:@"png"]];
    }
    else
    {
        
        tabFontFize =35;
        tabheight = 82;//62
        tabButtonW = 161;
        tabButtonH = 52; 
        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"green_line_ipad" ofType:@"png"]];
        tempImage2 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"like_ipad" ofType:@"png"]];
        
        tempImage3 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"like_hand" ofType:@"png"]];
    }    
    
    vl_BottomTabView = [[UIView alloc] initWithFrame:CGRectMake(0,(430.0/480)*curSH ,self.view.frame.size.width,  (50.0/480)*curSH)];
    vl_BottomTabView.backgroundColor = [UIColor blackColor];
    [vl_MainView addSubview:vl_BottomTabView];
    
    
    UIButton *btnLogout  = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnLogout.frame = CGRectMake((11.0/320)*curSW,0,(86.0/320)*curSW,(50.0/480)*curSH);
    
    btnLogout.backgroundColor = [UIColor clearColor];
    
    [btnLogout addTarget:self action:@selector(logoutFB) forControlEvents:UIControlEventTouchUpInside];
    [btnLogout setTitle:@"LOGOUT" forState:UIControlStateNormal];
    //[btnShare setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    //(btnLogout).titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:15];
    
    btnLogout.titleLabel.font = [UIFont fontWithName:@"BigNoodleTitling" size:23];

    
    //[btnLogout setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
    
    [btnLogout setTitleColor:[UIColor colorWithRed:250/255.0 green:204/255.0 blue:0/255.0 alpha:1] forState:UIControlStateNormal];
    
    //[btnLogout  setCusLable:@"" initWithFrame:CGRectMake(0, 0, (86.0/320)*curSW, (5.0/480)*curSH) bgColor:[UIColor colorWithRed:0/255.0 green:255.0/255.0 blue:139.0/255.0 alpha:1]];
    
    [vl_BottomTabView addSubview:btnLogout];
    
    
    
    UIButton *btnAbout  = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnAbout.frame = CGRectMake((225.0/320)*curSW,0,(86.0/320)*curSW,(50.0/480)*curSH);
    
    btnAbout.backgroundColor = [UIColor clearColor];
    
    [btnAbout addTarget:self action:@selector(aboutApp) forControlEvents:UIControlEventTouchUpInside];
    [btnAbout setTitle:@"ABOUT" forState:UIControlStateNormal];
    //[btnShare setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    //(btnAbout).titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:15];
    btnAbout.titleLabel.font = [UIFont fontWithName:@"BigNoodleTitling" size:23];

    
    //[btnAbout setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
    
    [btnAbout setTitleColor:[UIColor colorWithRed:250/255.0 green:204/255.0 blue:0/255.0 alpha:1] forState:UIControlStateNormal];
    
    
    //[btnAbout  setCusLable:@"" initWithFrame:CGRectMake(0, 0, (86.0/320)*curSW, (5.0/480)*curSH) bgColor:[UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:116.0/255.0 alpha:1]];
    
    [vl_BottomTabView addSubview:btnAbout];
    
    
    
    
    
    [vl_BottomTabView release];
}

-(void)logoutFB
{

    
    
    
    
    UIAlertView *alertLogout = [[UIAlertView alloc] init];
	[alertLogout setTitle:@"Confirm"];
	[alertLogout setMessage:@"Are you sure want to logout?"];
	[alertLogout setDelegate:self];
	[alertLogout addButtonWithTitle:@"Yes"];
	[alertLogout addButtonWithTitle:@"No"];
	[alertLogout show];
	[alertLogout release];
    
     
    
   


}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
        if([login initFb])
        {
           
             [[login initFb] logout:self];
            
        }
        
        appDelegate.userID = nil;
        
        appDelegate.redirectToRoot = TRUE;
        
        appDelegate.loginBool = 0;
        
        [loginDefaults setObject:@"0" forKey:@"login"];
        
        [loginDefaults synchronize];
        
        [self dismissModalViewControllerAnimated:YES];
        
        //[login nilFb] ;
         
        
	}
	else if (buttonIndex == 1)
	{
		// No
	}
}



-(void)aboutApp
{

    if (vl_AboutView) {
        
        vl_AboutView.hidden = NO;
        return;
        
    }
    
    
    vl_AboutView = [[UIView alloc] initWithFrame:CGRectMake(0,0 ,self.view.frame.size.width,self.view.frame.size.height)];
    vl_AboutView.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.2];
    [vl_MainView addSubview:vl_AboutView];
    [vl_AboutView bringSubviewToFront:vl_MainView];
    
    
    
    UIView *vl_AboutinnerView = [[UIView alloc] initWithFrame:CGRectMake((58.0/320)*curSW , (162.0/480)*curSH ,(220.0/320)*curSW , (123.0/480)*curSH)];
    vl_AboutinnerView.backgroundColor = [UIColor whiteColor];
    [vl_AboutView addSubview:vl_AboutinnerView];
    
    
    UILabel *tempLabel;
    
    tempLabel= [[UILabel alloc]initWithFrame:CGRectMake((25.0/320)*curSW, (12.0/480)*curSH, (170.0/320)*curSW , (18.0/480)*curSH )];
    tempLabel.text = @"Mobile Social Solution";
    [tempLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [tempLabel setTextColor:[UIColor colorWithRed:226.0/255.0 green:0/255.0 blue:99.0/255.0 alpha:1]];
    [tempLabel setTextAlignment:UITextAlignmentCenter];
    tempLabel.backgroundColor = [UIColor clearColor];
    [vl_AboutinnerView addSubview:tempLabel];
    [tempLabel release];
    
    
    tempLabel= [[UILabel alloc]initWithFrame:CGRectMake((25.0/320)*curSW, (30.0/480)*curSH, (170.0/320)*curSW , (18.0/480)*curSH )];
    tempLabel.text = @"Version 1.0";
    [tempLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [tempLabel setTextColor:[UIColor colorWithRed:162.0/255.0 green:162.0/255.0 blue:162.0/255.0 alpha:1]];
    [tempLabel setTextAlignment:UITextAlignmentCenter];
    tempLabel.backgroundColor = [UIColor clearColor];
    [vl_AboutinnerView addSubview:tempLabel];
    [tempLabel release];

    
    
    
    
    UIButton *btnAboutOK  = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnAboutOK.frame = CGRectMake((65.0/320)*curSW,(62.0/480)*curSH,(86.0/320)*curSW,(40.0/480)*curSH);
    [btnAboutOK addTarget:self action:@selector(exitAboutInfo) forControlEvents:UIControlEventTouchUpInside];
    [btnAboutOK setTitle:@"OK" forState:UIControlStateNormal];
    (btnAboutOK).titleLabel.font =  [UIFont fontWithName:@"HelveticaNeueBold" size:20];
    
    btnAboutOK.backgroundColor = [UIColor blackColor]; 
    
    
    
    [btnAboutOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [vl_AboutinnerView addSubview:btnAboutOK];
    
    [vl_AboutinnerView release];
    [vl_AboutView release];
    

}

-(void)exitAboutInfo
{
    vl_AboutView.hidden = YES;   

}





-(NSString *) GetValueInXML:(NSString *)xmlString SearchStr:(NSString *)SearchStr
{
    NSString *str2;
    NSArray *arr=[xmlString componentsSeparatedByString:[NSString stringWithFormat:@"<%@>",SearchStr]];
    if ([arr count]>0)
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
