//
//  mmsvViewController.m
//  maximSocialVideo
//
//  Created by neo on 28/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "mmsvViewController.h"
#import "epubstore_svcAppDelegate.h"
#import "facebookdetailtable.h"
#import "contributeViewController.h"

//static NSString *kAppId=@"247740738612415";
//#define kOAuthConsumerKey @"TT6Z5hPUoIms4v8rkhapag";
//#define kOAuthConsumerSecret @"TBKuAHe2NLYlnleVX64Zko5CQ8NeoDgGmr3GagGe3M";
@implementation mmsvViewController

epubstore_svcAppDelegate *appDelegate;
facebookdetailtable *fbTable;
//@synthesize session = _session;
@synthesize loginDialog = _loginDialog;
@synthesize facebookName = _facebookName;
@synthesize posting = _posting,friendsUid;

@synthesize curSW, curSH;
@synthesize _mediadetails, _userVL, _mediaPost;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
    
//    if (appDelegate.onFirstLoad) {
//        [self redirectToLogin];
//    }
    loginDefaults = [NSUserDefaults standardUserDefaults];

    NSLog(@"login = %@",[loginDefaults valueForKey:@"login"]);
    if ([[loginDefaults valueForKey:@"login"] isEqualToString:@"1"]) {
        boolLoading = 1;
        [self redirectToLogin];
    }
    
    //[appDelegate.window bringSubviewToFront:button];
    
    
    rankDefaults = [NSUserDefaults standardUserDefaults];
    
    
    _avloader  = [[avloader alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height+20)]; 
    _avloader.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
    [self.view addSubview:_avloader];
    [self.view bringSubviewToFront:_avloader];
    [_avloader initLoaderWithSize:CGSizeMake(100, 100)];
    
    
    [self performSelectorInBackground:@selector(enableLoader) withObject:self];
    
    currentPage = 1;
   
    curSW = [[UIScreen mainScreen] bounds].size.width;
    curSH = [[UIScreen mainScreen] bounds].size.height;
        
	appDelegate.myarray=[[NSMutableArray alloc]init];
   
    vl_MainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height-20)];
    vl_MainView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:vl_MainView];
    
    
    backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height+20)];
    
    backgroundImageView.image = [UIImage imageNamed:@"bg_1_blue.png"];
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self 
               action:@selector(aMethod:)
     forControlEvents:UIControlEventTouchUpInside];
    button.tag = 200+1;
    UIImage *CloseImg = [UIImage imageNamed:@"icon_close.png"];
    [button setImage:CloseImg forState:UIControlStateNormal];
    button.frame = CGRectMake(295.0, 27.0, 20.0, 20.0);
    [self.view addSubview:button];
    [self.view bringSubviewToFront:button];
    
    [self setTabbuttons];
    
    [self setAddBanners];
    
    NSLog(@"ap delegate = %d",appDelegate.redirectToRoot);
    
    if (appDelegate.redirectToRoot==0)
    {
        [self setbotomTab];
    }
    else
    {
        appDelegate.redirectToRoot = false;
        [self bottomTabLogout];
    }
    
    _avloader.hidden = YES;
    
    [appDelegate fetchVideoListing:@"media.video-list-feature" uid:@"" setCurrentPage:currentPage];
    
    [self buildVideos:0 setPage:0];
    
}

-(void)aMethod:(id)sender
{
    [self.view removeFromSuperview];
    self.tabBarController.selectedIndex = 0;
    [self showTabBar:self.tabBarController]; 
    [appDelegate.tabCoverView setHidden:NO];
    
//    UIButton *sender = (UIButton *)[appDelegate.tabCoverView viewWithTag:1000];
//    sender.tag = 200+1;
    NSLog(@"%d",[sender tag]);
    
    UIButton *buttag = (UIButton *)sender;
    
    NSLog(@"tag = %d",[buttag tag]);
    
    [appDelegate LoadView];
}

- (void) showTabBar:(UITabBarController *) tabbarcontroller {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
            
        } 
        else 
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
        }
        
        
    }
    
    [UIView commitAnimations]; 
}

-(void)LoadIcon

{
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(110, 190, 100, 100)];
	[loadingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]];
	//Enable maskstobound so that corner radius would work.
	[loadingView.layer setMasksToBounds:YES];
	//Set the corner radius
	[loadingView.layer setCornerRadius:10.0];    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[activityView setFrame:CGRectMake((100-20)/2, (100-20)/2, 20, 20)];
	[activityView setHidesWhenStopped:YES];
	[activityView startAnimating];
    //    [loadingView setAlpha:0.5];
	[loadingView addSubview:activityView];
    [self.view addSubview:loadingView];
	[activityView release];
}
-(void)fetchUserDetail
{
    
    NSString *urlString =[NSString stringWithFormat:@"%@media/list",ServerIp];
    
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
    [request setURL:[NSURL URLWithString:urlString]];
    
    NSLog(@"urlString----%@",urlString);
    
	
    NSString *myParameters = [NSString stringWithFormat:@"method=user.profile&user_id=%@&req_userid=%@",appDelegate.userID,appDelegate.userID];
    
    NSLog(@"myParameters -- %@",myParameters);
    
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    // now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"fetchVideoDetails ---- %@",returnString);
    
    
    if (returnString) 
    {
        
        //userFLname = [[NSString alloc] init];
        
        if (appDelegate.userID!=NULL)
        {
        
        userArray = [[NSMutableArray alloc] init];
        
        userImage     = [self GetValueInXML:returnString SearchStr:@"thumb"];
        
        //userFLname    = [NSString stringWithFormat:@"%@ %@",[self GetValueInXML:returnString SearchStr:@"fname"], [self GetValueInXML:returnString SearchStr:@"lname"] ];
        
        [userArray addObject:[NSString stringWithFormat:@"%@ %@",[self GetValueInXML:returnString SearchStr:@"fname"], [self GetValueInXML:returnString SearchStr:@"lname"]]];
        NSLog(@"user name = %@",[userArray objectAtIndex:0]);
        }
    }
    
    
    [returnString release];
    
}

-(NSString *) GetValueInXML:(NSString *)xmlString SearchStr:(NSString *)SearchStr
{
    NSString *str2;
    NSArray *arr=[xmlString componentsSeparatedByString:[NSString stringWithFormat:@"<%@>",SearchStr]];
    if ([arr count]>0)
    {
        NSString *str1=[arr objectAtIndex:1];
        NSArray *arr1=[str1 componentsSeparatedByString:[NSString stringWithFormat:@"</%@>",SearchStr]];
        if ([arr1 count]>0)
        {
            str2=[arr1 objectAtIndex:0];
            
        }
    }	
    return str2;
}
-(void)setbotomTab
{
    
    int shareX,shareY,shareW,shareH;
    UIImage *tempImage;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        shareX = 121;
        shareY = 0;
        shareW = 86;
        shareH = 50;
        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"share_line_iphone" ofType:@"png"]];
        
        
    }
    else
    {
        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"share_line_iphone" ofType:@"png"]];
        
        shareX = 342;
        shareY = 0;
        shareW = 85;
        shareH = 50;
        
    }
    
    
    vl_bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-20, self.view.frame.size.width , 50)];
    vl_bottomView.backgroundColor = [UIColor blackColor];
    
    
    [self.view addSubview:vl_bottomView];
    [self.view bringSubviewToFront:vl_bottomView];
    
   // appDelegate.loginBool = 1;
    btnLogin  = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLogin.frame = CGRectMake(10,10,35,18);
    [btnLogin setImage:[UIImage imageNamed:@"img_login.png"] forState:UIControlStateNormal];
    btnLogin.backgroundColor = [UIColor clearColor];
    
    [btnLogin addTarget:self action:@selector(redirectToLogin) forControlEvents:UIControlEventTouchUpInside];    
    [vl_bottomView addSubview:btnLogin];
    [vl_bottomView bringSubviewToFront:btnLogin];
    
    
    btnCamera  = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCamera.frame = CGRectMake((320-30)/2,7,30,24);
    [btnCamera setImage:[UIImage imageNamed:@"ing_startRecord_iphone.png"] forState:UIControlStateNormal];
    btnCamera.backgroundColor = [UIColor clearColor];
    
    [btnCamera addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];    
    [vl_bottomView addSubview:btnCamera];
    [vl_bottomView bringSubviewToFront:btnCamera];
    
    
    lblRank = [[UILabel alloc]initWithFrame:CGRectMake(245, 6, 50, 30)];
    lblRank.text = @"RANK";
    lblRank.font = [UIFont boldSystemFontOfSize:14.0];
    lblRank.textColor = [UIColor colorWithRed:0/255.0 green:181/255.0 blue:220/255.0 alpha:1];
    lblRank.backgroundColor = [UIColor clearColor];
    [vl_bottomView addSubview:lblRank];
    
    lblRankText = [[UILabel alloc]initWithFrame:CGRectMake(290, 13, 25, 15)];
    
    NSLog(@"rank = %@",[rankDefaults valueForKey:@"rank"]);
    
    lblRankText.text = [rankDefaults valueForKey:@"rank"];
    lblRankText.font = [UIFont boldSystemFontOfSize:13.0];

    lblRankText.textColor = [UIColor colorWithRed:0/255.0 green:181/255.0 blue:220/255.0 alpha:1];
    lblRankText.textAlignment = UITextAlignmentCenter;
    lblRankText.backgroundColor = [UIColor whiteColor];
    [vl_bottomView addSubview:lblRankText];
    
    [vl_bottomView release];
    
    
}

-(void)openCamera
{

    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Take Video", @"Take Photo",@"Take Video From Library",@"Take Photo From Library" ,@"Cancel",nil];
    actionSheet.actionSheetStyle =UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    [actionSheet release];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    	    if (buttonIndex == 0) 
            {
                NSLog(@"video");
                
                [self presentVideoMode];

                
       	    } 
            else if (buttonIndex==1)
            {
                NSLog(@"photo");
                [self presentPhotoMode];

            }
            else if (buttonIndex==2)
            {
                [self presentVideoLibrary];
            }
            else if (buttonIndex==3)
            {
                [self presentPhotoLibrary];
            }
    
            else if (buttonIndex==4)
            {
                
            }
    
}
-(void)presentPhotoMode
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
	{
        
		        // Create image picker controller
        imagePickerController = [[UIImagePickerController alloc] init];
        
        // Set source to the camera
        imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
        
        // Delegate is self
        imagePickerController.delegate = self;
        
        // Allow editing of image ?
        imagePickerController.allowsImageEditing = NO;
        
        // Show image picker
        [self presentModalViewController:imagePickerController animated:YES];
    }
}

-(void)bottomTabLogout
{
    int shareX,shareY,shareW,shareH;
    UIImage *tempImage;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        shareX = 121;
        shareY = 0;
        shareW = 86;
        shareH = 50;
        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"share_line_iphone" ofType:@"png"]];
        
        
    }
    else
    {
        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"share_line_iphone" ofType:@"png"]];
        
        shareX = 342;
        shareY = 0;
        shareW = 85;
        shareH = 50;
        
    }
    
    
    vl_bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width , 50)];
    vl_bottomView.backgroundColor = [UIColor blackColor];
    
    
    [self.view addSubview:vl_bottomView];
    [self.view bringSubviewToFront:vl_bottomView];
    
   // appDelegate.loginBool = 1;
    btnLogin  = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLogin.frame = CGRectMake(10,10,35,18);
    [btnLogin setImage:[UIImage imageNamed:@"img_login.png"] forState:UIControlStateNormal];
    btnLogin.backgroundColor = [UIColor clearColor];
    
    [btnLogin addTarget:self action:@selector(redirectToLogin) forControlEvents:UIControlEventTouchUpInside];    
    [vl_bottomView addSubview:btnLogin];
    [vl_bottomView bringSubviewToFront:btnLogin];
    
    lblRank = [[UILabel alloc]initWithFrame:CGRectMake(245, 10, 50, 30)];
    lblRank.text = @"RANK";
    lblRank.font = [UIFont boldSystemFontOfSize:14.0];
    lblRank.textColor = [UIColor colorWithRed:0/255.0 green:181/255.0 blue:220/255.0 alpha:1];
    lblRank.backgroundColor = [UIColor clearColor];
    [vl_bottomView addSubview:lblRank];
    
    lblRankText = [[UILabel alloc]initWithFrame:CGRectMake(290, 17, 25, 15)];
    lblRankText.text = [rankDefaults valueForKey:@"rank"];
    lblRankText.font = [UIFont boldSystemFontOfSize:13.0];
    
    lblRankText.textColor = [UIColor colorWithRed:0/255.0 green:181/255.0 blue:220/255.0 alpha:1];
    lblRankText.textAlignment = UITextAlignmentCenter;
    lblRankText.backgroundColor = [UIColor whiteColor];
    [vl_bottomView addSubview:lblRankText];
    
    [vl_bottomView release];

}

-(void)selectedShare
{
    if (appDelegate.reachability==FALSE)
    {
        UIAlertView *alertLogout = [[UIAlertView alloc] init];
        [alertLogout setTitle:@"No network connection"];
        //[alertLogout setMessage:@"No network found"];
        [alertLogout setDelegate:self];
        [alertLogout addButtonWithTitle:@"OK"];
        alertLogout.tag = 1003; 
        
        [alertLogout show];
        [alertLogout release];
        return;
        
    }
  
     if (appDelegate.userID) 
    {
        
       /* if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            _mediaPost = [[mediaPost alloc] initWithNibName:@"mmsvViewController_iPhone" bundle:nil];
            
        }
        else
        {
            _mediaPost = [[mediaPost alloc] initWithNibName:@"mmsvViewController_iPad" bundle:nil];
        }
        
        //_mediaPost._delegate = self;
        [_mediaPost initMediaPost];
        [self presentModalViewController:_mediaPost animated:YES];
        */
        
        [self presentVideoMode];
        
        
    }
     else
    {
    
        UIAlertView *alertLogout = [[UIAlertView alloc] init];
        [alertLogout setTitle:@"Record Content"];
        [alertLogout setMessage:@"Please log-in to record and share with the world"];
        [alertLogout setDelegate:self];
        [alertLogout addButtonWithTitle:@"OK"];
        alertLogout.tag = 1001; 
        [alertLogout addButtonWithTitle:@"Cancel"];
        [alertLogout show];
        [alertLogout release];
    
    
    } 

}



-(void)presentVideoMode
{
    
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
	{
        
		videoCaptureFlag = 0;
        
        imagePickerController = [[UIImagePickerController alloc] init];
		imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
		imagePickerController.allowsEditing = YES;
        imagePickerController.showsCameraControls = NO;
        
		imagePickerController.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];//[NSArray arrayWithObject:(NSString *)kUTTypeMovie];
        
        
        imagePickerController.delegate = self;
		[self presentModalViewController:imagePickerController animated:YES];
        
        
        
        UIImage *tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"img_flipCamera_iphone" ofType:@"png"]];
        
        
        btnFlipCam=[UIButton buttonWithType:UIButtonTypeCustom];
        btnFlipCam.frame = CGRectMake(255, 5, 60, 55);
        [btnFlipCam setImage:tempImage forState:UIControlStateNormal];
        [btnFlipCam addTarget:self action:@selector(flipCamera) forControlEvents:UIControlEventTouchUpInside];
        [imagePickerController.view  addSubview:btnFlipCam];
        [tempImage release];
        
        
        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"img_cancelRecord_iphone" ofType:@"png"]];
        btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
        btnCancel.frame = CGRectMake(8, 440, 30, 27);
        [btnCancel setImage:tempImage forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(dismissCamera) forControlEvents:UIControlEventTouchUpInside];
        [imagePickerController.view  addSubview:btnCancel];
        //btnCancel.userInteractionEnabled=NO;
        [tempImage release];
        
        
        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ing_startRecord_iphone" ofType:@"png"]];
        btnStartRecord=[UIButton buttonWithType:UIButtonTypeCustom];
        btnStartRecord.frame = CGRectMake(145, 440, 30, 24);
        [btnStartRecord setImage:tempImage forState:UIControlStateNormal];
        [btnStartRecord addTarget:self action:@selector(startVideoRecording) forControlEvents:UIControlEventTouchUpInside];
        //btnStartRecord.userInteractionEnabled=NO;
        [imagePickerController.view  addSubview:btnStartRecord];
        [tempImage release];
        
        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ing_stopRecord_iphone" ofType:@"png"]];
        btnStopRecord=[UIButton buttonWithType:UIButtonTypeCustom];
        btnStopRecord.frame = CGRectMake(145, 440, 30, 24);
        [btnStopRecord setImage:tempImage forState:UIControlStateNormal];
        [btnStopRecord addTarget:self action:@selector(StopVideoRecording) forControlEvents:UIControlEventTouchUpInside];
        btnStopRecord.hidden = YES;
        [imagePickerController.view  addSubview:btnStopRecord];
        [tempImage release];
        
        
        
        
        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"img_library_iphone" ofType:@"png"]];
        
        
        btnLibrary=[UIButton buttonWithType:UIButtonTypeCustom];
        btnLibrary.frame = CGRectMake(265, 430, 60, 45);
        [btnLibrary setImage:tempImage forState:UIControlStateNormal];
        [btnLibrary addTarget:self action:@selector(goToLibrary) forControlEvents:UIControlEventTouchUpInside];
       // btnLibrary.userInteractionEnabled=NO;
        [imagePickerController.view  addSubview:btnLibrary];
        
        
        [tempImage release];
        
	}
    else
    {
        [self performSelector:@selector(goToLibrary1) withObject:nil afterDelay:0.5];
    }
    
    
    
//    btnCancel.userInteractionEnabled        =   YES;
//    btnStartRecord.userInteractionEnabled   =   YES;
//    btnLibrary.userInteractionEnabled       =   YES;
    
    
}

-(void)presentVideoLibrary
{
    
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
	{
        
        videoCaptureFlag = 1;

        
        imagePickerController = [[UIImagePickerController alloc] init];
		imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		imagePickerController.allowsEditing = YES;
        //imagePickerController.showsCameraControls = NO;
        
		imagePickerController.mediaTypes =  [NSArray arrayWithObjects: (NSString *) kUTTypeMovie, nil];//[NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    
        
        
        imagePickerController.delegate = self;
		[self presentModalViewController:imagePickerController animated:YES];
        
        
        
   
	}
    else
    {
        [self performSelector:@selector(goToLibrary1) withObject:nil afterDelay:0.5];
    }
    
    
    
//    btnCancel.userInteractionEnabled        =   YES;
//    btnStartRecord.userInteractionEnabled   =   YES;
//    btnLibrary.userInteractionEnabled       =   YES;
    
    
}

-(void)presentPhotoLibrary
{
    
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
	{
        
		
        
        imagePickerController = [[UIImagePickerController alloc] init];
		imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		imagePickerController.allowsEditing = YES;
        //imagePickerController.showsCameraControls = NO;
        
		imagePickerController.mediaTypes =  [NSArray arrayWithObjects: (NSString *) kUTTypeImage, nil];//[NSArray arrayWithObject:(NSString *)kUTTypeMovie];
        
        
        
        imagePickerController.delegate = self;
		[self presentModalViewController:imagePickerController animated:YES];
        
        
        
        
	}
    else
    {
        [self performSelector:@selector(goToLibrary1) withObject:nil afterDelay:0.5];
    }
    
    
    
//    btnCancel.userInteractionEnabled        =   YES;
//    btnStartRecord.userInteractionEnabled   =   YES;
//    btnLibrary.userInteractionEnabled       =   YES;
    
    
}


-(void)dismissCamera
{
        
    [imagePickerController dismissModalViewControllerAnimated:YES];
    
    if (imagePickerController!=nil) {
        [imagePickerController release];
        imagePickerController = nil;
    }
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [imagePickerController dismissModalViewControllerAnimated:NO];
    //[self performSelector:@selector(backtoHome) withObject:nil afterDelay:0.5];
}

- (void)imagePickerController: (UIImagePickerController *)picker2 didFinishPickingMediaWithInfo: (NSDictionary *)info 
{
    
  //  UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];

   // orientationStr1 = [[NSString stringWithFormat:@"%d",orientation] retain];
    
    redirectToPost = TRUE;
    [picker2 dismissModalViewControllerAnimated:NO];
	NSString *mediaType = [info valueForKey:UIImagePickerControllerMediaType];
	if([mediaType isEqualToString:@"public.movie"])
	{
		NSLog(@"came to video select...");
		
		appDelegate.postVideoUrl =(NSURL*)[info objectForKey:@"UIImagePickerControllerMediaURL"];
        
        NSLog(@"appDelegate.postVideoUrl--- %@", appDelegate.postVideoUrl);
        
    
        if (videoCaptureFlag==1)
        {
            appDelegate.captureOrientation = 3;
        }
        
       [self performSelector:@selector(postMediaWithDelay) withObject:nil afterDelay:0.5];
		
	}
	else if([mediaType isEqualToString:@"public.image"])
	{
        UIImage *capture = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        int imageOrientation = capture.imageOrientation;
        
        
        if (imageOrientation==3)
        {
            imageOrientation = 1;
        }
        else if (imageOrientation==0)
        {
            imageOrientation = 3;
        }
        else if (imageOrientation==1)
        {
            imageOrientation = 4;
        }

        imageDict = [[NSMutableDictionary alloc] init];
        
        [imageDict setObject:capture forKey:@"0"];
        
        NSLog(@"outputImage = %@",[info objectForKey:@"UIImagePickerControllerOriginalImage"]);
        
        [self performSelector:@selector(postPhotoWithDelay:) withObject:[NSString stringWithFormat:@"%d",imageOrientation] afterDelay:0.5];

    
    }
    
}
-(void)postPhotoWithDelay:(NSString*)orientationStr1
{
    contributeViewController *contributeView = [[contributeViewController alloc] initWithNibName:@"contributeViewController" bundle:nil];
    contributeView.strType = @"photo";
    contributeView.userName = [userArray objectAtIndex:0];
    contributeView.pageUserId = appDelegate.userID;
    contributeView.imageDict = imageDict;
    NSLog(@"orientation str= %@",orientationStr1);
    contributeView.orientationStr = orientationStr1;
    [self presentModalViewController:contributeView animated:NO];
                   
    [contributeView release];
}

-(void)postMediaWithDelay
{


    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        _mediaPost = [[mediaPost alloc] initWithNibName:@"mmsvViewController_iPhone" bundle:nil];
        
    }
    else
    {
        _mediaPost = [[mediaPost alloc] initWithNibName:@"mmsvViewController_iPad" bundle:nil];
    }
    
    [_mediaPost initMediaPost];
    
    [self presentModalViewController:_mediaPost animated:NO];
}

-(void)flipCamera
{
    
    imagePickerController.cameraDevice = (imagePickerController.cameraDevice == UIImagePickerControllerCameraDeviceFront) ? UIImagePickerControllerCameraDeviceRear : UIImagePickerControllerCameraDeviceFront;
    
    
    
}

-(void)startVideoRecording
{
    UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
    appDelegate.captureOrientation = orientation;
    NSLog(@"%d---------%d"  , appDelegate.captureOrientation , orientation );
    

    btnStartRecord.hidden   =   YES;
    btnStopRecord.hidden    =   NO;
    btnLibrary.hidden       =   YES;
    btnFlipCam.hidden       =   YES;
    
     NSLog(@"%d---------%d"  , appDelegate.captureOrientation , appDelegate.orientation);
    
    [imagePickerController startVideoCapture];
}


-(void)StopVideoRecording
{
    
    btnStartRecord.hidden = NO;
    btnStopRecord.hidden = YES;
    btnFlipCam.hidden    =   NO;
    [imagePickerController stopVideoCapture];
    
}



-(void)goToLibrary
{
    redirectToPost = TRUE;
    
    [imagePickerController dismissModalViewControllerAnimated:YES];
    
    [imagePickerController release];
    
    imagePickerController   =   nil;
    
   
    
    [self performSelector:@selector(goToLibrary1) withObject:nil afterDelay:0.5];
    
}

-(void)goToLibrary1
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) 
	{
        imagePickerController = [[UIImagePickerController alloc] init];
		imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
		imagePickerController.allowsEditing = YES;
		imagePickerController.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];//[NSArray arrayWithObject:(NSString *)kUTTypeMovie];
        imagePickerController.delegate = self;
		[self presentModalViewController:imagePickerController animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
		[imagePickerController release];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if([alertView tag]==1001)
    {
        if (buttonIndex == 0)
        {
            [self performSelector:@selector(redirectToLogin) withObject:nil afterDelay:0.5];
            
        }
        else if (buttonIndex == 1)
        {
            //[self performSelector:@selector(presentVideoMode) withObject:nil afterDelay:0.5];
            //[self presentVideoMode];
        }
    }
}

-(void)redirectToLogin
{
    
    //if (appDelegate.reachability==FALSE)
    // if ([appDelegate checkWifi:YES])
    {   
        //self.view.userInteractionEnabled = NO;
        _login = [[login alloc] init];
        
        _login._delegate = self;
        
//        _avloader  = [[avloader alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height+20)]; 
//        _avloader.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
//        [self.view addSubview:_avloader];
//        [self.view bringSubviewToFront:_avloader];
//        [_avloader initLoaderWithSize:CGSizeMake(100, 100)];
        
        
      //  [self performSelectorInBackground:@selector(enableLoader) withObject:nil];
        [self performSelector:@selector(adjustScreen) withObject:nil afterDelay:0.5];
        
        
        [_login facebtnact];
        
        appDelegate.onFirstLoad = FALSE;
        
        
    } 
//    else
//    {
//        
//        UIAlertView *alertLogout = [[UIAlertView alloc] init];
//        [alertLogout setTitle:@"Message"];
//        [alertLogout setMessage:@"No network connection"];
//        [alertLogout setDelegate:self];
//        [alertLogout addButtonWithTitle:@"OK"];
//        alertLogout.tag = 1002; 
//        
//        [alertLogout show];
//        [alertLogout release];
//        
//        
//        return;
//
//    }
    
    
    
    //[self performSelector:@selector(setHiddenActivity) withObject:nil afterDelay:2.0];
   
//    else
//    {
//        [self performSelector:@selector(setHiddenActivity) withObject:nil afterDelay:2.0];
//    }
        
}

-(void)fbLogedIn
{
    [self performSelectorInBackground:@selector(enableLoader) withObject:nil];
    boolLoading = 0;

    [loginDefaults setObject:@"1" forKey:@"login"];
    
    [loginDefaults synchronize];
   
    btnLogin.hidden = YES;
    btnSignIn.hidden = YES;
    btnLogedUser.hidden = NO;
    appDelegate.loginFlag = FALSE;
    //_avloader.hidden  = YES;
    
//    _avloader  = [[avloader alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height+20)]; 
//    _avloader.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
//    [self.view addSubview:_avloader];
//    [self.view bringSubviewToFront:_avloader];
//    [_avloader initLoaderWithSize:CGSizeMake(100, 100)];
//    
//    
  // [self performSelector:@selector(setHiddenActivity) withObject:self];
    
    appDelegate.redirectToRoot = 0;
    
    lblRankText.text = [rankDefaults valueForKey:@"rank"];

    
    [self viewDidAppear:YES];
    
    //self.view.userInteractionEnabled = YES;
    
    [loadingView removeFromSuperview];

}





-(void)buildVideos:(int)vI setPage:(int)curPage
{

    
    if (!_buildVideos) {
        _buildVideos = [buildVideos alloc];
        _buildVideos.currentPage = 1;
        _buildVideos.videoCount = [[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",1]]objectForKey:@"recordcnt"] objectForKey:@"text"] intValue];
        [_buildVideos initWithFrame:CGRectMake(0, ((130.0/480)*curSH) ,self.view.frame.size.width, ((298.0/480)*curSH)) ];
        _buildVideos.backgroundColor=[UIColor clearColor];
        
        _buildVideos._delegate = self;
        
        _buildVideos.alpha = 0;
        
        
        
        if (hotSelected) {
            
            _buildVideos.urlStr = @"media.video-list-hot";
        }
        else if (featureSelected) {
            _buildVideos.urlStr = @"media.video-list-feature";
            
        }
        else if (feedSelected) {
            _buildVideos.urlStr = @"media.video-list-feed";
            
        }
        
        else if (recentSelected) {
            _buildVideos.urlStr = @"media.video-list-recent";
            
        }
        
        [vl_MainView addSubview:_buildVideos];
        
        /*-----animation to fadeout-----*/
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.8];
        _buildVideos.alpha = 1;
        [UIView commitAnimations];
        
        
        //_avloader.hidden = YES;
        
        [self performSelector:@selector(setHiddenActivity) withObject:nil afterDelay:2.0];

    }
    else
    {
        [_buildVideos removeFromSuperview];
        _buildVideos = [buildVideos alloc];
        _buildVideos.currentPage = 1;
        _buildVideos.videoCount = [[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",1]]objectForKey:@"recordcnt"] objectForKey:@"text"] intValue];
        [_buildVideos initWithFrame:CGRectMake(0, ((130.0/480)*curSH) ,self.view.frame.size.width, ((298.0/480)*curSH)) ];
        _buildVideos.backgroundColor=[UIColor clearColor];
        
        _buildVideos._delegate = self;
        
        _buildVideos.alpha = 0;
        
        
        
        if (hotSelected) {
            
            _buildVideos.urlStr = @"media.video-list-hot";
        }
        else if (featureSelected) {
            _buildVideos.urlStr = @"media.video-list-feature";
            
        }
        else if (feedSelected) {
            _buildVideos.urlStr = @"media.video-list-feed";
            
        }
        else if (recentSelected) {
            _buildVideos.urlStr = @"media.video-list-recent";
            
        }
        
        [vl_MainView addSubview:_buildVideos];
        
        /*-----animation to fadeout-----*/
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.8];
        _buildVideos.alpha = 1;
        [UIView commitAnimations];
        
        
        //_avloader.hidden = YES;

        [self performSelector:@selector(setHiddenActivity) withObject:nil afterDelay:2.0];

        
    }
    
    if (boolLoading==1)
    {
        [self LoadIcon];

    }
    
    if ([[loginDefaults valueForKey:@"login"] isEqualToString:@"0"])    {
        
        [loadingView removeFromSuperview];
    }

    
       
}




- (void)setAddBanners
{
    int bannerX, bannerY, bannerW, bannerH;
    NSString *tempimageName;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
       /* bannerX=10;
        bannerY=40;
        bannerW=302;
        bannerH=90;
       */ 
        tempimageName =@"banner_iphone.png";  
        
    }
    else
    {
        
        /*bannerX=32;
        bannerY=85;
        bannerW=705;
        bannerH=193;
        */
        tempimageName =@"banner_ipad.png";
        
    }
    
    bannerX=((15.0/480)*curSW);
    bannerY=((60.0/480)*curSH);
    bannerW=((302.0/480)*curSW);
    bannerH=((90.0/480)*curSH);
    
    
    vl_BannerView = [[UIView alloc] initWithFrame:CGRectMake(bannerX, bannerY, bannerW, bannerH)];
    vl_BannerView.backgroundColor = [UIColor colorWithRed:175.0/255.0 green:174.0/255.0 blue:172.0/255.0 alpha:1];
    [vl_MainView addSubview:vl_BannerView]; 
    
    
    UIImageView *bannerIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:tempimageName]];
    [vl_BannerView addSubview:bannerIV];
    
    
    
    
    
    
    
    
}

-(void)setTabbuttons
{
    
    featureSelected = TRUE;
    hotSelected  = feedSelected = recentSelected = FALSE;
    
    int btnSpace, tabFontFize, tabheight, tabButtonW, tabButtonH; 
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        btnSpace = 0;
        tabFontFize = 10;
        tabheight = 24;
        tabButtonW = 70;
        tabButtonH = 24; 
    }
    else
    {
        
        btnSpace = 0;
        tabFontFize = 25;
        tabheight = 52;
        tabButtonW = 161;
        tabButtonH = 52; 
        
    }    
    
    vl_TabsView = [[UIView alloc] initWithFrame:CGRectMake(0, 19, self.view.frame.size.width ,tabheight )];
    vl_TabsView.backgroundColor = [UIColor clearColor];
    [vl_MainView addSubview:vl_TabsView]; 
    
    btnFeature  = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFeature.frame = CGRectMake(0, 0, (83.0/320)*curSW, (34.0/480)*curSH);
    btnFeature.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    [btnFeature setBackgroundImage:[UIImage imageNamed:@"feature_select.png"] forState:UIControlStateNormal];
    [btnFeature addTarget:self action:@selector(selectedFeature) forControlEvents:UIControlEventTouchUpInside];
    //(btnFeature).titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:tabFontFize];
    //[btnFeature setTitleColor:[UIColor colorWithRed:255/255.0 green:0 blue:38/255.0 alpha:1] forState:UIControlStateNormal];
    [vl_TabsView addSubview:btnFeature];
    
    btnRecent  = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRecent.frame = CGRectMake(((btnFeature.frame.origin.x)+btnFeature.frame.size.width+2), 0, (68.0/320)*curSW, (34.0/480)*curSH);
    btnRecent.backgroundColor = [UIColor colorWithRed:61/255.0 green:61/255.0 blue:61/255.0 alpha:1];
    [btnRecent setBackgroundImage:[UIImage imageNamed:@"recent_deselect.png"] forState:UIControlStateNormal];
    [btnRecent addTarget:self action:@selector(selectedRecent) forControlEvents:UIControlEventTouchUpInside];
    //(btnRecent).titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:tabFontFize];
    //[btnRecent setTitleColor:[UIColor colorWithRed:0 green:254/255.0 blue:215/255.0 alpha:1] forState:UIControlStateNormal];
    [vl_TabsView addSubview:btnRecent];
    
    btnHot  = [UIButton buttonWithType:UIButtonTypeCustom];
    btnHot.frame = CGRectMake(btnRecent.frame.origin.x+btnRecent.frame.size.width+2, 0, (69.0/320)*curSW, (34.0/480)*curSH);
    btnHot.backgroundColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1];
    [btnHot setBackgroundImage:[UIImage imageNamed:@"hot_deselect.png"] forState:UIControlStateNormal];
    [btnHot addTarget:self action:@selector(selectedHot) forControlEvents:UIControlEventTouchUpInside];
    //(btnHot).titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:tabFontFize];
    //[btnHot setTitleColor:[UIColor colorWithRed:255/255.0 green:234/255.0 blue:0 alpha:1] forState:UIControlStateNormal];
    
    [vl_TabsView addSubview:btnHot];
    
    
    
    
    
    
    btnFeed  = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFeed.frame = CGRectMake(((btnHot.frame.origin.x)+btnHot.frame.size.width+2), 0, (63.0/320)*curSW, (34.0/480)*curSH);
    btnFeed.backgroundColor = [UIColor colorWithRed:61/255.0 green:61/255.0 blue:61/255.0 alpha:1];
    [btnFeed setBackgroundImage:[UIImage imageNamed:@"feed_deselect.png"] forState:UIControlStateNormal];
    [btnFeed addTarget:self action:@selector(selectedFeed) forControlEvents:UIControlEventTouchUpInside];
    //(btnFeed).titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:tabFontFize];
    //[btnFeed setTitleColor:[UIColor colorWithRed:0 green:254/255.0 blue:215/255.0 alpha:1] forState:UIControlStateNormal];
    [vl_TabsView addSubview:btnFeed];
    
    
   
    
}


- (void)selectedFeature
{
    if (featureSelected) {
        return;
    }
    
//    [backgroundImageView removeFromSuperview];
//    
//    backgroundImageView.image = [UIImage imageNamed:@"bg_1.png"];
//    
//    [self.view addSubview:backgroundImageView];
//    
//    [self.view sendSubviewToBack:backgroundImageView];
    
    [self performSelectorInBackground:@selector(enableLoader) withObject:self];
    featureSelected = TRUE;
    hotSelected  = feedSelected = recentSelected =FALSE;

    
    [btnFeature setBackgroundImage:[UIImage imageNamed:@"feature_select.png"] forState:UIControlStateNormal];
    [btnHot setBackgroundImage:[UIImage imageNamed:@"hot_deselect.png"] forState:UIControlStateNormal];
    [btnFeed setBackgroundImage:[UIImage imageNamed:@"feed_deselect.png"] forState:UIControlStateNormal];
    [btnRecent setBackgroundImage:[UIImage imageNamed:@"recent_deselect.png"] forState:UIControlStateNormal];
    
    [_buildVideos removeFromSuperview];
    [_buildVideos release];
    _buildVideos =nil;
    [appDelegate fetchVideoListing:@"media.video-list-feature"uid:@"" setCurrentPage:currentPage ];
    
        
    [self buildVideos:0 setPage:0];
     _avloader.hidden = YES;
    
}

-(void)enableLoader
{
    
    if(_avloader)
    {
        [self.view bringSubviewToFront:_avloader];
        _avloader.hidden = NO;
    }
}

- (void)selectedHot
{
    
    
    if (hotSelected) {
        return;
    }
    
//    [backgroundImageView removeFromSuperview];
//    
//    backgroundImageView.image = [UIImage imageNamed:@"bg_1.png"];
//    
//    [self.view addSubview:backgroundImageView];
//    
//    [self.view sendSubviewToBack:backgroundImageView];
    
    [self performSelectorInBackground:@selector(enableLoader) withObject:self];
   
    hotSelected = TRUE;
    featureSelected  = feedSelected = recentSelected = FALSE;

    [btnFeature setBackgroundImage:[UIImage imageNamed:@"feature_deselect.png"] forState:UIControlStateNormal];
    [btnHot setBackgroundImage:[UIImage imageNamed:@"hot_select.png"] forState:UIControlStateNormal];
    [btnFeed setBackgroundImage:[UIImage imageNamed:@"feed_deselect.png"] forState:UIControlStateNormal];
    [btnRecent setBackgroundImage:[UIImage imageNamed:@"recent_deselect.png"] forState:UIControlStateNormal];
    [_buildVideos removeFromSuperview];

    [_buildVideos release];
    
    
    _buildVideos = nil;
     
    
    [appDelegate fetchVideoListing:@"media.video-list-hot"uid:@"" setCurrentPage:currentPage];
    
    
        
    [self buildVideos:0 setPage:0];

       
    
    _avloader.hidden = YES;
    
}
- (void)selectedFeed
{
    
    
    if (appDelegate.loginBool==1 ) 
    {
        
    
    
        if (feedSelected) {
            return;
        }
        
//        [backgroundImageView removeFromSuperview];
//        
//        backgroundImageView.image = [UIImage imageNamed:@"bg_1.png"];
//        
//        [self.view addSubview:backgroundImageView];
//        
//        [self.view sendSubviewToBack:backgroundImageView];
        
        [self performSelectorInBackground:@selector(enableLoader) withObject:self];
        feedSelected = TRUE;
        featureSelected  = hotSelected =  recentSelected = FALSE;

        
        
        [btnFeature setBackgroundImage:[UIImage imageNamed:@"feature_deselect.png"] forState:UIControlStateNormal];
        [btnHot setBackgroundImage:[UIImage imageNamed:@"hot_deselect.png"] forState:UIControlStateNormal];
        [btnFeed setBackgroundImage:[UIImage imageNamed:@"feed_select.png"] forState:UIControlStateNormal];
        [btnRecent setBackgroundImage:[UIImage imageNamed:@"recent_deselect.png"] forState:UIControlStateNormal];
        
        [_buildVideos removeFromSuperview];

        [_buildVideos release];
        
        _buildVideos = nil;
        
         
        [appDelegate fetchVideoListing:@"media.video-list-feed"uid:appDelegate.userID setCurrentPage:currentPage ];
        
        
        
        [self buildVideos:0 setPage:0];
         _avloader.hidden = YES;
        
    }
    else
    {
        
        [[[[UIAlertView alloc]initWithTitle:@"" message:@"Please log in to follow users and view their posts" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease]show];
    
    }
    
}

-(void)selectedRecent
{
    if (recentSelected && appDelegate.mediaPosted==FALSE) {
        return;
    }
    
//    [backgroundImageView removeFromSuperview];
//
//    backgroundImageView.image = [UIImage imageNamed:@"bg_4.png"];
//    
//    [self.view addSubview:backgroundImageView];
//    
//    [self.view sendSubviewToBack:backgroundImageView];
    
    [self performSelectorInBackground:@selector(enableLoader) withObject:self];
    recentSelected = TRUE;
    featureSelected  = hotSelected =  feedSelected = FALSE;
        
    
    [btnFeature setBackgroundImage:[UIImage imageNamed:@"feature_deselect.png"] forState:UIControlStateNormal];
    [btnHot setBackgroundImage:[UIImage imageNamed:@"hot_deselect.png"] forState:UIControlStateNormal];
    [btnFeed setBackgroundImage:[UIImage imageNamed:@"feed_deselect.png"] forState:UIControlStateNormal];
    [btnRecent setBackgroundImage:[UIImage imageNamed:@"recent_select.png"] forState:UIControlStateNormal];
    
    
    
    
    [_buildVideos release];
    [_buildVideos removeFromSuperview];
    [appDelegate fetchVideoListing:@"media.video-list-recent"uid:@"" setCurrentPage:currentPage];
    
    [self buildVideos:0 setPage:0];
    _avloader.hidden = YES;
}
-(void)videoSelected    //:(id)sender
{
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        _mediadetails = [[mediadetails alloc] initWithNibName:@"mmsvViewController_iPhone" bundle:nil];
        
    }
    else
    {
        _mediadetails = [[mediadetails alloc] initWithNibName:@"mmsvViewController_iPad" bundle:nil];
    }
    
    
    [self presentModalViewController:_mediadetails animated:YES];
    
    
    
}

-(void)loadData
{
    _avloader  = [[avloader alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height+20)]; 
    _avloader.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
    [self.view addSubview:_avloader];
    [self.view bringSubviewToFront:_avloader];
    [_avloader initLoaderWithSize:CGSizeMake(100, 100)];
}

-(void)logedUserSelected
{
    
    [self performSelectorInBackground:@selector(enableLoader) withObject:nil];
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        _userVL = [[userVideoListing alloc] initWithNibName:@"mmsvViewController_iPhone" bundle:nil];
        
    }
    else
    {
        _userVL = [[userVideoListing alloc] initWithNibName:@"mmsvViewController_iPad" bundle:nil];
    }
    
    
    _userVL.pageUserId = appDelegate.userID;
    
    
    [self presentModalViewController:_userVL animated:YES];
    
   // [_avloader removeFromSuperview];
    [self setHiddenActivity];
    
}


-(void)userSelected
{

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        _userVL = [[userVideoListing alloc] initWithNibName:@"mmsvViewController_iPhone" bundle:nil];
        
    }
    else
    {
        _userVL = [[userVideoListing alloc] initWithNibName:@"mmsvViewController_iPad" bundle:nil];
    }
    
    //NSLog(@"selected user id = %d",appDelegate.selectedUserId);    
    _userVL.pageUserId = [NSString stringWithFormat:@"%@",appDelegate.selectedUserId];
    
    
    [self presentModalViewController:_userVL animated:YES];



}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (appDelegate.redirectToRoot==TRUE)
    {
        [self LoadIcon];

    
//        if (appDelegate.boolFlag==0)
//        {
//            NSLog(@"test");
//            [_avloader initLoaderWithSize:CGSizeMake(100, 100)];
//            
//            
//          //  [self performSelectorInBackground:@selector(enableLoader) withObject:self];
//        }
    }
    
    else
    {
        //[_avloader release];
        //[_avloader removeFromSuperview];
    }
    
    
    if (appDelegate.loginFlag==TRUE) {
        
//        if (_avloader)
//        {
//            //[_avloader release];
//            //[_avloader removeFromSuperview];
//        }
        
        [self redirectToLogin];
    }



}

-(void)adjustScreen
{
    self.view.window.frame = CGRectMake(0, 0, 320, 480);
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

}

- (void)viewDidAppear:(BOOL)animated
{
    
    
    [super viewDidAppear:animated];
    
    [self adjustScreen];
    NSLog(@"app delegate bool = %d",appDelegate.redirectToRoot);
    
    if (appDelegate.redirectToRoot==1)
    {
        
        [self viewDidLoad];
    }
    
    
//    if (appDelegate.userID!=NULL) 
//    {

        if (redirectToPost==TRUE) {
            redirectToPost = FALSE;
            return;
        }
        
        
        
        //appDelegate.redirectToRoot = FALSE;
        
        //        if (appDelegate.loginFlag==TRUE) {
        //            
        //            if (_avloader)
        //            {
        //                [_avloader removeFromSuperview];
        //            }
        //            
        //            [self redirectToLogin];
        //        }
        
        
        if (appDelegate.userID == NULL) {
            btnSignIn.hidden = NO;
            btnLogin.hidden= NO;
            btnLogedUser.hidden=YES;
            btnCamera.hidden = YES;
            lblRank.hidden = YES;
            lblRankText.hidden = YES;
        }
        else
        {
            if (appDelegate.userID > 0) 
            {
                //
            }
            else
            {
                [self fetchUserDetail];
            }

            btnCamera  = [UIButton buttonWithType:UIButtonTypeCustom];
            btnCamera.frame = CGRectMake((320-30)/2,7,30,24);
            [btnCamera setImage:[UIImage imageNamed:@"ing_startRecord_iphone.png"] forState:UIControlStateNormal];
            btnCamera.backgroundColor = [UIColor clearColor];
            
            [btnCamera addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];    
            [vl_bottomView addSubview:btnCamera];
            [vl_bottomView bringSubviewToFront:btnCamera];        lblRank.hidden = NO;
            lblRankText.hidden = NO;
        }
    
    if (appDelegate.boolDelete==1)
    {
        
                NSLog(@"current page = %d",currentPage);
                
                if (hotSelected) {
                    [_buildVideos release];
                    [_buildVideos removeFromSuperview];
                    [appDelegate fetchVideoListing:@"media.video-list-hot"uid:@"" setCurrentPage:currentPage];
                }
                else if (featureSelected) {
                    [_buildVideos release];
                    [_buildVideos removeFromSuperview];
                  [appDelegate fetchVideoListing:@"media.video-list-feature"uid:@"" setCurrentPage:currentPage];
                }
                else if (feedSelected) {
                    [_buildVideos release];
                    [_buildVideos removeFromSuperview];
                    [appDelegate fetchVideoListing:@"media.video-list-feed"uid:@"" setCurrentPage:currentPage];
                }
                else if (recentSelected) {
                    [_buildVideos release];
                    [_buildVideos removeFromSuperview];
                    [appDelegate fetchVideoListing:@"media.video-list-recent"uid:@"" setCurrentPage:currentPage];
                }
                [self buildVideos:0 setPage:0];
    }
        
        NSLog(@"app user id = %@",appDelegate.userID);

    
        if (appDelegate.userID!=NULL)
            
        {
        
            btnLogin.hidden = YES;
            btnLogedUser=[UIButton buttonWithType:UIButtonTypeCustom];
            btnLogedUser.frame = CGRectMake(20, 7, 25, 25);
             
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",appDelegate.userID]];
            
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            
            
            [btnLogedUser setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
            
            [btnLogedUser addTarget:self action:@selector(logedUserSelected) forControlEvents:UIControlEventTouchUpInside];
            
            [vl_bottomView addSubview:btnLogedUser];
        }
    //}
    
    if (appDelegate.mediaPosted==TRUE) {
        
        [self selectedRecent];
        
        appDelegate.mediaPosted = FALSE ; 
    }
    
    [self setHiddenActivity];
    
    
}
-(void)refreshList
{
    
    
    
    [self performSelectorInBackground:@selector(enableLoader) withObject:self];
    
    [self fetchUserDetail];
    
    NSLog(@"current page = %d",currentPage);
    
    if (hotSelected) {
        [_buildVideos release];
        [_buildVideos removeFromSuperview];
        [appDelegate fetchVideoListing:@"media.video-list-hot"uid:@"" setCurrentPage:currentPage];
    }
    else if (featureSelected) {
        [_buildVideos release];
        [_buildVideos removeFromSuperview];
        [appDelegate fetchVideoListing:@"media.video-list-feature"uid:@"" setCurrentPage:currentPage];
    }
    else if (feedSelected) {
        [_buildVideos release];
        [_buildVideos removeFromSuperview];
        [appDelegate fetchVideoListing:@"media.video-list-feed"uid:appDelegate.userID setCurrentPage:currentPage];
    }
    else if (recentSelected) {
        [_buildVideos release];
        [_buildVideos removeFromSuperview];
        [appDelegate fetchVideoListing:@"media.video-list-recent"uid:@"" setCurrentPage:currentPage];
    }
    [self buildVideos:0 setPage:0];
}

-(void)hideActivity
{
    [_avloader removeFromSuperview];
    
    //self.view.userInteractionEnabled = YES;
}

-(void)setHiddenActivity
{
    _avloader.hidden = YES;

}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
    [self enableLoader];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    
   // NSLog(@"%@",interfaceOrientation);
    
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown && interfaceOrientation == UIInterfaceOrientationPortrait);
    
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
