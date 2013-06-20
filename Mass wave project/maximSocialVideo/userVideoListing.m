//
//  userVideoListing.m
//  maximSocialVideo
//
//  Created by neo on 31/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "userVideoListing.h"
#import "contributeViewController.h"

@implementation userVideoListing
@synthesize pageUserId;

@synthesize _mediadetails, _userSettings;

@synthesize setY;


epubstore_svcAppDelegate *appDelegate;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/
-(void)enableLoader
{
    
    if ([_avloader isHidden]) {
        [self.view bringSubviewToFront:_avloader];
        _avloader.hidden = NO;
    }
    
    
}

-(void)disableLoader
{
    _avloader.hidden = YES;
    
}
 
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    rankDefaults = [NSUserDefaults standardUserDefaults];
    
    listTableView =[[UITableView alloc]initWithFrame:CGRectMake(0,50, 320 ,225)];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setShowsVerticalScrollIndicator:NO];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    
    listTableView.separatorColor=[UIColor clearColor];
    listTableView.backgroundColor  = [UIColor clearColor];
    
    //[vl_View addSubview:listTableView];
    
    message = [[UILabel alloc] init];
    message.font = [UIFont fontWithName:@"HelveticaNeue" size:30];
    message.textColor = [UIColor colorWithRed:113.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:1];
    message.backgroundColor = [UIColor clearColor];
    //[vl_View addSubview:message];
    
    currentPage = 1;

    if ([appDelegate.userID isEqualToString:pageUserId]) 
    {
         [self fetchNotification];
    }
    
    backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height+20)];
    
    backgroundImageView.image = [UIImage imageNamed:@"bg_3_blue.png"];
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
    
    
    curSW = [[UIScreen mainScreen] bounds].size.width;
    curSH = [[UIScreen mainScreen] bounds].size.height;
    bildListingTab = TRUE;
    contentSelected = TRUE; 
    followingSelected = followersSelected = starringSelected = FALSE;
    followed = FALSE;
    
    
    vl_MainView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width , self.view.frame.size.height+((20.0/480)*curSH))];
    vl_MainView.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1];
    [self.view addSubview:vl_MainView];
    
    [self setNavTabbuttons];
    
    [self fetchUserDetail];
    NSLog(@"pageUserId----%@",self.pageUserId);
    [appDelegate fetchVideoListing:@"media.video-list-recent"uid:self.pageUserId setCurrentPage:currentPage];
    
    [self buildUserView];
    
    [self buildVideolisting];
    
    [self buildBottomTab];
     if (![appDelegate.userID isEqualToString:pageUserId]) 
     {
    if (followed==TRUE) {
        btnContribute.hidden = NO;
        buttonFollower.hidden = NO;
        [buttonFollower setTitle:@"UnFollow" forState:UIControlStateNormal];
        
        buttonFollower.titleLabel.font = [UIFont fontWithName:@"BigNoodleTitling" size:23];
        
        
        
        //buttonFollower.titleLabel.textColor = [UIColor colorWithRed:250/255.0 green:204/255.0 blue:0/255.0 alpha:1];
        
        [buttonFollower setTitleColor:[UIColor colorWithRed:250/255.0 green:204/255.0 blue:0/255.0 alpha:1] forState:UIControlStateNormal];
        
        [btnContribute setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateNormal];

    }
    else
    {
        btnContribute.hidden = NO;
        buttonFollower.hidden = NO;
        [buttonFollower setTitle:@"Follow" forState:UIControlStateNormal];
        
        buttonFollower.titleLabel.font = [UIFont fontWithName:@"BigNoodleTitling" size:23];
        
        
        
       // buttonFollower.titleLabel.textColor = [UIColor colorWithRed:250/255.0 green:204/255.0 blue:0/255.0 alpha:1];
        
        [buttonFollower setTitleColor:[UIColor colorWithRed:250/255.0 green:204/255.0 blue:0/255.0 alpha:1] forState:UIControlStateNormal];
        
        [btnContribute setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];



    }
     }
    
    
    if (appDelegate.userID==NULL)
    {
        buttonFollower.hidden = YES;
        btnContribute.hidden = YES;
        lblRank.hidden = YES;
        lblRankText.hidden = YES;
    }
    else
    {
        lblRank.hidden = NO;
        lblRankText.hidden = NO;
    }
    
}


 

-(void)fetchNotification
{
    NSString *urlString =[NSString stringWithFormat:@"%@iphone_request.php",ServerIp];
    
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
    [request setURL:[NSURL URLWithString:urlString]]; 
    
    NSLog(@"urlString----%@",urlString);
	
    NSString *myParameters = [NSString stringWithFormat:@"method=notify&user_id=%@",appDelegate.userID];
    
    NSLog(@"%@",myParameters);
    
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    // now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"%@",returnString);
    
    
    
    if (returnString) 
    {
        
        
        
        if (notifyDetails!=nil) {
            [notifyDetails release];
            notifyDetails = nil;
        }
        notifyCount  = [[self GetValueInXML:returnString SearchStr:@"notifyCount"] intValue];
        
        
        if (notifyCount>0) 
        {
            newNotifyCount  = [[self GetValueInXML:returnString SearchStr:@"newNotifyCnt"] intValue];
            
            NSError *error;
            
            notifyDetails  = [XMLReader1  dictionaryForXMLString:returnString error:&error];
            
            NSLog(@"%@", notifyDetails);
                        
            if (notifyCount==1) {
                
               
                notifyDetails = [[NSDictionary alloc] initWithDictionary:[[notifyDetails objectForKey:@"notification"]objectForKey:@"notify"]];
                 NSLog(@"%@", notifyDetails);
            }else
            {
                if (aNnotifyDetails!=nil) {
                    [aNnotifyDetails release];
                    aNnotifyDetails = nil;
                }
                aNnotifyDetails = [[NSArray alloc] initWithArray:(NSArray*)[[notifyDetails objectForKey:@"notification"] objectForKey:@"notify"]];
                 NSLog(@"%@", aNnotifyDetails);
            }
        
        }
        
       
        
    }
    
    // [[[[UIAlertView alloc] initWithTitle:@"error" message:returnString delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] autorelease] show];
    
    [returnString release];
    
}

-(void)resetNotifications
{
    

    NSString *urlString =[NSString stringWithFormat:@"%@media/notify",ServerIp];
    
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
    [request setURL:[NSURL URLWithString:urlString]]; 
    
    NSLog(@"urlString----%@",urlString);
	
    NSString *myParameters = [NSString stringWithFormat:@"method=notify.clear&user_id=%@",appDelegate.userID];
    
    NSLog(@"%@",myParameters);
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    // now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
    NSLog(@"%@",returnString);
    
    if (returnString) 
    {
          // [[[[UIAlertView alloc] initWithTitle:@"returnString" message:returnString delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] autorelease] show];
    }

}

-(void)fetchUserDetail
{

    NSString *urlString =[NSString stringWithFormat:@"%@media/list",ServerIp];
    
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
    [request setURL:[NSURL URLWithString:urlString]];
    
    NSLog(@"urlString----%@",urlString);
    
    NSLog(@"user id =%@",pageUserId);
	
    NSString *myParameters = [NSString stringWithFormat:@"method=user.profile&user_id=%@&req_userid=%@",appDelegate.userID, pageUserId];
    
    NSLog(@"myParameters -- %@",myParameters);
    
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    // now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"fetchVideoDetails ---- %@",returnString);
    
    
    if (returnString) 
    {
        
        userArray = [[NSMutableArray alloc] init];
        [userArray addObject:[NSString stringWithFormat:@"%@ %@",[self GetValueInXML:returnString SearchStr:@"fname"], [self GetValueInXML:returnString SearchStr:@"lname"]]];


    userImage     = [self GetValueInXML:returnString SearchStr:@"thumb"];
    userFLname    = [NSString stringWithFormat:@"%@ %@",[self GetValueInXML:returnString SearchStr:@"fname"], [self GetValueInXML:returnString SearchStr:@"lname"] ];
            
            
    NSString *followedFlag = [self GetValueInXML:returnString SearchStr:@"follow"];
        
        
        if ([followedFlag isEqualToString:@"1"]) {
            followed = TRUE;
        } 
        else
        {
            followed = FALSE;
        }
        
    }
    
    
    [returnString release];

}
 



-(void)buildBottomTab
{
    
    curSW = [[UIScreen mainScreen] bounds].size.width;
    curSH = [[UIScreen mainScreen] bounds].size.height;
    
    
    int  tabFontFize, tabheight, tabButtonW, tabButtonH;
    
    UIImage *tempImage, *tempImage2 ;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        tabFontFize = 16;
        tabheight = 50;
        tabButtonW = 70;
        tabButtonH = 24; 
        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"atatar" ofType:@"png"]];
        tempImage2 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"home_button" ofType:@"png"]];
        
        
        
    }
    else
    {
        
        tabFontFize =35;
        tabheight = 82;//62
        tabButtonW = 161;
        tabButtonH = 52; 
        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"green_line_ipad" ofType:@"png"]];
        
    }    
    
    vl_BottomTabView = [[UIView alloc] initWithFrame:CGRectMake(0,(400.0/480)*curSH, self.view.frame.size.width ,(50.0/480)*curSH)];
    vl_BottomTabView.backgroundColor = [UIColor blackColor];
    [vl_MainView addSubview:vl_BottomTabView];
    
    if (!appDelegate.userID) 
    {
        
//        UIButton *btnSignIn  = [UIButton buttonWithType:UIButtonTypeCustom];
//        btnSignIn.frame = CGRectMake(0,0,75,50);
//        btnSignIn.backgroundColor = [UIColor clearColor];
//        [btnSignIn addTarget:self action:@selector(redirectToLogin) forControlEvents:UIControlEventTouchUpInside];
//        (btnSignIn).titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:15];
//        
//        [btnSignIn setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
//        [vl_BottomTabView addSubview:btnSignIn];
//        
//        
//        UILabel *signIn = [[UILabel alloc] initWithFrame:btnSignIn.frame];
//        signIn.numberOfLines = 2;
//        signIn.text = @"Sign-up\nLog-in";
//        signIn.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
//        signIn.textAlignment = UITextAlignmentCenter;
//        signIn.backgroundColor = [UIColor clearColor];
//        signIn.textColor =  [ UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
//        [btnSignIn addSubview:signIn];
        
    }
    else
    {
    
    
        //home_button.png
         
//        UIButton *btnHome;
//        btnHome=[UIButton buttonWithType:UIButtonTypeCustom];
//        btnHome.frame = CGRectMake(15,7,30,30);
//        [btnHome setImage:tempImage2 forState:UIControlStateNormal];
//        [btnHome addTarget:self action:@selector(backtoRoot) forControlEvents:UIControlEventTouchUpInside];
//        
//        [vl_BottomTabView addSubview:btnHome];
         
    
    
    }
    
    NSLog(@"app dele user id,page user id = %@,%@",appDelegate.userID,pageUserId);
    
    
    if ([appDelegate.userID isEqualToString:pageUserId]) 
    {
        
        
        btnContribute=[UIButton buttonWithType:UIButtonTypeCustom];
        btnContribute.frame = CGRectMake((320-30)/2,11,30,24);
        [btnContribute setImage:[UIImage imageNamed:@"ing_startRecord_iphone.png"] forState:UIControlStateNormal];
        [btnContribute addTarget:self action:@selector(loadContribute) forControlEvents:UIControlEventTouchUpInside];
        
        [vl_BottomTabView addSubview:btnContribute];
        
        
    }
    else
    {
//        if (appDelegate.userID>0) 
//        {
//         
//            UIButton *button;
//            button=[UIButton buttonWithType:UIButtonTypeCustom];
//            button.frame = CGRectMake(270, 5, 30, 30);
//            [button setImage:tempImage forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(goTologedUser) forControlEvents:UIControlEventTouchUpInside];
//            
//            [vl_BottomTabView addSubview:button];
//           
//        
//        }  
        
        btnContribute=[UIButton buttonWithType:UIButtonTypeCustom];
        btnContribute.frame = CGRectMake((320-82)/2,15,22,23);
        [btnContribute setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
        [btnContribute addTarget:self action:@selector(loadContribute) forControlEvents:UIControlEventTouchUpInside];
        

        
        buttonFollower  = [[UIButton alloc] initWithFrame:CGRectMake(btnContribute.frame.origin.x+btnContribute.frame.size.width, 15, 90, 23)];
        
        
        buttonFollower.backgroundColor = [UIColor clearColor];
        
        
        [buttonFollower setTitle:@"Follow" forState:UIControlStateNormal];

        [buttonFollower addTarget:self action:@selector(loadContribute) forControlEvents:UIControlEventTouchUpInside];
        
        buttonFollower.titleLabel.font = [UIFont fontWithName:@"BigNoodleTitling" size:23];
        
        
        
        buttonFollower.titleLabel.textColor = [UIColor colorWithRed:250/255.0 green:204/255.0 blue:0/255.0 alpha:1];
        
        [vl_BottomTabView addSubview:buttonFollower];
        
        [vl_BottomTabView addSubview:btnContribute];
        btnFollowers.hidden = YES;
        btnFollowing.hidden = YES;
        //btnStarring.hidden = YES;
        
    } 
   
    [vl_BottomTabView release];
    
}

-(void)loadContribute
{
    if ([appDelegate.userID isEqualToString:pageUserId]) 
    {
        
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Take Video", @"Take Photo",@"Take Video From Library",@"Take Photo From Library" ,@"Cancel",nil];
        actionSheet.actionSheetStyle =UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
        [actionSheet release];
        
        
    }
    else 
    {
        
        [self followUser];
    } 
    

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

-(void)presentVideoMode
{
    
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
	{
        
		
        
        imagePickerController = [[UIImagePickerController alloc] init];
		imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
		imagePickerController.allowsEditing = YES;
        imagePickerController.showsCameraControls = NO;
        
		imagePickerController.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];//[NSArray arrayWithObject:(NSString *)kUTTypeMovie];
        
        
        imagePickerController.delegate = self;
		[self presentModalViewController:imagePickerController animated:YES];
        
        
        
        UIImage *tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"img_flipCamera_iphone" ofType:@"png"]];
        
        
        btnFlipCam=[UIButton buttonWithType:UIButtonTypeCustom];
        btnFlipCam.frame = CGRectMake(255, 5, 60, 45);
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
        btnStartRecord.frame = CGRectMake(130, 430, 60, 45);
        [btnStartRecord setImage:tempImage forState:UIControlStateNormal];
        [btnStartRecord addTarget:self action:@selector(startVideoRecording) forControlEvents:UIControlEventTouchUpInside];
        //btnStartRecord.userInteractionEnabled=NO;
        [imagePickerController.view  addSubview:btnStartRecord];
        [tempImage release];
        
        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ing_stopRecord_iphone" ofType:@"png"]];
        btnStopRecord=[UIButton buttonWithType:UIButtonTypeCustom];
        btnStopRecord.frame = CGRectMake(130, 430, 60, 45);
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
        //btnLibrary.userInteractionEnabled=NO;
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


-(void)goToLibrary
{
    //redirectToPost = TRUE;
    
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

-(void)presentVideoLibrary
{
    
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
	{
        
		
        
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
    
    //UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    // orientationStr1 = [[NSString stringWithFormat:@"%d",orientation] retain];
    
    //redirectToPost = TRUE;
    [picker2 dismissModalViewControllerAnimated:YES];
	NSString *mediaType = [info valueForKey:UIImagePickerControllerMediaType];
	if([mediaType isEqualToString:@"public.movie"])
	{
		NSLog(@"came to video select...");
		
		appDelegate.postVideoUrl =(NSURL*)[info objectForKey:@"UIImagePickerControllerMediaURL"];
        
        NSLog(@"appDelegate.postVideoUrl--- %@", appDelegate.postVideoUrl);
        
        _avloader  = [[avloader alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height+20)]; 
        _avloader.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
        [self.view addSubview:_avloader];
        [self.view bringSubviewToFront:_avloader];
        [_avloader initLoaderWithSize:CGSizeMake(100, 100)];
        
        
        [self performSelector:@selector(postMediaWithDelay) withObject:nil afterDelay:0.5];
        
        
        
        
		
	}
	else if([mediaType isEqualToString:@"public.image"])
	{
        UIImage *capture = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        
        
        
        imageDict = [[NSMutableDictionary alloc] init];
        
        [imageDict setObject:capture forKey:@"0"];
        
        NSLog(@"outputImage = %@",[info objectForKey:@"UIImagePickerControllerOriginalImage"]);
        _avloader  = [[avloader alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height+20)]; 
        _avloader.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
        [self.view addSubview:_avloader];
        [self.view bringSubviewToFront:_avloader];
        [_avloader initLoaderWithSize:CGSizeMake(100, 100)];
        [self performSelector:@selector(postPhotoWithDelay:) withObject:[NSString stringWithFormat:@"%d",capture.imageOrientation] afterDelay:0.5];
        
        
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
    [self presentModalViewController:contributeView animated:YES];
    
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
    
    [self presentModalViewController:_mediaPost animated:YES];
}

-(void)flipCamera
{
    
    imagePickerController.cameraDevice = (imagePickerController.cameraDevice == UIImagePickerControllerCameraDeviceFront) ? UIImagePickerControllerCameraDeviceRear : UIImagePickerControllerCameraDeviceFront;
    
    
    
}

-(void)backtoRoot
{

    appDelegate.redirectToRoot = TRUE;
    [self dismissModalViewControllerAnimated:YES];

}


-(void)redirectToLogin
{
    
   appDelegate.loginFlag = TRUE;
    
   [self dismissModalViewControllerAnimated:YES];
    
//    contributeViewController *contributeView = [[[contributeViewController alloc]initWithNibName:@"contributeViewController" bundle:nil] autorelease];
//    
//    contributeView.pageUserId = pageUserId;
//    contributeView.userName = userFLname;
//    [self presentModalViewController:contributeView animated:YES];
    
    
}



-(void)goTologedUser
{
    
     
    
    pageUserId = [NSString stringWithFormat:@"%d",[appDelegate.userID longLongValue]];
    
    
    [vl_MainView removeFromSuperview];
    
    
    
    [self viewDidLoad];
    
    
    
}


-(void)setNavTabbuttons
{
    
   
    curSW = [[UIScreen mainScreen] bounds].size.width;
    curSH = [[UIScreen mainScreen] bounds].size.height;
    
      
    
    UIView *vl_TempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width ,(36.0/480)*curSH )];
    vl_TempView.backgroundColor = [UIColor clearColor];

    [vl_MainView addSubview:vl_TempView];
    [vl_TempView release];
    
    [vl_MainView setBackgroundColor:[UIColor clearColor]];
    
    button1=[[UIButton alloc]initWithFrame:CGRectMake(10, 28, (20.0/320)*curSW , (20.0/480)*curSH )];
    [button1 addTarget:self action:@selector(backtoHome) forControlEvents:UIControlEventTouchUpInside]; 


    [button1 setBackgroundImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];

    [self.view addSubview:button1];
    [button1 release];


 
    NSLog(@"appDelegate.userID----%@---pageUserId----%@",appDelegate.userID,pageUserId);
    
    button2=[[UIButton alloc]initWithFrame:CGRectMake((290.0/320)*curSW, 0, (20.0/320)*curSW , (20.0/480)*curSH )];
    [button2 addTarget:self action:@selector(goToSettings) forControlEvents:UIControlEventTouchUpInside]; 
    [button2 setBackgroundImage:[UIImage imageNamed:@"icon_setting.png"] forState:UIControlStateNormal];
    button2.hidden = YES;
    [vl_TempView addSubview:button2];
    
    
    
//    button3 = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    
//    [button3 setTitle:@"FOLLOW" forState:UIControlStateNormal];
//    button3.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
//    
//    button3.frame = CGRectMake(240.0, 0, 80, 20);
//    [button3 addTarget:self action:@selector(followUser) forControlEvents:UIControlEventTouchUpInside];
//    button3.hidden = YES;
//    [vl_TempView addSubview:button3];
    
    
    if ([appDelegate.userID isEqualToString:pageUserId]) 
    {
       
        
        button2.hidden = NO;
        


    }
    else
    {
    
        

        //button3.hidden = NO;
    
    }    
    
    
}

-(void)goToSettings
{

    [self performSelectorInBackground:@selector(enableLoader) withObject:nil];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        _userSettings = [[userSettings alloc] initWithNibName:@"mmsvViewController_iPhone" bundle:nil];
        
    }
    else
    {
        _userSettings = [[userSettings alloc] initWithNibName:@"mmsvViewController_iPad" bundle:nil];
    }
    
    
    [self presentModalViewController:_userSettings animated:YES];
    
    [self performSelector:@selector(disableLoader) withObject:nil afterDelay:0.5];

}


 


-(void)followUser
{

    
    
    if (appDelegate.userID) 
    {

        NSString *urlString =[NSString stringWithFormat:@"%@users",ServerIp];
        
        urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        // setting up the request object now
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        
        [request setURL:[NSURL URLWithString:urlString]];
        
        NSLog(@"urlString----%@",urlString);
        
        NSLog(@"page user id = %@",pageUserId);
        
        NSString *myParameters = [NSString stringWithFormat:@"method=user.follow&user_id=%@&follow_id=%@",appDelegate.userID, pageUserId];
        
        NSLog(@"myParameters -- %@",myParameters);
        
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
        
        // now lets make the connection to the web
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"followUser ---- %@",returnString);
        
        
        if (returnString) 
        {
            
            
            if (followed ==FALSE)
            {
            [[[[UIAlertView alloc] initWithTitle:@"Success" message:@"Followed Successfully" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] autorelease] show];
                followed = TRUE;
            //buttonFollower.hidden = YES;
            [buttonFollower setTitle:@"UnFollow" forState:UIControlStateNormal];
                
                buttonFollower.titleLabel.font = [UIFont fontWithName:@"BigNoodleTitling" size:23];
                
                
                
                //buttonFollower.titleLabel.textColor = [UIColor colorWithRed:250/255.0 green:204/255.0 blue:0/255.0 alpha:1];
                
                [buttonFollower setTitleColor:[UIColor colorWithRed:250/255.0 green:204/255.0 blue:0/255.0 alpha:1] forState:UIControlStateNormal];

                
                [btnContribute setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateNormal];

            }
            else
            {
                [[[[UIAlertView alloc] initWithTitle:@"Success" message:@"UnFollowed Successfully" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] autorelease] show];
                followed = FALSE;
                //buttonFollower.hidden = YES;
                [buttonFollower setTitle:@"Follow" forState:UIControlStateNormal];
                
                buttonFollower.titleLabel.font = [UIFont fontWithName:@"BigNoodleTitling" size:23];
                
                
                
               // buttonFollower.titleLabel.textColor = [UIColor colorWithRed:250/255.0 green:204/255.0 blue:0/255.0 alpha:1];
                
                [buttonFollower setTitleColor:[UIColor colorWithRed:250/255.0 green:204/255.0 blue:0/255.0 alpha:1] forState:UIControlStateNormal];

                
                [btnContribute setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];

            }

            //btnContribute.hidden = YES;
            
            if (followingSelected) {
                [_userBuildVideos release];
                [_userBuildVideos removeFromSuperview];
                [appDelegate fetchVideoListing:@"user.following"uid:pageUserId setCurrentPage:currentPage];
                [self buildVideolisting];
            }
            
            
        }
        
        
        [returnString release];
    }   
//    else
//    {
//        [[[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Please log-in to follow '%@'", userFLname] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease] show];
//    
//    
//    }

}



-(void)backtoHome
{
    [_userBuildVideos release];
    [_userBuildVideos removeFromSuperview];
    
    [self dismissModalViewControllerAnimated:YES];

}


-(void)buildUserView
{
    curSW = [[UIScreen mainScreen] bounds].size.width;
    curSH = [[UIScreen mainScreen] bounds].size.height;
    int lblFontsize;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        lblFontsize = 22;
        
    }
    else
    {
        
        lblFontsize = 35;
        
    }   

    
    UIView *vl_TempView = [[UIView alloc] initWithFrame:CGRectMake(0, ((36.0/480)*curSH), self.view.frame.size.width ,(96.0/480)*curSH )];
   
    vl_TempView.backgroundColor = [UIColor clearColor];
    
    [vl_MainView addSubview:vl_TempView];
    
    
    
    
    
    
    
    photoButton *btnUserPic;
    btnUserPic=[[photoButton alloc]initWithFrame:CGRectMake(((20.0/320)*curSW), ((8.0/480)*curSH), ((53.0/320)*curSW), ((51.0/480)*curSH))];
    btnUserPic.userInteractionEnabled=NO;
    
    [vl_TempView addSubview:btnUserPic];
    
    
    /*cache loader*/
    
    /*URL CACHE  CHECK*/
    NSArray *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* lastComponent = [NSString stringWithFormat:@"%@.jpg",pageUserId];
    NSString *path = [[searchPath objectAtIndex:0]  stringByAppendingString:[NSString stringWithFormat:@"/thumbData/%@",lastComponent]];
    
    NSLog(@"path --- %@",path);
    
    NSLog(@"user id = %@",pageUserId);
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) 
    {
        //path = [NSString stringWithFormat:@"file://localhost/private%@",path];
       

        NSData *dataImage = [NSData dataWithContentsOfFile:path];
        [(photoButton*)btnUserPic setBackgroundImage:[UIImage imageWithData:dataImage] forState:UIControlStateNormal];
    }else
    {
        [(photoButton*)btnUserPic loadImage:userImage isLast:TRUE];   
    }
    
    /**************/
   
    
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(((87.0/320)*curSW), ((5.0/480)*curSH), ((216.0/320)*curSW), ((27.0/480)*curSH))];
    userName.font = [UIFont fontWithName:@"BigNoodleTitling" size:lblFontsize];
    userName.textColor = [UIColor colorWithRed:0/255.0 green:181/255.0 blue:220/255.0 alpha:1];
    
    userName.textAlignment = UITextAlignmentLeft;
    
    userName.text = userFLname;
    userName.backgroundColor = [UIColor clearColor];
    
    
    NSLog(@"user name text = %@",userName.text);
    [vl_TempView addSubview:userName];
    
    [userName release];

    
    
    
  if(notifyCount>0 && [appDelegate.userID isEqualToString:pageUserId])
  {
    
        UIImage *tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"img_notify_iphone" ofType:@"png"]];

        UIButton *btnNotify;
        btnNotify=[UIButton buttonWithType:UIButtonTypeCustom];
        btnNotify.frame = CGRectMake(88,55, 25, 23);
        [btnNotify setImage:tempImage forState:UIControlStateNormal];
        [btnNotify addTarget:self action:@selector(showNotifyPopup) forControlEvents:UIControlEventTouchUpInside];
        [vl_TempView  addSubview:btnNotify];
        [tempImage release];


        if (newNotifyCount>=1) 
        {

            lblNotifyCount = [[UILabel alloc] initWithFrame:CGRectMake(0,-2, 25, 23)];
            lblNotifyCount.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            lblNotifyCount.textColor = [UIColor colorWithRed:113.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:1];
            lblNotifyCount.textAlignment = UITextAlignmentCenter;
            lblNotifyCount.text = [NSString stringWithFormat:@"%d",newNotifyCount];
            lblNotifyCount.backgroundColor = [UIColor clearColor];
            [btnNotify addSubview:lblNotifyCount];
            [lblNotifyCount release]; 
            UILabel *lblNotifications = [[UILabel alloc] initWithFrame:CGRectMake(120,55, 200, 26)];
            lblNotifications.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
            lblNotifications.textColor = [UIColor colorWithRed:0/255.0 green:189.0/255.0 blue:159.0/255.0 alpha:1];
            lblNotifications.text = @"Notifications";
            lblNotifications.backgroundColor = [UIColor clearColor];
            [vl_TempView addSubview:lblNotifications];
            [lblNotifications release];

        }
        else
        {
              //lblNotifyCount.hidden = YES;
              //btnNotify.hidden = YES;
            lblNotifyCount = [[UILabel alloc] initWithFrame:CGRectMake(0,-2, 25, 23)];
            lblNotifyCount.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            lblNotifyCount.textColor = [UIColor colorWithRed:113.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:1];
            lblNotifyCount.textAlignment = UITextAlignmentCenter;
            lblNotifyCount.text = [NSString stringWithFormat:@"%d",0];
            lblNotifyCount.backgroundColor = [UIColor clearColor];
            [btnNotify addSubview:lblNotifyCount];
            [lblNotifyCount release]; 
            UILabel *lblNotifications = [[UILabel alloc] initWithFrame:CGRectMake(120,55, 200, 26)];
            lblNotifications.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
            lblNotifications.textColor = [UIColor colorWithRed:0/255.0 green:189.0/255.0 blue:159.0/255.0 alpha:1];
            lblNotifications.text = @"Notifications";
            lblNotifications.backgroundColor = [UIColor clearColor];
            [vl_TempView addSubview:lblNotifications];
            [lblNotifications release];
            
          
        }
   
      
   
  }  
    
    
    
    lblRank = [[UILabel alloc]initWithFrame:CGRectMake(((87.0/320)*curSW), 26, 50, 30)];
    lblRank.text = @"RANK";
    lblRank.font = [UIFont boldSystemFontOfSize:14.0];
    lblRank.textColor = [UIColor whiteColor];
    lblRank.backgroundColor = [UIColor clearColor];
    [vl_TempView addSubview:lblRank];
    
    lblRankText = [[UILabel alloc]initWithFrame:CGRectMake(((137.0/320)*curSW), 34, 25, 15)];
    lblRankText.text = [rankDefaults valueForKey:@"rank"];
    lblRankText.font = [UIFont boldSystemFontOfSize:13.0];
    
    lblRankText.textColor = [UIColor colorWithRed:0/255.0 green:181/255.0 blue:220/255.0 alpha:1];
    lblRankText.textAlignment = UITextAlignmentCenter;
    lblRankText.backgroundColor = [UIColor whiteColor];
    [vl_TempView addSubview:lblRankText];

      
    [vl_TempView release];

}

-(void)showNotifyPopup
{
    boolFollow = 0;

    if (notifyCount<=0) {
        return;
    }
    
    
    if (_notifyView) 
    {

        _notifyView.hidden =NO;
        [self.view bringSubviewToFront:_notifyView];
    
    }
    else
    {

    
        _notifyView = [[UIView alloc] initWithFrame:CGRectMake(35, 80, 250, 320)];
        _notifyView.backgroundColor = [UIColor whiteColor];
        _notifyView.layer.borderColor = [UIColor grayColor].CGColor;
        _notifyView.layer.borderWidth = 5;
        _notifyView.layer.cornerRadius = 10;
        [self.view addSubview:_notifyView];
        
        
        UIView *_notifyTabView = [[UIView alloc] initWithFrame:CGRectMake(0, 4, 250, 25)];
        _notifyTabView.backgroundColor = [UIColor grayColor];
        _notifyTabView.layer.cornerRadius = 5;
        [_notifyView addSubview:_notifyTabView];
        [_notifyTabView release];
        
        UIImage *tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"img_cancelRecord_iphone" ofType:@"png"]];
        UIButton *btnCancel;
        btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
        btnCancel.frame = CGRectMake(230, 3, 15, 15);
        [btnCancel setImage:tempImage forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(dismissNotifyView) forControlEvents:UIControlEventTouchUpInside];
        [_notifyTabView  addSubview:btnCancel];
        [tempImage release];

        
        aTableView =[[UITableView alloc]initWithFrame:CGRectMake(0,29.5, 250 ,285)];
        [aTableView setBackgroundColor:[UIColor clearColor]];
        [aTableView setShowsVerticalScrollIndicator:NO];
        [aTableView setDelegate:self];
        [aTableView setDataSource:self];
        
        aTableView.separatorColor=[UIColor grayColor];
        aTableView.backgroundColor  = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];

        [_notifyView addSubview:aTableView];
	 
    }

    lblNotifyCount.text = [NSString stringWithFormat:@"%d",newNotifyCount];
    
    
    
    [self performSelectorInBackground:@selector(resetNotifications) withObject:nil];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    
    if (boolFollow==0) {
        
        return notifyCount;

    }
    else
    {
        return userCount;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return [indexPath row] * 20;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        return 50;
        
    }
    else
    {
        return 75;
    }
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
    
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (boolFollow==0)
    {
    
    
    /*-------Adding Image to Cell--------Start---- */ 
    photoButton *button;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        button=[[photoButton alloc]initWithFrame:CGRectMake(10,2.5, 45, 45)];
        
    }
    else
    {    
        button=[[photoButton alloc]initWithFrame:CGRectMake(12, 8, 56, 54)];
        
    }
    button.userInteractionEnabled=NO;
     
    
    if (notifyCount==1)
    {
        [(photoButton*)button loadImage:[[notifyDetails valueForKey:@"uimg"]objectForKey:@"text"] isLast:TRUE];
    }
    else  if (notifyCount>1)
    {
        [(photoButton*)button loadImage:[[[aNnotifyDetails objectAtIndex:[indexPath row]]objectForKey:@"uimg"]objectForKey:@"text"]isLast:TRUE]; 
    } 
    
    
    if ([indexPath row]< newNotifyCount ) 
    {
        cell.contentView.backgroundColor  = [UIColor groupTableViewBackgroundColor];
    }
    
    
    [cell.contentView addSubview:button]; 
    [button release];
    /*-------Adding Image to Cell--------END----*/
    
    
    
    /*-------Adding Title to Cell--------Start---- */ 
    int lblFontSize;
    UILabel *messageLabel, *hoursMessage;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        messageLabel=[[UILabel alloc]initWithFrame:CGRectMake(60,0,190,25)];
        hoursMessage=[[UILabel alloc]initWithFrame:CGRectMake(60,25,190,25)];
        lblFontSize = 8;
    }
    else
    {    
        messageLabel=[[UILabel alloc]initWithFrame:CGRectMake(100,0,500,75)];
         hoursMessage=[[UILabel alloc]initWithFrame:CGRectMake(60,0,190,25)];
        lblFontSize = 40;
    }
	messageLabel.font = [UIFont boldSystemFontOfSize:lblFontSize];
    messageLabel.textColor=[UIColor blackColor];
	messageLabel.backgroundColor=[UIColor clearColor];
    
    NSString *notifyType, *notifyMessage1, *notifyMessage2, *notifyMediaType;
    UIImage *tempImage;
    if (notifyCount==1)
    {
        notifyType = [[notifyDetails valueForKey:@"notify_type"]objectForKey:@"text"];
        
        notifyMediaType= [[notifyDetails valueForKey:@"notify_media_type"]objectForKey:@"text"];
        
        
        if ([notifyMediaType isEqualToString:@"1"])         notifyMediaType = @"video";
        else if ([notifyMediaType isEqualToString:@"2"])    notifyMediaType = @"photo";
        
        
        if ([notifyType isEqualToString:@"3"]) {
            tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"notifyTag_iphone" ofType:@"png"]];
            notifyMessage1=[NSString stringWithFormat:@"%@ Tagged you in a %@",[[notifyDetails valueForKey:@"uname"]objectForKey:@"text"], notifyMediaType];
        }
        else if ([notifyType isEqualToString:@"1"]) {
            tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"notifyComment2_iphone" ofType:@"png"]];
            notifyMessage1=[NSString stringWithFormat:@"%@ Commented on %@ '%@'",notifyMediaType, [[notifyDetails valueForKey:@"uname"]objectForKey:@"text"], [[notifyDetails valueForKey:@"vname"]objectForKey:@"text"]];
        }
        else if ([notifyType isEqualToString:@"2"]) {
            tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"notifyLike_iphone" ofType:@"png"]];
            notifyMessage1=[NSString stringWithFormat:@"%@ Like your %@ '%@'",notifyMediaType, [[notifyDetails valueForKey:@"uname"]objectForKey:@"text"], [[notifyDetails valueForKey:@"vname"]objectForKey:@"text"]];
        }
        
        notifyMessage2=[NSString stringWithFormat:@"          %@",[[notifyDetails valueForKey:@"vhours"]objectForKey:@"text"]];
    }
    else  if (notifyCount>1)
    {
        
        notifyType = [[[aNnotifyDetails objectAtIndex:[indexPath row]]objectForKey:@"notify_type"]objectForKey:@"text"];
        
        notifyMediaType = [[[aNnotifyDetails objectAtIndex:[indexPath row]]objectForKey:@"notify_media_type"]objectForKey:@"text"];
         NSLog(@"notifyMediaType --- %@",notifyMediaType);
        if ([notifyMediaType isEqualToString:@"1"])         notifyMediaType = @"video";
        else if ([notifyMediaType isEqualToString:@"2"])    notifyMediaType = @"photo";
        NSLog(@"notifyMediaType --- %@",notifyMediaType);
        
        
        
        if ([notifyType isEqualToString:@"3"]) {
             tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"notifyTag_iphone" ofType:@"png"]];
            notifyMessage1=[NSString stringWithFormat:@"%@ Tagged you in a %@",[[[aNnotifyDetails objectAtIndex:[indexPath row]]objectForKey:@"uname"]objectForKey:@"text"],notifyMediaType];
        }
        else if ([notifyType isEqualToString:@"1"]) {
            tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"notifyComment2_iphone" ofType:@"png"]];
            notifyMessage1=[NSString stringWithFormat:@"%@ Commented on %@ '%@'",[[[aNnotifyDetails objectAtIndex:[indexPath row]]objectForKey:@"uname"]objectForKey:@"text"],notifyMediaType, [[[aNnotifyDetails objectAtIndex:[indexPath row]]objectForKey:@"vname"]objectForKey:@"text"]];
        }
        else if ([notifyType isEqualToString:@"2"]) {
            tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"notifyLike_iphone" ofType:@"png"]];
            notifyMessage1=[NSString stringWithFormat:@"%@ Likes your %@ '%@'",[[[aNnotifyDetails objectAtIndex:[indexPath row]]objectForKey:@"uname"]objectForKey:@"text"], notifyMediaType,[[[aNnotifyDetails objectAtIndex:[indexPath row]]objectForKey:@"vname"]objectForKey:@"text"]];
        }
        
       notifyMessage2=[NSString stringWithFormat:@"          %@",[[[aNnotifyDetails objectAtIndex:[indexPath row]]objectForKey:@"vhours"]objectForKey:@"text"]];
        
	}
    messageLabel.text = notifyMessage1;
    //messageLabel.layer.borderColor = [UIColor greenColor].CGColor;
    //messageLabel.layer.borderWidth = 1.0;
    [cell addSubview:messageLabel];
    [messageLabel release];
    
    
    hoursMessage.font = [UIFont boldSystemFontOfSize:lblFontSize];
    hoursMessage.textColor=[UIColor blackColor];
	hoursMessage.backgroundColor=[UIColor clearColor];
    hoursMessage.text = notifyMessage2;
    //hoursMessage.layer.borderColor = [UIColor greenColor].CGColor;
    //hoursMessage.layer.borderWidth = 1.0;
    [cell addSubview:hoursMessage];
    [hoursMessage release];
    
    
    UIButton *imgButton=[[UIButton alloc]initWithFrame:CGRectMake(60,25,20,20)];
    [imgButton addTarget:self action:@selector(backtoHome) forControlEvents:UIControlEventTouchUpInside]; 
    
    [imgButton setImage:tempImage forState:UIControlStateNormal];
    
     
    [cell addSubview:imgButton];
    imgButton.userInteractionEnabled=NO;
    [imgButton release];
    
    
    }
    else
    {
        
        //NSLog(@"user = %@",[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"]);
        
        NSLog(@"user count = %d",userCount);
        
        if (userCount>1)
        {
        
        NSString *userImageUrl = [[[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectAtIndex:indexPath.row] objectForKey:@"user_img"] objectForKey:@"text"];
        
        
        NSString *strName = [[[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectAtIndex:indexPath.row] objectForKey:@"user_name"] objectForKey:@"text"];
        
        UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 30)];
        lblName.backgroundColor = [UIColor clearColor];
        lblName.textColor = [UIColor colorWithRed:250/255.0 green:204/255.0 blue:0/255.0 alpha:1.0];
        lblName.text = strName;
        
        lblName.font = [UIFont fontWithName:@"BigNoodleTitling" size:16];
        [cell.contentView addSubview:lblName];
        
        photoButton *btnUser;
        
        NSString *video_userId = [[[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectAtIndex:indexPath.row] objectForKey:@"video_id"] objectForKey:@"text"];
      
        btnUser=[[photoButton alloc]initWithFrame:CGRectMake(15, 5, 29, 30)];
            
        
        
        NSArray *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* lastComponent = [NSString stringWithFormat:@"%@.jpg",video_userId];
        NSString *path = [[searchPath objectAtIndex:0]  stringByAppendingString:[NSString stringWithFormat:@"/thumbData/%@",lastComponent]];
        
        NSLog(@"path --- %@",path);
        
        if ([[NSFileManager defaultManager]fileExistsAtPath:path]) 
        {
            NSLog(@"cache");
            path = [NSString stringWithFormat:@"file://localhost/private%@",path];
            NSData *dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
            [(photoButton*)btnUser setBackgroundImage:[UIImage imageWithData:dataImage] forState:UIControlStateNormal];
        }else
        {
            NSLog(@"online");
            [(photoButton*)btnUser loadImage:userImageUrl isLast:TRUE];  
        }
        
        [btnUser addTarget:self action:@selector(selectedUserProfile:) forControlEvents:UIControlEventTouchUpInside];
        int userId = [[[[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectAtIndex:indexPath.row] objectForKey:@"user_id"] objectForKey:@"text"] intValue];        
        btnUser.tag = userId;
        btnUser.videoUserId = [[[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectAtIndex:indexPath.row] objectForKey:@"user_id"] objectForKey:@"text"];
        [cell.contentView addSubview:btnUser];
        }
        else
        {
            NSString *userImageUrl = [[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectForKey:@"user_img"] objectForKey:@"text"];
            
            
            NSString *strName = [[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectForKey:@"user_name"] objectForKey:@"text"];
            
            UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 30)];
            lblName.backgroundColor = [UIColor clearColor];
            lblName.textColor = [UIColor colorWithRed:250/255.0 green:204/255.0 blue:0/255.0 alpha:1.0];
            lblName.text = strName;
            
            lblName.font = [UIFont fontWithName:@"BigNoodleTitling" size:16];
            [cell.contentView addSubview:lblName];
            
            photoButton *btnUser;
            
            NSString *video_userId = [[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectForKey:@"video_id"] objectForKey:@"text"];
            
            btnUser=[[photoButton alloc]initWithFrame:CGRectMake(15, 5, 29, 30)];
            
            
            
            NSLog(@"app data - %@",appDelegate.listData);
            NSArray *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* lastComponent = [NSString stringWithFormat:@"%@.jpg",video_userId];
            NSString *path = [[searchPath objectAtIndex:0]  stringByAppendingString:[NSString stringWithFormat:@"/thumbData/%@",lastComponent]];
            
            NSLog(@"path --- %@",path);
            
            if ([[NSFileManager defaultManager]fileExistsAtPath:path]) 
            {
                
                path = [NSString stringWithFormat:@"file://localhost/private%@",path];
                NSData *dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
                [(photoButton*)btnUser setBackgroundImage:[UIImage imageWithData:dataImage] forState:UIControlStateNormal];
            }else
            {
                [(photoButton*)btnUser loadImage:userImageUrl isLast:TRUE];  
            }
            
            [btnUser addTarget:self action:@selector(selectedUserProfile:) forControlEvents:UIControlEventTouchUpInside];
            int userId = [[[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectForKey:@"user_id"] objectForKey:@"text"] intValue];        
            btnUser.tag = userId;
            btnUser.videoUserId = [[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectForKey:@"user_id"] objectForKey:@"text"];
            NSLog(@"video user id = %@",btnUser.videoUserId);
            [cell.contentView addSubview:btnUser];

        }
        
    }
    
    
	
	return cell;
        
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (boolFollow==0)
    {
    
        if(notifyCount==1)
        {
            //
        
        }else
        {
            appDelegate.videoTagId = [[[[aNnotifyDetails objectAtIndex:[indexPath row]]objectForKey:@"vid"]objectForKey:@"text"] intValue];
        }
        _notifyView.hidden =YES;
        [aTableView release];
        aTableView = nil;
        [self videoSelected];
    }
    else
    {
        for (UIButton*button in [tableView cellForRowAtIndexPath:indexPath].contentView.subviews
) {
            if ([button isKindOfClass:[UIButton class]]) {
                [self selectedUserProfile:button];
            }
        }
       
    }
    
}




-(void)selectedUserProfile:(id)sender
{
    //int userId = [sender tag];
   // self.pageUserId = [NSString stringWithFormat:@"%d",userId];
    self.pageUserId = [sender videoUserId];
    NSLog(@"sender tag = %d",[sender tag]);
    [backgroundImageView removeFromSuperview];
    
    [vl_MainView removeFromSuperview];
    
    setY = @"down";
    
    [self viewDidLoad];   
    
    [self viewDidAppear:YES];
}


-(void)dismissNotifyView
{
    boolFollow=1;
    _notifyView.hidden =YES;

}

-(void)buildVideolisting
{
    curSW = [[UIScreen mainScreen] bounds].size.width;
    curSH = [[UIScreen mainScreen] bounds].size.height;

   
    if (bildListingTab==TRUE) 
    {
        
        vl_View = [[UIView alloc] initWithFrame:CGRectMake(0, ((124.0/480)*curSH), self.view.frame.size.width ,(350.0/480)*curSH )];            
        
        
        vl_View.backgroundColor = [UIColor clearColor];
        [vl_MainView addSubview:vl_View];
        [vl_View release];

        /*set video listing tab buttons  --- Start */
        
        int btnSpace, tabFontFize; 
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            tabFontFize = 10;
        }
        else
        {
            tabFontFize = 25;
        }
        
        btnSpace = (2.0/320)*curSW;
        UIView *vl_vlTabView;
        
        
        if ([setY isEqualToString:@"down"])
        {

            vl_vlTabView = [[UIView alloc] initWithFrame:CGRectMake(0, 6, self.view.frame.size.width ,(35.0/480)*curSH )];
        }
        else
        {
            vl_vlTabView = [[UIView alloc] initWithFrame:CGRectMake(0, -2, self.view.frame.size.width ,(35.0/480)*curSH )];
        }
        
        [vl_View addSubview:vl_vlTabView];
        
        vl_vlTabView.backgroundColor = [UIColor clearColor];
        
        
        
        
        btnContent  = [UIButton buttonWithType:UIButtonTypeCustom];
        btnContent.frame = CGRectMake(0, 0, (85.0/320)*curSW, (35.0/480)*curSH);
        [btnContent setBackgroundImage:[UIImage imageNamed:@"content_select.png"] forState:UIControlStateNormal];
        [btnContent addTarget:self action:@selector(contentSelected) forControlEvents:UIControlEventTouchUpInside];
        [btnContent setBackgroundColor:[UIColor clearColor]];
        [vl_vlTabView addSubview:btnContent];
        
        btnFollowing  = [UIButton buttonWithType:UIButtonTypeCustom];
        btnFollowing.frame = CGRectMake(btnContent.frame.origin.x+btnContent.frame.size.width+3, 0, (70.0/320)*curSW, (35.0/480)*curSH);
        [btnFollowing addTarget:self action:@selector(followingSelected) forControlEvents:UIControlEventTouchUpInside];
        [btnFollowing setBackgroundColor:[UIColor clearColor]];

        [btnFollowing setBackgroundImage:[UIImage imageNamed:@"following_deselect.png"] forState:UIControlStateNormal];

        [vl_vlTabView addSubview:btnFollowing];
        
        
        btnFollowers  = [UIButton buttonWithType:UIButtonTypeCustom];
        btnFollowers.frame = CGRectMake(btnFollowing.frame.origin.x+btnFollowing.frame.size.width+3, 0, (73.0/320)*curSW, (35.0/480)*curSH);
        [btnFollowers addTarget:self action:@selector(followersSelected) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [btnFollowers setBackgroundColor:[UIColor clearColor]];

        [btnFollowers setBackgroundImage:[UIImage imageNamed:@"followers_deselect.png"] forState:UIControlStateNormal];

        [vl_vlTabView addSubview:btnFollowers];
        
        
        
        
        
        
//        btnStarring  = [UIButton buttonWithType:UIButtonTypeCustom];
//        btnStarring.frame = CGRectMake(btnFollowers.frame.origin.x+btnFollowers.frame.size.width+3, 0, (83.0/320)*curSW, (35.0/480)*curSH);
//        [btnStarring addTarget:self action:@selector(starringSelected) forControlEvents:UIControlEventTouchUpInside];
//        
//        
//        
//        [btnStarring
//         setBackgroundColor:[UIColor clearColor]];
//
//        [btnStarring setBackgroundImage:[UIImage imageNamed:@"starring_deselect.png"] forState:UIControlStateNormal];
//
//        
//        [vl_vlTabView addSubview:btnStarring];
        
        
    }   
    
    
    
    
    /*Build Videos  --- Start */
    
    _userBuildVideos = [[userBuildVideos alloc] initWithFrame:CGRectMake(((9.0/320)*curSW), ((26.0/480)*curSH) ,((303.0/320)*curSW), ((324.0/480)*curSH))];
    _userBuildVideos.backgroundColor=[UIColor clearColor];
    
    _userBuildVideos._delegate = self;
    
    // _userBuildVideos.currentPage = 1;
    
    // _userBuildVideos.videoCount = [[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",1]]objectForKey:@"recordcnt"] objectForKey:@"text"] intValue];
    

    if (contentSelected) {
        
        _userBuildVideos.urlStr = @"media.video-list-recent";
    }
//    else if (followingSelected) {
//        _userBuildVideos.urlStr = @"user.following";
//        
//    }
//    else if (followersSelected) {
//        _userBuildVideos.urlStr = @"user.followers";
//        
//    }
    else if (starringSelected) {
        _userBuildVideos.urlStr = @"media.video-starring";
        
    }

    
    [vl_View addSubview:_userBuildVideos];
    
    _avloader  = [[avloader alloc] initWithFrame:CGRectMake(50, 50, 100 , 100)]; 
    _avloader.backgroundColor = [UIColor clearColor];
    [_userBuildVideos addSubview:_avloader];
    [_userBuildVideos bringSubviewToFront:_avloader];
    
    [_avloader initLoaderWithSize:CGSizeMake(100, 100)];
    
    [self performSelectorInBackground:@selector(enableLoader) withObject:self];
    
    
    /*Build Videos  --- End */
    
    /*set video listing tab buttons  --- End */

    [vl_MainView addSubview:vl_BottomTabView];
    
}

-(void)contentSelected
{
    if (contentSelected) {
        return;
    }
    
    [self performSelectorInBackground:@selector(enableLoader) withObject:nil];
    
    btnContribute.hidden = NO;
    buttonFollower.hidden = NO;
    contentSelected = TRUE; 
    followingSelected = followersSelected = starringSelected = FALSE;
    bildListingTab = FALSE;

    [listTableView removeFromSuperview];
    [message removeFromSuperview];
    [btnContent setBackgroundImage:[UIImage imageNamed:@"content_select.png"] forState:UIControlStateNormal];
    [btnFollowing setBackgroundImage:[UIImage imageNamed:@"following_deselect.png"] forState:UIControlStateNormal];
    [btnFollowers setBackgroundImage:[UIImage imageNamed:@"followers_deselect.png"] forState:UIControlStateNormal];
    //[btnStarring setBackgroundImage:[UIImage imageNamed:@"starring_deselect.png"] forState:UIControlStateNormal];
    
    //[_userBuildVideos release];
    [_userBuildVideos removeFromSuperview];
    [appDelegate fetchVideoListing:@"media.video-list-recent"uid:pageUserId setCurrentPage:currentPage];
    [self buildVideolisting];
    
    [self performSelector:@selector(disableLoader) withObject:nil afterDelay:0.5];

}
-(void)followingSelected
{
    if (followingSelected) {
        return;
    }
    
    [self performSelectorInBackground:@selector(enableLoader) withObject:nil];
    
    btnContribute.hidden = YES;
    buttonFollower.hidden = YES;
    followingSelected = TRUE; 
    contentSelected = followersSelected = starringSelected = FALSE;
    bildListingTab = FALSE;
    boolFollow =1;
    
    [listTableView removeFromSuperview];
    [message removeFromSuperview];
    [btnContent setBackgroundImage:[UIImage imageNamed:@"content_deselect.png"] forState:UIControlStateNormal];
    [btnFollowing setBackgroundImage:[UIImage imageNamed:@"followers_select.png"] forState:UIControlStateNormal];
    [btnFollowers setBackgroundImage:[UIImage imageNamed:@"followers_deselect.png"] forState:UIControlStateNormal];
    //[btnStarring setBackgroundImage:[UIImage imageNamed:@"starring_deselect.png"] forState:UIControlStateNormal];

    
    //[_userBuildVideos release];
    [_userBuildVideos removeFromSuperview];
    [appDelegate fetchVideoListing:@"user.following"uid:self.pageUserId setCurrentPage:currentPage];
    //[self buildVideolisting];
    userCount = [[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"recordcnt"] objectForKey:@"text"] intValue];
       
    if (userCount>0)
    {
        
        [vl_View addSubview:listTableView];
        [listTableView reloadData];

    }
    else
    {

        message.frame = CGRectMake(((50.0/320)*curSW), ((39.0/480)*curSH), ((280.0/320)*curSW), ((300.0/480)*curSH));
        message.text = @"No one following";
        [vl_View addSubview:message];
        

    }
    
    [self performSelector:@selector(disableLoader) withObject:nil afterDelay:0.5];

}
-(void)followersSelected
{

    if (followersSelected) {
        return;
    }
    [self performSelectorInBackground:@selector(enableLoader) withObject:nil];
    
    btnContribute.hidden = YES;
    buttonFollower.hidden = YES;
    followersSelected = TRUE; 
    followingSelected =contentSelected = starringSelected = FALSE;
    bildListingTab = FALSE;
   
    boolFollow =1;
    
    
    [btnContent setBackgroundImage:[UIImage imageNamed:@"content_deselect.png"] forState:UIControlStateNormal];
    [btnFollowing setBackgroundImage:[UIImage imageNamed:@"following_deselect.png"] forState:UIControlStateNormal];
    [btnFollowers setBackgroundImage:[UIImage imageNamed:@"following_select.png"] forState:UIControlStateNormal];
    //[btnStarring setBackgroundImage:[UIImage imageNamed:@"starring_deselect.png"] forState:UIControlStateNormal];
    
    //[_userBuildVideos release];
    [_userBuildVideos removeFromSuperview];
    [appDelegate fetchVideoListing:@"user.followers"uid:pageUserId setCurrentPage:currentPage];
    //[self buildVideolisting];
   
    
    [listTableView removeFromSuperview];
    
    [message removeFromSuperview];
    
    userCount = [[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"recordcnt"] objectForKey:@"text"] intValue];
    
    
    if (userCount>0)
    {

        [vl_View addSubview:listTableView];
        
        [listTableView reloadData];

    }
    else
    {

        
        message.frame = CGRectMake(((30.0/320)*curSW), ((39.0/480)*curSH), ((280.0/320)*curSW), ((300.0/480)*curSH));
        
        message.text = @"No followers found";
        [vl_View addSubview:message];
        
        

    }
    
    
    
    [self performSelector:@selector(disableLoader) withObject:nil afterDelay:0.5];

}
-(void)starringSelected
{

    if (starringSelected) {
        return;
    }
    btnContribute.hidden = YES;
    buttonFollower.hidden = YES;
    starringSelected = TRUE; 
    followingSelected = followersSelected = contentSelected = FALSE;
    bildListingTab = FALSE;
    [listTableView removeFromSuperview];

    [message removeFromSuperview];
    [btnContent setBackgroundImage:[UIImage imageNamed:@"content_deselect.png"] forState:UIControlStateNormal];
    [btnFollowing setBackgroundImage:[UIImage imageNamed:@"following_deselect.png"] forState:UIControlStateNormal];
    [btnFollowers setBackgroundImage:[UIImage imageNamed:@"followers_deselect.png"] forState:UIControlStateNormal];
    //[btnStarring setBackgroundImage:[UIImage imageNamed:@"starring_select.png"] forState:UIControlStateNormal];

    //[_userBuildVideos release];
    [_userBuildVideos removeFromSuperview];
    [appDelegate fetchVideoListing:@"media.video-starring"uid:pageUserId setCurrentPage:currentPage];
    [self buildVideolisting];
    
    [self performSelector:@selector(disableLoader) withObject:nil afterDelay:0.5];

}

 


-(void)userSelected
{

    if (contentSelected) {
        return;
    }
    self.pageUserId = [NSString stringWithFormat:@"%@",appDelegate.selectedUserId];
    
    [backgroundImageView removeFromSuperview];
    
    [vl_MainView removeFromSuperview];
    
    [self viewDidLoad];
    

}

-(void)videoSelected    
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

-(void)viewWillAppear:(BOOL)animated
{

    if (appDelegate.loginFlag) {
        [self redirectToLogin];
    }

}


- (void)viewDidAppear:(BOOL)animated
{
 
//    if(vl_MainView==nil)   [self viewDidLoad];
//
//    if(appDelegate.userID==nil)
//    {
//        [self viewDidLoad];
//    }
    if (appDelegate.redirectToRoot == TRUE) {
        appDelegate.boolFlag = 1;
        
        [self dismissModalViewControllerAnimated:YES];
    }
     appDelegate.boolFlag = 0;
     [self performSelector:@selector(disableLoader) withObject:nil afterDelay:0.5];
    
}   
-(void)dealloc
{


    if (_notifyView) {
        [_notifyView release];
    }

}

-(void)refreshList
{
    
    [self performSelectorInBackground:@selector(enableLoader) withObject:self];

    
    if (contentSelected) {
        [appDelegate fetchVideoListing:@"media.video-list-recent"uid:self.pageUserId setCurrentPage:currentPage];
    }else if (starringSelected) {
        [appDelegate fetchVideoListing:@"media.video-starring"uid:self.pageUserId setCurrentPage:currentPage];
    }
    
    [listTableView removeFromSuperview];
    [_userBuildVideos removeFromSuperview];
    
    
    [self buildVideolisting];
    
    
    if (![appDelegate.userID isEqualToString:pageUserId]) 
    {
        btnFollowers.hidden = YES;
        btnFollowing.hidden = YES;
        //btnStarring.hidden = YES;
    }
    
    [self performSelector:@selector(disableLoader) withObject:nil afterDelay:0.5];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
