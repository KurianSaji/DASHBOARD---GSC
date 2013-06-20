//
//  HDBackgroundDemoOneViewController.m
//  HDBackgroundDemoOne
//
//  Created by partha neo on 11/15/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "HDBackgroundDemoOneViewController.h"
#import <StoreKit/StoreKit.h>
#import "epubstore_svcAppDelegate.h"

#import "HDLoopDemoViewController.h"
//#import "AdWhirlView.h"
#import "SplashViewController.h"
#import "SA_OAuthTwitterEngine.h"
#define kOAuthConsumerKey				@"gKKNHPCJR4ogFjWT9vjgg"		//REPLACE ME  Twitter
#define kOAuthConsumerSecret			@"1FOKxqZI4FCT1zjKMA6vdE16jZD5STGVB5wGzxrpKc"
#import "AsynView.h"
#import "myClass.h"
@implementation HDBackgroundDemoOneViewController

epubstore_svcAppDelegate *appDelegate;
static NSString* kAppId = @"180294668651052";

UITextView *twitterTextField ;
UIView * twitterView;
BOOL TwitterOpened= NO;

NSString *firstThumbImg;
NSString *secThumbImg;
NSString *thirdThumbImg;
NSString *fourthThumbImg;
NSString *fifthThumbImg;
NSString *fifthThumbImg;
NSString *sixthThumbImg;
NSString *sevenththumbImg;

NSString *imageName1;
NSData *receivedData;
NSString *path1;
UIImageView *imgView;
UILabel *label;
NSMutableArray *catArray;
NSMutableArray *arrUrlData;
int iCatCount;
UINavigationBar* theBar;



int screenWidth1 = 320;
int screenHeight1 = 480;





/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/
int count11;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
-(void)viewWillDisappear:(BOOL)animated
{
 ////   self.title=nil;
}
- (void)viewWillAppear:(BOOL)animated 
{
	
	
	topLabel.hidden=NO;
	
	if (aTableView ==nil) 
	{
        if (screenWidth1==320) 
        {
            aTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, (80.0/480)*screenHeight1, screenWidth1, screenHeight1-((123.0/480)*screenHeight1))];
        }
        else
        {
            aTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, (80.0/480)*screenHeight1, screenWidth1, screenHeight1-((60.0/480)*screenHeight1))];
        }////		[aTableView setContentInset:UIEdgeInsetsMake(50,0,0,0)];
		[aTableView setBackgroundColor:[UIColor blackColor]];
		
		//aTableView.separatorColor = [UIColor clearColor];
		aTableView.separatorColor=[UIColor whiteColor];
        aTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
		[aTableView setDelegate:self];
		[aTableView setDataSource:self];
		[self.view addSubview:aTableView];
		[self.view sendSubviewToBack:aTableView];
	}
	
	self.navigationItem.leftBarButtonItem=nil;
 ////   [self.navigationController.navigationBar setHidden:NO];
	if(count11>=1){

	}
	
}
-(void)removeSplash
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
	[splashScreen removeFromSuperview];
	[self.navigationController.navigationBar setHidden:FALSE];
	[pool release];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//NSLog(@"in DemoViewDidLoad..");
	
	screenWidth1 = [[UIScreen mainScreen] bounds].size.width;
	screenHeight1 = [[UIScreen mainScreen] bounds].size.height;
    if (screenWidth1==320) 
    {
        UIImage *topImage=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"wallpaperImg" ofType:@"png"]];
        UIImageView *topCoverImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, topImage.size.width/2, topImage.size.height/2)];
        [topCoverImage setImage:topImage];
        [self.view addSubview:topCoverImage];
        [topCoverImage release];
        [topImage release];
    }
    else
    {
        UIImage *topImage=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"wallpaperImg" ofType:@"png"]];
        UIImageView *topCoverImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, topImage.size.width, topImage.size.height)];
        [topCoverImage setImage:topImage];
        [self.view addSubview:topCoverImage];
        [topCoverImage release];
        [topImage release];
    }
    
	
	
	if(screenHeight1 == 1024)
	{
		//appDelegate.strURL = 
	}

	appDelegate =(epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[self.navigationController.navigationBar setHidden:TRUE];
	
	
	
	
	appDelegate.thumbView = TRUE;
	
	
	
    if (screenWidth1==320) 
    {
        aTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, (80.0/480)*screenHeight1, screenWidth1, screenHeight1-((123.0/480)*screenHeight1))];
        
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_wallpaperIphone"]]];
    }
    else
    {
        aTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, (80.0/480)*screenHeight1, screenWidth1, screenHeight1-((60.0/480)*screenHeight1))];
        
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_wallpaperIpad"]]];
        
    }////	[aTableView setContentInset:UIEdgeInsetsMake(50,0,0,0)];
	[aTableView setBackgroundColor:[UIColor blackColor]];
	[aTableView setShowsVerticalScrollIndicator:NO];
	//aTableView.separatorColor = [UIColor clearColor];
	[aTableView setDelegate:self];
	[aTableView setDataSource:self];
	[self.view addSubview:aTableView];
    aTableView.separatorColor=[UIColor whiteColor];
    aTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
	
// navigationBar
/*	
	theBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 768, 48.0f)];
	[theBar pushNavigationItem:[[UINavigationItem alloc] initWithTitle:@""]];
	theBar.barStyle=UIBarStyleBlackTranslucent;

	[self.view addSubview: theBar];
*/	
	
	// = [[UILabel alloc] initWithFrame:CGRectMake(40, 2, 180, 40)];
	/*if (appDelegate.screenHeight1==1024) {
		topLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 350, 60)];
	///	[topLabel setFont:[UIFont boldSystemFontOfSize:43.0]];
        [topLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:42.0]];
        [topLabel setColorAtRect:CGRectMake((5.0/320)*screenWidth1, (24.0/480)*screenHeight1, (104.0/320)*screenWidth1, (3.0/480)*screenHeight1) color:[UIColor greenColor]];
	}
	else {
		topLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.5, 0, 150, 27)];
	///	[topLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
        [topLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18.0]];
        [topLabel setColorAtRect:CGRectMake((5.0/320)*screenWidth1, (24.0/480)*screenHeight1, (108.0/320)*screenWidth1, (3.0/480)*screenHeight1) color:[UIColor greenColor]];
	}
	
	[topLabel setTextAlignment:UITextAlignmentLeft];
	[topLabel setBackgroundColor:[UIColor clearColor]];
    topLabel.baselineAdjustment=UIBaselineAdjustmentAlignCenters;
////    topLabel.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    
	[topLabel setTextColor:[UIColor blackColor]];
	[topLabel setText:@"CATEGORIES"];
	
	
	//[label release];

	
	UIView *adBg=[[UIView alloc]init] ;//]WithImage:temp11];
	
	[adBg setFrame:CGRectMake(0,(53.0/480)*screenHeight1,768,(27.0/480)*screenHeight1)];
    [adBg setBackgroundColor:[UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1]];
	//[self.view addSubview:adBg];*/
   // [adBg addSubview:topLabel];
	
	//UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    //[btn setTitle:@"i" forState:UIControlStateNormal];
   // [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   // btn.titleLabel.font=[UIFont fontWithName:@"HoeflerText-BlackItalic" size:32];
//    if (appDelegate.screenWidth1==320) 
//    {
//        btn.titleLabel.font=[UIFont fontWithName:@"HoeflerText-BlackItalic" size:17];
//    }
    
    ////	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"Information.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionSheetAction) forControlEvents:UIControlEventTouchUpInside];
	
    btn.frame=CGRectMake(screenWidth1-((35.0/768)*screenWidth1), (10.0/1024)*screenHeight1, (30.0/768)*screenWidth1, (30.0/1024)*screenHeight1);
    [self.view addSubview:btn];
	iCatCount = [appDelegate.arrCatList count];
/*	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
																	style:UIBarButtonSystemItemDone target:nil action:nil];
	appDelegate.tabBarController.navigationItem.rightBarButtonItem = rightButton;
	[rightButton release];
    
  */  
	
}

-(void)loadDefaultFils{
		
	NSString *imageName;
	NSString *strCatDetails;
	NSArray *arrCatDetails;

	
	for(int i = 0;i<[appDelegate.arrCatList count];i++)
	{
		strCatDetails = [appDelegate.arrCatList objectAtIndex:i];
		
		arrCatDetails = [[NSArray alloc]init];

		arrCatDetails = [strCatDetails componentsSeparatedByString:appDelegate.strColDelimiter];

		
		imageName = [NSString stringWithFormat:@"%@_%@",[arrCatDetails objectAtIndex:appDelegate.iCatIDIndex],appDelegate.strThumbImgName];
		UIImage *imgPlaceHolder = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:imageName]];
		//[self imageSaveToDocumentPath:imgPlaceHolder :imageName];
		//[imgPlaceHolder release];
		int iLoopUpTo;

		iLoopUpTo = [[arrCatDetails objectAtIndex:appDelegate.iCatNoOfImgsIndex] intValue];
		for(int iNumberOfImages = 0;iNumberOfImages<iLoopUpTo;iNumberOfImages++)
		{
			imageName = [NSString stringWithFormat:@"%@_%@_%d.png",[arrCatDetails objectAtIndex:appDelegate.iCatIDIndex],appDelegate.str104by157Name,iNumberOfImages+1];
			imgPlaceHolder = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:imageName]];
			//[self imageSaveToDocumentPath:imgPlaceHolder :imageName];
			//[imgPlaceHolder release];
			
			imageName = [NSString stringWithFormat:@"%@_%@_%d.png",[arrCatDetails objectAtIndex:appDelegate.iCatIDIndex],appDelegate.str320by480Name,iNumberOfImages+1];
			imgPlaceHolder = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:imageName]];
			//[self imageSaveToDocumentPath:imgPlaceHolder :imageName];
			//[imgPlaceHolder release];
			
			imageName = [NSString stringWithFormat:@"%@_%@_%d.png",[arrCatDetails objectAtIndex:appDelegate.iCatIDIndex],appDelegate.str640by960Name,iNumberOfImages+1];
			imgPlaceHolder = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:imageName]];
			//[self imageSaveToDocumentPath:imgPlaceHolder :imageName];
			//[imgPlaceHolder release];
		
		}
		//[arrCatDetails release];
	}
}



-(void)actionSheetAction{
	
		
	/*UIActionSheet *aSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Tell a Friend",@"Tweet This",@"Facebook",@"Other Apps",nil];
	[aSheet showInView:self.view];
	[aSheet release];*/
    
    aSheet=[[UIActionSheet alloc]initWithTitle:nil 
                                      delegate:self 
                             cancelButtonTitle:@"Cancel" 
                        destructiveButtonTitle:nil 
                             otherButtonTitles:@"Tell a Friend",@"Tweet This",@"Facebook",@"Other Apps",@"",nil];
    
    [aSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    
    UIButton *notifc;
    if(appDelegate.screenWidth1 == 320)
        notifc  = [[UIButton alloc]initWithFrame:CGRectMake(45, 238, 140, 38)];
    else
    {
        notifc  = [[UIButton alloc]initWithFrame:CGRectMake(30, 200, 140, 38)];
    }
    
    [notifc setBackgroundColor:[UIColor clearColor]];
    [notifc setTitle:@"Notification" forState:UIControlStateNormal];
    [notifc setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [notifc setFont:[UIFont boldSystemFontOfSize:22]];
    [aSheet addSubview:notifc];
    
    if(appDelegate.screenWidth1 == 320)
        firstNotify = [[UISwitch alloc]initWithFrame:CGRectMake(182, 242, 137, 38)];
    else
    {
        firstNotify = [[UISwitch alloc]initWithFrame:CGRectMake(165, 205, 137, 38)];
    }
    
    [firstNotify addTarget:self action:@selector(SwitchOn:) forControlEvents:UIControlEventTouchUpInside];
    [firstNotify setTag:90];
    [firstNotify setOn:appDelegate.IsEnabledLinks];
    [aSheet addSubview:firstNotify];
    
    [aSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    
    if(appDelegate.screenWidth1 == 320)
        [aSheet setBounds:CGRectMake(0,0,320,380)];
    else    
    {
        [aSheet setFrame:CGRectMake(0,0,320,650)];
    }   

	
	
}

-(void)SwitchOn:(id)sender
{
	NSLog(@"switchOn...");
	UISwitch *Swt_HighightL = (UISwitch *)[aSheet viewWithTag:90];
	if(Swt_HighightL!=nil)
	{
		if(Swt_HighightL.tag == 90)
		{
			
			if(Swt_HighightL.on)
			{
                appDelegate.ISPushNotification = YES;
				appDelegate.IsEnabledLinks = YES;
				appDelegate.isSwitch=appDelegate.IsEnabledLinks;
				
				[appDelegate.prefs setBool:YES forKey:@"IsEnabledLinks"];
                [appDelegate.prefs setBool:YES forKey:@"ISPushNotification"];
				[appDelegate.prefs synchronize];
				
			}
			else 
			{
				appDelegate.ISPushNotification = NO;
				appDelegate.IsEnabledLinks = NO;
				appDelegate.isSwitch=appDelegate.IsEnabledLinks;
				
				[appDelegate.prefs setBool:NO forKey:@"IsEnabledLinks"];
                [appDelegate.prefs setBool:NO forKey:@"ISPushNotification"];
				[appDelegate.prefs synchronize];
			}
		}
	}
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	
	if(buttonIndex ==0)
	{
		[self emailact];
		
	}else if(buttonIndex ==1)
	{
		//Change For Twitter
		[self openTwitterPage];
		
		
	}
	else if(buttonIndex ==2)
	{
		[self facebtnact];
		
	}
	else if(buttonIndex ==3)
	{
		
		[[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"http://itunes.apple.com/us/artist/alpha-media-group-inc./id393395810"]];
	}
	
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([appDelegate.arrCatList count]==1) {
        if ([[[appDelegate.arrCatList objectAtIndex:0] componentsSeparatedByString:appDelegate.strColDelimiter] count]==1) {
            return 0;
        }
        else{
            return [appDelegate.arrCatList count];
        }
    }
    return [appDelegate.arrCatList count];
}


//// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	
	//static NSString *CellIdentifier = @"Cell";
	
		
	UITableViewCell *cell = nil;// = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];		
	}
//	[cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
	
	NSLog(@"%@",appDelegate.arrCatList);
	NSString *strCatDetails1 = [appDelegate.arrCatList objectAtIndex:indexPath.row];
	NSArray *arrCatDetails1 = [[NSArray alloc]init];
	arrCatDetails1 = [strCatDetails1 componentsSeparatedByString:appDelegate.strColDelimiter];
	

	NSString *imageName2;
	
	
	if(screenHeight1==1024)
	imageName2 = [NSString stringWithFormat:@"upload/cover/thumb/%@_Ipad_%@",[arrCatDetails1 objectAtIndex:appDelegate.iCatIDIndex],appDelegate.strThumbImgName];
	else {
		imageName2 = [NSString stringWithFormat:@"upload/cover/thumb/%@_Iphone_%@",[arrCatDetails1 objectAtIndex:appDelegate.iCatIDIndex],appDelegate.strThumbImgName];

	}

	CGRect frame;
	
	if(screenHeight1==1024)
	{
		//frame.size.width=65*screenWidth1/320; frame.size.height=130*screenHeight1/480;
		frame.size.width=90; frame.size.height=90;

		frame.origin.x=4*screenWidth1/320; frame.origin.y=2.5*screenHeight1/480;
	}
	else 
	{
		frame.size.width=65; frame.size.height=65;
		frame.origin.x=6*screenWidth1/320; frame.origin.y=7*screenHeight1/480;
	}

	
	NSString *mypath = [appDelegate.strURL stringByAppendingFormat:@"%@",imageName2];
    
	if([appDelegate checkFileExist:[imageName2 lastPathComponent]])
	{
		imgView = [[UIImageView alloc]initWithFrame:frame];
		UIImage *img = [appDelegate getImageFromDocFolder:[imageName2 lastPathComponent]];
		imgView.image = img;
		[cell.contentView addSubview:imgView];
        [imgView release];
        imgView=nil;
        
	}
	else
	{
		
		// get the image using nsurlconnection in asynview class
		AsynView* image;
		
		
				
		image = [[[AsynView alloc]initWithFrame:frame] autorelease];
	
	if(screenHeight1!=1024)
		image.backgroundColor=[UIColor clearColor];
		
		NSURL *myUrl = [NSURL URLWithString:mypath];
        NSLog(@"hit url %@",myUrl.absoluteString);
		[image loadImageFromURL:myUrl];
		[cell.contentView addSubview:image];
       

	}
	
	//image.frame=frame;
   
    UIImageView *cross=[[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width-120, 0, 2,100)];
    if(screenHeight1!=1024){
        cross.frame=CGRectMake(tableView.frame.size.width-100, 0, 2,80);
    }
    [cross setBackgroundColor:[UIColor whiteColor]];
    [cell.contentView addSubview:cross];
    [cross release];
	[cell setBackgroundColor:[UIColor redColor]];
	
	UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
	myBackView.backgroundColor = [UIColor grayColor];
	cell.selectedBackgroundView = myBackView;
	
	//cell.frame=frame;
	
	
	return cell;
	
}


		 
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell1 forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	//int k=indexPath.row;
	
	NSString *strCatDetails1;
	NSArray *arrCatDetails1;
	NSLog(@"%@",appDelegate.arrCatList);
	strCatDetails1 = [appDelegate.arrCatList objectAtIndex:indexPath.row];
	//arrCatDetails1 = [[NSArray alloc]init];
	arrCatDetails1 = [strCatDetails1 componentsSeparatedByString:appDelegate.strColDelimiter];
	
	//***newvalue
    
	int newValue = [[arrCatDetails1 objectAtIndex:appDelegate.iUpdateValue]intValue];

	
	if(screenHeight1==1024)
	{
		label = [[UILabel alloc]initWithFrame:CGRectMake(160,20,350,50)];
		[label setFont:[UIFont boldSystemFontOfSize:30]];
		//label.font = [UIFont fontWithName:@"Arial" size: 30.0];		
	}
	else 
	{
		//label.font = [UIFont fontWithName:@"Arial" size: 20.0];
		//[label setFont:[UIFont boldSystemFontOfSize:20]];
		label = [[UILabel alloc]initWithFrame:CGRectMake(83,20,142,21)];
		label.shadowColor = [UIColor colorWithWhite:1 alpha:1];
        [label setFont:[UIFont boldSystemFontOfSize:14]];
	}
	

	label.text = [arrCatDetails1 objectAtIndex:appDelegate.iCatNameIndex];
	[label setTextColor:[UIColor whiteColor]];
	
	if(screenHeight1!=1024)
		[label setBackgroundColor:[UIColor clearColor]];
	else {
		[label setBackgroundColor:[UIColor clearColor]];
	}
	
	[cell1.contentView addSubview:label];
	
	[label release];
	
	
	NSString *strPurchasedValue = [NSString stringWithFormat:@"%@",[arrCatDetails1 objectAtIndex:appDelegate.checkPurchasedValue]];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	//added
	
	
	
//	NSString *currentProductID=[[NSString stringWithFormat:@"wallpaperpackipadhd10%@",[ arrCatDetails1 objectAtIndex:appDelegate.iCatIDIndex]] substringFromIndex:15];
	
	
	NSString *currentProductID;
	if(screenHeight1==1024)
		currentProductID=[[NSString stringWithFormat:@"maxhotgirlswpipa%@",[ arrCatDetails1 objectAtIndex:appDelegate.iCatIDIndex]] substringFromIndex:15];
	else
		currentProductID=[[NSString stringWithFormat:@"maxhotgirlswpiph%@",[ arrCatDetails1 objectAtIndex:appDelegate.iCatIDIndex]] substringFromIndex:15];

	
	int purchseStatus=[defaults integerForKey:currentProductID];
	NSLog(@"product ids%@  %@ %d",currentProductID,strPurchasedValue,purchseStatus);
	//end added
	
	//commented int purchseStatus=[defaults integerForKey:[ NSString stringWithFormat:@"%@",[ arrCatDetails1 objectAtIndex:appDelegate.iCatIDIndex]]];
	
	BOOL dontDisplayNew;
	//if( [strPurchasedValue floatValue]!=0 && purchseStatus!=111)
	{
		
		UIImageView *purchaseImgView = [[UIImageView alloc]init ];//]WithFrame:CGRectMake(0, 0, screenWidth1, 100)];
					dontDisplayNew=FALSE;					 
		 if(screenHeight1==1024)
		 
		 {
			// purchaseImgView.frame = CGRectMake(0, 0, screenWidth1, 100);
			// [purchaseImgView setImage: [UIImage imageNamed:@"premium_overlay_768x100.png"]];
			 if(newValue==1)
			 {
				 dontDisplayNew=TRUE;
            //     UIImage *buyImage=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ipad_new_buynow" ofType:@"png"]];
                 UIImage *buyImage=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"premium_overlay_768x100" ofType:@"png"]];
				 purchaseImgView.frame = CGRectMake(screenWidth1-buyImage.size.width-2, 0, buyImage.size.width+8, 100);
				 [purchaseImgView setImage: buyImage];
                 [buyImage release];
			 }
			 else {
				 UIImage *buyImage=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"btnIpad_free" ofType:@"png"]];
				 purchaseImgView.frame = CGRectMake(screenWidth1-buyImage.size.width-2, 0, buyImage.size.width+8, 100);
				 [purchaseImgView setImage: buyImage];
                 [buyImage release];
				// [purchaseImgView setImage: [UIImage imageNamed:@"premium_overlay_768x100.png"]];
			 }	
		 }
		 
		 
		 else 
		 {
			// purchaseImgView.frame = CGRectMake(0, 0, screenWidth1, 80);
			 
			// [purchaseImgView setImage: [UIImage imageNamed:@"premium_overlay_320x79.png"]];
			 if(newValue==1)
			 {
				 dontDisplayNew=TRUE;
            //     UIImage *buyImage=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"iphone_new_buynow" ofType:@"png"]];
                 UIImage *buyImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"premium_overlay_320x79" ofType:@"png"]];
				 purchaseImgView.frame = CGRectMake(screenWidth1-buyImage.size.width-4, 0, buyImage.size.width+5, 80);
				 [purchaseImgView setImage: buyImage];
                 //[buyImage release];
			//	 purchaseImgView.frame = CGRectMake(0, 0, screenWidth1, 80);
			//	 [purchaseImgView setImage: [UIImage imageNamed:@"iphone_new_buynow.png"]];	
			 }
			 else {
                 UIImage *buyImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"btniphone_free" ofType:@"png"]];
				 purchaseImgView.frame = CGRectMake(screenWidth1-buyImage.size.width-4, 0, buyImage.size.width+5, 80);
				 [purchaseImgView setImage: buyImage];
               //  [buyImage release];
			//	 purchaseImgView.frame = CGRectMake(0, 0, screenWidth1, 80);
			//	 [purchaseImgView setImage: [UIImage imageNamed:@"premium_overlay_320x79.png"]];	
			 }
		 }
		 
		 [cell1 addSubview:purchaseImgView];
		 [purchaseImgView release];
	}
	
	UIImageView *backImgView = [[UIImageView alloc]init];
	if(screenHeight1==1024)
	{
		
		backImgView.frame = CGRectMake(0, 0, screenWidth1, 100);
		[backImgView setImage: [UIImage imageNamed:@"320_75_BG.png"]];
		//[cell1 setBackgroundColor: [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"320_75_BG.png"]]];
		
	}
	else 
	{
		backImgView.frame = CGRectMake(0, 0, screenWidth1, 79);
		[backImgView setImage: [UIImage imageNamed:@"320_75_BG2.png"]];
		//[cell1 setBackgroundColor: [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"320_75_BG2.png"]]];
		
	}
//	[cell1 addSubview:backImgView];
    [backImgView release];
	//***newvalue
	if(newValue==1 && dontDisplayNew==FALSE)
	{
		
		UIImageView *newImageView = [[UIImageView alloc]init ];
		if(screenHeight1==1024)
		{
			newImageView.frame = CGRectMake(0, 0, screenWidth1, 100);
			[newImageView setImage: [UIImage imageNamed:@"new_ioverlay_ipad.png"]];

			
		}
		else 
		{
			newImageView.frame = CGRectMake(0, 0, screenWidth1, 79);

			//[cell1 setBackgroundColor: [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"new_ioverlay_iphone.png"]]];
			[newImageView setImage: [UIImage imageNamed:@"new_ioverlay_iphone.png"]];

			
		}
		
		[cell1 addSubview:newImageView];
		[newImageView release];
	}
	
	
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if(screenHeight1==1024)return 100;
	
	return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
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
	else
	{
		appDelegate.thumbView = FALSE;
	int k=indexPath.row;
	
	NSString *strCatDetails1;
	NSArray *arrCatDetails1;
////		topLabel.hidden=YES;
	strCatDetails1 = [appDelegate.arrCatList objectAtIndex:indexPath.row];
	arrCatDetails1 = [[NSArray alloc]init];
	arrCatDetails1 = [strCatDetails1 componentsSeparatedByString:appDelegate.strColDelimiter];
	
	
		[theBar setHidden:YES];
		HDLoopDemoViewController *aHDLoop =[[HDLoopDemoViewController alloc]initWithNibName:@"HDLoopDemoViewController" bundle:nil];
		//UINavigationController *controll=[[UINavigationController alloc]initWithRootViewController:aHDLoop];
		//aHDLoop.frame.view = CGRectMake(0, 0, 768, 1024-50);
		aHDLoop.sCatName = [arrCatDetails1 objectAtIndex:appDelegate.iCatNameIndex];
		aHDLoop.iCatId = [[arrCatDetails1 objectAtIndex:appDelegate.iCatIDIndex]intValue] ;
		aHDLoop.iCatIndexValue = k;
		aHDLoop.totalImages = [[arrCatDetails1 objectAtIndex:appDelegate.iCatNoOfImgsIndex]intValue ] ;
		//[self presentModalViewController:aHDLoop animated:YES];
		[self.navigationController pushViewController:aHDLoop animated:YES];
	
        [aHDLoop release];
	}
	
		
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
	
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
}
-(void)viewDidDisappear:(BOOL)animated
{
	
	for(UIView *s in aTableView.subviews)
	{
		[s removeFromSuperview];
	}
	[aTableView removeFromSuperview];
	
	[aTableView release];
	aTableView = nil;
	
}
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
}


- (void)dealloc {
    [super dealloc];
	[aTableView release];
	[_engine release];
}

- (NSString *)adWhirlApplicationKey {
    return kSampleAppKey;
}

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (NSURL *)adWhirlConfigURL {
    return [NSURL URLWithString:kSampleConfigURL];
}

- (NSURL *)adWhirlImpMetricURL {
    return [NSURL URLWithString:kSampleImpMetricURL];
}

- (NSURL *)adWhirlClickMetricURL {
    return [NSURL URLWithString:kSampleClickMetricURL];
}

- (NSURL *)adWhirlCustomAdURL {
    return [NSURL URLWithString:kSampleCustomAdURL];
}



- (NSDate *)dateOfBirth {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:1979];
    [comps setMonth:11];
    [comps setDay:6];
    NSDate *date = [gregorian dateFromComponents:comps];
    [gregorian release];
    [comps release];
    return date;
}

- (NSUInteger)incomeLevel {
    return 99999;
}

- (NSString *)postalCode {
    return @"31337";
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
    CGPoint tempPoint=[touch locationInView:self.view];
    if(tempPoint.y>=screenHeight1-50)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.com/apps/zaahtechnologiesinc"]];
}


#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return nil;//[[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	NSLog(@"Authenicated for %@", username);
	//NSLog(@"twitterText for %@", twitterText);
	[_engine sendUpdate: [NSString stringWithFormat:@"%@",twitterTextField.text]];
	[twitterTextField release];
	twitterTextField = nil;
}
- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Failed!");
	UIAlertView *status=[[UIAlertView alloc]initWithTitle:@"Twitter Authentication Failed!" 
												  message:nil 
												 delegate:self 
										cancelButtonTitle:@"OK" 
										otherButtonTitles:nil];
	[status show];
	[status release];
	[self dismissModalViewControllerAnimated:YES];
	
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Canceled.");
	UIAlertView *status=[[UIAlertView alloc]initWithTitle:@"Twitter Authentication Canceled" 
												  message:nil 
												 delegate:self 
										cancelButtonTitle:@"OK" 
										otherButtonTitles:nil];
	[status show];
	[status release];
	[self dismissModalViewControllerAnimated:YES];
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	NSLog(@"Request %@ succeeded", requestIdentifier);
	UIAlertView *status=[[UIAlertView alloc]initWithTitle:@"Tweet posted successfully" 
												  message:nil 
												 delegate:self 
										cancelButtonTitle:@"OK" 
										otherButtonTitles:nil];
	[status show];
	[status release];
	[self dismissModalViewControllerAnimated:YES];
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}



//=============================================================================================================================
#pragma mark ViewController Stuff

-(void)openTwitterPage
{
	[self.navigationController.navigationBar setHidden:NO];
	TwitterOpened = YES;
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Post", @selector(twitteract));
	self.navigationItem.leftBarButtonItem = BARBUTTON(@"Back", @selector(action:));
////	self.title=@"Tweet This";
	
	twitterView = [[UIView alloc]initWithFrame:CGRectMake(0,0, screenWidth1, screenHeight1)];
	UIImage  *img  = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Twitter" ofType:@"jpg"]];
	UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, screenWidth1, screenHeight1)];
	imageView.image = img;
	
	
	twitterTextField = [[UITextView alloc] initWithFrame:CGRectMake(10,100, screenWidth1-20, 200)];
	
    twitterTextField.textColor = [UIColor blackColor];
	
    twitterTextField.font = [UIFont fontWithName:@"Arial" size:18];
	
    twitterTextField.delegate = self;
	
    twitterTextField.backgroundColor = [UIColor whiteColor];
	twitterTextField.text =@"I hooked up my phone with the GraffitiSprayCan Dash App. Check it.http://itunes.com/apps/zaahtechnologiesinc";
	//  twitterTextField.placeholder = @"Enter Text To Tweet";
	
	//   twitterTextField.returnKeyType = UIReturnKeyDefault;
	
	// twitterTextField.keyboardType = UIKeyboardTypeDefault; 
	
    twitterTextField.scrollEnabled = YES;
	
    twitterTextField.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	
	
	
	[twitterView addSubview:imageView];
	
	
	[twitterView addSubview:twitterTextField];
	
	[self.view addSubview:twitterView];
	[img release];
	[imageView release];
	
	//[twitterTextField release];
	
	//[twitterView release];
	
	
}



-(IBAction)twitteract {
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
	else{
	if ([twitterTextField hasText]==FALSE) {
		UIAlertView *status=[[UIAlertView alloc]initWithTitle:@"Please enter text to tweet" 
													  message:nil 
													 delegate:self 
											cancelButtonTitle:@"OK" 
											otherButtonTitles:nil];
		[status show];
		[status release];
		return;
		
	}
	
	TwitterOpened = NO;
////	topLabel.text= @"Categories";
	//self.title = @"Categories";
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
	[btn addTarget:self action:@selector(actionSheetAction) forControlEvents:UIControlEventTouchUpInside];
	
	for(UIView *s in twitterView.subviews )
	{
		[s removeFromSuperview];
	}
	
	//[twitterTextField release];
	[twitterView removeFromSuperview];
	[twitterView release];
	
	if (_engine) [_engine release];
	_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
	_engine.consumerKey = kOAuthConsumerKey;
	_engine.consumerSecret = kOAuthConsumerSecret;
	
	UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
	
	if (controller) 
		[self presentModalViewController: controller animated: YES];
	else {
		[_engine sendUpdate: [NSString stringWithFormat: @"Already Updated. %@", [NSDate date]]];
	}
	}
	[self.navigationController.navigationBar setHidden:YES];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"]) {
		
		[textView resignFirstResponder];
		
	}
    return YES;
	
}

-(void)action:(id)sender{

	if(TwitterOpened ==YES)
	{
        [self.navigationController.navigationBar setHidden:YES];
		TwitterOpened =NO;
////		topLabel.text= @"Categories";
		//self.title = @"Categories";
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
		[btn addTarget:self action:@selector(actionSheetAction) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = nil;
		for(UIView *s in twitterView.subviews )
		{
			[s removeFromSuperview];
		}
		
		[twitterTextField release];
		twitterTextField = nil;
		[twitterView removeFromSuperview];
		[twitterView release];
		
		
		return;
	}
	
}

-(IBAction)facebtnact
{
	
	_permissions =  [[NSArray arrayWithObjects: @"read_stream",@"user_photos",@"user_videos",@"publish_stream ",nil] retain];
	_facebook = [[Facebook alloc] init];
	
	if(appDelegate.facebookLogin == TRUE)
	{
		appDelegate.facebookLogin = FALSE;
		[_facebook logout:self];
	}
	[_facebook authorize:kAppId permissions:_permissions delegate:self];
	
}


-(void) fbDidLogin 
{
	NSLog(@"did  login");
	
	
	//UIImage  *img  = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Fol3Image2" ofType:@"jpg"]];
	//	NSData *dataObj = UIImageJPEGRepresentation(img, 1.0);
	//	
	//	NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:dataObj, @"picture",
	//									@"my pencil",@"caption",nil];
	//	
	//	
	//	[_facebook requestWithMethodName: @"facebook.photos.upload" 
	//						   andParams: params
	//					   andHttpMethod: @"POST" 
	//						 andDelegate: self]; 
	
	[self publishStream];
	
	
	
	
}

- (void) publishStream{
	
	SBJSON *jsonWriter = [[SBJSON new] autorelease];
	
	NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys: 
														   @"Always Running",@"text",@"http://itsti.me/",@"href", nil], nil];
    
    NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *strLink = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Itunes_Link"]];
	
	NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
	NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
								@"I hooked up my phone with the GraffitiSprayCan Dash App. Check it. ", @"name",strLink,@"caption",nil];//@"http://itunes.com/elitegudz/",@"href", nil];
	NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   kAppId, @"api_key",
								   @"Share on Facebook",@"user_message_prompt",
								   
								   attachmentStr, @"attachment",
								   nil];	    
	
	
	[_facebook dialog: @"stream.publish"
			andParams: params
		  andDelegate:self];
	
}

- (void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"did not login");
	
	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Unable To Login" 
											  message:nil 
											 delegate:self 
									cancelButtonTitle:@"OK" 
									otherButtonTitles:nil];
	[fb show];
	[fb release];
}

/**
 * Callback for facebook logout
 */ 
-(void) fbDidLogout {
	
	//	[_facebook release];
	
	
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Callback when a request receives Response
 */ 
- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response{
	
	NSLog(@"received response  %@",response );
	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Success" 
											  message:@"Your Image Posted" 
											 delegate:self 
									cancelButtonTitle:@"OK" 
									otherButtonTitles:nil];
	[fb show];
	[fb release];
	
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest*)request didFailWithError:(NSError*)error{
	NSLog(@"%@",error);
	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Unable To Connect" 
											  message:nil 
											 delegate:self 
									cancelButtonTitle:@"OK" 
									otherButtonTitles:nil];
	[fb show];
	[fb release];
	
	
}

/**
 * Called when a request returns and its response has been parsed into an object.
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on thee format of the API response.
 */
- (void)request:(FBRequest*)request didLoad:(id)result {
	
	
	
	NSLog(@"result is ---- %d",result );
	[_facebook logout:self];
	
	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Logged Out" 
											  message:nil 
											 delegate:self 
									cancelButtonTitle:@"OK" 
									otherButtonTitles:nil];
	[fb show];
	[fb release];
}





///////////////////////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/** 
 * Called when a UIServer Dialog successfully return
 */
- (void)dialogDidComplete:(FBDialog*)dialog withPost:(NSString *)currentPostID{
	NSLog(@"feed to delete and %@ rrrr ", currentPostID);
	//[_facebook logout:self];
	
	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Message posted successfully" 
											  message:nil 
											 delegate:self 
									cancelButtonTitle:@"OK" 
									otherButtonTitles:nil];
	[fb show];
	[fb release];
}






-(IBAction)emailact{
	
	MFMailComposeViewController *controller= [[MFMailComposeViewController alloc] init];
	
	
	controller.mailComposeDelegate = self;
	
[controller setSubject:@"I hooked up my phone with the GraffitiSprayCan Dash App. Check it."];	
	//	UIImage *roboPic = [self getphotofrompaint];//[UIImage imageWithContentsOfFile:dataFilePath];
	//	NSData *imageData = UIImagePNGRepresentation(roboPic);
	// 	[controller addAttachmentData:imageData mimeType:@"image/png" fileName:@"concreteImmortalz.png"];
	NSString *emailBody = @"http://itunes.apple.com/us/artist/alpha-media-group-inc./id393395810";
	[controller setMessageBody:emailBody isHTML:NO]; 
	//UIImage  *img  = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Fol3Image2" ofType:@"jpg"]];
	//NSData *dataObj = UIImageJPEGRepresentation(img, 1.0);
	
	
	//[controller addAttachmentData:dataObj mimeType:@"image/jpg" fileName:@"HDWallpaper"];
	
	if(controller!=nil){
	[self presentModalViewController:(UIViewController*)controller animated:YES];
	}
		//[img release];
	[controller release];
	
	
	
}
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
	[self.view setHidden:FALSE];
	if(result==MFMailComposeResultSent){
		UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Mail Sent" 
												  message:nil 
												 delegate:self 
										cancelButtonTitle:@"OK" 
										otherButtonTitles:nil];
		[fb show];
		[fb release];
	}
	else if(result==MFMailComposeResultCancelled){
		UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Mail Cancelled" 
												  message:nil 
												 delegate:self 
										cancelButtonTitle:@"OK" 
										otherButtonTitles:nil];
		[fb show];
		[fb release];
	}
	else if(result==MFMailComposeResultFailed){
		UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Mail Failed" 
												  message:nil 
												 delegate:self 
										cancelButtonTitle:@"OK" 
										otherButtonTitles:nil];
		[fb show];
		[fb release];
	}
	
	
}



@end
