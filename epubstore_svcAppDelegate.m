//
//  epubstore_svcAppDelegate.m
//  epubstore_svc
//
//  Created by partha neo on 9/1/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "epubstore_svcAppDelegate.h"

#import "RootViewController.h"
//#import "DetailViewController.h"
#import "StoreXMLParser.h"
#import "MyBooksViewController.h"
#import "MyComicsViewController.h"
#import "StoreViewController.h"
#import "Catalog.h"
#import "Shelf.h"
#import "SettingsViewController.h"
#import "DashBoardViewController.h"
#import "Clocks.h"
#import "Videos.h"
#import "HDBackgroundDemoOneViewController.h"
#import "HDLoopDemoViewController.h"
#import "Backgrounds.h"
#import "JukeBox.h"
#import "Shop.h"
#import "socialView.h"
#import "bottomTabBarController.h"
#import "CustomViewController.h"

//########################clock
#import "AlarmsViewController.h"
#import "AlarmSettings.h"

//FB
//#import "ASIHTTPRequest.h"
//#import "ASIFormDataRequest.h"
//#import "JSON.h"
//FB
//Twitter
#import "SA_OAuthTwitterEngine.h"
#define kOAuthConsumerKey				@"0H3ta5HmYUvHmNUulLw"		//REPLACE ME
#define kOAuthConsumerSecret			@"mCt81nQDZO3culxS9arcct3XqXisetjxim5ESIngaA"		//REPLACE ME
#define degreesToRadians(x) (M_PI * x / 180.0)
//Twitter

#define ITUNESLINK @"http://www.adminmyapp.com/dashboardgsc/api/read?action=getiTuneUrl"
@implementation epubstore_svcAppDelegate

//StoreViewController *storeVC;
MyBooksViewController *mybooksVC;
MyComicsViewController * myComicsVC;
//SettingsViewController *sett_ViewCont;
UIButton *sclbtn;
//DashBoard
//DashBoardViewController *dashB;
//Clocks *clckVC;
//Videos *videoVC;
//HDLoopDemoViewController *bgVC;
//AlarmsViewController *viewController1;
//socialView *scl;
//JukeBox *jbVC;
//BOOL VappFirstTime=TRUE;
//Shop *shopVC;
epubstore_svcAppDelegate *appdelegate;
StoreXMLParser *storeXmlParser;
BOOL _isDataSourceAvailable;

@synthesize isFirstTimeGameLoad,gameController,activateCount;

@synthesize shopview,videoz,videoview;

@synthesize shopVC,videoVC,storeVC,dashB,bgVC,viewController1,sett_ViewCont;

@synthesize slideToCancel,allSongs;

@synthesize Arr_DownloadingBooks,tabBarController,slideShowTime;

@synthesize window,navigationController;
@synthesize splitViewController; 
@synthesize rootViewController;
@synthesize t;
//@synthesize detailViewController;
@synthesize Masterdatabase;
@synthesize recordsetmaster;
@synthesize bookPurchased;
@synthesize fontSize;
@synthesize fontName;
@synthesize speed;
@synthesize bookListArray;
@synthesize booksDetailsArray;
@synthesize downloadCount;
@synthesize bookdetailsObj;
@synthesize NoWifiConnection,thumbView;

@synthesize loginAuthKey,errorDetails,isValidLoginOrReg,recoveredPassWord,userDetails;
@synthesize deviceToken,Uid,appBadge;

@synthesize screenHeight1,screenWidth1,tabCoverView;

BOOL pnFailed;

@synthesize IsEnabledLinks;
@synthesize ISPushNotification;

@synthesize loginDialog = _loginDialog;
@synthesize accessToken = _accessToken;
@synthesize loginDialogView = _loginDialogView;

//@synthesize newsTable;

//*******************************************//
@synthesize aNavigation1,myvalue;

@synthesize strCatList,strCatDetails,strSlideDetails,arrCatList,strURL,strCatName,facebookLogin;
@synthesize iCatIDIndex,iCatNameIndex,iCatNoOfImgsIndex,strThumbImgName,checkPurchasedValue,iUpdateValue;

@synthesize str320by480Name,str104by157Name,str640by960Name,strRowDelimeter,strColDelimiter,strCatDelimiter,strTotalString,dataFilePath,docFolder;

@synthesize isVideoPlaying;
//Video

//@synthesize vidUrl;


//###########################clock
@synthesize interruptedOnPlayback,cancenView;
@synthesize aNavigation,themeValue,alarmTheme;
@synthesize alarmTimeArray,totalTime,songIndex,ipodSongTitle,musicPlayer,audioPlayer,newSection,firstString,volumeLevel,purchaseValue,arrBuyImages;//playList
@synthesize sclbtn,productIdName,productArray,storeproductidentifier;

@synthesize isSwitch;
@synthesize prefs;


@synthesize viewController = _viewController;

@synthesize myarray,picStr,tabIndex;
@synthesize listData;
@synthesize userID, logedUserFLName, logedUserImg;
@synthesize videoTagId, selectedUserId;
@synthesize postVideoUrl;
@synthesize FBfriendsList, FBfriendsIds;
@synthesize videoTaggedIds;
@synthesize postTitle, postDescription;
@synthesize loginFlag, redirectToRoot, reachability,boolFlag,loginBool,boolComments,boolVideoPlayer, onFirstLoad, mediaPosted,boolDelete;
@synthesize orientation, captureOrientation;


#pragma mark -
#pragma mark Application lifecycle
static NSString *kAppId=@"247740738612415";

void HandleExceptions(NSException *exception) {
	NSLog(@"This is where we save the application data during a exception");
	// Save application data on crash
}
/*
 My Apps Custom signal catcher, we do special stuff here, and TestFlight takes care of the rest
 **/
void SignalHandler(int sig) {
	
	NSLog(@"This is where we save the application data during a signal");
	// Save application data on crash
}

//#################clock


NSTimer *snoozeTimer;
BOOL SnoozeOn = FALSE;

/*                               
-(id)init {
	if (self = [super init]) 
	{
		[self EpubStore_database:@"ePubStore.sqlite"];
	}
	
	return self;
}
*/

-(void)hideIndicator
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
   // if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[mmsvViewController alloc] initWithNibName:@"mmsvViewController_iPhone" bundle:nil];
//    } else {
//        self.viewController = [[mmsvViewController alloc] initWithNibName:@"mmsvViewController_iPad" bundle:nil];
//    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{ 
    NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(memoryLevel) userInfo:nil repeats:YES];
    
    NSSetUncaughtExceptionHandler(&HandleExceptions);
	// create the signal action structure 
	struct sigaction newSignalAction;
	// intialize the signal action structure
	memset(&newSignalAction, 0, sizeof(newSignalAction));
	// set SignalHandler as the handler in the signal action structure
	newSignalAction.sa_handler = &SignalHandler;
	// set SignalHandler as the handlers for SIGABRT, SIGILL and SIGBUS
	sigaction(SIGABRT, &newSignalAction, NULL);
	sigaction(SIGILL, &newSignalAction, NULL);
	sigaction(SIGBUS, &newSignalAction, NULL);
	
	// Call takeOff after install your own unhandled exception and signal handlers
	[TestFlight takeOff:@"5b346417d9fa38ab34507ea971975df3_MTEzNjY"]; 
    
    
    prefs = [NSUserDefaults standardUserDefaults];
	screenHeight1 = [[UIScreen mainScreen] bounds].size.height;
    screenWidth1 =[[UIScreen mainScreen] bounds].size.width;
	slideShowTime=10;
	[self.window setBackgroundColor:[UIColor blackColor]];
	//Code Changed As per mani's request on 22-03-2011				 
	
	//NIKHIL NEW CODE
    //[url release];
	//playing = YES;
	isFirstTimeGameLoad=YES;
    
	if([prefs integerForKey:@"gotWifiAtleastOnce"]!=777)
	{
		
		NSString *str =@"http://www.google.com";
		NSURL *url = [[NSURL alloc] initWithString:str];
		NSData *data = [[NSData alloc]initWithContentsOfURL:url];
		//if(data==nil)
        //		{
        //		
        //			
        //			UIView *errView= [[UIView alloc] initWithFrame:CGRectMake(0, 0,768 , 1024)];
        //			UILabel *errlabel= [[UILabel alloc] initWithFrame:CGRectMake(70, 500,668 , 100)];
        //			errlabel.text=@"This application requires active internet connection. Please connect to internet." ;
        //			[errView addSubview:errlabel];
        //			[errView setBackgroundColor:[UIColor blackColor]];
        //			[errlabel setBackgroundColor:[UIColor clearColor]];
        //			[errlabel setTextColor:[UIColor whiteColor]];
        //			
        //			[window addSubview:errView];
        //			[window makeKeyAndVisible];
        //			
        //			[errView release];
        //			[errlabel release];
        //			[url release];
        //			
        //			return;
        //			
        //		}
        //		else 
		{
			
			[prefs setInteger:777 forKey:@"gotWifiAtleastOnce"];
			[prefs synchronize];
		}
		[url release];
		[data release];
	}
	
	
	///NIKHIL NEW CODE - END 
	
	if([prefs integerForKey:@"appFirstTime"]!=1)
	{
		IsEnabledLinks=TRUE;
		ISPushNotification=TRUE;
		
        [prefs setInteger:1 forKey:@"appFirstTime"];
		[prefs setBool:IsEnabledLinks forKey:@"IsEnabledLinks"];
		[prefs setBool:ISPushNotification forKey:@"ISPushNotification"];
		[prefs setInteger:3 forKey:@"delayTime"];
		[prefs synchronize];
        
		//[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
		pnFailed=YES;
	}
	else
	{
		IsEnabledLinks = [prefs boolForKey:@"IsEnabledLinks"];
		ISPushNotification = [prefs boolForKey:@"ISPushNotification"];
		//slideShowTime =[prefs integerForKey:@"delayTime"];
	}
	
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
	
    
	
	/********************************    This is for Ebook Reader  ******************************************/
	Arr_DownloadingBooks = [[NSMutableArray alloc] init];
	fontSize = [prefs floatForKey:@"FontSize"];
	speed = [prefs floatForKey:@"ScrollSpeed"];
	loginAuthKey = [prefs stringForKey:@"AuthenticationKey"];
	if ([loginAuthKey isEqualToString:@"" ]) 
	{
		loginAuthKey = nil;
	}
	//loginAuthKey =@"9650ef957e71f654013e1319f3c72268";
	if (fontSize ==0) {
		fontSize = 100.0;
		
	}
	fontName = @"none";
	NoWifiConnection =FALSE;
    
	// Override point for customization after app launch    
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	NSString *path=[documentsDirectory stringByAppendingPathComponent:@"ePubStore.sqlite"];
	self.Masterdatabase=[FMDatabase databaseWithPath:path];
	if(![self.Masterdatabase open]) 	
	{
		NSLog(@"Not open");
	}
	
    
	// **********************   Load 2 Xml Files  ******************************//
	//[self LoadAllBooksDateSortXml];// No need to save this file By Coomented 
	[self LoadAllBooksData:FALSE];
	
	
	//***************************************************
	strThumbImgName=@"Thumb.png";
	str320by480Name = @"384by512";
	str104by157Name = @"255by340";
	str640by960Name = @"768by1024";
	
	self.facebookLogin = TRUE;
	
	//	
	//	str320by480Name = @"320by480";
	//	str104by157Name = @"104by157";
	//	str640by960Name = @"640by960";
	
	
	
	
	//Delimeters
	strRowDelimeter = @"|$|$";
	strColDelimiter = @"$$";
	strCatDelimiter = @"$|$|";
	
	
	UIImage *img = nil;
	
	
	
	//dashB=[[DashBoardViewController alloc] init];
	//dashB.title = @"Dashboard";
	//img = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"dashboard_icon.png"]] ];
	//dashB.tabBarItem.image = img;
	
	
	//Comics
	storeVC = [[StoreViewController alloc] init];
	storeVC.title = @"Magazines";
	img = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"comics_icon.png"]] ];
	storeVC.tabBarItem.image = img;
	//[img release];
	
	//Clocks
	//clckVC=[[Clocks alloc] init];
    //	clckVC.title = @"Clocks";
    //	img = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"clock_icon.png"]] ];
    //	clckVC.tabBarItem.image = img;
    //	[img release];
	
	viewController1=[[AlarmsViewController alloc] init];
	viewController1.title = @"Clocks";
	img = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"clock_icon.png"]] ];
	viewController1.tabBarItem.image = img;
	//[img release];
	
	//Videos
	videoVC=[[Videos alloc] init];
	videoVC.title = @"Videos";
	img = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"videos_icon.png"]] ];
	videoVC.tabBarItem.image = img;
	//[img release];
	
	//[self.window addSubview:videoVC.view];
	//[videoVC.view addSubview:videoview];
	[videoVC.view setHidden:TRUE];
	
	//videoview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 150, 768, 467)];
    //	[self.window addSubview:videoview];
    //	[videoview setHidden:TRUE];
	//Backgrounds		
    
	bgVC=[[HDBackgroundDemoOneViewController alloc] init];
	//bgVC = [[UINavigationController alloc] init];
	UINavigationController *navigation=[[UINavigationController alloc]initWithRootViewController:bgVC];
	navigation.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	//bgVC.title = @"Backgrounds";
	img = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"backgrounds_icon.png"]] ];
	navigation.tabBarItem.image = img;
	navigation.tabBarItem.title = @"Backgrounds";
	//[img release];
    
    // Games===
    gameController=[[TBONEViewController alloc] init];
	gameController.title = @"APPS";
	img = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"videos_icon.png"]] ];
	gameController.tabBarItem.image = img;
	//[img release];    	
    gameController.isGameClosed=TRUE;
    /////    [gameController.navigationController setNavigationBarHidden:TRUE];
	//Shop
	
//	shopVC=[[Shop alloc] init];
//	shopVC.title = @"Shop";
//	//shopview = [[UIWebView alloc]init];
//	img = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"shop_icon.png"]] ];
//	shopVC.tabBarItem.image = img;
	//[img release];
    ////	shopview.hidden=YES;
	
    CustomViewController *customView =[[CustomViewController alloc] init];
    customView.title = @"MASSWAVE";
    img = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"shop_icon.png"]] ];
    customView.tabBarItem.image = img;
	
	
	sett_ViewCont = [[SettingsViewController alloc] init] ;//]WithNibName:@"SettingsViewController" bundle:[NSBundle mainBundle]];
	sett_ViewCont.title = @"Settings";
	
	img = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"icon_setting.png"]] ];
	sett_ViewCont.tabBarItem.image = img;
	//[img release];
    
	bottomTabBarController *tempTabBar = [[bottomTabBarController alloc] init];
    self.tabBarController=tempTabBar;
    [tempTabBar release];
    ///    self.tabBarController.isVideoPlaying=TRUE;
    //Karpaga on 29-08-2011	tabBarController.viewControllers = [NSArray arrayWithObjects: dashB,storeVC,viewController1,videoVC,bgVC,shopVC,sett_ViewCont, nil]; //jbVC,
	self.tabBarController.viewControllers = [NSArray arrayWithObjects: storeVC,viewController1,videoVC,navigation,gameController,customView, nil]; //jbVC,
    [navigation release];
	self.tabBarController.selectedIndex = 1;
	[self.tabBarController.tabBar sizeToFit];
    //Karpaga on 29-08-2011	
	self.tabBarController.selectedViewController = storeVC;
	self.tabBarController.delegate=self;
    [self.tabBarController.moreNavigationController setNavigationBarHidden:TRUE];
    
    tabCoverView=[[UIView alloc]initWithFrame:CGRectMake(0, screenHeight1-48, screenWidth1, 48)];
    [tabCoverView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    tabCoverView.tag = 1000;
    [self.tabBarController.view addSubview:tabCoverView];
    int titleFontSize=7;
    previousTab=1;
    if (screenWidth1==768) 
    {
        titleFontSize=15;
        
        CustomButton *magz_btn=[CustomButton buttonWithType:UIButtonTypeCustom];
        magz_btn.frame=CGRectMake((28.0/320)*screenWidth1, 0, (45.0/320)*screenWidth1, 38);
        [magz_btn setTitle:@"MAGAZINES" forState:UIControlStateNormal];
        magz_btn.titleLabel.font=[UIFont boldSystemFontOfSize:titleFontSize];
        [tabCoverView addSubview:magz_btn];
        [magz_btn addTarget:self action:@selector(loadSelectedViewController:) forControlEvents:UIControlEventTouchUpInside];
        magz_btn.tag=200+1;
        [magz_btn setColorAtRect:CGRectMake(magz_btn.center.x-((20.0/320)*screenWidth1)-magz_btn.frame.origin.x, -1, ((40.0/320)*screenWidth1), 4) color:[UIColor yellowColor]];
        [magz_btn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        
        CustomButton *clk_btn=[CustomButton buttonWithType:UIButtonTypeCustom];
        clk_btn.frame=CGRectMake((87.0/320)*screenWidth1, 0, (30.0/320)*screenWidth1, 38);
        [clk_btn setTitle:@"CLOCK" forState:UIControlStateNormal];
        clk_btn.titleLabel.font=[UIFont boldSystemFontOfSize:titleFontSize];
        [tabCoverView addSubview:clk_btn];
        clk_btn.tag=200+2;
        [clk_btn addTarget:self action:@selector(loadSelectedViewController:) forControlEvents:UIControlEventTouchUpInside];
        
        CustomButton *vid_btn=[CustomButton buttonWithType:UIButtonTypeCustom];
        vid_btn.frame=CGRectMake((133.0/320)*screenWidth1, 0, (30.0/320)*screenWidth1, 38);
        [vid_btn setTitle:@"VIDEOS" forState:UIControlStateNormal];
        vid_btn.titleLabel.font=[UIFont boldSystemFontOfSize:titleFontSize];
        [tabCoverView addSubview:vid_btn];
        vid_btn.tag=200+3;
        [vid_btn addTarget:self action:@selector(loadSelectedViewController:) forControlEvents:UIControlEventTouchUpInside];
        
        CustomButton *bg_btn=[CustomButton buttonWithType:UIButtonTypeCustom];
        bg_btn.frame=CGRectMake((182.0/320)*screenWidth1, 0, (60.0/320)*screenWidth1, 38);
        [bg_btn setTitle:@"BACKGROUNDS" forState:UIControlStateNormal];
        bg_btn.titleLabel.font=[UIFont boldSystemFontOfSize:titleFontSize];
        [tabCoverView addSubview:bg_btn];
        bg_btn.tag=200+4;
        [bg_btn addTarget:self action:@selector(loadSelectedViewController:) forControlEvents:UIControlEventTouchUpInside];
        
        CustomButton *gam_btn=[CustomButton buttonWithType:UIButtonTypeCustom];
        gam_btn.frame=CGRectMake((255.0/320)*screenWidth1, 0, (30.0/320)*screenWidth1, 38);
        [gam_btn setTitle:@"APPS" forState:UIControlStateNormal];
        gam_btn.titleLabel.font=[UIFont boldSystemFontOfSize:titleFontSize];
        [tabCoverView addSubview:gam_btn];
        gam_btn.tag=200+5;
        [gam_btn addTarget:self action:@selector(loadSelectedViewController:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        magz_btn=[CustomButton buttonWithType:UIButtonTypeCustom];
        magz_btn.frame=CGRectMake((3.0/320)*screenWidth1, 0, (45.0/320)*screenWidth1, 38);
        [magz_btn setTitle:@"MAGAZINES" forState:UIControlStateNormal];
        magz_btn.titleLabel.font=[UIFont boldSystemFontOfSize:titleFontSize];
        [tabCoverView addSubview:magz_btn];
        [magz_btn addTarget:self action:@selector(loadSelectedViewController:) forControlEvents:UIControlEventTouchUpInside];
        magz_btn.tag=200+1;
        [magz_btn setColorAtRect:CGRectMake(magz_btn.center.x-((20.0/320)*screenWidth1)-magz_btn.frame.origin.x, -1, ((40.0/320)*screenWidth1), 4) color:[UIColor yellowColor]];
        [magz_btn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        
        CustomButton *clk_btn=[CustomButton buttonWithType:UIButtonTypeCustom];
        clk_btn.frame=CGRectMake((62.0/320)*screenWidth1, 0, (30.0/320)*screenWidth1, 38);
        [clk_btn setTitle:@"CLOCK" forState:UIControlStateNormal];
        clk_btn.titleLabel.font=[UIFont boldSystemFontOfSize:titleFontSize];
        [tabCoverView addSubview:clk_btn];
        clk_btn.tag=200+2;
        [clk_btn addTarget:self action:@selector(loadSelectedViewController:) forControlEvents:UIControlEventTouchUpInside];
        
        CustomButton *vid_btn=[CustomButton buttonWithType:UIButtonTypeCustom];
        vid_btn.frame=CGRectMake((108.0/320)*screenWidth1, 0, (30.0/320)*screenWidth1, 38);
        [vid_btn setTitle:@"VIDEOS" forState:UIControlStateNormal];
        vid_btn.titleLabel.font=[UIFont boldSystemFontOfSize:titleFontSize];
        [tabCoverView addSubview:vid_btn];
        vid_btn.tag=200+3;
        [vid_btn addTarget:self action:@selector(loadSelectedViewController:) forControlEvents:UIControlEventTouchUpInside];
        
        CustomButton *bg_btn=[CustomButton buttonWithType:UIButtonTypeCustom];
        bg_btn.frame=CGRectMake((157.0/320)*screenWidth1, 0, (60.0/320)*screenWidth1, 38);
        [bg_btn setTitle:@"BACKGROUNDS" forState:UIControlStateNormal];
        bg_btn.titleLabel.font=[UIFont boldSystemFontOfSize:titleFontSize];
        [tabCoverView addSubview:bg_btn];
        bg_btn.tag=200+4;
        [bg_btn addTarget:self action:@selector(loadSelectedViewController:) forControlEvents:UIControlEventTouchUpInside];
        
        CustomButton *gam_btn=[CustomButton buttonWithType:UIButtonTypeCustom];
        gam_btn.frame=CGRectMake((230.0/320)*screenWidth1, 0, (30.0/320)*screenWidth1, 38);
        [gam_btn setTitle:@"APPS" forState:UIControlStateNormal];
        gam_btn.titleLabel.font=[UIFont boldSystemFontOfSize:titleFontSize];
        [tabCoverView addSubview:gam_btn];
        gam_btn.tag=200+5;
        [gam_btn addTarget:self action:@selector(loadSelectedViewController:) forControlEvents:UIControlEventTouchUpInside];
        
        
        gam_btn1=[CustomButton buttonWithType:UIButtonTypeCustom];
        gam_btn1.frame=CGRectMake((270.0/320)*screenWidth1, 0, (50.0/320)*screenWidth1, 38);
        [gam_btn1 setTitle:@"MASSWAVE" forState:UIControlStateNormal];
        gam_btn1.titleLabel.font=[UIFont boldSystemFontOfSize:titleFontSize];
        [tabCoverView addSubview:gam_btn1];
        gam_btn1.tag=200+6;
        [gam_btn1 addTarget:self action:@selector(loadSelectedViewController:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    

    
    
    //    CustomButton *shp_btn=[CustomButton buttonWithType:UIButtonTypeCustom];
    //    shp_btn.frame=CGRectMake((285.0/320)*screenWidth1, 0, (26.0/320)*screenWidth1, 38);
    //    [shp_btn setTitle:@"SHOP" forState:UIControlStateNormal];
    //     shp_btn.titleLabel.font=[UIFont boldSystemFontOfSize:titleFontSize];
    //    [tabCoverView addSubview:shp_btn];
    //    shp_btn.tag=200+6;
    //    [shp_btn addTarget:self action:@selector(loadSelectedViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    
	//[dashB release];
	[storeVC release];
	[viewController1 release];
	[videoVC release];
	[shopVC release];
	[bgVC release];
	[sett_ViewCont release];
	
	
    //End of FB Like
	//**********************************
	//[window addSubview:[shopVC view]];
	if([[UIScreen mainScreen] bounds].size.height==1024)
		///self.strURL = @"http://www.elitegudz.com/hdwallipad/";
        //self.strURL = @"http://208.122.55.129/maximdash/hdwallipad/";
        
        //        self.strURL = @"http://208.122.55.224/maximdash/hdwallipad/";
		self.strURL = @"http://adminmyapp.com/dashboardgsc/hdwallipad/";
    
    //self.strURL = @"http://122.183.212.56/maximdash/hdwallipad/";
    
    //http://208.122.55.129/maximdash/
    //self.strURL = @"http://maximgirls.myzaah.com/maximdash/hdwallipad/";
    //http://maximgirls.myzaah.com/maximwallpaper/hdwallipad
	else {
        //        self.strURL = @"http://208.122.55.224/maximdash/hdwallip/";
        
        self.strURL = @"http://adminmyapp.com/dashboardgsc/hdwallip/";
		
        //self.strURL = @"http://122.183.212.56/maximdash/hdwallip/";
        //self.strURL = @"http://208.122.55.129/maximdash/hdwallip/";
		//self.strURL = @"http://maximgirls.myzaah.com/maximdash/hdwallip/";
        //http://maximgirls.myzaah.com/maximwallpaper/hdwallipad
		str320by480Name = @"320by480";
		str104by157Name = @"104by157";
		str640by960Name = @"640by960";
		
	}
    
    NSData *urlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@%@",self.strURL,@"info.php" ] ]];
	
	//NSUserDefaults *backGrounds = [NSUserDefaults standardUserDefaults];
	
	
	if(urlData == nil)
	{
		self.strCatList = [prefs objectForKey:@"configString"];
	}
	else {
		self.strCatList = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
		[prefs setObject:self.strCatList forKey:@"configString"];
	}
	[prefs synchronize];
	
	[urlData release];
	//arrCatList =[[[NSMutableArray alloc]initWithArray:[self.strCatList componentsSeparatedByString:strRowDelimeter]]retain];
	arrCatList =[[self.strCatList componentsSeparatedByString:strRowDelimeter] mutableCopy];
	
	for(int i=0;i<[arrCatList count];i++)
	{
		NSString *temp = [arrCatList objectAtIndex:i];
		NSString *trim= [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		[arrCatList replaceObjectAtIndex:i withObject:trim];
		
	}
	
	self.thumbView = TRUE;
	//Index value of category details
	iCatIDIndex = 0;
	iCatNameIndex = 1;
	iCatNoOfImgsIndex = 2;
	checkPurchasedValue = 3;
	iUpdateValue = 4; 
    
    
    /*
     
     NSData *urlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@%@",self.strURL,@"info.php" ] ]];
     
     NSLog(@"hit url1 %@",urlData);
     
     if(urlData == nil)
     {
     self.strCatList = [prefs objectForKey:@"configString"];
     }
     else 
     {
     self.strCatList = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
     [prefs setObject:self.strCatList forKey:@"configString"];
     }
     
     {
     NSString *arr=[prefs objectForKey:@"configString"];
     if (self.strCatList) {
     [self.strCatList release];
     self.strCatList=nil;
     }
     self.strCatList = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
     if (arr) {
     for (NSString *str in [self.strCatList componentsSeparatedByString:strRowDelimeter]) {
     if ([[str componentsSeparatedByString:@"$$"] count]>=5) {
     for (NSString *str1 in [arr componentsSeparatedByString:strRowDelimeter]) {
     if ([[str1 componentsSeparatedByString:@"$$"] count]>=5) {
     if ([[[str componentsSeparatedByString:@"$$"] objectAtIndex:0] isEqualToString:[[str1 componentsSeparatedByString:@"$$"] objectAtIndex:0]]) {
     if (![[[str componentsSeparatedByString:@"$$"] objectAtIndex:5] isEqualToString:[[str1 componentsSeparatedByString:@"$$"] objectAtIndex:5]]) {
     if(screenHeight1==1024)
     [self removeImageFromDocFolder:[[NSString stringWithFormat:@"%@_Ipad_%@",[[str componentsSeparatedByString:@"$$"] objectAtIndex:0],self.strThumbImgName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
     else {
     [self removeImageFromDocFolder:[[NSString stringWithFormat:@"%@_Iphone_%@",[[str componentsSeparatedByString:@"$$"] objectAtIndex:0],self.strThumbImgName]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
     }
     break;
     }
     }
     }
     
     }
     
     }
     
     }
     }
     
     [prefs setObject:self.strCatList forKey:@"configString"];
     }
     
     [prefs synchronize];
     
     [urlData release];
     
     //strCatList = @"51$$Concrete Immortalz$$9|$|$52$$Damaged Gudz$$9|$|$53$$Elite Gudz$$9|$|$54$$Goons And Bot$$19|$|$55$$Art Canvases$$9|$|$56$$Monsters$$9|$|$57$$Phat Phaces$$10";
     
     
     //strCatList = @"51$$Concrete Immortalz$$9$$0.00|$|$52$$Damaged Gudz$$9$$0.99|$|$53$$Elite Gudz$$9$$0.00|$|$54$$Goons And Bot$$19$$0.00|$|$55$$Art Canvases$$9$$0.00|$|$56$$Monsters$$9$$0.00|$|$57$$Phat Phaces$$10$$0.00";
     
     //strCatList = @"51$$Concrete Immortalz$$9$$0.99$$0|$|$52$$Damaged Gudz$$9$$0.00$$1|$|$53$$Elite Gudz$$9$$0.00$$0|$|$54$$Goons And Bot$$19$$0.00$$0|$|$55$$Art Canvases$$9$$0.00$$0|$|$56$$Monsters$$9$$0.00$$0";
     
     
     //This value should be fetched from user default
     //strCatList =[NSString stringWithFormat:@"51$$Concrete Immortalz$$9|$|$52$$Damaged Gudz$$9|$|$53$$Elite Gudz$$9|$|$54$$Goons And Bot$$19|$|$55$$Art Canvases$$9|$|$56$$Monsters$$9|$|$57$$Phat Phaces$$10|$|$"];
     arrCatList =[[NSMutableArray alloc]initWithArray:[self.strCatList componentsSeparatedByString:strRowDelimeter]];
     
     
     for(int i=0;i<[arrCatList count];i++)
     {
     NSString *temp = [arrCatList objectAtIndex:i];
     NSString *trim= [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     [arrCatList replaceObjectAtIndex:i withObject:trim];
     
     
     }
     
     self.thumbView = TRUE;
     //Index value of category details
     iCatIDIndex = 0;
     iCatNameIndex = 1;
     iCatNoOfImgsIndex = 2;
     checkPurchasedValue = 3;
     iUpdateValue = 4;*/ 
	
	//aNavigation.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    //[window addSubview:aNavigation.view];
	
	//#####################clock
	[self.window setBackgroundColor:[UIColor blackColor]];
	//aNavigation =[[UINavigationController alloc]init];//WithRootViewController:viewController1];
    //aNavigation1 =[[UINavigationController alloc]initWithRootViewController:bgVC];
    
	//[aNavigation setNavigationBarHidden:YES];
	//aNavigation.navigationBar.barStyle=UIBarStyleBlackTranslucent;
	//[aNavigation1 setNavigationBarHidden:YES];
	//aNavigation1.navigationBar.barStyle=UIBarStyleBlackTranslucent;
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
	
	UIApplication *thisApp = [UIApplication sharedApplication];
	thisApp.idleTimerDisabled = NO;
	thisApp.idleTimerDisabled = YES;
	
	//[[UIApplication sharedApplication] cancelAllLocalNotifications];
	//  [window addSubview:viewController.view];
	//[self.window addSubview:aNavigation.view];
	//[window addSubview:aNavigation1.view];
	//[window setBackgroundColor:[UIColor blackColor]];
    //[self.window makeKeyAndVisible];
	//slideToCancel.enabled = YES;
	
    //	NSUserDefaults *prefz = [NSUserDefaults standardUserDefaults];
    //	NSString *UrlWithIndex = [prefz stringForKey:@"AlarmIndex"];
    //	ipodSongTitle = [prefz stringForKey:@"ipodSongTitle"];
	
	//alarmTimeArray = (NSMutableArray *)[prefs arrayForKey:@"AlarmTimeArray"];
	alarmTimeArray = [self getArray];
	
    //	NSRange end  = [UrlWithIndex rangeOfString: @"$$$"];
    //	NSRange end1 = [UrlWithIndex rangeOfString: @"###"];
    //	
    //	int lenght =  [UrlWithIndex length];
    //	
    //	if (end.location !=NSNotFound &&UrlWithIndex !=nil) {
    //		lenght = lenght -(end1.location+end1.length);
    //		
    //		newSection = [[UrlWithIndex substringWithRange: NSMakeRange (0,end.location)]intValue];
    //		songIndex= [[UrlWithIndex substringWithRange: NSMakeRange (end.location+end.length,1)]intValue];
    //		volumeLevel = [[UrlWithIndex substringWithRange: NSMakeRange (end1.location+end1.length,lenght)]intValue];
    //	}
    //	else {
    //		newSection = 1;
    //		songIndex = 0;
    //		volumeLevel = 1;
    //	} 
	//	if (newSection == nil) {
	//		newSection =1;
	//		songIndex = 0;
	//	}
    //	if (volumeLevel ==0.0) {
    //		volumeLevel = 0.5;
    //	}
	//newSection = 1;
	
	//playList = [[NSMutableArray alloc]init];
	//[playList addObject:@"Zombie_Horde_by_Wolfsinger"];
	//[playList addObject:@"Zombie_News_01_by_parabolix"];
	//[playList addObject:@"Zombie_News_02_by_Corsica_S"];
	
	MPMediaQuery *query = [[[MPMediaQuery alloc] init] autorelease];
    [query setGroupingType:MPMediaGroupingArtist];
	allSongs = [[NSMutableArray alloc] initWithArray:[query items] ];
    
    
    
	if (!slideToCancel) {
		// Create the slider
		slideToCancel = [[SlideToCancelViewController alloc] init];
		slideToCancel.delegate = self;
		//cancenView = [[UIView alloc]initWithFrame:CGRectMake(0,-390,768,700)];//320,390
		UIImage *trackImage = [UIImage imageNamed:@"turnoffbutton.png"];
		if(screenHeight1 == 1024)
		{
			cancenView = [[UIView alloc]initWithFrame:CGRectMake(0,-390,768,700)];
			trackImage = [UIImage imageNamed:@"turnoffbutton.png"];
		}
		else
		{
			cancenView = [[UIView alloc]initWithFrame:CGRectMake(0,-390,320,390)];
			trackImage = [UIImage imageNamed:@"turnoffbuttoniphone.png"];
		}
		UIImageView *sliderBackground = [[UIImageView alloc] initWithImage:trackImage];
		
		// Create the superview same size as track backround, and add the background image to it
		UIButton *cancelbutton;// = [[UIButton alloc]initWithFrame:CGRectMake(0,0,768,50)];
		if(screenHeight1 == 1024)
			cancelbutton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,768,50)];
		else
			cancelbutton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,320,50)];
		
		[cancelbutton addTarget:self action:@selector(cancelSnooze) forControlEvents:UIControlEventTouchUpInside];			  
		[cancenView addSubview:sliderBackground];
        [sliderBackground release];
		[cancenView addSubview:cancelbutton];
		[cancelbutton release];
		///[cancenView setBackgroundColor:[UIColor redColor]];
		
		// Position the slider off the bottom of the view, so we can slide it up
		CGRect sliderFrame = slideToCancel.view.frame;
		if(screenHeight1 == 1024)
			sliderFrame.origin.y = 1500; //window.frame.size.height;
		else
			sliderFrame.origin.y = window.frame.size.height;
		slideToCancel.view.frame = sliderFrame;
		
		// Add slider to the view
		[window addSubview:cancenView];	
        
		//[window addSubview:slideToCancel.view];
		
        //		alm = [[AlarmsViewController alloc]init];
        //		[alm performSelector:@selector(sliding)];
		
	}
	
	
	UILocalNotification *localNotif =[launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
		
		[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
		
		[snoozeTimer invalidate];
		snoozeTimer = nil;
		[self startSlidingAndAlarmPlay];
		//[self playAlarm];
	}
	
    
	//Video
	
	//vidUrl = @"http://www.adminmyapp.com/dashboard/wizardworld/api/read?action=video&start=0&record=5";
	
	
    // Alarm */
	window.backgroundColor = [UIColor blackColor];
	//[window addSubview:aNavigation.view];
	[window bringSubviewToFront:cancenView];
	//[window bringSubviewToFront:slideToCancel.view];
	//[window addSubview:tabBarController.view];
	//[slideToCancel release];
	[self.window addSubview:self.tabBarController.view];
    [self.window makeKeyAndVisible];
	[self.tabBarController.view addSubview:slideToCancel.view]; 
    
    ////    if (screenWidth1==320) 
    {
        //        closeTabBar=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //        closeTabBar.frame=CGRectMake(screenWidth1-50, screenHeight1-50, 40, 40);
        //        [self.tabBarController.view addSubview:closeTabBar];
        //        closeTabBar.hidden=TRUE;
        //        [closeTabBar addTarget:self action:@selector(ManageTabBar) forControlEvents:UIControlEventTouchUpInside];
        //        closeTabBar.transform=CGAffineTransformMakeRotation(degreesToRadians(-90));
        //        closeTabBar.center=CGPointMake(screenWidth1-15, screenHeight1-15);
        //        showingTabBar=TRUE;
    } 
    
    [self checkWifi:YES];

    
    //fetching notlogedIn video Listing 
    [self fetchVideoListing:@"media.video-list-feature"uid:nil setCurrentPage:1];
    
    loginBool = 0;
    
    boolFlag =0;
    
    tempBool =0;
    
    boolVideoPlayer = 0;
    
    boolDelete = 0;
    
    onFirstLoad = TRUE;
    
       
    
    
    redirectToRoot = loginFlag = FALSE;
    
    
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory1 = [paths1 objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory1 stringByAppendingPathComponent:@"data"];
    NSString *thumbPath = [documentsDirectory1 stringByAppendingPathComponent:@"thumbData"];
    NSLog(@"data path = %@",dataPath);
    
    NSError *error;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
    {    
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:thumbPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:thumbPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
        
    }

    [self performSelector:@selector(LoadURL)];
    
    return YES;
}
-(BOOL)checkWifi:(BOOL)showMsg
{
    
	
	Reachability *wifiReach = [[Reachability reachabilityForInternetConnection] retain];
	[wifiReach startNotifier];
	
	NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
	BOOL connectionAvailble= FALSE;//[curReach connectionRequired];
    NSString* statusString= @"";
    switch (netStatus)
    {
        case NotReachable:
        {
			connectionAvailble= FALSE;
			break;
        }
            
        case ReachableViaWWAN:
        {
			connectionAvailble= TRUE;
			NSLog(@"Wan Connected");
			break;
        }
        case ReachableViaWiFi:
        {
			NSLog(@"WiFi Connected");
			connectionAvailble= TRUE;
			break;
		}
    }
    if(!connectionAvailble && showMsg)
    {
		//      statusString= [NSString stringWithFormat: @"%@, Connection Required", statusString];
        
        reachability = FALSE;
        //		UIAlertView *connectWiFi=[[UIAlertView alloc]initWithTitle:@"Network Connection Error" message:@"You must be connected to Internet" 
        //														  delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        //		[connectWiFi show];
        //		[connectWiFi release];
    }
    else
    {
        reachability = TRUE;
    }
    
    
	[wifiReach release];
	return connectionAvailble;	
}

-(void)fetchVideoListing:(NSString*)method uid:(NSString*)userId setCurrentPage:(int)curPage 
{
    
    // now we can save these to a file
    NSString   *savePath = [[NSString stringWithFormat:@"~/Documents/data/%@.data",method] stringByExpandingTildeInPath];
    
    if(reachability==FALSE)
	{
        //and restore them
        
        BOOL isDirectory = NO;
        if ( [[NSFileManager defaultManager] fileExistsAtPath:savePath isDirectory: &isDirectory ] ) {
            listData = [NSMutableDictionary dictionaryWithContentsOfFile: savePath];
        } else {
            listData = [[NSMutableDictionary alloc] init];
        }
	}
    else
    {
        if (tempBool==0) {
            listData = [[NSMutableDictionary alloc]init];
            tempBool=1;
        }
        
        NSString *urlString =[NSString stringWithFormat:@"%@media/list",ServerIp];
        
        urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        // setting up the request object now
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        
        [request setURL:[NSURL URLWithString:urlString]]; 
        
        
        
        
        NSString *myParameters = [NSString stringWithFormat:@"app_id=%@&user_id=%@&page=%d&method=%@", kAppId, userId, curPage,method];
        NSLog(@"urlString----%@",urlString);
        
        NSLog(@"%@",myParameters);
        
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
        
        // now lets make the connection to the web
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"video list returnString --- %@",returnString);
        
        if (returnString) 
        {
            
            NSError *error;
            
            
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
            
            tempDict = [(NSMutableDictionary*)[XMLReader1  dictionaryForXMLString:returnString error:&error] mutableCopy];
            
            tempDict = [tempDict objectForKey:@"VideoListing"];
            
            
            if (tempDict!=nil)
            {
                
                [listData setObject:tempDict forKey:[NSString stringWithFormat:@"%d",curPage]];
                
                [listData writeToFile: savePath atomically: YES];
                
            }
            else
            {
                [listData removeAllObjects];
            }
            
        }
        
        [returnString release];
    }
}

//-(void)hideIndicator
//{
//    CustomViewController *mmsView = [[CustomViewController alloc] init];
//    
//    [self.window addSubview:mmsView.view];
//}

-(void)LoadView
{
    [magz_btn setColorAtRect:CGRectMake(magz_btn.center.x-((20.0/320)*screenWidth1)-magz_btn.frame.origin.x, -1, ((40.0/320)*screenWidth1), 4) color:[UIColor yellowColor]];
    [magz_btn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    [gam_btn1 setColorAtRect:CGRectMake(5, -1, 40, 4) color:[UIColor clearColor]];
    [gam_btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    previousTab = 1;
}

-(void)loadMassWave
{
    // Override point for customization after application launch.
    //if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    //self.viewController = [[mmsvViewController alloc] initWithNibName:@"mmsvViewController_iPhone" bundle:nil];
//    } else {
//        self.viewController = [[mmsvViewController alloc] initWithNibName:@"mmsvViewController_iPad" bundle:nil];
//    }
    
    //self.window.rootViewController = self.viewController;
   // [self.window makeKeyAndVisible];
    
    [self hideTabBar:self.tabBarController];
    
    [tabCoverView setHidden:YES];
  
}

- (void) hideTabBar:(UITabBarController *) tabbarcontroller {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
        } 
        else 
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
        }
    }
    
    [UIView commitAnimations];
        
}


-(void)memoryLevel
{
	int mem =0;
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS ) {
        //NSLog(@"Memory in use (in bytes): %u", info.resident_size);
        mem=info.resident_size;
		
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
    }
	vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
	
    if (kernReturn != KERN_SUCCESS)
    {
        return;
    }
	
    double available=(vm_page_size * vmStats.free_count)/1024.0;
	//NSLog(@"###############%@################",[NSString stringWithFormat:@"%.2f Total %.2f Available",mem/1000000.0,available/1024.0]);
	
}

-(void)loadSelectedGameId:(UIButton*)sender
{
   // int selectedGame=sender.tag;
////    [self StartgameInitialization];
    
    [self loadSelectedGame:sender];
}
-(void)ManageTabBar
{
    if (showingTabBar) 
    {
        closeTabBar.center=CGPointMake(screenWidth1-15, screenHeight1-15);
        closeTabBar.hidden=FALSE;
        [self.tabBarController.tabBar setHidden:TRUE];
        tabCoverView.hidden=TRUE;
        self.tabBarController.view.frame=CGRectMake(0, 0, screenWidth1, screenHeight1);//CGPointMake(screenWidth1/2.0, (screenHeight1/2.0)+0);
        [[self.tabBarController.view.subviews objectAtIndex:0] setFrame:CGRectMake(0, 0, screenWidth1, screenHeight1)];
        showingTabBar=FALSE;
        closeTabBar.transform=CGAffineTransformMakeRotation(degreesToRadians(-90));
    }
    else
    {
         closeTabBar.center=CGPointMake(screenWidth1-15, screenHeight1-(15+50));
        [self.tabBarController.tabBar setHidden:FALSE];
        tabCoverView.hidden=FALSE;
        showingTabBar=TRUE;
        closeTabBar.transform=CGAffineTransformMakeRotation(degreesToRadians(90));
    }
}
-(void)showTabBar
{
    closeTabBar.hidden=TRUE;
    [self.tabBarController.tabBar setHidden:FALSE];
    tabCoverView.hidden=FALSE;
    showingTabBar=TRUE;
}
-(void)loadSelectedViewController:(UIButton*)sender
{
    [magz_btn setColorAtRect:CGRectMake(magz_btn.center.x-((20.0/320)*screenWidth1)-magz_btn.frame.origin.x, -1, ((40.0/320)*screenWidth1), 4) color:[UIColor blackColor]];
    [magz_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    int tag=sender.tag-200;
    NSLog(@"tag = %d",tag);
    NSLog(@"previousTab = %d",previousTab);
    if (previousTab==tag) 
    {
        return;
    }
    else
    {
        UIButton *prevBtn=(UIButton*)[tabCoverView viewWithTag:(200+previousTab)];
        [prevBtn setColorAtRect:CGRectMake(0, 0, 0, 0) color:[UIColor clearColor]];
        [prevBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        int x=(sender.center.x-((20.0/320)*screenWidth1))-sender.frame.origin.x;
        int y=-1;
        int w=((40.0/320)*screenWidth1);
        int h=4;
        isVideoPlaying=FALSE;
        switch (tag)
        {
            case 1:
                [self showTabBar];
                [sender setColorAtRect:CGRectMake(x, y, w, h) color:[UIColor yellowColor]];
                [sender setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
//                if (gameController && previousTab==5) {
//                    if (!isFirstTimeGameLoad) {
//                        [gameController myApplicationWillResignActive];
//                    }
//                    
//                }
                
                break;
            case 2:
                [self showTabBar];
                [sender setColorAtRect:CGRectMake(x, y, w, h) color:[UIColor blueColor]];
                [sender setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//                if (gameController&& previousTab==5) {
//                    if (!isFirstTimeGameLoad) {
//                        [gameController myApplicationWillResignActive];
//                    }                    
//                }
                break;
            case 3:
                [self showTabBar];
                [sender setColorAtRect:CGRectMake(x, y, w, h) color:[UIColor redColor]];
                [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//                if (gameController&& previousTab==5) {
//                    if (!isFirstTimeGameLoad) {
//                        [gameController myApplicationWillResignActive];
//                    }                   
//                }
                break;
            case 4:
                 NSLog(@"hit url1");
                NSData *urlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@%@",self.strURL,@"info.php" ] ]];
                
                
                if(urlData == nil)
                {
                    self.strCatList = [prefs objectForKey:@"configString"];
                }
                else {
                    /*NSString *arr=[prefs objectForKey:@"configString"];
                    if (self.strCatList) {
                        [self.strCatList release];
                        self.strCatList=nil;
                    }
                    self.strCatList = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
                    if (arr) {
                        for (NSString *str in [self.strCatList componentsSeparatedByString:strRowDelimeter]) {
                            if ([[str componentsSeparatedByString:@"$$"] count]>=5) {
                                for (NSString *str1 in [arr componentsSeparatedByString:strRowDelimeter]) {
                                    if ([[str1 componentsSeparatedByString:@"$$"] count]>=5) {
                                        if ([[[str componentsSeparatedByString:@"$$"] objectAtIndex:0] isEqualToString:[[str1 componentsSeparatedByString:@"$$"] objectAtIndex:0]]) {
                                            if (![[[str componentsSeparatedByString:@"$$"] objectAtIndex:5] isEqualToString:[[str1 componentsSeparatedByString:@"$$"] objectAtIndex:5]]) {
                                                if(screenHeight1==1024)
                                                    [self removeImageFromDocFolder:[[NSString stringWithFormat:@"%@_Ipad_%@",[[str componentsSeparatedByString:@"$$"] objectAtIndex:0],self.strThumbImgName]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                                                else {
                                                    [self removeImageFromDocFolder:[[NSString stringWithFormat:@"%@_Iphone_%@",[[str componentsSeparatedByString:@"$$"] objectAtIndex:0],self.strThumbImgName]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                                                }
                                                break;
                                            }
                                        }
                                    }
                                    
                                }
                                
                            }
                            
                        }
                    }
                    
                    [prefs setObject:self.strCatList forKey:@"configString"];*/
                    if (self.strCatList) {
                        [self.strCatList release];
                        self.strCatList=nil;
                    }
                    self.strCatList = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
                    [prefs setObject:self.strCatList forKey:@"configString"];
                    
                }
                [prefs synchronize];
//                if (!arrCatList) {
//                    [arrCatList release];
//                    arrCatList=nil;
//                }
               
                arrCatList =[[self.strCatList componentsSeparatedByString:strRowDelimeter] mutableCopy];
                
                
                for(int i=0;i<[arrCatList count];i++)
                {
                    NSString *temp = [arrCatList objectAtIndex:i];
                    NSString *trim= [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    [arrCatList replaceObjectAtIndex:i withObject:trim];
                    
                    
                }
                [urlData release];
                for (UITableView *atable in bgVC.view.subviews) {
                    if ([atable isKindOfClass:[UITableView class]]) {
                        [atable reloadData];
                    }
                }
                [self showTabBar];
                [sender setColorAtRect:CGRectMake(x, y, w, h) color:[UIColor greenColor]];
                [sender setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//                if (gameController&& previousTab==5) {
//                    if (!isFirstTimeGameLoad) {
//                        [gameController myApplicationWillResignActive];
//                    }
//                }
                break;
            case 5:
                if (!gameController) {
                    NSLog(@"realease game controller");
                    gameController=[[TBONEViewController alloc] init];
                    gameController.title = @"Games";
                    UIImage* img = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"videos_icon.png"]] ];
                    gameController.tabBarItem.image = img;
                    //tabBarController.selectedViewController=gameController;
                    self.tabBarController.viewControllers = [NSArray arrayWithObjects: [self.tabBarController.viewControllers objectAtIndex:0],[self.tabBarController.viewControllers objectAtIndex:1],[self.tabBarController.viewControllers objectAtIndex:2],[self.tabBarController.viewControllers objectAtIndex:3],gameController,[self.tabBarController.viewControllers objectAtIndex:5], nil];
                    //[tabBarController.viewControllers objectAtIndex:4]=gameController;
                    [self ManageTabBar];
                    [self ManageTabBar];
                    [sender setColorAtRect:CGRectMake(x, y, w, h) color:[UIColor orangeColor]];
                    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                    [gameController StartgameInitialization];
                    [gameController initializeWithView:gameController.view];                    
                    //[gameController myApplicationDidBecomeActive];
                }
                else{
                    [self ManageTabBar];
                    [self ManageTabBar];
                    [sender setColorAtRect:CGRectMake(x, y, w, h) color:[UIColor orangeColor]];
                    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                    
//                    if (isFirstTimeGameLoad) {
//                        NSLog(@"Game is intialized here--------------------------------------++++++++++++++++");
//                        [gameController StartgameInitialization];
//                        [gameController initializeWithView:gameController.view];
//                    }
//                    
//                    [gameController myApplicationDidBecomeActive];
                }
                
                break;
            case 6:
                [self showTabBar];
                
                NSLog(@"int = %d,%d,%d,%d",x, y, w, h);
                [sender setColorAtRect:CGRectMake(x, y, w, h) color:[UIColor purpleColor]];
                [sender setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
//                if (gameController&& previousTab==5) {
//                    if (!isFirstTimeGameLoad) {
//                        [gameController myApplicationWillResignActive];
//                    }
//                }
                [self loadMassWave];
                break;
            default:
                break;
        }
    }
    
    self.tabBarController.selectedIndex = tag-1;
    previousTab=tag;
}

- (void)tabBarController:(UITabBarController *)tabBarController1 didSelectViewController:(UIViewController *)viewController 
{
    if (tabBarController1.selectedIndex==1) {
       
        viewController1.slideshowTimer=nil;
        viewController1.slideshowTimer=[NSTimer scheduledTimerWithTimeInterval:slideShowTime target:viewController1 selector:@selector(slideShow) userInfo:nil repeats:YES];
    }
//	if (dashB==nil)
//		[dashB release];
//	if (viewController1==nil)
//		[viewController1 release];
////	if (videoVC==nil)
////		[videoVC release];
//	if (storeVC==nil)
//		[bgVC release];
//	if (storeVC==nil)
//		[bgVC release];
//	if (sett_ViewCont==nil)
//		[sett_ViewCont release];
//	if (tabBarController!=nil)
//	{
//		if (tabBarController.selectedIndex!=3)
//		{
//			[videoview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
//		}
//		else {
//			if (VappFirstTime==TRUE)
//			{
//				VappFirstTime=FALSE;
//				[self.videoVC performSelector:@selector(firstVideo)];
//			}
//			else {
//				[videoview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.videoVC.videoURL]]];
//			}
//
//		}
//
//	}
//	if(tabBarController1.selectedViewController==shopVC)
//	{
//		 [videoview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
//		[self performSelector:@selector(startShop)];
//	}
//	if(tabBarController1.selectedViewController==storeVC)
//	{
//		 [videoview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
//		[self performSelector:@selector(startComic)];
//	}
//	if(tabBarController1.selectedViewController==dashB)
//	{
//		 [videoview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
//	}
//	if(tabBarController1.selectedViewController==viewController1)
//	{
//		 [videoview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
//	}
//	if(tabBarController1.selectedViewController==videoVC)
//	{
//		[videoview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
//		
//		[videoVC performSelector:@selector(firstVideo)];
//		[appdelegate.videoVC.view setHidden:FALSE];
//	}
//	if(tabBarController1.selectedViewController==bgVC)
//	{
//		 [videoview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
//	}
//	if(tabBarController1.selectedViewController==sett_ViewCont)
//	{
//		 [videoview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
//	}
	
}




#pragma Network Check

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

-(void) startShop {
	if (![self isDataSourceAvailable])
	{
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:@"Network Connection Error" 
							  message:@"You need to be connected to the internet to use this feature." 
							  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		alert.delegate=self;
		[alert show];
		[alert release];
	} 
	else {
		
		//shopVC=[[StoreViewController alloc] init];
		
	}
}

-(void) startComic {
	if (![self isDataSourceAvailable])
	{
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:@"Network Connection Error" 
							  message:@"You need to be connected to the internet to use this feature." 
							  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		alert.delegate=self;
		[alert show];
		[alert release];
		return;
	} 
	else {
		
		//storeVC=[[Videos alloc] init];
		
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{ 
	
	switch(buttonIndex) 
	{
		case 0:
		{
	
			return;
		}break;
		
		default:
			break;
	}
}

#pragma End

-(void)LoadAllBooksDateSortXml
{
	NSString *allBooksUrl =[NSString stringWithFormat:@"%@/api/read?action=allbooks&authKey=%@&sortBy=name&sortOrder=asc",serverIP,loginAuthKey];
	allBooksUrl=[allBooksUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL *url = [[NSURL alloc] initWithString:allBooksUrl];
	NSData *data = [[NSData alloc]initWithContentsOfURL:url];
	NSLog(@"Loding all books data %@",allBooksUrl);
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	dataFilePath = [documentsDirectory stringByAppendingPathComponent:@"storeDate.xml"];
	if (data==nil) 
	{
		if ([self checkFileExist:@"storeDate.xml"]) 
		{
			data = [NSData dataWithContentsOfFile:dataFilePath];
		}
		else 
		{
			NoWifiConnection =TRUE;
			data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"storeDate" ofType:@"xml"]];
		}
	}
	[data writeToFile:dataFilePath atomically:YES];
	[data release];
	//[dataFilePath release];
    [url release];
}

-(void)LoadAllBooksData :(BOOL)loadDateXml
{
NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	//http://122.183.249.154/wizardworld/api/read?action=allbooks&authKey=%28null%29&sortBy=name&sortOrder=asc
	//http://122.183.249.152/wizardworld/api/read?action=allbooks&authKey=%28null%29&sortBy=name&sortOrder=asc
	NSString *allBooksUrl ;
		 NSString *xmlName ;
	if (loadDateXml ==FALSE) 
	{
 		allBooksUrl = [[NSString alloc] initWithFormat:@"%@/api/read?action=allbooks&authKey=%@&sortBy=name&sortOrder=asc",serverIP,loginAuthKey];
		xmlName = @"store";
	}
	else 
	{
		xmlName = @"storeDate";
		allBooksUrl = [[NSString alloc] initWithFormat:@"%@/api/read?action=allbooks&authKey=%@&sortBy=date&sortOrder=desc",serverIP,loginAuthKey];
	}
	NSLog(@"All books URL===>%@",allBooksUrl);
	allBooksUrl=[allBooksUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

	NSURL *url = [[NSURL alloc] initWithString:allBooksUrl];
	//data=nil;
	NSData *data = [NSData dataWithContentsOfURL:url];
	[allBooksUrl release];
	
	//NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    storeXmlParser = [[StoreXMLParser alloc]initXMLParser];
	[xmlParser setDelegate:storeXmlParser];
	BOOL success = [xmlParser parse];
	[xmlParser release];
	xmlParser=nil;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	dataFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.xml",xmlName]] ;
	
	if(!success)
	{

		data = [[NSData alloc]initWithContentsOfFile:dataFilePath];
		if (data==nil) 
		{
			NoWifiConnection =TRUE;
			data = [[NSData alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:xmlName ofType:@"xml"]];
			
		}
		
		xmlParser = [[NSXMLParser alloc] initWithData:data];
		
		[storeXmlParser release];
		storeXmlParser = nil;
		storeXmlParser = [[StoreXMLParser alloc]initXMLParser];
		
		[xmlParser setDelegate:storeXmlParser];
		success = [xmlParser parse];
		[xmlParser release];
		xmlParser=nil;
		[data release];
	}
	else
	{
		NSLog(@"XML write file==>%@",dataFilePath);
		[data writeToFile:dataFilePath atomically:YES];
		NSLog(@"XML write data==>%@",data);
	}
	[xmlParser release];
	[storeXmlParser release];
	if(success)
	{
		[NSThread detachNewThreadSelector:@selector(DownloadThread:) toTarget:self withObject:nil];	
	}
	else
	{
		
		NSLog(@"Error Error Error!!!");
	}
	[url release];
[pool drain];
}


-(void)DownloadThread:(NSString *)indx
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init] ; 
	
	
	self.downloadCount = 1;
	for (int i =0; i<[self.bookListArray count]; i++) 
	{
		int index = [indx intValue];
		BookDetails* bkDetailOBJ = [self.bookListArray objectAtIndex:index];
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *docDirectory = [paths objectAtIndex:0];
		NSString *dataFilePath = docDirectory;
		
		
		NSString *myurl = bkDetailOBJ.CatalogImage;
		NSString *ISBNNumber = [NSString stringWithFormat:@"%@",bkDetailOBJ.ISBNNumber];
		NSLog(@"********* Book url %@ the isbn number %@",myurl,ISBNNumber);
		if (myurl!=nil) 
		{
			NSString *imageName = [myurl lastPathComponent];
			NSString *fileName  = [NSString stringWithFormat:@"/%@",imageName];
			if(![self checkFileExist:fileName])
			{
				NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:myurl]];
				UIImage *img = [UIImage imageWithData:imageData];
				if (img==nil) 
				{
					NSLog(@"No Image");
					//img = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"no_image1.png"]] ];
				}
				[self saveImage :img withName:[dataFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",imageName]]];
				self.downloadCount ++;
				@try 
				{
					//For Store View
					UIView *contentView= [storeVC.scrollview viewWithTag:index+1];
					UIImageView *coverImgView = (UIImageView *) [contentView viewWithTag:9999];
					coverImgView.image = img;
				}
				@catch (NSException * e) 
				{
				}
				NSLog(@"Image Added %d",index+1);
				//[img release];
				[imageData release];
			}
			//[fileName release];
		}
		
		
		
		/// featured Image Download Start
		myurl = bkDetailOBJ.PopupImage ;
		ISBNNumber = @"";
		if (myurl!=nil) 
		{
			NSString *imageName = [myurl lastPathComponent];
			NSString * fileName  = [NSString stringWithFormat:@"/%@",imageName];
			if(![self checkFileExist:fileName])
			{
				NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:myurl]];
				UIImage *img = [UIImage imageWithData:imageData];
				if (img==nil) 
				{
					NSLog(@"No Image");
					//img = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"no_image1.png"]] ];
				}
				
				[self saveImage :img withName:[dataFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",imageName]]];
				//[fileName release];
				//[img release];
				[imageData release];
			}
		}
		
		
	}
	
	
	
	NSLog(@"Image Added %d",index+1);
	
	[pool drain]; 
	
}

-(void)LoadURL
{
    NSString *URLString;
    NSURLConnection *URLConnection;
    
    URLString = [NSString stringWithFormat:@"%@",ITUNESLINK];
    
    NSLog(@"%@",URLString);
    responseData = [[NSMutableData data] retain];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    URLConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"%@",[error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSString *ResponseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:ResponseString forKey:@"Itunes_Link"];
	[defaults synchronize];
    
    NSLog(@"ResponseString = %@",ResponseString);
    
    [ResponseString release];
}

-(BOOL) checkFileExist:(NSString*)filename
{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	dataFilePath = [documentsDirectory stringByAppendingPathComponent:filename] ;
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataFilePath];
	return fileExists;
}
 
-(void)saveImage:(UIImage *)image withName:(NSString *)name {
	
	NSLog(@"saveImage aqpp Delegate");
	@try {
		NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];//1.0f = 100% quality
		[data2 writeToFile:name atomically:YES];
	}
	@catch (NSException * e) {
		NSLog(@"saveImage Exception");
	}
	
}



-(void)GotoSignInPage
{
	tabBarController.selectedIndex = 2;
	tabBarController.selectedViewController = splitViewController;
}




-(void)EpubStore_database:(NSString *)dbname
{
    // First, test for existence............
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:dbname];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (!success)
	{
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbname];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
		if (!success) {
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
		}
	}
}
- (void)applicationWillResignActive:(UIApplication *)application {
    if (gameController) {
        if(!isFirstTimeGameLoad)
        [gameController myApplicationWillResignActive];
    }
    
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"Application enter background");
    if (gameController) {
        if(!isFirstTimeGameLoad)
        [gameController myApplicationDidEnterBackground];
    }
    
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
       NSLog(@"Application enter foreground");
    if (gameController) {
        if(!isFirstTimeGameLoad)
        [gameController myApplicationWillResignActive];
    }
    
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (gameController) {
        if(!isFirstTimeGameLoad)
        [gameController myApplicationDidBecomeActive];
    }
    
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	
		
}


#pragma mark -
#pragma mark Webview for Videos
/*
- (void)loadWebUIViewWithYoutubeLink {
    videoview.delegate = self;
    NSString *htmlString = [NSString stringWithFormat:[NSString
													   stringWithContentsOfFile:[[NSBundle mainBundle]
																				 pathForResource:@"YouTubeTemplate" ofType:@"txt"]],
							@"b85hn8rJvgw",  @"b85hn8rJvgw", nil];
    [videoview loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://youtube.com"]];
}

- (UIButton *)findButtonInView:(UIView *)view {
    UIButton *button = nil;
	
    if ([view isMemberOfClass:[UIButton class]]) {
        return (UIButton *)view;
    }
	
    if (view.subviews && [view.subviews count] > 0) {
        for (UIView *subview in view.subviews) {
            button = [self findButtonInView:subview];
            if (button) return button;
        }
    }
	
    return button;
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    UIButton *b = [self findButtonInView:_webView];
    [b sendActionsForControlEvents:UIControlEventTouchUpInside];
}


*/

#pragma mark -
#pragma mark Push Notifications
// mess alert
/*
 2	 * ------------------------------------------------------------------------------------------
 3	 *  BEGIN APNS CODE
 4	 * ------------------------------------------------------------------------------------------
 5	 */
/**
 8	 * Fetch and Format Device Token and Register Important Information to Remote Server
 9	 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken 
{
	
	
#if !TARGET_IPHONE_SIMULATOR
	
	// Get Bundle Info for Remote Registration (handy if you have more than one app)
	
	// Check what Notifications the user has turned on.  We registered for all three, but they may have manually disabled some or all of them.
	//NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
	NSInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
	NSLog(@"enabledRemoteNotificationTypes %i",rntypes);
	// Set the defaults to disabled unless we find otherwise...
	NSString *pushBadge = @"disabled";
	NSString *pushAlert = @"disabled";
	NSString *pushSound = @"disabled";
	
	// Check what Registered Types are turned on. This is a bit tricky since if two are enabled, and one is off, it will return a number 2... not telling you which
	// one is actually disabled. So we are literally checking to see if rnTypes matches what is turned on, instead of by number. The "tricky" part is that the
	// single notification types will only match if they are the ONLY one enabled.  Likewise, when we are checking for a pair of notifications, it will only be
	// true if those two notifications are on.  This is why the code is written this way
	
	
	if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound))
	{
		pushBadge = @"enabled";
		pushAlert = @"enabled";
		pushSound = @"enabled";
	}
	else if(rntypes == ( UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound))
	{
		pushAlert = @"enabled";
		pushSound = @"enabled";
	}
	else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound))
	{
		pushBadge = @"enabled";
		pushSound = @"enabled";
	}
	else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert))
	{
		pushBadge = @"enabled";
		pushAlert = @"enabled";
	}
	else if(rntypes == UIRemoteNotificationTypeBadge)
	{
		pushBadge = @"enabled";
	}
	else if(rntypes == UIRemoteNotificationTypeAlert)
	{
		pushAlert = @"enabled";
	}
	else if(rntypes == UIRemoteNotificationTypeSound)
	{
		pushSound = @"enabled";
	}
	
	// Get the users Device Model, Display Name, Unique ID, Token & Version Number
	
	// Prepare the Device Token for Registration (remove spaces and < >)
	
	self.deviceToken = [[[[devToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""]
						stringByReplacingOccurrencesOfString: @" " withString: @""];
	
	//if (ISPushNotification==YES)
	//{
		[self sendingDetailsToServer];
	//}
	
	
	self.Uid = [(NSString *)[UIDevice currentDevice]uniqueIdentifier];
	
	NSLog(@"Device token karpaga===>%@",self.deviceToken);
	
/*	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.deviceToken message:self.Uid delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
	[alert show];
	[alert release];*/
	
	
#endif
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	NSLog(@"Error description is %@",[error description]);
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Push Notification Error" message:[NSString stringWithFormat:@"%@",[error description]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	
	pnFailed = NO;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo 
{
    if (ISPushNotification==YES){
#if !TARGET_IPHONE_SIMULATOR
        
        NSLog(@"remote notification: %@",[userInfo description]);
        NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
        
        //NSLog(@"Received Push Alert: %@", alert);
        
        NSString *sound = [apsInfo objectForKey:@"sound"];
        NSLog(@"Received Push Sound: %@", sound);
        //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        NSString *badge = [apsInfo objectForKey:@"badge"];
        NSLog(@"Received Push Badge: %@", badge);
        appBadge=badge;
        
        NSString *alertMsg = [apsInfo objectForKey:@"alert"];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"MaximBoard Notification" message:[NSString stringWithFormat:@"%@",alertMsg] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
		
#endif

    }
}
#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Overriden to allow any orientation.
	return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
	//return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) ;

}
- (void)applicationWillTerminate:(UIApplication *)application 
{
    [gameController myApplicationWillTerminate];
    // Save data if appropriate....................................
	NSUserDefaults *DownloadingDetails = [NSUserDefaults standardUserDefaults];
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:Arr_DownloadingBooks];
	[DownloadingDetails setObject:data forKey:@"DownloadingBooks"];
    
    NSCache *cache = [[NSCache alloc] init];
    [cache removeAllObjects];
   
}
-(void) loginFB//:(id)sender
{
//	[window addSubview:fbVar.view];
//	[fbVar loginFB];
//	UIButton *btn = (UIButton *)sender;
//	[btn setHidden:TRUE];
	
	NSLog(@"Login Btn Pressed");
    NSString *appId = @"203683792989682";//8fa673a06891cac667e55d690e27ecbb";
    NSString *permissions = @"";//publish_stream";
    
    if (_loginDialog == nil) {
        self.loginDialog = [[[FBFunLoginDialog alloc] initWithAppId:appId requestedPermissions:permissions delegate:self] autorelease];
        self.loginDialogView = _loginDialog.view;
    }
    
    if (_loginState == LoginStateStartup || _loginState == LoginStateLoggedOut) {
        _loginState = LoginStateLoggingIn;
        [_loginDialog login];
    } else if (_loginState == LoginStateLoggedIn) {
        _loginState = LoginStateLoggedOut;        
        [_loginDialog logout];
    }
    
    [self refresh];
//		UIButton *btn = (UIButton *)sender;
//		[btn setHidden:TRUE];
	

}

-(void) loginTwitter//:(id)sender
{
	if (_engine) return;
	_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
	_engine.consumerKey = kOAuthConsumerKey;
	_engine.consumerSecret = kOAuthConsumerSecret;
	
	UIViewController	*controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
	
	if (controller) 
		[tabBarController presentModalViewController: controller animated: YES];
	else {
		[_engine sendUpdate: [NSString stringWithFormat: @"The new issue of #MaximBoard Digital is out! Download it for free on your mobile device or read it online at www.maximgirls.com"]];
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"Tweet updated successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}	
}


//Mail
-(void) sendMail//:(id)sender
{
	MFMailComposeViewController *mailController = [[[MFMailComposeViewController alloc] init] autorelease];
	if (mailController!=nil)
	{
		mailController.mailComposeDelegate = self;
		[mailController setSubject:@"The new issue of Wizard World Digital has arrived"];
	//	NSString *emailBody = @"The new issue of Wizard World Digital has arrived. Be sure to check it out \
		and download the free Ipad Application here http://ow.ly/4oQsJ - You can \
		also read it for free online at www.wizardworlddigital.com";                         

		/*NSString *emailBody = @"<p>The new issue of Wizard World Digital has arrived. Be sure to check it out \
		and download the free Ipad Application here http://ow.ly/4oQsJ - You can \
		also read it for free online at www.wizardworlddigital.com</p> \
		<ul> \
		<li class=\"sociablefirst\"><a rel=\"nofollow\" target=\"_blank\" href=\"mailto:?subject=The new issue of Wizard World Digital has arrived%20&amp;body=<p>The new issue of Wizard World Digital has arrived. Be sure to check it out \
		and download the free Ipad Application here http://ow.ly/4oQsJ - You can \
		also read it for free online at www.wizardworlddigital.com</p> \" title=\"email\"><img src=\"http://blogs.business.com/b2b-online-marketing/wp-content/plugins/sociable/images/services-sprite.gif\" title=\"email\" alt=\"email\" style=\"width: 16px; height: 16px; background: url(&quot;http://blogs.business.com/b2b-online-marketing/wp-content/plugins/sociable/images/services-sprite.png&quot;) no-repeat scroll -325px -1px transparent;\" class=\"sociable-hovers\"></a></li> \
		<li><a rel=\"nofollow\" target=\"_blank\" href=\"http://twitter.com/home?status=The new issue of #WizardWorld Digital is out! Download it for free on your mobile device or read it online at www.wizardworlddigital.com\" title=\"Twitter\"><img src=\"http://blogs.business.com/b2b-online-marketing/wp-content/plugins/sociable/images/services-sprite.gif\" title=\"Twitter\" alt=\"Twitter\" style=\"width: 16px; height: 16px; background: url(&quot;http://blogs.business.com/b2b-online-marketing/wp-content/plugins/sociable/images/services-sprite.png&quot;) no-repeat scroll -343px -55px transparent;\" class=\"sociable-hovers\"></a></li> \
		<li><a rel=\"nofollow\" target=\"_blank\" href=\"http://www.facebook.com/wizardworld\" title=\"Facebook\"><img src=\"http://blogs.business.com/b2b-online-marketing/wp-content/plugins/sociable/images/services-sprite.gif\" title=\"Facebook\" alt=\"Facebook\" style=\"width: 16px; height: 16px; background: url(&quot;http://blogs.business.com/b2b-online-marketing/wp-content/plugins/sociable/images/services-sprite.png&quot;) no-repeat scroll -343px -1px transparent;\" class=\"sociable-hovers\"></a></li> \
		</ul>";*/
		
		NSString *allBooksUrl ;
		allBooksUrl = [NSString stringWithFormat:@"%@/api/read?action=getemail",serverIP];
		NSLog(@"Mail URL==>%@",allBooksUrl);
		
		//allBooksUrl = [[NSString alloc] initWithFormat:@"%@/api/read?action=allbooks&authKey=%@&sortBy=name&sortOrder=asc",serverIP,loginAuthKey];
		NSError *error;
		NSURLResponse *response;
		NSData *dataReply;
		NSString *stringReply;
		
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: 
										[NSURL URLWithString:allBooksUrl]];
		[request setHTTPMethod: @"GET"];
		dataReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		stringReply = [NSString stringWithData:dataReply encoding:NSUTF8StringEncoding];
		NSLog(@"Mail content==>%@",stringReply);
		[mailController setMessageBody:stringReply isHTML:YES];
		[tabBarController presentModalViewController:mailController animated:YES];
//		[mailController release];
	}
}
//Wizard world logo click
//Mail
-(void) gotoURL:(id)sender
{
}


- (void)mailComposeController:(MFMailComposeViewController*)mailController didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[mailController becomeFirstResponder];
	[mailController dismissModalViewControllerAnimated:YES];
}


// *********************************************************************************** //
// ****************          Sending Device token to the server               ******** //
//************************************************************************************* //

-(void)sendingDetailsToServer
{
	NSString *allBooksUrl ;
	//allBooksUrl = [[NSString alloc] stringWithFormat:@"%@/api/read?action=notifyinfo&devicetoken=%@&message=New book available&badge=&status=1",serverIP,self.deviceToken];
	if (ISPushNotification==YES)
	{
		allBooksUrl = [NSString stringWithFormat:@"%@api/read?action=notifyinfo&devicetoken=%@&status=1"/*&message=New book available&badge=1*/,self.strURL,deviceToken];
	}
	else {
		allBooksUrl = [NSString stringWithFormat:@"%@api/read?action=notifyinfo&devicetoken=%@&status=0"/*&message=New book available&badge=1*/,self.strURL,deviceToken];
	}
    NSLog(@"fghjufghjy hjfghj fghfghj");
	NSLog(@"%@ %@",self.strURL,allBooksUrl);
	allBooksUrl = [allBooksUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

	//allBooksUrl = [[NSString alloc] initWithFormat:@"%@/api/read?action=allbooks&authKey=%@&sortBy=name&sortOrder=asc",serverIP,loginAuthKey];
	NSError *error;
	NSURLResponse *response;
	NSData *dataReply;
	NSString *stringReply;
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: 
									[NSURL URLWithString:allBooksUrl]];
	[request setHTTPMethod: @"GET"];
	dataReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	//stringReply = [NSString stringWithData:dataReply encoding:NSUTF8StringEncoding];
	//NSLog(@"Device reply string is ===>%@",stringReply);
	
}

- (void)refresh {
    if (_loginState == LoginStateStartup || _loginState == LoginStateLoggedOut) {
        NSLog(@"Not connected to Facebook");
    } else if (_loginState == LoginStateLoggingIn) {
        NSLog(@"Connecting to Facebook");
    } else if (_loginState == LoginStateLoggedIn) {
        NSLog(@"connected to Facebook");
    }   
}

#pragma mark FBFunLoginDialogDelegate

- (void)accessTokenFound:(NSString *)accessToken {
    NSLog(@"Access token found: %@", accessToken);
    self.accessToken = accessToken;
    _loginState = LoginStateLoggedIn;
    [self.loginDialog dismissModalViewControllerAnimated:YES];    
    [self showLinkBtn];
    [self refresh];
}

- (void)displayRequired {
    [tabBarController presentModalViewController:_loginDialog animated:YES];
}

- (void)closeTapped {
    [self.loginDialog dismissModalViewControllerAnimated:YES];
    _loginState = LoginStateLoggedOut;     
//    [self showLinkBtn];	
//    [_loginDialog logout];
    [self refresh];
}


-(void) showLinkBtn
{
//	NSString *html = @"<iframe src=\" \
//	http://www.facebook.com/plugins/like.php?href=http%3A%2F%2Fwww.facebook.com%2Fwizardworld&layout=button_count&show_faces=true&width=450&action=like&font&colorscheme=light&height=21<http://www.facebook.com/plugins/like.php?href=http%3A%2F%2Fwww.facebook.com%2Fwizardworld&layout=button_count&show_faces=true&width=450&action=like&font&colorscheme=light&height=21>\" \
//	scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; \
//	width:450px; height:21px;\" allowTransparency=\"true\"></iframe>"; 				
//	
//	UIWebView *bookWebBtn = [[UIWebView alloc] initWithFrame:CGRectMake(570, 982, 95, 30)];
//	[bookWebBtn loadHTMLString:html baseURL:[NSURL URLWithString:@"http://www.facebook.com"]];
//	[bookWebBtn setBackgroundColor:[UIColor clearColor]];
//	[bookWebBtn setOpaque:NO];
//	[tabBarController.view addSubview:bookWebBtn];
//	[bookWebBtn release];
//	
////	[self performSelector:@selector(hideFBControls) withObject:nil afterDelay:2.0]; 
//	
//	NSTimer *fbTimer= [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hideFBControls) userInfo:nil repeats:NO];	
}

- (void)hideFBControls
{
	NSLog(@"Web view called");
	UIButton *btn = (UIButton *)[tabBarController.view viewWithTag:1001];
	[btn setHidden:TRUE];
}
#pragma mark Memory management

- (void)dealloc
{
	//Twitter
	[_engine release];
	//Twitter
	self.loginDialog = nil;
	self.loginDialogView = nil;
    self.accessToken = nil;
	
	[slideToCancel release];
	[Uid release];
	[storeVC release];
	[shopVC release];
	[deviceToken release];
	[Arr_DownloadingBooks release];
    [splitViewController release];
	[tabBarController release];
    [window release];
	//[viewController release];
    [super dealloc];
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	NSLog(@"Authenicated for %@", username);
	[_engine sendUpdate: [NSString stringWithFormat: @"The new issue of #MaximBoard Digital is out! Download it for free on your mobile device or read it online at www.maximgirls.com"]];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"Tweet updated successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	[_engine release];
	_engine=nil;
	NSLog(@"Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	[_engine release];
	_engine=nil;
	NSLog(@"Authentication Canceled.");
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	NSLog(@"Request %@ succeeded", requestIdentifier);
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}


//******************

-(void)imageSaveToDocumentPath:(UIImage *)image :(NSString*)psFileName
{
	NSString *document_path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *string  = [NSString stringWithFormat:@"%@/%@",document_path,psFileName];
    BOOL exists = [self checkFileExist:psFileName];
    if(exists)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:string error:NULL];
    }
	
	[UIImagePNGRepresentation(image) writeToFile:string atomically:YES];
	
}


//-(BOOL) checkFileExist:(NSString*)filename
//{
//	//NSLog(@"checkFileExist");
//	//NSLog(filename);
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//	docFolder = documentsDirectory;
//    NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:filename];
//    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataFilePath];
//	//NSLog(@"filename %@",dataFilePath);
//    return fileExists;
//}
-(UIImage *) removeImageFromDocFolder:(NSString*)pImageName
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	dataFilePath = [documentsDirectory stringByAppendingPathComponent:pImageName];
	UIImage *imgGetStoredImage;
	NSLog(@"image name%@",pImageName);
	BOOL exists = [self checkFileExist:pImageName];
    if(exists)
    {
        NSLog(@"image name%@",dataFilePath);
		NSError *error;
		
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:dataFilePath error:&error];
        if (!success) NSLog(@"Error: %@", [error localizedDescription]);
    }
	else
	{
		//Default image to be placed
		//NSLog(@"getImageFromDoc - %@ Image not found",pImageName);
	}
	
	
	
	return imgGetStoredImage;
}

-(UIImage *) getImageFromDocFolder:(NSString*)pImageName
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	dataFilePath = [documentsDirectory stringByAppendingPathComponent:pImageName];
	UIImage *imgGetStoredImage;
	
	BOOL exists = [self checkFileExist:pImageName];
    if(exists)
    {
		
		NSData *nsdGetImageData = [[NSData alloc]initWithContentsOfFile:dataFilePath];
		imgGetStoredImage =[UIImage imageWithData:nsdGetImageData];
		[nsdGetImageData release];
    }
	else
	{
		//Default image to be placed
		//NSLog(@"getImageFromDoc - %@ Image not found",pImageName);
	}
	
	
	
	return imgGetStoredImage;
}

//##############################clock
void audioRouteChangeListenerCallback (
									   void                      *inUserData,
									   AudioSessionPropertyID    inPropertyID,
									   UInt32                    inPropertyValueSize,
									   const void                *inPropertyValue
									   ) {
	
	// ensure that this callback was invoked for a route change
	if (inPropertyID != kAudioSessionProperty_AudioRouteChange) return;
	
	// This callback, being outside the implementation block, needs a reference to the
	//		MainViewController object, which it receives in the inUserData parameter.
	//		You provide this reference when registering this callback (see the call to 
	//		AudioSessionAddPropertyListener).
	epubstore_svcAppDelegate *controller = (epubstore_svcAppDelegate *) inUserData;
	
	// if application sound is not playing, there's nothing to do, so return.
	if (controller.audioPlayer.playing == 0 ) {
		
		NSLog (@"Audio route change while application audio is stopped.");
		return;
		
	} else {
		
		// Determines the reason for the route change, to ensure that it is not
		//		because of a category change.
		CFDictionaryRef	routeChangeDictionary = inPropertyValue;
		
		CFNumberRef routeChangeReasonRef =
		CFDictionaryGetValue (
							  routeChangeDictionary,
							  CFSTR (kAudioSession_AudioRouteChangeKey_Reason)
							  );
		
		SInt32 routeChangeReason;
		
		CFNumberGetValue (
						  routeChangeReasonRef,
						  kCFNumberSInt32Type,
						  &routeChangeReason
						  );
		
		// "Old device unavailable" indicates that a headset was unplugged, or that the
		//	device was removed from a dock connector that supports audio output. This is
		//	the recommended test for when to pause audio.
		if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {
			
			[controller.audioPlayer pause];
			NSLog (@"Output device removed, so application audio was paused.");
			
			UIAlertView *routeChangeAlertView = 
			[[UIAlertView alloc]	initWithTitle: NSLocalizedString (@"Playback Paused", @"Title for audio hardware route-changed alert view")
									   message: NSLocalizedString (@"Audio output was changed", @"Explanation for route-changed alert view")
									  delegate: controller
							 cancelButtonTitle: NSLocalizedString (@"StopPlaybackAfterRouteChange", @"Stop button title")
							 otherButtonTitles: NSLocalizedString (@"ResumePlaybackAfterRouteChange", @"Play button title"), nil];
			[routeChangeAlertView show];
            [routeChangeAlertView release];
			// release takes place in alertView:clickedButtonAtIndex: method
			
		} else {
			
			NSLog (@"A route change occurred that does not require pausing of application audio.");
		}
	}
}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
	// Handle the notificaton when the app is running
	
	if ([[notif.userInfo objectForKey:@"Download"] isEqualToString:@"Download Book"]) {
		UIApplication *app = [UIApplication sharedApplication];
		
		if (bgTask != UIBackgroundTaskInvalid) {
			[app endBackgroundTask:bgTask]; 
			bgTask = UIBackgroundTaskInvalid;
		}
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:notif.alertBody delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	else {
	

	NSLog(@"****************************Recieved Notification %@",notif);
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *UrlWithIndex = [prefs stringForKey:@"AlarmIndex"];
	ipodSongTitle = [prefs stringForKey:@"ipodSongTitle"];
	
	//NSString *getSnoozeString = [prefs stringForKey:@"snoozeChanged"];
	
	//alarmTimeArray = (NSMutableArray *)[prefs arrayForKey:@"AlarmTimeArray"];
	alarmTimeArray = [self getArray];
	//NSLog(@"UrlWithIndex %@",UrlWithIndex);
	
	
	NSRange end = [UrlWithIndex rangeOfString: @"$$$"];
	NSRange end1 = [UrlWithIndex rangeOfString: @"###"];
	
	int lenght =  [UrlWithIndex length];
	
//	if (end.location !=NSNotFound &&UrlWithIndex !=nil) {
//		lenght = lenght -(end1.location+end1.length);
//		
//		newSection = [[UrlWithIndex substringWithRange: NSMakeRange (0,end.location)]intValue];
//		songIndex= [[UrlWithIndex substringWithRange: NSMakeRange (end.location+end.length,1)]intValue];
//		volumeLevel = [[UrlWithIndex substringWithRange: NSMakeRange (end1.location+end1.length,lenght)]intValue];
//	}
//	else {
//		newSection = 1;
//		songIndex = 0;
//		/////////////////////////////////volumeLevel = 1;
//	}
	//if (newSection == nil) {
	//		newSection =1;
	//		songIndex = 0;
	//	}
//	if (volumeLevel ==0.0) {
//		volumeLevel = 0.3;
//	}
	
	//[[UIApplication sharedApplication] scheduleLocalNotification:notif];
	//newSection = 1;
	UIApplication *thisApp = [UIApplication sharedApplication];
	thisApp.idleTimerDisabled = NO;
	thisApp.idleTimerDisabled = YES;
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
	
	//if([getSnoozeString isEqualToString:@"snoozeForSomeTime"])
	//	{
	//		[snoozeTimer invalidate];
	//		snoozeTimer = nil;
	//		[self startSlidingAndAlarmPlay];
	//	}
	
	
	//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alarm" message:@"Snooze after 2 minutes"
	//												   delegate:self cancelButtonTitle:@"Quit" otherButtonTitles:@"Snooze", nil];
	//	[alert show];
	//	[alert release];
        if(!snoozeTimer){
            [snoozeTimer invalidate];
            snoozeTimer = nil;
        }
	[self startSlidingAndAlarmPlay];
	
        

		
	}
	//[self playAlarm];
}

-(void)cancelSnooze
{
	[musicPlayer stop];
	[audioPlayer stop];
	//[musicPlayer release];
	//[audioPlayer release];
	//audioPlayer=nil;
	//musicPlayer=nil;
	
	//[snoozeTimer invalidate];
	//	snoozeTimer = nil;
	
	slideToCancel.enabled = NO;
	cancenView.userInteractionEnabled = NO;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGPoint sliderCenter = slideToCancel.view.center;
	if(screenHeight1 == 1024)
		sliderCenter.y += 1500;
	else
		sliderCenter.y += slideToCancel.view.bounds.size.height;
	slideToCancel.view.center = sliderCenter;
	
	CGRect sliderFrame = cancenView.frame;
	sliderFrame.origin.y = -390;
	cancenView.frame = sliderFrame;
	[UIView commitAnimations];
	
	
}
- (void) startSlidingAndAlarmPlay {
	// Start the slider animation
	slideToCancel.enabled = YES;
	cancenView.userInteractionEnabled = YES;
	
	//if (snoozeTimer!=nil) {
	//[snoozeTimer invalidate];
	//snoozeTimer = nil;
	//}
	[window addSubview:slideToCancel.view];
	// Slowly move up the slider from the bottom of the screen
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGPoint sliderCenter = slideToCancel.view.center;
	if(screenHeight1 == 1024)
		sliderCenter.y = 924;
	else
		sliderCenter.y = 442;
	slideToCancel.view.center = sliderCenter;
	CGRect sliderFrame = cancenView.frame;
	sliderFrame.origin.y = 0;
	cancenView.frame = sliderFrame;
	[UIView commitAnimations];
	
	
	//if(newSection == 0)
	//{
		//NSLog(@"alarm on");
    
    if ([prefs objectForKey:@"currentSong"]) {
        MPMediaQuery *query = [[MPMediaQuery alloc] init];
		[musicPlayer stop];
		musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
        for (int k=0;k<[allSongs count]; k++) {
			MPMediaItem *playItem = [allSongs objectAtIndex:k];
			NSString *itemURL = [[playItem valueForProperty:MPMediaItemPropertyAssetURL] absoluteString];
			if ([itemURL isEqualToString:[prefs objectForKey:@"currentSong"]]) {
				MPMediaItemCollection *userMediaItemCollection = [MPMediaItemCollection collectionWithItems:[query items]];
				[musicPlayer setQueueWithItemCollection:userMediaItemCollection];
				musicPlayer.nowPlayingItem = playItem;
				musicPlayer.repeatMode = MPMusicRepeatModeOne;
				musicPlayer.volume = 1.0;
				[musicPlayer play];
                [[MPMusicPlayerController applicationMusicPlayer] setVolume:1.0];
                [query release];
				return;
			}
		}
        if ([allSongs count]>0) {
            MPMediaItem *playItem = [allSongs objectAtIndex:0];
            MPMediaItemCollection *userMediaItemCollection = [MPMediaItemCollection collectionWithItems:[query items]];
            [musicPlayer setQueueWithItemCollection:userMediaItemCollection];
            musicPlayer.nowPlayingItem = playItem;
            musicPlayer.repeatMode = MPMusicRepeatModeOne;
            musicPlayer.volume = 1.0;
            [musicPlayer play];
            [[MPMusicPlayerController applicationMusicPlayer] setVolume:1.0];
            [query release];
            return;
        }
        else{
            [query release];
            [self setupApplicationAudio];
            return;
        }
    }
    else{
        [self setupApplicationAudio];
        return;
    }
    
    
		
//    MPMediaQuery *query = [[[MPMediaQuery alloc] init] autorelease];
//    [musicPlayer stop];
//    musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
//		
//		if(songIndex ==0)
//			songIndex =1;
//		BOOL songPresent =FALSE;
//		for (int k=0;k<[allSongs count]; k++) {
//			MPMediaItem *playItem = [allSongs objectAtIndex:k];
//			NSString *itemName = [playItem valueForProperty:MPMediaItemPropertyTitle];
//			if([ipodSongTitle isEqualToString:@""]==TRUE||ipodSongTitle ==nil)
//				ipodSongTitle = itemName;
//			if ([itemName isEqualToString:ipodSongTitle]) {
//				MPMediaItemCollection *userMediaItemCollection = [MPMediaItemCollection collectionWithItems:[query items]];
//				[musicPlayer setQueueWithItemCollection:userMediaItemCollection];
//				musicPlayer.nowPlayingItem = playItem;
//				musicPlayer.repeatMode = MPMusicRepeatModeOne;
//				musicPlayer.volume = volumeLevel;
//				[musicPlayer play];
//				k=[allSongs count];
//				songPresent = TRUE;
//				//return;
//			}
//		}
//		if (!songPresent) {
//			//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"File Missing" message:@"Selected alarm music is deleted from iPod"
//			//																	   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//			//						[alert setTag:5];
//			//						[alert show];
//			//						[alert release];
//		}
//		
//		
//		
//		
//		
//		
//	//}
//	else {
//		/*NSString *urlstring = [[NSBundle mainBundle] pathForResource:[playList objectAtIndex:songIndex ] ofType:@"mp3"];
//		 NSURL *url = [NSURL fileURLWithPath:urlstring];
//		 NSError *error;
//		 [audioPlayer stop];
//		 audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//		 audioPlayer.numberOfLoops = -1;*/
//		
//		//[self setupApplicationAudio];
//		
//		
//		/*if (audioPlayer == nil)
//		 NSLog([error description]);
//		 else
//		 {
//		 audioPlayer.volume = volumeLevel;
//		 [audioPlayer play];*/
//	}
}


//}

- (void) setupApplicationAudio 
{
    NSLog(@"default alarm");
	NSString *urlstring = [[NSBundle mainBundle] pathForResource:@"apple_alarm" ofType:@"mp3"];
	//NSURL *newURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
	//urlstring=[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

	NSURL *url = [NSURL fileURLWithPath:urlstring];
//	
//	[[AVAudioSession sharedInstance] setDelegate: self];
//	[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: nil];
//	
//	AudioSessionAddPropertyListener (
//									 kAudioSessionProperty_AudioRouteChange,
//									 audioRouteChangeListenerCallback,
//									 self
//									 );
//	
//	NSError *activationError = nil;
//	[[AVAudioSession sharedInstance] setActive: YES error: &activationError];
	
	// Instantiates the AVAudioPlayer object, initializing it with the sound
	AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: url error: nil];
    
	if (newPlayer!=nil)
	{
        NSLog(@"Audio play");
		self.audioPlayer = newPlayer;
		[newPlayer release];
		[self setMusicPlayer: [MPMusicPlayerController applicationMusicPlayer]];
		// "Preparing to play" attaches to the audio hardware and ensures that playback
		//		starts quickly when the user taps Play
		[audioPlayer prepareToPlay];
		//[appSoundPlayer setVolume: 1.0];
		audioPlayer.volume = 1.0;
		[audioPlayer play];
        [audioPlayer setNumberOfLoops:-1];
        
		[audioPlayer setDelegate: self];
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:1.0];

	}
    //[url release];
	//playing = YES;
	
}

- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) appSoundPlayer successfully: (BOOL) flag {
	
	playing = NO;
	//[appSoundButton setEnabled: YES];
}

- (void) audioPlayerBeginInterruption: player {
	
	NSLog (@"Interrupted. The system has paused audio playback.");
	
	if (playing) {
		
		playing = NO;
		interruptedOnPlayback = YES;
	}
}

- (void) audioPlayerEndInterruption: player {
	
	NSLog (@"Interruption ended. Resuming audio playback.");
	
	// Reactivates the audio session, whether or not audio was playing
	//		when the interruption arrived.
	[[AVAudioSession sharedInstance] setActive: YES error: nil];
	
	if (interruptedOnPlayback) {
		
		[audioPlayer prepareToPlay];
		[audioPlayer play];
		playing = YES;
		interruptedOnPlayback = NO;
	}
}

- (void) cancelled {
	// Disable the slider and re-enable the button
	[musicPlayer stop];
	[audioPlayer stop];
	//[musicPlayer release];
	//[audioPlayer release];
	//audioPlayer=nil;
	//musicPlayer=nil;

	SnoozeOn = TRUE;
	slideToCancel.enabled = NO;
	cancenView.userInteractionEnabled = NO;
	
	
	snoozeTimer =[NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(startSlidingAndAlarmPlay) userInfo:nil repeats:NO];
	
	
	
	// Slowly move down the slider off the bottom of the screen
	//	[UIView beginAnimations:nil context:nil];
	//	[UIView setAnimationDuration:0.5];
	//	CGPoint sliderCenter = slideToCancel.view.center;
	//	sliderCenter.y += slideToCancel.view.bounds.size.height;
	//	slideToCancel.view.center = sliderCenter;
	//	[UIView commitAnimations];
	
	slideToCancel.enabled = NO;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGPoint sliderCenter = slideToCancel.view.center;
	if(screenHeight1 == 1024)
		sliderCenter.y = 1500;
	else
		sliderCenter.y += slideToCancel.view.bounds.size.height;
	slideToCancel.view.center = sliderCenter;
	
	CGRect sliderFrame = cancenView.frame;
	sliderFrame.origin.y = -390;
	cancenView.frame = sliderFrame;
	[UIView commitAnimations];
	cancenView.userInteractionEnabled = NO;
	
}


//-(void)playAlarm{
//	
//	
//	
//	
//	if(newSection == 0)
//	{
//		//NSLog(@"alarm on");
//		
//		MPMediaQuery *query = [[[MPMediaQuery alloc] init] autorelease];
//		NSMutableArray *mySongs = [[NSMutableArray alloc] initWithArray:[query items] ];
//		[musicPlayer stop];
//		musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
//		
//		if(songIndex ==0)
//			songIndex =1;
//		BOOL songPresent =FALSE;
//		for (int k=0;k<[mySongs count]; k++) {
//			MPMediaItem *playItem = [mySongs objectAtIndex:k];
//			NSString *itemName = [playItem valueForProperty:MPMediaItemPropertyTitle];
//			if([ipodSongTitle isEqualToString:@""]==TRUE||ipodSongTitle ==nil)
//				ipodSongTitle = itemName;
//			if ([itemName isEqualToString:ipodSongTitle]) {
//				MPMediaItemCollection *userMediaItemCollection = [MPMediaItemCollection collectionWithItems:[query items]];
//				[musicPlayer setQueueWithItemCollection:userMediaItemCollection];
//				musicPlayer.nowPlayingItem = playItem;
//				musicPlayer.repeatMode = MPMusicRepeatModeOne;
//				musicPlayer.volume = volumeLevel;
//				[musicPlayer play];
//				k=[mySongs count];
//				songPresent = TRUE;
//				//return;
//			}
//		}
//		if (!songPresent) {
//			//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"File Missing" message:@"Selected alarm music is deleted from iPod"
//			//																	   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//			//						[alert setTag:5];
//			//						[alert show];
//			//						[alert release];
//		}
//		
//		
//		
//		
//		
//		
//	}
//	else {
//		NSString *urlstring = [[NSBundle mainBundle] pathForResource:[playList objectAtIndex:songIndex ] ofType:@"mp3"];
//		NSURL *url = [NSURL fileURLWithPath:urlstring];
//		NSError *error;
//		[audioPlayer stop];
//		audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//		audioPlayer.numberOfLoops = -1;
//		if (audioPlayer == nil)
//			NSLog([error description]);
//		else
//		{
//			audioPlayer.volume = volumeLevel;
//			[audioPlayer play];
//		}
//	}
//	
//	
//	
//}

-(void)showAlert
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alarm" message:@"Snooze after 2 minutes"
												   delegate:self cancelButtonTitle:@".. Quit" otherButtonTitles:@"..Snooze", nil];
	[alert show];
	[alert release];
}



//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex { 
//	if (alertView.tag == 5) {
//		return;
//	}
//	switch(buttonIndex) {
//		case 0:
//			
//			
//			[musicPlayer stop];
//			[audioPlayer stop];
//			break;
//		case 1:
//			[musicPlayer stop];
//			[audioPlayer stop];
//			
//			break;
//		default:
//			break;
//	}
//}
-(void)saveArray:(NSMutableArray *)myArray
{
	NSString *stringToSave =@"";
	for(int k =0;k<[myArray count];k++)
	{
		AlarmSettings *alarmSetting = [myArray objectAtIndex:k];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		//MM/DD/YYYY
		[dateFormatter setDateFormat:@"hh:mm a"];
		//[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"IST"]];
		
		NSString *myDate = [dateFormatter stringFromDate:alarmSetting.alarmFireDate];
		
		NSString *myString = [NSString stringWithFormat:@"%d$$%d$$%@$$",alarmSetting.ID,alarmSetting.repeat,myDate];
		if (![stringToSave isEqualToString:@""]) {
			stringToSave = [NSString stringWithFormat:@"%@%@~~",stringToSave,myString];
		}
		else {
		    stringToSave = [NSString stringWithFormat:@"%@~~",myString];
		}
		
		[dateFormatter release];
        
	}
	
	[prefs setObject:stringToSave forKey:@"AlarmSettings"];
	[prefs synchronize];
	
	
}
-(NSMutableArray *)getArray
{
	
	prefs = [NSUserDefaults standardUserDefaults];
	NSString *fullString = [prefs stringForKey:@"AlarmSettings"];
	//NSLog(@"fullString is: %@", fullString);
	NSArray *myArray = [fullString componentsSeparatedByString:@"~~"];
    if (!alarmTimeArray) {
        alarmTimeArray=[[NSMutableArray alloc]init];
    }
    [alarmTimeArray removeAllObjects];
	//NSMutableArray *mutableArray = [[NSMutableArray alloc]init];
	
	for (int k =0; k<[myArray count];k++) {
		if (k<[myArray count]-1) {
			
			NSString *myString = [myArray objectAtIndex:k];
			NSArray *myArray2 = [myString componentsSeparatedByString:@"$$"];
			AlarmSettings *alarmSettings = [[AlarmSettings alloc]init];
			alarmSettings.ID = [[myArray2 objectAtIndex:0]intValue];
			alarmSettings.repeat = [[myArray2 objectAtIndex:1]intValue];
			
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
			[dateFormatter setDateFormat:@"hh:mm a"];
			NSString *myDateString = [NSString stringWithFormat:@"%@",[myArray2 objectAtIndex:2]];
			alarmSettings.alarmFireDate = [dateFormatter dateFromString:myDateString];
			//NSLog(@"MyDate is: %@", myDate);
			[alarmTimeArray addObject:alarmSettings];
            [dateFormatter release];
            [alarmSettings release];
            
		}
	}
	
	return alarmTimeArray;
}

#pragma mark -
#pragma mark Memory management
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    
    if (tabBarController.selectedIndex!=4) {
        NSLog(@"Game memory Warning+++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
        //[[tabBarController.viewControllers] objectAtIndex:4]=nil;
        [gameController myApplicationDidReceiveMemoryWarning];
        [gameController myApplicationWillResignActive];

        [gameController comeOutOfGame];
        [gameController release];
        gameController=nil;
        isFirstTimeGameLoad=YES;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"We are running out of memory! Please clear up cache and restart your work."
												   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
    
}
@end