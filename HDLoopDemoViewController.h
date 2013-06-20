//
//  HDLoopDemoViewController.h
//  HDLoopDemo
//
//  Created by partha neo on 11/11/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AdWhirlDelegateProtocol.h"
//#import "AdWhirlView.h"


#import "FBConnect.h"
#import"SA_OAuthTwitterController.h"
#import <MessageUI/MessageUI.h>
#import <StoreKit/StoreKit.h>
#define kSampleAppKey @"a202683fdf7a4e3fb54fc3cbd8638b1a" //"68a3bdafbd4746c3adf9454658cec92a" // change this to ur adwhirl sdk key
#define kSampleConfigURL @"http://mob.adwhirl.com/getInfo.php"
#define kSampleImpMetricURL @"http://met.adwhirl.com/exmet.php"
#define kSampleClickMetricURL @"http://met.adwhirl.com/exclick.php"
#define kSampleCustomAdURL @"http://mob.adwhirl.com/custom.php"


#define BARBUTTON(TITLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]
@class SA_OAuthTwitterEngine,epubstore_svcAppDelegate;

//@class WallPaperScreenVC;
@interface HDLoopDemoViewController : UIViewController <UIScrollViewDelegate,UIActionSheetDelegate,UITextViewDelegate,UINavigationBarDelegate,FBRequestDelegate,FBDialogDelegate,FBSessionDelegate,MFMailComposeViewControllerDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver,SKRequestDelegate>{
	

	UIImage *anImage;
	UIScrollView *aScrollView;

	UIView *aView;
	int totalImagesCount;


	
//	WallPaperScreenVC *wallPaperVc;
	
	//UIScrollView *containerScrollView;
	//UIScrollView *leftScrollView;
	//UIScrollView *rightScrollView;
	//UIScrollView *scrollView;
	

	UINavigationController *aController;
	NSString *sCatName;
	int iCatId;
	int iCatIndexValue;
	int totalImages;
	UIButton *aButton;
	
	SA_OAuthTwitterEngine				*_engine;
	Facebook* _facebook;
	NSArray* _permissions;
	epubstore_svcAppDelegate *appDelegate;
	
	NSURLConnection *connection;
	NSURLConnection *connection2;
	NSMutableData *data;
	NSMutableData *data2;
	//AdWhirlView *adView;
NSURL *responseUrl;
	NSURL *responseUrl1;
    int currentImage;
	
    
	}

//@property (nonatomic,retain) WallPaperScreenVC *wallPaperVc;
@property (nonatomic,retain)NSMutableArray *selectedcategoryArray;
@property (nonatomic,retain)NSURL *responseUrl;
@property (nonatomic,retain)NSURL *responseUrl1;
@property (nonatomic,retain)NSString *sCatName;
@property (nonatomic,assign)int iCatId;
@property (nonatomic,assign)int totalImages;
@property (nonatomic,assign)int iCatIndexValue; 
@property (nonatomic,assign)int totalImagesCount;
@property (nonatomic,retain)NSString *kInAppPurchaseProUpgradeProductId;
-(void)setImagesstartingFrom:(NSInteger)number withView:(UIView*)v;
//-(void)setViews;
-(IBAction)facebtnact;
-(IBAction)twitteract;
-(IBAction)emailact;
-(void)openTwitterPage;
- (void) publishStream;
-(IBAction)fnSelectedThumb:(id)sender;
-(void)loadImageFromURL:(NSString*)url;
- (void)loadImageFromURL2:(NSString*)url;


@end

