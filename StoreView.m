//
//  StoreView.m
//  Alarm
//
//  Created by Zaah Technologies India PVT on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StoreView.h"
#import <StoreKit/StoreKit.h>
#import "epubstore_svcAppDelegate.h"
#import "AlarmsViewController.h"

#define kMinimumGestureLength  25
////#define kMaximumVariance   5

@implementation StoreView

UIView *clockdownloadingOverlayView;
UIView *clockdownloadingOverlayView1;
UIActivityIndicatorView *downloadingIndicator;
NSString *kInAppPurchaseProUpgradeProductId1 =@"pack1";
SKProduct *proUpgradeProduct;
SKProductsRequest *storeproductsRequest;
CGPoint gestureStartPoint;

UIScrollView *scrollImgView;
UIButton *btnToAlarm;
UIImage *img;
int  boughtTheme;
UIImageView *selectThemeImgView;
int screenWidth = 768;
int ipadScreenHeight1 = 1024;
int x=0;
int y=0;
UIView *shopView;
UIWebView *webView;
UIActivityIndicatorView *loadingIndicator;
UIImageView *swipeImgView;
UIImageView *swipeImgView1;
UIImageView *swipeImgView2;
UIImageView *swipeImgView3;

UIImageView *buyNowView;
UIImageView *buyNowView1;
UIImageView *buyNowView2;
UIImageView *imgView;

UIImageView *storeView;
UIImageView *storeView1;
UIImageView *storeView2;
UIImageView *storeView3;

UIImageView *arrowImgView;
UIImageView *arrowImgView1;
UIImageView *arrowImgView2;
UIImageView *arrowImgView3;
UIImageView *arrowImgView4;
UIImageView *arrowImgView5;


UIButton *buyNow;
UIButton *buyNow1;
UIButton *buyNow2;
UIButton *infoBtn;
UIButton *selectTheme;
UIButton *frwdBtn;
UIButton *backwdBtn1;


UIImageView *owendImgView,*owendImgView1;
BOOL frwdBtnClicked;
BOOL backwdBtnClicked;
BOOL isPurchased;
BOOL buyNowEvent;
BOOL buyNowEvent1;
BOOL buyNowEvent2;
BOOL setAction;
int myvalue;
int myValue;

//int scrollValue;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	ratioWidth=screenWidth/[UIScreen mainScreen].bounds.size.width;
	ratioHeight=ipadScreenHeight1/[UIScreen mainScreen].bounds.size.height;
	[self.view setFrame:CGRectMake(0, 0, 768, 900)];
	if (appdelegate.screenHeight1!=1024) {
		[self.view setFrame:CGRectMake(0, 0, 768/ratioWidth, 900/ratioHeight)];
	}
	NSLog(@"viewdidload");
	
	NSLog(@"-->%d",appdelegate.purchaseValue);
	
    [super viewDidLoad];
	appdelegate = (epubstore_svcAppDelegate*)[[UIApplication sharedApplication]delegate];
	//int screenWidth = 768;
//	int ipadScreenHeight1 = 1024;
	frwdBtnClicked = TRUE;
	backwdBtnClicked =TRUE;
	setAction = TRUE;
	
	if(scrollImgView == nil)
	scrollImgView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, ipadScreenHeight1)];
	scrollImgView.contentSize=CGSizeMake(1*768, 0);
	if (appdelegate.screenHeight1!=1024) {
		[scrollImgView setFrame:CGRectMake(0/ratioWidth, 0/ratioHeight, screenWidth/ratioWidth, ipadScreenHeight1/ratioHeight)];
	scrollImgView.contentSize=CGSizeMake(1*320, 0);
	}
	[scrollImgView setBackgroundColor:[UIColor blackColor]];
	scrollImgView.delegate=self;
	[scrollImgView setContentOffset:CGPointMake(0, 0)];
	
	scrollImgView.scrollEnabled=YES;
	[scrollImgView setPagingEnabled:YES];
	scrollImgView.showsHorizontalScrollIndicator=NO;
	
	
	if(x == 0)
	{
		NSLog(@"xvalue %d----",appdelegate.themeValue);
		//if(storeView == nil)
		storeView =[[UIImageView alloc]initWithFrame:CGRectMake(x,y,screenWidth ,ipadScreenHeight1)];
		if (appdelegate.screenHeight1!=1024) {
			[storeView setFrame:CGRectMake(x/ratioWidth, y/ratioWidth, screenWidth/ratioWidth, ipadScreenHeight1/ratioHeight)];
		}
		//else {
//			[storeView removeFromSuperview];
//		}
		img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"store_bg.png" ofType:@""]];
		[storeView setImage:img];
		//[img release];
		[scrollImgView addSubview:storeView];
		[storeView release];
		//x= 320;
		NSLog(@"next");
	}
	
	if(storeView1 == nil)
	storeView1 =[[UIImageView alloc]initWithFrame:CGRectMake(screenWidth,y,screenWidth,ipadScreenHeight1)];
	if (appdelegate.screenHeight1!=1024) {
		[storeView1 setFrame:CGRectMake(0, 0, screenWidth/ratioWidth, ipadScreenHeight1/ratioHeight)];
	}
	img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"store_bg.png" ofType:@""]];
	[storeView1 setImage:img];
	[img release];
	[scrollImgView addSubview:storeView1];
	
	
	if(storeView2 == nil)
	storeView2 =[[UIImageView alloc]initWithFrame:CGRectMake(screenWidth+768,y,screenWidth,ipadScreenHeight1)];
	if (appdelegate.screenHeight1!=1024) {
		[storeView2 setFrame:CGRectMake((screenWidth+768)/screenWidth, y/ipadScreenHeight1, screenWidth/ratioWidth, ipadScreenHeight1/ratioHeight)];
	}
	img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"store_bg.png" ofType:@""]];
	[storeView2 setImage:img];
	[img release];
	//[scrollImgView addSubview:storeView2];
	
	
//	if(arrowImgView == nil)
//	arrowImgView =[[UIImageView alloc]initWithFrame:CGRectMake(680,480,25,27)];
//	if (appdelegate.screenHeight1!=1024) {
//		[arrowImgView setFrame:CGRectMake(680/ratioWidth, 480/ratioHeight, 25/ratioWidth, 27/ratioHeight)];
//	}
//	//[arrowImgView setBackgroundColor:[UIColor ma]];
//	img =[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"track_list_fwd.png" ofType:@""]];
//	[arrowImgView setImage:img];
//	[img release];
//	//[scrollImgView addSubview:arrowImgView];
//	
//	
//	
//	if(arrowImgView1 == nil)
//	arrowImgView1 =[[UIImageView alloc]initWithFrame:CGRectMake(1450,480,25,27)];
//	if (appdelegate.screenHeight1!=1024) {
//		[arrowImgView1 setFrame:CGRectMake(1450/ratioWidth, 480/ratioHeight, 25/ratioWidth, 27/ratioHeight)];
//	}
//	//[arrowImgView1 setBackgroundColor:[UIColor purpleColor]];
//	
//	img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"track_list_fwd.png" ofType:@""]];
//	[arrowImgView1 setImage:img];
//	[img release];
//	//[scrollImgView addSubview:arrowImgView1];
//	
//	
//	
//	
//	//if(arrowImgView2 == nil)
//	arrowImgView2 =[[UIImageView alloc]initWithFrame:CGRectMake(1610,480,25,27)];
//	if (appdelegate.screenHeight1!=1024) {
//		[arrowImgView2 setFrame:CGRectMake(1610/ratioWidth, 480/ratioHeight, 25/ratioWidth, 27/ratioHeight)];
//	}
//	//[arrowImgView2 setBackgroundColor:[UIColor magentaColor]];
//	img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"track_list_back.png" ofType:@""]];
//	[arrowImgView2 setImage:img];
//	[img release];
//	//[scrollImgView addSubview:arrowImgView2];
//	
//	//if(arrowImgView3 == nil)
//	arrowImgView3 =[[UIImageView alloc]initWithFrame:CGRectMake(830,480,25,27)];
//	if (appdelegate.screenHeight1!=1024) {
//		[arrowImgView3 setFrame:CGRectMake(830/ratioWidth, 480/ratioHeight, 25/ratioWidth, 27/ratioHeight)];
//	}
//	//[arrowImgView3 setBackgroundColor:[UIColor redColor]];
//	img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"track_list_back.png" ofType:@""]];
//	[arrowImgView3 setImage:img];
//	[img release];
//	//[scrollImgView addSubview:arrowImgView3];
	
	
	
	
	if(swipeImgView1 == nil)
	swipeImgView1 =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,screenWidth,ipadScreenHeight1)];//640,0,320,480
	if (appdelegate.screenHeight1!=1024) {
		[swipeImgView1 setFrame:CGRectMake(0/ratioWidth, 0/ratioHeight, screenWidth/ratioWidth, ipadScreenHeight1/ratioHeight)];
	}
	img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"img_box11.png" ofType:@""]];
	[swipeImgView1 setImage:img];
	[img release];
	[scrollImgView addSubview:swipeImgView1];
	//[swipeImgView1 release];
	
	
	if(swipeImgView2 == nil)
	swipeImgView2 =[[UIImageView alloc]initWithFrame:CGRectMake((screenWidth)+0,0,screenWidth,ipadScreenHeight1)];//960,0,320,480
	if (appdelegate.screenHeight1!=1024) {
		[swipeImgView2 setFrame:CGRectMake(screenWidth/ratioWidth, 0/ratioHeight, screenWidth/ratioWidth, ipadScreenHeight1/ratioHeight)];
	}
	img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"img_box21.png" ofType:@""]];
	[swipeImgView2 setImage:img];
	[img release];
	[scrollImgView addSubview:swipeImgView2];
	//[swipeImgView2 release];
	
	if(swipeImgView3 == nil)
		swipeImgView3 =[[UIImageView alloc]initWithFrame:CGRectMake((2*screenWidth)+10,110,790,950)];
	if (appdelegate.screenHeight1!=1024) {
		[swipeImgView3 setFrame:CGRectMake(((2*screenWidth)+10)/ratioWidth, 110/ratioHeight, 790/ratioWidth, 950/ratioHeight)];
	}
	img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"img_box31.png" ofType:@""]];
	[swipeImgView3 setImage:img];
	[img release];
	//[scrollImgView addSubview:swipeImgView3];
	
	
	//if(owendImgView == nil)
//	owendImgView =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,480)];
//	
//	img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"owned.png" ofType:@""]];
//	owendImgView.image = img;
//	[img release];
//	[scrollImgView addSubview:owendImgView];
	//[owendImgView release];
	
	
	
	if(owendImgView1 == nil)
		owendImgView1 =[[UIImageView alloc]initWithFrame:CGRectMake(1900,450,320,480)];
	if (appdelegate.screenHeight1!=1024) {
		[owendImgView1 setFrame:CGRectMake(1900/ratioWidth, 450/ratioHeight, 320/ratioWidth, 480/ratioHeight)];
	}
	//img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"owned.png" ofType:@""]];
	//owendImgView1.image = img;
	//[img release];
	//[scrollImgView addSubview:owendImgView1];
	
	if(buyNow ==nil)
	{buyNow = [[UIButton alloc]initWithFrame:CGRectMake(768+190, 380, 102, 70)];
		if (appdelegate.screenHeight1!=1024) {
			[buyNow setFrame:CGRectMake((768+190)/ratioWidth, 380/ratioHeight, 102/ratioWidth, 70/ratioHeight)];
		}
	//[buyNow setBackgroundColor:[UIColor purpleColor]];
		[buyNow addTarget:self action:@selector(buyNowAction) forControlEvents:UIControlEventTouchUpInside];}
	[scrollImgView addSubview:buyNow];
	
	
	if(buyNow1 ==nil)
	{buyNow1 = [[UIButton alloc]initWithFrame:CGRectMake(1536+190, 380, 102, 70)];
		if (appdelegate.screenHeight1!=1024) {
			[buyNow1 setFrame:CGRectMake((1536+190)/ratioWidth, 380/ratioHeight, 102/ratioWidth, 70/ratioHeight)];
		}
	//[buyNow1 setBackgroundColor:[UIColor redColor]];
		[buyNow1 addTarget:self action:@selector(buyNowAction1) forControlEvents:UIControlEventTouchUpInside];}
	[scrollImgView addSubview:buyNow1];	
	[self.view addSubview:scrollImgView];
	
	
	if(buyNow2 ==nil)
	{buyNow2 = [[UIButton alloc]initWithFrame:CGRectMake(2304+190, 380, 102, 70)];
		if (appdelegate.screenHeight1!=1024) {
			[buyNow2 setFrame:CGRectMake((2304+190)/ratioWidth, 380/ratioHeight, 102/ratioWidth, 70/ratioHeight)];
		}
		//[buyNow1 setBackgroundColor:[UIColor purpleColor]];
		[buyNow1 addTarget:self action:@selector(buyNowAction1) forControlEvents:UIControlEventTouchUpInside];}
	[scrollImgView addSubview:buyNow1];	
	[self.view addSubview:scrollImgView];
	
	if(infoBtn ==nil)
	infoBtn = [[UIButton alloc]initWithFrame:CGRectMake(385, 270, 380, 120)];
	if (appdelegate.screenHeight1!=1024) {
		[infoBtn setFrame:CGRectMake(385/ratioWidth, 270/ratioHeight, 380/ratioWidth, 120/ratioHeight)];
	}
	//infoBtn.backgroundColor = [UIColor purpleColor];
		//[infoBtn addTarget:self action:@selector(infoBtnAction) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:infoBtn];
	
	//if(selectTheme ==nil)
	selectTheme = [[UIButton alloc]initWithFrame:CGRectMake(250, 260, 280, 450)];
	if (appdelegate.screenHeight1!=1024) {
		[selectTheme setFrame:CGRectMake(250/ratioWidth, 260/ratioHeight, 280/ratioWidth, 450/ratioHeight)];
	}
	//selectTheme.backgroundColor = [UIColor blueColor];
		[selectTheme addTarget:self action:@selector(selectThemeAction) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:selectTheme];
	[selectTheme release];
	
	
	if(frwdBtn ==nil)
	{
		frwdBtn = [[UIButton alloc]initWithFrame:CGRectMake(645,580,35,35)];
		if (appdelegate.screenHeight1!=1024) {
			[frwdBtn setFrame:CGRectMake(645/ratioWidth, 580/ratioHeight, 35/ratioWidth, 35/ratioHeight)];
		}
	//frwdBtn.backgroundColor = [UIColor redColor];
		[frwdBtn addTarget:self action:@selector(frwdBtnAction) forControlEvents:UIControlEventTouchUpInside];}
	//[self.view addSubview:frwdBtn];
	
	//if(backwdBtn1 ==nil)
	{
	backwdBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(90,580,35,35)];//830,480
		if (appdelegate.screenHeight1!=1024) {
			[backwdBtn1 setFrame:CGRectMake(90/ratioWidth, 580/ratioHeight, 35/ratioWidth, 35/ratioHeight)];
		}
	//backwdBtn1.backgroundColor = [UIColor redColor];
	[backwdBtn1 addTarget:self action:@selector(backwdBtnAction) forControlEvents:UIControlEventTouchUpInside];
	//[self.view addSubview:backwdBtn1];
	[backwdBtn1 release];
	}
	//if(btnToAlarm ==nil)
	btnToAlarm = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 145, 70)];
	if (appdelegate.screenHeight1!=1024) {
		[btnToAlarm setFrame:CGRectMake(5/ratioWidth, 15/ratioHeight, 145/ratioWidth, 70/ratioHeight)];
	}
	//btnToAlarm.backgroundColor = [UIColor redColor];
	[btnToAlarm addTarget:self action:@selector(btnToAlarmAction) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btnToAlarm];
	
	if(buyNowView == nil)
	buyNowView =[[UIImageView alloc]initWithFrame:CGRectMake(1190,450,320,480)];
	if (appdelegate.screenHeight1!=1024) {
		[buyNowView setFrame:CGRectMake(1190/ratioWidth, 450/ratioHeight, 320/ratioWidth, 480/ratioHeight)];
	}
	
	//if(buyNowView1 == nil)
//	buyNowView1 =[[UIImageView alloc]initWithFrame:CGRectMake(960,0,320,480)];
	
	//if(buyNowView2 == nil)
//		buyNowView2 =[[UIImageView alloc]initWithFrame:CGRectMake(960,0,320,480)];
	
	NSUserDefaults *prefsen = [NSUserDefaults standardUserDefaults];
	
	
	appdelegate.purchaseValue = [[prefsen stringForKey:@"alarmpurchasedtheme"] intValue];
	
	NSLog(@"-->%d",appdelegate.purchaseValue);
	
	//if(buyNowView)
	//	[buyNowView removeFromSuperview];
	
	if(appdelegate.purchaseValue == 1)
	{
		isPurchased = FALSE;
		
		img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"owned.png" ofType:@""]];
		[buyNowView setImage:img];
		[img release]; 
		[scrollImgView addSubview:buyNowView];
		//[buyNowView release];
	}
	else
	{
		isPurchased = TRUE;
		
		img = [[UIImage alloc]init];//WithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"buy_now.png" ofType:@""]];
		[buyNowView setImage:img];
		[img release]; 
		[scrollImgView addSubview:buyNowView];
		//[buyNowView release];
		
	}
	
	NSUserDefaults *prefsen2 = [NSUserDefaults standardUserDefaults];
	
	myValue = [[prefsen2 stringForKey:@"alarmpurchasedtheme1"] intValue];
	
	NSLog(@"-->%d",appdelegate.purchaseValue);
	
	//if(buyNowView1)
	//	[buyNowView1 removeFromSuperview];
	if(myValue  == 1)
	{
		isPurchased = FALSE;
		
		img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"owned.png" ofType:@""]];
		[buyNowView1 setImage:img];
		[img release]; 
		[scrollImgView addSubview:buyNowView1];
		//[buyNowView1 release];
	}
	else
	{
		isPurchased = TRUE;
		
		img = [[UIImage alloc]init];//WithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"buy_now.png" ofType:@""]];
		[buyNowView1 setImage:img];
		[img release]; 
		[scrollImgView addSubview:buyNowView1];
		//[buyNowView1 release];
	}
	
	
	
	if(shopView==nil)
		shopView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 768,1024)];
	if (appdelegate.screenHeight1!=1024) {
		[shopView setFrame:CGRectMake(0/ratioWidth, 0/ratioHeight, screenWidth/ratioWidth, ipadScreenHeight1/ratioHeight)];
	}
	
	if(imgView ==nil)
	imgView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,768,50 )];//768,44
	if (appdelegate.screenHeight1!=1024) {
		[imgView setFrame:CGRectMake(0/ratioWidth, 0/ratioHeight, screenWidth/ratioWidth, 50/ratioHeight)];
	}
	imgView.image=[UIImage imageNamed:@"shopTitle.png"];
	
	[shopView addSubview:imgView];
	
	
	if(webView==nil)
		webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 50, 768,1024)];
	if (appdelegate.screenHeight1!=1024) {
		[webView setFrame:CGRectMake(0/ratioWidth, 50/ratioHeight, screenWidth/ratioWidth, ipadScreenHeight1/ratioHeight)];
	}
	[webView setBackgroundColor:[UIColor blackColor]];
	
	[webView setDelegate:self];
	
//	NSURL *aURL = [NSURL URLWithString:@"http://itunes.com/apps/zaahtechnologiesinc"];
//	NSURLRequest *aRequest = [NSURLRequest requestWithURL:aURL];
//	//load the index.html file into the web view.
//	[webView loadRequest:aRequest];
//	
	
	UIButton *button= [UIButton buttonWithType: UIButtonTypeCustom];	
	//[button setTitle:@"Back" forState:UIControlStateNormal];
	[button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
	button.frame=CGRectMake(0, 0, 320, 44);
	if (appdelegate.screenHeight1!=1024) {
		[button setFrame:CGRectMake(0/ratioWidth, 0/ratioHeight, 320/ratioWidth, 44/ratioHeight)];
	}
	[button addTarget:self action:@selector(hideWebView) forControlEvents:UIControlEventTouchUpInside];
	
	//[button setBackgroundColor:[UIColor magentaColor]];//button.alpha=.5;
	
	
	[shopView addSubview:button];
	
	loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(768/2, 250, 20,20)];
	if (appdelegate.screenHeight1!=1024) {
		[loadingIndicator setFrame:CGRectMake((768/2)/ratioWidth, 250/ratioHeight, 20/ratioWidth, 20/ratioHeight)];
	}
	[loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
	[loadingIndicator setHidesWhenStopped:YES];
	
	[webView addSubview:loadingIndicator];
	
	[shopView addSubview:webView];
	
	
	UIActivityIndicatorView *downloadingIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	downloadingIndicator1.frame = CGRectMake(369,497, 30.0, 30.0);//369,497, 30.0, 30.0
	if (appdelegate.screenHeight1!=1024) {
		[downloadingIndicator1 setFrame:CGRectMake(369/ratioWidth, 497/ratioHeight, 30.0/ratioWidth, 30.0/ratioHeight)];
	}
	downloadingIndicator1.center = self.view.center;
	[downloadingIndicator1 startAnimating];
	
	clockdownloadingOverlayView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];//0, 0, 320, 480
	if (appdelegate.screenHeight1!=1024) {
		[clockdownloadingOverlayView setFrame:CGRectMake(0/ratioWidth, 0/ratioHeight, screenWidth/ratioWidth, ipadScreenHeight1/ratioHeight)];
	}
	[clockdownloadingOverlayView setAlpha:0.85];
	[clockdownloadingOverlayView setBackgroundColor:[UIColor grayColor]];
	[self.view  addSubview:clockdownloadingOverlayView];
	[clockdownloadingOverlayView addSubview:downloadingIndicator1];
	clockdownloadingOverlayView.hidden = YES;
	[scrollImgView addSubview:arrowImgView];
	//[scrollImgView addSubview:arrowImgView1];
	//[scrollImgView addSubview:arrowImgView2];
	[scrollImgView addSubview:arrowImgView3];
}
	
-(void)viewWillAppear:(BOOL)animated
{
	
	
	//
//	
//	buyNowView =[[UIImageView alloc]initWithFrame:CGRectMake(320,0,320,480)];
//	
//	buyNowView1 =[[UIImageView alloc]initWithFrame:CGRectMake(640,0,320,480)];
//	
//	NSUserDefaults *prefsen = [NSUserDefaults standardUserDefaults];
//	
//	
//	appdelegate.purchaseValue = [[prefsen stringForKey:@"alarmpurchasedtheme"] intValue];
//	
//	NSLog(@"-->%d",appdelegate.purchaseValue);
//	
//	//if(buyNowView)
//	//	[buyNowView removeFromSuperview];
//	
//	if(appdelegate.purchaseValue == 1)
//	{
//		isPurchased = FALSE;
//		
//		img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"owned.png" ofType:@""]];
//		[buyNowView setImage:img];
//		[img release]; 
//		[scrollImgView addSubview:buyNowView];
//		[buyNowView release];
//	}
//	else
//	{
//		isPurchased = TRUE;
//		
//		img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"buy_now.png" ofType:@""]];
//		[buyNowView setImage:img];
//		[img release]; 
//		[scrollImgView addSubview:buyNowView];
//		[buyNowView release];
//		
//	}
//	
//	NSUserDefaults *prefsen2 = [NSUserDefaults standardUserDefaults];
//	
//	int myValue = [[prefsen2 stringForKey:@"alarmpurchasedtheme1"] intValue];
//	
//	NSLog(@"-->%d",appdelegate.purchaseValue);
//	
//	//if(buyNowView1)
//	//	[buyNowView1 removeFromSuperview];
//	if(myValue  == 1)
//	{
//		isPurchased = FALSE;
//		
//		img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"owned.png" ofType:@""]];
//		[buyNowView1 setImage:img];
//		[img release]; 
//		[scrollImgView addSubview:buyNowView1];
//		[buyNowView1 release];
//	}
//	else
//	{
//		isPurchased = TRUE;
//		
//		img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"buy_now.png" ofType:@""]];
//		[buyNowView1 setImage:img];
//		[img release]; 
//		[scrollImgView addSubview:buyNowView1];
//		[buyNowView1 release];
//	}
//	
}



-(void)btnToAlarmAction
{
	
	//[self.view setHidden:YES]; 
	
	//[self.view removeFromSuperview];
	[self dismissModalViewControllerAnimated:YES];

}

- (void)scrollViewDidScroll:(UIScrollView *)scroll
{
	
	appdelegate.themeValue = scroll.contentOffset.x;
	setAction == TRUE;
	NSLog(@"appdelegate.themeValue %d",scroll.contentOffset.x);


}


-(void)frwdBtnAction
{
	frwdBtnClicked = FALSE;
	[self scrollViewDidScroll:scrollImgView ];
	if(appdelegate.screenHeight1 == 1024)
	{
	//NSLog(@"xxxxx %d",320*appdelegate.themeValue/320);
	if(scrollImgView.contentOffset.x==0)
	{
		//NSLog(@"xxxxx %d",1280*appdelegate.themeValue/320);

		[ scrollImgView setContentOffset: CGPointMake( 768, 0 ) animated: YES ];
		

	}
	}
	else {
		if(scrollImgView.contentOffset.x==0)
		{
			[scrollImgView setContentOffset: CGPointMake( 320, 0 ) animated: YES ];
		}
		
		//else if (scrollImgView.contentOffset.x==screenWidthiphone) 
//		{
//			[scrollImgView setContentOffset: CGPointMake( screenWidthiphone*2, 0 ) animated: YES ];
//		}
	}
	
	//else if (scrollImgView.contentOffset.x==768) 
//	{
//		////NSLog(@"xxxxx %d",1280*appdelegate.themeValue/320);
//
//		[ scrollImgView setContentOffset: CGPointMake( 1536, 0 ) animated: YES ];
//	}
	
	//else if (scrollImgView.contentOffset.x==1536) 
//	{
//		////NSLog(@"xxxxx %d",1280*appdelegate.themeValue/320);
//		
//		[ scrollImgView setContentOffset: CGPointMake( 2304, 0 ) animated: YES ];
//	}
	
}

-(void)backwdBtnAction
{
	
	
	
	backwdBtnClicked = FALSE;
	[self scrollViewDidScroll:scrollImgView ];
	if(appdelegate.screenHeight1 == 1024)
	{
	if(scrollImgView.contentOffset.x==768)
	{
		[ scrollImgView setContentOffset: CGPointMake( 0, 0 ) animated: YES ];
	}
	
	else if (scrollImgView.contentOffset.x==1536) 
	{
		[ scrollImgView setContentOffset: CGPointMake( 768, 0 ) animated: YES ];
	}
	}
	else {
		if(scrollImgView.contentOffset.x==320)
		{
			[scrollImgView setContentOffset: CGPointMake( 0, 0 ) animated: YES ];
			
		}
		
		else if (scrollImgView.contentOffset.x==320*2) 
		{
			[ scrollImgView setContentOffset: CGPointMake( 320, 0 ) animated: YES ];
		}
	}
	//else if (scrollImgView.contentOffset.x==2304) 
//	{
//		[ scrollImgView setContentOffset: CGPointMake( 1536, 0 ) animated: YES ];
//	}
}

-(void)selectThemeAction
{
//	AlarmsViewController *alm;
		//clockdownloadingOverlayView.hidden=FALSE;
		NSLog(@"xvalue %d", appdelegate.themeValue);
					
		if(frwdBtnClicked == FALSE)
		{
			appdelegate.alarmTheme = appdelegate.alarmTheme+1;
			frwdBtnClicked= TRUE;
		}
		
		if(backwdBtnClicked == FALSE)
		{
			appdelegate.alarmTheme = appdelegate.alarmTheme-2;
			backwdBtnClicked= TRUE;
		}
		
		
	if(appdelegate.screenHeight1 == 1024)
		appdelegate.alarmTheme = scrollImgView.contentOffset.x/768;
	else
		appdelegate.alarmTheme = scrollImgView.contentOffset.x/320;
	
	
	
		NSUserDefaults *prefs1 = [NSUserDefaults standardUserDefaults];
		
		appdelegate.purchaseValue = [[prefs1 stringForKey:@"alarmpurchasedtheme"] intValue];
		appdelegate.myvalue  = [[prefs1 stringForKey:@"alarmpurchasedtheme1"] intValue];
		
		//int noNeedValue = [[prefs1 stringForKey:@"noNeedTopurchase"] intValue];
	
	if (appdelegate.alarmTheme == 0)
	{
		
		NSString *themeIndex = @"0";
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		[prefs setObject:themeIndex forKey:@"alarmThemeValue"];
		[prefs synchronize];
		
		[self btnToAlarmAction];
		
	}
		
	else if (appdelegate.alarmTheme == 1)
		{
			
			if (appdelegate.purchaseValue == 1)
			{
				NSString *themeIndex = @"1";
				NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
				[prefs setObject:themeIndex forKey:@"alarmThemeValue"];
				[prefs synchronize];
				
				[self btnToAlarmAction];
			}
			else
			{
				if([appdelegate isDataSourceAvailable]==TRUE)
				{
					//if(clockdownloadingOverlayView.hidden==TRUE)
						//[self buyNowAction];
					NSString *themeIndex = @"1";
					NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
					[prefs setObject:themeIndex forKey:@"alarmThemeValue"];
					[prefs synchronize];
					
					[self btnToAlarmAction];
				}
				else {
					UIAlertView *alert = [[UIAlertView alloc] 
										  initWithTitle:@"Network Connection Error" 
										  message:@"You need to be connected to the internet to use this feature." 
										  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
					alert.delegate=self;
					[alert show];
					[alert release];
				}

			}
			
		}
		
	
	
	else if(appdelegate.alarmTheme == 2 )
		{
			if (appdelegate.myvalue == 1)
			{
				NSString *themeIndex = @"2";
				NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
				[prefs setObject:themeIndex forKey:@"alarmThemeValue"];
				[prefs synchronize];
				[self btnToAlarmAction];
			}
			else
			{
				if ([appdelegate isDataSourceAvailable]==TRUE)
				{
					//if(clockdownloadingOverlayView.hidden==TRUE)
						[self buyNowAction1];
				}
				else {
					UIAlertView *alert = [[UIAlertView alloc] 
										  initWithTitle:@"Network Connection Error" 
										  message:@"You need to be connected to the internet to use this feature." 
										  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
					alert.delegate=self;
					[alert show];
					[alert release];
				}

			}
			
		}
	frwdBtnClicked = FALSE;

		setAction = FALSE;

	//}
		 // added by mani*** - ends

}

-(void)infoBtnAction
{
	 
	[self.view addSubview:shopView];  

	
}


-(void)webViewDidStartLoad:(UIWebView *)webView 
{
	[loadingIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView 
{
	[loadingIndicator stopAnimating];
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	[loadingIndicator stopAnimating];
}

-(void)hideWebView
{
	//NSLog(@"hideWebView");
	[shopView removeFromSuperview];
	
}
-(void)buyNowAction
{
	
	buyNowEvent = TRUE;
		
			
    	clockdownloadingOverlayView.hidden=FALSE;

		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
		//boughtTheme = 1;
		kInAppPurchaseProUpgradeProductId1 = @"DashboardClockSkin1";
		[self requestProUpgradeProductData];
		//clockdownloadingOverlayView.hidden=FALSE;
	
	
		
		//appdelegate.alarmTheme = appdelegate.themeValue/768;
//			
//		NSString *themeIndex1 = @"1"; //[NSString stringWithFormat:@"%d",appdelegate.alarmTheme];
//		
//		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//		
//		[prefs setObject:themeIndex1 forKey:@"alarmThemeValue"];
//		
//		[prefs synchronize];
//		
//		appdelegate.purchaseValue = 1;
//		
//		NSString *purchaseIndex1 = [NSString stringWithFormat:@"%d",appdelegate.purchaseValue];
//		
//		NSUserDefaults *prefs1 = [NSUserDefaults standardUserDefaults];
//		
//		[prefs1 setObject:purchaseIndex1 forKey:@"alarmpurchasedtheme"];
//		[prefs1 synchronize];
//			
//		[self dismissModalViewControllerAnimated:YES];
	
                      
}

-(void)buyNowAction1
{
	buyNowEvent1 = TRUE;


	
	clockdownloadingOverlayView.hidden=FALSE;

	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	
	kInAppPurchaseProUpgradeProductId1 = @"DashboardClockSkin2";
	[self requestProUpgradeProductData];
	//clockdownloadingOverlayView.hidden=FALSE;
	
	
	
	//appdelegate.alarmTheme = scrollImgView.contentOffset.x/768;
//	
//	NSString *themeIndex1 = @"2"; //[NSString stringWithFormat:@"%d",appdelegate.alarmTheme];
//	
//	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//	
//	[prefs setObject:themeIndex1 forKey:@"alarmThemeValue"];
//	
//	[prefs synchronize];
//	
//	appdelegate.myvalue = 1;
//	NSString *purchaseIndex1 = [NSString stringWithFormat:@"%d",appdelegate.myvalue];
//	NSUserDefaults *prefs1 = [NSUserDefaults standardUserDefaults];
//	
//	[prefs1 setObject:purchaseIndex1 forKey:@"alarmpurchasedtheme1"];
//	[prefs1 synchronize];
//	[self dismissModalViewControllerAnimated:YES];
	
	
}




//******before@end

//********************************inapppurchase

- (void)requestProUpgradeProductData
{
	clockproductIdentifiers = [NSSet setWithObject:kInAppPurchaseProUpgradeProductId1 ];
	appdelegate.storeproductidentifier = clockproductIdentifiers;
	if(appdelegate.storeproductidentifier == clockproductIdentifiers)
	{
		storeproductsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:clockproductIdentifiers];
		storeproductsRequest.delegate = self;
		[storeproductsRequest start];
	}
	
	// we will release the request object in the delegate callback
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	//NSArray *products = response.products;
	appdelegate.productArray = response.products;
	if(appdelegate.productArray == response.products)
	{
		proUpgradeProduct = [appdelegate.productArray count] == 1 ? [[appdelegate.productArray objectAtIndex:0] retain] : nil;
	    if (proUpgradeProduct)
		{
			NSLog(@"Product title: %@" , proUpgradeProduct.localizedTitle);
			NSLog(@"Product description: %@" , proUpgradeProduct.localizedDescription);
			NSLog(@"Product price: %@" , proUpgradeProduct.price);
			NSLog(@"Product id: %@" , proUpgradeProduct.productIdentifier);
			
			
			if([self canMakePurchases]==YES)
				[self purchaseProUpgrade]; 
			else {
								
				[clockdownloadingOverlayView setHidden:TRUE];
								
			}
			
			
		}
		
		for (NSString *invalidProductId in response.invalidProductIdentifiers)
		{
			NSLog(@"Invalid product id: %@" , invalidProductId);
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Unable to purchase the theme with id : %@",invalidProductId] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
			[alert show]; 
			[alert release];
			
			[clockdownloadingOverlayView setHidden:TRUE];
			
			
		}
		
		if(appdelegate.storeproductidentifier == clockproductIdentifiers)
		{
			[storeproductsRequest release];
		}
	}
	
	
}

/*
 - (void)request:(SKRequest *)request didFailWithError:(NSError *)error
 {
 
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"ERROR : %@" , [error description] ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
 //[alert show]; 
 [alert release];
 [clockdownloadingOverlayView setHidden:TRUE];
 }
 */

- (void)requestDidFinish:(SKRequest *)request
{
	
	
}


#pragma -
#pragma Public methods

//
// call this method once on startup
//
- (void)loadStore
{
	// restarts any purchases if they were interrupted last time the app was open
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	
	// get the product description (defined in early sections)
	[self requestProUpgradeProductData];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
	return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//
- (void)purchaseProUpgrade
{
	SKPayment *payment = [SKPayment paymentWithProductIdentifier:kInAppPurchaseProUpgradeProductId1];
	[[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
	if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseProUpgradeProductId1])
	{
		// save the transaction receipt to disk
		[[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceipt" ];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

//
// enable pro features
//
- (void)sprovideContent:(NSString *)productId
{
	appdelegate.productIdName = productId;
	if ([appdelegate.productIdName isEqualToString:kInAppPurchaseProUpgradeProductId1])
	{
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isProUpgradePurchased" ];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Would you like to read the book you just purchased ?"] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil]; 
		//[alert show]; 
		//[alert release];
		
		
		@try {
			
			
			//appDelegate.bookPurchased =TRUE;
			//[NSThread detachNewThreadSelector:@selector(startBookDownloading:) toTarget:self withObject:nil];	
			
		}
		@catch (NSException * e) {
			
		}
		
		
		//		
//		NSString *currentProductID=[productId substringFromIndex:15];
//		
//		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//		
//		[defaults setInteger: 111 forKey: currentProductID]; //getting the last 52 from "wallpaperpack1052"
//		[defaults synchronize];
		
		
		if(appdelegate.screenHeight1 == 1024)
			appdelegate.alarmTheme = scrollImgView.contentOffset.x/768;
		else
			appdelegate.alarmTheme = scrollImgView.contentOffset.x/320;
		

		//Added by Mani*** - Begins
		
		if(appdelegate.alarmTheme == 2)
		{
			//appdelegate.alarmTheme = appdelegate.themeValue/320;
			
			NSString *themeIndex1 = @"2";//[NSString stringWithFormat:@"%d",appdelegate.alarmTheme];
			
			NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
			[prefs setObject:themeIndex1 forKey:@"alarmThemeValue"];
			[prefs synchronize];
			//[themeIndex1 release];
			
			appdelegate.myvalue = 1;     			
			NSString *purchaseIndex1 = [NSString stringWithFormat:@"%d",appdelegate.myvalue];
			
			NSUserDefaults *prefs1 = [NSUserDefaults standardUserDefaults];
			
			[prefs1 setObject:purchaseIndex1 forKey:@"alarmpurchasedtheme1"];
			[prefs1 synchronize];
			
			[clockdownloadingOverlayView setHidden:TRUE];
			[self.parentViewController dismissModalViewControllerAnimated:YES];
			
		}
		
		if(appdelegate.alarmTheme == 1)
		{
			//appdelegate.alarmTheme = scrollImgView.contentOffset.x/320;
			
			NSString *themeIndex1 =@"1"; // [NSString stringWithFormat:@"%d",appdelegate.alarmTheme];
			
			NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
			
			[prefs setObject:themeIndex1 forKey:@"alarmThemeValue"];
			
			[prefs synchronize];
			//[themeIndex1 release];
			
			appdelegate.purchaseValue = 1;
			
			NSString *purchaseIndex1 = [NSString stringWithFormat:@"%d",appdelegate.purchaseValue];
			
			NSUserDefaults *prefs1 = [NSUserDefaults standardUserDefaults];
			
			[prefs1 setObject:purchaseIndex1 forKey:@"alarmpurchasedtheme"];
			[prefs1 synchronize];
			//[purchaseIndex1 release];
			
			[clockdownloadingOverlayView setHidden:TRUE];
			[self.parentViewController dismissModalViewControllerAnimated:YES];
		}
		//Added by Mani*** - Ends		
		
		[clockdownloadingOverlayView setHidden:TRUE];
//		
//				
//		[self dismissModalViewControllerAnimated:YES];
		
		NSUserDefaults *prefsen = [NSUserDefaults standardUserDefaults];
		
		
		appdelegate.purchaseValue = [[prefsen stringForKey:@"alarmpurchasedtheme"] intValue];
		
		NSLog(@"-->%d",appdelegate.purchaseValue);
		
		//if(buyNowView)
		//	[buyNowView removeFromSuperview];
		
		if(appdelegate.purchaseValue == 1)
		{
			isPurchased = FALSE;
			
			img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"owned.png" ofType:@""]];
			[buyNowView setImage:img];
			[img release]; 
			//[scrollImgView addSubview:buyNowView];
			//[buyNowView release];
		}

		
		NSUserDefaults *prefsen2 = [NSUserDefaults standardUserDefaults];
		
		myValue = [[prefsen2 stringForKey:@"alarmpurchasedtheme1"] intValue];
		
		NSLog(@"-->%d",appdelegate.purchaseValue);
		
		//if(buyNowView1)
		//	[buyNowView1 removeFromSuperview];
		if(myValue  == 1)
		{
			isPurchased = FALSE;
			
			img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"owned.png" ofType:@""]];
			[buyNowView1 setImage:img];
			[img release]; 
			//[scrollImgView addSubview:buyNowView1];
			//[buyNowView1 release];
		}
		
		
		
	}
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
	// remove the transaction from the payment queue.
	[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
	
	//NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
	if (wasSuccessful)
	{
		//appdelegate.purchaseValue = 1;
		//appdelegate.myvalue = 1;
		
		//Added by Mani*** - Begins
		//appdelegate.purchaseValue = 1;
		//Added by Mani*** - Ends
		
		
		// send out a notification that we’ve finished the transaction
		//    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
		
		//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"transaction success : " ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		//[alert show]; 
		//[alert release];
	}
	else
	{
		// send out a notification for the failed transaction
		//  [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];

		//Added by Mani*** - Begins
		appdelegate.purchaseValue = 0;
		appdelegate.myvalue = 0;
		//Added by Mani*** - Ends	
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Transaction failed : %@", transaction.payment.productIdentifier ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		[alert show]; 
		[alert release];
		
	}
	[clockdownloadingOverlayView setHidden:TRUE];

	//if(buyNowEvent)
//	{		
//		NSLog(@"clockdownloadingOverlayView");
//		[clockdownloadingOverlayView setHidden:TRUE];
//	}
//	if(buyNowEvent1)
//	{
//		NSLog(@"clockdownloadingOverlayView++++++");
//		
//		[clockdownloadingOverlayView1 setHidden:TRUE];
//		
//	}
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
	[self recordTransaction:transaction];
	[self sprovideContent:transaction.payment.productIdentifier];
	[self finishTransaction:transaction wasSuccessful:YES];
	
	[clockdownloadingOverlayView setHidden:TRUE];

	//if(buyNowEvent)
//	{		
//		NSLog(@"clockdownloadingOverlayView");
//		[clockdownloadingOverlayView setHidden:TRUE];
//	}
//	if(buyNowEvent1)
//	{
//		NSLog(@"clockdownloadingOverlayView++++++");
//		
//		[clockdownloadingOverlayView1 setHidden:TRUE];
//		
//	}

}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
	[self recordTransaction:transaction.originalTransaction];
	[self sprovideContent:transaction.originalTransaction.payment.productIdentifier];
	[self finishTransaction:transaction wasSuccessful:YES];
	
	[clockdownloadingOverlayView setHidden:TRUE];

	//if(buyNowEvent)
//	{		
//		NSLog(@"clockdownloadingOverlayView");
//		[clockdownloadingOverlayView setHidden:TRUE];
//	}
//	if(buyNowEvent1)
//	{
//		NSLog(@"clockdownloadingOverlayView++++++");
//		
//		[clockdownloadingOverlayView1 setHidden:TRUE];
//		
//	}

}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
	if (transaction.error.code != SKErrorPaymentCancelled)
	{
		// error!
		[self finishTransaction:transaction wasSuccessful:NO];
	}
	else
	{
		// this is fine, the user just cancelled, so don’t notify
		[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
	}
	
	[clockdownloadingOverlayView setHidden:TRUE];

	//if(buyNowEvent)
//	{		
//		NSLog(@"clockdownloadingOverlayView");
//		[clockdownloadingOverlayView setHidden:TRUE];
//	}
//	if(buyNowEvent1)
//	{
//		NSLog(@"clockdownloadingOverlayView++++++");
//		
//		[clockdownloadingOverlayView1 setHidden:TRUE];
//		
//	}

}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions)
	{
		
		//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"transaction state: %d",transaction.transactionState ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		//	[alert show]; 
		//	[alert release];
		
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
				[self completeTransaction:transaction];
				break;
			case SKPaymentTransactionStateFailed:
				[self failedTransaction:transaction];
				break;
			case SKPaymentTransactionStateRestored:
				[self restoreTransaction:transaction];
				break;
			default:
				break;
		}
	}
}

// Sent when transactions are removed from the queue (via finishTransaction:).
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
	
} 
// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
	
}

// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue 
{
	
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
	//return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) ;
}


- (void)dealloc {
	
	[storeView1 release];
	[storeView2 release];
	[scrollImgView release];
    [super dealloc];
}


@end
