//
//  TBONEViewController.h
//  TBONE
//
//  Created by Zaah Technologies India PVT on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "cocos2d.h"
#import "viewCenter.h"

@class RootViewControllerGame;
@class GameLayer;
@class epubstore_svcAppDelegate;
@interface TBONEViewController : UIViewController <NSXMLParserDelegate>
{
    int screenWidth,screenHeight;
    epubstore_svcAppDelegate *appDelegate;
    
    
    RootViewControllerGame	*viewController;
	GameLayer *currentGameLayer;
	//CCSprite *_pauseScreen;
    //	CCMenu *_pauseScreenMenu;
    //	CCMenuItem *pauseMenuItem;
    //	CCLayer *pauseLayer;
	int pauseTemp_;
	BOOL _pauseScreenUp;
	int currenttime;
	int currentscore;
	float timer;
	NSTimer* timers;
	NSTimer* enemy2timer;
	NSTimer* enemy3timer;
	BOOL pauseEnabled;
	BOOL defaultIconEnable;
	viewCenter *centerview;
	NSTimer *timered;
	BOOL soundEnabled;
	
	BOOL isProVersion;
	BOOL acivateInvisible;
	
	BOOL isFbTapped;
	
	BOOL isContestEnabled;
	
	NSUserDefaults *defaults;
	
	NSString *fName;
	NSString *lName;
	NSString *email;
	NSString *uidString;
	NSString *fullName;
	NSString *thumbURL;
	NSString *deviceID;
	
	NSString *UStr;
	
	BOOL isUpdatedScore;
	BOOL isDataAvailable;
	
	BOOL shouldLoadFaster;
	
	BOOL singleTrigger;
	int activateCount;
	NSMutableDictionary *serverResponseDict;
	UILabel * llabel1;
    
    NSMutableArray *aLink;
    NSMutableString *currentElementValue;
    
}
-(void)initializeGameScreen;

@property(nonatomic,retain) NSMutableArray *aLink;

@property BOOL isGameClosed;
@property (nonatomic, retain)UILabel * llabel1;
@property (nonatomic, retain) viewCenter *centerview;
@property (nonatomic, retain)NSTimer* enemy2timer;
@property (nonatomic, retain)NSTimer* enemy3timer;
@property (nonatomic, retain)NSTimer* timers;
@property (nonatomic, assign)int currentscore;
@property (nonatomic, assign)float timer;
@property (nonatomic, assign)int currenttime;
@property (nonatomic, assign) GameLayer *currentGameLayer;
@property (nonatomic,assign)int pauseTemp_;
@property (nonatomic, assign) BOOL defaultIconEnable;
@property (nonatomic, assign) BOOL pauseScreenUp;
@property (nonatomic, assign) BOOL pauseEnabled;
@property (nonatomic, assign) BOOL soundEnabled;
@property(nonatomic,assign) BOOL isProVersion;
@property (nonatomic, assign) BOOL acivateInvisible;
@property(nonatomic, assign) BOOL isFbTapped;
@property(nonatomic, assign) BOOL isContestEnabled;
@property(nonatomic, assign) BOOL shouldLoadFaster;

@property(nonatomic,retain) NSString *fName;
@property(nonatomic,retain) NSString *lName;
@property(nonatomic,retain) NSString *email;
@property(nonatomic,retain) NSString *uidString;
@property(nonatomic,retain) NSString *fullName;
@property(nonatomic,retain) NSString *thumbURL;
@property(nonatomic,retain) NSString *deviceID;
@property(nonatomic,retain) NSString *UStr;

@property(nonatomic,assign) BOOL isUpdatedScore;
@property(nonatomic,assign) BOOL isDataAvailable;

@property(nonatomic,assign) BOOL isServerResponse;
@property(nonatomic,retain) NSMutableDictionary *serverResponseDict;

-(void)hideButton;
-(void)callBack;
- (void)StartgameInitialization;
-(void)initializeWithView:(UIView*)gameView;
- (void)myApplicationWillResignActive; 
- (void)myApplicationDidBecomeActive;
- (void)myApplicationDidReceiveMemoryWarning;
-(void) myApplicationDidEnterBackground;
-(void)myApplicationWillEnterForeground;
- (void)myApplicationWillTerminate;
- (void)myApplicationSignificantTimeChange;
-(void)loadSelectedGame:(UIButton*)selectedGameBtn;
-(void)comeOutOfGame;
@end
