//
//  AlarmsViewController.h
//  Alarms
//
//  Created by neo on 19/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AdWhirlDelegateProtocol.h"
//#import "AdWhirlView.h"
#import <AudioUnit/AudioUnit.h>
#import<AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "MapKit/MapKit.h"
#import "ICB_WeatherConditions.h"
#import "StoreView.h"


#define kSampleAppKey @"5582ac6791d94645ac908aa4207659a6"; //New Alarm Id //a202683fdf7a4e3fb54fc3cbd8638b1a" //68a3bdafbd4746c3adf9454658cec92a" // change this to ur adwhirl sdk key
#define kSampleConfigURL @"http://mob.adwhirl.com/getInfo.php"
#define kSampleImpMetricURL @"http://met.adwhirl.com/exmet.php"
#define kSampleClickMetricURL @"http://met.adwhirl.com/exclick.php"
#define kSampleCustomAdURL @"http://mob.adwhirl.com/custom.php"

#define BARBUTTON(TITLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]//,AdWhirlDelegate

@class epubstore_svcAppDelegate;
@class SlideToCancelViewController,Videos,StoreView;

@interface AlarmsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{

	UIImageView *loadImageView;
	UIImageView *cloudImageView;
	UIImageView *charcterImageView;
	
	UIImageView *time1,*time2,*min1,*min2,*amPm;
	IBOutlet UIView *alarmView;
	IBOutlet UIView *tableview;
	//IBOutlet UIView *flipView;
	UIButton *alarmBtn;
	UIButton *FlipBtn;
	UIButton *volumeBtn;
	UIButton *selectSongs;
	UISlider *slider;
	IBOutlet UITableView *newtable;
	IBOutlet UIBarButtonItem *EditButton;
	epubstore_svcAppDelegate *appdelegate;
	BOOL isDayOn,isVolume;
	
	UIButton *infoButton;
	
	//SA_OAuthTwitterEngine				*_engine;
	UIImage *twitterimage;
	UIImageView *temp11;
	UILabel *tweetThis;
	UIButton *cancel;
	UIButton *post;
	UIView * twitterView;
	UITextView *twitterTextField ;
	
	
	//Facebook* _facebook;
	NSArray* _permissions;
	CLLocationManager   *locmanager;

	UIImageView *alarmOn1;
	UIImageView *alarmOn2;
	
	UIImageView *alarmOff1;
	UIImageView *alarmOff2;
	BOOL onoff;
	UIImageView *alarmOnOff;
 	UIView *zipview;
	SlideToCancelViewController *slideToCancel;
	NSArray *myImages;
	Videos *vid;
	StoreView *storeView;
	
	UIImageView *transparentImage;
	UIImageView *hourBackImage;
	UIImageView *minsBackImage;

	//iPad-iPhone Width and Height ratio
	float ratioWidth;
	float ratioHeight;
	
	//move clock
	CGPoint startPoint;
	CGPoint movePoint;
	BOOL isMove;
	
	//slide show
	
	NSTimer *slideshowTimer;
	NSString *imageFileName;
	
	//UIToolbar *topToolBar;
//	UIBarButtonItem *alarmButton;
//	UIBarButtonItem *songButton;
//	UIBarButtonItem *flipButton;
//	UIBarButtonItem *themeButton;
//	UIBarButtonItem *flexibleSpace;
}
//@property(nonatomic,retain)UIImageView *alarmOn1;
//@property(nonatomic,retain)UIImageView *alarmOn2;
//@property(nonatomic,retain)UIImageView *alarmOff1;
//@property(nonatomic,retain)UIImageView *alarmOff2;
@property(nonatomic,retain) NSTimer *slideshowTimer;
@property(nonatomic,retain) NSString *imageFileName;
@property(nonatomic,assign) BOOL onoff;
@property(nonatomic,retain)IBOutlet UIView *zipview;
-(IBAction)backAction;
-(IBAction)volumeBtnAction;
-(IBAction)flipBtnAction;
-(IBAction)selectSongsAction;
-(IBAction)editAction:(id)sender;
-(void)watchTime;
-(void)viewLoadMethod;
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
-(void) removePreviousThemeFootprint;
-(void)addtimeView;
-(void)addEyeAnimation;
-(void)changeViews;
- (void) publishStream;
- (void) sendEmailTo;
-(void)openTwitterPage;
-(IBAction)facebtnact;
- (void)showWeatherFor:(NSString *)query;
-(void)btnStoreAction:(id)sender;

-(IBAction)backBtnAction;
-(IBAction)setAsDefaultBtnAction;
//@property(nonatomic,retain)	StoreView *storeView;

@end

