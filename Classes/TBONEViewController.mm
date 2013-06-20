//
//  TBONEViewController.m
//  TBONE
//
//  Created by Zaah Technologies India PVT on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//#import "cocos2d.h"

//#import "GameConfig.h"
//#import "HelloWorldScene.h"
//#import "RootViewControllerGame.h"
//#import "GameStartScene.h"
//#import "GameSoundManager.h"
//#import "CCTransition.h"
//#import "BeforeGameStart.h"
//#import "fbScreen.h"
//#import "Reachability.h"
#import "XMLParserTbon.h"
//#import "HelloWorldScene.h"
#import "XMLReader.h"

#import "TBONEViewController.h"
#import "epubstore_svcAppDelegate.h"
@implementation TBONEViewController

@synthesize currentGameLayer;
@synthesize pauseTemp_;
@synthesize pauseScreenUp = _pauseScreenUp;
@synthesize currenttime;
@synthesize timer;
@synthesize timers;
@synthesize enemy2timer;
@synthesize enemy3timer;
@synthesize currentscore;
@synthesize pauseEnabled;
@synthesize defaultIconEnable;
@synthesize centerview;
@synthesize soundEnabled;
@synthesize isProVersion;
@synthesize acivateInvisible;
@synthesize isFbTapped;
@synthesize isContestEnabled;

@synthesize fName;
@synthesize lName;
@synthesize email;
@synthesize uidString;
@synthesize fullName;
@synthesize thumbURL;
@synthesize deviceID;
@synthesize UStr;
@synthesize isUpdatedScore;
@synthesize isDataAvailable,shouldLoadFaster;
@synthesize isServerResponse,serverResponseDict;
@synthesize  llabel1,isGameClosed;

@synthesize aLink;
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 */
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    screenWidth=[[UIScreen mainScreen]bounds].size.width;
    screenHeight=[[UIScreen mainScreen]bounds].size.height;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIImage *topImage;
    if(screenHeight == 1024)
    {
        topImage=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"games_Ipad" ofType:@"png"]];
    }
    else
    {
        topImage=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"games_Iphone" ofType:@"png"]];   
        
    }
    UIImageView *topCoverImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, topImage.size.width/2, topImage.size.height/2)];
    [topCoverImage setImage:topImage];
    [self.view addSubview:topCoverImage];
    [topCoverImage release];
    [topImage release];
    
    [self performSelectorOnMainThread:@selector(xmlParsing) withObject:nil waitUntilDone:YES];
}

-(void) xmlParsing {
    
    NSString *strUrl = @"http://www.adminmyapp.com/dashboardgsc/api/read?action=getLinks";
	NSLog(@"Stringurl-->%@", strUrl);
   	
	NSError *error;
	NSURLResponse *response;
	NSData *dataReply;
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
	[request setHTTPMethod: @"GET"];
	dataReply   = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if(!response){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
														message:@"Failed to Connect to the Internet"
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:dataReply];
	[xmlParser setDelegate:self];
	[xmlParser parse];
    
    //NSLog(@"array-->%@", aLink);
    
    
    UIButton *appButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *appButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *appButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *appButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *topbutton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *topbutton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *topbutton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if(screenHeight == 480)
    {
        appButton1.frame = CGRectMake(7,195,70,85); 
        appButton2.frame = CGRectMake(85,195,70,85); 
        appButton3.frame = CGRectMake(162,195,70,85);
        appButton4.frame = CGRectMake(242,195,70,85);
        bottomButton.frame = CGRectMake(22,315,275,100);
        topbutton1.frame = CGRectMake(160,125,10,15);
        topbutton2.frame = CGRectMake(175,125,10,15);
        topbutton3.frame = CGRectMake(190,125,15,15);
    }
    else
    {
        appButton1.frame = CGRectMake(17,420,170,210); 
        appButton2.frame = CGRectMake(205,420,165,210); 
        appButton3.frame = CGRectMake(386,420,170,210);
        appButton4.frame = CGRectMake(580,420,170,210);
        bottomButton.frame = CGRectMake(52,690,670,250);
        topbutton1.frame = CGRectMake(385,295,25,55);
        topbutton2.frame = CGRectMake(417,295,30,55);
        topbutton3.frame = CGRectMake(455,295,45,55);
    }
    
    
    [appButton1 setBackgroundColor:[UIColor clearColor]];
    appButton1.tag = 3;
    [appButton1 addTarget:self action:@selector(linkAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:appButton1];
    
    
    
    [appButton2 setBackgroundColor:[UIColor clearColor]];
    appButton2.tag = 4;
    [appButton2 addTarget:self action:@selector(linkAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:appButton2];
    
    
    
    [appButton3 setBackgroundColor:[UIColor clearColor]];
    appButton3.tag = 5;
    [appButton3 addTarget:self action:@selector(linkAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:appButton3];
    
    
    
    [appButton4 setBackgroundColor:[UIColor clearColor]];
    appButton4.tag = 6;
    [appButton4 addTarget:self action:@selector(linkAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:appButton4];
    
    
    
    [bottomButton setBackgroundColor:[UIColor clearColor]];
    bottomButton.tag = 7;
    [bottomButton addTarget:self action:@selector(linkAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
    
    
    
    [topbutton1 setBackgroundColor:[UIColor clearColor]];
    topbutton1.tag = 0;
    [topbutton1 addTarget:self action:@selector(linkAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topbutton1];
    
    
    
    [topbutton2 setBackgroundColor:[UIColor clearColor]];
    topbutton2.tag = 1;
    [topbutton2 addTarget:self action:@selector(linkAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topbutton2];
    
    
    
    [topbutton3 setBackgroundColor:[UIColor clearColor]];
    topbutton3.tag = 2;
    [topbutton3 addTarget:self action:@selector(linkAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topbutton3];
    
    
    /*    if (screenWidth==320) 
     {
     UIImage *topImage=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"topimage_iphone" ofType:@"png"]];
     UIImageView *topCoverImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, topImage.size.width/2, topImage.size.height/2)];
     [topCoverImage setImage:topImage];
     [self.view addSubview:topCoverImage];
     [topCoverImage release];
     [topImage release];
     }
     else
     {
     UIImage *topImage=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"topimage_ipad" ofType:@"png"]];
     UIImageView *topCoverImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, topImage.size.width, topImage.size.height)];
     [topCoverImage setImage:topImage];
     [self.view addSubview:topCoverImage];
     [topCoverImage release];
     [topImage release];
     }
     */   
    /* appDelegate=(epubstore_svcAppDelegate*)[[UIApplication sharedApplication]delegate];
     // UIView *gameView=self.view;
     NSLog(@"Loaded Game View Controller...");
     // NSLog(@"GameView frame...... X==%f Y==%f W==%f H==%f",gameView.frame.origin.x,gameView.frame.origin.y,gameView.frame.size.width,gameView.frame.size.height);
     self.navigationController.navigationBarHidden=TRUE;
     // Do any additional setup after loading the view from its nib.
     
     
     self.view.frame=CGRectMake(0, 0, screenWidth, screenHeight);
     
     NSLog(@"screenWidth===%d screenHeight==%d",screenWidth,screenHeight);
     
     self.view.center=CGPointMake(screenWidth/2.0, screenHeight/2.0);*/
    //[self StartgameInitialization];
    //[self initializeWithView:self.view];
    //[self initializeGameScreen];
    
}

-(IBAction)linkAction:(id)sender{
	NSString *urlString = [aLink objectAtIndex:[sender tag]];
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlstring-->%@", urlString);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"Response"]) {
		aLink = [[NSMutableArray alloc] init];
	}
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (!currentElementValue) {
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	} else {
		[currentElementValue appendString:string];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if([elementName isEqualToString:@"Response"]) {
	}
    else if([elementName isEqualToString:@"IsSuccess"]) {
	}
    else if([elementName isEqualToString:@"Links"]) {
	}
    else if([elementName isEqualToString:@"TopLinks"]) {
	}
    else if([elementName isEqualToString:@"MidLinks"]) {
	}
    else if([elementName isEqualToString:@"BotLinks"]) {
	}
   	else
    {
		if(currentElementValue != nil)
		{
			NSMutableString *str = [[NSMutableString alloc] initWithString:currentElementValue];
			[str replaceOccurrencesOfString:@"\n" withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [currentElementValue length])];
			[str replaceOccurrencesOfString:@"\t" withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [str length])];
			[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			
			if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
			{
				//NSLog(@"yes");
			}
			else
			{
				if(str != nil)
				{	
					[aLink addObject:str];
				}	
			}
			[str release];
		}
		
	}
	[currentElementValue release];
	currentElementValue = nil;
    
}

-(void)initializeGameScreen
{
    /* return;
     UIScrollView *gameListView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, (103.0/480)*screenHeight, screenWidth, (277.0/480)*screenHeight)];
     [self.view addSubview:gameListView];
     [gameListView setBackgroundColor:[UIColor clearColor]];
     for (int i=0; i<2; i++) 
     {
     NSString *imageName=[NSString stringWithFormat:@"game%dimage",(i+1)];
     UIImage *gameImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imageName ofType:@"png"]];
     UIImageView *gamePrevImage=[[UIImageView alloc]initWithFrame:CGRectMake((i*(((15.0/320)+(151.0/320))*screenWidth)), 0,(151.0/320)*screenWidth, (227.0/480)*screenHeight)];
     gamePrevImage.image=gameImage;
     [gameListView addSubview:gamePrevImage];
     
     UIButton *startSelectedGame=[UIButton buttonWithType:UIButtonTypeCustom];
     startSelectedGame.frame=CGRectMake((i*(((15.0/320)+(151.0/320))*screenWidth)), (232.0/480)*screenHeight,(151.0/320)*screenWidth, (45.0/480)*screenHeight);
     [gameListView addSubview:startSelectedGame];
     [startSelectedGame setBackgroundColor:[UIColor blackColor]];
     [startSelectedGame setTitle:@"PLAY NOW" forState:UIControlStateNormal];
     [startSelectedGame setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [gamePrevImage release];
     startSelectedGame.tag=i+1;
     [startSelectedGame addTarget:appDelegate action:@selector(loadSelectedGameId:) forControlEvents:UIControlEventTouchUpInside];
     gameListView.contentSize=CGSizeMake((i+1)*(((15.0/320)+(151.0/320))*screenWidth), (277.0/480)*screenHeight);
     }
     [gameListView release];*/
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void) setPause:(BOOL)up
{
	//self.pauseScreenUp = YES;
}



- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
    //#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	
	//	CC_ENABLE_DEFAULT_GL_STATES();
	//	[glView swapBuffers];
	//	CC_ENABLE_DEFAULT_GL_STATES();
	
    //#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}
- (void)StartgameInitialization
{
	/*shouldLoadFaster=FALSE;
     CCLOG(@"applicationDidFinishLaunching++++++++"); 
     if(!centerview)
     centerview = [[viewCenter alloc] initWithNibName:@"viewCenter" bundle:nil];
     
     
     defaultIconEnable=TRUE;
     defaults = [NSUserDefaults standardUserDefaults];
     
     Reachability* reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
     isDataAvailable = [reachability FinalStatus];
     
     if([defaults boolForKey:@"isProUpgradePurchased" ])
     {
     isProVersion = [defaults boolForKey:@"isProUpgradePurchased" ];
     }
     else {
     isProVersion = FALSE;
     }
     
     if([defaults boolForKey:@"CONTESTENABLED"])
     {
     isContestEnabled = [defaults boolForKey:@"CONTESTENABLED"];
     }
     else 
     {
     isContestEnabled = FALSE;
     }
     
     if([defaults objectForKey:@"URLSTRING"])
     {
     UStr = [defaults objectForKey:@"URLSTRING"];
     }
     else {
     UStr = [[NSString alloc]init];
     }
     
     if([defaults objectForKey:@"PREVIOUSSCORE"])
     {
     currentscore = [defaults integerForKey:@"PREVIOUSSCORE"];
     }
     
     if([defaults boolForKey:@"SCOREUPDATE"])
     {
     if(isDataAvailable)
     {
     NSString *allBooksUrl = [NSString stringWithFormat:@"%@%d",UStr,currentscore];
     allBooksUrl = [allBooksUrl stringByReplacingOccurrencesOfString:@" " withString:@"\""];
     allBooksUrl = [allBooksUrl stringByReplacingOccurrencesOfString:@"@" withString:@"\u0040"];
     NSLog(@"fb URL==>%@",allBooksUrl);
     
     allBooksUrl=[allBooksUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     NSError *error;
     NSURLResponse *response;
     NSData *dataReply;
     NSString *stringReply;
     
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: 
     [NSURL URLWithString:allBooksUrl]];
     [request setHTTPMethod: @"POST"];
     dataReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
     stringReply = [NSString stringWithData:dataReply encoding:NSUTF8StringEncoding];
     NSArray *array = [stringReply componentsSeparatedByString:@"</success>"];
     NSLog(@"%@",[array description]);
     NSString *str = [array objectAtIndex:0];
     NSLog(@"%@",str);
     array = [str componentsSeparatedByString:@">"];
     str = [array objectAtIndex:1];
     NSLog(@"%@",str);
     if([str isEqualToString:@"1"])
     {
     
     isUpdatedScore = FALSE;
     [[NSUserDefaults standardUserDefaults] setBool:currentscore forKey:@"SCOREUPDATE" ];
     [[NSUserDefaults standardUserDefaults] synchronize];
     NSLog(@"SUCCESS");
     }
     else if([str isEqualToString:@"0"])
     {
     isUpdatedScore = TRUE;
     [[NSUserDefaults standardUserDefaults] setBool:currentscore forKey:@"SCOREUPDATE" ];
     [[NSUserDefaults standardUserDefaults] synchronize];
     }
     }
     
     }
     
     
     if(isDataAvailable)
     {
     
     NSString *urlString = @"http://21stgames.com/basearcade/admin/api/read?action=contestXml";
     urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"\""];
     urlString = [urlString stringByReplacingOccurrencesOfString:@"@" withString:@"\u0040"];
     NSLog(@"fb URL==>%@",urlString);
     
     urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     
     NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
     XMLParserTbon *parser = [[XMLParserTbon alloc] initXMLParserwithIndex:1];
     [xmlParser setDelegate:parser];
     BOOL success = [xmlParser parse];
     if(success){
     isServerResponse = TRUE;
     }
     
     [xmlParser release];
     [parser release];
     
     }
     
     
     currenttime=60;
     timer=0.8f;
     currentscore=0;*/
	
}

-(void)initializeWithView:(UIView*)gameView
{
    
    ////    NSLog(@"GameView frame...... X==%f Y==%f W==%f H==%f",gameView.frame.origin.x,gameView.frame.origin.y,gameView.frame.size.width,gameView.frame.size.height);
	
    // Init the window
    
    // Try to use CADisplayLink director
    // if it fails (SDK < 3.1) use the default director
    /* if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
     [CCDirector setDirectorType:kCCDirectorTypeDefault];
     
     
     CCDirector *director = [CCDirector sharedDirector];
     
     
     timered = [NSTimer scheduledTimerWithTimeInterval:20.0f target:self selector:@selector(disableScreenLock) userInfo:nil repeats:YES];
     
     
     // Init the View Controller
     
     viewController = [[RootViewControllerGame alloc] initWithNibName:nil bundle:nil];
     viewController.wantsFullScreenLayout = YES;
     
     //
     // Create the EAGLView manually
     //  1. Create a RGB565 format. Alternative: RGBA8
     //	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
     //
     //
     EAGLView *glView = [EAGLView viewWithFrame:[self.view bounds]
     pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
     depthFormat:0						// GL_DEPTH_COMPONENT16_OES
     ];
     
     // attach the openglView to the director
     [director setOpenGLView:glView];
     
     //	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
     if( ! [director enableRetinaDisplay:YES] )
     CCLOG(@"Retina Display Not supported");
     
     //
     // VERY IMPORTANT:
     // If the rotation is going to be controlled by a UIViewController
     // then the device orientation should be "Portrait".
     //
     // IMPORTANT:
     // By default, this template only supports Landscape orientations.
     // Edit the RootViewController.m file to edit the supported orientations.
     //
     #if GAME_AUTOROTATION == kGameAutorotationUIViewController
     [director setDeviceOrientation:kCCDeviceOrientationPortrait];
     #else
     [director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
     #endif
     
     [director setAnimationInterval:1.0/60];
     [director setDisplayFPS:NO];
     
     
     // make the OpenGLView a child of the view controller
     [viewController setView:glView];
     
     // make the View Controller a child of the main window
     [self.view  addSubview: viewController.view];
     
     ////    [gameView makeKeyAndVisible];
     
     // Default texture format for PNG/BMP/TIFF/JPEG/GIF images
     // It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
     // You can change anytime.
     [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
     
     
     //	// Removes the startup flicker
     [self removeStartupFlicker];
     
     //[NSThread sleepForTimeInterval:2.0f];
     //sleep (3);
     
     [[GCHelper sharedInstance] authenticateLocalUser];  // game center
     centerview.view.userInteractionEnabled=NO;
     [self.view  addSubview:centerview.view];
     
     [[GameSoundManager sharedManager] setup];//for sound setup.
     //    appDelegate.activateCount++;
     //     //[[CCDirector sharedDirector] replaceScene: [BeforeGameStart scene]];
     //    NSLog(@"Activate count :%d",appDelegate.activateCount);
     //    if(appDelegate.activateCount==1)
     //    {
     //       // singleTrigger=YES;
     //        NSLog(@"Activate count is equal to 1");
     
     [[CCDirector sharedDirector] runWithScene: [BeforeGameStart scene]];
     //    }
     //    else if(appDelegate.activateCount > 1)
     //    {
     //        NSLog(@"Activate count is greater than 1");
     //
     //        [[CCDirector sharedDirector] replaceScene: [BeforeGameStart scene]];
     //
     //    }
     // }
     appDelegate.isFirstTimeGameLoad=NO;*/
    ////     [[CCDirector sharedDirector] runWithScene: [GameStartScene scene]];
    // [[CCDirector sharedDirector] runWithScene:[HelloWorld scene]];
}

-(void)callBack
{
	
}
-(void)loadSelectedGame:(UIButton*)selectedGameBtn
{
//    int selectedGame=selectedGameBtn.tag;
//    switch (selectedGame) 
//    {
//        case 1:
//            
//            [[CCDirector sharedDirector]replaceScene:[GameStartScene scene]];
//            break;
//            
//        default:
//            break;
//    }
}

-(void)hideButton
{
	/*GameStartScene *hideButtonPopup = [GameStartScene node];
     NSLog(@"ookokokkokk++++++++++***************");
     [hideButtonPopup hideButton];*/
}
- (void)disableScreenLock
{
	/*[UIApplication sharedApplication].idleTimerDisabled=NO;
     [UIApplication sharedApplication].idleTimerDisabled=YES;
     [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];*/
}

- (void)myApplicationWillResignActive 
{
	/*NSLog(@"Resign Active in TBOne ViewCOntroller+++++++++++++++++++++++");
     //	soundEnabled = TRUE;
     [GameSoundManager sharedManager].soundEngine.mute=YES;
     [GameSoundManager sharedManager].soundEngine.backgroundMusicVolume=0.0f;
     [GameSoundManager sharedManager].soundEngine.effectsVolume=0.0f;
     [[CCDirector sharedDirector] stopAnimation];
     [[CCDirector sharedDirector] pause];
     
     if(timered != nil)
     {
     [timered invalidate];
     timered = nil;
     }*/
}

- (void)myApplicationDidBecomeActive{
	/*NSLog(@"Become Active in TBOne ViewCOntroller+++++++++++++++++++++++");
     timered = [NSTimer scheduledTimerWithTimeInterval:20.0f target:self selector:@selector(disableScreenLock) userInfo:nil repeats:YES];
     [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(muteDisabler) userInfo:nil repeats:NO];
     
     [[CCDirector sharedDirector] stopAnimation];
     
     [[CCDirector sharedDirector] resume];
     //[GameSoundManager sharedManager].soundEngine.backgroundMusicVolume=0.4f;
     
     [[CCDirector sharedDirector] startAnimation];
     if(currentGameLayer != nil)
     {
     if (!currentGameLayer.pauseScreenUp)
     [currentGameLayer pauseButtonTapped:nil];
     else
     [[CCDirector sharedDirector] pause];
     }*/
}
- (void)muteDisabler
{
	/*[GameSoundManager sharedManager].soundEngine.mute=NO;
     //[GameSoundManager sharedManager].soundEngine.backgroundMusicVolume=0.4f;
     [GameSoundManager sharedManager].soundEngine.effectsVolume=1.0f;*/
}
- (void)myApplicationDidReceiveMemoryWarning{
    //    [CCAnimationCache purgeSharedAnimationCache];
    //    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
    //    [CCTextureCache purgeSharedTextureCache];
    //[[CCDirector sharedDirector] purgeCachedData];
    
    
    //    CCDirector *director = [CCDirector sharedDirector];
    //	
    //	[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"CONTESTENABLED" ];
    //	[[NSUserDefaults standardUserDefaults] synchronize];
    //	
    //	
    //	[[director openGLView] removeFromSuperview];
    //	
    //	[viewController release];
    //	//[centerview release];
    //	
    //	
    //	[director end];	
    
}

-(void) myApplicationDidEnterBackground{
	//[[CCDirector sharedDirector] stopAnimation];
	//[[CCDirector sharedDirector] pause];
}

-(void)myApplicationWillEnterForeground{
	//NSLog(@"applicationWillEnterForeground");
}
-(void)comeOutOfGame
{
    //if (isGameClosed) 
    /*{
     NSLog(@"+++++++++++++++++++++++++++Game is closed");
     
     //        if (viewController) {
     //            [viewController dismissModalViewControllerAnimated:YES];
     //            [viewController release];
     //            viewController=nil;
     //            //[[PSPDFCache sharedPSPDFCache] clearCache];
     //        }
     
     [CCAnimationCache purgeSharedAnimationCache];
     [CCSpriteFrameCache purgeSharedSpriteFrameCache];
     [CCTextureCache purgeSharedTextureCache];
     [[CCDirector sharedDirector] purgeCachedData];
     currenttime=60;
     [self myApplicationWillTerminate];
     //[[CCDirector sharedDirector] release];
     //[self myApplicationWillTerminate];
     
     //        [[GameSoundManager sharedManager] release];
     //        [[CCDirector sharedDirector] release];
     //        [timered invalidate];
     //        timered=nil;
     return;
     }*/
    //isGameClosed=TRUE;
    //    NSLog(@"+++++++++++++++++++++++++++Game is closed++++++++++++++++++++++++++++++");
    //
    //    [self myApplicationWillTerminate];
    //    //[[GameSoundManager sharedManager] release];
    //    [[CCDirector sharedDirector] release];
    //    [timered invalidate];
    //    timered=nil;
}
- (void)myApplicationWillTerminate{
	/*CCDirector *director = [CCDirector sharedDirector];
     
     [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"CONTESTENABLED" ];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     
     [[director openGLView] removeFromSuperview];
     
     [viewController release];
     viewController=nil;
     //[centerview release];
     
     [director end];	*/
}

- (void)myApplicationSignificantTimeChange{
	//[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    // return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    /* NSLog(@"Dealloc done in game controller++++++++++++++++++++++++++++++++++++++++");
     [[CCDirector sharedDirector].openGLView removeFromSuperview];
     //[[CCDirector sharedDirector] popScene];
     [[GCHelper sharedInstance] release];
     [[GameSoundManager sharedManager]release];
     [[CCDirector sharedDirector] release];
     [centerview release];
     [super dealloc];*/
}

@end
