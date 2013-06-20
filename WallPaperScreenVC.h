//
//  WallPaperScreenVC.h
//  HDBackgroundDemoOne
//
//  Created by Zaah Technologies India PVT on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "AdWhirlDelegateProtocol.h"
//#import "AdWhirlView.h"

#define kSampleAppKey @"a202683fdf7a4e3fb54fc3cbd8638b1a" //68a3bdafbd4746c3adf9454658cec92a" // change this to ur adwhirl sdk key
#define kSampleConfigURL @"http://mob.adwhirl.com/getInfo.php"
#define kSampleImpMetricURL @"http://met.adwhirl.com/exmet.php"
#define kSampleClickMetricURL @"http://met.adwhirl.com/exclick.php"
#define kSampleCustomAdURL @"http://mob.adwhirl.com/custom.php"

//#import "FBConnect.h"
#import"SA_OAuthTwitterController.h"
#import <MessageUI/MessageUI.h>

#define BARBUTTON(TITLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]
@class SA_OAuthTwitterEngine,epubstore_svcAppDelegate;
@interface WallPaperScreenVC : UIViewController <UIScrollViewDelegate,UIActionSheetDelegate,UITextViewDelegate,UIAlertViewDelegate>{


	
	int iTotalCatImages;
	
	
	SA_OAuthTwitterEngine				*_engine;
	//Facebook* _facebook;
	NSArray* _permissions;
	int iSelectedCatIndex;
	int iSelectedImgIndex;
	
	NSString *sCatTitle;
	epubstore_svcAppDelegate *appDelegate;
	
	
	NSMutableData *data;
	
		
	UIButton *btnforward;
	UIButton *btnbackward;
    
    

}

@property(nonatomic,retain)NSMutableArray *selectedArray;
@property(nonatomic,assign)int iSelectedImgIndex;
@property(nonatomic,assign)int iSelectedCatIndex;
@property(nonatomic,assign)int iTotalCatImages;
@property (nonatomic,assign) NSString *sCatTitle;

@property(nonatomic,retain)UIButton *btnforward;
@property(nonatomic,retain)UIButton *btnbackward;

//@property(nonatomic,retain)NSURLConnection *connection;


-(IBAction)facebtnact;
-(IBAction)twitteract;
-(IBAction)emailact;
-(void)openTwitterPage;
- (void) publishStream;
- (void)loadImageFromURL:(NSString*)url ;


@end
