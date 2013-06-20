//
//  epubstore_svcAppDelegate.h
//  epubstore_svc
//
//  Created by partha neo on 9/1/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import "BookDetails.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import <sqlite3.h>
//#import "TBONEAppDelegate.h"
#import "TBONEViewController.h"
//FB
#import "FBFunLoginDialog.h"
//Mail
#import <MessageUI/MessageUI.h>
//############################################clock 
//#import "AlarmsViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SlideToCancelViewController.h"
//@class AlarmsViewController;

#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/SCNetworkReachability.h>

//#import "PSPDFKit.h"

#import "CustomButton.h"
//#import "TBONEViewController.h"
#import "XMLReader1.h"
#import"Reachability.h"
//#import "mmsvViewController.h"


@class Videos;
@class Shop;
@class StoreViewController;
@class DashBoardViewController;
@class HDLoopDemoViewController;
@class AlarmsViewController;
@class SettingsViewController;
@class mmsvViewController;


typedef enum {
    LoginStateStartup,
    LoginStateLoggingIn,
    LoginStateLoggedIn,
    LoginStateLoggedOut
} LoginState;
//FB


//#define serverIP @"http://122.183.249.152/comicstory/epub"
//#define serverIP @"http://122.183.249.154/wizardworld"
//#define serverIP @"http://www.adminmyapp.com/wizardworld/beta"
//#define serverIP @"http://www.adminmyapp.com/wizardworld/tp"
//#define serverIP @"http://myzaah.com/maximdash"
//#define serverIP @"http://maximgirls.myzaah.com/maximdash"
#define serverIP @"http://adminmyapp.com/dashboardgsc"
//#define serverIP @"http://122.183.212.56/maximdash"
//#define serverIP @"http://122.183.212.56/maximdash"
//#define serverIP @"http://maximgear.gostorego.com/"
//#define serverIP @"http://www.concreteimmortalz.com/comicstore"
//#define serverIP @"http://www.concreteimmortalz.com"
//#define serverIP @"http://www.phetusexclusives.com/ci/comicstore/"

//#define authKey @"9650ef957e71f654013e1319f3c72268"s
//Twitter

#define ServerIp @"http://staging.masswave.com/"


@class SA_OAuthTwitterEngine, SA_OAuthTwitterController;

@protocol SA_OAuthTwitterControllerDelegate <NSObject>
@optional
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username;
- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller;
- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller;
@end
//Twitter

@class RootViewController;
//@class DetailViewController;

@class test;


@interface epubstore_svcAppDelegate : NSObject <UIApplicationDelegate,UIActionSheetDelegate,UITabBarControllerDelegate,FBFunLoginDialogDelegate,MFMailComposeViewControllerDelegate,MPMediaPickerControllerDelegate,AVAudioPlayerDelegate,UIWebViewDelegate> {
//Twitter
	SA_OAuthTwitterEngine						*_engine;
	id <SA_OAuthTwitterControllerDelegate>		_delegate;
//Twitter
    UIWindow *window;
    UISplitViewController *splitViewController;

	
    RootViewController *rootViewController;
   // DetailViewController *detailViewController;
	test *t;
	
	UITabBarController *tabBarController;
	UINavigationController *navigationController;
	NSMutableArray *booksArray;
	
	BookDetails *bookdetailsObj;
	
	FMDatabase *Masterdatabase;
	FMResultSet *recordsetmaster;

	// For Epub Reader 
	NSString *fontName ;
	CGFloat fontSize;
	CGFloat speed;

	// For Epub Store

	NSMutableArray *bookListArray;
	NSMutableArray *booksDetailsArray;
   	
    int downloadCount; 
	BOOL bookPurchased;
	
	// For signup 
	NSString *userDetails;
	NSString *loginAuthKey;
	//NSString *signUPAuthKey;
	NSString *errorDetails;
	NSString *recoveredPassWord;
	BOOL isValidLoginOrReg;
	BOOL NoWifiConnection;
	
	//For Storing Downloading book details
	NSMutableArray *Arr_DownloadingBooks;
	NSString *deviceToken,*appBadge;
	NSString *Uid;
	
	
	BOOL IsEnabledLinks;
	BOOL ISPushNotification;
	BOOL IsWifiConnection;

    LoginState _loginState;
    FBFunLoginDialog *_loginDialog;
    UIView *_loginDialogView;
    NSString *_accessToken;
    //*****************************///
	
	UINavigationController *aNavigation1;
	
	NSString *strCatList,*strCatDetails,*strSlideDetails,*strCatName;
	NSMutableArray *arrCatList;
	NSInteger  iCatIDIndex;
	NSInteger iCatNameIndex ;
	NSInteger iCatNoOfImgsIndex;
	NSInteger checkPurchasedValue;
	NSInteger iUpdateValue;
	NSString *strURL;
	NSString *strThumbImgName;
	NSString *str320by480Name ;
	NSString *str104by157Name ;
	NSString *str640by960Name ;
	NSString *strRowDelimeter;
	NSString *strColDelimiter;
	NSString *strCatDelimiter;
	NSString *strTotalString;
	NSString *dataFilePath;
	NSString *docFolder;
	BOOL facebookLogin;
	BOOL thumbView;
//#########################################clock
	MPMusicPlayerController *musicPlayer;
	//AlarmsViewController *alm;
	NSString *totalTime;
	NSInteger songIndex;
	AVAudioPlayer *audioPlayer;
	//NSMutableArray *playList;
	NSInteger *newSection;
	NSInteger *ipodIndex;
	float volumeLevel;
	NSString *firstString;
	UINavigationController *aNavigation;
	NSString *ipodSongTitle;
	NSMutableArray *alarmTimeArray;
	NSMutableArray *arrBuyImages;
	SlideToCancelViewController *slideToCancel;
	//BOOL facebookLogin;
	UIButton *sclbtn;
	int purchaseValue;
	int myvalue;
	int themeValue;
	int alarmTheme;
	
	BOOL						playing ;
	BOOL						interruptedOnPlayback;
	UIView *cancenView;
	
	//NSString *vidUrl;
	UIWebView *shopview;
	UIWebView *videoview;
	NSMutableArray *videoz;
	
	NSString *productIdName;
	NSArray *productArray;
	NSSet *storeproductidentifier;
	
	Videos *videoVC;
	Shop *shopVC;
	StoreViewController *storeVC;
	DashBoardViewController *dashB;
	HDLoopDemoViewController *bgVC;
	AlarmsViewController *viewController1;
	SettingsViewController *sett_ViewCont;
	int screenHeight1,screenWidth1;
	UIViewController *customViewController;
	UIBackgroundTaskIdentifier bgTask;
	
	
    
	int slideShowTime,previousTab;
    UIView *tabCoverView;
    UIButton *closeTabBar;
    BOOL showingTabBar,isVideoPlaying;
    
    NSUserDefaults *prefs;
    
    BOOL isSwitch;
    
    CustomButton *magz_btn;
    
    NSMutableDictionary *listData; 
    
    NSString *userID;
    
    int videoTagId;
    
    CustomButton *gam_btn1;
    
    NSString *selectedUserId;
    
    NSString *logedUserFLName, *logedUserImg;
    
    NSDictionary *FBfriendsList;
    
    NSString *FBfriendsIds;
    
    NSMutableArray *videoTaggedIds;
    
    NSString *postTitle, *postDescription;
    
    BOOL loginFlag, redirectToRoot,reachability,boolFlag,tempBool,loginBool,boolComments,boolVideoPlayer,onFirstLoad,boolDelete;
    
    int orientation, captureOrientation;
    
    BOOL mediaPosted;
    
    NSMutableData *responseData;
}

@property (nonatomic, retain) UIView *tabCoverView;
@property(nonatomic,retain)NSUserDefaults *prefs;

@property int activateCount;
@property (nonatomic,retain)TBONEViewController *gameController;
@property(assign)BOOL isFirstTimeGameLoad;

@property(assign)BOOL isSwitch;

@property(assign)BOOL isVideoPlaying;


@property (nonatomic,retain)NSMutableArray *allSongs;

@property (nonatomic,retain)UIViewController *customViewController;
@property (nonatomic,retain)UIWebView *shopview;
@property (nonatomic,retain)UIWebView *videoview;
@property (nonatomic, assign)int screenHeight1,screenWidth1;
@property (nonatomic, assign)int slideShowTime;
@property (nonatomic,retain)NSMutableArray *videoz;
@property (nonatomic,retain) SlideToCancelViewController *slideToCancel;

@property (nonatomic,retain) Shop *shopVC;
@property (nonatomic,retain)Videos *videoVC;
@property (nonatomic,retain)StoreViewController *storeVC;
@property (nonatomic,retain)DashBoardViewController *dashB;
@property (nonatomic,retain)HDLoopDemoViewController *bgVC;
@property (nonatomic,retain)AlarmsViewController *viewController1;
@property (nonatomic,retain)SettingsViewController *sett_ViewCont;

//Twitter
@property (nonatomic, readwrite, retain) SA_OAuthTwitterEngine *engine;
@property (nonatomic, readwrite, assign) id <SA_OAuthTwitterControllerDelegate> delegate;
//Twitter

//FB
@property (retain) FBFunLoginDialog *loginDialog;
@property (retain) UIWebView *webView;
@property (copy) NSString *accessToken;
@property (retain) UIView *loginDialogView;
//FB

@property(nonatomic) BOOL IsWifiConnection;
@property (nonatomic) BOOL ISPushNotification;
@property (nonatomic) BOOL IsEnabledLinks;

@property (nonatomic, retain) NSString *Uid;
@property(nonatomic, retain)NSString *deviceToken,*appBadge;
@property(nonatomic, retain)NSMutableArray *Arr_DownloadingBooks; 

@property (nonatomic,readwrite)CGFloat fontSize;
@property (nonatomic,retain)NSString *fontName;
@property (nonatomic,readwrite)CGFloat speed;
@property (nonatomic,readwrite)int downloadCount;

@property (nonatomic, retain)UINavigationController *navigationController;
@property (nonatomic, retain)BookDetails *bookdetailsObj;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic,retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic,retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic,retain) IBOutlet test *t;


//@property (nonatomic,retain) IBOutlet DetailViewController *detailViewController;

@property (nonatomic,retain) FMDatabase *Masterdatabase;
@property (nonatomic,retain) FMResultSet *recordsetmaster;


@property (nonatomic, retain) NSMutableArray *bookListArray;
@property (nonatomic, retain) NSMutableArray *booksDetailsArray;
@property (nonatomic,readwrite)BOOL bookPurchased; 

@property (nonatomic, retain) NSString *userDetails;
@property (nonatomic, retain) NSString *loginAuthKey;
//@property (nonatomic, retain) NSString *signUPAuthKey;
@property (nonatomic, retain) NSString *errorDetails;
@property (nonatomic, retain) NSString *recoveredPassWord;
@property (nonatomic, assign) BOOL isValidLoginOrReg;
@property (nonatomic, assign) BOOL NoWifiConnection;

//*************************//////

@property (nonatomic, retain)UINavigationController *aNavigation1;
@property (nonatomic,assign)NSString *strCatList;
@property (nonatomic,assign)NSString *strCatDetails;
@property (nonatomic,assign)NSString *strSlideDetails;

@property (nonatomic,retain)NSMutableArray *arrCatList;
@property (nonatomic,assign)NSInteger iCatIDIndex;
@property (nonatomic,assign)NSInteger iCatNameIndex ;
@property (nonatomic,assign)NSInteger iCatNoOfImgsIndex;
@property (nonatomic,assign)NSInteger checkPurchasedValue;

@property (nonatomic,assign)NSString *strURL;
@property (nonatomic,assign)NSString *str320by480Name ;
@property (nonatomic,assign)NSString *str104by157Name ;
@property (nonatomic,assign)NSString *str640by960Name;
@property (nonatomic,assign)NSString *strThumbImgName;
@property (nonatomic,assign)NSString *strRowDelimeter;
@property (nonatomic,assign)NSString *strColDelimiter;
@property (nonatomic,assign)NSString *strCatDelimiter;
@property (nonatomic,assign)NSString *strTotalString;
@property (nonatomic,assign)NSString *strCatName;
@property (nonatomic,assign)NSInteger iUpdateValue;
@property (nonatomic,assign)NSString *dataFilePath;
@property (nonatomic,assign)NSString *docFolder;
@property (nonatomic,assign)BOOL facebookLogin;
@property (nonatomic,assign)BOOL thumbView;

@property (nonatomic, retain)IBOutlet UITabBarController *tabBarController;

//#############################clock
//@property (nonatomic, retain) IBOutlet AlarmsViewController *viewController;


@property (nonatomic, retain) NSString *totalTime;
@property (nonatomic, retain) NSMutableArray *alarmTimeArray;
@property (nonatomic, retain) MPMusicPlayerController *musicPlayer;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic,assign) NSInteger songIndex;
//@property (nonatomic, retain) NSMutableArray *playList;
@property (nonatomic, assign) NSInteger *newSection;
@property (nonatomic, assign) float volumeLevel;
@property (nonatomic, retain) NSString *firstString;
@property (nonatomic, retain) NSString *ipodSongTitle;
@property (nonatomic,retain) UINavigationController *aNavigation;
@property (nonatomic,assign)	int purchaseValue;
@property (nonatomic,assign)	int myvalue;
@property (nonatomic, retain)	NSMutableArray *arrBuyImages;
@property (nonatomic,assign) int themeValue;
@property (nonatomic,assign)int alarmTheme;
//@property (nonatomic,assign)BOOL facebookLogin;

@property (readwrite)			BOOL					interruptedOnPlayback;
//@property (nonatomic, retain)	MPMusicPlayerController	*musicPlayer;

@property (nonatomic,retain)UIView *cancenView;
@property (nonatomic,retain) UIButton *sclbtn;

@property(nonatomic,assign)NSString *productIdName;
@property(nonatomic,assign)NSArray *productArray;
@property(nonatomic,assign)NSSet *storeproductidentifier;

//@property(nonatomic,retain)UITableView * newsTable;

@property(assign)BOOL loginFlag, redirectToRoot, reachability,boolFlag,loginBool,boolComments,boolVideoPlayer, onFirstLoad, mediaPosted,boolDelete;

@property(nonatomic, retain)NSString *postTitle, *postDescription;

@property(nonatomic, retain)NSMutableArray *videoTaggedIds;

@property(nonatomic, retain)NSString *FBfriendsIds;

@property(nonatomic,retain)NSDictionary *FBfriendsList;

@property(nonatomic,retain)NSURL *postVideoUrl;

@property(assign)int videoTagId,orientation,captureOrientation;
@property (nonatomic,retain) NSString *selectedUserId;

@property(strong, nonatomic)NSString *userID, *logedUserFLName, *logedUserImg;

@property (strong, nonatomic)NSMutableArray *myarray;

@property (strong, nonatomic)NSString *picStr;

@property (assign, nonatomic)NSInteger tabIndex;


@property (strong, nonatomic) mmsvViewController *viewController;

@property (strong)NSMutableDictionary *listData;

-(void)fetchVideoListing:(NSString*)method uid:(NSString*)userId setCurrentPage:(int)curPage;

-(BOOL)checkWifi:(BOOL)showMsg;

-(void)LoadView;
-(void)playAlarm;
-(NSMutableArray *)getArray;
-(void)saveArray:(NSMutableArray *)myArray;
-(void)loadSelectedGameId:(UIButton*)sender;
- (void) setupApplicationAudio;
-(void)loadSelectedViewController:(UIButton*)sender;
- (void) hideTabBar:(UITabBarController *) tabbarcontroller ;
-(void)hideIndicator;
//#########################

-(BOOL) checkFileExist:(NSString*)filename;
-(void)imageSaveToDocumentPath:(UIImage *)image :(NSString*)psFileName;
-(UIImage *) getImageFromDocFolder:(NSString*)pImageName;
//-(NSMutableArray *)getBookDetails;
-(void)EpubStore_database:(NSString *)dbname;
//-(BOOL)IsBookInShelf;
-(void)LoadAllBooksData :(BOOL)loadDateXml;
-(void)GotoSignInPage;
-(void)saveImage:(UIImage *)image withName:(NSString *)name ;
//-(void)DownloadThread:(BookDetails *)bkDetailOBJ;
-(void)DownloadThread:(NSString *)indx;
-(BOOL) checkFileExist:(NSString*)filename;
-(void)LoadAllBooksDateSortXml;
-(void) showLinkBtn;
//Push Notification
-(void)sendingDetailsToServer;
-(UIImage *) removeImageFromDocFolder:(NSString*)pImageName;
//Twitter
+ (SA_OAuthTwitterController *) controllerToEnterCredentialsWithTwitterEngine: (SA_OAuthTwitterEngine *) engine delegate: (id <SA_OAuthTwitterControllerDelegate>) delegate forOrientation:(UIInterfaceOrientation)theOrientation;
+ (SA_OAuthTwitterController *) controllerToEnterCredentialsWithTwitterEngine: (SA_OAuthTwitterEngine *) engine delegate: (id <SA_OAuthTwitterControllerDelegate>) delegate;
+ (BOOL) credentialEntryRequiredWithTwitterEngine: (SA_OAuthTwitterEngine *) engine;
//Twitter
@end


@interface UILabel (customized) 

-(void)setColorAtRect:(CGRect)rectFrame color:(UIColor*)bgColor;
@end

@implementation UILabel (customized)

-(void)setColorAtRect:(CGRect)rectFrame color:(UIColor*)bgColor
{
    UIView *extraview=[[UIView alloc]initWithFrame:rectFrame];
    [extraview setBackgroundColor:bgColor];
    [self addSubview:extraview];
    [extraview release];
}

@end

@interface UIView (customized) 

-(void)setColorAtRect:(CGRect)rectFrame color:(UIColor*)bgColor;
@end

@implementation UIView (customized)
-(void)setColorAtRect:(CGRect)rectFrame color:(UIColor*)bgColor
{
    if([[self subviews] count])
    {
        for(int i=0;i<[[self subviews] count];i++)
        {
           if([(UIView*)[[self subviews] objectAtIndex:i] backgroundColor]==[UIColor blueColor])
           {
                
               [[[self subviews] objectAtIndex:i] removeFromSuperview];
           }
        }
    }
    UIView *extraview=[[UIView alloc]initWithFrame:rectFrame];
    [extraview setBackgroundColor:bgColor];
    [self addSubview:extraview];
    [extraview release];
}

@end
