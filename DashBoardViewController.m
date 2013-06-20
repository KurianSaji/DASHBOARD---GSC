//
//  DashBoardViewController.m
//  DashBoard
//
//  Created by neo on 11/04/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "DashBoardViewController.h"
#import "epubstore_svcAppDelegate.h"
#import "Videos.h"

@implementation DashBoardViewController

@synthesize tabbr,aTableView;
@synthesize web;
UIActivityIndicatorView *loadingIndicator;
UIButton *fbButton;
UIButton *btn_close;
BOOL _isDataSourceAvailable;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

-(void) fbLogin:(id) sender
{

	web.frame=CGRectMake(0, 0, 768, 1024);
	[web setBackgroundColor:[UIColor whiteColor]];
	[self.view bringSubviewToFront:web];
	
	//if(webhome == nil)
	webhome=[[UIButton alloc]initWithFrame:CGRectMake(5,3, 85, 45)];
	[webhome setBackgroundColor:[UIColor blackColor]]; 
	[webhome setTitle:@"Home" forState:UIControlStateNormal];
	[webhome setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[webhome addTarget:self action:@selector(homeEvent) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:webhome];
	[self.view bringSubviewToFront:webhome];
	[webhome release];
	
	if (btn_close==nil)
	{
		btn_close = [[UIButton alloc] initWithFrame:CGRectMake(730, 8, 27, 26)];
		btn_close.tag=100;
		[btn_close setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
		[btn_close addTarget:nil action:@selector(closeFBWindow:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:btn_close];
		[self.view bringSubviewToFront:btn_close];
	}
	else {
		btn_close.hidden=NO;
	}
	[self.view bringSubviewToFront:btn_close];
	
}

//-(void)viewWillAppear:(BOOL)animated
//{
	
	//NSString *shopAddress = @"http://www.adminmyapp.com/dashboard/api/read?action=getrssfeeds";
//	NSURL *shopurl =[NSURL URLWithString:shopAddress];
//	NSURLRequest *shoprequest = [NSURLRequest requestWithURL:shopurl];
//	[web loadRequest:shoprequest];
	
//}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{	
	appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (![self isDataSourceAvailable])
	{
				
	} 
	else {
		UIImage *fbframe = [UIImage imageNamed:@"facebook_text_input.png"];
		UIImageView *imgFrame = [[UIImageView alloc]initWithFrame:CGRectMake(50, 700, 698,268)];
		imgFrame.image =fbframe;
		[self.view addSubview:imgFrame];
		
		if (web==nil)
			web = [[UIWebView alloc]init];
		web.frame=CGRectMake(58, 708, 680,250);////58, 733, 680,222
		[web setBackgroundColor:[UIColor clearColor]];
		
		NSString *shopAddress = @"http://myzaah.com/maximdash/api/read?action=getrssfeeds";
		NSURL *shopurl =[NSURL URLWithString:shopAddress];
		NSURLRequest *shoprequest = [NSURLRequest requestWithURL:shopurl];
		[web loadRequest:shoprequest];
		
		
		//====web.view.hidden=NO;
		
		
		[self.view addSubview:web];
		[web release];
		
		
		UIImage *fbimg = [UIImage imageNamed:@"facebook_logo.png"];
		fbButton = [[UIButton alloc]initWithFrame:CGRectMake(65, 660, 54,68)];
		[fbButton setImage:fbimg forState:UIControlStateNormal];
		[fbButton addTarget:self action:@selector(fbLogin:) 
		   forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:fbButton];
		[fbButton release];
		
		webhome=[[UIButton alloc]initWithFrame:CGRectMake(655,705, 85, 35)];
		[webhome setBackgroundColor:[UIColor blackColor]]; 
		[webhome setTitle:@"Home" forState:UIControlStateNormal];
		[webhome setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		
		[webhome addTarget:self action:@selector(homeEvent) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:webhome];
		[self.view bringSubviewToFront:webhome];
		[webhome release];

	}
	 	
	if(tp == nil)
	{
		tp = [[UIImageView alloc]init];
	}
	[tp initWithFrame:CGRectMake(190, -140, 428, 433)];
	tp.image = [UIImage imageNamed:@"tp_logo.png"];
	[self.view addSubview:tp];
	[tp release];
	//[self showURL];
		
    [super viewDidLoad];
}

-(void)homeEvent
{
	NSString *shopAddress = @"http://myzaah.com/maximdash/api/read?action=getrssfeeds";
	NSURL *shopurl =[NSURL URLWithString:shopAddress];
	NSURLRequest *shoprequest = [NSURLRequest requestWithURL:shopurl];
	[web loadRequest:shoprequest];
	
}


-(void)showURL
{
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
	NSString *shopAddress = @"http://myzaah.com/maximdash/api/read?action=getrssfeeds";
	NSURL *shopurl =[NSURL URLWithString:shopAddress];
	NSURLRequest *shoprequest = [NSURLRequest requestWithURL:shopurl];
	[web loadRequest:shoprequest];
}

- (BOOL)isDataSourceAvailable
{
	static BOOL checkNetwork = YES;
	
	if (checkNetwork) 
	{ 
		checkNetwork = NO;
		
		Boolean success;    
		const char *host_name = "www.google.com";
		
		SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
		SCNetworkReachabilityFlags flags;
		success = SCNetworkReachabilityGetFlags(reachability, &flags);
		_isDataSourceAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
		CFRelease(reachability);
	}
	return _isDataSourceAvailable;
}

-(void) closeFBWindow:(id) sender
{
	
	web.frame=CGRectMake(58, 708, 680,250);
	[self.view addSubview:web];
	//UIButton *btn=(UIButton*)sender;
	//btn.hidden=YES;
	btn_close.hidden=YES;
	[self.view addSubview:fbButton];
	webhome.frame=CGRectMake(655,705, 85, 45);
	[self.view addSubview:webhome];
	[self.view bringSubviewToFront:webhome];
	
}


-(IBAction)comicbtn
{
	appDelegate.tabBarController.selectedIndex = 1;
	[appDelegate.videoview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
	[appDelegate startComic];
}
-(IBAction)clockbtn
{
	[appDelegate.videoVC.view setHidden:FALSE];
	appDelegate.tabBarController.selectedIndex = 2;
	[appDelegate.videoview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
}
-(IBAction)videobtn
{
	appDelegate.tabBarController.selectedIndex = 3;
	//appDelegate.videoview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 150, 768, 467)];
//	[appDelegate.videoVC :appDelegate.videoview];
	[appDelegate.videoview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
	[appDelegate.videoVC performSelector:@selector(firstVideo)];
}
-(IBAction)backgroundbtn
{
	appDelegate.tabBarController.selectedIndex = 4;
	[appDelegate.videoview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
}
-(IBAction)shopbtn
{
	[appDelegate.videoVC.view setHidden:FALSE];
	appDelegate.tabBarController.selectedIndex = 5;
	[appDelegate.videoview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
	[appDelegate startShop];
}
-(IBAction)jukeboxbtn
{
	//epubstore_svcAppDelegate *appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
//	appDelegate.tabBarController.selectedIndex = 6;
}
-(IBAction)socialbtn
{
	appDelegate.tabBarController.selectedIndex = 6;
	[appDelegate.videoview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
}

-(void)viewWillDisappear:(BOOL)animated
{
	[web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
	
	NSString *shopAddress = @"http://myzaah.com/maximdash/api/read?action=getrssfeeds";
	NSURL *shopurl =[NSURL URLWithString:shopAddress];
	NSURLRequest *shoprequest = [NSURLRequest requestWithURL:shopurl];
	[web loadRequest:shoprequest];
}

-(void)buttonPressed
{
	DashBoardViewController *dc = [[DashBoardViewController alloc]init];
	[self presentModalViewController:dc animated:YES];
	[dc release];
	
}

-(void) receivedRotate: (NSNotification*) notification
{
	UIDeviceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
	
	if(interfaceOrientation != UIDeviceOrientationUnknown)
		//[self deviceInterfaceOrientationChanged:interfaceOrientation];
		[self didRotateFromInterfaceOrientation:interfaceOrientation];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
//	UIAlertView *alert = [[UIAlertView alloc] 
//						  initWithTitle:@"Warning" 
//						  message:@"You are running out of memory" 
//						  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//	[alert show];
//	[alert release];
	
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
