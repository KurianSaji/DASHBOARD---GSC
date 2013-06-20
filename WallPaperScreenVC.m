//
//  WallPaperScreenVC.m
//  HDBackgroundDemoOne
//
//  Created by Zaah Technologies India PVT on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WallPaperScreenVC.h"
#import "SA_OAuthTwitterEngine.h"
#import <StoreKit/StoreKit.h>
#define kOAuthConsumerKey				@"gKKNHPCJR4ogFjWT9vjgg"		//REPLACE ME  Twitter
#define kOAuthConsumerSecret			@"1FOKxqZI4FCT1zjKMA6vdE16jZD5STGVB5wGzxrpKc"	
#import "epubstore_svcAppDelegate.h"
#import "HDLoopDemoViewController.h"



int currentPage =0;

int newPositionCount;

UIScrollView *wallpaperScrollView;
CGPoint gestureStartPoint;
//CGFloat kMaximumVariance = 250;
//CGFloat kMinimumGestureLength = 0.5;
UIImage *imageToSave;
int currentPage ;

UIImageView *previousImageView;
UIImageView *currentImageView;
UIImageView *nextImageView;
UIImageView *srollImageView[19];

UITextView *twitterTextField ;
UIView * twitterView;

NSString *strCatDetails;
NSArray *arrCatDetails;
NSString *imageName;
UIImageView *imageView;

UIView *forwardview;
UIImageView *buttonImgView;

UIImageView *blurImgView;

int imgCount1 =0;
int screenWidt = 320;
int screenHeig = 480;
int pageCount ;
int previousRightScroll =0;

int selectedFolder=1;
int selectedImage=1;
int imageViewCount=0;

BOOL viewLoadedCompletely=FALSE;

BOOL UserClickedBack = NO;
BOOL _TwitterOpened= NO;

UIImageView *walPaperImgView1;

UIImageView *walPaperImgView2;
UIImageView *walPaperImgView3;
//UIImageView *loadImgView;

UIView *downloadingOverlayView;
UIActivityIndicatorView *downloadingIndicator;
UIImageView *loadImgView;
BOOL frwdBtnClicked;
BOOL backwdBtnClicked;
int forward=0;

NSString *strWallImgName;
NSString *newWallImgName;


@implementation WallPaperScreenVC


@synthesize iSelectedImgIndex,selectedArray;
@synthesize iSelectedCatIndex;
@synthesize iTotalCatImages;
@synthesize sCatTitle;
//@synthesize connection;
@synthesize btnforward;
@synthesize btnbackward;
NSURLConnection *connection;
int dummySelectedIndex;


static NSString* kAppId = @"180294668651052";

BOOL saveBtnValue = FALSE;
BOOL loadingDone = FALSE;
int imgToLoad = 1;
int currentImg = 1;
BOOL swipedLeft = TRUE;

BOOL viewJustLoaded=TRUE;

BOOL scrollViewScrollDetectionEnabled=TRUE;

HDLoopDemoViewController *hdloop;

NSString *strCatDetails1;
NSArray *arrCatDetails1;

BOOL lastimage;

//NSString *kInAppPurchaseProUpgradeProductId =@"wallpaperpackipadhd001";
SKProduct *proUpgradeProduct;
SKProductsRequest *productsRequest;
int totalImagesCount;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	appDelegate = (epubstore_svcAppDelegate*)[[UIApplication sharedApplication]delegate];
	
//    self.selectedArray=[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d info",iSelectedCatIndex]];
	viewJustLoaded=TRUE;
	saveBtnValue = FALSE;
	loadingDone = FALSE;
	imgToLoad = 1;
	currentImg = 1;
	swipedLeft = TRUE;
	connection=nil;
	//NSLog(@"viewDidLoad");
	
	frwdBtnClicked = TRUE;
	backwdBtnClicked =TRUE;
	
	[self.view setFrame:[[UIScreen mainScreen] bounds]];
	
	screenWidt = [[UIScreen mainScreen] bounds].size.width;
	screenHeig = [[UIScreen mainScreen] bounds].size.height;
	
	
	
    [super viewDidLoad];
	appDelegate =(epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	//self.navigationItem.leftBarButtonItem = BARBUTTON(@"Back", @selector(action:));
	//self.title = sCatTitle;
	twitterTextField = nil;
	_TwitterOpened =NO;
	imageToSave = nil;
	
	
	
	loadImgView =[[UIImageView alloc]init];
	
	
	if(screenHeig == 1024)
	{
		[loadImgView setFrame:CGRectMake(screenWidt/2-112/2 , screenHeig/2-39/2+50, 112, 39)];
		[loadImgView setImage:[UIImage imageNamed:@"loading_1024x768" ]];
		
	}
	else
	{
		[loadImgView setFrame:CGRectMake(screenWidt/2-77/2 , screenHeig/2-30/2+35, 77, 30)];
		[loadImgView setImage:[UIImage imageNamed:@"loading_320x480"]];
		
	}
	
	[self.view addSubview:loadImgView];
	//[loadImgView release];
	
	[self.view setBackgroundColor:[UIColor blackColor]];
	
	
	downloadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	downloadingIndicator.frame = CGRectMake(369,497, 30.0, 30.0);
	downloadingIndicator.center = self.view.center;
	[downloadingIndicator startAnimating];
	
	[self.view addSubview:downloadingIndicator];
	//[downloadingIndicator release];
	
	wallpaperScrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 48.0f, screenWidt, screenHeig)];
	[wallpaperScrollView setBackgroundColor:[UIColor clearColor]];
	wallpaperScrollView.delegate=self;
	wallpaperScrollView.contentSize=CGSizeMake(3*screenWidt, 0);
	wallpaperScrollView.scrollEnabled=YES;
	[wallpaperScrollView setPagingEnabled:YES];
	wallpaperScrollView.showsHorizontalScrollIndicator=NO;
    if (iTotalCatImages>3) {
        wallpaperScrollView.contentSize=CGSizeMake(3*screenWidt, 0);
    }
    else if(iTotalCatImages==2) {
        wallpaperScrollView.contentSize=CGSizeMake(2*screenWidt, 0);
    }
    else if(iTotalCatImages==1) {
        wallpaperScrollView.contentSize=CGSizeMake(screenWidt, 0);
    }
	
	walPaperImgView1 =[[UIImageView alloc]init];
	[walPaperImgView1 setFrame:CGRectMake(0, 0, screenWidt, screenHeig-50)];
	[walPaperImgView1 setBackgroundColor:[UIColor clearColor]];
	[wallpaperScrollView addSubview:walPaperImgView1];
	
	walPaperImgView2 =[[UIImageView alloc]init];
	[walPaperImgView2 setFrame:CGRectMake(screenWidt, 0, screenWidt, screenHeig-50)];
	[walPaperImgView2 setBackgroundColor:[UIColor clearColor]];
	[wallpaperScrollView addSubview:walPaperImgView2];
	
	
	walPaperImgView3 =[[UIImageView alloc]init];
	[walPaperImgView3 setFrame:CGRectMake(screenWidt*2, 0, screenWidt, screenHeig-50)];
	[walPaperImgView3 setBackgroundColor:[UIColor clearColor]];
	[wallpaperScrollView addSubview:walPaperImgView3];
	
	
	//dummySelectedIndex = iSelectedImgIndex;
	
	// button tag always starts from 1. 
	[self.view addSubview:wallpaperScrollView];
	
	buttonImgView =[[UIImageView alloc]init];
	
	[buttonImgView setFrame:CGRectMake(0, 48.0f, screenWidt, screenHeig-50)];
	
	if(screenHeig == 1024)
	{
		[buttonImgView setImage:[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Screen03_icons" ofType:@"png"]]];
		
	}
	else 
	{
		[buttonImgView setImage:[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Screen03_icons_iphone" ofType:@"png"]]];
		
	}
	
	[self.view addSubview:buttonImgView];
	[buttonImgView release];
	
	//hdloop = [[HDLoopDemoViewController alloc]init];
	//	NSLog(@"%d",hdloop.totalImagesCount);
	
	strCatDetails1 = [appDelegate.arrCatList objectAtIndex:0];//iCatIndexValue
	arrCatDetails1 = [[NSArray alloc]init];
	arrCatDetails1 = [strCatDetails1  componentsSeparatedByString:appDelegate.strColDelimiter];
	
	totalImagesCount = [[arrCatDetails1 objectAtIndex:appDelegate.iCatNoOfImgsIndex ]intValue];
	
	
	//btnbackward=[[UIButton alloc] init];
    //	if(screenHeig == 1024)
    //		btnbackward.frame=CGRectMake(10, 512, 92,33);
    //	else {
    //		btnbackward.frame=CGRectMake(4.2, 240, 38,15.5);
    //		
    //	}
    //	
    //	[btnbackward addTarget:self action:@selector(pagebackward:) forControlEvents:UIControlEventTouchUpInside];
    //	//[btnbackward setImage:[UIImage imageNamed:@"previouswp.png"] forState:UIControlStateNormal];
    //	[btnbackward setBackgroundColor:[UIColor redColor]];
    //	//[self.view addSubview:btnbackward];
    //	//[btnbackward release];
    //	
    //	btnforward=[[UIButton alloc] init];
    //	if(screenHeig == 1024)
    //		btnforward.frame=CGRectMake(668, 512, 92,33);
    //	else {
    //		btnforward.frame=CGRectMake(278.3, 240, 38,15.5);
    //		
    //	}
    //	[btnforward addTarget:self action:@selector(pageforward:) forControlEvents:UIControlEventTouchUpInside];
    //	//[btnforward setImage:[UIImage imageNamed:@"nextwp.png"] forState:UIControlStateNormal];
    //	[btnforward setBackgroundColor:[UIColor redColor]];
    //	//[self.view addSubview:btnforward];
    //	//[btnforward release];
	
	
	
	NSString *urlName;
	//UIImage *imgWallPaper;
	
	strCatDetails = [appDelegate.arrCatList objectAtIndex:iSelectedCatIndex];
	arrCatDetails = [[NSArray alloc]init];
	arrCatDetails = [strCatDetails  componentsSeparatedByString:appDelegate.strColDelimiter ];
	
	imageName = [NSString stringWithFormat:@"upload/product/image/%@_%@_%d.png",[arrCatDetails objectAtIndex:appDelegate.iCatIDIndex],appDelegate.str320by480Name,[[[self.selectedArray objectAtIndex:iSelectedImgIndex-1] objectForKey:@"id"] intValue]];
    newPositionCount=iSelectedImgIndex;
	NSString *strWallImgName = [imageName lastPathComponent]; 
	
	//	if([appDelegate checkFileExist:strWallImgName])
	//	{
	//		
	//		imgWallPaper = [appDelegate getImageFromDocFolder:strWallImgName];
	//	}
	//	else 
	//	{
	urlName = [appDelegate.strURL stringByAppendingString:imageName];
    NSLog(@"%@ IN",urlName);
	[self loadImageFromURL:urlName];	
	
	
	UIButton *setAsBackground =[[UIButton alloc]init];
	[setAsBackground setFrame:CGRectMake(60*screenWidt/320,screenHeig-40*screenHeig/480,100*screenWidt/320,40*screenHeig/480)];
	[setAsBackground setBackgroundColor:[UIColor clearColor]];
	[setAsBackground addTarget:self action:@selector(saveImageAction) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:setAsBackground];
	[setAsBackground release];
	
	UIButton *BackButton =[[UIButton alloc]init];
	[BackButton setFrame:CGRectMake(160*screenWidt/320, screenHeig-40*screenHeig/480, 100*screenWidt/320, 40*screenHeig/480)];
	[BackButton setBackgroundColor:[UIColor clearColor]];
	[BackButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:BackButton];
	[BackButton release];
	
	UINavigationBar* theBar;	
	if(screenHeig== 1024)
		theBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 768, 48.0f)];
	else {
		theBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320, 48.0f)];
		
	}	
    
    NSString *wallTitle = [NSString stringWithFormat:@"   %@",sCatTitle];
    [theBar pushNavigationItem:[[UINavigationItem alloc] initWithTitle:wallTitle]];
    //theBar.topItem.title = sCatTitle;
    
	theBar.barStyle=UIBarStyleBlackTranslucent;
	[self.view addSubview: theBar];
    
    //    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"BACK" style:UIBarButtonItemStyleBordered target:self action:@selector(backBtnAction)];
    //    
    //    
    //    theBar.topItem.backBarButtonItem = backButton; 
	
	UIButton *button=[[UIButton alloc] init];
	button.frame=CGRectMake(15, 5, 74,32);
	//[button setBackgroundImage:buttonBg forState:UIControlStateNormal];
	[button addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
	
	[button setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:button];
	[button release];
	UIImageView *barImgVIew;
	
	if(screenHeig == 1024)
		barImgVIew = [[UIImageView alloc]initWithFrame:CGRectMake(15, 2,65,40)];
	else
		barImgVIew = [[UIImageView alloc]initWithFrame:CGRectMake(0, 9,50,30)];
	
	UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"back11.png"] ofType:@""]];
	barImgVIew.image = img;
	[img release];
	[self.view addSubview:barImgVIew];
	[barImgVIew release];
	
	//UIImageView *barImgVIew = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 768,50)];
	//	
	//	UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"tweet.png"] ofType:@""]];
	//	barImgVIew.image = img;
	//	[img release];
	//	[self.view addSubview:barImgVIew];
	//BackButton.backgroundColor=[UIColor greenColor];
	
	//UIView *adBg=[[UIView alloc]init] ;
	//	
	//	[adBg setFrame:CGRectMake(0,974,768,50)];
	//	[self.view addSubview:adBg];
	//	
	//	adView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
	//    //adView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
	//	if(screenHeig==1024)
	//	{
	//		[adBg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"elite-gudz-1.jpg"]]];
	//		[adView setFrame:CGRectMake(220, screenHeig-50, screenWidt, 50)];
	//		
	//	}
	//	else
	//	{
	//		[adView setFrame:CGRectMake(0, screenHeig-50, screenWidt, 50)];
	//		[adView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"eliteGudz_ad.png"]]];
	//	}
	//	
	//	
	//    [self.view addSubview:adView];
	
	
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
	[btn addTarget:self action:@selector(actionSheetAction) forControlEvents:UIControlEventTouchUpInside];
	
	UserClickedBack = NO;
	
	
	//*************in app purchase
	//Over Lay View 
	if (downloadingOverlayView ==nil) {
		UIActivityIndicatorView *downloadingIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		downloadingIndicator1.frame = CGRectMake(369,497, 30.0, 30.0);
		downloadingIndicator1.center = self.view.center;
		[downloadingIndicator1 startAnimating];
		
		if(screenHeig == 1024)
		{
			downloadingOverlayView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
		}
		else 
		{
			downloadingOverlayView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
		}
		
		[downloadingOverlayView setAlpha:0.85];
		[downloadingOverlayView setBackgroundColor:[UIColor grayColor]];
		[self.view  addSubview:downloadingOverlayView];
		[downloadingOverlayView addSubview:downloadingIndicator1];
		[downloadingIndicator1 release];
	}
	[downloadingOverlayView setHidden:TRUE];
	
	if(wallpaperScrollView.contentOffset.x==2*screenWidt) 
	{
		btnforward.hidden=YES;
	}
	else {
		btnforward.hidden=NO;
	}
	
	if(wallpaperScrollView.contentOffset.x==0)
	{
		btnbackward.hidden=YES;
	}
	else {
		btnbackward.hidden=NO;
	}
	
	if([strWallImgName isEqualToString:newWallImgName])
	{
		btnforward.hidden = TRUE;
		btnbackward.hidden=NO;
	}
	
	//[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	if (iSelectedImgIndex==1) {
        btnbackward.hidden=YES;
    }
    else{
        btnbackward.hidden=NO;
    }
    if (iSelectedImgIndex==totalImagesCount) {
        btnforward.hidden=YES;
    }
    else{
        btnforward.hidden=NO;
    }
//	if(wallpaperScrollView.contentOffset.x==2*screenWidt) 
//	{
//		btnforward.hidden=YES;
//	}
//	else {
//		btnforward.hidden=NO;
//	}
//	
//	if(wallpaperScrollView.contentOffset.x==0)
//	{
//		btnbackward.hidden=YES;
//	}
//	else {
//		btnbackward.hidden=NO;
//	}
	[self setBlurImage];
}



-(void)setBlurImage
{
	NSString *tmpThumbBGImgName;
	
	strCatDetails = [appDelegate.arrCatList objectAtIndex:iSelectedCatIndex];
	
	
	arrCatDetails = [[NSArray alloc]init];
	arrCatDetails = [strCatDetails  componentsSeparatedByString:appDelegate.strColDelimiter];
	
	if(loadingDone==FALSE)
	{
		
		tmpThumbBGImgName=[NSString stringWithFormat:@"%@_%@_%d.png",[arrCatDetails objectAtIndex:appDelegate.iCatIDIndex],appDelegate.str104by157Name,[[[self.selectedArray objectAtIndex:iSelectedImgIndex-1] objectForKey:@"id"] intValue]] ;
		if([appDelegate checkFileExist:tmpThumbBGImgName])
		{
			UIImage *bgImage= [appDelegate getImageFromDocFolder:tmpThumbBGImgName];
			
			blurImgView.image=bgImage;
			
			//[bgImage release];
			
		}
		else {
			blurImgView.image=nil;
		}
	}
	else {
		
		tmpThumbBGImgName=[NSString stringWithFormat:@"%@_%@_%d.png",[arrCatDetails objectAtIndex:appDelegate.iCatIDIndex],appDelegate.str104by157Name,[[[self.selectedArray objectAtIndex:newPositionCount-1] objectForKey:@"id"] intValue]] ;
		if([appDelegate checkFileExist:tmpThumbBGImgName])
		{
			UIImage *bgImage= [appDelegate getImageFromDocFolder:tmpThumbBGImgName];
			
			blurImgView.image=bgImage;
			
			//[bgImage release];
			
		}
		else {
			blurImgView.image=nil;
		}
	}
	
	//Added by Karpagarajan
	//	/********************************GOOGLE ANALYTICS CODE**************************************************/	
	//	[[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-25063363-1"
	//										   dispatchPeriod:kGANDispatchPeriodSec
	//												 delegate:nil];
	//	NSError *error1;
	//	
	//	if (![[GANTracker sharedTracker] setCustomVariableAtIndex:1
	//														 name:@"MaximGirls"
	//														value:@"iv1"
	//													withError:&error1]) {
	//		NSLog(@"error in setCustomVariableAtIndex");
	//	}
	//	
	//	
	//	if (![[GANTracker sharedTracker] trackEvent:@"MaximGirls"
	//										 action:[NSString stringWithFormat:@"Maxim Application Picture Action(%@-%@)",sCatTitle,tmpThumbBGImgName]
	//										  label:[NSString stringWithFormat:@"Maxim Application Picture Action(%@-%@)",sCatTitle,tmpThumbBGImgName]
	//										  value:99
	//									  withError:&error1]) {
	//		NSLog(@"error in trackEvent");
	//	}
	//	
	//	
	//	if (![[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"/%@",sCatTitle]
	//										 withError:&error1]) {
	//		NSLog(@"error in trackPageview");
	//	}
	//	/******************************************************************************************************/
	
}


//-(void)pageforward:(id)sender
//{
//	frwdBtnClicked = FALSE;
//
//	loadingDone=TRUE;
//	NSString *urlName;
//	
//	int nextImgIndex = 0;
//	NSLog(@"scroll %d",currentImg);
//	
//	if(currentImg < iTotalCatImages - 1)
//	{
//		walPaperImgView1.image = walPaperImgView2.image;
//		walPaperImgView2.image = walPaperImgView3.image;
//		
//		if(walPaperImgView2.image == nil)
//		{
//			nextImgIndex= currentImg +1;
//			imgToLoad = 2;
//		}
//		else 
//		{
//			nextImgIndex= currentImg +2;
//			imgToLoad = 3;
//			
//		}
//		currentImg=currentImg+1;
//		if(currentImg==iTotalCatImages)currentImg=iTotalCatImages-1;
//		else if (currentImg==1)currentImg=2;
//		
//		if(nextImgIndex!=0 )
//		{
//			
//			strCatDetails = [appDelegate.arrCatList objectAtIndex:iSelectedCatIndex];
//			arrCatDetails = [[NSArray alloc]init];
//			arrCatDetails = [strCatDetails  componentsSeparatedByString:appDelegate.strColDelimiter];
//			
//			imageName = [NSString stringWithFormat:@"upload/product/image/%@_%@_%d.jpg",[arrCatDetails objectAtIndex:appDelegate.iCatIDIndex],appDelegate.str320by480Name,nextImgIndex];
//			
//			NSString *strWallImgName = [imageName lastPathComponent];
//			
//			
//			//		if([appDelegate checkFileExist:strWallImgName])
//			//		{
//			//			UIImage *imgWallPaper = [appDelegate getImageFromDocFolder:strWallImgName];
//			//		}
//			//		else 
//			//		{
//			urlName = [appDelegate.strURL stringByAppendingString:imageName];
//			[self loadImageFromURL:urlName];
//			
//			//}
//		}
////		[wallpaperScrollView setContentOffset: CGPointMake( 768*(currentImg-1), 0 ) animated: YES ];
//	}
//}
//
//-(void)pagebackward:(id)sender
//{
//	backwdBtnClicked = FALSE;
//	NSLog(@"scroll %d",currentImg);
//	NSString *urlName;
//	
//	int nextImgIndex = 0;
//	
//	if(currentImg >=0)
//	{
//		nextImgIndex= currentImg -1;
//		[wallpaperScrollView setContentOffset: CGPointMake( 768*currentImg, 0 ) animated: YES ];
//		
//		if(nextImgIndex!=0 )
//		{
//			
//			strCatDetails = [appDelegate.arrCatList objectAtIndex:iSelectedCatIndex];
//			arrCatDetails = [[NSArray alloc]init];
//			arrCatDetails = [strCatDetails  componentsSeparatedByString:appDelegate.strColDelimiter];
//			
//			imageName = [NSString stringWithFormat:@"upload/product/image/%@_%@_%d.jpg",[arrCatDetails objectAtIndex:appDelegate.iCatIDIndex],appDelegate.str320by480Name,nextImgIndex];
//			
//			NSString *strWallImgName = [imageName lastPathComponent];
//			
//			
//			//		if([appDelegate checkFileExist:strWallImgName])
//			//		{
//			//			UIImage *imgWallPaper = [appDelegate getImageFromDocFolder:strWallImgName];
//			//		}
//			//		else 
//			//		{
//			urlName = [appDelegate.strURL stringByAppendingString:imageName];
//			[self loadImageFromURL:urlName];
//			
//			//}
//		}
//		if (currentImg>0)
//		{
//			currentImg=currentImg-1;
//		}
//	}
//}

-(void)actionSheetAction{
	
	UIActionSheet *aSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Tell a Friend",@"Tweet This",@"Facebook",@"Other Apps",nil];
	[aSheet showInView:self.view];
	[aSheet release];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	
	if(buttonIndex ==0)
	{
		[self emailact];
		
	}else if(buttonIndex ==1)
	{
		[self openTwitterPage];
		//[self twitteract];
		
	}
	else if(buttonIndex ==2)
	{
		[self facebtnact];
		
	}
	else if(buttonIndex ==3)
	{
		[[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"http://itunes.apple.com/us/artist/alpha-media-group-inc./id393395810"]];
		
	}
	//else 
//	{
//		[self dismissModalViewControllerAnimated:YES];
//		
	//}
	
}



-(void)action:(id)sender{
	UserClickedBack = YES;
	if(_TwitterOpened ==YES)
	{
		UserClickedBack = NO;
		_TwitterOpened =NO;
		//self.title = sCatTitle;
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
		[btn addTarget:self action:@selector(actionSheetAction) forControlEvents:UIControlEventTouchUpInside];
		
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
	[[appDelegate.tabBarController.viewControllers objectAtIndex:0] popToRootViewControllerAnimated:YES];
	//[self.navigationController popToViewController:[[self.navigationController viewControllers]objectAtIndex:1] animated:YES ];
}

-(void)saveImageAction{
	
	
	NSString *strImgName = [appDelegate.arrCatList objectAtIndex:iSelectedCatIndex];
	NSArray *arrImgName = [[NSArray alloc]init];
	arrImgName = [strImgName  componentsSeparatedByString:appDelegate.strColDelimiter];
	//	
	//	//strCatDetails = [appDelegate.arrCatList objectAtIndex:iSelectedCatIndex];
	////	
	////	
	////	arrCatDetails = [[NSArray alloc]init];
	////	arrCatDetails = [strCatDetails  componentsSeparatedByString:appDelegate.strColDelimiter];
	////	
	//	NSString *strPurchasedValue = [NSString stringWithFormat:@"%@",[arrImgName objectAtIndex:appDelegate.checkPurchasedValue]];
	//	
	//	
	//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	//	
	//	//[defaults setObject: data forKey: @"authData"];
	//	//[defaults synchronize];
	//	
	//	//purchase in app
	//	kInAppPurchaseProUpgradeProductId = [NSString stringWithFormat:@"maximwallpaperpackipadhd10%@",[ arrImgName objectAtIndex:appDelegate.iCatIDIndex]];
	//	
	//	NSString *currentProductID=[kInAppPurchaseProUpgradeProductId substringFromIndex:15];
	//	
	//	int purchseStatus=[defaults integerForKey:currentProductID];
	//	
	//	if( [strPurchasedValue floatValue]!=0 && purchseStatus!=111)
	//	{
	//		
	//		[self requestProUpgradeProductData];
	//		downloadingOverlayView.hidden=FALSE;
	//		return;
	//	}
	//	
	
	
	downloadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	downloadingIndicator.frame = CGRectMake(369,497, 30.0, 30.0);
	downloadingIndicator.center = self.view.center;
	[downloadingIndicator startAnimating];
	
	[self.view addSubview:downloadingIndicator];
	
	
	imageName = [NSString stringWithFormat:@"upload/product/image/%@_%@_%d.png",[arrImgName objectAtIndex:appDelegate.iCatIDIndex],appDelegate.str320by480Name,[[[self.selectedArray objectAtIndex:newPositionCount-1] objectForKey:@"id"] intValue]];
	NSString *urlName = [appDelegate.strURL stringByAppendingString:imageName];
	
	
	if([appDelegate checkFileExist:[urlName lastPathComponent]])
	{
		
		UIImage *bigImage= [appDelegate getImageFromDocFolder:[urlName lastPathComponent]];
		
		
		[downloadingIndicator removeFromSuperview];
		//UIImage *imgWallPaper = [UIImage imageWithData:data];
		
		UIImageWriteToSavedPhotosAlbum(bigImage,nil, nil, nil);
		UIAlertView  *alertView =[[UIAlertView alloc]initWithTitle:nil 
														   message:@" Image Saved To Albums, view the image in the Photos directory and select Use as Wallpaper" 
														  delegate:self cancelButtonTitle:@"OK" 
												 otherButtonTitles:nil];
		
		[alertView show];
		[alertView release];
		//[bigImage release];
		
		saveBtnValue = FALSE;
	}
	else {
		
		UIAlertView *status=[[UIAlertView alloc]initWithTitle:@"Downloading Hi Resolution image to your device, view the image in the Photos directory and select Use as Wallpaper" 
													  message:nil 
													 delegate:self 
											cancelButtonTitle:@"OK" 
											otherButtonTitles:nil];
		[status show];
		[status release];
		
		
		
		
		
	}
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView title] isEqualToString:@"Downloading Hi Resolution image to your device, view the image in the Photos directory and select Use as Wallpaper"]) {
        saveBtnValue = TRUE;
        NSString *strImgName = [appDelegate.arrCatList objectAtIndex:iSelectedCatIndex];
        NSArray *arrImgName = [[NSArray alloc]init];
        arrImgName = [strImgName  componentsSeparatedByString:appDelegate.strColDelimiter];
        imageName = [NSString stringWithFormat:@"upload/product/image/%@_%@_%d.png",[arrImgName objectAtIndex:appDelegate.iCatIDIndex],appDelegate.str320by480Name,[[[self.selectedArray objectAtIndex:newPositionCount-1] objectForKey:@"id"] intValue]];
        NSString *urlName = [appDelegate.strURL stringByAppendingString:imageName];
        [self loadImageFromURL:urlName];
    }
}


-(void)backButtonAction{
	UserClickedBack = YES;
	loadingDone =TRUE;
	//[connection cancel];
	[connection release];
	connection = nil;
	
	walPaperImgView1.image = nil;
	walPaperImgView2.image = nil;

	walPaperImgView3.image = nil;

	//[[appDelegate.tabBarController.viewControllers objectAtIndex:4] popToRootViewControllerAnimated:NO];
	//[self dismissModalViewControllerAnimated:YES];
		[self dismissModalViewControllerAnimated:YES];

	//[appDelegate.tabBarController popToViewController:[[appDelegate.tabBarController viewControllers]objectAtIndex:0] animated:YES ];
}

-(void)backBtnAction
{
	
	[loadImgView release];
	loadImgView=nil;
	[connection release];
	connection = nil;

	walPaperImgView1.image = nil;
	walPaperImgView2.image = nil;
	walPaperImgView3.image = nil;
	
	[wallpaperScrollView removeFromSuperview];
	[wallpaperScrollView release];
	
	for (UIView *view in [self.view subviews])
	{
		[view removeFromSuperview];
	}
	
	[self dismissModalViewControllerAnimated:YES];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}





- (void)loadImageFromURL:(NSString*)url 
{
	
	if([appDelegate checkFileExist:[url lastPathComponent]])
	{
        NSLog(@"fit iamge url from local%@",url);
		//UIImage *bigImage= [appDelegate getImageFromDocFolder:[url lastPathComponent]];
		//[bigImage release];
		//bigImage=nil;

		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		UIImage *bigImage= [UIImage imageWithData:[NSData dataWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:[url lastPathComponent]]]];
		
		
		
		if(viewJustLoaded==TRUE)
		{
			
			walPaperImgView1.image=nil;
			walPaperImgView2.image=nil;
			walPaperImgView3.image=nil;
			
			viewJustLoaded=FALSE;
			
		}
		
		
		int nextImgIndex = 0;
		NSString *urlName;
		
		
		
		
		{
			if(loadingDone == FALSE)
			{
				
				if(iSelectedImgIndex == 1)
				{
					
					currentImg = 1;
					
					if(imgToLoad == 1)
					{
						walPaperImgView1.image = bigImage;
						scrollViewScrollDetectionEnabled=FALSE;
						[wallpaperScrollView setContentOffset:CGPointMake(0, 0)];
						scrollViewScrollDetectionEnabled=TRUE;
						imgToLoad = 2;
						nextImgIndex = 2;
						if (iTotalCatImages==1) loadingDone = TRUE;
						
					}
					else if(imgToLoad == 2)
					{
						walPaperImgView2.image = bigImage;
						//[wallpaperScrollView setContentOffset:CGPointMake(0, 0)];
						imgToLoad = 3;
						nextImgIndex = 3;
                        if (iTotalCatImages==2) loadingDone = TRUE;
						
					}
					else if(imgToLoad == 3)
					{
						walPaperImgView3.image = bigImage;
						//[wallpaperScrollView setContentOffset:CGPointMake(0, 0)];
						imgToLoad = 0;
						nextImgIndex = 0;
						loadingDone = TRUE;
						
					}
					
				}
                else if(iSelectedImgIndex == 2 && iTotalCatImages==2)
				{
					
					currentImg = iSelectedImgIndex;
					if(imgToLoad == 1)
					{
                        walPaperImgView2.image = bigImage;
						[wallpaperScrollView setContentOffset:CGPointMake(screenWidt, 0)];
						imgToLoad = 2;
						nextImgIndex = iTotalCatImages-1;
					}
					else if(imgToLoad == 2)
					{
                        walPaperImgView1.image = bigImage;
						//[frameScrollView setContentOffset:CGPointMake(640, 0)];
						imgToLoad = 0;
						nextImgIndex = 0;
						loadingDone = TRUE;
					}
                    
					
				}
				else if(iSelectedImgIndex == iTotalCatImages)
				{
					
					currentImg = iSelectedImgIndex;
					if(imgToLoad == 1)
					{
						walPaperImgView3.image = bigImage;
						scrollViewScrollDetectionEnabled=FALSE;
						[wallpaperScrollView setContentOffset:CGPointMake(screenWidt*2, 0)];
						scrollViewScrollDetectionEnabled=TRUE;
						imgToLoad = 2;
						nextImgIndex = iTotalCatImages-1;
					}
					else if(imgToLoad == 2)
					{
						walPaperImgView2.image = bigImage;
						//[wallpaperScrollView setContentOffset:CGPointMake(640, 0)];
						imgToLoad = 3;
						nextImgIndex = iTotalCatImages-2;
					}
					else if(imgToLoad == 3)
					{
						walPaperImgView1.image = bigImage;
						//[wallpaperScrollView setContentOffset:CGPointMake(640, 0)];
						imgToLoad = 0;
						nextImgIndex = 0;
						loadingDone = TRUE;
					}
					
				}
				else 
				{
					
					currentImg = iSelectedImgIndex;
					if(imgToLoad == 1)
					{
						walPaperImgView2.image = bigImage;
						scrollViewScrollDetectionEnabled=FALSE;
						[wallpaperScrollView setContentOffset:CGPointMake(screenWidt, 0)];
						scrollViewScrollDetectionEnabled=TRUE;
						
						imgToLoad = 2;
						nextImgIndex = iSelectedImgIndex+1;
					}
					else if(imgToLoad == 2)
					{
						walPaperImgView3.image = bigImage;
						//[wallpaperScrollView setContentOffset:CGPointMake(640, 0)];
						imgToLoad = 3;
						nextImgIndex = iSelectedImgIndex-1;
					}
					else if(imgToLoad == 3)
					{
						walPaperImgView1.image = bigImage;
						//[wallpaperScrollView setContentOffset:CGPointMake(640, 0)];
						imgToLoad = 0;
						nextImgIndex = 0;
						loadingDone = TRUE;
					}
				}
			}
			
			else {
				
				if(imgToLoad == 1)
				{
					walPaperImgView1.image = bigImage;
					imgToLoad = 0;
					nextImgIndex = 0;
				}
				else if(imgToLoad == 2)
				{
					if(swipedLeft)
					{
						walPaperImgView2.image =bigImage;
						imgToLoad = 1;
						nextImgIndex = currentImg-1;
					}
					else
					{
						walPaperImgView2.image = bigImage;
						imgToLoad = 3;
						nextImgIndex = currentImg+1;
					}
				}
				else if(imgToLoad == 3)
				{
					walPaperImgView3.image = bigImage;
					imgToLoad = 0;
					nextImgIndex = 0;
				}
				
			}
			
		}
		
		//[bigImage release];
		
		
		//		NSString *strDescription;
		//		UIImage *imgData ;
		//		
		//		imgData = [UIImage imageWithData:data];
		//		strDescription = url;
		//		
		//		NSString *last = [strDescription lastPathComponent];
		//		NSString *wallPaperImg = [last stringByReplacingOccurrencesOfString:@">" withString:@""];
		//[appDelegate imageSaveToDocumentPath:imgData :wallPaperImg];
		
		
		if(nextImgIndex!=0 && nextImgIndex <= iTotalCatImages){
			
			strCatDetails = [appDelegate.arrCatList objectAtIndex:iSelectedCatIndex];
			
			
			arrCatDetails = [[NSArray alloc]init];
			arrCatDetails = [strCatDetails  componentsSeparatedByString:appDelegate.strColDelimiter];
			
			
			imageName = [NSString stringWithFormat:@"upload/product/image/%@_%@_%d.png",[arrCatDetails objectAtIndex:appDelegate.iCatIDIndex],appDelegate.str320by480Name,[[[self.selectedArray objectAtIndex:nextImgIndex-1] objectForKey:@"id"] intValue]];
            NSLog(@"load image url%@",imageName);
			//NSString *strWallImgName = [imageName lastPathComponent];
			
			
			//	if([appDelegate checkFileExist:strWallImgName])
			//	{
			//		UIImage *imgWallPaper = [appDelegate getImageFromDocFolder:strWallImgName];
			//	}
			//	else  
			//	{
			
			urlName = [appDelegate.strURL stringByAppendingString:imageName];
            
			[self loadImageFromURL:urlName];
			
			//}
			
			
			//			NSLog(@"scroll view content offset : %d",wallpaperScrollView.contentOffset.x);
			
			//			if(iSelectedImgIndex==1)
			//				[wallpaperScrollView setContentOffset:CGPointMake(0, 0)];
			//			else if(iSelectedImgIndex==iTotalCatImages)
			//				[wallpaperScrollView setContentOffset:CGPointMake(2*screenWidt, 0)];
			//			else
			//				[wallpaperScrollView setContentOffset:CGPointMake(screenWidt, 0)];
			
		}
	}
	else
	{
		NSLog(@"fit iamge url from server%@",url);
		
		NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
												 cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:180.0];
		
		connection =  [[NSURLConnection alloc]initWithRequest:request delegate:self];
		
		
		if(data != nil)
		{
			[data release];
			data=nil;
		}
		
	}
	
	
	
	
	
}



- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData 
{ 
	
	if(theConnection!=connection)
	{
		//		if(theConnection!=nil)
		//		{	NSLog(@"releasing theconnection didReceiveData");
		//		   [theConnection release];
		//			theConnection=nil;
		//		   NSLog(@"released theconnection didReceiveData");
		//		}
		return;
	}
	
	if (data==nil) 
	{
		data = [[NSMutableData alloc] initWithCapacity:2048];
    }
	
    [data appendData:incrementalData];
	
	
}


- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection 
{
	NSLog(@"CDFL - WALLPPRSRCN - %@",[theConnection description]);
	
	if(theConnection!=connection)
	{
		//		if(theConnection!=nil)
		//		{	NSLog(@"releasing theconnection connectionDidFinishLoading");
		//			//[theConnection release];
		//			theConnection=nil;
		//			NSLog(@"released theconnection connectionDidFinishLoading");
		//		}
		return;
	}
	
	
	
	if(viewJustLoaded==TRUE)
	{
		
		walPaperImgView1.image=nil;
		walPaperImgView2.image=nil;
		walPaperImgView3.image=nil;
		
		viewJustLoaded=FALSE;
		
	}
	
	
	int nextImgIndex = 0;
	NSString *urlName;
	
	
	if(saveBtnValue == TRUE)
	{
		
		[downloadingIndicator removeFromSuperview];
		UIImage *imgWallPaper = [UIImage imageWithData:data];
		
		UIImageWriteToSavedPhotosAlbum(imgWallPaper,nil, nil, nil);
		UIAlertView  *alertView =[[UIAlertView alloc]initWithTitle:nil 
														   message:@" Image Saved To Albums" 
														  delegate:self cancelButtonTitle:@"OK" 
												 otherButtonTitles:nil];
		
		[alertView show];
		[alertView release];
		//[imgWallPaper release];
		
		saveBtnValue = FALSE;
	}
	else
	{
		if(loadingDone == FALSE)
		{
			
			if(iSelectedImgIndex == 1)
			{
				
				currentImg = 1;
				
				if(imgToLoad == 1)
				{
					walPaperImgView1.image = [UIImage imageWithData:data];
					scrollViewScrollDetectionEnabled=FALSE;
					[wallpaperScrollView setContentOffset:CGPointMake(0, 0)];
					scrollViewScrollDetectionEnabled=TRUE;
					imgToLoad = 2;
					nextImgIndex = 2;
					
					
				}
				else if(imgToLoad == 2)
				{
					walPaperImgView2.image = [UIImage imageWithData:data];
					//[wallpaperScrollView setContentOffset:CGPointMake(0, 0)];
					imgToLoad = 3;
					nextImgIndex = 3;
					
				}
				else if(imgToLoad == 3)
				{
					walPaperImgView3.image = [UIImage imageWithData:data];
					//[wallpaperScrollView setContentOffset:CGPointMake(0, 0)];
					imgToLoad = 0;
					nextImgIndex = 0;
					loadingDone = TRUE;
					
				}
				
			}
            else if(iSelectedImgIndex == 2 && iTotalCatImages==2)
            {
                
                currentImg = iSelectedImgIndex;
                if(imgToLoad == 1)
                {
                    walPaperImgView2.image = [UIImage imageWithData:data];
                    [wallpaperScrollView setContentOffset:CGPointMake(screenWidt, 0)];
                    imgToLoad = 2;
                    nextImgIndex = iTotalCatImages-1;
                }
                else if(imgToLoad == 2)
                {
                    walPaperImgView1.image = [UIImage imageWithData:data];
                    //[frameScrollView setContentOffset:CGPointMake(640, 0)];
                    imgToLoad = 0;
                    nextImgIndex = 0;
                    loadingDone = TRUE;
                }
                
                
            }
			else if(iSelectedImgIndex == iTotalCatImages)
			{
				
				currentImg = iSelectedImgIndex;
				if(imgToLoad == 1)
				{
					walPaperImgView3.image = [UIImage imageWithData:data];
					scrollViewScrollDetectionEnabled=FALSE;
					[wallpaperScrollView setContentOffset:CGPointMake(screenWidt*2, 0)];
					scrollViewScrollDetectionEnabled=TRUE;
					imgToLoad = 2;
					nextImgIndex = iTotalCatImages-1;
				}
				else if(imgToLoad == 2)
				{
					walPaperImgView2.image = [UIImage imageWithData:data];
					//[wallpaperScrollView setContentOffset:CGPointMake(640, 0)];
					imgToLoad = 3;
					nextImgIndex = iTotalCatImages-2;
				}
				else if(imgToLoad == 3)
				{
					walPaperImgView1.image = [UIImage imageWithData:data];
					//[wallpaperScrollView setContentOffset:CGPointMake(640, 0)];
					imgToLoad = 0;
					nextImgIndex = 0;
					loadingDone = TRUE;
				}
				
			}
			else 
			{
				
				currentImg = iSelectedImgIndex;
				if(imgToLoad == 1)
				{
					walPaperImgView2.image = [UIImage imageWithData:data];
					scrollViewScrollDetectionEnabled=FALSE;
					[wallpaperScrollView setContentOffset:CGPointMake(screenWidt, 0)];
					scrollViewScrollDetectionEnabled=TRUE;
					
					imgToLoad = 2;
					nextImgIndex = iSelectedImgIndex+1;
				}
				else if(imgToLoad == 2)
				{
					walPaperImgView3.image = [UIImage imageWithData:data];
					//[wallpaperScrollView setContentOffset:CGPointMake(640, 0)];
					imgToLoad = 3;
					nextImgIndex = iSelectedImgIndex-1;
				}
				else if(imgToLoad == 3)
				{
					walPaperImgView1.image = [UIImage imageWithData:data];
					//[wallpaperScrollView setContentOffset:CGPointMake(640, 0)];
					imgToLoad = 0;
					nextImgIndex = 0;
					loadingDone = TRUE;
				}
				
				
			}
			
			
			
		}
		
		else {
			
			if(imgToLoad == 1)
			{
				walPaperImgView1.image = [UIImage imageWithData:data];
				imgToLoad = 0;
				nextImgIndex = 0;
			}
			else if(imgToLoad == 2)
			{
				if(swipedLeft)
				{
					walPaperImgView2.image = [UIImage imageWithData:data];
					imgToLoad = 1;
					nextImgIndex = currentImg-1;
				}
				else
				{
					walPaperImgView2.image = [UIImage imageWithData:data];
					imgToLoad = 3;
					nextImgIndex = currentImg+1;
				}
			}
			else if(imgToLoad == 3)
			{
				walPaperImgView3.image = [UIImage imageWithData:data];
				imgToLoad = 0;
				nextImgIndex = 0;
			}
			
		}
		
	}
	NSString *strDescription;
	UIImage *imgData ;
	
	imgData = [UIImage imageWithData:data];
    if ([[[UIDevice currentDevice] systemVersion] intValue]>=5) {
        strDescription = theConnection.originalRequest.URL.absoluteString;
    }
    else{
        strDescription = theConnection.description;
    }
	
    NSLog(@"%@",strDescription);
	
	NSString *last = [strDescription lastPathComponent];
	NSString *wallPaperImg = [last stringByReplacingOccurrencesOfString:@">" withString:@""];
	[appDelegate imageSaveToDocumentPath:imgData :wallPaperImg];
	
	
	if(nextImgIndex!=0 && nextImgIndex <= iTotalCatImages){
		
		strCatDetails = [appDelegate.arrCatList objectAtIndex:iSelectedCatIndex];
		
		
		arrCatDetails = [[NSArray alloc]init];
		arrCatDetails = [strCatDetails  componentsSeparatedByString:appDelegate.strColDelimiter];
		
		
		imageName = [NSString stringWithFormat:@"upload/product/image/%@_%@_%d.png",[arrCatDetails objectAtIndex:appDelegate.iCatIDIndex],appDelegate.str320by480Name,[[[self.selectedArray objectAtIndex:nextImgIndex-1] objectForKey:@"id"] intValue]];
        NSLog(@"image url%@",imageName);
		//NSString *strWallImgName = [imageName lastPathComponent];
		
		
		//	if([appDelegate checkFileExist:strWallImgName])
		//	{
		//		UIImage *imgWallPaper = [appDelegate getImageFromDocFolder:strWallImgName];
		//	}
		//	else 
		//	{
		urlName = [appDelegate.strURL stringByAppendingString:imageName];
		[self loadImageFromURL:urlName];
		
		//}
		
		
		
	}
	[data release];
    data=nil;
    NSLog(@"releasing connection connectionDidFinishLoading");
	[connection release];
	NSLog(@"released connection connectionDidFinishLoading");
	connection=nil;
	
}


-(void)connection:(NSURLConnection *)connection1  didFailWithError:(NSError *)error 
{
	NSLog(@"connection failed");
	downloadingIndicator.hidden = YES;
	loadImgView.hidden = YES;
	UIAlertView* statusAlert = [[UIAlertView alloc] initWithTitle:@"Alert" 
														  message:@"Could not connect to the internet. Please try again later"delegate:self 
												cancelButtonTitle: @"Ok"
												otherButtonTitles:nil];
	[statusAlert show];
	[statusAlert release];
	
	NSLog(@"releasing connection didFail");
	[connection release];
	connection=nil;
	NSLog(@"released connection didFail");
}	



-(void)pageforward:(id)sender
{

	if(wallpaperScrollView.contentOffset.x>=2*self.view.frame.size.width) 
	{
		
		return;
	}
	//btnforward.hidden=NO;
	[wallpaperScrollView setContentOffset:CGPointMake(wallpaperScrollView.contentOffset.x+self.view.frame.size.width, 0)];
	
	
	[self scrollViewDidEndDecelerating:wallpaperScrollView];
	
}
-(void)pagebackward:(id)sender
{
	if(wallpaperScrollView.contentOffset.x<=0) return;
	
	[wallpaperScrollView setContentOffset:CGPointMake(wallpaperScrollView.contentOffset.x-self.view.frame.size.width, 0)];
	
	
	[self scrollViewDidEndDecelerating:wallpaperScrollView];
	
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if(scrollViewScrollDetectionEnabled==FALSE)return;
	if(viewLoadedCompletely==FALSE)return;
	loadingDone=TRUE;
	blurImgView.image=nil;	
	
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scroll
{
	
	
	
	//if(loadingDone==FALSE)return;
	
	loadingDone=TRUE;
	NSString *urlName;
	
	int nextImgIndex = 0;
	NSLog(@"scrooll %d",currentImg);
	
	if(scroll.contentOffset.x == 0){
		swipedLeft = TRUE;
		
		if(currentImg >2)
		{
			walPaperImgView3.image = walPaperImgView2.image;
			walPaperImgView2.image = walPaperImgView1.image;
			
			
			
			if(walPaperImgView2.image == nil)
			{
				nextImgIndex= currentImg -1;
				imgToLoad = 2;
			}
			else 
			{
				nextImgIndex= currentImg -2;
				imgToLoad = 1;
				
			}
			
			scrollViewScrollDetectionEnabled=FALSE;
			[scroll setContentOffset:CGPointMake(screenWidt, 0)];
			scrollViewScrollDetectionEnabled=TRUE;
			currentImg = currentImg -1;
			walPaperImgView1.image = nil;
			
			
		}
	}
	
	else if(scroll.contentOffset.x == screenWidt*2){
		swipedLeft = FALSE;
		
		if(currentImg < iTotalCatImages - 1)
		{
			walPaperImgView1.image = walPaperImgView2.image;
			walPaperImgView2.image = walPaperImgView3.image;
			
			if(walPaperImgView2.image == nil)
			{
				nextImgIndex= currentImg +1;
				imgToLoad = 2;
			}
			else 
			{
				nextImgIndex= currentImg +2;
				imgToLoad = 3;
				
			}
			
			scrollViewScrollDetectionEnabled=FALSE;
			[scroll setContentOffset:CGPointMake(screenWidt, 0)];
			scrollViewScrollDetectionEnabled=TRUE;
			
			currentImg = currentImg +1;
			walPaperImgView3.image = nil;
			
			
		}
	}
	else if(scroll.contentOffset.x == screenWidt){
		
		if(currentImg==iTotalCatImages)currentImg=iTotalCatImages-1;
		else if (currentImg==1)currentImg=2;
		
		
	}
	
	
	
	if(nextImgIndex!=0 && nextImgIndex <= iTotalCatImages)
	{
		
		strCatDetails = [appDelegate.arrCatList objectAtIndex:iSelectedCatIndex];
		arrCatDetails = [[NSArray alloc]init];
		arrCatDetails = [strCatDetails  componentsSeparatedByString:appDelegate.strColDelimiter];
		
		imageName = [NSString stringWithFormat:@"upload/product/image/%@_%@_%d.png",[arrCatDetails objectAtIndex:appDelegate.iCatIDIndex],appDelegate.str320by480Name,[[[self.selectedArray objectAtIndex:nextImgIndex-1] objectForKey:@"id"] intValue]];
		
		//NSString *strWallImgName = [imageName lastPathComponent];
		
		
		//		if([appDelegate checkFileExist:strWallImgName])
		//		{
		//			UIImage *imgWallPaper = [appDelegate getImageFromDocFolder:strWallImgName];
		//		}
		//		else 
		//		{
		urlName = [appDelegate.strURL stringByAppendingString:imageName];
		[self loadImageFromURL:urlName];
		
		//}
	}
	
	newPositionCount=currentImg;
	
	
	if(scroll.contentOffset.x==0)newPositionCount=1;
	if(scroll.contentOffset.x==2*screenWidt)newPositionCount=iTotalCatImages;
	
		if(wallpaperScrollView.contentOffset.x==2*screenWidt) 
		{
			btnforward.hidden=YES;
			
		}
		else {
			btnforward.hidden=NO;
		}
		
		if(wallpaperScrollView.contentOffset.x==0)
		{
			btnbackward.hidden=YES;
		}
		else {
			btnbackward.hidden=NO;
		}
		
	

	NSLog(@"new Position Count = %d",newPositionCount);
	[self setBlurImage];
	
	
	
}







- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    	//NSLog(@" didReceiveMemoryWarning in WallPaperScreenVC "); 
    // Release any cached data, images, etc that aren't in use.
	
//	UIAlertView *alert = [[UIAlertView alloc] 
//						  initWithTitle:@"Warning" 
//						  message:@"You are running out of memory" 
//						  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//	[alert show];
//	[alert release];
	
}

- (void)viewDidAppear:(BOOL)animated
{
	
	viewLoadedCompletely=TRUE;
	
	
}

-(void)viewDidDisappear:(BOOL)animated
{
	if (UserClickedBack ==NO) {
		return;
	}
	
	//walPaperImgView1.image=nil;
	
	if(connection!=nil)
	{
		
		//[connectionForWallPaper cancel];
		[connection release];
		connection =nil;
		
	}
	
	if(data!=nil)
	{
		
		//[connectionForWallPaper cancel];
		[data release];
		data =nil;
		
	}
	
	
	[walPaperImgView1 removeFromSuperview];
	[walPaperImgView2 removeFromSuperview];
	[walPaperImgView3 removeFromSuperview];
	
	[walPaperImgView1 release];
	[walPaperImgView2 release];
	[walPaperImgView3 release];
	
	for(UIView *s in wallpaperScrollView.subviews)
	{
		[s removeFromSuperview];
		
	}
	if (imageToSave !=nil) {
		[imageToSave release];
		imageToSave = nil;
	}
	//if (totalImages>3) {
	//		[previousImageView release];
	//		[nextImageView release];
	//		[currentImageView release];
	//	}
	
	
	[wallpaperScrollView removeFromSuperview];
	
	[wallpaperScrollView release];
	
	if (twitterTextField !=nil) {
		[twitterTextField release];
		twitterTextField =nil;
	}
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
}





- (void)dealloc {
    [super dealloc];
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

//- (void)adWhirlDidReceiveAd:(AdWhirlView *)adWhirlView {
//    /*self.label.text = [NSString stringWithFormat:
//     @"Got ad from %@",
//     [adWhirlView mostRecentNetworkName]];*/
//}
//
//- (void)adWhirlDidFailToReceiveAd:(AdWhirlView *)adWhirlView usingBackup:(BOOL)yesOrNo {
//    /*self.label.text = [NSString stringWithFormat:
//     @"Failed to receive ad from %@, %@. Error: %@",
//     [adWhirlView mostRecentNetworkName],
//     yesOrNo? @"will use backup" : @"will NOT use backup",
//     adWhirlView.lastError == nil? @"no error" : [adWhirlView.lastError localizedDescription]];*/
//    //[adView requestFreshAd];
//}
//
//- (void)adWhirlReceivedRequestForDeveloperToFufill:(AdWhirlView *)adWhirlView {
//    UILabel *replacement = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, screenWidt, screenHeig)];
//    replacement.backgroundColor = [UIColor blackColor];
//    replacement.textColor = [UIColor whiteColor];
//    replacement.textAlignment = UITextAlignmentCenter;
//    replacement.text = @"Visit EliteGudz.com now !";
//    [adWhirlView replaceBannerViewWith:replacement];
//    [replacement release];
//    //self.label.text = @"Generic Notification";
//}
//
//- (void)adWhirlReceivedNotificationAdsAreOff:(AdWhirlView *)adWhirlView {
//    //self.label.text = @"Ads are off";
//	
//}
//
//- (void)adWhirlWillPresentFullScreenModal {
//   // NSLog(@"SimpleView: will present full screen modal");
//}
//
//- (void)adWhirlDidDismissFullScreenModal {
//   // NSLog(@"SimpleView: did dismiss full screen modal");
//}
//
//- (void)adWhirlDidReceiveConfig:(AdWhirlView *)adWhirlView {
//    //self.label.text = @"Received config. Requesting ad...";
//}
//
//- (CLLocation *)locationInfo {
//    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
//    CLLocation *location = [locationManager location];
//    [locationManager release];
//    return location;
//}

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
	
//    NSSet *allTouches = [event allTouches];
//    UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
//    CGPoint tempPoint=[touch locationInView:self.view];
//	
//    if(tempPoint.y>=screenHeig-50)
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.com/apps/zaahtechnologiesinc"]];
}



- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	
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
	UIAlertView *status=[[UIAlertView alloc]initWithTitle:@"Tweet Posted successfully" 
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
	//self.navigationController.navigationBarHidden = TRUE;
	_TwitterOpened = YES;
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Post", @selector(twitteract));

	self.title = @"Tweet This";

	twitterView = [[UIView alloc]initWithFrame:CGRectMake(0,0, screenWidt, screenHeig)];
	UIImage  *img  = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Twitter" ofType:@"jpg"]];
	UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, screenWidt, screenHeig)];
	imageView.image = img;
	
	
	twitterTextField = [[UITextView alloc] initWithFrame:CGRectMake(10,100, screenWidt-20, 200)];
	
    twitterTextField.textColor = [UIColor blackColor];
	
    twitterTextField.font = [UIFont fontWithName:@"Arial" size:18];
	
    twitterTextField.delegate = self;
	
    twitterTextField.backgroundColor = [UIColor whiteColor];
	
  //  twitterTextField.placeholder = @"Enter Text To Tweet";
	
 //   twitterTextField.returnKeyType = UIReturnKeyDefault;
	
   // twitterTextField.keyboardType = UIKeyboardTypeDefault; 
	twitterTextField.text =@"I hooked up my phone with the Graffiti Wallpapers HD App. Check it. http://itunes.com/apps/zaahtechnologiesinc";
	
    twitterTextField.scrollEnabled = YES;
	
    twitterTextField.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	
	//twitterTextField = [[UITextField alloc] initWithFrame:CGRectMake(10,100, 300, 200)];
//	twitterTextField.borderStyle = UITextBorderStyleRoundedRect;
//	twitterTextField.textColor = [UIColor blackColor]; //text color
//	twitterTextField.font = [UIFont systemFontOfSize:17.0];  //font size
//	twitterTextField.placeholder = @"Enter Text To Tweet";  //place holder
//	twitterTextField.backgroundColor = [UIColor clearColor]; //background color
//	twitterTextField.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
//	twitterTextField.
//	twitterTextField.keyboardType = UIKeyboardTypeDefault;  // type of the keyboard
//	twitterTextField.returnKeyType = UIReturnKeyDone;  // type of the return key
//	
//	twitterTextField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
//	twitterTextField.delegate = self;
	
	[twitterView addSubview:imageView];
	
	
	[twitterView addSubview:twitterTextField];
	
	[self.view addSubview:twitterView];
	[img release];
	[imageView release];
	
	//[twitterTextField release];
	
	//[twitterView release];
	
	
}



-(IBAction)twitteract {
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
	_TwitterOpened = NO;
			self.title = sCatTitle;
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
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"]) {
		
		[textView resignFirstResponder];
		
	}
    return YES;
	
}


//-(IBAction)facebtnact{
//	_permissions =  [[NSArray arrayWithObjects: @"read_stream",@"user_photos",@"user_videos",@"publish_stream ",nil] retain];
//	_facebook = [[Facebook alloc] init];
//	
//	if(appDelegate.facebookLogin == TRUE)
//	{
//		appDelegate.facebookLogin = FALSE;
//		[_facebook logout:self];
//	}
//	[_facebook authorize:kAppId permissions:_permissions delegate:self];
//
//
//}
//
//
//-(void) fbDidLogin {
//	NSLog(@"did  login");
//	
//	
//	//UIImage  *img  = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Fol3Image2" ofType:@"jpg"]];
////	NSData *dataObj = UIImageJPEGRepresentation(img, 1.0);
////	
////	NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:dataObj, @"picture",
////									@"my pencil",@"caption",nil];
////	
////	
////	[_facebook requestWithMethodName: @"facebook.photos.upload" 
////						   andParams: params
////					   andHttpMethod: @"POST" 
////						 andDelegate: self]; 
//	
//	
//		[self publishStream];
//
//	
//	
//}
//
//- (void) publishStream{
//	
//	SBJSON *jsonWriter = [[SBJSON new] autorelease];
//	
//	NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys: 
//														   @"Always Running",@"text",@"http://itsti.me/",@"href", nil], nil];
//	
//	NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
//	NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
//								@"I hooked up my phone with the Graffiti Wallpapers HD App. Check it. ", @"name",@"http://itunes.apple.com/us/app/graffiti-wallpaper-hd/id408863271?mt=8",@"caption",nil];//@"http://itunes.com/elitegudz/",@"href", nil];
//	NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
//	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//								   kAppId, @"api_key",
//								   @"Share on Facebook",@"user_message_prompt",
//								   
//								   attachmentStr, @"attachment",
//								   nil];	
//	
//	
//	[_facebook dialog: @"stream.publish"
//			andParams: params
//		  andDelegate:self];
//	
//}
//
//- (void)fbDidNotLogin:(BOOL)cancelled {
//	NSLog(@"did not login");
//	
//	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Unable To Login" 
//											  message:nil 
//											 delegate:self 
//									cancelButtonTitle:@"OK" 
//									otherButtonTitles:nil];
//	[fb show];
//	[fb release];
//}
//
///**
// * Callback for facebook logout
// */ 
//-(void) fbDidLogout {
//	
//	//	[_facebook release];
//	
//	
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//// FBRequestDelegate
//
///**
// * Callback when a request receives Response
// */ 
//- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response{
//	
//	NSLog(@"received response  %@",response );
//	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Success" 
//											  message:@"Your Image Posted" 
//											 delegate:self 
//									cancelButtonTitle:@"OK" 
//									otherButtonTitles:nil];
//	[fb show];
//	[fb release];
//	
//}
//
///**
// * Called when an error prevents the request from completing successfully.
// */
//- (void)request:(FBRequest*)request didFailWithError:(NSError*)error{
//	NSLog(@"%@",error);
//	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Unable To Connect" 
//											  message:nil 
//											 delegate:self 
//									cancelButtonTitle:@"OK" 
//									otherButtonTitles:nil];
//	[fb show];
//	[fb release];
//	
//	
//}

/**
 * Called when a request returns and its response has been parsed into an object.
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on thee format of the API response.
 */
//- (void)request:(FBRequest*)request didLoad:(id)result {
//	
//	
//	
//	NSLog(@"result is ---- %d",result );
//	[_facebook logout:self];
//	
//	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Logged Out" 
//											  message:nil 
//											 delegate:self 
//									cancelButtonTitle:@"OK" 
//									otherButtonTitles:nil];
//	[fb show];
//	[fb release];
//}
//




///////////////////////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/** 
 * Called when a UIServer Dialog successfully return
 */
//- (void)dialogDidComplete:(FBDialog*)dialog withPost:(NSString *)currentPostID{
//	NSLog(@"feed to delete and %@ rrrr ", currentPostID);
//	
//	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Message posted successfully" 
//											  message:nil 
//											 delegate:self 
//									cancelButtonTitle:@"OK" 
//									otherButtonTitles:nil];
//	[fb show];
//	[fb release];
//}



-(IBAction)emailact{
	
	MFMailComposeViewController *controller= [[MFMailComposeViewController alloc] init];
	
	
	controller.mailComposeDelegate = self;
	
	[controller setSubject:@"I hooked up my phone with the Graffiti Wallpapers HD App. Check it."];
	
	//	UIImage *roboPic = [self getphotofrompaint];//[UIImage imageWithContentsOfFile:dataFilePath];
	//	NSData *imageData = UIImagePNGRepresentation(roboPic);
	// 	[controller addAttachmentData:imageData mimeType:@"image/png" fileName:@"concreteImmortalz.png"];
	NSString *emailBody = @"http://itunes.apple.com/us/artist/alpha-media-group-inc./id393395810";
	[controller setMessageBody:emailBody isHTML:NO]; 
	//UIImage  *img  = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Fol3Image2" ofType:@"jpg"]];
//	NSData *dataObj = UIImageJPEGRepresentation(img, 1.0);
//	
//
//	[controller addAttachmentData:dataObj mimeType:@"image/jpg" fileName:@"HDWallpaper"];
	if(controller!=nil)
	{
	[self presentModalViewController:(UIViewController*)controller animated:YES];
	}
//	[img release];
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


//********************************inapppurchase

//- (void)requestProUpgradeProductData
//{
//	NSSet *productIdentifiers = [NSSet setWithObject:kInAppPurchaseProUpgradeProductId ];
//	productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
//	productsRequest.delegate = self;
//	[productsRequest start];
//	
//	// we will release the request object in the delegate callback
//}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	NSArray *products = response.products;
	proUpgradeProduct = [products count] == 1 ? [[products objectAtIndex:0] retain] : nil;
	
	if (proUpgradeProduct)
	{
		NSLog(@"Product title: %@" , proUpgradeProduct.localizedTitle);
		NSLog(@"Product description: %@" , proUpgradeProduct.localizedDescription);
		NSLog(@"Product price: %@" , proUpgradeProduct.price);
		NSLog(@"Product id: %@" , proUpgradeProduct.productIdentifier);
		
		//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"title:%@, desc:%@, price:%@, id:%@",proUpgradeProduct.localizedTitle,proUpgradeProduct.localizedDescription,proUpgradeProduct.price,proUpgradeProduct.productIdentifier] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		//[alert show]; 
		//[alert release];
		
		if([self canMakePurchases]==YES)
			[self purchaseProUpgrade]; 
		else {
			[downloadingOverlayView setHidden:TRUE];
		}

		
	}
	
	for (NSString *invalidProductId in response.invalidProductIdentifiers)
	{
		NSLog(@"Invalid product id: %@" , invalidProductId);
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Unable to purchase the wallpaper pack with id : %@",invalidProductId] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		[alert show]; 
		[alert release];
		[downloadingOverlayView setHidden:TRUE];
		
	}
	
	// finally release the reqest we alloc/init’ed in requestProUpgradeProductData
	[productsRequest release];
	
	//[[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

/*
 - (void)request:(SKRequest *)request didFailWithError:(NSError *)error
 {
 
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"ERROR : %@" , [error description] ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
 //[alert show]; 
 [alert release];
 [downloadingOverlayView setHidden:TRUE];
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
//- (void)purchaseProUpgrade
//{
//	SKPayment *payment = [SKPayment paymentWithProductIdentifier:kInAppPurchaseProUpgradeProductId];
//	[[SKPaymentQueue defaultQueue] addPayment:payment];
//}

#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
//- (void)recordTransaction:(SKPaymentTransaction *)transaction
//{
//	if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseProUpgradeProductId])
//	{
//		// save the transaction receipt to disk
//		[[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceipt" ];
//		[[NSUserDefaults standardUserDefaults] synchronize];
//	}
//}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
	//if ([productId isEqualToString:kInAppPurchaseProUpgradeProductId])
	{
		// enable the pro features
		
		
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
		
		
		
		//downloading_Progress = TRUE;
		
		
		
		
		
		//						NSString * setOrderInfoUrl = [NSString stringWithFormat:@"%@/api/read?action=setorderinfo&authKey=%@&bookId=%d",serverIP,appDelegate.loginAuthKey,selectedBookIndex];
		//						NSURL *url = [[NSURL alloc] initWithString:setOrderInfoUrl];
		//						NSData *data = [[NSData alloc]initWithContentsOfURL:url];
		//						
		//						NSString * str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
		//						if ([str rangeOfString:@"<IsSuccess>1"].location !=NSNotFound) {
		//							downloading_Progress = FALSE;
		//						}
		//						else {
		//							// There may be problem in purchase  
		//						}
		//						
		//						downloading_Progress = FALSE;
		
		
		NSString *currentProductID=[productId substringFromIndex:15];
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		[defaults setInteger: 111 forKey: currentProductID]; //getting the last 52 from "wallpaperpack1052"
		[defaults synchronize];
		
		[downloadingOverlayView setHidden:TRUE];
		
		
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
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Transaction failed : %@", transaction.payment.productIdentifier ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		//[alert show]; 
		[alert release];
		
	}
	[downloadingOverlayView setHidden:TRUE];
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
	[self recordTransaction:transaction];
	[self provideContent:transaction.payment.productIdentifier];
	[self finishTransaction:transaction wasSuccessful:YES];
	[downloadingOverlayView setHidden:TRUE];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
	[self recordTransaction:transaction.originalTransaction];
	[self provideContent:transaction.originalTransaction.payment.productIdentifier];
	[self finishTransaction:transaction wasSuccessful:YES];
	[downloadingOverlayView setHidden:TRUE];
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
	[downloadingOverlayView setHidden:TRUE];
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


  


@end
