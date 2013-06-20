//
//  Videos.h
//  DashBoard
//
//  Created by Zaah Technologies on 15/04/11.
//  Copyright 2011 Zaah. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "imageParser.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import "FBConnect.h"
#import"SA_OAuthTwitterController.h"
#import <MessageUI/MessageUI.h>
@class epubstore_svcAppDelegate;
@interface Videos : UIViewController <UIScrollViewDelegate,UIWebViewDelegate,NSXMLParserDelegate>{
	
	UIScrollView *scroll;
	//UIWebView *videoview;
	NSMutableArray *images;
	NSMutableArray *titleName;
	NSMutableArray *videoz;
	NSMutableString *currentElementVal;
	NSString *vidUrl;
	NSURLConnection *connection;
	IBOutlet UIImageView *videoimageView;
	epubstore_svcAppDelegate *appdelegate;
	NSString *videoURL;
    int screenWidth1,screenHeight1,prevVideoTag;
    BOOL allowLandscape,isPlaying;
    SA_OAuthTwitterEngine				*_engine;
	Facebook* _facebook;
	NSArray* _permissions;
    epubstore_svcAppDelegate *appDelegate;
    UITextView *twitterTextField ;
    UIView * twitterView;
    BOOL TwitterOpened;
    UIToolbar *topBar;
    
    UIActionSheet *aSheet;
    UISwitch *firstNotify;
}
@property(nonatomic,retain)UIScrollView *scroll;
//@property(nonatomic,retain)UIWebView *videoview;
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) NSMutableArray *titleName;
@property (nonatomic, retain) NSMutableArray *videoz;
@property (nonatomic,retain)IBOutlet UIImageView *videoimageView;

@property (nonatomic,retain) NSString *videoURL;
-(void)buttonClicked:(id)sender;
- (void)loadImageFromURL:(id)sender;	
- (void) initXMLParser;
@end
