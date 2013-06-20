    //
//  Videos.m
//  DashBoard
//
//  Created by Zaah Technologies on 15/04/11.
//  Copyright 2011 Zaah. All rights reserved.
//

#import "Videos.h"
#import "epubstore_svcAppDelegate.h"
#import "CustomButton.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPMoviePlayerViewController.h>
#import "SA_OAuthTwitterEngine.h"
#define kOAuthConsumerKey				@"gKKNHPCJR4ogFjWT9vjgg"		//REPLACE ME  Twitter
#define kOAuthConsumerSecret			@"1FOKxqZI4FCT1zjKMA6vdE16jZD5STGVB5wGzxrpKc"

@interface MPMoviePlayerViewController (private)

@end
@implementation MPMoviePlayerViewController (private)

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    NSLog(@"MPMoviePlayerViewController Playing....");
    return YES;
}

@end


@implementation Videos

@synthesize scroll,images,titleName,videoz;
@synthesize videoimageView;
@synthesize videoURL;

int screnWidthipad =768;
CustomButton *thumbbtn[200];
UILabel *vidname[10];
//UITextView *vidname[10];
int buttonindex=0;
NSMutableData *data;
UIView *videoview1;
int buttonwidth =214;
UIView *overview;
BOOL clicked=TRUE;
BOOL _isDataSourceAvailable;
int pageno;
int buttonindex;
int btnvalue=3;
MPMoviePlayerViewController *movie;
BOOL isDisplayed;
BOOL VappFirstTime=TRUE;
UIWebView *webVideo;
static NSString* kAppId = @"180294668651052";
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/ //sroll*button
- (BOOL)isDataSourceAvailable
{
	static BOOL checkNetwork = YES;
	
	if (checkNetwork) 
	{ 
		checkNetwork = NO;
		
		Boolean success;    
		const char *host_name = "www.google.com";
		
		SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
		SCNetworkReachabilityFlags flags;
		success = SCNetworkReachabilityGetFlags(reachability, &flags);
		_isDataSourceAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
		CFRelease(reachability);
	}
	return checkNetwork;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Video did load");
	isDisplayed=FALSE;
    TwitterOpened= NO;
    appDelegate=[[UIApplication sharedApplication]delegate];
    if (!self.images) {
        self.images = [[NSMutableArray alloc] init];
    }
	if (!self.titleName) {
        self.titleName = [[NSMutableArray alloc] init];
    }
	if (!self.videoz) {
        self.videoz = [[NSMutableArray alloc] init];
    }
	[self.images removeAllObjects];
    [self.titleName removeAllObjects];
    [self.videoz removeAllObjects];
    
    screenWidth1 = [[UIScreen mainScreen] bounds].size.width;
	screenHeight1 = [[UIScreen mainScreen] bounds].size.height;
    if (screenWidth1==320) 
    {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"videosBg_iphone.png"]];
        buttonwidth=107;
        UIImage *topImage=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"videotop_ipad" ofType:@"png"]];
        UIImageView *topCoverImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, topImage.size.width/2, topImage.size.height/2)];
        [topCoverImage setImage:topImage];
        [self.view addSubview:topCoverImage];
        [topCoverImage release];
        [topImage release];
    }
    else
    {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"videosBg_ipad.png"]];
        buttonwidth=256;
        UIImage *topImage=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"videotop_ipad" ofType:@"png"]];
        UIImageView *topCoverImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, topImage.size.width, topImage.size.height)];
        [topCoverImage setImage:topImage];
        [self.view addSubview:topCoverImage];
        [topCoverImage release];
        [topImage release];
    }
    UILabel *maximTv=[[UILabel alloc]initWithFrame:CGRectMake((30.0/768)*screenWidth1, (100.0/1024)*screenHeight1, (223.0/768)*screenWidth1, (50.0/1024)*screenHeight1)];
    maximTv.text=@"MAXIM TV";
    if (screenWidth1==768) 
    {
        [maximTv setFont:[UIFont boldSystemFontOfSize:30]];
    }
    else
    {
        [maximTv setFont:[UIFont boldSystemFontOfSize:13]];
    }
   // [self.view addSubview:maximTv];
    [maximTv setTextColor:[UIColor blackColor]];
    [maximTv setBackgroundColor:[UIColor clearColor]];
    [maximTv release];

    UIView *videoBackView=[[UIView alloc]initWithFrame:CGRectMake(0, (70.0/480)*screenHeight1, screenWidth1, (216.0/480)*screenHeight1)];
    [videoBackView setBackgroundColor:[UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1]];
    [videoBackView setColorAtRect:CGRectMake((12.0/320)*screenWidth1, (13.0/480)*screenHeight1, screenWidth1-(2*12.0/320)*screenWidth1, (4.0/480)*screenHeight1) color:[UIColor redColor]];
    [self.view addSubview:videoBackView];
    [videoBackView release];
    
    /*UIView *featureVideo=[[UIView alloc]initWithFrame:CGRectMake(0, (650.0/1024)*screenHeight1, screenWidth1, (40.0/1024)*screenHeight1)];
    [featureVideo setBackgroundColor:[UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1]];
    UIImageView *arrowView=[[UIImageView alloc]initWithFrame:CGRectMake((11.0/768)*screenWidth1, (11.0/1024)*screenHeight1, (24.0/768)*screenWidth1, (14.0/1024)*screenHeight1)];
    UIImage *arrowImg=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"videoArrow" ofType:@"png"]];
    arrowView.image=arrowImg;
    [featureVideo addSubview:arrowView];
    [self.view addSubview:featureVideo];
    [featureVideo release];
    UILabel *featureLable=[[UILabel alloc]initWithFrame:CGRectMake((42.0/768)*screenWidth1, 0, (223.0/768)*screenWidth1, (37.0/1024)*screenHeight1)];
    featureLable.text=@"FEATURED VIDEO";
    [featureVideo addSubview:featureLable];
    [featureLable setTextColor:[UIColor blackColor]];
    [featureLable setBackgroundColor:[UIColor clearColor]];
    
    if (screenWidth1==768) 
    {
        [featureLable setFont:[UIFont fontWithName:@"Helvetica" size:24]];
    }
    else
    {
        [featureLable setFont:[UIFont fontWithName:@"Helvetica" size:10]];
    }
    [featureLable release];
    [arrowImg release];
    [arrowView release];*/

    /*UIView *videoListBackView=[[UIView alloc]initWithFrame:CGRectMake(0, (337.0/480)*screenHeight1, screenWidth1, (103.0/480)*screenHeight1)];
    [videoListBackView setBackgroundColor:[UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1]];
    [self.view addSubview:videoListBackView];
    [videoListBackView release];*/
	[self performSelector:@selector(viewContent) withObject:nil afterDelay:0.05];
	
/*	[[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(windowNowVisible:) 
                                                name:UIWindowDidBecomeVisibleNotification 
                                              object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(windowNowHidden:) 
                                                 name:UIWindowDidBecomeHiddenNotification 
                                               object:self.view.window];
 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackDidFinish:) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackDidFinish:) name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];
    
    //UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
//    [btn setTitle:@"i" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    btn.titleLabel.font=[UIFont fontWithName:@"HoeflerText-BlackItalic" size:32];
//    if (screenWidth1==320) 
//    {
//        btn.titleLabel.font=[UIFont fontWithName:@"HoeflerText-BlackItalic" size:17];
//    }
    
    ////	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"Information.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionSheetAction) forControlEvents:UIControlEventTouchUpInside];
	
    btn.frame=CGRectMake(screenWidth1-((35.0/768)*screenWidth1), (10.0/1024)*screenHeight1, (30.0/768)*screenWidth1, (30.0/1024)*screenHeight1);
    [self.view addSubview:btn];
    
    topBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    UIView *topBarView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth1, 44)];
    UIButton *postBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [postBtn setTitle:@"Post" forState:UIControlStateNormal];
    postBtn.frame=CGRectMake(screenWidth1-90, 5, 70, 35);
    [postBtn addTarget:self action:@selector(twitteract) forControlEvents:UIControlEventTouchUpInside];
    [topBarView addSubview:postBtn];
    [topBarView setBackgroundColor:[UIColor clearColor]];
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
    backBtn.frame=CGRectMake(0, 5, 70, 35);
    [backBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [topBarView addSubview:backBtn];
    
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [postBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *tabBtn2=[[UIBarButtonItem alloc]initWithCustomView:topBarView];
    NSArray *items=[[NSArray alloc]initWithObjects:tabBtn2,nil];
    [topBar setItems:items];
 }

- (void)loadStateDidChange:(NSNotification*)notification
{
    NSLog(@"________loadStateDidChange");
    appdelegate.isVideoPlaying=TRUE;
    
    isPlaying=TRUE;
}

- (void)playbackDidFinish:(NSNotification*)notification
{
    NSLog(@"________DidExitFullscreenNotification");
    appdelegate.isVideoPlaying=FALSE;
    
    UIViewController *c = [[UIViewController alloc]init];
    [self presentModalViewController:c animated:NO];
    [self dismissModalViewControllerAnimated:NO];
    [c release];

    
///    [appdelegate changeOrientationToPortrait];
}

- (void)windowNowVisible:(NSNotification *)notification
{
    NSLog(@"Youtube/ Media window appears");
    appdelegate.isVideoPlaying=TRUE;
}


- (void)windowNowHidden:(NSNotification *)notification 
{
    NSLog(@"Youtube/ Media window disappears."); 
    appdelegate.isVideoPlaying=FALSE;
}

-(void)viewWillAppear:(BOOL)animated
{
    if (isPlaying) 
    {
        isPlaying=FALSE;
        return;
    }
	isDisplayed=TRUE;
	NSLog(@"Called in viewwillappear");
	appdelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appdelegate.videoVC.view setHidden:FALSE];
	//[appdelegate.window bringSubviewToFront:appdelegate.videoview];
	[appdelegate.window bringSubviewToFront:appdelegate.videoVC.view];
	[appdelegate.videoview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.videoURL]]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (isPlaying) 
    {
        return;
    }
	isDisplayed=FALSE;
	//[appdelegate.videoVC.view setHidden:TRUE];
	[appdelegate.window willRemoveSubview:appdelegate.videoVC.view];
	[appdelegate.videoview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];	
}



-(void)viewContent
{
	//isDisplayed=FALSE;
	//	appdelegate = (DashboardUnivseAppDelegate *)[[UIApplication sharedApplication] delegate];
	//	if(appdelegate.screenHeight1 == 1024)
	//	{
	//		[[NSBundle mainBundle] loadNibNamed:@"Videos" owner:self options:nil];
	//		
	//	}
	//	else								 
	//		[[NSBundle mainBundle] loadNibNamed:@"Videosiphone" owner:self options:nil];
	NSLog(@"Video view content");
	appdelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
	if ([self isNetConnected])
	{
		_isDataSourceAvailable=TRUE;
	}
	else {
		_isDataSourceAvailable=FALSE;
	}
	
	
	if (_isDataSourceAvailable==TRUE)
	{
		NSString *strUrlpath=[NSString stringWithFormat:@"%@/api/read?action=video&start=0&record=15",serverIP];
		NSURL *url = [[NSURL alloc] initWithString:strUrlpath];
		
		NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
		[url release];
		[xmlParser setDelegate:self];
		BOOL success = [xmlParser parse];
        [xmlParser release];
        xmlParser=nil;

		if(appdelegate.screenHeight1 ==1024)
		{
			scroll =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 600, screnWidthipad, 400)];
			scroll.contentSize=CGSizeMake((buttonwidth*[self.images count])+60, 0);
            
		}
		else
		{
            scroll =[[UIScrollView alloc] initWithFrame:CGRectMake(0, (600.0/1024)*screenHeight1, (screnWidthipad/768.0)*screenWidth1, (400.0/1024)*screenHeight1)];
            

            
            //scroll =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 300, (screnWidthipad/768.0)*screenWidth1, 100)];
            
			scroll.contentSize=CGSizeMake((buttonwidth*[self.images count])+20, 0);
		//	scroll =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 270, 320, 205)];
		//	scroll.contentSize=CGSizeMake(0, (62*[self.images count]+150));
		}
		[scroll setBackgroundColor:[UIColor clearColor]];
		scroll.delegate=self;
		
		scroll.scrollEnabled=YES;
		//[scroll setPagingEnabled:YES];
		scroll.showsHorizontalScrollIndicator=NO;
		[self.view addSubview:scroll];
		[scroll release];
        

		
		//		if(appdelegate.screenHeight1 == 1024)
		//			appdelegate.videoview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 150, 768, 467)];
		//		else
		//			appdelegate.videoview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 50, 320, 196)];
		
		
		
		if(appdelegate.screenHeight1 == 1024)
			webVideo= [[UIWebView alloc]initWithFrame:CGRectMake((12.0/320)*screenWidth1, (86.0/480)*screenHeight1, 768-(2*12.0/320)*screenWidth1, (182.0/480)*screenHeight1)];
		else
			webVideo = [[UIWebView alloc]initWithFrame:CGRectMake(12, 86, 320-(2*12), 182)];
		
		webVideo.tag = 3001;
		
		
		appdelegate.videoview=webVideo;
		
		
		[self.view addSubview:webVideo];
		
		[self.view bringSubviewToFront:webVideo];
		
		for(UIView *view1 in [appdelegate.videoview subviews])
		{
			[self.view bringSubviewToFront:view1];
		}
		if (webVideo!=nil)
		{
			//[webVideo removeFromSuperview];
			[webVideo release];
			webVideo=nil;
		}
		//for(UIWebView *view1 in [self.view subviews])
		//		{
		//			[self.view bringSubviewToFront:view1];
		//		}
		
		
		
		int i=0;
//		if(appdelegate.screenHeight1 == 1024)
		{
			for (int col = 0; col<[self.images count];col++) // 10+col*253,126, 243, 149
			{//buttonwidth=110;
	////			if(appdelegate.screenHeight1 ==1024)
                thumbbtn[i] = [CustomButton buttonWithType:UIButtonTypeCustom];
                
                thumbbtn[i].frame=CGRectMake(((2+col*109.66)/320.0)*screenWidth1,(63.0/480)*screenHeight1, (106.66/320)*screenWidth1, (71.0/480)*screenHeight1);
			/*	else
					thumbbtn[i] = [[CustomButton alloc] initWithFrame:CGRectMake(5+col*105,10, 100, 80)];
			*/	
				UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"video_thumbnail_01" ofType:@"png"]];
				[thumbbtn[i] setBackgroundImage:img forState:UIControlStateNormal];
				//[img release];
				[thumbbtn[i] addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
				thumbbtn[i].tag=i+200;
//                [thumbbtn[i] setBackgroundColor:[UIColor blackColor]];
				[scroll addSubview: thumbbtn[i]];
				vidname[i] = [[UILabel alloc]init];
	////			if(appdelegate.screenHeight1 == 1024)
                vidname[i].frame = CGRectMake(((2+col*109.66)/320.0)*screenWidth1,((63.0+70.0)/480)*screenHeight1, ((107/320.0)*screenWidth1), (21.0/480)*screenHeight1);
			/*	else
					vidname[i].frame = CGRectMake(5+col*105,95, 100, 30);//5+col*105,90, 100, 30
			*/	
				//vidname[i].backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"video_text_input.png"]];
				vidname[i].backgroundColor=[UIColor blackColor];
				vidname[i].textColor=[UIColor whiteColor];
                vidname[i].textAlignment=UITextAlignmentCenter;
               
				NSString *tempname = [self.titleName objectAtIndex:i];
				NSString *trimName= [tempname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				
				NSLog(@"text manes : %@ count: %d",self.titleName,[self.images count]);
				[vidname[i] setText:trimName];
				
				vidname[i].numberOfLines = 0;
                if(appdelegate.screenHeight1 ==1024)
				vidname[i].font = [UIFont systemFontOfSize:16];
                else
                    vidname[i].font = [UIFont systemFontOfSize:8];
				
				NSString *temp = [self.images objectAtIndex:i];
				NSString *trim= [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				
				NSString *temp1 = [NSString stringWithFormat:@"%@/%@",serverIP,trim];
				thumbbtn[i].strThumUrl=temp1;
				[scroll addSubview: vidname[i]];
				if (i<3)
				{
					[self performSelector:@selector(loadImageFromURL:) withObject:thumbbtn[i]  afterDelay:0.1];
					//				[self performSelector:@selector(loadScrollContent:) withObject:aButton afterDelay:intervalVal];
					//				intervalVal+=0.2;
				}
				if (i==0)
				{
                    prevVideoTag=-1;
					[self buttonClicked:thumbbtn[i]];
				}
				
				[vidname[i] release];
				//[thumbbtn[i] release];
				i++;
			}
		}
/*		else
		{
			for(int row = 0; row < [self.images count]; row++)
			{
				for (int col = 0; col<1;col++) // 10+col*253,126, 243, 149
				{
					
					//thumbbtn[i] = [[CustomButton alloc] initWithFrame:CGRectMake(5+col*105,10, 100, 80)];
					thumbbtn[i] = [[CustomButton alloc] initWithFrame:CGRectMake(5,5+row*72, 103,62)];
					
					UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"video_thumbnail_01" ofType:@"png"]];
					[thumbbtn[i] setImage:img forState:UIControlStateNormal];
					[img release];
					[thumbbtn[i] addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
					thumbbtn[i].tag=i+200;
					[scroll addSubview: thumbbtn[i]];
					vidname[i] = [[UILabel alloc]init];
					
					vidname[i].frame = CGRectMake(118,5+row*72, 192,62 );//5+col*105,90, 100, 30
					
					//vidname[i].backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"video_text_input.png"]];
					vidname[i].backgroundColor=[UIColor clearColor];
					vidname[i].textColor=[UIColor whiteColor];
					NSString *tempname = [self.titleName objectAtIndex:i];
					NSString *trimName= [tempname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
					
					NSLog(@"text manes : %@",self.titleName);
					[vidname[i] setText:trimName];
					
					vidname[i].numberOfLines = 0;
					vidname[i].font = [UIFont systemFontOfSize:10];
					vidname[i].adjustsFontSizeToFitWidth = YES;
					
					NSString *temp = [self.images objectAtIndex:i];
					NSString *trim= [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
					
					NSString *temp1 = [NSString stringWithFormat:@"%@/%@",serverIP,trim];
					thumbbtn[i].strThumUrl=temp1;
					[scroll addSubview: vidname[i]];
					if (i<3)
					{
						[self performSelector:@selector(loadImageFromURL:) withObject:thumbbtn[i]  afterDelay:0.1];
						//				[self performSelector:@selector(loadScrollContent:) withObject:aButton afterDelay:intervalVal];
						//				intervalVal+=0.2;
					}
					if (i==0)
					{
						[self buttonClicked:thumbbtn[i]];
					}
					
					[vidname[i] release];
					//[thumbbtn[i] release];
					i++;
				}
			}
			
		}
		
*/		
		
		//vidname[0].backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"video_text_input.png"]];
//		vidname[0].backgroundColor=[UIColor clearColor];
//		vidname[0].textColor=[UIColor whiteColor];
		NSLog(@"here video %@",self.videoz);
		if(self.videoz != nil)
		{
			if ([self.videoz count]>1)
			{
				NSString *temp = [self.videoz objectAtIndex:0];
				NSString *trim= [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				
				[self.videoz replaceObjectAtIndex:0 withObject:trim];
				NSString *vid = [self.videoz objectAtIndex:0];
				
				self.videoURL=vid;
				NSURL *test1 = [NSURL URLWithString:vid];
				NSURLRequest *test = [NSURLRequest requestWithURL:test1];
////				[appdelegate.videoview setScalesPageToFit:YES];
				
				//NSURL *test1 = [NSURL URLWithString:@"http://www.southparkstudios.com/full-episodes/s10e03-cartoon-wars-part-i"];
				//				NSURLRequest *test = [NSURLRequest requestWithURL:test1];
				//appdelegate.videoview.userInteractionEnabled==FALSE;
				[appdelegate.videoview loadRequest:test];
				
			}
		}
	}
	//[appdelegate.videoview release];
    NSLog(@"check");
	appdelegate.videoview=(UIWebView*)[self.view viewWithTag:3001];
	
	for (UIScrollView *scroll in [appdelegate.videoview subviews]) {
        //Set the zoom level.
        [scroll setZoomScale:2.5f animated:YES];
    }
}




-(void)buttonClicked:(id)sender
{
	UIButton *currentBtn = (UIButton*)sender;
	int btnTag = currentBtn.tag-200;
	
	appdelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSLog(@"all videoz%@",self.videoz);
	NSLog(@"tag %d",btnTag);
		for(int i=0;i<[self.videoz count];i++)
		{
			NSString *temp = [self.videoz objectAtIndex:i];
			NSString *trim= [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			[self.videoz replaceObjectAtIndex:i withObject:trim];
			
		}
NSLog(@"after trim");
   
	if(btnTag<[self.videoz count])
	{
		if (prevVideoTag==btnTag) 
        {
            return;
        }
        else
        {
            if (prevVideoTag!=-1) {
                [thumbbtn[prevVideoTag] setBackgroundColor:[UIColor blackColor]];
                [thumbbtn[prevVideoTag] setColorAtRect:CGRectMake(0, -(7.0/480)*screenHeight1, buttonwidth, (7.0/480)*screenHeight1) color:[UIColor clearColor]];
            }
            
        }
		prevVideoTag=btnTag;
        
        [thumbbtn[btnTag] setBackgroundColor:[UIColor blackColor]];
        [thumbbtn[btnTag] setColorAtRect:CGRectMake(0, -(7.0/480)*screenHeight1, buttonwidth, (7.0/480)*screenHeight1) color:[UIColor blueColor]];
  /*      
		for(int i=0; i<[self.videoz count];i++)
		{
			if(btnNos==i)
			{
				if(thumbbtn[btnTag].selected==NO)
				{
                    [thumbbtn[btnTag] setBackgroundColor:[UIColor blackColor]];
                    [thumbbtn[btnTag] setColorAtRect:CGRectMake(0, -(4.0/480)*screenHeight1, buttonwidth, (4.0/480)*screenHeight1) color:[UIColor blueColor]];
				}
			}
			else
			{
				[thumbbtn[i] setBackgroundColor:[UIColor blackColor]];
				[thumbbtn[btnTag] setColorAtRect:CGRectMake(0, -(4.0/480)*screenHeight1, buttonwidth, (4.0/480)*screenHeight1) color:[UIColor redColor]];
			}
		}
	*/			
		//<param name="allowfullscreen" value="true" />
         NSLog(@"prev %d",prevVideoTag);
		NSString *vid = [self.videoz objectAtIndex:btnTag];
		//NSString* embedHTML = @"\
//		<html><head>\
//		<style type=\"text/css\">\
//		body {\
//		background-color: transparent;\
//		color: white;\
//		onload = playvideo();\
//		}\
//		</style>\
//		</head><body style=\"margin:0\">\
//		<embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
//		width=\"%0.0f\" height=\"%0.0f\"></embed>\
//		</body></html>";
		self.videoURL=[vid stringByAppendingString:@"?autostart=1"];
	//	NSString* html = [NSString stringWithFormat:embedHTML, self.videoURL, appdelegate.videoview.frame.size.width, appdelegate.videoview.frame.size.height];
		// [appdelegate.videoview loadHTMLString:html baseURL:nil]; 
		//NSLog(@"Video URL==>%@",videoURL);
		NSURL *test1 = [NSURL URLWithString:vid];
		NSURLRequest *test = [NSURLRequest requestWithURL:test1];
		appdelegate.videoview.delegate = self;
		appdelegate.videoview.scalesPageToFit = NO;
//		appdelegate.videoview.autoresizingMask = NO;
		//[self dismissMoviePlayerViewControllerAnimated:YES];
		appdelegate.videoview.allowsInlineMediaPlayback=YES;
		appdelegate.videoview.mediaPlaybackRequiresUserAction=YES;
        
		[appdelegate.videoview loadRequest:test];
		if (isDisplayed==TRUE)
		{
			NSLog(@"Called in ButtonClick");
			[appdelegate.videoVC.view setHidden:FALSE];
			[appdelegate.window bringSubviewToFront:appdelegate.videoview];
		}
//		appdelegate.videoview.userInteractionEnabled==FALSE;
		//if(appdelegate.videoview.userInteractionEnabled == TRUE)
//		{
//			appdelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
//			[appdelegate.window bringSubviewToFront:appdelegate.videoVC.view];
//		}

	}
}
- (UIButton *)findButtonInView:(UIView *)view {
	UIButton *button = nil;
	
	if ([view isMemberOfClass:[UIButton class]]) {
		return (UIButton *)view;
	}
	
	if (view.subviews && [view.subviews count] > 0) {
		for (UIView *subview in view.subviews) {
			button = [self findButtonInView:subview];
			if (button) return button;
		}
	}
	
	return button;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"Came to load web.........");
    allowLandscape=TRUE;
////    appdelegate.tabBarController.isVideoPlaying=TRUE;
}
- (void)webViewDidFinishLoad:(UIWebView *)_webView {
	UIButton *b = [self findButtonInView:_webView];
	[b sendActionsForControlEvents:UIControlEventTouchUpInside];
    allowLandscape=FALSE;
     NSLog(@"Came Loading completed.............");
}

//- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
//	if (isDisplayed==TRUE)
//	{
//		if (appdelegate.videoview.userInteractionEnabled==TRUE)
//		{
//			NSLog(@"Called in webfinished");
//			appdelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
//			[appdelegate.videoview setHidden:FALSE];
//			[appdelegate.window bringSubviewToFront:appdelegate.videoview];
//		}			
//	}
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrolling
{
	int x= scroll.contentOffset.x;
	//NSLog(@"Scroll End decelerating %d,total count=%d",x);
	for(int i=0;i<[self.images count];i++)
	{
		CustomButton *btn= [scroll viewWithTag:200+i];
		int yCon=btn.frame.origin.x;
		if (yCon>=x-50 && yCon<=x+600)
		{
			NSLog(@"control %d top==%d",i,yCon);
			[self performSelector:@selector(loadImageFromURL:) withObject:btn  afterDelay:0.1];
			//			intervalVal+=0.2;
		}
	}	
}
-(BOOL) isNetConnected
{
	NSString *str =@"http://www.google.com";
	NSURL *url = [[NSURL alloc] initWithString:str];
	NSData *data1 = [[NSData alloc]initWithContentsOfURL:url];
    [url release];
	url=nil;
	if(data1==nil)
	{
		return FALSE;
	}
	else 
	{
        [data1 release];
        data1=nil;
		return TRUE;
	}
	
	
}

- (void)loadImageFromURL:(id)sender 
{
	[sender loadImage];
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData 
{
	//if (self.cancelPressed==YES)
//		return;
	if (data==nil) 
	{
		data = [[NSMutableData alloc] initWithCapacity:2048];
	}
	[data appendData:incrementalData];
}


- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection 
{

	UIImage *imgThumb;
	imgThumb = [UIImage imageWithData:data];
	
	if(buttonindex<[self.titleName count])
	{
		NSString *txt = [self.titleName objectAtIndex:buttonindex];
		vidname[buttonindex].text = txt;
			
	}
		
	[thumbbtn[buttonindex] setImage:imgThumb forState:UIControlStateNormal];
		
	[data release];
	data = nil;
		
	if(buttonindex<[self.images count])
	{
		buttonindex++;
		NSString *str = @"http://myzaah.com/maximdash/wizardworld/";
		NSString *urlPath = [self.images objectAtIndex:buttonindex];
		NSString *fullpath = [str stringByAppendingString:urlPath];
	
		[self loadImageFromURL:fullpath];
	}
	else 
	{
		return;
	}
	
	thumbbtn[0].highlighted = UIControlStateHighlighted;
	
	
	if(clicked==TRUE)
	{
		clicked=FALSE;
		if(thumbbtn[0].highlighted==YES)
		{
			
			[thumbbtn[0] setBackgroundColor:[UIColor darkGrayColor]];
			
		}
		else
		{
			[thumbbtn[0] setBackgroundColor:[UIColor whiteColor]];
		}
		
		appdelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
		
		NSString *temp = [self.videoz objectAtIndex:0];
		NSString *trim= [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		[self.videoz replaceObjectAtIndex:0 withObject:trim];
		NSString *vid = [self.videoz objectAtIndex:0];
		
		NSURL *test1 = [NSURL URLWithString:vid];
		NSURLRequest *test = [NSURLRequest requestWithURL:test1];
		
		[appdelegate.videoview loadRequest:test]; 
		
	}
	

}

-(void)firstVideo
{
    NSLog(@"first video");
	if ([self isNetConnected])
	{
		_isDataSourceAvailable=TRUE;
	}
	else {
		_isDataSourceAvailable=FALSE;
	}
	if (_isDataSourceAvailable==TRUE)
	{
		NSLog(@"Wifi connected");
		NSString *strUrlpath=[NSString stringWithFormat:@"%@/api/read?action=video&start=0&record=15",serverIP];
		NSURL *url = [[NSURL alloc] initWithString:strUrlpath];
		
		NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
		[url release];
		[xmlParser setDelegate:self];
		[xmlParser parse];
		[xmlParser release];
		xmlParser=nil;
		appdelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
		
		NSString *temp = [self.videoz objectAtIndex:0];
		NSString *trim= [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		[self.videoz replaceObjectAtIndex:0 withObject:trim];
		NSString *vid = [self.videoz objectAtIndex:0];
		
		NSURL *test1 = [NSURL URLWithString:vid];
		NSURLRequest *test = [NSURLRequest requestWithURL:test1];
		
		[appdelegate.videoview loadRequest:test]; 

	}
}


-(void) initXMLParser {
	//[super init];
	
	//return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"Response"]) {
		
		
		//self.titleName = [[NSMutableArray alloc] init];
			
	}
	else if([elementName isEqualToString:@"Title"]) {
		
	}
	
	else if([elementName isEqualToString:@"ThumbPath"]) {
		
	}
	else if([elementName isEqualToString:@"VideoPath"]) {
		
	}
	
	NSLog(@"Processing Element: %@", elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
	
	if(!currentElementVal) 
		currentElementVal = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementVal appendString:string];
	
	NSLog(@"Processing Value: %@", currentElementVal);
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	if([elementName isEqualToString:@"Response"])
		return;
	
	if([elementName isEqualToString:@"ThumbPath"]) {
		[self.images addObject:currentElementVal];
		
		
	}
	else if([elementName isEqualToString:@"Title"]) {
		[self.titleName addObject:currentElementVal];
		
	}
	if([elementName isEqualToString:@"VideoPath"]) {
		[self.videoz addObject:currentElementVal];
		
		
	}
		
	[currentElementVal release];
	currentElementVal = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    if (!allowLandscape) 
    {
        return ((interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) || (interfaceOrientation == UIInterfaceOrientationPortrait));
    }
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
//	[alert show];
//	[alert release];
	
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)actionSheetAction{
	
    
	/*UIActionSheet *aSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Tell a Friend",@"Tweet This",@"Facebook",@"Other Apps",nil];
	[aSheet showInView:self.view];
	[aSheet release];*/
    
    aSheet=[[UIActionSheet alloc]initWithTitle:nil 
                                      delegate:self 
                             cancelButtonTitle:@"Cancel" 
                        destructiveButtonTitle:nil 
                             otherButtonTitles:@"Tell a Friend",@"Tweet This",@"Facebook",@"Other Apps",@"",nil];
    
    [aSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    
    UIButton *notifc;
    if(appDelegate.screenWidth1 == 320)
        notifc  = [[UIButton alloc]initWithFrame:CGRectMake(45, 238, 140, 38)];
    else
    {
        notifc  = [[UIButton alloc]initWithFrame:CGRectMake(30, 200, 140, 38)];
    }
    
    [notifc setBackgroundColor:[UIColor clearColor]];
    [notifc setTitle:@"Notification" forState:UIControlStateNormal];
    [notifc setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [notifc setFont:[UIFont boldSystemFontOfSize:22]];
    [aSheet addSubview:notifc];
    
    if(appDelegate.screenWidth1 == 320)
        firstNotify = [[UISwitch alloc]initWithFrame:CGRectMake(182, 242, 137, 38)];
    else
    {
        firstNotify = [[UISwitch alloc]initWithFrame:CGRectMake(165, 205, 137, 38)];
    }
    
    [firstNotify addTarget:self action:@selector(SwitchOn:) forControlEvents:UIControlEventTouchUpInside];
    [firstNotify setTag:90];
    [firstNotify setOn:appDelegate.IsEnabledLinks];
    [aSheet addSubview:firstNotify];
    
    [aSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    
    if(appDelegate.screenWidth1 == 320)
        [aSheet setBounds:CGRectMake(0,0,320,380)];
    else    
    {
        [aSheet setFrame:CGRectMake(0,0,320,650)];
    }   

	
	
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	
	if(buttonIndex ==0)
	{
		[self emailact];
		
	}else if(buttonIndex ==1)
	{
		//Change For Twitter
		[self openTwitterPage];
		
		
	}
	else if(buttonIndex ==2)
	{
		[self facebtnact];
		
	}
	else if(buttonIndex ==3)
	{
		
		[[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"http://itunes.apple.com/us/artist/alpha-media-group-inc./id393395810"]];
	}
	
}

-(void)SwitchOn:(id)sender
{
	NSLog(@"switchOn...");
	UISwitch *Swt_HighightL = (UISwitch *)[aSheet viewWithTag:90];
	if(Swt_HighightL!=nil)
	{
		if(Swt_HighightL.tag == 90)
		{
			
			if(Swt_HighightL.on)
			{
                appDelegate.ISPushNotification = YES;
				appDelegate.IsEnabledLinks = YES;
				appDelegate.isSwitch=appDelegate.IsEnabledLinks;
				
				[appDelegate.prefs setBool:YES forKey:@"IsEnabledLinks"];
                [appDelegate.prefs setBool:YES forKey:@"ISPushNotification"];
				[appDelegate.prefs synchronize];
				
			}
			else 
			{
				appDelegate.ISPushNotification = NO;
				appDelegate.IsEnabledLinks = NO;
				appDelegate.isSwitch=appDelegate.IsEnabledLinks;
				
				[appDelegate.prefs setBool:NO forKey:@"IsEnabledLinks"];
                [appDelegate.prefs setBool:NO forKey:@"ISPushNotification"];
				[appDelegate.prefs synchronize];
			}
		}
	}
}


-(IBAction)emailact{
	
	MFMailComposeViewController *controller= [[MFMailComposeViewController alloc] init];
	
	
	controller.mailComposeDelegate = self;
	
    [controller setSubject:@"I hooked up my phone with the GraffitiSprayCan Dash App. Check it."];	
	//	UIImage *roboPic = [self getphotofrompaint];//[UIImage imageWithContentsOfFile:dataFilePath];
	//	NSData *imageData = UIImagePNGRepresentation(roboPic);
	// 	[controller addAttachmentData:imageData mimeType:@"image/png" fileName:@"concreteImmortalz.png"];
	NSString *emailBody = @"http://itunes.apple.com/us/artist/alpha-media-group-inc./id393395810";
	[controller setMessageBody:emailBody isHTML:NO]; 
	//UIImage  *img  = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Fol3Image2" ofType:@"jpg"]];
	//NSData *dataObj = UIImageJPEGRepresentation(img, 1.0);
	
	
	//[controller addAttachmentData:dataObj mimeType:@"image/jpg" fileName:@"HDWallpaper"];
	
	if(controller!=nil){
        [self presentModalViewController:(UIViewController*)controller animated:YES];
	}
    //[img release];
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
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
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
    [topBar removeFromSuperview];
	
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
    [topBar removeFromSuperview];
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	NSLog(@"Request %@ succeeded", requestIdentifier);
	UIAlertView *status=[[UIAlertView alloc]initWithTitle:@"Tweet posted successfully" 
												  message:nil 
												 delegate:self 
										cancelButtonTitle:@"OK" 
										otherButtonTitles:nil];
	[status show];
	[status release];
	[self dismissModalViewControllerAnimated:YES];
    [topBar removeFromSuperview];
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
    [topBar removeFromSuperview];
}



//=============================================================================================================================
#pragma mark ViewController Stuff

-(void)openTwitterPage
{
    //	[self.navigationController.navigationBar setHidden:NO];
	TwitterOpened = YES;
    //	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Post", @selector(twitteract));
    //	self.navigationItem.leftBarButtonItem = BARBUTTON(@"Back", @selector(action:));
    
    
    
    ////	self.title=@"Tweet This";
	
	twitterView = [[UIView alloc]initWithFrame:CGRectMake(0,0, screenWidth1, screenHeight1)];
	UIImage  *img  = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Twitter" ofType:@"jpg"]];
	UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, screenWidth1, screenHeight1)];
	imageView.image = img;
	
	
	twitterTextField = [[UITextView alloc] initWithFrame:CGRectMake(10,100, screenWidth1-20, 200)];
	
    twitterTextField.textColor = [UIColor blackColor];
	
    twitterTextField.font = [UIFont fontWithName:@"Arial" size:18];
	
    twitterTextField.delegate = self;
	
    twitterTextField.backgroundColor = [UIColor whiteColor];
	twitterTextField.text =@"I hooked up my phone with the GraffitiSprayCan Dash App. Check it.http://itunes.com/apps/zaahtechnologiesinc";
	//  twitterTextField.placeholder = @"Enter Text To Tweet";
	
	//   twitterTextField.returnKeyType = UIReturnKeyDefault;
	
	// twitterTextField.keyboardType = UIKeyboardTypeDefault; 
	
    twitterTextField.scrollEnabled = YES;
	
    twitterTextField.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	
	
	
	[twitterView addSubview:imageView];
	
	
	[twitterView addSubview:twitterTextField];
	
	[self.view addSubview:twitterView];
	[img release];
	[imageView release];
	
	//[twitterTextField release];
	
	//[twitterView release];
	[self.view addSubview:topBar];
	
}



-(IBAction)twitteract {
	if (![appDelegate isDataSourceAvailable])
	{
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:@"Network Connection Error" 
							  message:@"You need to be connected to the internet to use this feature." 
							  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		alert.delegate=self;
		[alert show];
		[alert release];
	}
	else{
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
        
        TwitterOpened = NO;
        ////	topLabel.text= @"Categories";
        //self.title = @"Categories";
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
	[self.navigationController.navigationBar setHidden:YES];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"]) {
		
		[textView resignFirstResponder];
		
	}
    return YES;
	
}

-(void)action:(id)sender{
    
	if(TwitterOpened ==YES)
	{
        [topBar removeFromSuperview];
        //    [self.navigationController.navigationBar setHidden:YES];
		TwitterOpened =NO;
        ////		topLabel.text= @"Categories";
		//self.title = @"Categories";
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
		[btn addTarget:self action:@selector(actionSheetAction) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = nil;
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
	
}

-(IBAction)facebtnact
{
	
	_permissions =  [[NSArray arrayWithObjects: @"read_stream",@"user_photos",@"user_videos",@"publish_stream ",nil] retain];
	_facebook = [[Facebook alloc] init];
	
	if(appDelegate.facebookLogin == TRUE)
	{
		appDelegate.facebookLogin = FALSE;
		[_facebook logout:self];
	}
	[_facebook authorize:kAppId permissions:_permissions delegate:self];
	
}


-(void) fbDidLogin 
{
	NSLog(@"did  login");
	
	
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

- (void) publishStream{
	
	SBJSON *jsonWriter = [[SBJSON new] autorelease];
	
	NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys: 
														   @"Always Running",@"text",@"http://itsti.me/",@"href", nil], nil];
    
    NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *strLink = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Itunes_Link"]];
	
	NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
	NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
								@"I hooked up my phone with the GraffitiSprayCan Dash App. Check it. ", @"name",strLink,@"caption",nil];//@"http://itunes.com/elitegudz/",@"href", nil];
	NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   kAppId, @"api_key",
								   @"Share on Facebook",@"user_message_prompt",
								   
								   attachmentStr, @"attachment",
								   nil];	    
	
	
	[_facebook dialog: @"stream.publish"
			andParams: params
		  andDelegate:self];
	
}

- (void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"did not login");
	
	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Unable To Login" 
											  message:nil 
											 delegate:self 
									cancelButtonTitle:@"OK" 
									otherButtonTitles:nil];
	[fb show];
	[fb release];
}

/**
 * Callback for facebook logout
 */ 
-(void) fbDidLogout {
	
	//	[_facebook release];
	
	
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Callback when a request receives Response
 */ 
- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response{
	
	NSLog(@"received response  %@",response );
	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Success" 
											  message:@"Your Image Posted" 
											 delegate:self 
									cancelButtonTitle:@"OK" 
									otherButtonTitles:nil];
	[fb show];
	[fb release];
	
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest*)request didFailWithError:(NSError*)error{
	NSLog(@"%@",error);
	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Unable To Connect" 
											  message:nil 
											 delegate:self 
									cancelButtonTitle:@"OK" 
									otherButtonTitles:nil];
	[fb show];
	[fb release];
	
	
}

/**
 * Called when a request returns and its response has been parsed into an object.
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on thee format of the API response.
 */
- (void)request:(FBRequest*)request didLoad:(id)result {
	
	
	
	NSLog(@"result is ---- %d",result );
	[_facebook logout:self];
	
	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Logged Out" 
											  message:nil 
											 delegate:self 
									cancelButtonTitle:@"OK" 
									otherButtonTitles:nil];
	[fb show];
	[fb release];
}





///////////////////////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/** 
 * Called when a UIServer Dialog successfully return
 */
- (void)dialogDidComplete:(FBDialog*)dialog withPost:(NSString *)currentPostID{
	NSLog(@"feed to delete and %@ rrrr ", currentPostID);
	//[_facebook logout:self];
	
	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Message posted successfully" 
											  message:nil 
											 delegate:self 
									cancelButtonTitle:@"OK" 
									otherButtonTitles:nil];
	[fb show];
	[fb release];
}



- (void)dealloc {
	
	[images release];
	[titleName release];
	[videoz release];
	[connection release];
	[data release];
    [super dealloc];
}


@end
