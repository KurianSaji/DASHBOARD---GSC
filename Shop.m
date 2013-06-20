    //
//  Shop.m
//  DashBoard
//
//  Created by Zaah Technologies on 15/04/11.
//  Copyright 2011 Zaah. All rights reserved.
//

#import "Shop.h"
#import "epubstore_svcAppDelegate.h"

@implementation Shop

BOOL _isDataSourceAvailable;

//@synthesize shopview;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
//        // Custom initialization
//    }
//    return self;
//}

//- (void)awakeFromNib
//{


- (void)viewWillAppear:(BOOL)animated
{
	//NSString *shopAddress = @"http://shop.elitegudz.com/dashboard";
	//NSString *shopAddress = @"http://www.terminalpress.com/index.php/comics/zombies.html";
	if (![appDelegate isDataSourceAvailable])
	{
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:@"Network Connection Error" 
							  message:@"You need to be connected to the internet to use this feature." 
							  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		alert.delegate=self;
		[alert show];
		[alert release];
	}
	NSString *shopAddress = @"http://maximgear.gostorego.com/";
	NSURL *shopurl =[NSURL URLWithString:shopAddress];
	//[appDelegate.shopview setDelegate:self];
	NSURLRequest *shoprequest = [NSURLRequest requestWithURL:shopurl];
	[appDelegate.shopview loadRequest:shoprequest];
	
//	if(appDelegate.screenHeight1 == 1024)
//		loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(768/2, 1024/2, 20,20)];
//	else
//		loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 180, 20,20)];
//	[loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
//	[loadingIndicator setHidesWhenStopped:YES];
	
//	if (![self isDataSourceAvailable])
//	{
//		
//	} 
//	else {
//		[appDelegate.shopview addSubview:loadingIndicator];
//		
//	}
	appDelegate.shopview.hidden=NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [appDelegate.shopview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
	appDelegate.shopview.hidden=YES;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSLog(@"shop view did load");
	
	appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
	//[appDelegate.videoVC.view removeFromSuperview];
	if(appDelegate.screenHeight1 == 1024)
		appDelegate.shopview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
	else
		appDelegate.shopview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320,480)];
	[appDelegate.shopview setScalesPageToFit:YES];
	appDelegate.shopview.opaque = NO;
	appDelegate.shopview.hidden=NO;
	[self.view addSubview:appDelegate.shopview];
	
	//NSString *shopAddress = @"http://shop.elitegudz.com/dashboard";
	//NSString *shopAddress = @"http://www.maximgirls.com";
	NSString *shopAddress = @"http://maximgear.gostorego.com/";
	NSURL *shopurl =[NSURL URLWithString:shopAddress];
	[appDelegate.shopview setDelegate:self];
	NSURLRequest *shoprequest = [NSURLRequest requestWithURL:shopurl];
	[appDelegate.shopview loadRequest:shoprequest];
		
	if(appDelegate.screenHeight1 == 1024)	
		loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(768/2, 1024/2, 20,20)];
	else
		loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(320/2, 480/2, 20,20)];
	[loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
	[loadingIndicator setHidesWhenStopped:YES];
	
	if (![self isDataSourceAvailable])
	{
		
	} 
	else {
		[appDelegate.shopview addSubview:loadingIndicator];
				
	}
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


-(void)webViewDidStartLoad:(UIWebView *)webView 
{
	[loadingIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView 
{
	[loadingIndicator stopAnimating];
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return ((interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) || (interfaceOrientation == UIInterfaceOrientationPortrait));
	//return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) ;

}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
	
//	UIAlertView *alert = [[UIAlertView alloc] 
//						  initWithTitle:@"Warning" 
//						  message:@"You are running out of memory" 
//						  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//	[alert show];
//	[alert release];
	
	
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	//[appDelegate.shopview release];
	//[loadingIndicator release];
    [super dealloc];
}


@end
