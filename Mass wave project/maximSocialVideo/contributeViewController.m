//
//  contributeViewController.m
//  maximSocialVideo
//
//  Created by Palani on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "contributeViewController.h"
#import "QuartzCore/QuartzCore.h"

@implementation contributeViewController

@synthesize pageUserId;

@synthesize userName;

@synthesize friendsList;

@synthesize strType;

@synthesize orientationStr;


@synthesize imageDict;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    photo_count = 0;
    
    imgView1.image = [imageDict valueForKey:@"0"];
    
    imgView1.hidden = NO;
    
    imgView2.hidden = YES;
    
    imgView3.hidden = YES;
    
    imgView4.hidden = YES;
    
    
    btn1.hidden = NO;
    
    btn2.hidden = YES;
    
    btn3.hidden = YES;
    
    btn4.hidden = YES;
    
    
    titleTextField.font = [UIFont fontWithName:@"Helvetica" size:22];
    
   
    titleTextField.layer.cornerRadius = 0.0001;
    
       
    contentTextView.text = @"Content";
    contentTextView.textColor = [UIColor lightGrayColor];
    
    
    lblName.text = appDelegate.logedUserFLName;
    
    [lblName setTextColor:[UIColor colorWithRed:0/255.0 green:181/255.0 blue:220/255.0 alpha:1]];
    
    lblName.font = [UIFont fontWithName:@"BigNoodleTitling" size:23];
    
    lblContribute.font = [UIFont fontWithName:@"BigNoodleTitling" size:22];
    
    contentTextView.font = [UIFont fontWithName:@"BigNoodleTitling" size:22];
    
    lblTagOthers.font = [UIFont fontWithName:@"BigNoodleTitling" size:22];
    
    /*cache loader*/
    
    /*URL CACHE  CHECK*/
//    NSArray *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString* lastComponent = [NSString stringWithFormat:@"%@.jpg",pageUserId];
//    NSString *path = [[searchPath objectAtIndex:0]  stringByAppendingString:[NSString stringWithFormat:@"/thumbData/%@",lastComponent]];
//    
//    
//    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) 
//    {
//        path = [NSString stringWithFormat:@"file://localhost/private%@",path];
//        NSData *dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
//        
//        [btnProfile setBackgroundImage:[UIImage imageWithData:dataImage] forState:UIControlStateNormal];
//    }

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",appDelegate.userID]];
    
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    
    [btnProfile setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
    
    

    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    
    appDelegate.videoTaggedIds = tempArray;
    
    [tempArray release];
    
    [self fetchFriendsList];
    
    aTableView =[[UITableView alloc]initWithFrame:CGRectMake(0,280, 320 ,150)];
    [aTableView setBackgroundColor:[UIColor clearColor]];
    [aTableView setShowsVerticalScrollIndicator:YES];
    [aTableView setDelegate:self];
    [aTableView setDataSource:self];
    
    aTableView.separatorColor=[UIColor clearColor];
    
    [self.view addSubview:aTableView];	
    
    
   appDelegate.mediaPosted = FALSE;

}

-(void)fetchFriendsList
{
    
    NSString *urlString =[NSString stringWithFormat:@"%@media/list",ServerIp];
    
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // setting up the request object now
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    
    NSString *myParameters = [NSString stringWithFormat:@"method=user.friends&user_id=%@", appDelegate.FBfriendsIds];
    
    
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    // now lets make the connection to the web
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSError *error;
    
    
    
    
    if (returnString) 
    {
        
        self.friendsList = [XMLReader1  dictionaryForXMLString:returnString error:&error];
        
        
        
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
    
	
    /*-------Adding Image to Cell--------Start---- */ 
    photoButton *button;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        button=[[photoButton alloc]initWithFrame:CGRectMake(10, 5, 32, 29)];
        
    }
    else
    {    
        button=[[photoButton alloc]initWithFrame:CGRectMake(32, 8, 56, 54)];
        
    }
    button.userInteractionEnabled=NO;
    
    
//    if ([ appDelegate.myarray isKindOfClass:[NSDictionary class]])
//    {
//        [(photoButton*)button loadImage:[[appDelegate.myarray valueForKey:@"uimg"]objectForKey:@"text"] isLast:TRUE];
//    }
//    else
//    {
//        [(photoButton*)button loadImage:[[[appDelegate.myarray objectAtIndex:[indexPath row]]objectForKey:@"uimg"]objectForKey:@"text"] isLast:TRUE]; 
//    }   
//    [cell.contentView addSubview:button]; 
//    [button release];
    /*-------Adding Image to Cell--------END----*/
    
    
    /*-------Adding Title to Cell--------Start---- */ 
    int lblFontSize;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,0,212,36)];
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
       // nameLabel.text=[NSString stringWithFormat:@"%@ %@",[[appDelegate.myarray valueForKey:@"fname"]objectForKey:@"text"] , [[appDelegate.myarray valueForKey:@"lname"]objectForKey:@"text"]];
        
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
        button=[[photoButton alloc]initWithFrame:CGRectMake(267, 0, 60, 37)];
        
        
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
    
    }
	
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
       // UIButton *tempButton = (UIButton *)[self.view viewWithTag:userTab];
        [sender setTitle:@"UnTag" forState:UIControlStateNormal];
        //[tempButton release];
        [tagArray replaceObjectAtIndex:userTab withObject:@"UnTag"];
        
        
    }
    
    
}


-(IBAction)btnUpload
{
    if (appDelegate.reachability==FALSE)
    {
        UIAlertView *alertLogout = [[UIAlertView alloc] init];
        [alertLogout setTitle:@"No network connection"];
        [alertLogout setDelegate:self];
        [alertLogout addButtonWithTitle:@"OK"];
        alertLogout.tag = 1003; 
        
        [alertLogout show];
        [alertLogout release];
        return;
        
    }
    
    if (appDelegate.userID && [strType isEqualToString:@"video"]) 
    {
        
        [self presentVideoMode];
        
        
    }
    else if (appDelegate.userID && [strType isEqualToString:@"photo"])
    {
        //[self presentPhotoMode];
        
        if ([imageDict count]<4)
        {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Take Photo From Library" ,@"Cancel",nil];
        actionSheet.actionSheetStyle =UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
        [actionSheet release];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Sorry, maximum 4 photos can be uploaded" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            
            [alertView release];
        }
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) 
    {
        
        [self presentPhotoMode];
        
        
    } 
    else if (buttonIndex==1)
    {
        [self presentPhotoLibrary];
        
    }
    else if (buttonIndex==2)
    {
        
    }
   
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
    
    
    
    btnCancel.userInteractionEnabled        =   YES;
    btnStartRecord.userInteractionEnabled   =   YES;
    btnLibrary.userInteractionEnabled       =   YES;
    
    
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
        btnCancel.frame = CGRectMake(5, 430, 60, 45);
        [btnCancel setImage:tempImage forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(dismissCamera) forControlEvents:UIControlEventTouchUpInside];
        [imagePickerController.view  addSubview:btnCancel];
        btnCancel.userInteractionEnabled=NO;
        [tempImage release];
        
        
        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ing_startRecord_iphone" ofType:@"png"]];
        btnStartRecord=[UIButton buttonWithType:UIButtonTypeCustom];
        btnStartRecord.frame = CGRectMake(130, 430, 60, 45);
        [btnStartRecord setImage:tempImage forState:UIControlStateNormal];
        [btnStartRecord addTarget:self action:@selector(startVideoRecording) forControlEvents:UIControlEventTouchUpInside];
        btnStartRecord.userInteractionEnabled=NO;
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
        btnLibrary.userInteractionEnabled=NO;
        [imagePickerController.view  addSubview:btnLibrary];
        
        
        [tempImage release];
        
	}
    else
    {
        [self performSelector:@selector(goToLibrary1) withObject:nil afterDelay:0.5];
    }
    
    
    
    btnCancel.userInteractionEnabled        =   YES;
    btnStartRecord.userInteractionEnabled   =   YES;
    btnLibrary.userInteractionEnabled       =   YES;
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
}

- (void)imagePickerController: (UIImagePickerController *)picker2 didFinishPickingMediaWithInfo: (NSDictionary *)info 
{
    
    //UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    
   
    

    photo_count = photo_count+1;
    
    //[btnUpload setBackgroundImage:[UIImage imageNamed:@"upload_more.png"] forState:UIControlStateNormal];

    //redirectToPost = TRUE;
    [picker2 dismissModalViewControllerAnimated:YES];
	NSString *mediaType = [info valueForKey:UIImagePickerControllerMediaType];
    
    
	if([mediaType isEqualToString:@"public.movie"])
	{
		
		appDelegate.postVideoUrl =(NSURL*)[info objectForKey:@"UIImagePickerControllerMediaURL"];
        
        
        
        
        
        //[self performSelector:@selector(postMediaWithDelay) withObject:nil afterDelay:0.5];
        
        
        
        
		
	}
	else if([mediaType isEqualToString:@"public.image"])
	{
        
		
        
        UIImage *capture = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
       
        //capture.imageOrientation
        
          
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
        
        
        self.orientationStr = [self.orientationStr stringByAppendingString:[NSString stringWithFormat:@",%d",imageOrientation]];
        [btnUpload setBackgroundImage:[UIImage imageNamed:@"upload_more.png"] forState:UIControlStateNormal];
        
        if (![imageDict objectForKey:@"0"])
        {
             [imageDict setObject:capture forKey:[NSString stringWithFormat:@"%d",0]];
            
            imgView1.hidden = NO;
            btn1.hidden = NO;
            imgView1.image = [imageDict valueForKey:@"0"];
            
        }
        else if (![imageDict objectForKey:@"1"])
        {
            [imageDict setObject:capture forKey:[NSString stringWithFormat:@"%d",1]];
            imgView2.hidden = NO;
            btn2.hidden = NO;
            imgView2.image = [imageDict valueForKey:@"1"];

        }
        else if (![imageDict objectForKey:@"2"])
        {
            [imageDict setObject:capture forKey:[NSString stringWithFormat:@"%d",2]];
            imgView3.hidden = NO;
            btn3.hidden = NO;
            imgView3.image = [imageDict valueForKey:@"2"];

        }
        else if (![imageDict objectForKey:@"3"])
        {
            [imageDict setObject:capture forKey:[NSString stringWithFormat:@"%d",3]];
            imgView4.hidden = NO;
            btn4.hidden = NO;
            imgView4.image = [imageDict valueForKey:@"3"];

        }
        
    }
    
    
}

-(void)postMediaWithDelay
{
    [imagePickerController dismissModalViewControllerAnimated:YES];
}

-(IBAction)btnSubmit
{
    
    //[self resetViewDown];
    if ([[titleTextField text] length]==0) 
    {
        
        [[[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter title" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease] show];
        [titleTextField becomeFirstResponder];
        
    }
    else if ([[titleTextField text] length] <= 4 || [[titleTextField text] length] > 25) 
    {
        
        [[[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter title between 5 to 25 characters" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease] show];
        [titleTextField becomeFirstResponder];
        
    }
    else if ([[contentTextView text] length] > 1000) 
    {
        
        [[[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter description below 1000 characters" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease] show];
        [contentTextView becomeFirstResponder];
        
    }
    else 
    {
        
        [self performSelectorInBackground:@selector(startAnimatingAV) withObject:nil];
        
        NSString *postTagedIds1, *postTagedIds2;
        
        appDelegate.postTitle = [titleTextField text];
        
        appDelegate.postDescription =  [contentTextView text];
        
        if ([appDelegate.videoTaggedIds count]>0) {
            postTagedIds1 = [NSString stringWithFormat:@"%@",[appDelegate.videoTaggedIds description]];
            
        }
        else
        {
            postTagedIds1 = postTagedIds2 = @"";
        }
        
        
        if ([strType isEqualToString:@"video"])
        {
        
//        NSString *categoryId = [[NSString alloc] init];
//        categoryId = @"57";
//        
//        
//        NSString *urlString =[NSString stringWithFormat:@"%@media/list?user_id=%@&method=media.video-add&title=%@&desc=%@&location=chennai&tagids=%@&orentation=%@&media_catid=%@",ServerIp, appDelegate.userID,appDelegate.postTitle, @"" ,postTagedIds1,orientationStr,categoryId];
//        
//        urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        // setting up the request object now
//        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
//        [request setURL:[NSURL URLWithString:urlString]]; 
//        NSData *mediaData = [[NSData alloc] initWithContentsOfURL:appDelegate.postVideoUrl];
//        NSString *mediaFileName =  [appDelegate.postVideoUrl lastPathComponent];
//        [request setHTTPMethod:@"POST"];
//        
//        NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
//        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//        NSMutableData *body = [NSMutableData data];
//        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"media_data\"; filename=\"%@\"\r\n", mediaFileName] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[NSData dataWithData:mediaData]];
//        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        // setting the body of the post to the reqeust
//        [request setHTTPBody:body];
//        // now lets make the connection to the web
//        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//        /**/
//        _avloader.hidden = YES;
//        [_avloader release];
//        [_avloader removeFromSuperview];
//        /**/
//        
//        if (returnString) 
//        {
//            
//            NSString  *success    = [self GetValueInXML:returnString SearchStr:@"success"];
//            
//            NSString  *message    = [self GetValueInXML:returnString SearchStr:@"message"]; 
//            
//            if ([success isEqualToString:@"1"]) 
//            {
//                [[[[UIAlertView alloc] initWithTitle:@"Result" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease] show];
//                
//                appDelegate.redirectToRoot  =0;
//                
//                [self dismissModalViewControllerAnimated:YES]; 
//            }
//            else
//            {
//                [[[[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease] show];
//                
//            }
//            
//            
//        } 
        }
        else if ([strType isEqualToString:@"photo"])
        {
            
            NSString *returnString;
            
            
            
            NSString *categoryId = [[NSString alloc] init];
            categoryId = @"57";
            
            
            NSString *urlString =[NSString stringWithFormat:@"%@media/list?user_id=%@&method=media.photo-add&title=%@&desc=%@&location=chennai&tagids=%@&orentation=%@&media_catid=%@&img_captn=%@&file_count=%d",ServerIp, appDelegate.userID,appDelegate.postTitle, @"" ,postTagedIds1,self.orientationStr,categoryId,@"",[imageDict count]];
            
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:urlString delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
//            
//            [alertView show];
//            
//            [alertView   release];
            
            urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            // setting up the request object now
            NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
            [request setURL:[NSURL URLWithString:urlString]]; 
            
            [request setHTTPMethod:@"POST"];           
            NSMutableData *body = [NSMutableData data];
            int x=0;
            for (NSString *key in imageDict)
            {
                
                
                
            UIImage *img = [imageDict valueForKey:key];
                
            
            NSData *mediaData = UIImagePNGRepresentation(img);
            NSString *mediaFileName =  @"capture.png";

            NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"media_data%d\"; filename=\"%@\"\r\n",++x, mediaFileName] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:mediaData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
                           
            }
            
            [request setHTTPBody:body];
            NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            
            _avloader.hidden = YES;
            [_avloader release];
            [_avloader removeFromSuperview];
         
            
            
            if (returnString) 
            {
                appDelegate.mediaPosted = TRUE;
                
                NSString  *success    = [self GetValueInXML:returnString SearchStr:@"success"];
                
                NSString  *message    = [self GetValueInXML:returnString SearchStr:@"message"]; 
                
                if ([success isEqualToString:@"1"]) 
                {
//                UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"Result" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                    alert.tag = 10;
//                    [alert show];
//                    [alert release];
                    
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

-(IBAction)btnDelete:(id)sender
{
    //1,2,3,4
    //[[self.orientationStr componentsSeparatedByString:@","] objectAtIndex:[sender tag]];
    NSRange range;
    if ([imageDict objectForKey:[NSString stringWithFormat:@"%d",[sender tag]+1]]) {
        range=NSMakeRange(([sender tag]*2), 2);
    }
    else{
        range=NSMakeRange(([sender tag]*2), 1);
    }
     
    
    self.orientationStr = [self.orientationStr stringByReplacingCharactersInRange:range withString:@""];
    
    
    btn1.hidden = YES;
    btn2.hidden = YES;
    btn3.hidden = YES;
    btn4.hidden = YES;
    imgView1.hidden = YES;
    imgView2.hidden = YES;
    imgView3.hidden = YES;
    imgView4.hidden = YES;
    [imageDict removeObjectForKey:[NSString stringWithFormat:@"%d",[sender tag]]];
    for (int x=[sender tag]+1;x<4;x++) {
        if ([imageDict objectForKey:[NSString stringWithFormat:@"%d",x]]) {
            [imageDict setObject:[imageDict objectForKey:[NSString stringWithFormat:@"%d",x]] forKey:[NSString stringWithFormat:@"%d",x-1]];
            [imageDict removeObjectForKey:[NSString stringWithFormat:@"%d",x]];
        }
    }
    if ([imageDict objectForKey:@"0"])
    {
        imgView1.hidden = NO;
        btn1.hidden = NO;
        imgView1.image = [imageDict valueForKey:@"0"];
        
    }
    if ([imageDict objectForKey:@"1"])
    {
        imgView2.hidden = NO;
        btn2.hidden = NO;
        imgView2.image = [imageDict valueForKey:@"1"];
        
    }
    if ([imageDict objectForKey:@"2"])
    {
        imgView3.hidden = NO;
        btn3.hidden = NO;
        imgView3.image = [imageDict valueForKey:@"2"];
        
    }
    if ([imageDict objectForKey:@"3"])
    {
        imgView4.hidden = NO;
        btn4.hidden = NO;
        imgView4.image = [imageDict valueForKey:@"3"];
        
    }
    if ([[imageDict allKeys] count]==0)
            {
                 [btnUpload setBackgroundImage:[UIImage imageNamed:@"btn_upload.png"] forState:UIControlStateNormal];
            }
    
   
    
//    if ([imageDict objectForKey:@"0"])
//    {
//        imgView1.hidden = YES;
//        btn1.hidden = YES;
//    }
//    else if ([sender tag]==1)
//    {
//        imgView2.hidden = YES;
//        btn2.hidden = YES;
//
//    }
//    else if ([sender tag]==2)
//    {
//        imgView3.hidden = YES;
//        btn3.hidden = YES;
//
//    }
//    else if ([sender tag]==3)
//    {
//        imgView4.hidden = YES;
//        btn4.hidden = YES;
//
//    }
//    
//    if ([[imageDict allKeys] count]==0)
//    {
//        photo_count = 0;
//    }
    
    
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

-(void)flipCamera
{
    
    imagePickerController.cameraDevice = (imagePickerController.cameraDevice == UIImagePickerControllerCameraDeviceFront) ? UIImagePickerControllerCameraDeviceRear : UIImagePickerControllerCameraDeviceFront;
    
    
    
}

-(void)startVideoRecording
{
    
    btnStartRecord.hidden   =   YES;
    btnStopRecord.hidden    =   NO;
    btnLibrary.hidden       =   YES;
    btnFlipCam.hidden       =   YES;
    
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



- (void)animateView:(NSUInteger)tag
{
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    if (tag > 2) {
        rect.origin.y = -84.0f * (tag - 2);
    } else {
        rect.origin.y = 0;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(textView.text.length == 0){
        textView.textColor = [UIColor lightGrayColor];
    }
    else
        
    {
        textView.textColor = [UIColor blackColor];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{

    textView.text = @"";
    textView.textColor = [UIColor blackColor];
    [self animateView:3];

}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateView:0];
}

- (BOOL) textFieldShouldReturn:(UITextField*)textField {
    [textField resignFirstResponder];
    return YES;
}
-(IBAction)btnBack:(id)sender
{
    
    if (appDelegate.mediaPosted==TRUE) 
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alertPost = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Photo(s) will not be saved. please post it!... " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok post it", nil];
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
            [self dismissModalViewControllerAnimated:YES];
        }
        else if(buttonIndex ==1)
        {
            [self btnSubmit];
        }
        
    }
    
    
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
