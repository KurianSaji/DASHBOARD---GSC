//
//  AlarmsViewController.m
//  Alarms
//
//  Created by neo on 19/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlarmsViewController.h"
#import "epubstore_svcAppDelegate.h"
#import "AlarmDetails.h"
#import "MusicListController.h"
#import "PlaySound.h"
#import "SlideToCancelViewController.h"
//#import "SA_OAuthTwitterEngine.h"
#import "AlarmSettings.h"
#import "StoreView.h"
#import "ICB_WeatherConditions.h"
#import "MapKit/MapKit.h"
#import "Calender.h"
#import "Videos.h"

#define kOAuthConsumerKeyq				@"HSXlD2Qoge97RVpMDDJ1ZA"		//REPLACE ME  Twitter
#define kOAuthConsumerSecretq			@"aqSxdileEqMpOpb3WtE1QaaiYVZPbLEVCLKtisQV1wY"

@implementation AlarmsViewController
@synthesize onoff,zipview,imageFileName,slideshowTimer;

int animatingviewTag = 343434;
//NSArray * eyeBlinkArray ;
//NSArray * eyeRollArray;
NSArray *timeParseArray;
MusicListController *sound;
//NSMutableArray *currentImageArray;  //Zipcode

UIImageView *eyeAnimatingImgVw;
UIImageView *eyeRollImageView;
UIImageView  *btnImageView;

//static NSString* kAppId = @"180294668651052";
//BOOL twitterClicked=FALSE;
//BOOL TwitterOpened= NO;
int MaximumAlarm = 5;
int cloudStartX=320;
UIImageView *wheatherReportView;
UIImage *weatherImg;
UILabel *tempLabel;
UIButton *btnStore;
UIButton *btnCalender;
UIButton *btnWheather;
UIImageView *tempImgView1;
UIImageView *tempImgView2;
UIImageView *tempImgView3;
UIImageView *degreeImgView;
BOOL isStoreClicked = TRUE;
BOOL flipDone;
BOOL isPickerClicked;
BOOL isZipcodeView;
BOOL geoFlag;
int animationType=0;
int animationFrame=1;
NSInteger *temLength;

UIImageView *calenImgView;
UIImageView *yearImgView;
UIImageView *monthImgView;
UIImageView *dayImgView;
UIImageView *dateImgView1;
UIImageView *dateImgView2;
NSMutableArray *myArray;
UIPickerView *uiPicker;
UIApplication *thisApp;
UITextField *textField;
NSTimer *watchTimer;
NSTimer *cloudTimer;
NSString *countryName;
NSString *zipCodeNo;
int myValue;
NSInteger *arrayIndex;
UIView *countryWheatherView;
UILabel	*zipLabel;
NSString *countryCode;
NSString *tempLength;
UIImage *img;
UIImage *timcoln;
UIImage *timcoln1;
UIImageView *colImage;
UIImageView *splashView2;
int ipadScreenWidth=768;
int ipadScreenHeight=1024;
NSString *iPhoneORiPad;
/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
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



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.imageFileName=[[NSString alloc]init];
	ratioWidth=ipadScreenWidth/[UIScreen mainScreen].bounds.size.width;
	ratioHeight=ipadScreenHeight/[UIScreen mainScreen].bounds.size.height;

	
	
	appdelegate = (epubstore_svcAppDelegate*)[[UIApplication sharedApplication]delegate];

	transparentImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg1.png"]];
		transparentImage.frame=CGRectMake(0, 0, transparentImage.image.size.width+200, transparentImage.image.size.height+100);
	iPhoneORiPad=@"IPA_";
	//topToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];

	//int hei=CGRectGetMinY(appdelegate.tabBarController.tabBar.frame)-CGRectGetMaxY(topToolBar.frame);
	if (appdelegate.screenHeight1!=1024) {
		transparentImage.frame=CGRectMake(0, 0, transparentImage.frame.size.width/ratioWidth, transparentImage.frame.size.height/ratioHeight);
		iPhoneORiPad=@"IPH_";
	}

	transparentImage.center=CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds),CGRectGetMidY([UIScreen mainScreen].bounds) );
	
	hourBackImage=[[UIImageView alloc]init];
	hourBackImage.frame=CGRectMake(60, 10, 298, 301);
	if (appdelegate.screenHeight1!=1024) {
		hourBackImage.frame=CGRectMake(60/ratioWidth, 10/ratioHeight, 298/ratioWidth, 301/ratioHeight);
	}
	//hourBackImage.center=self.view.center;
	
	minsBackImage=[[UIImageView alloc]init];
	minsBackImage.frame=CGRectMake(CGRectGetMaxX(hourBackImage.frame)-50, 10, 223+75, 226+75);
	if (appdelegate.screenHeight1!=1024) {
		minsBackImage.frame=CGRectMake(CGRectGetMaxX(hourBackImage.frame)-50/ratioWidth, 10/ratioHeight, 298/ratioWidth, 301/ratioHeight);
	}
	//minsBackImage.center=self.view.center;
	[transparentImage addSubview:hourBackImage];
	[transparentImage addSubview:minsBackImage];
	
	
	if(appdelegate.screenHeight1 == 1024)
	{
		[[NSBundle mainBundle] loadNibNamed:@"AlarmsViewController" owner:self options:nil];
		
	}
	else								 
		[[NSBundle mainBundle] loadNibNamed:@"AlarmViewiphone" owner:self options:nil];
	
	
	isDayOn = TRUE;
	//isVolume = TRUE;
	flipDone = TRUE;
	isPickerClicked = FALSE;
	isZipcodeView = TRUE;
	geoFlag = TRUE;
	onoff=FALSE;
	
	amPm=[[UIImageView alloc]init];
	
	min1=[[UIImageView alloc]init ];
	min2=[[UIImageView alloc]init];
	time1=[[UIImageView alloc]init];
	time2=[[UIImageView alloc]init];
	
	appdelegate.shopview.hidden=YES;
	
	//vid = [[Videos alloc]init];
	//	
	//	vid.videoimageView.hidden=TRUE;
	
	//locmanager = [[CLLocationManager alloc] init]; 
	//	[locmanager setDelegate:self]; 
	//	[locmanager setDesiredAccuracy:kCLLocationAccuracyBest];
	//	
	//	
	//	[locmanager startUpdatingLocation];
	if (appdelegate.screenHeight1!=1024) {
		tableview.frame=CGRectMake(0/ratioWidth, 0/ratioHeight, 768/ratioWidth,1024/ratioHeight);
		
	}
	[self.view setBackgroundColor:[UIColor blackColor]];
	
	NSUserDefaults *prefs1 = [NSUserDefaults standardUserDefaults];
	
	//Type cast added by Mani***
	appdelegate.alarmTheme= [[prefs1 stringForKey:@"alarmThemeValue"] intValue];
	
	colImage = [[UIImageView alloc]init];
	
	
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	//appdelegate.alarmTimeArray = (NSMutableArray *)[prefs arrayForKey:@"AlarmTimeArray"];
	appdelegate.alarmTimeArray = [appdelegate getArray];
	if (appdelegate.alarmTimeArray==nil)
	{
		appdelegate.alarmTimeArray = [[NSMutableArray alloc]init];
	}
	
	
	timeParseArray=[[NSArray alloc]init];
	
	
	alarmView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 770,1024)];
	if (appdelegate.screenHeight1!=1024) {
		alarmView.frame=CGRectMake(0, 0/ratioHeight, 770/ratioWidth,1024/ratioHeight);
	}
	//[alarmView setBackgroundColor:[UIColor blackColor]];
	
	//NSInteger Theme = [prefs integerForKey:@"GNBDayOrNight"];
	BOOL Theme =[prefs integerForKey:@"GNBDayOrNight"];
	//GNBDayOrNight 0 Day 
	//GNBDayOrNight 1 Night 
	if(loadImageView==nil)
	{
		if(appdelegate.alarmTheme == 0)
		{
			loadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -113, 770,1100)];//0,0,768,1024
			if (appdelegate.screenHeight1!=1024) {
				loadImageView.frame=CGRectMake(0, -113/ratioHeight, 770/ratioWidth,1100/ratioHeight);
			}
		}
		else
		{
			loadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -113, 770,1100)];//0, -113, 770,1100
			if (appdelegate.screenHeight1!=1024) {
				loadImageView.frame=CGRectMake(0, -113/ratioHeight, 770/ratioWidth,1100/ratioHeight);
			}
		}
	}
	if (Theme ==0) {
		
		isDayOn =FALSE;
	}
	else if(Theme ==1)
	{
		isDayOn = FALSE;
	}
	
	
	[alarmView addSubview:loadImageView];
	
	
	
	[self.view addSubview:alarmView];
	[alarmView addSubview:transparentImage];
	
    UIImageView *imageVV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_2.png"]];
    imageVV.frame=CGRectMake(0, 0, 770, 42);
    if (appdelegate.screenHeight1!=1024) {
        imageVV.image=[UIImage imageNamed:@"icon_1.png"];
		imageVV.frame=CGRectMake(0, 0, 770/ratioWidth,42);
	}
    [self.view addSubview:imageVV];
    
	charcterImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0,42,770,1024-42)];
	if (appdelegate.screenHeight1!=1024) {
		charcterImageView.frame=CGRectMake(0, 42, 770/ratioWidth,(1024-42)/ratioHeight);
	}
	
	//AdWhirlView *adView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
	//    //adView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
	//    [adView setFrame:CGRectMake(0, 0, 320, 50)];
	//    [adView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"eliteGudz_ad.png"]]];
	//    [alarmView addSubview:adView];
	
	infoButton=[UIButton buttonWithType:UIButtonTypeInfoLight];
	//infoButton.frame=CGRectMake(280,445,20, 20);
	infoButton.frame=CGRectMake(700,60, 20, 20);//700,60, 20, 20 //290,60, 20, 20
	if (appdelegate.screenHeight1!=1024) {
		infoButton.frame=CGRectMake(700/ratioWidth, 60/ratioHeight, 20/ratioWidth,20/ratioHeight);
	}
	//infoButton.backgroundColor = [UIColor blackColor];
	[infoButton addTarget:(id)self action:@selector(aboutButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
	[alarmView addSubview:infoButton];
	
	
	//[self performSelector:@selector(onOFF)];
	
	
	
	
	//NSString *str = [prefs stringForKey:@"alarmZipCode"];
//	int iValue = [str intValue];
//	
//	if(iValue == 0)
//	{
//		locmanager = [[CLLocationManager alloc] init]; 
//		[locmanager setDelegate:self]; 
//		[locmanager setDesiredAccuracy:kCLLocationAccuracyBest];
//		[locmanager startUpdatingLocation];
//		
//		//CLLocationCoordinate2D coord;    
//		//		coord.latitude = 45.574779;// 13.023796;//33.786594;//42.40000;
//		//		coord.longitude = -122.685366;
//		//			
//		//		MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coord];
//		//		geocoder.delegate = self;
//		//		[geocoder start];
//	}
//	else 
//	{
//		[self showWeatherFor:str ];
//	}
	
	//if(cloudTimer==nil)
	cloudTimer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(moveCloud) userInfo:nil repeats:YES];
	
	countryWheatherView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, 320, 480)];
		[countryWheatherView setBackgroundColor:[UIColor clearColor]];
	
	[self changeViews];
	[self addtimeView];
	slideshowTimer=[NSTimer scheduledTimerWithTimeInterval:appdelegate.slideShowTime target:self selector:@selector(slideShow) userInfo:nil repeats:YES];

	//topToolBar.barStyle=UIBarStyleBlackTranslucent;
//	alarmButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStyleBordered target:self action:@selector(alarmBtnAction)];
//	songButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStyleBordered target:self action:@selector(selectSongsAction)];
//	flipButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStyleBordered target:self action:@selector(flipBtnAction)];
//	themeButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStyleBordered target:self action:@selector(btnStoreAction)];
//	flexibleSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//	[topToolBar setItems:[NSArray arrayWithObjects:alarmButton,songButton,flipButton,themeButton,flexibleSpace,nil]];
//	[alarmView addSubview:topToolBar];
	//[NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(animateEye) userInfo:nil repeats:YES];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(stopFlip:) forControlEvents:UIControlEventTouchUpInside];
    button.tag=99;
    button.frame=CGRectMake(appdelegate.screenWidth1-100, 0, 100, 44);
    [button setTitle:@"Pause" forState:UIControlStateNormal];
    [self.view addSubview:button];
  
}

-(void)stopFlip:(id)sender
{
    if ([[sender currentTitle] isEqualToString:@"Play"]) {
        [sender setTitle:@"Pause" forState:UIControlStateNormal];
        slideshowTimer=[NSTimer scheduledTimerWithTimeInterval:appdelegate.slideShowTime target:self selector:@selector(slideShow) userInfo:nil repeats:YES];
        
    }
    else{
        [sender setTitle:@"Play" forState:UIControlStateNormal];
        [slideshowTimer invalidate];
        slideshowTimer=nil;
    }
}


-(void)slideShow
{
	//if (appdelegate.screenHeight1==1024) {
		NSString *str=[self.imageFileName substringWithRange:NSMakeRange(18, 1)  ];
		if ([str intValue]<4) {

			
			//img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@Adam's-clock_0%d.png",iPhoneORiPad,[str intValue]+1] ofType:@""]];
			[UIImageView beginAnimations:nil context:nil];
            //change to set the time
            [UIImageView setAnimationDuration:1.0];
            [UIImageView setAnimationBeginsFromCurrentState:YES];
            [UIImageView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:alarmView cache:YES];
			
            //UIImage *img = [UIImage imageNamed:@"innerBottom.png"];
            [charcterImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@Adam's-clock_0%d.png",iPhoneORiPad,[str intValue]+1] ofType:@""]]];
            [UIImageView commitAnimations];
			
			
			self.imageFileName=[NSString stringWithFormat:@"%@Adam's-clock_0%d.png",iPhoneORiPad,[str intValue]+1];
			//[img release];
		}
	else {
		//img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@Adam's-clock_01.png",iPhoneORiPad] ofType:@""]];			
		[UIImageView beginAnimations:nil context:nil];
		//change to set the time
		[UIImageView setAnimationDuration:1.0];
		[UIImageView setAnimationBeginsFromCurrentState:YES];
		[UIImageView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:alarmView cache:YES];
		
		//UIImage *img = [UIImage imageNamed:@"innerBottom.png"];
		[charcterImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@Adam's-clock_01.png",iPhoneORiPad] ofType:@""]]];
		[UIImageView commitAnimations];
		
		
		self.imageFileName=[NSString stringWithFormat:@"%@Adam's-clock_01.png",iPhoneORiPad];

		//[img release];
	}

	//}
	//[charcterImageView.image name]
}
-(void)onOFF
{
	if(appdelegate.alarmTheme == 0)
	{
		if(isDayOn == TRUE)
		{
			if([appdelegate.alarmTimeArray count] == 0)
			{
				[alarmOnOff removeFromSuperview];
				//if(alarmOnOff==nil)
				alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
				if (appdelegate.screenHeight1!=1024) {
					alarmOnOff.frame=CGRectMake(320/ratioWidth, 850/ratioHeight-30, 155/ratioWidth,118/ratioHeight);
				}
				UIImage *on= [UIImage imageNamed:@"off_brown.png"];
				[alarmOnOff setImage:on];
				[alarmView addSubview:alarmOnOff];
				[alarmOnOff release];
			}
			else 
			{
				[alarmOnOff removeFromSuperview];
				//	if(alarmOnOff==nil)
				alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
				if (appdelegate.screenHeight1!=1024) {
					alarmOnOff.frame=CGRectMake(320/ratioWidth, 850/ratioHeight-30, 155/ratioWidth,118/ratioHeight);
				}
				UIImage *off= [UIImage imageNamed:@"on_01.png"];
				[alarmOnOff setImage:off];
				[alarmView addSubview:alarmOnOff];
				[alarmOnOff release];
			}
		}
		else 
		{
			if([appdelegate.alarmTimeArray count] == 0)
			{
				[alarmOnOff removeFromSuperview];
				//if(alarmOnOff==nil)
				alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
				if (appdelegate.screenHeight1!=1024) {
					alarmOnOff.frame=CGRectMake(320/ratioWidth, 850/ratioHeight-30, 155/ratioWidth,118/ratioHeight);
				}
				UIImage *on= [UIImage imageNamed:@"off_green.png"];
				[alarmOnOff setImage:on];
				[alarmView addSubview:alarmOnOff];
				[alarmOnOff release];
			}
			else 
			{
				[alarmOnOff removeFromSuperview];
				//if(alarmOnOff==nil)
				alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
				if (appdelegate.screenHeight1!=1024) {
					alarmOnOff.frame=CGRectMake(320/ratioWidth, 850/ratioHeight-30, 155/ratioWidth,118/ratioHeight);
				}
				UIImage *off= [UIImage imageNamed:@"on_green.png"];
				[alarmOnOff setImage:off];
				[alarmView addSubview:alarmOnOff];
				[alarmOnOff release];
			}
		}
		
		
	}
	else if(appdelegate.alarmTheme == 1)
	{
		if([appdelegate.alarmTimeArray count] == 0)
		{
			[alarmOnOff removeFromSuperview];
			//if(alarmOnOff==nil)
			alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
			if (appdelegate.screenHeight1!=1024) {
				alarmOnOff.frame=CGRectMake(320/ratioWidth, 850/ratioHeight-30, 155/ratioWidth,118/ratioHeight);
			}
			UIImage *on= [UIImage imageNamed:@"off_green.png"];
			[alarmOnOff setImage:on];
			[alarmView addSubview:alarmOnOff];
			[alarmOnOff release];
		}
		else 
		{
			[alarmOnOff removeFromSuperview];
			//if(alarmOnOff==nil)
			alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
			if (appdelegate.screenHeight1!=1024) {
				alarmOnOff.frame=CGRectMake(320/ratioWidth, 850/ratioHeight-30, 155/ratioWidth,118/ratioHeight);
			}
			UIImage *off= [UIImage imageNamed:@"on_green.png"];
			[alarmOnOff setImage:off];
			[alarmView addSubview:alarmOnOff];
			[alarmOnOff release];
		}
	}
	else if(appdelegate.alarmTheme == 2)
	{
		if([appdelegate.alarmTimeArray count] == 0)
		{
			[alarmOnOff removeFromSuperview];
			//if(alarmOnOff==nil)
			alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
			if (appdelegate.screenHeight1!=1024) {
				alarmOnOff.frame=CGRectMake(320/ratioWidth, 850/ratioHeight-30, 155/ratioWidth,118/ratioHeight);
			}
			UIImage *on= [UIImage imageNamed:@"off_green.png"];
			[alarmOnOff setImage:on];
			[alarmView addSubview:alarmOnOff];
			[alarmOnOff release];
		}
		else 
		{
			[alarmOnOff removeFromSuperview];
			//if(alarmOnOff==nil)
			alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
			if (appdelegate.screenHeight1!=1024) {
				alarmOnOff.frame=CGRectMake(320/ratioWidth, 850/ratioHeight-30, 155/ratioWidth,118/ratioHeight);
			}
			UIImage *off= [UIImage imageNamed:@"on_green.png"];
			[alarmOnOff setImage:off];
			[alarmView addSubview:alarmOnOff];
			[alarmOnOff release];
		}
	}
	
	
	
	
	
}



-(void)loadSplash2
{
	UIImage *splash2=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Default" ofType:@"png"]];
	splashView2.image=splash2;
	splashView2.frame=CGRectMake(0,0,480,320);
	[self.view addSubview:splashView2];
	//[splash2 release];
	[splashView2 release];
}

-(void)viewLoadMethod
{
	//######################
	//UIBarButtonItem *btnStore1;
	
	
	[self watchTime];
	
	if(watchTimer==nil)
		watchTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(watchTime) userInfo:nil repeats:YES];
	
	
	if(appdelegate.alarmTheme == 0)
	{
		
		if(isDayOn == TRUE)
		{
			if(time2.image == nil)
			{
				timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"dots.png"] ofType:@""]];
				colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
				if (appdelegate.screenHeight1!=1024) {
					colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
				}
				colImage.image = timcoln;
				//[timcoln release];
			}
			else {
				timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"dots.png"] ofType:@""]];
				colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
				if (appdelegate.screenHeight1!=1024) {
					colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
				}
				colImage.image = timcoln;
				//[timcoln release];
			}
			
			if([appdelegate.alarmTimeArray count] == 0)
			{
				[alarmOnOff removeFromSuperview];
				//if(alarmOnOff==nil)
				alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
				if (appdelegate.screenHeight1!=1024) {
					alarmOnOff.frame=CGRectMake(320/ratioWidth, 850/ratioHeight-30, 155/ratioWidth,118/ratioHeight);
				}
				UIImage *on= [UIImage imageNamed:@"off_brown.png"];
				[alarmOnOff setImage:on];
				[alarmView addSubview:alarmOnOff];
				[alarmOnOff release];
				
				
			}
			else 
			{
				[alarmOnOff removeFromSuperview];
				//if(alarmOnOff==nil)
				alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
				if (appdelegate.screenHeight1!=1024) {
					alarmOnOff.frame=CGRectMake(320/ratioWidth, 850/ratioHeight-30, 155/ratioWidth,118/ratioHeight);
				}
				UIImage *off= [UIImage imageNamed:@"on_01.png"];
				[alarmOnOff setImage:off];
				[alarmView addSubview:alarmOnOff];
				[alarmOnOff release];
			}
		}
		else {
			if(time2.image == nil)
			{
				timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
				colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
				if (appdelegate.screenHeight1!=1024) {
					colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
				}
				colImage.image = timcoln;
				//[timcoln release];
			}
			else {
				timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
				colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
				if (appdelegate.screenHeight1!=1024) {
					colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
				}
				colImage.image = timcoln;
				//[timcoln release];
			}
			
			
			if([appdelegate.alarmTimeArray count] == 0)
			{[alarmOnOff removeFromSuperview];
				//if(alarmOnOff==nil)
				alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
				if (appdelegate.screenHeight1!=1024) {
					alarmOnOff.frame=CGRectMake(320/ratioWidth, 850/ratioHeight-30, 155/ratioWidth,118/ratioHeight);
				}
				UIImage *on= [UIImage imageNamed:@"off_green.png"];
				[alarmOnOff setImage:on];
				[alarmView addSubview:alarmOnOff];
				[alarmOnOff release];
			}
			else 
			{[alarmOnOff removeFromSuperview];
				//if(alarmOnOff==nil)
				alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
				if (appdelegate.screenHeight1!=1024) {
					alarmOnOff.frame=CGRectMake(320/ratioWidth, 850/ratioHeight-30, 155/ratioWidth,118/ratioHeight);
				}
				UIImage *off= [UIImage imageNamed:@"on_green.png"];
				[alarmOnOff setImage:off];
				[alarmView addSubview:alarmOnOff];
				[alarmOnOff release];
			}
		}
		
	}
	else if(appdelegate.alarmTheme==1)
	{
		if(time2.image == nil)
		{
			timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
			colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
			if (appdelegate.screenHeight1!=1024) {
				colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
			}
			colImage.image = timcoln;
			//[timcoln release];
		}
		else {
			timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
			colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
			if (appdelegate.screenHeight1!=1024) {
				colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
			}
			colImage.image = timcoln;
			//[timcoln release];
		}
		if([appdelegate.alarmTimeArray count] == 0)
		{
			[alarmOnOff removeFromSuperview];
			//if(alarmOnOff==nil)
			alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
			if (appdelegate.screenHeight1!=1024) {
				alarmOnOff.frame=CGRectMake(320/ratioWidth, 850/ratioHeight-30, 155/ratioWidth,118/ratioHeight);
			}
			UIImage *on= [UIImage imageNamed:@"off_green.png"];
			[alarmOnOff setImage:on];
			[alarmView addSubview:alarmOnOff];
			[alarmOnOff release];
		}
		else 
		{[alarmOnOff removeFromSuperview];
			//if(alarmOnOff==nil)
			alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
			if (appdelegate.screenHeight1!=1024) {
				alarmOnOff.frame=CGRectMake(320/ratioWidth, 850/ratioHeight-30, 155/ratioWidth,118/ratioHeight);
			}
			UIImage *off= [UIImage imageNamed:@"on_green.png"];
			[alarmOnOff setImage:off];
			[alarmView addSubview:alarmOnOff];
			[alarmOnOff release];
		}
	}
	else if(appdelegate.alarmTheme == 2)
	{
		if([appdelegate.alarmTimeArray count] == 0)
		{
			[alarmOnOff removeFromSuperview];
			//if(alarmOnOff==nil)
			alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
			if (appdelegate.screenHeight1!=1024) {
				alarmOnOff.frame=CGRectMake(320/ratioWidth, 850/ratioHeight-30, 155/ratioWidth,118/ratioHeight);
			}
			UIImage *on= [UIImage imageNamed:@"off_green.png"];
			[alarmOnOff setImage:on];
			[alarmView addSubview:alarmOnOff];
			[alarmOnOff release];
		}
		else 
		{
			[alarmOnOff removeFromSuperview];
			//if(alarmOnOff==nil)
			alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
			if (appdelegate.screenHeight1!=1024) {
				alarmOnOff.frame=CGRectMake(320/ratioWidth, 850/ratioHeight-30, 155/ratioWidth,118/ratioHeight);
			}
			UIImage *off= [UIImage imageNamed:@"on_green.png"];
			[alarmOnOff setImage:off];
			[alarmView addSubview:alarmOnOff];
			[alarmOnOff release];
		}
	}
	
	
	NSDate *date = [NSDate date];
	//UIImage *img;
	
	NSDateFormatter *formatter = [[[NSDateFormatter alloc]init]autorelease];
	
	//[formatter setDateFormat:@"EEEE yyyy/MM/dd hh:mm a"];
	[formatter setDateFormat:@"yyyy/MM/dd "];
	NSString *dateString = [formatter stringFromDate:date];
	
	NSString *year = [dateString substringWithRange:NSMakeRange(0, 4)];
	NSString *month = [dateString substringWithRange:NSMakeRange(5, 2)];
	NSString *date1 = [dateString substringWithRange:NSMakeRange(8, 2)];
	
	
	
	//NSString *yearIndex = [year substringWithRange:NSMakeRange(2,2)];//last two digits of year
	
	
	NSDate *today = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *weekdayComponents =
	[gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:today];
    [gregorian release];
	NSInteger weekday = [weekdayComponents weekday];
	
	
	if(calenImgView==nil)
		calenImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,480)];
	//calenImgView = [[UIImageView alloc]initWithFrame:CGRectMake(85, 330, 173,108)];
	
	else {
		[calenImgView removeFromSuperview];
	}
	
	
	if(appdelegate.alarmTheme == 0)
	{
		
	}
	if(appdelegate.alarmTheme == 1)
	{
		
	}
	if(dayImgView==nil){
		dayImgView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 260,52,27)];// 50, -10, 760,1024 //0, 0, 320,480
		
	}
	else {
		dayImgView.frame=CGRectMake(50, 260,52,27);
		[dayImgView removeFromSuperview];
	}
	//img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"weekday_%d.png",weekday] ofType:@""]];
	dayImgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"weekday_%d.png",weekday] ofType:@""]];
	//[img release];
	//[dayImgView setBackgroundColor:[UIColor blackColor]];
	[transparentImage addSubview:dayImgView];
	//[dayImgView release];
	
	if(monthImgView==nil){ //(-20, 0, 320,480)
		monthImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dayImgView.frame)+10, 260, 139,27)];//15, 220, 760,750 //-10, 0, 320,480
		
	}
	else {
		monthImgView.frame=CGRectMake(CGRectGetMaxX(dayImgView.frame)+10, 260, 139,27);
		[monthImgView removeFromSuperview];
	}
	//img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"month_%d.png", [month intValue]] ofType:@""]];
	monthImgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"month_%d.png", [month intValue]] ofType:@""]];
//	[img release];
	
	[transparentImage addSubview:monthImgView];
	
	
	NSString *temp = [date1 substringToIndex:1];
	if(dateImgView1==nil){
		dateImgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(monthImgView.frame)+10, 260, 13,27)];//120, 240, 600,720 //-5, 0, 320,480
		
	}
	else {
		dateImgView1.frame=CGRectMake(CGRectGetMaxX(monthImgView.frame)+10, 260, 13,27);
		[dateImgView1 removeFromSuperview];
	}
	//img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@.png",temp] ofType:@""]];
	dateImgView1.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@",temp] ofType:@"png"]];;
	//[img release];
	//[tempImgView2 setBackgroundColor:[UIColor blackColor]];
	[transparentImage addSubview:dateImgView1];
	//[dateImgView1 release];
	
	NSString *temp1 = [date1 substringFromIndex:1];
	if(dateImgView2==nil)
	dateImgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dateImgView1.frame), 260, 13,27)];//155, 240, 600,720 //15, 0, 320,480
	
	else {
		dateImgView2.frame=CGRectMake(CGRectGetMaxX(dateImgView1.frame), 260, 13,27);
			[dateImgView2 removeFromSuperview];
		}
	//img=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@",temp1] ofType:@"png"]];
	//img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@",temp1] ofType:@"png"]];
	dateImgView2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@",temp1] ofType:@"png"]];
	//[img release];
	//img=nil;
	//[tempImgView2 setBackgroundColor:[UIColor blackColor]];
	[transparentImage addSubview:dateImgView2];
	
	
	
	//[dateImgView2 release];
	
	
	
	
	//UIImageView *btnImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 320,480)];
	//	img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"buttons_img.png"] ofType:@""]];
	//	btnImageView.image = img;
	//	//[tempImgView2 setBackgroundColor:[UIColor blackColor]];
	//	[alarmView addSubview:btnImageView]; //audio
	
	
	if(alarmBtn==nil)//25, 692  100, 70  //6, 285, 46, 40
	{
		alarmBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, 2, 40, 30)];
		
		//if(appdelegate.alarmTheme == 2)
		//		{
		//			alarmBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, 605, 100, 70)];
		//			[alarmBtn setBackgroundColor:[UIColor redColor]];
		//		}
		//		else 
		//		{
		//			alarmBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, 20, 40, 30)];
		//			//[alarmBtn setBackgroundColor:[UIColor greenColor]];
		//		}
	}
	else 
	{
		alarmBtn.frame=CGRectMake(12, 2, 40, 30);
		[alarmBtn removeFromSuperview];
	}
	//alarmBtn.backgroundColor = [UIColor blackColor];
	[alarmBtn addTarget:self action:@selector(alarmBtnAction) forControlEvents:UIControlEventTouchUpInside];
	[alarmView addSubview:alarmBtn];
	
	if(FlipBtn==nil)//25, 692, 100, 70 //6, 335, 46, 30
	{
		FlipBtn = [[UIButton alloc]initWithFrame:CGRectMake(107, 2, 40, 30)];
		//if(appdelegate.alarmTheme == 2)
		//		{
		//			FlipBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, 700, 100, 70)];
		//			[FlipBtn setBackgroundColor:[UIColor redColor]];
		//		}
		//		else 
		//		{
		//			
		//			FlipBtn = [[UIButton alloc]initWithFrame:CGRectMake(107, 20, 40, 30)];
		//			//[FlipBtn setBackgroundColor:[UIColor greenColor]];
		//		}
	}
	else 
	{
		FlipBtn.frame=CGRectMake(107, 2, 40, 30);
		[FlipBtn removeFromSuperview];
	}
	//FlipBtn.backgroundColor = [UIColor blackColor];
	[FlipBtn addTarget:self action:@selector(flipBtnAction) forControlEvents:UIControlEventTouchUpInside];
	[alarmView addSubview:FlipBtn];
	
//	if(volumeBtn==nil)//25, 790, 100, 70 //6, 380, 46, 30
//	{
//		volumeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,0,0)];//25, 800, 100, 70
//		//[volumeBtn setBackgroundColor:[UIColor greenColor]];
//	}
//	else 
//	{
//		volumeBtn.frame=CGRectMake(0,0,0,0);
//		[volumeBtn removeFromSuperview];
//	}
//	//volumeBtn.backgroundColor = [UIColor blackColor];
//	[volumeBtn addTarget:self action:@selector(volumeBtnAction) forControlEvents:UIControlEventTouchUpInside];
//	[alarmView addSubview:volumeBtn];
	
	if(selectSongs==nil)//25, 880, 100, 70 //6, 428, 46, 30
	{
		selectSongs = [[UIButton alloc]initWithFrame:CGRectMake(55, 2, 40, 30)];
		//if(appdelegate.alarmTheme == 2)
		//		{
		//			selectSongs = [[UIButton alloc]initWithFrame:CGRectMake(25, 900, 100, 70)];
		//			[selectSongs setBackgroundColor:[UIColor redColor]];
		//		}
		//		else
		//		{
		//			selectSongs = [[UIButton alloc]initWithFrame:CGRectMake(55, 20, 40, 30)];
		//			//[selectSongs setBackgroundColor:[UIColor greenColor]];
		//		}
	}
	else 
	{
		selectSongs.frame=CGRectMake(55, 2, 40, 30);
		[selectSongs removeFromSuperview];
	}
	//selectSongs.backgroundColor = [UIColor blackColor];
	[selectSongs addTarget:self action:@selector(selectSongsAction) forControlEvents:UIControlEventTouchUpInside];
	[alarmView addSubview:selectSongs];
	
	if(btnStore==nil)//25, 495, 100, 70 //15, 240, 46, 40
	{
		btnStore = [[UIButton alloc]initWithFrame:CGRectMake(155, 2, 40, 30)];
		
	}
	else 
	{
		btnStore.frame=CGRectMake(155, 2, 40, 30);
		[btnStore removeFromSuperview];
	}
	//btnStore.backgroundColor = [UIColor greenColor];
	[btnStore addTarget:self action:@selector(btnStoreAction) forControlEvents:UIControlEventTouchUpInside];
	[alarmView addSubview:btnStore];
	
	
	
	//iphone frame for date,month,day
	
	if (appdelegate.screenHeight1!=1024) {
		dayImgView.frame=CGRectMake(50/ratioWidth, 260/ratioHeight, 52/ratioWidth,27/ratioHeight);
		dateImgView2.frame=CGRectMake(dateImgView2.frame.origin.x/ratioWidth, dateImgView2.frame.origin.y/ratioHeight, 13/ratioWidth,27/ratioHeight);
		dateImgView1.frame=CGRectMake(dateImgView1.frame.origin.x/ratioWidth, dateImgView1.frame.origin.y/ratioHeight, 13/ratioWidth,27/ratioHeight);
		monthImgView.frame=CGRectMake(monthImgView.frame.origin.x/ratioWidth, monthImgView.frame.origin.y/ratioHeight, 139/ratioWidth,27/ratioHeight);
		
		//alarmBtn.frame=CGRectMake(12/ratioWidth, 2/ratioHeight, 40/ratioWidth, 30/ratioHeight);
		//FlipBtn.frame=CGRectMake(107/ratioWidth, 2/ratioHeight, 40/ratioWidth, 30/ratioHeight);
		//selectSongs.frame=CGRectMake(55/ratioWidth, 2/ratioHeight, 40/ratioWidth, 30/ratioHeight);
		//btnStore.frame=CGRectMake(155/ratioWidth, 2/ratioHeight, 40/ratioWidth, 30/ratioHeight);
	}
	
	if(wheatherReportView==nil)
		wheatherReportView = [[UIImageView alloc]init];// WithFrame:CGRectMake(0, 45, 320,127)];
	else {
		[wheatherReportView removeFromSuperview]; //0, 40, 320,127
	}
	//wheatherReportView.frame = CGRectMake(0, -20, 320,120);
	if(appdelegate.alarmTheme == 0)
	{
		wheatherReportView.frame = CGRectMake(transparentImage.frame.size.width-450, transparentImage.frame.size.height-120, 600,120);
		btnWheather = [[UIButton alloc]initWithFrame:wheatherReportView.frame];
		if (appdelegate.screenHeight1!=1024) {
			wheatherReportView.frame=CGRectMake(transparentImage.frame.size.width-(450/ratioWidth), transparentImage.frame.size.height-(120/ratioWidth), 600/ratioWidth,120/ratioHeight);
			btnWheather.frame=wheatherReportView.frame;

		}
		
	}
	else 
	{
		wheatherReportView.frame = CGRectMake(transparentImage.frame.size.width-450, transparentImage.frame.size.height-120, 600,120);
		btnWheather = [[UIButton alloc]initWithFrame:wheatherReportView.frame];
		if (appdelegate.screenHeight1!=1024) {
			wheatherReportView.frame=CGRectMake(transparentImage.frame.size.width-(450/ratioWidth), transparentImage.frame.size.height-(120/ratioWidth), 600/ratioWidth,120/ratioHeight);
			btnWheather.frame=wheatherReportView.frame;
			
		}
	}
	[wheatherReportView setBackgroundColor:[UIColor clearColor]];
	[transparentImage addSubview:wheatherReportView];
	
	[btnWheather addTarget:self action:@selector(btnWheatherAction) forControlEvents:UIControlEventTouchUpInside];
   
	
	
	if(tempImgView1==nil)
		tempImgView1 = [[UIImageView alloc]init];//WithFrame:CGRectMake(0, 55, 320,94)];
	else //5, 50, 320,94
	{
		[tempImgView1 removeFromSuperview];
	}
	//tempImgView1.frame = CGRectMake(5, -10, 320,94);
	if(appdelegate.alarmTheme == 0)
	{
		tempImgView1.frame = CGRectMake(wheatherReportView.frame.origin.x+150,wheatherReportView.frame.origin.y, 320,94);
		if (appdelegate.screenHeight1!=1024) {
			tempImgView1.frame=CGRectMake(tempImgView1.frame.origin.x/ratioWidth+45, tempImgView1.frame.origin.y/ratioHeight+65, 320/ratioWidth,94/ratioHeight);
			
		}
	}
	else {
		tempImgView1.frame = CGRectMake(wheatherReportView.frame.origin.x+150,wheatherReportView.frame.origin.y, 320,94);//5, 50, 320,94
		if (appdelegate.screenHeight1!=1024) {
			tempImgView1.frame=CGRectMake(tempImgView1.frame.origin.x/ratioWidth+45, tempImgView1.frame.origin.y/ratioHeight+65, 320/ratioWidth,94/ratioHeight);
			
		}
	}
	[tempImgView1 setBackgroundColor:[UIColor clearColor]];
	[transparentImage addSubview:tempImgView1];
	
	if(tempImgView2==nil)
		tempImgView2 = [[UIImageView alloc]init];//WithFrame:CGRectMake(180,60, 320,94)];
	else 
	{
		[tempImgView2 removeFromSuperview];
	}
	//tempImgView2.frame = CGRectMake(5, -10, 320,94);
	if(appdelegate.alarmTheme == 0)
	{
		tempImgView2.frame = CGRectMake(wheatherReportView.frame.origin.x+150,wheatherReportView.frame.origin.y, 320,94);
	}
	else {
		tempImgView2.frame = CGRectMake(wheatherReportView.frame.origin.x+150,wheatherReportView.frame.origin.y, 320,94);
	}
	if (appdelegate.screenHeight1!=1024) {
		tempImgView2.frame=CGRectMake(tempImgView2.frame.origin.x/ratioWidth+45, tempImgView2.frame.origin.y/ratioHeight+65, 320/ratioWidth,94/ratioHeight);
		
	}
	[tempImgView2 setBackgroundColor:[UIColor clearColor]];
	[transparentImage addSubview:tempImgView2];
	
	
	//if(tempImgView3==nil)
	//		tempImgView3 = [[UIImageView alloc]init ];//WithFrame:CGRectMake(0, 55, 320,94)];
	//	else 
	//	{
	//		[tempImgView3 removeFromSuperview];
	//	}
	//	tempImgView3.frame = CGRectMake(70,60, 320,94);
	//	[tempImgView3 setBackgroundColor:[UIColor redColor]];
	//	[alarmView addSubview:tempImgView3];
	
	
	if(degreeImgView==nil)
		degreeImgView = [[UIImageView alloc]init ];//WithFrame:CGRectMake(20, 55, 320,94)];
	else 
	{
		[degreeImgView removeFromSuperview];
	}
	
	//if(tempLength  <=2)
	//	{
	//		degreeImgView.frame = CGRectMake(0, 55, 320,94);
	//	}
	//	else {
	//		degreeImgView.frame = CGRectMake(20, 55, 320,94);
	//
	//	}
	
	
	[degreeImgView setBackgroundColor:[UIColor clearColor]];
	[transparentImage addSubview:degreeImgView];
	
	if(appdelegate.alarmTheme == 0)
	{
		degreeImgView.frame = CGRectMake(wheatherReportView.frame.origin.x+150,wheatherReportView.frame.origin.y, 320,94);
		if (appdelegate.screenHeight1!=1024) {
			degreeImgView.frame=CGRectMake(degreeImgView.frame.origin.x/ratioWidth+45, degreeImgView.frame.origin.y/ratioHeight+65, 320/ratioWidth,94/ratioHeight);
			
		}
	}
	else
	{
		degreeImgView.frame = CGRectMake(wheatherReportView.frame.origin.x+150,wheatherReportView.frame.origin.y, 320,94);
		if (appdelegate.screenHeight1!=1024) {
			degreeImgView.frame=CGRectMake(degreeImgView.frame.origin.x/ratioWidth+45, degreeImgView.frame.origin.y/ratioHeight+65, 320/ratioWidth,94/ratioHeight);
			
		}
	}
	 [transparentImage addSubview:btnWheather];
}


-(void)watchTime
{
	
	NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
	[timeFormat setDateFormat:@"hh:mm:a"];
	NSDate *now = [[NSDate alloc] init];
	NSString *theTime = [timeFormat stringFromDate:now];
	
	[timeFormat release];
	[now release];
	
	
	timeParseArray=[theTime componentsSeparatedByString:@":"];
	NSString *hr=[timeParseArray objectAtIndex:0];
	NSString *min=[timeParseArray objectAtIndex:1];
	//hr=[timeParseArray objectAtIndex:0];
	//min=[timeParseArray objectAtIndex:1];
	NSString *am=[timeParseArray objectAtIndex:2];
	
	
	
	NSString *h1,*h2,*m1,*m2;
	h1 = [ hr substringWithRange:NSMakeRange(0,1)];
	h2 = [ hr substringWithRange:NSMakeRange(1,1)];
	m1=[min substringWithRange:NSMakeRange(0,1)];
	m2=[min substringWithRange:NSMakeRange(1,1)];
	
	if(appdelegate.alarmTheme == 1 || appdelegate.alarmTheme == 2 )   //|| appdelegate.alarmTheme == 2  || appdelegate.alarmTheme == 3 )
	{
		
		UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"img_no%@.png",m2] ofType:@""]];//@"img_no%@.png"
		min1.image =img;
		//[img release];
		
		img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"img_no%@.png",m1] ofType:@""]];
		min2.image =img;
		//[img release];
		
		img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"img_no%@.png",h2] ofType:@""]];
		time1.image =img;
		//[img release];
		
		img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"img_no%@.png",h1] ofType:@""]];
		time2.image =img;
		//[img release];
		
		//timcoln1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
		//		col.image = timcoln1;
		//		[timcoln1 release];
		[transparentImage addSubview:colImage];
	}
	else if(appdelegate.alarmTheme == 0)
	{
		if(isDayOn == TRUE)
		{
			UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"new%@.png",m2] ofType:@""]];//@"img_no%@.png"
			min1.image =img;
			//[img release];
			
			img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"new%@.png",m1] ofType:@""]];
			min2.image =img;
			//[img release];
			
			img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"new%@.png",h2] ofType:@""]];
			time1.image =img;
			//[img release];
			
			img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"new%@.png",h1] ofType:@""]];
			time2.image =img;
			//[img release];
		}
		else 
		{
			UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"img_no%@.png",m2] ofType:@""]];//@"img_no%@.png"
			min1.image =img;
			//[img release];
			
			img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"img_no%@.png",m1] ofType:@""]];
			min2.image =img;
			//[img release];
			
			img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"img_no%@.png",h2] ofType:@""]];
			time1.image =img;
			//[img release];
			
			img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"img_no%@.png",h1] ofType:@""]];
			time2.image =img;
			//[img release];
		}
		
		//timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"dots.png"] ofType:@""]];
		//		colImage.image = timcoln;
		//		[timcoln release];
		[transparentImage addSubview:colImage];
	}
	//else if(appdelegate.alarmTheme == 2)
	//	{
	//		
	//		UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"imgno%@.png",m2] ofType:@""]];//@"img_no%@.png"
	//		min1.image =img;
	//		[img release];
	//		
	//		img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"imgno%@.png",m1] ofType:@""]];
	//		min2.image =img;
	//		[img release];
	//		
	//		img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"imgno%@.png",h2] ofType:@""]];
	//		time1.image =img;
	//		[img release];
	//		
	//		img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"imgno%@.png",h1] ofType:@""]];
	//		time2.image =img;
	//		[img release];
	//	}
	//if([h1 isEqualToString:@"0"])
	//	{
	//		time2.image =nil;//img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"imgAM" ofType:@"png"]];
	//	}
	
	if(appdelegate.alarmTheme == 0)
	{
		if(isDayOn == TRUE)
		{
			if ([am isEqualToString:@"AM"]) {
				//img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"imgAM" ofType:@"png"]];
				img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"new_am" ofType:@"png"]];
				amPm.image =img;
				//[img release];
			}
			else if ([am isEqualToString:@"PM"]) {
				//img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"imgPM" ofType:@"png"]];
				img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"new_pm" ofType:@"png"]];
				amPm.image =img;
				//[img release];
			}
		}
		else
		{
			if ([am isEqualToString:@"AM"]) {
				//img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"imgAM" ofType:@"png"]];
				img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"imgAM" ofType:@"png"]];
				amPm.image =img;
				//[img release];
			}
			else if ([am isEqualToString:@"PM"]) {
				//img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"imgPM" ofType:@"png"]];
				img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"imgPM" ofType:@"png"]];
				amPm.image =img;
				//[img release];
			}
		}
	}
	
	else if(appdelegate.alarmTheme == 1 || appdelegate.alarmTheme == 2)
	{
		
		if ([am isEqualToString:@"AM"]) {
			img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"imgAM" ofType:@"png"]];
			//img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"new_am" ofType:@"png"]];
			amPm.image =img;
			//[img release];
		}
		else if ([am isEqualToString:@"PM"]) {
			img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"imgPM" ofType:@"png"]];
			//img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"new_pm" ofType:@"png"]];
			amPm.image =img;
			//[img release];
		}
	}
	
	else if(appdelegate.alarmTheme == 2)
	{
		
		if ([am isEqualToString:@"AM"]) {
			img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"imgAM1" ofType:@"png"]];
			//img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"new_am" ofType:@"png"]];
			amPm.image =img;
			//[img release];
		}
		else if ([am isEqualToString:@"PM"]) {
			img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"imgPM1" ofType:@"png"]];
			//img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"new_pm" ofType:@"png"]];
			amPm.image =img;
			//[img release];
		}
	}
	
	
}



-(void)moveCloud
{
	//	cloudStartX -=5;
	//	if (cloudStartX<=-260) {
	//		cloudStartX = 320;
	//	}
	
	cloudStartX -=5;
	if (cloudStartX<=-240) {
		cloudStartX = 750;
	}
	
	
	cloudImageView.frame = CGRectMake(cloudStartX,50, 260, 146);//cloudStartX,50, 260, 146
	if (appdelegate.screenHeight1!=1024) {
		cloudImageView.frame=CGRectMake(cloudImageView.frame.origin.x/ratioWidth, cloudImageView.frame.origin.y/ratioHeight, 260/ratioWidth,146/ratioHeight);
		
	}
}

-(void)alarmBtnAction
{
	[slideshowTimer invalidate];
	slideshowTimer=nil;
	[appdelegate.musicPlayer stop];
	[appdelegate.audioPlayer stop];
//	if (isVolume == FALSE) {
//		[self volumeBtnAction];
//	}
	
	[newtable reloadData];
	[UIView beginAnimations:nil context:nil];
	
	[UIView setAnimationDuration:1.2f];
	[UIView setAnimationDelegate:self];
	
	//UIView *vw =[[UIView alloc]initWithFrame:<#(CGRect)frame#>
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:alarmView cache:YES];
	
	[self.view addSubview:tableview];
	
	[UIView commitAnimations];
	
	
}


-(IBAction)backAction
{
	if (slideshowTimer==nil) {
        if ([[(UIButton *)[self.view viewWithTag:99] currentTitle] isEqualToString:@"Pause"]) {
            slideshowTimer=[NSTimer scheduledTimerWithTimeInterval:appdelegate.slideShowTime target:self selector:@selector(slideShow) userInfo:nil repeats:YES];
        }
		
	}
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.2f];
	[UIView setAnimationDelegate:self];
	
	//[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];	
	
	[self.view addSubview:alarmView]; 
	//[alarmView addSubview:transparentImage];
	[UIView commitAnimations];
	[newtable reloadData];
	[tableview removeFromSuperview];
	[self viewLoadMethod];
    [self.view bringSubviewToFront:(UIButton *)[self.view viewWithTag:99]];
       
}

-(IBAction)flipBtnAction
{
	[slideshowTimer invalidate];
	slideshowTimer=nil;
	
	flipDone = FALSE;
	[appdelegate.musicPlayer stop];
	[appdelegate.audioPlayer stop];
	
	//[self removePreviousThemeFootprint];
//	if (isVolume == FALSE) {
//		[self volumeBtnAction];
//	}
	
	[UIView beginAnimations:nil context:nil];
	
	[UIView setAnimationDuration:1.2f];
	[UIView setAnimationDelegate:self];
	
	
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:alarmView cache:YES];	
	[UIView commitAnimations];
	
	if (slideshowTimer==nil) {
        if ([[(UIButton *)[self.view viewWithTag:99] currentTitle] isEqualToString:@"Pause"]) {
            slideshowTimer=[NSTimer scheduledTimerWithTimeInterval:appdelegate.slideShowTime target:self selector:@selector(slideShow) userInfo:nil repeats:YES];
        }
	}
	[self changeViews];
	
	
	NSUserDefaults *prefs2 = [NSUserDefaults standardUserDefaults];
	//NSInteger i = isDayOn +1;
	if (isDayOn ==TRUE) 
	{
		[prefs2 setBool:FALSE forKey:@"GNBDayOrNight"];
		
	}
	if (isDayOn ==FALSE) {
		[prefs2 setBool:TRUE forKey:@"GNBDayOrNight"];
		
	}
	
	[prefs2 synchronize];
	
	
	
	[tableview removeFromSuperview];
	[self.view bringSubviewToFront:(UIButton *)[self.view viewWithTag:99]];
	//NSString *IndexString = [NSString stringWithFormat:@"%d",isDayOn];
	//[prefs set:[NSString stringWithFormat:@"%d",isDayOn] forKey:@"GNBDayOrNight"];
	
}

-(void)animates
{
	if(appdelegate.alarmTheme==0)
	{
		if(isDayOn == TRUE)
		{
			//			myImages = [NSArray arrayWithObjects:
			//						[UIImage imageNamed:@"Rich's clock_01.png"],[UIImage imageNamed:@"Rich's clock_02.png"],nil];
			//myImages = [NSArray arrayWithObjects:
//						[UIImage imageNamed:[NSString stringWithFormat:@"%@Adam's-clock_01.png",iPhoneORiPad]],[UIImage imageNamed:[NSString stringWithFormat:@"%@Adam's-clock_01.png",iPhoneORiPad]],nil];
//			
//			charcterImageView.animationImages=myImages;
//			charcterImageView.animationDuration = 0.8; 
//			charcterImageView.animationRepeatCount = 0; 
//			[charcterImageView startAnimating];
			charcterImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@Adam's-clock_01.png",iPhoneORiPad]];
			self.imageFileName=[NSString stringWithFormat:@"%@Adam's-clock_01.png",iPhoneORiPad];

			[alarmView addSubview:charcterImageView];
			[alarmView addSubview:transparentImage];
			
		}
		else 
		{
			//			myImages = [NSArray arrayWithObjects:
			//						[UIImage imageNamed:[NSString stringWithFormat:@"%@Adam's-clock_01.png",iPhoneORiPad]],[UIImage imageNamed:[NSString stringWithFormat:@"%@Adam's-clock_02.png",iPhoneORiPad]],nil];
			//myImages = [NSArray arrayWithObjects:
//						[UIImage imageNamed:[NSString stringWithFormat:@"%@Adam's-clock_02.png",iPhoneORiPad]],[UIImage imageNamed:[NSString stringWithFormat:@"%@Adam's-clock_02.png",iPhoneORiPad]],nil];
//			
//			charcterImageView.animationImages=myImages;
//			charcterImageView.animationDuration = 0.8; 
//			charcterImageView.animationRepeatCount = 0; 
//			[charcterImageView startAnimating];
			charcterImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@Adam's-clock_02.png",iPhoneORiPad]];
			self.imageFileName=[NSString stringWithFormat:@"%@Adam's-clock_02.png",iPhoneORiPad];
			[alarmView addSubview:charcterImageView];
			[alarmView addSubview:transparentImage];
			
		}
	}
}



-(void)changeViews
{
	
	if(isStoreClicked == FALSE)
	{
		if (appdelegate.purchaseValue!=1)
		{
			//appdelegate.alarmTheme = 0;
		}
	}
	
	if(appdelegate.alarmTheme == 0)
	{
		if(isDayOn == TRUE)
		{
			if([appdelegate.alarmTimeArray count] == 0)
			{
				//self.onoff=FALSE;
				alarmOff1.hidden=YES;
				//if(alarmOn1==nil)
				alarmOn1 = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
				if (appdelegate.screenHeight1!=1024) {
					alarmOn1.frame=CGRectMake(alarmOn1.frame.origin.x/ratioWidth, alarmOn1.frame.origin.y/ratioHeight, 155/ratioWidth,118/ratioHeight);
					
				}
				UIImage *on= [UIImage imageNamed:@"on_01.png"];
				[alarmOn1 setImage:on];
				[alarmView addSubview:alarmOn1];
				[alarmOn1 release];
			}else
			{
				//self.onoff=TRUE;
				alarmOn1.hidden=YES;
				//if(alarmOff1==nil)
				alarmOff1 = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
				if (appdelegate.screenHeight1!=1024) {
					alarmOff1.frame=CGRectMake(alarmOff1.frame.origin.x/ratioWidth, alarmOff1.frame.origin.y/ratioHeight, 155/ratioWidth,118/ratioHeight);
					
				}
				UIImage *off= [UIImage imageNamed:@"off_brown.png"];
				[alarmOff1 setImage:off];
				[alarmView addSubview:alarmOff1];
				[alarmOff1 release];
				
			}
		}
		else
		{
			if(onoff==TRUE)
			{
				//self.onoff=FALSE;
				alarmOff1.hidden=YES;
				//if(alarmOn1==nil)
				alarmOn1 = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
				if (appdelegate.screenHeight1!=1024) {
					alarmOn1.frame=CGRectMake(alarmOn1.frame.origin.x/ratioWidth, alarmOn1.frame.origin.y/ratioHeight, 155/ratioWidth,118/ratioHeight);
					
				}
				UIImage *on= [UIImage imageNamed:@"on_green.png"];
				[alarmOn1 setImage:on];
				[alarmView addSubview:alarmOn1];
				[alarmOn1 release];
			}else
			{
				//self.onoff=TRUE;
				alarmOn1.hidden=YES;
				//if(alarmOff1==nil)
				alarmOff1 = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
				if (appdelegate.screenHeight1!=1024) {
					alarmOff1.frame=CGRectMake(alarmOff1.frame.origin.x/ratioWidth, alarmOff1.frame.origin.y/ratioHeight, 155/ratioWidth,118/ratioHeight);
					
				}
				UIImage *off= [UIImage imageNamed:@"off_green.png"];
				[alarmOff1 setImage:off];
				[alarmView addSubview:alarmOff1];
				[alarmOff1 release];
				
			}
		}
	}
	else if(appdelegate.alarmTheme == 1)
	{
		if(onoff==TRUE)
		{
			//self.onoff=FALSE;
			alarmOff1.hidden=YES;
			//if(alarmOn1==nil)
			alarmOn1 = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
			if (appdelegate.screenHeight1!=1024) {
				alarmOn1.frame=CGRectMake(alarmOn1.frame.origin.x/ratioWidth, alarmOn1.frame.origin.y/ratioHeight, 155/ratioWidth,118/ratioHeight);
				
			}
			UIImage *on= [UIImage imageNamed:@"on_green.png"];
			[alarmOn1 setImage:on];
			[alarmView addSubview:alarmOn1];
			[alarmOn1 release];
		}else
		{
			//self.onoff=TRUE;
			alarmOn1.hidden=YES;
			//if(alarmOff1==nil)
			alarmOff1 = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
			if (appdelegate.screenHeight1!=1024) {
				alarmOff1.frame=CGRectMake(alarmOff1.frame.origin.x/ratioWidth, alarmOff1.frame.origin.y/ratioHeight, 155/ratioWidth,118/ratioHeight);
				
			}
			UIImage *off= [UIImage imageNamed:@"off_green.png"];
			[alarmOff1 setImage:off];
			[alarmView addSubview:alarmOff1];
			[alarmOff1 release];
			
		}
	}
	else if(appdelegate.alarmTheme == 2)
	{
		if([appdelegate.alarmTimeArray count] == 0)
		{
			[alarmOnOff removeFromSuperview];
			//if(alarmOnOff==nil)
			alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
			if (appdelegate.screenHeight1!=1024) {
				alarmOnOff.frame=CGRectMake(alarmOnOff.frame.origin.x/ratioWidth, alarmOnOff.frame.origin.y/ratioHeight-30, 155/ratioWidth,118/ratioHeight);
				
			}
			UIImage *on= [UIImage imageNamed:@"off_green.png"];
			[alarmOnOff setImage:on];
			[alarmView addSubview:alarmOnOff];
			[alarmOnOff release];
		}
		else 
		{
			[alarmOnOff removeFromSuperview];
			//if(alarmOnOff==nil)
			alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
			if (appdelegate.screenHeight1!=1024) {
				alarmOnOff.frame=CGRectMake(alarmOnOff.frame.origin.x/ratioWidth, alarmOnOff.frame.origin.y/ratioHeight-30, 155/ratioWidth,118/ratioHeight);
				
			}
			UIImage *off= [UIImage imageNamed:@"on_green.png"];
			[alarmOnOff setImage:off];
			[alarmView addSubview:alarmOnOff];
			[alarmOnOff release];
		}
	}
	
	
	
	NSUserDefaults *prefs1 = [NSUserDefaults standardUserDefaults];
	
	appdelegate.purchaseValue = [[prefs1 stringForKey:@"alarmpurchasedtheme"] intValue];
	appdelegate.alarmTheme= [[prefs1 stringForKey:@"alarmThemeValue"] intValue];
	appdelegate.myvalue  = [[prefs1 stringForKey:@"alarmpurchasedtheme1"] intValue];
	
	
	
	//NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	//	
	//	int myvalue  = [[prefs stringForKey:@"alarmpurchasedtheme1"] intValue] ;
	//	
	if(appdelegate.myvalue==1)
	{
		appdelegate.purchaseValue = 1;
	}
	
	
	
	//if (appdelegate.purchaseValue!=1)
	//	{
	//		appdelegate.alarmTheme = 0;
	//	}
	
	UIImage *img ;	
	
	if(isDayOn == TRUE)
	{
		isDayOn = FALSE;
		
		if(appdelegate.alarmTheme == 0)
		{
			//[charcterImageView removeFromSuperview];
			//			img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ZB_background_04.jpg" ofType:@""]];
			//			[charcterImageView setImage:img];
			//			[alarmView addSubview:charcterImageView];
			//		//	[self addEyeAnimation];
			
			[self performSelector:@selector(animates)];
			
			
			if(time2.image == nil)
			{
				//min1.frame =CGRectMake(550, 344, 212,261);
				//				min2.frame=CGRectMake(350, 344, 212,261);//(100, 210, 40, 60);
				//				time1.frame =CGRectMake(150, 344, 212,261);//(50, 210, 40, 60);
				//				time2.frame =CGRectMake(0, 344, 217,261);//(225, 240, 35, 35);
				//				amPm.frame = CGRectMake(580, 600, 162,85);
				
				timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
				colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
				if (appdelegate.screenHeight1!=1024) {
					colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
					
				}
				colImage.image = timcoln;
				//[timcoln release];
			}
			else
			{
				//min1.frame =CGRectMake(550, 344, 212,261);
				//				min2.frame=CGRectMake(350, 344, 212,261);//(100, 210, 40, 60);
				//				time1.frame =CGRectMake(150, 344, 212,261);//(50, 210, 40, 60);
				//				time2.frame =CGRectMake(0, 344, 217,261);//(225, 240, 35, 35);
				//				amPm.frame = CGRectMake(580, 600, 162,85);
				
				timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
				colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
				if (appdelegate.screenHeight1!=1024) {
					colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
					
				}
				colImage.image = timcoln;
				//[timcoln release];
			}
			
			
		}
		
		else if(appdelegate.alarmTheme == 1)
		{
			[charcterImageView stopAnimating];		
			[charcterImageView removeFromSuperview];
			//			img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ZB_background_06.jpg" ofType:@""]];
			img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@Adam's-clock_03.png",iPhoneORiPad] ofType:@""]];			
			self.imageFileName=[NSString stringWithFormat:@"%@Adam's-clock_03.png",iPhoneORiPad];
			[charcterImageView setImage:img];
			[alarmView addSubview:charcterImageView];
			[alarmView addSubview:transparentImage];
			//[img release];
			
			if(time2.image == nil)
			{
				
				timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
				colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
				if (appdelegate.screenHeight1!=1024) {
					colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
					
				}
				colImage.image = timcoln;
				//[timcoln release];	
			}
			else {
				timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
				colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
				if (appdelegate.screenHeight1!=1024) {
					colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
					
				}
				colImage.image = timcoln;
				//[timcoln release];
			}
			
		}
		else if(appdelegate.alarmTheme == 2)////////////
		{
			
			[charcterImageView stopAnimating];
			[charcterImageView removeFromSuperview];
			//			img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ZB_background_08.jpg" ofType:@""]];
			img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@Adam's-clock_01.png",iPhoneORiPad] ofType:@""]];	
			self.imageFileName=[NSString stringWithFormat:@"%@Adam's-clock_01.png",iPhoneORiPad];
			[charcterImageView setImage:img];
			[alarmView addSubview:charcterImageView];
			[alarmView addSubview:transparentImage];
			if(time2.image == nil)
			{
				timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
				colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
				if (appdelegate.screenHeight1!=1024) {
					colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
					
				}
				colImage.image = timcoln;
				//[timcoln release];
			}
			else {
				timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
				colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
				if (appdelegate.screenHeight1!=1024) {
					colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
					
				}
				colImage.image = timcoln;
				//[timcoln release];
			}
			
			
			
			
		}
		
	}
	else //packbg_3_0.png
	{
		isDayOn = TRUE;
		
        if(appdelegate.alarmTheme == 0)//ZB_background_04.jpg
		{
			//[charcterImageView removeFromSuperview];
			//			img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ZB_background_03.jpg" ofType:@""]];
			//			[charcterImageView setImage:img];
			//			[alarmView addSubview:charcterImageView];
			[self performSelector:@selector(animates)];
			//[self addEyeAnimation];
			
			if(time2.image == nil)
			{
				//min1.frame =CGRectMake(550, 344, 212,261);
				//				min2.frame=CGRectMake(350, 344, 212,261);//(100, 210, 40, 60);
				//				time1.frame =CGRectMake(150, 344, 212,261);//(50, 210, 40, 60);
				//				time2.frame =CGRectMake(0, 344, 217,261);//(225, 240, 35, 35);
				//				amPm.frame = CGRectMake(580, 600, 162,85);
				
				timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"dots.png"] ofType:@""]];
				colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
				if (appdelegate.screenHeight1!=1024) {
					colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
					
				}
				colImage.image = timcoln;
				//[timcoln release]; 
			}
			else
			{
				//min1.frame =CGRectMake(550, 344, 212,261);
				//				min2.frame=CGRectMake(350, 344, 212,261);//(100, 210, 40, 60);
				//				time1.frame =CGRectMake(150, 344, 212,261);//(50, 210, 40, 60);
				//				time2.frame =CGRectMake(0, 344, 217,261);//(225, 240, 35, 35);
				//				amPm.frame = CGRectMake(580, 600, 162,85);
				
				timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"dots.png"] ofType:@""]];
				colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
				if (appdelegate.screenHeight1!=1024) {
					colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
					
				}
				colImage.image = timcoln;
				//[timcoln release]; 
			}
		}
		
		else if(appdelegate.alarmTheme == 1)
		{
			[charcterImageView stopAnimating];			
			[charcterImageView removeFromSuperview];
			//			img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ZB_background_05.jpg" ofType:@""]];
			img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@Adam's-clock_04.png",iPhoneORiPad] ofType:@""]];
			self.imageFileName=[NSString stringWithFormat:@"%@Adam's-clock_04.png",iPhoneORiPad];
			[charcterImageView setImage:img];
			//[img release];
			[alarmView addSubview:charcterImageView];
			[alarmView addSubview:transparentImage];
			if(time2.image == nil)
			{
				timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
				colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
				if (appdelegate.screenHeight1!=1024) {
					colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
					
				}
				colImage.image = timcoln;
				//[timcoln release];
			}
			else {
				
				
				
				
				timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
				colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
				if (appdelegate.screenHeight1!=1024) {
					colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
					
				}
				colImage.image = timcoln;
				//[timcoln release];
			}
			
		}
		else if(appdelegate.alarmTheme == 2)
		{
			[charcterImageView stopAnimating];
			[charcterImageView removeFromSuperview];
			//			img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ZB_background_07.jpg" ofType:@""]];
			img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@Adam's-clock_01.png",iPhoneORiPad] ofType:@""]];	
			self.imageFileName=[NSString stringWithFormat:@"%@Adam's-clock_01.png",iPhoneORiPad];
			[charcterImageView setImage:img];
			//[img release];
			[alarmView addSubview:charcterImageView];
			[alarmView addSubview:transparentImage];
			if(time2.image == nil)
			{
				timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
				colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
				if (appdelegate.screenHeight1!=1024) {
					colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
					
				}
				colImage.image = timcoln;
				//[timcoln release];
			}
			else {
				timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
				colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
				if (appdelegate.screenHeight1!=1024) {
					colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
					
				}
				colImage.image = timcoln;
				//[timcoln release];
			}
			
		}
		
		
		
	}
	min2.frame=CGRectMake(0, 30, 125,150);//(100, 210, 40, 60);
	min1.frame =CGRectMake(CGRectGetMaxX(min2.frame)-20, 30, 125,150);
	
	time2.frame =CGRectMake(0, 30, 125,150);//(225, 240, 35, 35);
	time1.frame =CGRectMake(CGRectGetMaxX(time2.frame)-20, 30, 125,150);//(50, 210, 40, 60);
	
	amPm.frame = CGRectMake(450, CGRectGetMaxY(min2.frame)-10, 60,40);
		if (appdelegate.screenHeight1!=1024) {
			min2.frame=CGRectMake(min2.frame.origin.x/ratioWidth, min2.frame.origin.y/ratioHeight, 125/ratioWidth,150/ratioHeight);//(100, 210, 40, 60);
			min1.frame =CGRectMake(min1.frame.origin.x/ratioWidth, min1.frame.origin.y/ratioHeight, 125/ratioWidth,150/ratioHeight);
			
			time2.frame =CGRectMake(time2.frame.origin.x/ratioWidth, time2.frame.origin.y/ratioHeight, 125/ratioWidth,150/ratioHeight);//(225, 240, 35, 35);
			time1.frame =CGRectMake(time1.frame.origin.x/ratioWidth, time1.frame.origin.y/ratioHeight, 125/ratioWidth,150/ratioHeight);//(50, 210, 40, 60);
			
			amPm.frame = CGRectMake(450/ratioWidth, CGRectGetMaxY(min2.frame)-10/ratioHeight, 60/ratioWidth,40/ratioHeight);
			
		}		
	
	[transparentImage addSubview:colImage];
	[self viewLoadMethod];
	[self.view bringSubviewToFront:(UIButton *)[self.view viewWithTag:99]];
	[self addtimeView];
	
}

-(void)checkBoughtValue
{
	
}
//-(IBAction)volumeBtnAction{
//	
//	if(isVolume == TRUE){
//		[appdelegate playAlarm];
//		
//		isVolume = FALSE;
//		slider = [[UISlider alloc] initWithFrame:CGRectMake(320, 780, 290, 170) ];//80, 388, 150, 40
//		if (appdelegate.screenHeight1!=1024) {
//			slider.frame=CGRectMake(slider.frame.origin.x/ratioWidth, slider.frame.origin.y/ratioHeight, 290/ratioWidth,170/ratioHeight);
//			
//		}
//		slider.minimumValue = 0.00;
//		slider.maximumValue = 1.00;
//		slider.value = appdelegate.volumeLevel;
//		[slider addTarget:self action:@selector(volumeChanged) forControlEvents:UIControlEventValueChanged];
//		slider.continuous = YES;
//		
//		[alarmView addSubview:slider];
//	}
//	else {
//		[appdelegate.musicPlayer stop];
//		[appdelegate.audioPlayer stop];
//		isVolume = TRUE;
//		[slider removeFromSuperview];
//		[slider release];
//	}
//	
//	
//}

-(IBAction)selectSongsAction{
	[slideshowTimer invalidate];
	slideshowTimer=nil;
	[appdelegate.musicPlayer stop];
	[appdelegate.audioPlayer stop];
//	if (isVolume == FALSE) {
//		[self volumeBtnAction];
//	}
	if(sound == nil){
        
		sound = [[MusicListController alloc]initWithNibName:@"MusicListController" bundle:nil];
        
	}
    
    sound.navigationController.navigationBar.frame=CGRectMake(0, 0, appdelegate.screenWidth1, 44);
	//[self presentModalViewController:sound animated:YES];
//	[UIView beginAnimations:nil context:nil];
//	
//	[UIView setAnimationDuration:1.2f];
//	[UIView setAnimationDelegate:self];
//	
//	//UIView *vw =[[UIView alloc]initWithFrame:<#(CGRect)frame#>
//	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:alarmView cache:YES];
	
	[self.view addSubview:sound.view];
	
	//[UIView commitAnimations];
	//[self.view addSubview:sound.view];
}
//-(void)volumeChanged{
//	appdelegate.volumeLevel = slider.value;
//	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//	NSString *IndexString = [NSString stringWithFormat:@"%d$$$%d###%f",appdelegate.newSection,appdelegate.songIndex,appdelegate.volumeLevel];
//	[prefs setObject:IndexString forKey:@"AlarmIndex"];
//	if(appdelegate.newSection==0)
//		appdelegate.musicPlayer.volume = slider.value;
//	else {
//		appdelegate.audioPlayer.volume = slider.value;
//	}
//}


-(void)btnWheatherAction
{
	[slideshowTimer invalidate];
	slideshowTimer=nil;
	isZipcodeView = FALSE;
	
	
	if(isPickerClicked == FALSE)
	{
		
		[min1 removeFromSuperview];
		[min2 removeFromSuperview];
		[time1 removeFromSuperview];
		[time2 removeFromSuperview];
		[amPm removeFromSuperview];
		[colImage removeFromSuperview];
		//[self removePreviousThemeFootprint];
		UIImage *img ;
		
		//[appdelegate.aNavigation setNavigationBarHidden:NO];
		[self.view addSubview:zipview];
		if (appdelegate.screenHeight1!=1024) {
			zipview.frame=CGRectMake(zipview.frame.origin.x/ratioWidth, zipview.frame.origin.y/ratioHeight, 768/ratioWidth,1024/ratioHeight);
			
		}
		
		UIImageView *bgView =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,768 ,1024-44-appdelegate.tabBarController.tabBar.frame.size.height)];
		if (appdelegate.screenHeight1!=1024) {
			bgView.frame=CGRectMake(bgView.frame.origin.x/ratioWidth, bgView.frame.origin.y/ratioHeight, 768/ratioWidth,1024/ratioHeight);
			
		}
		img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"zipBg.png" ofType:@""]];
		[bgView setImage:img];
		//[img release];
		[countryWheatherView addSubview:bgView];
		[bgView release];
		//[self.view addSubview:countryWheatherView];
		
		[zipview addSubview:countryWheatherView];
		
		bgView =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,768 ,1024)];
		if (appdelegate.screenHeight1!=1024) {
			bgView.frame=CGRectMake(bgView.frame.origin.x/ratioWidth, bgView.frame.origin.y/ratioHeight, 768/ratioWidth,1024/ratioHeight);
			
		}
		img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"zipBg.png" ofType:@""]];
		[bgView setImage:img];
		//[img release];
		[countryWheatherView addSubview:bgView];
		[bgView release];
		[self.view addSubview:zipview];
		
		
		//self.navigationItem.rightBarButtonItem = BARBUTTON(@"Done", @selector(setAsDefaultBtnAction));
		//		self.navigationItem.leftBarButtonItem = BARBUTTON(@"Back", @selector(backBtnAction));
		//		self.title = @"Enter ZipCode";
		
		isPickerClicked = TRUE;
		
		//uiPicker = [[UIPickerView alloc] initWithFrame : CGRectZero];
		//		uiPicker.delegate = self;
		//		uiPicker.dataSource = self;
		//		uiPicker.showsSelectionIndicator = YES;
		//		uiPicker.frame = CGRectMake ( 0, 150, 320, 100 ) ;
		//		[countryWheatherView addSubview:uiPicker];
		
		
		textField = [[UITextField alloc] initWithFrame:CGRectMake(135,75, 120, 25)];
		//if (appdelegate.screenHeight1!=1024) {
//			textField.frame=CGRectMake(textField.frame.origin.x/ratioWidth, textField.frame.origin.y/ratioHeight, 120/ratioWidth,25/ratioHeight);
//			
//		}
		textField.delegate = self;
		//textField.returnKeyType = UIReturnKeyDone;
		textField.backgroundColor = [UIColor clearColor];
		[textField setTextColor:[UIColor blackColor]];
		[textField setBorderStyle:UITextBorderStyleLine];
		textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
		textField.adjustsFontSizeToFitWidth = TRUE;
		textField.keyboardType = UIKeyboardTypeAlphabet;
		[countryWheatherView addSubview:textField];
		
		zipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 80, 25)];
		
		//if (appdelegate.screenHeight1!=1024) {
//			zipLabel.frame=CGRectMake(zipLabel.frame.origin.x/ratioWidth, zipLabel.frame.origin.y/ratioHeight, 80/ratioWidth,25/ratioHeight);
//			
//		}
		
		[zipLabel setBackgroundColor:[UIColor clearColor]];
		[zipLabel setTextColor:[UIColor whiteColor]];
		[zipLabel setText:@"ZipCode"];
		[countryWheatherView addSubview:zipLabel];
		
		
		//UIButton *setAsDefaultBtn = [[UIButton alloc]initWithFrame:CGRectMake(210,25,100,35)];
		//		setAsDefaultBtn.backgroundColor = [UIColor redColor];
		//		[setAsDefaultBtn addTarget:self action:@selector(setAsDefaultBtnAction) forControlEvents:UIControlEventTouchUpInside];
		//		[countryWheatherView addSubview:setAsDefaultBtn];
		//		
		//		
		//		
		//		UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 15, 50, 25)];
		//		//UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 470, 100, 100)];
		//		//backBtn.backgroundColor = [UIColor redColor];
		//		[backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
		//		[countryWheatherView addSubview:backBtn];
		
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSString *strzip = [prefs stringForKey:@"alarmZipCode"] ;
		int newValue = [strzip intValue];
		//NSString *countryStr = [prefs stringForKey:@"alarmCountryName"];
		
		if(!newValue==0)
		{
			[textField setText:strzip];
			//arrayIndex = [myArray indexOfObject:countryStr] ;
			
		}
		else 
		{
			[textField setText:zipCodeNo];
			//arrayIndex = [myArray indexOfObject:countryName] ;
			
		}
		
		
		//[uiPicker selectRow:arrayIndex inComponent:0 animated:YES];
		
		
		
	}
	
}


-(void)backBtnAction
{
	if (slideshowTimer==nil) {
        if ([[(UIButton *)[self.view viewWithTag:99] currentTitle] isEqualToString:@"Pause"]) {
            slideshowTimer=[NSTimer scheduledTimerWithTimeInterval:appdelegate.slideShowTime target:self selector:@selector(slideShow) userInfo:nil repeats:YES];
        }
		
	}
	[appdelegate.aNavigation setNavigationBarHidden:YES];
	
	[countryWheatherView removeFromSuperview];
	[wheatherReportView removeFromSuperview];
	[tempImgView1 removeFromSuperview];
	[tempImgView2 removeFromSuperview];
	[degreeImgView removeFromSuperview];
	[zipview removeFromSuperview];
	
	isPickerClicked = FALSE;
	[textField resignFirstResponder];
	
	[self viewLoadMethod];
	[self.view bringSubviewToFront:(UIButton *)[self.view viewWithTag:99]];
	[self addtimeView];
}


-(void)setAsDefaultBtnAction
{
	if (slideshowTimer==nil) {
        if ([[(UIButton *)[self.view viewWithTag:99] currentTitle] isEqualToString:@"Pause"]) {
            slideshowTimer=[NSTimer scheduledTimerWithTimeInterval:appdelegate.slideShowTime target:self selector:@selector(slideShow) userInfo:nil repeats:YES];
        }
	}
	[countryWheatherView removeFromSuperview];
	[wheatherReportView removeFromSuperview];
	[tempImgView1 removeFromSuperview];
	[tempImgView2 removeFromSuperview];
	[degreeImgView removeFromSuperview];
	[zipview removeFromSuperview];
	
	[textField resignFirstResponder];
	
	//[appdelegate.aNavigation setNavigationBarHidden:YES];
	
	NSString *str = textField.text;
	
	if(![str isEqualToString:nil])
	{
		
		[self showWeatherFor:str ];
		
	}
	
	
	//NSString *themeIndex = [NSString stringWithFormat:@"%d",appdelegate.alarmTheme];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:str forKey:@"alarmZipCode"];
	[prefs synchronize];
	
	
	//int iCountryIndex = [NSString stringWithFormat:@"%d",countryCode];
	//NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:countryCode forKey:@"alarmCountryName"];
	[prefs synchronize];
	
	
	
	
	isPickerClicked = FALSE;
	[textField resignFirstResponder];
	
	[self viewLoadMethod];
    [self.view bringSubviewToFront:(UIButton *)[self.view viewWithTag:99]];
	//[alarmView addSubview:amPm];
	[self addtimeView];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return !([newString length] > 6);
}

//- (UIView *) pickerView:(UIPickerView *)pickerView
//			 viewForRow:(NSInteger)row
//		   forComponent: (NSInteger)component reusingView:(UIView *)view
//{
//    CGRect cellFrame = CGRectMake(10.0, 0.0, 300, 32.0);
//    UILabel *newView = [[[UILabel alloc] initWithFrame:cellFrame] autorelease];
//    newView.backgroundColor = [UIColor lightGrayColor];
//	//newView.alpha = .5;
//	//[UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:1.0];
//	newView.text = [myArray objectAtIndex:row];
//    return newView;
//}
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//	return 1;
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//	return [myArray count];
//}
//
//#pragma mark Picker Delegate Methods
//
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//
//	return [myArray objectAtIndex:row];
//}
//
//
//
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//	countryCode	= [myArray objectAtIndex:row] ;	
//	[textField resignFirstResponder];
//	
//	
//	//countryCode = [myArray indexOfObject:strCountry];
//}


-(IBAction)editAction:(id)sender{
	//NSMutableArray *notificationArray =(NSMutableArray *) [[UIApplication sharedApplication] scheduledLocalNotifications];
	if (slideshowTimer==nil) {
        if ([[(UIButton *)[self.view viewWithTag:99] currentTitle] isEqualToString:@"Pause"]) {
            slideshowTimer=[NSTimer scheduledTimerWithTimeInterval:appdelegate.slideShowTime target:self selector:@selector(slideShow) userInfo:nil repeats:YES];
        }
	}
	if([appdelegate.alarmTimeArray count]==0)
	{
		[self backAction];
		return;
	}
	if(self.editing)
	{
		[super setEditing:NO animated:NO]; 
		[newtable setEditing:NO animated:YES];
		
		UIBarButtonItem *btn = (UIBarButtonItem*)sender;
		[btn setTitle:@"Edit"];
		
	}
	else
	{
		[super setEditing:YES animated:YES]; 
		[newtable setEditing:YES animated:YES];
		
		UIBarButtonItem *btn = (UIBarButtonItem*)sender;
		[btn setTitle:@"Done"];
		
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 1;
			break;
		case 1:
		{
			
			return [appdelegate.alarmTimeArray count];
		}
			break;
			
	}
	return 0;
}

-(void)ResetAllAlarm
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:@"" forKey:@"AlarmSettings"];
	[prefs synchronize];
	[appdelegate.alarmTimeArray removeAllObjects];
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
	
}

//- (void)viewDidAppear:(BOOL)animated {
//	appdelegate.alarmArray = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] arrayForKey:@"alarmtime"];
//	if(appdelegate.alarmArray == nil)
//		appdelegate.alarmArray = [[NSMutableArray alloc]init];
//	for(int k = 0 ;k<[appdelegate.alarmArray count];k++)
//	{
//		appdelegate.totalTime = [appdelegate.alarmArray objectAtIndex:k];
//		
//	}
//    [super viewDidAppear:animated];
//}

-(void)viewWillDisappear:(BOOL)animated
{
	//[slideshowTimer invalidate];
	//slideshowTimer =nil;
}
- (void)viewWillAppear:(BOOL)animated  {
	//if (slideshowTimer==nil) {
//		slideshowTimer=[NSTimer scheduledTimerWithTimeInterval:appdelegate.slideShowTime target:self selector:@selector(slideShow) userInfo:nil repeats:YES];
//	}
//	
	
	NSString *str = [[NSUserDefaults standardUserDefaults] stringForKey:@"alarmZipCode"];
	int iValue = [str intValue];
	
	if(iValue == 0)
	{
        if (!locmanager) {
            locmanager = [[CLLocationManager alloc] init]; 
            [locmanager setDelegate:self]; 
            [locmanager setDesiredAccuracy:kCLLocationAccuracyBest];
            [locmanager startUpdatingLocation];
        }
		
        //[locmanager release];
        //locmanager=nil;
	}
	else 
	{
		[self showWeatherFor:str ];
	}
	
	if(thisApp==nil)
		thisApp = [UIApplication sharedApplication];
	thisApp.idleTimerDisabled = NO;
	thisApp.idleTimerDisabled = YES;
	
	UIImage *bgImg;
	isDayOn=TRUE;
	appdelegate = (epubstore_svcAppDelegate*)[[UIApplication sharedApplication]delegate];
	[appdelegate.videoVC.view setHidden:TRUE];
	
	if(appdelegate.alarmTheme == 0)
	{
		if(isDayOn == TRUE)
		{
			if([appdelegate.alarmTimeArray count] == 0)
			{
				[alarmOnOff removeFromSuperview];
				//if(alarmOnOff==nil)
				alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
				UIImage *on= [UIImage imageNamed:@"off_brown.png"];
				[alarmOnOff setImage:on];
				[alarmView addSubview:alarmOnOff];
				[alarmOnOff release];
				
			}
			else 
			{
				[alarmOnOff removeFromSuperview];
				//if(alarmOnOff==nil)
				alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
				UIImage *off= [UIImage imageNamed:@"on_01.png"];
				[alarmOnOff setImage:off];
				[alarmView addSubview:alarmOnOff];
				[alarmOnOff release];
			}
		}
		else {
			if([appdelegate.alarmTimeArray count] == 0)
			{
				[alarmOnOff removeFromSuperview];
				//if(alarmOnOff==nil)
				alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
				UIImage *on= [UIImage imageNamed:@"off_green.png"];
				[alarmOnOff setImage:on];
				[alarmView addSubview:alarmOnOff];
				[alarmOnOff release];
				
			}
			else 
			{
				[alarmOnOff removeFromSuperview];
				//if(alarmOnOff==nil)
				alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
				UIImage *off= [UIImage imageNamed:@"on_green.png"];
				[alarmOnOff setImage:off];
				[alarmView addSubview:alarmOnOff];
				[alarmOnOff release];
			}
		}
		if (appdelegate.screenHeight1!=1024) {
			alarmOnOff.frame=CGRectMake(alarmOnOff.frame.origin.x/ratioWidth, alarmOnOff.frame.origin.y/ratioHeight-30, 155/ratioWidth,118/ratioHeight);
			
		}
		
	}
	else if(appdelegate.alarmTheme == 1)
	{
		if([appdelegate.alarmTimeArray count] == 0)
		{[alarmOnOff removeFromSuperview];
			//if(alarmOnOff==nil)
			alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
			UIImage *on= [UIImage imageNamed:@"off_green.png"];
			[alarmOnOff setImage:on];
			[alarmView addSubview:alarmOnOff];
			[alarmOnOff release];
		}
		else 
		{[alarmOnOff removeFromSuperview];
			//if(alarmOnOff==nil)
			alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
			UIImage *off= [UIImage imageNamed:@"on_green.png"];
			[alarmOnOff setImage:off];
			[alarmView addSubview:alarmOnOff];
			[alarmOnOff release];
		}
		if (appdelegate.screenHeight1!=1024) {
			alarmOnOff.frame=CGRectMake(alarmOnOff.frame.origin.x/ratioWidth, alarmOnOff.frame.origin.y/ratioHeight-30, 155/ratioWidth,118/ratioHeight);
			
		}
	}
	else if(appdelegate.alarmTheme == 2)
	{
		if([appdelegate.alarmTimeArray count] == 0)
		{
			[alarmOnOff removeFromSuperview];
			//if(alarmOnOff==nil)
			alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
			UIImage *on= [UIImage imageNamed:@"off_green.png"];
			[alarmOnOff setImage:on];
			[alarmView addSubview:alarmOnOff];
			[alarmOnOff release];
		}
		else 
		{
			[alarmOnOff removeFromSuperview];
			//if(alarmOnOff==nil)
			alarmOnOff = [[UIImageView alloc]initWithFrame:CGRectMake(320,850,155,118)];
			UIImage *off= [UIImage imageNamed:@"on_green.png"];
			[alarmOnOff setImage:off];
			[alarmView addSubview:alarmOnOff];
			[alarmOnOff release];
		}
		if (appdelegate.screenHeight1!=1024) {
			alarmOnOff.frame=CGRectMake(alarmOnOff.frame.origin.x/ratioWidth, alarmOnOff.frame.origin.y/ratioHeight-30, 155/ratioWidth,118/ratioHeight);
			
		}
	}
	
	NSUserDefaults *prefs1 = [NSUserDefaults standardUserDefaults];
	
	appdelegate.alarmTheme= [[prefs1 stringForKey:@"alarmThemeValue"] intValue];
	
	appdelegate.purchaseValue = [[prefs1 stringForKey:@"alarmpurchasedtheme"] intValue];
	
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	appdelegate.myvalue  = [[prefs stringForKey:@"alarmpurchasedtheme1"] intValue];
	
	if(appdelegate.myvalue==1)
	{
		//appdelegate.purchaseValue = 1;
	}
	
	
	
	//Added by Mani*** - Begins
	//If not yet purchased the the item and just scrolled the list of theam - we have to keep the default theam	//Added by Mani*** - Begins
	if (appdelegate.purchaseValue!=1)
	{
		
		//appdelegate.alarmTheme = 0;
	}
	//Added by Mani*** - Ends
	
	if(isStoreClicked == FALSE)
	{
		//[self removePreviousThemeFootprint];
		[amPm removeFromSuperview];
		if(appdelegate.alarmTheme == 0)
		{
			//if(appdelegate.purchaseValue!=1)
			//							return;
			
			if(isDayOn == TRUE)
			{
				//isDayOn = TRUE;
				//				[charcterImageView removeFromSuperview];
				//				bgImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ZB_background_03.jpg" ofType:@""]];
				//				[charcterImageView setImage:bgImg];
				//				[bgImg release];
				//				[alarmView addSubview:charcterImageView];
				
				[self performSelector:@selector(animates)];
				
				if(time2.image == nil)
				{
					timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"dots.png"] ofType:@""]];
					colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
					
					colImage.image = timcoln;
					//[timcoln release];
				}
				else {
					timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"dots.png"] ofType:@""]];
					colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
					colImage.image = timcoln;
					//[timcoln release];
					
				}
				if (appdelegate.screenHeight1!=1024) {
					colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
					
				}
				
			}
			else {
				//[charcterImageView removeFromSuperview];
				//				bgImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ZB_background_04.jpg" ofType:@""]];
				//				[charcterImageView setImage:bgImg];
				//				[bgImg release];
				//				[alarmView addSubview:charcterImageView];
				
				[self performSelector:@selector(animates)];
				
				if(time2.image == nil)
				{
					timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
					////////
					colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
					colImage.image = timcoln;
					//[timcoln release];
				}
				else {////
					timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
					colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
					colImage.image = timcoln;
					//[timcoln release];
				}
				if (appdelegate.screenHeight1!=1024) {
					colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
					
				}
				
			}
		}
		else if(appdelegate.alarmTheme == 1)
		{
			//if(appdelegate.purchaseValue!=1)
			//				return;
			[charcterImageView stopAnimating];
			if(isDayOn == TRUE)
			{
				isDayOn = FALSE;
				[charcterImageView removeFromSuperview];
				//				bgImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ZB_background_05.jpg" ofType:@""]];
				bgImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@Adam's-clock_03.png",iPhoneORiPad] ofType:@""]];
				self.imageFileName=[NSString stringWithFormat:@"%@Adam's-clock_03.png",iPhoneORiPad];
				[charcterImageView setImage:bgImg];
				//[bgImg release];
				[alarmView addSubview:charcterImageView];
				[alarmView addSubview:transparentImage];
				if(time2.image == nil)
				{
					timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
					colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
					colImage.image = timcoln;
					//[timcoln release];
				}
				else
				{
					timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
					colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
					colImage.image = timcoln;
					//[timcoln release];
				}
				if (appdelegate.screenHeight1!=1024) {
					colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
					
				}
				
			}
			else
			{
				
				[charcterImageView removeFromSuperview];
				//				bgImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ZB_background_06.jpg" ofType:@""]];
				bgImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@Adam's-clock_04.png",iPhoneORiPad] ofType:@""]];
				self.imageFileName=[NSString stringWithFormat:@"%@Adam's-clock_04.png",iPhoneORiPad];
				[charcterImageView setImage:bgImg];
				//[bgImg release];
				[alarmView addSubview:charcterImageView];
				[alarmView addSubview:transparentImage];
				if(time2.image == nil)
				{
					timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
					colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
					colImage.image = timcoln;
					//[timcoln release];
				}
				else {
					timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
					colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
					colImage.image = timcoln;
					//[timcoln release];
				}
				if (appdelegate.screenHeight1!=1024) {
					colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
					
				}
				
			}
		}
		else if(appdelegate.alarmTheme == 2)
		{
			//if(appdelegate.myvalue!=1)
			//				return;
			[charcterImageView stopAnimating];
			if(isDayOn == TRUE)
			{
				isDayOn = TRUE;
				[charcterImageView removeFromSuperview];
				//				bgImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ZB_background_07.jpg" ofType:@""]];
				bgImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@Adam's-clock_01.png",iPhoneORiPad] ofType:@""]];
				self.imageFileName=[NSString stringWithFormat:@"%@Adam's-clock_01.png",iPhoneORiPad];
				[charcterImageView setImage:bgImg];
				//[bgImg release];
				[alarmView addSubview:charcterImageView];
				[alarmView addSubview:transparentImage];
				if(time2.image == nil)
				{
					timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
					colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
					colImage.image = timcoln;
					//[timcoln release];
				}
				else{
					timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
					colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
					colImage.image = timcoln;
					//[timcoln release];
				}
				if (appdelegate.screenHeight1!=1024) {
					colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
					
				}
				
			}
			else {
				[charcterImageView removeFromSuperview];
				//				bgImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ZB_background_08.jpg" ofType:@""]];
				bgImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@Adam's-clock_01.png",iPhoneORiPad] ofType:@""]];
				self.imageFileName=[NSString stringWithFormat:@"%@Adam's-clock_01.png",iPhoneORiPad];
				[charcterImageView setImage:bgImg];
				//[bgImg release];
				[alarmView addSubview:charcterImageView];
				[alarmView addSubview:transparentImage];
				if(time2.image == nil)
				{
					timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
					colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
					colImage.image = timcoln;
					//[timcoln release];
				}
				else {
					timcoln = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"colun.png"] ofType:@""]];
					colImage.frame = CGRectMake(CGRectGetMaxX(hourBackImage.frame)-110, CGRectGetMinY(hourBackImage.frame)+20, 105,175);
					colImage.image = timcoln;
					//[timcoln release];
				}
				if (appdelegate.screenHeight1!=1024) {
					colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
					
				}
				
			}
			
			
		}
		
		[transparentImage addSubview:colImage];
		
		
		
		[self viewLoadMethod];
		
		[self addtimeView];
	}
	
	appdelegate.alarmTimeArray  = [appdelegate getArray];
	if(appdelegate.alarmTimeArray == nil||[appdelegate.alarmTimeArray  count]==0)
		[EditButton setTitle:@"Done"];
	else
		[EditButton setTitle:@"Edit"];
	[newtable reloadData];
}


//Added by Mani*** to clear previous theam
-(void) removePreviousThemeFootprint
{
	if(isDayOn == FALSE)
	{
		if (eyeRollImageView)
		{
			eyeRollImageView.image=nil;
			[eyeRollImageView removeFromSuperview];
		}
	}
	
	if(isDayOn == TRUE)
	{
		if (eyeAnimatingImgVw)
		{
			eyeAnimatingImgVw.image=nil;
			[eyeAnimatingImgVw removeFromSuperview];
		}
	}
	
	[min1 removeFromSuperview];
	[min2 removeFromSuperview];
	[time1 removeFromSuperview];
	[time2 removeFromSuperview];
	[amPm removeFromSuperview];
	[colImage removeFromSuperview];
	[cloudImageView removeFromSuperview];
	
	
	[wheatherReportView removeFromSuperview];
	//[wheatherReportView release];
	[tempImgView1 removeFromSuperview];
	//[tempImgView1 release];
	[tempImgView2 removeFromSuperview];
	//[tempImgView2 release];
	[degreeImgView removeFromSuperview];
	//[degreeImgView release];
	// Added by Mani*** - Ends
	
}

-(void)addEyeAnimation
{
	
	UIImage *eyeImage;
	if (isDayOn == TRUE)
	{
		
		
		[charcterImageView removeFromSuperview];
		//		eyeImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Rich's clock_02.png" ofType:@""]];
		eyeImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@Adam's-clock_01.png",iPhoneORiPad] ofType:@""]];
		self.imageFileName=[NSString stringWithFormat:@"%@Adam's-clock_01.png",iPhoneORiPad];
		//eyeImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"packbg_3_0.png" ofType:@""]];
		[charcterImageView setImage:eyeImage];
		//[eyeImage release];
		[alarmView addSubview:charcterImageView];
		[alarmView addSubview:transparentImage];
		
		animationType=1;
		
		if(eyeAnimatingImgVw ==nil)
			eyeAnimatingImgVw = [[UIImageView alloc]initWithFrame:CGRectMake(300, 300, 160.8, 71.5)];//76.1, 146.1, 160.8, 71.5
		else {
			[eyeAnimatingImgVw removeFromSuperview];
		}
		if (appdelegate.screenHeight1!=1024) {
			eyeAnimatingImgVw.frame=CGRectMake(eyeAnimatingImgVw.frame.origin.x/ratioWidth, eyeAnimatingImgVw.frame.origin.y/ratioHeight, 160.8/ratioWidth,71.5/ratioHeight);
			
		}
		[alarmView addSubview:eyeAnimatingImgVw];
	}
	else 
	{
		
		// Added by mani*** begins
		[charcterImageView removeFromSuperview];
		//		eyeImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@Adam's-clock_02.png",iPhoneORiPad] ofType:@""]];//packbg_3_1.png
		eyeImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@Adam's-clock_02.png",iPhoneORiPad] ofType:@""]];//packbg_3_1.png
		self.imageFileName=[NSString stringWithFormat:@"%@Adam's-clock_02.png",iPhoneORiPad];
		//eyeImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"packbg_3_1.png" ofType:@""]];
		[charcterImageView setImage:eyeImage];
		[alarmView addSubview:charcterImageView];
		[alarmView addSubview:transparentImage];
		//[eyeImage release];
		
		
		animationType=2;
		if(eyeRollImageView ==nil)
			eyeRollImageView = [[UIImageView alloc]initWithFrame:CGRectMake(230, 200, 320, 480)];//300, 500, 320, 480
		else {
			[eyeRollImageView removeFromSuperview];
		}
		if (appdelegate.screenHeight1!=1024) {
			eyeRollImageView.frame=CGRectMake(eyeRollImageView.frame.origin.x/ratioWidth, eyeRollImageView.frame.origin.y/ratioHeight, 320/ratioWidth,480/ratioHeight);
			
		}
		
		[alarmView addSubview:eyeRollImageView];
		
	}
	
	
}

-(void)addtimeView
{
	[min1 removeFromSuperview];
	[min2 removeFromSuperview];
	[time1 removeFromSuperview];
	[time2 removeFromSuperview];
	[amPm removeFromSuperview];
	
	//if(time2.image == nil)
	//{
	/*if(appdelegate.alarmTheme == 0)  		
	 {
	 if(isDayOn == TRUE)
	 {
	 
	 min1.frame =CGRectMake(CGRectGetMaxX(min2.frame)-20, 30, 125,150);
	 min2.frame=CGRectMake(10, 30, 125,150);//(100, 210, 40, 60);
	 time1.frame =CGRectMake(CGRectGetMaxX(time2.frame)-20, 30, 125,150);//(50, 210, 40, 60);
	 time2.frame =CGRectMake(10, 30, 125,150);//(225, 240, 35, 35);
	 amPm.frame = CGRectMake(180, CGRectGetMaxY(min2.frame), 50,50);
	 }
	 else 
	 {
	 
	 min1.frame =CGRectMake(CGRectGetMaxX(min2.frame)-20, 30, 125,150);
	 min2.frame=CGRectMake(10, 30, 125,150);//(100, 210, 40, 60);
	 time1.frame =CGRectMake(CGRectGetMaxX(time2.frame)-20, 30, 125,150);//(50, 210, 40, 60);
	 time2.frame =CGRectMake(10, 30, 125,150);//(225, 240, 35, 35);
	 amPm.frame = CGRectMake(180, CGRectGetMaxY(min2.frame), 50,50);
	 }
	 [minsBackImage addSubview:amPm];
	 
	 
	 }
	 else if(appdelegate.alarmTheme == 1 || appdelegate.alarmTheme == 2)
	 {
	 
	 
	 min1.frame =CGRectMake(CGRectGetMaxX(min2.frame)-20, 30, 125,150);
	 min2.frame=CGRectMake(10, 30, 125,150);//(100, 210, 40, 60);
	 time1.frame =CGRectMake(CGRectGetMaxX(time2.frame)-20, 30, 125,150);//(50, 210, 40, 60);
	 time2.frame =CGRectMake(10, 30, 125,150);//(225, 240, 35, 35);
	 amPm.frame = CGRectMake(180, CGRectGetMaxY(min2.frame), 50,50);
	 
	 [minsBackImage addSubview:amPm];
	 
	 
	 }
	 }
	 else
	 {
	 if(appdelegate.alarmTheme == 0)  
	 {
	 if(isDayOn == TRUE)
	 {
	 min1.frame =CGRectMake(CGRectGetMaxX(min2.frame)-20, 30, 125,150);
	 min2.frame=CGRectMake(10, 30, 125,150);//(100, 210, 40, 60);
	 time1.frame =CGRectMake(CGRectGetMaxX(time2.frame)-20, 30, 125,150);//(50, 210, 40, 60);
	 time2.frame =CGRectMake(10, 30, 125,150);//(225, 240, 35, 35);
	 amPm.frame = CGRectMake(180, CGRectGetMaxY(min2.frame), 50,50);
	 [minsBackImage addSubview:amPm];
	 }
	 else
	 {
	 min1.frame =CGRectMake(CGRectGetMaxX(min2.frame)-20, 30, 125,150);
	 min2.frame=CGRectMake(10, 30, 125,150);//(100, 210, 40, 60);
	 time1.frame =CGRectMake(CGRectGetMaxX(time2.frame)-20, 30, 125,150);//(50, 210, 40, 60);
	 time2.frame =CGRectMake(10, 30, 125,150);//(225, 240, 35, 35);
	 amPm.frame = CGRectMake(180, CGRectGetMaxY(min2.frame), 50,50);
	 
	 [minsBackImage addSubview:amPm];
	 }
	 
	 
	 }
	 else if(appdelegate.alarmTheme == 1 || appdelegate.alarmTheme == 2)
	 {*/
	min2.frame=CGRectMake(0, 30, 125,150);//(100, 210, 40, 60);
	
	min1.frame =CGRectMake(CGRectGetMaxX(min2.frame)-20, 30, 125,150);
	time2.frame =CGRectMake(0, 30, 125,150);//(225, 240, 35, 35);
	
	time1.frame =CGRectMake(CGRectGetMaxX(time2.frame)-20, 30, 125,150);//(50, 210, 40, 60);
	amPm.frame = CGRectMake(450, CGRectGetMaxY(min2.frame)-10, 60,40);
	if (appdelegate.screenHeight1!=1024) {
		//colImage.frame=CGRectMake(colImage.frame.origin.x/ratioWidth+85, colImage.frame.origin.y/ratioHeight, 105/ratioWidth,175/ratioHeight);
		min2.frame=CGRectMake(min2.frame.origin.x/ratioWidth, min2.frame.origin.y/ratioHeight, 125/ratioWidth,150/ratioHeight);//(100, 210, 40, 60);
		min1.frame =CGRectMake(min1.frame.origin.x/ratioWidth, min1.frame.origin.y/ratioHeight, 125/ratioWidth,150/ratioHeight);
		
		time2.frame =CGRectMake(time2.frame.origin.x/ratioWidth, time2.frame.origin.y/ratioHeight, 125/ratioWidth,150/ratioHeight);//(225, 240, 35, 35);
		time1.frame =CGRectMake(time1.frame.origin.x/ratioWidth, time1.frame.origin.y/ratioHeight, 125/ratioWidth,150/ratioHeight);//(50, 210, 40, 60);
		
		amPm.frame = CGRectMake(450/ratioWidth, CGRectGetMaxY(min2.frame)-10/ratioHeight, 60/ratioWidth,40/ratioHeight);
		
	}
	[transparentImage addSubview:amPm];
	
	//}
	//}
	
	
	[minsBackImage addSubview:min1];
	[minsBackImage addSubview:min2];
	[hourBackImage addSubview:time1];
	[hourBackImage addSubview:time2];
	
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	//NSString *UrlWithIndex;
	switch (indexPath.section) {
		case 0:
			cell.textLabel.text = [NSString stringWithFormat:@"Add Alarm",indexPath.row];
			break;
			
		case 1:
		{
			//NSMutableArray *notificationArray =(NSMutableArray *) [[UIApplication sharedApplication] scheduledLocalNotifications];
			AlarmSettings *alarmSettings = (AlarmSettings *)[appdelegate.alarmTimeArray objectAtIndex:indexPath.row];
			[alarmSettings retain];
			NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
			//MM/DD/YYYY
			[dateFormatter setDateFormat:@"hh:mm a"];
			//[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"IST"]];
			cell.textLabel.text = [dateFormatter stringFromDate:alarmSettings.alarmFireDate];
			
		}				
			break;
			
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	
	if(indexPath.section == 0){
		//NSMutableArray *notificationArray =(NSMutableArray *) [[UIApplication sharedApplication] scheduledLocalNotifications];
		if ([appdelegate.alarmTimeArray count]>=MaximumAlarm) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"You cannot add more than 5 alarms"
														   delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
			[alert show];
			[alert release];
			return;
			
		}
		
		AlarmDetails *alarmdetails = [[AlarmDetails alloc]initWithNibName:@"AlarmDetails" bundle:nil];
		NSDate *date	= [NSDate date];
		NSDateFormatter *formatter = [[[NSDateFormatter alloc]init]autorelease];
		
		[formatter setDateFormat:@"hh:mm a"];
		
		NSString *str = [formatter stringFromDate:date];
		
		alarmdetails.myDateString = str;
		alarmdetails.EditIndex = -1;
		alarmdetails.localArrayIndex = -1;
		[appdelegate.tabBarController presentModalViewController:alarmdetails animated:YES];
	}
	
	if(indexPath.section == 1){
		
		AlarmDetails *alarmdetails = [[AlarmDetails alloc]initWithNibName:@"AlarmDetails" bundle:nil];
		
		AlarmSettings *alarmSettings =(AlarmSettings *) [appdelegate.alarmTimeArray objectAtIndex:indexPath.row];
		[alarmSettings retain];
		NSString *mainStr = [NSString stringWithFormat:@"%d",alarmSettings.ID];
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateFormat:@"hh:mm a"];
		
		NSMutableArray *notificationArray =(NSMutableArray *) [[UIApplication sharedApplication] scheduledLocalNotifications];
		for (int k= 0;k<[notificationArray count]; k++) {
			UILocalNotification *localNotif = [notificationArray objectAtIndex:k];
			NSString *str = [localNotif.userInfo objectForKey:@"AlarmID"];
			
			if ([str isEqualToString:mainStr]) {
				NSString *selectedTime = [dateFormatter stringFromDate:localNotif.fireDate];
				alarmdetails.myDateString = selectedTime;
				alarmdetails.EditIndex = k;
				alarmdetails.localArrayIndex = indexPath.row;
				
				
				//[appdelegate.tabBarController presentModalViewController:alarmdetails animated:YES];
				
				return;
			}
		}
		
		NSString *selectedTime = [dateFormatter stringFromDate:alarmSettings.alarmFireDate];
		alarmdetails.myDateString = selectedTime;
		alarmdetails.EditIndex = -1;
		alarmdetails.localArrayIndex = indexPath.row;
		//[self presentModalViewController:alarmdetails animated:YES];
		//[self.view addSubview:alarmdetails.view];
		[appdelegate.tabBarController presentModalViewController:alarmdetails animated:YES];
		
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	
}
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	//return UITableViewCellAccessoryDetailDisclosureButton;
	return UITableViewCellAccessoryDisclosureIndicator;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
		
		NSMutableArray *notificationArray =(NSMutableArray *) [[UIApplication sharedApplication] scheduledLocalNotifications];
		
		AlarmSettings *alarmSettings = (AlarmSettings *)[appdelegate.alarmTimeArray objectAtIndex:indexPath.row];
		[alarmSettings retain];
		NSString *myRepeatString =[NSString stringWithFormat:@"N"];
		if (alarmSettings.repeat==YES) {
			myRepeatString =[NSString stringWithFormat:@"N"];
		}
		//NSString *mainStr = [NSString stringWithFormat:@"%@$$$%d",myRepeatString,alarmSettings.ID];
		
		for (int k= 0;k<[notificationArray count]; k++) {
			UILocalNotification *localNotif = [notificationArray objectAtIndex:k];
			NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
			[dateFormatter setDateFormat:@"hh:mm a"];
			NSString *notifyAlarmDate = [dateFormatter stringFromDate:localNotif.fireDate];
			NSString *savedAlarmDate = [dateFormatter stringFromDate:alarmSettings.alarmFireDate];
			//NSString *str = [localNotif.userInfo objectForKey:@"AlarmID"];
			if ([notifyAlarmDate isEqualToString:savedAlarmDate]) {
				[[UIApplication sharedApplication] cancelLocalNotification:localNotif];
				
			}
		}
		
		[appdelegate.alarmTimeArray removeObjectAtIndex:indexPath.row];
		
		//[tableView deleteRowsAtIndexPaths:array withRowAnimation:YES];
		
		
		
		if ([appdelegate.alarmTimeArray count]==0) {
			[EditButton setTitle:@"Done"];
			[super setEditing:NO animated:NO]; 
			[newtable setEditing:NO animated:YES];
			//[[UIApplication sharedApplication] cancelAllLocalNotifications];
		}
		
		//		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		//		[prefs setObject:appdelegate.alarmTimeArray forKey:@"AlarmTimeArray"];
		//		[prefs synchronize];
		
		[appdelegate saveArray:appdelegate.alarmTimeArray];
		
		[tableView reloadData];
		
	}   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }  
	
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Detemine if it's in editing mode
    if (self.editing) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
//    // In the simplest, most efficient, case, reload the table view.
//    if (!self.tableView.editing) 
//        [self.tableView reloadData];
//}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	
	if (indexPath.section == 0) {
		return NO;
	}
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
////==================
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
 }
 */

//- (void)didReceiveMemoryWarning {
//	// Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
//	
//	// Release any cached data, images, etc that aren't in use.
//}
//
//- (void)viewDidUnload {
//	// Release any retained subviews of the main view.
//	// e.g. self.myOutlet = nil;
//}


- (void)dealloc {
    [super dealloc];
	
	[myImages release];
	[amPm release];
	[min1 release];
	[min2 release];
	[time1 release];
	[time2 release];
	[storeView release];
	
	//[vid release];
	
	if (eyeAnimatingImgVw) 
	{
		[eyeAnimatingImgVw release];
	}
	
	if (eyeRollImageView) 
	{
		[eyeRollImageView release];
	}
	
	
}

/* Start Of Add */

//- (NSString *)adWhirlApplicationKey {
//    return kSampleAppKey;
//}
//
//- (UIViewController *)viewControllerForPresentingModalView {
//    return self;
//}
//
//- (NSURL *)adWhirlConfigURL {
//    return [NSURL URLWithString:kSampleConfigURL];
//}
//
//- (NSURL *)adWhirlImpMetricURL {
//    return [NSURL URLWithString:kSampleImpMetricURL];
//}
//
//- (NSURL *)adWhirlClickMetricURL {
//    return [NSURL URLWithString:kSampleClickMetricURL];
//}
//
//- (NSURL *)adWhirlCustomAdURL {
//    return [NSURL URLWithString:kSampleCustomAdURL];
//}


- (CLLocation *)locationInfo {
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    CLLocation *location = [locationManager location];
    [locationManager release];
    return location;
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
    CGPoint tempPoint =[touch locationInView:self.view];
	if (CGRectContainsPoint(transparentImage.frame, [touch locationInView:alarmView])) {
		if (CGRectContainsPoint(wheatherReportView.frame, [touch locationInView:transparentImage])) {
			[self performSelector:@selector(btnWheatherAction)];
		}
		else {
			isMove=YES;
			startPoint=[touch locationInView:transparentImage];
		}

		
	}
	else {
		if(isZipcodeView==TRUE)
		{
			if(tempPoint.y<=50){
			}
			//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.elitegudz.com/wordpress"]];
		}
		
		else 
		{
			
			[textField resignFirstResponder];
			//		[super touchesBegan:touches withEvent:event];
			//		
			//		NSString *str = textField.text;
			////		uiPicker.hidden = YES;
			////		textField.hidden = YES;
			////		zipLabel.hidden = YES;
			////		isPickerClicked = FALSE;
			//		if(str!=nil)
			//			[self showWeatherFor:str ];
			//		
			//		wheatherReportView.frame = CGRectMake(0, 5, 320,127);
			//		tempImgView1.frame = CGRectMake(0, 15, 320,94);
			//		tempImgView2.frame = CGRectMake(0, 15, 320,94);
			//		degreeImgView.frame = CGRectMake(20, 15, 320,94);
			//		
			//		[countryWheatherView addSubview:wheatherReportView];
			//		[countryWheatherView addSubview:tempImgView1];
			//		[countryWheatherView addSubview:tempImgView2];
			//		[countryWheatherView addSubview:degreeImgView];
			
			
		}
	}

	
	
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	if(isMove)
	{
		CGPoint activePoint = [[touches anyObject] locationInView:transparentImage];
		
		// Determine new point based on where the touch is now located
		CGPoint newPoint = CGPointMake(transparentImage.center.x + (activePoint.x - startPoint.x),
									   transparentImage.center.y + (activePoint.y - startPoint.y));
		
		//--------------------------------------------------------
		// Make sure we stay within the bounds of the parent view
		//--------------------------------------------------------
		CGRect rect = transparentImage.bounds;
		rect.origin.y=38;
		rect.size.height=975;
		if (appdelegate.screenHeight1!=1024) {
			rect.size.height=431;
			rect.origin.y=39;
		}
		float midPointX = CGRectGetMidX(transparentImage.bounds);
		// If too far right...
		if (newPoint.x > transparentImage.superview.bounds.size.width  - midPointX)
			newPoint.x = transparentImage.superview.bounds.size.width - midPointX;
		else if (newPoint.x < midPointX)  // If too far left...
			newPoint.x = midPointX;
		
		float midPointY = CGRectGetMidY(transparentImage.bounds);
		// If too far down...
		
		//else if(newPoint.y>CGRectGetMinY(transparentImage.bounds))
			//newPoint.y = CGRectGetMinY(transparentImage.bounds);
		if (newPoint.y > rect.size.height  - midPointY)
			newPoint.y = rect.size.height - midPointY;
		else if (newPoint.y < midPointY)  // If too far up...
			newPoint.y = midPointY;
		if (newPoint.y<rect.origin.y+midPointY)
			newPoint.y=rect.origin.y+midPointY;
		// Set new center location
		transparentImage.center = newPoint;
		//NSSet *allTouches = [event allTouches];
//		//UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
//		movePoint=[[touches anyObject] locationInView:alarmView];
//		CGPoint previousLocation = [[touches anyObject] previousLocationInView:alarmView];
//		//if (CGRectContainsRect(alarmView.frame, CGRectMake(transparentImage.frame.origin.x+(movePoint.x-previousLocation.x), transparentImage.frame.origin.y+(movePoint.y-previousLocation.y), transparentImage.frame.size.width, transparentImage.frame.size.height))) {
//		CGPoint newpoint=CGPointMake(transparentImage.frame.origin.x+(movePoint.x-previousLocation.x), transparentImage.frame.origin.y+(movePoint.y-previousLocation.y));
//		CGPoint newpoint1=CGPointMake(CGRectGetMaxX(transparentImage.frame)-(movePoint.x-previousLocation.x), CGRectGetMaxY(transparentImage.frame)-(movePoint.y-previousLocation.y));
//		if (transparentImage.frame.origin.x+(movePoint.x-previousLocation.x)>0 && transparentImage.frame.origin.y+(movePoint.y-previousLocation.y)>20) {
//			transparentImage.frame=CGRectMake(transparentImage.frame.origin.x+(movePoint.x-previousLocation.x), transparentImage.frame.origin.y+(movePoint.y-previousLocation.y), transparentImage.frame.size.width, transparentImage.frame.size.height);
//
//		}
//
//		//}
		
	}
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	isMove=NO;
}
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//
//{
//	
//	//if(twitterClicked==FALSE){
//	
//	switch (buttonIndex)
//	
//	{
//			
//		case 0:
//			
//			[self sendEmailTo];
//			
//			break;
//			
//		case 1:
//			
//			[self openTwitterPage];
//			
//			break;
//			
//		case 2:
//			// About Us
//			[self facebtnact];
//			
//			break;
//			
//			//case 3:
//			//			
//			//			//Other Information
//			//			
//			//			/*if(otherApps ==nil)
//			//			 {
//			//			 otherApps =[[Others alloc] initWithNibName:@"Others" bundle:nil];
//			//			 
//			//			 }
//			//			 [self presentModalViewController:otherApps animated:YES];*/
//			//			break;
//		case 3:
//			
//			[[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"http://phobos.apple.com/WebObjects/MZSearch.woa/wa/search?WOURLEncoding=ISO8859_1&lang=1&output=lm&country=US&media=software&term=elite%20gudz"]];
//			
//			break;
//		default:
//			
//			
//			break;
//			
//	}
//	//}
//	return;
//	
//}

//****************change
-(void)aboutButtonFunction:(id)sender{
	//NSString *msgAlert = @"";
	//	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:msgAlert delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Tell A Friend",@"Tweet This",@"Facebook",@"Other Apps",nil ];
	//	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	//	[actionSheet showInView:self.view];
	//	[actionSheet release];
}
//*************************change

-(IBAction)facebtnact{
	//_permissions =  [[NSArray arrayWithObjects: @"read_stream",@"user_photos",@"user_videos",@"publish_stream ",nil] retain];
	//	_facebook = [[Facebook alloc] init];
	//
	//	if(appdelegate.facebookLogin == TRUE)
	//	{
	//		appdelegate.facebookLogin = FALSE;
	//		[_facebook logout:self];
	//	}
	//	[_facebook authorize:kAppId permissions:_permissions delegate:self];
}

//*************************change
-(void) fbDidLogin {
	
	
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

//*************************change
//- (void) publishStream{
//	
//	SBJSON *jsonWriter = [[SBJSON new] autorelease];
//	
//	NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys: 
//														   @"Always Running",@"text",@"http://itsti.me/",@"href", nil], nil];
//	
//	NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
//	NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
//								@"Goons & Bots invade your nightstand - Go to sleep with the Bots and wake with the Goons with this free animated cartoon clock.", @"name",@"http://zah.cc/8Cq",@"caption",nil];//@"http://itunes.com/elitegudz/",@"href", nil];
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
////*************************change
//- (void)fbDidNotLogin:(BOOL)cancelled {
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
//
////*************************change
//-(void) fbDidLogout {
//	
//	//	[_facebook release];
//	
//	
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Callback when a request receives Response
 */ 

//*************************change
//- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response{
//	
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
//
//
////*************************change
//- (void)request:(FBRequest*)request didFailWithError:(NSError*)error{
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

//*************************change
//- (void)request:(FBRequest*)request didLoad:(id)result {
//	
//	
//	
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





///////////////////////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/** 
 * Called when a UIServer Dialog successfully return
 */

//*************************change
//- (void)dialogDidComplete:(FBDialog*)dialog withPost:(NSString *)currentPostID{
//	//[_facebook logout:self];
//	
//	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Message posted  successfully" 
//											  message:nil 
//											 delegate:self 
//									cancelButtonTitle:@"OK" 
//									otherButtonTitles:nil];
//	[fb show];
//	[fb release];
//}

//*************************change
//- (void) sendEmailTo{
//	
//	
//	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
//	
//	picker.mailComposeDelegate = self;
//	
//	
//	[picker setSubject:@"Goons & Bots"];
//	
//	//NSArray *toRecipients = [NSArray arrayWithObject:mailString]; 
//	
//	//[picker setToRecipients:toRecipients];
//	NSString *emailBody =[NSString stringWithFormat:@"Goons & Bots invade your nightstand - Go to sleep with the Bots and wake with the Goons with this free animated cartoon clock. \nhttp://zah.cc/8Cq\n"];
//	[picker setMessageBody:emailBody isHTML:NO];
//	
//	//	[self presentModalViewController:picker animated:YES];
//	if (picker != nil)
//	{
//		[self presentModalViewController:picker animated:YES];
//	}
//	//	else
//	//	{
//	//		[self Resume];
//	//	}
//	[picker release];
//	
//}
//*************************change
//-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
//{
//	
//	[self becomeFirstResponder];
//	[self dismissModalViewControllerAnimated:YES];
//	[self.view setHidden:FALSE];
//	if(result==MFMailComposeResultSent){
//		UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Mail Sent" 
//												  message:nil 
//												 delegate:self 
//										cancelButtonTitle:@"OK" 
//										otherButtonTitles:nil];
//		[fb show];
//		[fb release];
//	}
//	else if(result==MFMailComposeResultCancelled){
//		UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Mail Cancelled" 
//												  message:nil 
//												 delegate:self 
//										cancelButtonTitle:@"OK" 
//										otherButtonTitles:nil];
//		[fb show];
//		[fb release];
//	}
//	else if(result==MFMailComposeResultFailed){
//		UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Mail Failed" 
//												  message:nil 
//												 delegate:self 
//										cancelButtonTitle:@"OK" 
//										otherButtonTitles:nil];
//		[fb show];
//		[fb release];
//	}
//	
//	
//}
//*************************change
//- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
//	[_engine sendUpdate: [NSString stringWithFormat:@"%@",twitterTextField.text]];
//	[twitterTextField release];
//	twitterTextField = nil;
//}
//- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
//	UIAlertView *status=[[UIAlertView alloc]initWithTitle:@"Twitter Authentication Failed!" 
//												  message:nil 
//												 delegate:self 
//										cancelButtonTitle:@"OK" 
//										otherButtonTitles:nil];
//	[status show];
//	[status release];
//	[self dismissModalViewControllerAnimated:YES];
//	
//}
//
//- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
//	UIAlertView *status=[[UIAlertView alloc]initWithTitle:@"Twitter Authentication Canceled" 
//												  message:nil 
//												 delegate:self 
//										cancelButtonTitle:@"OK" 
//										otherButtonTitles:nil];
//	[status show];
//	[status release];
//	[self dismissModalViewControllerAnimated:YES];
//}
//
////=============================================================================================================================
//#pragma mark TwitterEngineDelegate
//- (void) requestSucceeded: (NSString *) requestIdentifier {
//	UIAlertView *status=[[UIAlertView alloc]initWithTitle:@"Tweet posted successfully" 
//												  message:nil 
//												 delegate:self 
//										cancelButtonTitle:@"OK" 
//										otherButtonTitles:nil];
//	[status show];
//	[status release];
//	[self dismissModalViewControllerAnimated:YES];
//}
//
//- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
//}


//*************************change
-(void)openTwitterPage{
	//
	//	//self.navigationController.navigationBarHidden = TRUE;
	//	[appdelegate.aNavigation setNavigationBarHidden:NO];
	//	TwitterOpened = YES;
	//	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Post", @selector(twitteract));
	//	self.navigationItem.leftBarButtonItem = BARBUTTON(@"Back", @selector(action:));
	//	self.title = @"Tweet This";
	//	
	//	twitterView = [[UIView alloc]initWithFrame:CGRectMake(0,0, 320, 480)];
	//	UIImage  *img  = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Twitter" ofType:@"jpg"]];
	//	UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 320, 480)];
	//	imageView.image = img;
	//	
	//	
	//	twitterTextField = [[UITextView alloc] initWithFrame:CGRectMake(10,100, 300, 200)];
	//	
	//    twitterTextField.textColor = [UIColor blackColor];
	//	
	//    twitterTextField.font = [UIFont fontWithName:@"Arial" size:18];
	//	
	//    twitterTextField.delegate = self;
	//	
	//    twitterTextField.backgroundColor = [UIColor whiteColor];
	//	
	//	
	//	twitterTextField.text =[NSString stringWithFormat:@"Goons & Bots, Go to sleep with the Bots and wake with the Goons with this free animated cartoon clock.http://zah.cc/8Cq"];
	//    twitterTextField.scrollEnabled = YES;
	//	
	//    twitterTextField.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	//	
	//	
	//	[twitterView addSubview:imageView];
	//	
	//	
	//	[twitterView addSubview:twitterTextField];
	//	
	//	[alarmView addSubview:twitterView];
	//	[img release];
	//	[imageView release];
	
	
}
//*************************change
-(void)action:(id)sender{
	
	//[appdelegate.aNavigation setNavigationBarHidden:YES];
	//	
	//	if(TwitterOpened ==YES)
	//	{
	//		TwitterOpened =NO;
	//		//self.title = @"Categories";
	//		//UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
	//		//		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
	//		//		[btn addTarget:self action:@selector(actionSheetAction) forControlEvents:UIControlEventTouchUpInside];
	//		self.navigationItem.leftBarButtonItem = nil;
	//		self.navigationItem.rightBarButtonItem = nil;
	//		for(UIView *s in twitterView.subviews )
	//		{
	//			[s removeFromSuperview];
	//		}
	//		
	//		[twitterTextField release];
	//		twitterTextField = nil;
	//		[twitterView removeFromSuperview];
	//		[twitterView release];
	//		
	//		
	//		return;
	//	}
}

-(void)actionSheetAction{
	
	//
	//	UIActionSheet *aSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Tell a Friend",@"Tweet This",@"Facebook",@"Other Apps",nil];
	//	[aSheet showInView:self.view];
	//	[aSheet release];
	
	
}

//*************************change
-(IBAction)twitteract {
	//
	//	[appdelegate.aNavigation setNavigationBarHidden:YES];
	//	
	//	if ([twitterTextField hasText]==FALSE) {
	//		[appdelegate.aNavigation setNavigationBarHidden:NO];
	//		UIAlertView *status=[[UIAlertView alloc]initWithTitle:@"Please enter text to tweet" 
	//													  message:nil 
	//													 delegate:self 
	//											cancelButtonTitle:@"OK" 
	//											otherButtonTitles:nil];
	//		[status show];
	//		[status release];
	//		return;
	//		
	//	}
	//	
	//	TwitterOpened = NO;
	//	self.title = @"Categories";
	//	UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
	//	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
	//	[btn addTarget:self action:@selector(actionSheetAction) forControlEvents:UIControlEventTouchUpInside];
	//	
	//	for(UIView *s in twitterView.subviews )
	//	{
	//		[s removeFromSuperview];
	//	}
	//	
	//	//[twitterTextField release];
	//	[twitterView removeFromSuperview];
	//	[twitterView release];
	//	
	//	if (_engine) [_engine release];
	//	_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
	//	_engine.consumerKey = kOAuthConsumerKeyq;
	//	_engine.consumerSecret = kOAuthConsumerSecretq;
	//	
	//	UIViewController			*controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
	//	
	//	if (controller) 
	//		[self presentModalViewController: controller animated: YES];
	//	else {
	//		[_engine sendUpdate: [NSString stringWithFormat: @"Already Updated. %@", [NSDate date]]];
	//	}
	
}




//*************************change
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"]) {
		
		[textView resignFirstResponder];
		
	}
    return YES;
	
}




//#########################
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{ 
	
	if(geoFlag == TRUE)
	{
		geoFlag = FALSE;
		
		CLLocationCoordinate2D loc = [newLocation coordinate];
		
		NSString *str = [NSString stringWithFormat: @"%f", loc.latitude];
		NSString *str1	= [NSString stringWithFormat: @"%f", loc.longitude];
		
		
		
		MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:loc];
		geocoder.delegate = self;
		[geocoder start];
		
	}
	
	
	
}

- (void)showWeatherFor:(NSString *)query 
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    ICB_WeatherConditions *weather = [[ICB_WeatherConditions alloc] initWithQuery:query];
    
	[self performSelectorOnMainThread:@selector(updateUI:) withObject:weather waitUntilDone:NO];
    
    [pool release];
}

// This happens in the main thread     
- (void)updateUI:(ICB_WeatherConditions *)weather
{
	//UIImage *weatherImg;  //
	
	NSString *condName = [NSString stringWithFormat:@"%@",weather.condition];
	if([condName isEqualToString:@"Mostly Cloudy"]||[condName isEqualToString:@"Partly Cloudy"]||[condName isEqualToString:@"Cloudy"])
	{
		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"clouds_img.png"] ofType:@""]];
		//weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"haze.png"] ofType:@""]];
		
		
	}
	else if([condName isEqualToString:@"Sunny"]||[condName isEqualToString:@"Clear"])
	{
		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"sunny_img.png"] ofType:@""]];
		
	}
	else if([condName isEqualToString:@"Chance of Rain"]) 
	{
		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"chance_of_rain.png"] ofType:@""]];
		
	}
	else if([condName isEqualToString:@"Wind"])
	{
		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"windy_img.png"] ofType:@""]];
		
	}
	else if([condName isEqualToString:@"Rain"])
	{
		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"rain_hard_img.png"] ofType:@""]];
		//weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"storm.png"] ofType:@""]];
		
		
	}
	else if([condName isEqualToString:@"Hot"])
	{
		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"hot_img.png"] ofType:@""]];
		
	}
	////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& need images
	else if([condName isEqualToString:@"Snow Showers"]||[condName isEqualToString:@"Scattered Showers"]||[condName isEqualToString:@"Snow"])
	{
		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"snow_img.png"] ofType:@""]];
		
	}
	else if([condName isEqualToString:@"Fog"])
	{
		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"fog.png"] ofType:@""]];
		
	}
	
	else if([condName isEqualToString:@"Smoke"])
	{
		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"smoke.png"] ofType:@""]];
		
	}
	else if([condName isEqualToString:@"Light rain"])
	{
		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"rain_light_img.png"] ofType:@""]];
		
	}
	else if([condName isEqualToString:@"Chance of Storm"])
	{
		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"storm.png"] ofType:@""]];
		
	}
	else if([condName isEqualToString:@"Chance of Snow"])
	{
		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"chance_of_snow.png"] ofType:@""]];
		
	}
	else if([condName isEqualToString:@"Mostly Sunny"])
	{
		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"mostly_sunny.png"] ofType:@""]];
		
	}
	else if([condName isEqualToString:@"Ice"]||[condName isEqualToString:@"Freezing Rain"])
	{
		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"icy.png"] ofType:@""]];
		
	}
	else if([condName isEqualToString:@"Mist"])
	{
		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"mist.png"] ofType:@""]];
		
	}
	else if([condName isEqualToString:@"Flurries"])
	{
		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"snow_img.png"] ofType:@""]];
		
	}
	else 
	{
		weatherImg = nil;//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"windy_img.png"] ofType:@""]];
		
	}
	
	
	wheatherReportView.image = weatherImg;
	//[weatherImg release];
	//[wheatherImage release];
	
    
	NSString *tem = [NSString stringWithFormat:@"%d", weather.currentTemp];
	temLength = [tem length];
	//if(temLength == 1 )
	//	{
	//		//NSString *value = [tem  substringToIndex:1];
	////		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"1_img_%@.png",value] ofType:@""]];
	////		tempImgView1.image =weatherImg;
	////		[weatherImg release];
	////		
	////		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"degree_symbol.png"] ofType:@""]];
	////		if(isPickerClicked == FALSE)
	////			degreeImgView.frame = CGRectMake(-20, 50, 320,94);
	////		degreeImgView.image = weatherImg;
	//		
	//	}
	/*if(appdelegate.alarmTheme == 0)
	 {
	 
	 NSString *value = [tem  substringToIndex:1];
	 weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"1_img_%@.png",value] ofType:@""]];
	 tempImgView1.image =weatherImg;
	 [weatherImg release];
	 
	 NSString *value1 = [tem  substringFromIndex:1];
	 weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"2_img_%@.png",value1] ofType:@""]];
	 tempImgView2.image =weatherImg;
	 [weatherImg release];
	 
	 weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"degree_symbol.png"] ofType:@""]];
	 if(isPickerClicked == FALSE)  ////5, 50, 320,94
	 degreeImgView.frame = CGRectMake(5, 10, 320,94);
	 degreeImgView.image = weatherImg;
	 }*/
	if(temLength == 2)
	{
		NSString *value = [tem  substringToIndex:1];
		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"1_img_%@.png",value] ofType:@""]];
		tempImgView1.image =weatherImg;
		//[weatherImg release];
		
		NSString *value1 = [tem  substringFromIndex:1];
		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"2_img_%@.png",value1] ofType:@""]];
		tempImgView2.image =weatherImg;
		//[weatherImg release];
		
		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"degree_symbol.png"] ofType:@""]];
		if(isPickerClicked == FALSE)  ////5, 50, 320,94
			//degreeImgView.frame = CGRectMake(5, -10, 320,94);
			degreeImgView.image = weatherImg;
		//[weatherImg release];
	}
	else if(temLength == 3)
	{
		NSString *value = [tem  substringToIndex:1];
		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"1_img_%@.png",value] ofType:@""]];
		tempImgView1.image =weatherImg;
		//[weatherImg release];
		
		NSString *value1 = [tem  substringWithRange:NSMakeRange(1, 1)];
		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"2_img_%@.png",value1] ofType:@""]];
		tempImgView2.image =weatherImg;
		
		NSString *value2 = [tem  substringFromIndex:2];
		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"3_img_%@.png",value2] ofType:@""]];
		tempImgView3.image =weatherImg;
		//[weatherImg release];
		
		weatherImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"degree_symbol.png"] ofType:@""]];
		if(isPickerClicked == FALSE)
			degreeImgView.frame = CGRectMake(25, 50, 320,94);
		degreeImgView.image = weatherImg;
		//[weatherImg release];
	}
	
	if([tem isEqualToString:@"0"] )
	{
		tempImgView1.image = nil;
		tempImgView2.image = nil;
		tempImgView3.image = nil;
		degreeImgView.image = nil;
		
		
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"It seems to be an Invalid Zipcode has been entered." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		[alert show]; 
		[alert release];
	}
	
	
	
    
}

#pragma mark MKReverseGeocoder Delegate Methods
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	[geocoder release];
	
	//MKPlacemark * myPlacemark = placemark;
    // with the placemark you can now retrieve the city name
    //NSString *city = [myPlacemark.addressDictionary objectForKey:@"en_US"];
	
	//[self performSelectorInBackground:@selector(showWeatherFor:) withObject:[placemark.addressDictionary objectForKey:@"ZIP"]];
	[self performSelectorInBackground:@selector(showWeatherFor:) withObject:placemark.postalCode];
	
	
	//zipCodeNo = [placemark.addressDictionary objectForKey:@"ZIP"];
	zipCodeNo = placemark.postalCode;
	countryName = placemark.country;
	
	//[placemark.addressDictionary objectForKey:@"ZIP"]
}


//- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
//{
//    MKPlacemark * myPlacemark = placemark;
//    // with the placemark you can now retrieve the city name
//    NSString *city = [myPlacemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCityKey];
//}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{    
    
	//[g	eo	co	d	e	r	r	el	e	ase];
}


-(void)btnStoreAction      
{
	
	storeView = [[StoreView alloc]initWithNibName:@"StoreView" bundle:nil];
	
	isStoreClicked = FALSE;
	[self presentModalViewController:storeView animated:YES];
	
	
}

-(void)btnCalenderAction
{
	
	//	Calender *cal = [[Calender alloc]initWithNibName:@"Calender" bundle:nil];
	//	[self presentModalViewController:cal animated:YES];
	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
	
	//	UIAlertView *alert = [[UIAlertView alloc] 
	//						  initWithTitle:@"Warning" 
	//						  message:@"You are running out of memory" 
	//						  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	//	
	//	[alert show];
	//	[alert release];
	
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	//self.vid=nil;
}


//- (void)dealloc {
//    [super dealloc];
//	[vid release];
//}

@end
