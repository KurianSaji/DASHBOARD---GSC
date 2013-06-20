//
//  HDBackgroundDemoOneViewController.h
//  HDBackgroundDemoOne
//
//  Created by partha neo on 11/15/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


//#import "AdWhirlDelegateProtocol.h"
//#import "AdWhirlView.h"
//
#import "FBConnect.h"
#import"SA_OAuthTwitterController.h"
#import "epubstore_svcAppDelegate.h"

#import <MessageUI/MessageUI.h>

#define kSampleAppKey @"a202683fdf7a4e3fb54fc3cbd8638b1a" //68a3bdafbd4746c3adf9454658cec92a" // change this to ur adwhirl sdk key
#define kSampleConfigURL @"http://mob.adwhirl.com/getInfo.php"
#define kSampleImpMetricURL @"http://met.adwhirl.com/exmet.php"
#define kSampleClickMetricURL @"http://met.adwhirl.com/exclick.php"
#define kSampleCustomAdURL @"http://mob.adwhirl.com/custom.php"

#define BARBUTTON(TITLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]
@class TableCellView;
@class SA_OAuthTwitterEngine,epubstore_svcAppDelegate;

@interface HDBackgroundDemoOneViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextViewDelegate,UINavigationControllerDelegate,FBRequestDelegate,FBDialogDelegate,FBSessionDelegate,MFMailComposeViewControllerDelegate>{
	
	UITableView *aTableView;
	SA_OAuthTwitterEngine				*_engine;
	Facebook* _facebook;
	NSArray* _permissions;

	UIImageView *splashScreen;
	//AdWhirlView *adView;
	epubstore_svcAppDelegate *appDelegate;
	NSURLConnection *connection;
	NSMutableData *data;
	NSMutableArray *array;
	//HDBackgroundDemoOneViewController *hdback;
	UILabel *topLabel;
    
    UIActionSheet *aSheet;
    UISwitch *firstNotify;
}

-(IBAction)facebtnact;
-(IBAction)twitteract;
-(IBAction)emailact;
- (void)loadImageFromURL:(NSURL*)url;
-(void)loadDefaultFils;
- (void) publishStream;
-(void)openTwitterPage;
- (void)requestProUpgradeProductData;

@property (nonatomic, retain) NSMutableArray *array;
@end

