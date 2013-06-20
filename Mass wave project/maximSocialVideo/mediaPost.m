//
//  mediaPost.m
//  maximSocialVideo
//
//  Created by neo on 06/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "mediaPost.h"
 


epubstore_svcAppDelegate *appDelegate;

@implementation mediaPost

@synthesize latit, longit,locationManager;
@synthesize reverseGeocoder;
@synthesize locationString;
@synthesize _FBfriendsListCon;
@synthesize _userVL;

@synthesize friendsList;

 

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

 
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height)];
    
    backgroundImageView.image = [UIImage imageNamed:@"bg_2_blue.png"];
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
       
    
   /* UIAlertView *alertLogout = [[UIAlertView alloc] init];
    [alertLogout setTitle:@"Use your current location?"];
    [alertLogout setMessage:@"This allwos location information in photos and videos"];
    [alertLogout setDelegate:self];
    [alertLogout addButtonWithTitle:@"Don't Allow"];
    [alertLogout addButtonWithTitle:@"Ok"];
    [alertLogout show];
    [alertLogout releabse];
*/
    
    
      
     appDelegate.mediaPosted = FALSE;
    
    
}


-(void)initMediaPost
{

    appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.boolVideoPlayer = 1;

    
    //appDelegate.postVideoUrl = nil;
    [[UIApplication sharedApplication] setStatusBarStyle:YES];
    
    vl_MainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height+20)];
    [self.view addSubview:vl_MainView];
    
    
    //[self performSelector:@selector(presentVideoMode) withObject:nil afterDelay:0.5];
    
    
    vl_MainView.backgroundColor = [UIColor clearColor];
    
    [self setTabbuttons];
    
    [self buildUser];
    
    [self buildCustomVideo];
    
    [self buildLocationView];
    
    [self buildDescView];
    
    [self buildBottomTab];
    
    [self createTableView];
    
    
   [self performSelector:@selector(setFullScreenTrue) withObject:nil afterDelay:1];

    
    


}

-(void)createTableView
{
    
    UILabel *labelTag = [[UILabel alloc] initWithFrame:CGRectMake((20.0/320)*curSW , 320,300 ,21)];
    labelTag.text = @"TAG OTHERS";
    
    labelTag.textColor = [UIColor whiteColor];
    
    labelTag.backgroundColor = [UIColor clearColor];
    
    labelTag.font = [UIFont fontWithName:@"Helvetica" size:21];
    
    
    [self.view addSubview:labelTag];

    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    
    appDelegate.videoTaggedIds = tempArray;
    
    [tempArray release];
    
    [self fetchFriendsList];
    
    aTableView =[[UITableView alloc]initWithFrame:CGRectMake(0,340, 320 ,75)];
    [aTableView setBackgroundColor:[UIColor clearColor]];
    [aTableView setShowsVerticalScrollIndicator:YES];
    [aTableView setDelegate:self];
    [aTableView setDataSource:self];
    
    aTableView.separatorColor=[UIColor clearColor];
    
    [self.view addSubview:aTableView];	

}

-(void)fetchFriendsList
{
    
    NSString *urlString =[NSString stringWithFormat:@"%@media/list",ServerIp];
    
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // setting up the request object now
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    NSLog(@"urlString----%@",urlString);
    
    NSString *myParameters = [NSString stringWithFormat:@"method=user.friends&user_id=%@", appDelegate.FBfriendsIds];
    
    NSLog(@"myParameters -- %@",myParameters);
    
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    // now lets make the connection to the web
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"fetchVideoDetails ---- %@",returnString);
    
    NSError *error;
    
    
    
    
    if (returnString) 
    {
        
        self.friendsList = [XMLReader1  dictionaryForXMLString:returnString error:&error];
        
        
        NSLog(@"%@",self.friendsList);
        
        appDelegate.myarray = [[self.friendsList objectForKey:@"Tagged"]objectForKey:@"user"];
        
        
    }
    
    tagArray = [[NSMutableArray alloc] init];
    for (int i=0;i<[appDelegate.myarray count];i++)
    {
        [tagArray addObject:@"Tag"];
    }
    
    
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    
    
    if ([ appDelegate.myarray isKindOfClass:[NSDictionary class]])
    {
        return 1;
        
    }
    else
    {
        return [appDelegate.myarray count];
        
    }
	
	
	
	
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return [indexPath row] * 20;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        return 39;
        
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
	
    /*-------Adding Image to Cell--------Start---- */ 
    photoButton *button;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        button=[[photoButton alloc]initWithFrame:CGRectMake(20, 5, 32, 29)];
        
    }
    else
    {    
        button=[[photoButton alloc]initWithFrame:CGRectMake(32, 8, 56, 54)];
        
    }
    button.userInteractionEnabled=NO;
    //NSLog(@"%@",[[[appDelegate.myarray objectAtIndex:indexPath.row] objectAtIndex:0]objectForKey:@"pic"]);
    
//    if ([ appDelegate.myarray isKindOfClass:[NSDictionary class]])
//    {
//        [(photoButton*)button loadImage:[[appDelegate.myarray valueForKey:@"uimg"]objectForKey:@"text"] isLast:TRUE];
//    }
//    else
//    {
//        [(photoButton*)button loadImage:[[[appDelegate.myarray objectAtIndex:[indexPath row]]objectForKey:@"uimg"]objectForKey:@"text"] isLast:TRUE]; 
//    }  
    /*URL CACHE  CHECK*/
//    NSString *tempStr ;
//    if ([ appDelegate.myarray isKindOfClass:[NSDictionary class]])
//    {
//        tempStr = [[appDelegate.myarray valueForKey:@"uimg"]objectForKey:@"text"] ;
//    }
//    else
//    {
//        tempStr = [[[appDelegate.myarray objectAtIndex:[indexPath row]]objectForKey:@"uimg"]objectForKey:@"text"]; 
//    }  
//    
//    NSArray *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString* lastComponent = tempStr;
//    NSString *path = [[searchPath objectAtIndex:0]  stringByAppendingString:[NSString stringWithFormat:@"/thumbData/%@",lastComponent]];
//    
//    NSLog(@"path --- %@",path);
//    
//    
//    
//    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) 
//    {
//        //path = [NSString stringWithFormat:@"file://localhost/private%@",path];
//        NSData *dataImage = [NSData dataWithContentsOfFile:path];
//        [(photoButton*)button setBackgroundImage:[UIImage imageWithData:dataImage] forState:UIControlStateNormal];
//        
//        
//    }else
//    {
//        [(photoButton*)button loadImage:tempStr isLast:TRUE]; 
//        
//    }
    
    
    
    /////////////////////////////////////////////////////////////
    
    
    
    
    
    
    
    //[cell.contentView addSubview:button]; 
    //[button release];
    /*-------Adding Image to Cell--------END----*/
    
    
    /*-------Adding Title to Cell--------Start---- */ 
    int lblFontSize;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(20,0,212,36)];
        lblFontSize = 18;
    }
    else
    {    
        nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(20,0,500,75)];
        lblFontSize = 40;
    }
	nameLabel.font = [UIFont fontWithName:@"BigNoodleTitling" size:lblFontSize];
    nameLabel.textColor=[UIColor yellowColor];
	nameLabel.backgroundColor=[UIColor clearColor];
    
    
    if ([ appDelegate.myarray isKindOfClass:[NSDictionary class]])
    {
        //nameLabel.text=[NSString stringWithFormat:@"%@ %@",[[appDelegate.myarray valueForKey:@"fname"]objectForKey:@"text"] , [[appDelegate.myarray valueForKey:@"lname"]objectForKey:@"text"]];
        
        nameLabel.text=[NSString stringWithFormat:@"%@",[[appDelegate.myarray valueForKey:@"uname"]objectForKey:@"text"]];
    }
    else
    {
        
        //nameLabel.text=[NSString stringWithFormat:@"%@ %@",[[[appDelegate.myarray objectAtIndex:[indexPath row]]objectForKey:@"fname"]objectForKey:@"text"] , [[[appDelegate.myarray objectAtIndex:[indexPath row]]objectForKey:@"lname"]objectForKey:@"text"]];
        
        nameLabel.text=[NSString stringWithFormat:@"%@",[[[appDelegate.myarray objectAtIndex:[indexPath row]]objectForKey:@"uname"]objectForKey:@"text"]];
        
	}
    
    [cell addSubview:nameLabel];
    // nameLabel.layer.borderColor = [UIColor greenColor].CGColor;
    
    // nameLabel.layer.borderWidth = 1.0;
    
    [nameLabel release];
    /*-------Adding Title to Cell--------END---- */
    
    
    
    
    
    
    /*-------Adding CheckList Button to Cell--------Start---- */ 
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        button=[[photoButton alloc]initWithFrame:CGRectMake(260, 0, 60, 37)];
        
        
    }
    else
    {    
        button=[[photoButton alloc]initWithFrame:CGRectMake(600, 8, 56, 54)];
        
        
    }
    //[button addTarget:self action:@selector(tagging) forControlEvents:UIControlEventTouchUpInside]; 
    
    
    
    //[button setTitle:@"Tag" forState:UIControlStateNormal];
    
    [button setTitle:[tagArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];

    
    (button).titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:15];
    
    button.tag = [indexPath row]+1;
    
    
    if ([ appDelegate.myarray isKindOfClass:[NSDictionary class]])
    {
        button.videoUserId  = [[appDelegate.myarray valueForKey:@"uid"]objectForKey:@"text"]; }
    else
    {
        button.videoUserId  = [[[appDelegate.myarray objectAtIndex:[indexPath row]]objectForKey:@"uid"]objectForKey:@"text"];
    }
    [button setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
    //button.layer.borderColor = [UIColor greenColor].CGColor;
    //button.layer.borderWidth = 1.0;
    [button addTarget:self action:@selector(addRemoveTag:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [cell.contentView addSubview:button]; 
    [button release];
    
    
    /*-------Adding CheckList Button--------END----*/
    
    
	
	return cell;
}

-(void)addRemoveTag:(photoButton*)sender
{
    
    NSString *UserId = sender.videoUserId;
    int userTab = [sender tag]-1;
    
    
    if ([appDelegate.videoTaggedIds containsObject:UserId] ) 
    {
        
        [appDelegate.videoTaggedIds removeObject:UserId];
        //UIButton *tempButton = (UIButton *)[self.view viewWithTag:userTab];
        [sender setTitle:@"Tag" forState:UIControlStateNormal];
        //[tempButton release];
        
        [tagArray replaceObjectAtIndex:userTab withObject:@"Tag"];

        
        
    }
    else
    {
        
        [appDelegate.videoTaggedIds addObject:UserId];
        //UIButton *tempButton = (UIButton *)[self.view viewWithTag:userTab];
        [sender setTitle:@"UnTag" forState:UIControlStateNormal];
        //[tempButton release];
        
        [tagArray replaceObjectAtIndex:userTab withObject:@"UnTag"];

        
        
    }
    
    
    
    
    
    NSLog(@"appDelegate.videoTaggedIds Count --- %d", [appDelegate.videoTaggedIds count]);
    
    NSLog(@"appDelegate.videoTaggedIds --- %@", appDelegate.videoTaggedIds);
    
    
}


//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//	if (buttonIndex == 0)
//	{
//       //No
//        
//	}
//	else if (buttonIndex == 1)
//	{
//        
//        if (self.locationManager!=nil) 
//        {
//            [self.locationManager release];
//            self.locationManager = nil;
//        }
//        
//        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
//        self.locationManager.delegate = self;
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        self.locationManager.distanceFilter = kCLDistanceFilterNone;
//        [self.locationManager startUpdatingLocation];
//        
//
//        //[self performSelector:@selector(presentVideoMode) withObject:nil afterDelay:0.5];
//        //[self presentVideoMode];
//	}
//    
//    btnCancel.userInteractionEnabled        =   YES;
//    btnStartRecord.userInteractionEnabled   =   YES;
//    btnLibrary.userInteractionEnabled       =   YES;
//}
//
//    
// 
//
//
//
//-(void)presentVideoMode
//{
//    
//	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
//	{
//
//		
//        
//        imagePickerController = [[UIImagePickerController alloc] init];
//		imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//		imagePickerController.allowsEditing = YES;
//        imagePickerController.showsCameraControls = NO;
//        
//		imagePickerController.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];//[NSArray arrayWithObject:(NSString *)kUTTypeMovie];
//        
//        
//        
//       /* UIAlertView *alertLogout = [[UIAlertView alloc] init];
//        [alertLogout setTitle:@"Use your current location?"];
//        [alertLogout setMessage:@"This allows location information in photos and videos"];
//        [alertLogout setDelegate:self];
//        [alertLogout addButtonWithTitle:@"Don't Allow"];
//        [alertLogout addButtonWithTitle:@"Ok"];
//        [alertLogout show];
//        [alertLogout release];
//       */ 
//             
//         
//       
//
//        
//        
//        
//UIView *vl_BottomTabView1 = [[UIView alloc] initWithFrame:CGRectMake(0,(400.0/480)*curSH, self.view.frame.size.width ,(54.0/480)*curSH )];
//vl_BottomTabView1.backgroundColor = [UIColor grayColor];
//        
//        
//        
//        
//       		
//        
//        
//        [imagePickerController.view addSubview:vl_BottomTabView1];
//        [imagePickerController.view bringSubviewToFront:vl_BottomTabView1];
//
//        
//        imagePickerController.delegate = self;
//		[self presentModalViewController:imagePickerController animated:YES];
//
//       
//        
//        UIImage *tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"img_flipCamera_iphone" ofType:@"png"]];
//        
//        
//        btnFlipCam=[UIButton buttonWithType:UIButtonTypeCustom];
//        btnFlipCam.frame = CGRectMake(255, 5, 60, 45);
//        [btnFlipCam setImage:tempImage forState:UIControlStateNormal];
//        [btnFlipCam addTarget:self action:@selector(flipCamera) forControlEvents:UIControlEventTouchUpInside];
//        [imagePickerController.view  addSubview:btnFlipCam];
//        [tempImage release];
//        
//        
//        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"img_cancelRecord_iphone" ofType:@"png"]];
//        btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
//        btnCancel.frame = CGRectMake(5, 430, 60, 45);
//        [btnCancel setImage:tempImage forState:UIControlStateNormal];
//        [btnCancel addTarget:self action:@selector(dismissCamera) forControlEvents:UIControlEventTouchUpInside];
//        [imagePickerController.view  addSubview:btnCancel];
//        btnCancel.userInteractionEnabled=NO;
//        [tempImage release];
//        
//        
//        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ing_startRecord_iphone" ofType:@"png"]];
//        btnStartRecord=[UIButton buttonWithType:UIButtonTypeCustom];
//        btnStartRecord.frame = CGRectMake(130, 430, 60, 45);
//        [btnStartRecord setImage:tempImage forState:UIControlStateNormal];
//        [btnStartRecord addTarget:self action:@selector(startVideoRecording) forControlEvents:UIControlEventTouchUpInside];
//        btnStartRecord.userInteractionEnabled=NO;
//        [imagePickerController.view  addSubview:btnStartRecord];
//        [tempImage release];
//        
//        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ing_stopRecord_iphone" ofType:@"png"]];
//        btnStopRecord=[UIButton buttonWithType:UIButtonTypeCustom];
//        btnStopRecord.frame = CGRectMake(130, 430, 60, 45);
//        [btnStopRecord setImage:tempImage forState:UIControlStateNormal];
//        [btnStopRecord addTarget:self action:@selector(StopVideoRecording) forControlEvents:UIControlEventTouchUpInside];
//        btnStopRecord.hidden = YES;
//        [imagePickerController.view  addSubview:btnStopRecord];
//        [tempImage release];
//        
//        
//        
//        
//        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"img_library_iphone" ofType:@"png"]];
//        
//        
//        btnLibrary=[UIButton buttonWithType:UIButtonTypeCustom];
//        btnLibrary.frame = CGRectMake(265, 430, 60, 45);
//        [btnLibrary setImage:tempImage forState:UIControlStateNormal];
//        [btnLibrary addTarget:self action:@selector(goToLibrary) forControlEvents:UIControlEventTouchUpInside];
//        btnLibrary.userInteractionEnabled=NO;
//        [imagePickerController.view  addSubview:btnLibrary];
//        
//        
//        [tempImage release];
//
//	}
//    else
//    {
//        [self performSelector:@selector(goToLibrary1) withObject:nil afterDelay:0.5];
//    }
//    
//    
//    
//    btnCancel.userInteractionEnabled        =   YES;
//    btnStartRecord.userInteractionEnabled   =   YES;
//    btnLibrary.userInteractionEnabled       =   YES;
//    
//    
//}
//


-(void)moveViewUp
{
    self.view.center = CGPointMake((384.0/768)*self.view.frame.size.width , (512.0/1024)*self.view.frame.size.height);
    [UIView beginAnimations:@"TEST" context:nil];
    [UIView setAnimationDuration:0.25];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        self.view.center = CGPointMake((384.0/768)*self.view.frame.size.width , (360.0/1024)*self.view.frame.size.height);
    }
    else
    {
        self.view.center = CGPointMake((384.0/768)*self.view.frame.size.width , (250.0/1024)*self.view.frame.size.height);
    }
    [UIView commitAnimations];
}
-(void)resetViewDown
{
    [UIView beginAnimations:@"TEST" context:nil];
    [UIView setAnimationDuration:0.25];
    self.view.center = CGPointMake((384.0/768)*self.view.frame.size.width , (512.0/1024)*self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{   [self moveViewUp];      }

-(void)textViewDidBeginEditing:(UITextView *)textView   {   [self moveViewUp];      }

-(void)textFieldDidEndEditing:(UITextField *)textField  {   [self resetViewDown];   }

-(void)textViewDidEndEditing:(UITextField *)textView    {   [self resetViewDown];   }

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{ 
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textViewShouldReturn:(UITextField *)textView
{
   [textView resignFirstResponder];
   return YES;
}



-(void)setFullScreenTrue
{
    
    [_customVideoPlayer setFullScreen:true];
    
    [self performSelector:@selector(setFullScreenFalse) withObject:nil afterDelay:0.1];

}
-(void)setFullScreenFalse
{
    
    [_customVideoPlayer setFullScreen:FALSE];
    
}

-(void)setTabbuttons
{
    
    curSW = [[UIScreen mainScreen] bounds].size.width;
    curSH = [[UIScreen mainScreen] bounds].size.height;
    
    int tabFontFize, tabheight;//, tabButtonW, tabButtonH;
    UIButton *button1;  
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        tabFontFize = 10;
        tabheight = 32;
        
    }
    else
    {
        
        tabFontFize = 25;
        tabheight = 52;
        
        
    }    
    
    
    
    button1=[[UIButton alloc]initWithFrame:CGRectMake((10.0/320)*curSW, 25, (20.0/320)*curSW , (20.0/480)*curSH )];
    
    
    
    
    vl_TabsView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, self.view.frame.size.width ,(34.0/480)*curSH )];
    //vl_TabsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width ,tabheight )];
    vl_TabsView.backgroundColor = [UIColor clearColor];
    [vl_MainView addSubview:vl_TabsView];
    [vl_UserView release];
    
    
    
    [button1 addTarget:self action:@selector(backtoHome) forControlEvents:UIControlEventTouchUpInside]; 
    
    [button1 setBackgroundImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:button1];
    //[button1 release];

    
    
//    UIButton *btnTag=[UIButton buttonWithType:UIButtonTypeCustom];
//    btnTag.frame = CGRectMake((258.0/320)*curSW, 20, (50.0/320)*curSW , (33.0/480)*curSH );
//    [btnTag addTarget:self action:@selector(tagging) forControlEvents:UIControlEventTouchUpInside]; 
//    [btnTag setTitle:@"Tag" forState:UIControlStateNormal];
//    (btnTag).titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:20];
//    [btnTag setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
//    btnTag.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:btnTag];
    // btnTag.layer.borderColor = [UIColor greenColor].CGColor;
    // btnTag.layer.borderWidth = 1;
    //[button2 release];
    
}

-(void)tagging
{
    
     
    
    
   if ([[textTitle text] length]==0) 
    {
        
        [[[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter title" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease] show];
    
    }
    else if ([[textTitle text] length] <= 4 || [[textTitle text] length] > 25) 
    {
    
        [[[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter title between 5 to 25 characters" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease] show];
    
    }
    else 
      
    {
        
        appDelegate.postTitle = [textTitle text];
        appDelegate.postDescription =  [textDescription text];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            _FBfriendsListCon = [[facebookdetailtable alloc] initWithNibName:@"mmsvViewController_iPhone" bundle:nil];
            
        }
        else
        {
            _FBfriendsListCon = [[facebookdetailtable alloc] initWithNibName:@"mmsvViewController_iPad" bundle:nil];
        }
        
        _FBfriendsListCon._delegate = self;
        
        [self presentModalViewController:_FBfriendsListCon animated:YES];
    }
}





//-(void)backtoHome
//{
//    
//    if (_customVideoPlayer) 
//    {
//     
//        [_customVideoPlayer stopAndRemoveVideo];
//    
//    }   
//    
//    [self dismissModalViewControllerAnimated:YES];
//    
//}
-(void)buildUser
{
    int  tabFontFize;//, tabheight;//, tabButtonW;//, tabButtonH;
    int fontsize;
    
    curSW = [[UIScreen mainScreen] bounds].size.width;
    curSH = [[UIScreen mainScreen] bounds].size.height;
    
    photoButton *button,  *lblButton;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        tabFontFize = 22;
        fontsize=15;
     }
    else
    {
        tabFontFize = 25;
        fontsize=30;
    }    
    
    vl_UserView = [[UIView alloc] initWithFrame:CGRectMake(0,vl_TabsView.frame.size.height+10, self.view.frame.size.width ,(45.0/480)*curSH   )];
    vl_UserView.backgroundColor = [UIColor clearColor ];
    [vl_MainView addSubview:vl_UserView];
    
    //vl_UserView.layer.borderColor = [UIColor redColor].CGColor;
    //vl_UserView.layer.borderWidth = 1;
    
    
    
    
    
    button=[[photoButton alloc]initWithFrame:CGRectMake((15.0/320)*curSW, (16.0/480)*curSH, (25.0/320)*curSW, (25.0/480)*curSH)];
    
    button.videoUserId = appDelegate.userID;
    //[button addTarget:self action:@selector(selectedUser:) forControlEvents:UIControlEventTouchUpInside];
    [(photoButton*)button loadImage:appDelegate.logedUserImg isLast:TRUE]; 
    [vl_UserView addSubview:button];
    //button.layer.borderColor = [UIColor blueColor].CGColor;
    //button.layer.borderWidth = 1;
    
    
    
    lblButton= [photoButton buttonWithType:UIButtonTypeCustom];
    lblButton.frame = CGRectMake((49.0/320)*curSW,(16.0/480)*curSH,(297.0/320)*curSW,(28.0/480)*curSH);
                                 //(45/320)*curSW, (13/480)*curSH, (260/320)*curSW, (33/480)*curSH);
    [lblButton setTitle:appDelegate.logedUserFLName forState:UIControlStateNormal];
    lblButton.videoUserId = appDelegate.userID;
    //[lblButton addTarget:self action:@selector(selectedUser:) forControlEvents:UIControlEventTouchUpInside];
    //[lblButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    lblButton.titleLabel.font =[UIFont fontWithName:@"BigNoodleTitling" size:23]; 
    [lblButton setTitleColor:[UIColor colorWithRed:0/255.0 green:181/255.0 blue:220/255.0 alpha:1] forState:UIControlStateNormal];

    
    lblButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    //lblButton.layer.borderColor = [UIColor redColor].CGColor;
    //lblButton.layer.borderWidth = 1;
    
    [vl_UserView addSubview:lblButton];
    
    
     
    [vl_UserView release];
     
    
    
    
    
}

-(void)buildDescView
{
    
    int  tabFontFize, tabheight, tabButtonW, tabButtonH;
    int commentsX, commentsY, commentsW, commentsH;
    curSW = [[UIScreen mainScreen] bounds].size.width;
    curSH = [[UIScreen mainScreen] bounds].size.height;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        tabFontFize = 10;
        tabheight = 124;
        tabButtonW = 70;
        tabButtonH = 24; 
        
        
        commentsX = 15;
        commentsY = 0;
        commentsW = 301;
        commentsH = 124;
    }
    else
    {
        
        tabFontFize = 25;
        tabheight = 260;
        tabButtonW = 161;
        tabButtonH = 52; 
        
        commentsX = 35;
        commentsY = 0;
        commentsW = 701;
        commentsH = 262;
        
        
    }    
    
    
    vl_videoDescView = [[UIView alloc] initWithFrame:CGRectMake(0,(90.0/320)*curSW, self.view.frame.size.width ,(126.0/480)*curSH )];
    vl_videoDescView.backgroundColor = [UIColor clearColor];
    [vl_MainView addSubview:vl_videoDescView];
    
    //vl_videoDescView.layer.borderColor = [UIColor blueColor].CGColor;
    //vl_videoDescView.layer.borderWidth = 1;
    
    UILabel *lblcontribute = [[UILabel alloc] initWithFrame:CGRectMake((20.0/320)*curSW  ,(5.0/480)*curSH , (280.0/320)*curSW, (28.0/480)*curSH )];
    
    lblcontribute.text = @"Contribute";
    
    lblcontribute.textColor = [UIColor whiteColor];
    
    lblcontribute.backgroundColor = [UIColor clearColor];
    
    lblcontribute.font = [UIFont fontWithName:@"BigNoodleTitling" size:23];
    
    [vl_videoDescView addSubview:lblcontribute];
    
    textTitle = [[UITextField alloc] initWithFrame:CGRectMake((20.0/320)*curSW  ,(40.0/480)*curSH , (282.0/320)*curSW, (28.0/480)*curSH )];
    textTitle.borderStyle = UITextBorderStyleNone ;//UITextBorderStyleRoundedRect;
    textTitle.textColor = [UIColor blackColor]; //text color
    textTitle.font = [UIFont systemFontOfSize:20.0];  //font size
    textTitle.placeholder = @"Title";  //place holder
    textTitle.backgroundColor = [UIColor whiteColor]; //background color
    textTitle.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
    textTitle.keyboardType = UIKeyboardTypeDefault;  // type of the keyboard
    textTitle.returnKeyType = UIReturnKeyDone;  // type of the return key
    textTitle.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
    textTitle.delegate = self;
    

    
    
    [vl_videoDescView addSubview:textTitle];
    
    
//    textDescription = [[UITextView alloc] initWithFrame:CGRectMake((22.0/320)*curSW  ,(40.0/480)*curSH , (280.0/320)*curSW, (55.0/320)*curSH )];
//    textDescription.delegate = self;
//    
//     
//    [[NSNotificationCenter defaultCenter] addObserver:self 
//											 selector:@selector(setFullScreenFalse) 
//												 name:UITextViewTextDidBeginEditingNotification 
//											   object:textTitle];
//    
//    [vl_videoDescView addSubview:textDescription];
    
    
    
    /*
    
    textDescription = [[UITextField alloc] initWithFrame:CGRectMake((26.0/320)*curSW  ,(58.0/480)*curSH , (280.0/320)*curSW, (63.0/320)*curSH )];
    textDescription.borderStyle = UITextBorderStyleNone ;//UITextBorderStyleRoundedRect;
    textDescription.textColor = [UIColor blackColor]; //text color
    textDescription.font = [UIFont systemFontOfSize:15.0];  //font size
    textDescription.placeholder = @"Description";  //place holder
    textDescription.backgroundColor = [UIColor whiteColor]; //background color
    textDescription.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
    textDescription.keyboardType = UIKeyboardTypeDefault;  // type of the keyboard
    textDescription.returnKeyType = UIReturnKeyDone;  // type of the return key
    textDescription.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
    textDescription.delegate = self;
    //textDescription.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
    textDescription.layer.borderColor = [UIColor yellowColor].CGColor;
    textDescription.layer.borderWidth = 1;
    
    [vl_videoDescView addSubview:textDescription];
    */
    
    
    
    
    
    
    
    [vl_videoDescView release];
    
     
}


-(void)doit
{




}

 

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}

 


-(void)buildCustomVideo
{
    int  tabFontFize, tabheight, tabButtonW, tabButtonH, playerX, playerY, playerW, playerH;
    
    
     curSW = [[UIScreen mainScreen] bounds].size.width;
     curSH = [[UIScreen mainScreen] bounds].size.height;
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        tabFontFize = 10;
        tabheight = 200;
        tabButtonW = 70;
        tabButtonH = 24; 
        
        playerX=15;
        playerY=0;
        playerW=281;
        playerH=200;
    }
    else
    {
        
        tabFontFize = 25;
        tabheight = 468;
        tabButtonW = 161;
        tabButtonH = 52; 
        
        playerX=36;
        playerY=0;
        playerW=698;
        playerH=468;
        
        
    }
    
    
    playerX=(20.0/320)*curSW;
    playerY=(3/480)*curSH;
    playerW=(302.0/320)*curSW;
    playerH=(150.0/480)*curSH;
    
    
    
    
    vl_VideoView = [[UIView alloc] initWithFrame:CGRectMake(0,(165), self.view.frame.size.width ,(160.0/480)*curSH )];
    vl_VideoView.backgroundColor = [UIColor clearColor];
    [vl_MainView addSubview:vl_VideoView];
    
    
    
    
    
    
    _customVideoPlayer = [[customVideoPlayer alloc] initWithFrame:CGRectMake(playerX, playerY, playerW, playerH)];
    
    //_customVideoPlayer.videoPlayUrl = [[NSURL alloc] init];
    
    _customVideoPlayer.videoUrl = appDelegate.postVideoUrl;
    
    _customVideoPlayer._delegate = self;
    
    NSLog(@"appDelegate.postVideoUrl%@", appDelegate.postVideoUrl);
    
    //appDelegate.postVideoUrl = self.videoUrl;
         
    [_customVideoPlayer initCustomVideoPlayer];
    
    
    [vl_VideoView addSubview:_customVideoPlayer];
    
    
    //_customVideoPlayer =[_customVideoPlayer setOrientation:UIDeviceOrientationPortrait animated:NO];
    
    [_customVideoPlayer release];
    
    
    
    //controlTabH;
    //UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(15, 162, 281, 38) ];
    //tempView.backgroundColor = [UIColor colorWithRed:0/255.0 green:135/255.0 blue:130/255.0 alpha:1 ];
    //   /[vl_VideoView addSubview:tempView];
      
    
    
    [vl_VideoView release];
    
}



-(void)buildLocationView
{
    int  tabFontFize, tabheight, tabButtonW, tabButtonH;
    
    int   fontsize;
    
    curSW = [[UIScreen mainScreen] bounds].size.width;
    curSH = [[UIScreen mainScreen] bounds].size.height;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        tabFontFize = 15;
        tabheight = 28;
        tabButtonW = 70;
        tabButtonH = 24; 
        
         
        fontsize=10;
        
    }
    else
    {
        
        tabFontFize = 25;
        tabheight   = 62;
        tabButtonW  = 161;
        tabButtonH  = 52; 
        
       
        fontsize=30;
        
    }    
    
    vl_LocationView = [[UIView alloc] initWithFrame:CGRectMake(0,(vl_VideoView.frame.size.height+vl_TabsView.frame.size.height+vl_UserView.frame.size.height), self.view.frame.size.width ,(27.0/480)*curSH )];
    vl_LocationView.backgroundColor = [UIColor clearColor];
    [vl_MainView addSubview:vl_LocationView];
    [vl_LocationView release];
    
    
    UILabel *txtLabel;
     
     
  
    
    
    fontsize=14;
    
    txtLabel = [[UILabel alloc] initWithFrame:CGRectMake((9.0/320)*curSW, (0/480)*curSH, (302.0/320)*curSW, (25.0/480)*curSH)];
    
    txtLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:fontsize];
    
    txtLabel.textColor = [UIColor colorWithRed:146.0/255.0 green:24.0/255.0 blue:28.0/255.0 alpha:1];
    
    //NSLog(@"self.locationString ====== %@",self.locationString);
    
    //txtLabel.text = self.locationString;
    
    vl_LocationView.backgroundColor = [UIColor clearColor];
    
    txtLabel.backgroundColor = [UIColor clearColor];
    
    [vl_LocationView addSubview:txtLabel];
    
    
    //txtLabel.layer.borderColor = [UIColor greenColor].CGColor;
    
    //txtLabel.layer.borderWidth = 1;
    
    [txtLabel release];
    
    
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
    
    vl_BottomTabView = [[UIView alloc] initWithFrame:CGRectMake(0,(430.0/480)*curSH, self.view.frame.size.width ,(50.0/480)*curSH)];
    vl_BottomTabView.backgroundColor = [UIColor blackColor];
    [vl_MainView addSubview:vl_BottomTabView];
    
    
    
    
    //home_button.png
    
//    UIButton *btnHome;
//    btnHome=[UIButton buttonWithType:UIButtonTypeCustom];
//    btnHome.frame = CGRectMake(15,7,30,30);
//    [btnHome setImage:tempImage2 forState:UIControlStateNormal];
//    [btnHome addTarget:self action:@selector(backtoRoot) forControlEvents:UIControlEventTouchUpInside];
//    
//    [vl_BottomTabView addSubview:btnHome];
//    
//    
//    
//    
//    UIButton *button;
//    button=[UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(270, 5, 30, 30);
//    [button setImage:tempImage forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(goTologedUser) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *btnCancelToHome  = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    btnCancelToHome.frame = CGRectMake((11.0/320)*curSW,0,(86.0/320)*curSW,(50.0/480)*curSH);
//    
//    btnCancelToHome.backgroundColor = [UIColor clearColor];
//    
//    [btnCancelToHome addTarget:self action:@selector(backtoHome) forControlEvents:UIControlEventTouchUpInside];
//    [btnCancelToHome setTitle:@"CANCEL" forState:UIControlStateNormal];
//    //[btnShare setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
//    (btnCancelToHome).titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:15];
//    [btnCancelToHome setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
//    
//    
//    [btnCancelToHome  setCusLable:@"" initWithFrame:CGRectMake(0, 0, (86.0/320)*curSW, (5.0/480)*curSH) bgColor:[UIColor colorWithRed:0/255.0 green:255.0/255.0 blue:139.0/255.0 alpha:1]];
//
//    
//    [vl_BottomTabView addSubview:btnCancelToHome];

    
    UIButton *btnAbout  = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnAbout.frame = CGRectMake((320-47)/2,15,(47.0/320)*curSW,(18.0/480)*curSH);
    
    btnAbout.backgroundColor = [UIColor clearColor];
    
    [btnAbout addTarget:self action:@selector(resignKeboard) forControlEvents:UIControlEventTouchUpInside];
    //[btnAbout setTitle:@"Submit" forState:UIControlStateNormal];
    //[btnShare setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    //(btnAbout).titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:15];
    //[btnAbout setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
    [btnAbout setBackgroundImage:[UIImage imageNamed:@"btn_submit.png"] forState:UIControlStateNormal];
    
    //[btnAbout  setCusLable:@"" initWithFrame:CGRectMake(0, 0, (86.0/320)*curSW, (5.0/480)*curSH) bgColor:[UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:116.0/255.0 alpha:1]];
    
    [vl_BottomTabView addSubview:btnAbout];
    
    [vl_BottomTabView release];
    
    
}

-(void)resignKeboard
{
    
    [textTitle resignFirstResponder];
    [textDescription resignFirstResponder];
    
    
    
    [self performSelector:@selector(postMedia) withObject:nil afterDelay:0.5];
    
}

-(void)postMedia
{
    
    
    //[self resetViewDown];
    if ([[textTitle text] length]==0) 
    {
        
        [[[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter title" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease] show];
        [textTitle becomeFirstResponder];
        
    }
    else if ([[textTitle text] length] <= 4 || [[textTitle text] length] > 25) 
    {
        
        [[[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter title between 5 to 25 characters" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease] show];
        [textTitle becomeFirstResponder];
        
    }
    else if ([[textDescription text] length] > 1000) 
    {
        
        [[[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter description below 1000 characters" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease] show];
        [textDescription becomeFirstResponder];
        
    }
    else 
    {
        
        [self performSelectorInBackground:@selector(startAnimatingAV) withObject:nil];
        
        NSString *postTagedIds1, *postTagedIds2;
        
        appDelegate.postTitle = [textTitle text];
        
        appDelegate.postDescription =  [textDescription text];
        
        if ([appDelegate.videoTaggedIds count]>0) {
            postTagedIds1 = [NSString stringWithFormat:@"%@",[appDelegate.videoTaggedIds description]];
            //postTagedIds2 = [NSString stringWithFormat:@"%@",appDelegate.videoTaggedIds];
            
        }
        else
        {
            postTagedIds1 = postTagedIds2 = @"";
        }
        NSString *categoryId = [[NSString alloc] init];
        categoryId = @"57";
        
        NSLog(@"category id = %@",categoryId);
        
        NSString *urlString =[NSString stringWithFormat:@"%@media/list?user_id=%@&method=media.video-add&title=%@&desc=%@&location=chennai&tagids=%@&orentation=%d&media_catid=%@",ServerIp, appDelegate.userID,appDelegate.postTitle, @"" ,postTagedIds1,appDelegate.captureOrientation,categoryId];
        
        urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        // setting up the request object now
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:urlString]]; 
        NSLog(@"urlString----%@",urlString);
        NSLog(@"postvideourl-->%@",appDelegate.postVideoUrl);
        NSData *mediaData = [[NSData alloc] initWithContentsOfURL:appDelegate.postVideoUrl];
        NSString *mediaFileName =  [appDelegate.postVideoUrl lastPathComponent];
        [request setHTTPMethod:@"POST"];
        /*
         add some header info now
         we always need a boundary when we post a file
         also we need to set the content type
         ‰
         You might want to generate a random boundary.. this is just the same
         as my output from wireshark on a valid html post
         */
        NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"media_data\"; filename=\"%@\"\r\n", mediaFileName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:mediaData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        // setting the body of the post to the reqeust
        [request setHTTPBody:body];
        // now lets make the connection to the web
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"return string = %@",returnString);
        /**/
        _avloader.hidden = YES;
        [_avloader release];
        [_avloader removeFromSuperview];
        /**/
        
        //[[[[UIAlertView alloc] initWithTitle:@"Error" message:returnString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease] show];
        if (returnString) 
        {
            
            NSString  *success    = [self GetValueInXML:returnString SearchStr:@"success"];
            
            NSString  *message    = [self GetValueInXML:returnString SearchStr:@"message"]; 
            
            if ([success isEqualToString:@"1"]) 
            {
//               UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"Result" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                alert.tag = 10;
//                [alert show];
//                [alert release];
                
                appDelegate.mediaPosted = TRUE;
                
                appDelegate.redirectToRoot  =0;
                
                [self dismissModalViewControllerAnimated:YES]; 
                
                
            }
            else
            {
                [[[[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease] show];
                
            }
            
            
        }   
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag==10)
    {
    appDelegate.redirectToRoot  =0;
    
    [self dismissModalViewControllerAnimated:YES]; 
    }
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


-(void)startAnimatingAV
{
    _avloader  = [[avloader alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height+20)]; 
    _avloader.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
    [self.view addSubview:_avloader];
    [self.view bringSubviewToFront:_avloader];
    [_avloader initLoaderWithSize:CGSizeMake(100, 100)];
    
    
    _avloader.hidden = NO;
    
}
-(void)quitAndBackToHome
{
    if (_customVideoPlayer) 
    {
        [_customVideoPlayer stopAndRemoveVideo];
    }   
    [self dismissModalViewControllerAnimated:YES];

}


-(void)backtoHome
{
    if ( appDelegate.mediaPosted==TRUE) 
    {
        [self quitAndBackToHome];
    }
    else
    {
        UIAlertView *alertPost = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Video will not be saved. please post it!... " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok post it", nil];
        alertPost.delegate = self;
        alertPost.tag = 200;
        [alertPost show];
        [alertPost release];
    
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==200) {
        
        
        if (buttonIndex == 0) {
           [self quitAndBackToHome];
        }
        else if(buttonIndex ==1)
        {
            [self resignKeboard];
        }
        
    }
    

}


-(void)backtoRoot
{
    
    appDelegate.redirectToRoot = TRUE;
    [self dismissModalViewControllerAnimated:YES];
    
}


-(void)goTologedUser
{
    
    [self dismissMoviePlayerViewControllerAnimated];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        _userVL = [[userVideoListing alloc] initWithNibName:@"mmsvViewController_iPhone" bundle:nil];
        
    }
    else
    {
        _userVL = [[userVideoListing alloc] initWithNibName:@"mmsvViewController_iPad" bundle:nil];
    }
    
    
    
    appDelegate.selectedUserId = appDelegate.userID;
    
    _userVL.pageUserId = [NSString stringWithFormat:@"%@",appDelegate.selectedUserId];
    
    
    [self presentModalViewController:_userVL animated:YES];


}


//-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//	/*if ([errorLabel.text isEqualToString:@"Enable Your Location Service in Settings"]) {
//     errorLabel.text=@"";
//     }*/
//	
//    
//    
//    NSLog(@"locationManager");
//    
//	//self.view.userInteractionEnabled=YES;
//	locationCoordinate=[newLocation coordinate];
//	if (!self.latit && !self.longit) {
//		
//		//locationMatch=YES;
//		self.latit=[newLocation coordinate].latitude;
//		self.longit=[newLocation coordinate].longitude;
//        
//        
//        // [self.locationManager stopUpdatingLocation];
//        NSLog(@"locationManager2");
//        self.reverseGeocoder =[[[MKReverseGeocoder alloc] initWithCoordinate:locationCoordinate] autorelease];
//        self.reverseGeocoder.delegate = self;
//        [self.reverseGeocoder start];
//        
//        NSLog(@"locationManager3");
//        
//        NSLog(@"%@%@",reverseGeocoder, locationManager);
//        
//        [self.locationManager stopUpdatingLocation];
//        
//        
//        ///
//        
//    }
//    
//    
//  
//    
//}
//
//-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//	if ([[error domain] isEqualToString: kCLErrorDomain] && [error code] == kCLErrorDenied) {
//        // The user denied your app access to location information.
//		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Maxim Would Like to Use Your Current Location"
//															message:@"Enable Your Location Service in Settings"
//														   delegate:nil
//												  cancelButtonTitle:@"OK"
//												  otherButtonTitles:nil];
//		[alertView show];
//		[alertView release];
//		//self.view.userInteractionEnabled=NO;
//        
//    }
//	
//	
//}
//
//
//- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
//{
//    /*NSString *errorMessage = [error localizedDescription];
//     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot obtain address."
//     message:errorMessage
//     delegate:nil
//     cancelButtonTitle:@"OK"
//     otherButtonTitles:nil];
//     [alertView show];
//     [alertView release];
//     */
//    //headingLabel.text=@"Location not found";
//}
//
//- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
//{
//	self.locationString =[NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@",placemark.thoroughfare,placemark.locality,placemark.subLocality,placemark.administrativeArea,placemark.subAdministrativeArea,placemark.postalCode];
//	self.locationString =[self.locationString stringByReplacingOccurrencesOfString:@",(null)" withString:@""];
//	self.locationString=[self.locationString stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
//	
//    
//    //[[[[UIAlertView alloc] initWithTitle:@"location" message:self.locationString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil] autorelease] show];
//    
//    
//	[self.reverseGeocoder cancel];
//    
//    [self.locationManager stopUpdatingLocation];
//}


 
- (void)viewDidAppear:(BOOL)animated
{
    
    if (appDelegate.redirectToRoot ==TRUE) 
    {
        [self dismissModalViewControllerAnimated:YES];
    } 
//    else
//    {
//        
//        [self setTabbuttons];
//        
//        [self buildUser];
//        
//        [self buildCustomVideo];
//        
//        [self buildLocationView];
//        
//        [self buildDescView];
//        
//        [self buildBottomTab];
//        
//        [self createTableView];
//        
//        
//        [self performSelector:@selector(setFullScreenTrue) withObject:nil afterDelay:1];
//    }
    
}



-(void)onExitFullScreen
{
    UIViewController *c = [[UIViewController alloc]init];
    [self presentModalViewController:c animated:NO];
    [self dismissModalViewControllerAnimated:NO];
    [c release];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


 

-(void)setFullScreenValueTrue
{
    fulscreen = TRUE;
    
}
-(void)setFullScreenValueFalse
{
    fulscreen = FALSE;
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    
    NSLog(@"1");
    
    
    
     
    
   //return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown && interfaceOrientation == UIInterfaceOrientationPortrait);
    
    
    
    
    
    if (fulscreen==TRUE) 
    {
        return YES;
    }
    else
    {
        return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown && interfaceOrientation == UIInterfaceOrientationPortrait);
    }   
   
    
     
    
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown && interfaceOrientation == UIInterfaceOrientationPortrait);
    
    
    
    // Return YES for supported orientations
     
}



-(void)dealloc
{
    
    
    
}

@end
