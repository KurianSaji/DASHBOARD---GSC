//
//  mediadetails.m
//  maximSocialVideo
//
//  Created by neo on 19/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "mediadetails.h"
#import "userVideoListing.h"
@implementation mediadetails

@synthesize _customVideoPlayer, _comments;
@synthesize txtLabel;
@synthesize videoDetails, commentDetails;
@synthesize videoUrl;
@synthesize  videoThumbUrl, videoUserId, videoUserUrl, videoUserName, videoTitle, videoDesc, videoExt, videoDays, videoLocation, videoViewCount, video_id, video_Date, video_Cmt_Count, waveUpDown;

@synthesize commentCount;

@synthesize commentArray;

@synthesize btnPost, textFieldRounded;

@synthesize likeCount, didLike, didReviewed, canDelete;

@synthesize btnLike, lblLikeCount;

@synthesize likeIV;

@synthesize curSW, curSH;

@synthesize _userVL;

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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    boolComments =1;
    [self showComments];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate.boolFlag = 0;
    
    imagesArray = [[NSMutableArray alloc] init];
    
    backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height)];
    
    backgroundImageView.image = [UIImage imageNamed:@"bg_2_blue.png"];
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
    
    curSW = [[UIScreen mainScreen] bounds].size.width;
    curSH = [[UIScreen mainScreen] bounds].size.height;
    
    boolComments = 0;
    
    vl_MainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height+70)];
    vl_MainView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:vl_MainView];
    
    [self updateViewCount];
    
    [self fetchVideoDetails];
    
    [self fetchCommentsDetails];
    
    [self setTabbuttons];
    
    [self buildUser];
    
    [self buildCustomVideo];
    
    [self buildViewsCounts];
    
    
    if (appDelegate.boolComments==1)
    {
        boolComments = 1;
        [self buildComments];

    }
    
    
    [self buildBottomTab];
    
    if(appDelegate.userID)
    {
        [self  performSelector:@selector(buildFlagForReview) withObject:nil afterDelay:0.1];
    }
        
    
    
    button1.userInteractionEnabled = YES;
    
    [self performSelector:@selector(setHidden) withObject:nil afterDelay:4.0];
}

-(void)flagHidden
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    vl_FlagView.hidden= YES; 
    
    vl_FlagView.frame = CGRectMake(0,(368.0/480)*curSH , self.view.frame.size.width, (117.0/480)*curSH);
    [UIView commitAnimations];

}

-(void)flagSelected
{
    boolComments =1;
    [self showComments];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    vl_FlagView.hidden= NO; 
    
    vl_FlagView.frame = CGRectMake(0,(368.0/480)*curSH , self.view.frame.size.width, (117.0/480)*curSH);
    [UIView commitAnimations];
}
-(void)cancelFlag
{   
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    vl_FlagView.frame = CGRectMake(0,self.view.frame.size.height , self.view.frame.size.width, (117.0/480)*curSH);
    vl_FlagView.hidden = YES;
    [UIView commitAnimations];
}



-(void)buildFlagForReview
{
    
    
    
    curSW = [[UIScreen mainScreen] bounds].size.width;
    curSH = [[UIScreen mainScreen] bounds].size.height;
    
    vl_FlagView = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height , self.view.frame.size.width, (117.0/480)*curSH)];
    
    vl_FlagView.backgroundColor = [UIColor blackColor];
    
    [vl_MainView addSubview:vl_FlagView];
    
    // vl_FlagView.hidden=YES;
    
    
    
    btnReview = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnReview.frame = CGRectMake(0, 0, self.view.frame.size.width, (39.0/480)*curSH);
    
    [btnReview setTitle:@"Flag for review" forState:UIControlStateNormal];
    
    [btnReview setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [btnReview addTarget:self action:@selector(sendFlagForReview) forControlEvents:UIControlEventTouchUpInside];
    
    btnReview.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    btnReview.showsTouchWhenHighlighted = YES;
    
    btnReview.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
    | UIViewAutoresizingFlexibleBottomMargin;
    
    [vl_FlagView addSubview:btnReview];
    
    
    
    btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnDelete.frame = CGRectMake(0, 40, self.view.frame.size.width, (39.0/480)*curSH);
    
    [btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
    
    [btnDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [btnDelete addTarget:self action:@selector(confirmDeleteVideo) forControlEvents:UIControlEventTouchUpInside];
    
    btnDelete.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    btnDelete.showsTouchWhenHighlighted = YES;
    
    btnDelete.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
    | UIViewAutoresizingFlexibleBottomMargin;
    
    [vl_FlagView addSubview:btnDelete];
    
    
    
    btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnCancel.frame = CGRectMake(0, 79, self.view.frame.size.width, (39.0/480)*curSH);
    
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [btnCancel addTarget:self action:@selector(cancelFlag) forControlEvents:UIControlEventTouchUpInside];
    
    btnCancel.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    btnCancel.showsTouchWhenHighlighted = YES;
    
    btnCancel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
    | UIViewAutoresizingFlexibleBottomMargin;
    
    [vl_FlagView addSubview:btnCancel];
    
    
    [vl_FlagView bringSubviewToFront:vl_CommentView];

    
    
    if (self.didReviewed==TRUE) 
    {
        
        vl_FlagView.frame = CGRectMake(0,self.view.frame.size.height , self.view.frame.size.width, (78.0/480)*curSH);
        
        //btnReview.frame = CGRectMake(0, 0, self.view.frame.size.width, (39.0/480)*curSH);
        
        btnReview.hidden=YES;
        
        btnDelete.frame = CGRectMake(0, 0,  self.view.frame.size.width, (39.0/480)*curSH);
        
        btnCancel.frame = CGRectMake(0, 40, self.view.frame.size.width, (39.0/480)*curSH);
        
    }
    
    
    if (self.canDelete==FALSE) 
    {
        
        vl_FlagView.frame = CGRectMake(0,self.view.frame.size.height , self.view.frame.size.width, (78.0/480)*curSH);
        
        btnReview.frame = CGRectMake(0, 0, self.view.frame.size.width, (39.0/480)*curSH);
        
        
        
        btnDelete.frame = CGRectMake(0, 0,  self.view.frame.size.width, (39.0/480)*curSH);
        
        btnDelete.hidden=YES;
        
        btnCancel.frame = CGRectMake(0, 40, self.view.frame.size.width, (39.0/480)*curSH);
        
    }
    
    
    
    
}


-(void)sendFlagForReview
{
    
    UIDevice *myDevice = [UIDevice currentDevice];
	
	NSString *deviceUDID = [myDevice uniqueIdentifier];
	
    NSLog(@"ServerIp ---  %@", ServerIp);
    
    
 	NSString *urlString =[NSString stringWithFormat:@"%@review",ServerIp];
    
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
    [request setURL:[NSURL URLWithString:urlString]]; 
    
    NSLog(@"urlString----%@",urlString);
	
    
    int like_Flag;
    if (didLike) like_Flag = 0;
    else     like_Flag = 1;
    
    NSString *myParameters = [NSString stringWithFormat:@"method=review.media-video&user_id=%@&media_id=%d&device_id=%@&review_flag=1&mtype=%d",appDelegate.userID, appDelegate.videoTagId, deviceUDID,[videoType integerValue]];
    
    NSLog(@"%@",myParameters);
    
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    // now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"return data = %@",returnData);
	NSLog(@"sendFlagForReview -- returnString ---%@",returnString);
    
    if (returnString) 
    {
        NSString *success = [self GetValueInXML:returnString SearchStr:@"success"];
        NSString *message = [self GetValueInXML:returnString SearchStr:@"message"];
        
        [[[[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
        
        
        if ([success isEqualToString:@"1"]) {
            
            vl_FlagView.frame = CGRectMake(0,self.view.frame.size.height , self.view.frame.size.width, (78.0/480)*curSH);
            
            //btnReview.frame = CGRectMake(0, 0, self.view.frame.size.width, (39.0/480)*curSH);
            
            btnReview.hidden=YES;
            
            btnDelete.frame = CGRectMake(0, 0,  self.view.frame.size.width, (39.0/480)*curSH);
            
            btnCancel.frame = CGRectMake(0, 40, self.view.frame.size.width, (39.0/480)*curSH);
            
            
            self.didReviewed;
            
            if (self.canDelete==FALSE) 
            {
                button2.hidden=YES;
                
            }  
            
            
            
        }   
        
        
    }
    
    [returnString release];
    
    
    
}




-(void)confirmDeleteVideo
{

    UIAlertView *alertLogout = [[UIAlertView alloc] init];
    [alertLogout setTitle:@"Confirm"];
    
    if ([videoType isEqualToString:@"1"])
    {
        [alertLogout setMessage:@"Are you sure want to delete this video?"];

    }
    else
    {
        [alertLogout setMessage:@"Are you sure want to delete this photo?"];

    }
    
    [alertLogout setDelegate:self];
    [alertLogout addButtonWithTitle:@"Cancel"];
    [alertLogout addButtonWithTitle:@"Ok"];
    [alertLogout show];
    [alertLogout release];
 

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100)
    {
        if (buttonIndex==0)
        {
            [self backtoHome];
        }
    }
    else
    {
        if (buttonIndex == 0)
        {
            //No
            
        }
        else if (buttonIndex == 1)
        {
            [self deleteVideo];
            
        }
    }
	
}


-(void)deleteVideo
{
    
    
    
    UIDevice *myDevice = [UIDevice currentDevice];
	
	NSString *deviceUDID = [myDevice uniqueIdentifier];
	
    
 	NSString *urlString =[NSString stringWithFormat:@"%@media/delete",ServerIp];
    
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
    [request setURL:[NSURL URLWithString:urlString]];\
    
    NSLog(@"urlString----%@",urlString);
	
    
    int like_Flag;
    if (didLike) like_Flag = 0;
    else     like_Flag = 1;
    
    NSString *myParameters = [NSString stringWithFormat:@"method=media.video-delete&user_id=%@&media_id=%d&device_id=%@&mtype=%d",appDelegate.userID, appDelegate.videoTagId, deviceUDID,[videoType intValue]];
    
    NSLog(@"%@",myParameters);
    
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    // now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"deleteVideo -- returnString ---%@",returnString);
    
    
    
    
    if (returnString) 
    {
        NSString *success = [self GetValueInXML:returnString SearchStr:@"success"];
        NSString *message = [self GetValueInXML:returnString SearchStr:@"message"];
        
        //[[[[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        alertView.tag = 100;
        [alertView show];
        
        [alertView release];
        
        if ([success isEqualToString:@"1"]) 
        {
            appDelegate.boolDelete = 1;
            //[self backtoHome];
            
            return;
            
        }    
        
    }
    
    [returnString release];
    
    
    
}



-(void)fetchCommentsDetails
{
    
    
    NSString *urlString =[NSString stringWithFormat:@"%@comment/list",ServerIp];
    
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
    [request setURL:[NSURL URLWithString:urlString]]; 
    
    NSLog(@"urlString----%@",urlString);
	
    NSString *myParameters = [NSString stringWithFormat:@"user_id=%@&video_id=%d&method=comment.list-video",appDelegate.userID, appDelegate.videoTagId];
    
    NSLog(@"%@",myParameters);
    
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    // now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"%@",returnString);
    
    
    
    if (returnString) 
    {
        
        
        //[[[[UIAlertView alloc] initWithTitle:@"Success" message:returnString delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] autorelease] show]; 
        
        
        NSError *error;
        
        
        self.commentDetails  = [XMLReader1  dictionaryForXMLString:returnString error:&error];
        // NSLog(@"%@", self.commentDetails);
        commentCount = [[[[self.commentDetails objectForKey:@"VideoComments"] objectForKey:@"cmt_count"] objectForKey:@"text"] intValue];
        
        
        self.commentDetails = [self.commentDetails objectForKey:@"VideoComments"];
        
        // NSLog(@"%@", self.commentDetails);
        
        //self.commentDetails = 
        
        commentArray = [self.commentDetails objectForKey:@"comments"] ;
        
        NSLog(@"%@", commentArray);
        
        
        
        
        
        
    }
    
    // [[[[UIAlertView alloc] initWithTitle:@"error" message:returnString delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] autorelease] show];
    
    [returnString release];
    
}

-(void)fetchVideoDetails
{
    
    
    
    NSString *urlString =[NSString stringWithFormat:@"%@media/detail",ServerIp];
    
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
    [request setURL:[NSURL URLWithString:urlString]];
    
    NSLog(@"urlString----%@",urlString);
	
    NSString *myParameters = [NSString stringWithFormat:@"video_id=%d&method=media.video-view&user_id=%@", appDelegate.videoTagId, appDelegate.userID];
    
    NSLog(@"myParameters -- %@",myParameters);
    
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    // now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"fetchVideoDetails ---- %@",returnString);
    
    
    if (returnString) 
    {
        
        
        NSError *error;
        
        
        self.videoDetails = [XMLReader1  dictionaryForXMLString:returnString error:&error];
        
        
       

        
        self.videoDetails = [self.videoDetails objectForKey:@"VideoDetails"];
        
        NSLog(@"%@", self.videoDetails);
        
        
       
        
        videoType = [[[self.videoDetails objectForKey:@"video"] objectForKey:@"video_type"] objectForKey:@"text"];
        
        if ([videoType isEqualToString:@"1"])
        {
            vl_VideoView.hidden = NO;
            mediaType = 1;
        }
        else
        {
            mediaType = 2;
            
            vl_VideoView.hidden = YES;
            
            imgCount = [[[[self.videoDetails objectForKey:@"video"] objectForKey:@"image"] objectForKey:@"video_url"] count];
            
           
            
            if (imgCount==1)
            {
                for (int i=0;i<imgCount;i++)
                {
                    [imagesArray addObject:[[[[self.videoDetails objectForKey:@"video"] objectForKey:@"image"] objectForKey:@"video_url"] objectForKey:@"text"]];
                }

            }
            else
            {
            for (int i=0;i<imgCount;i++)
                {
                    [imagesArray addObject:[[[[[self.videoDetails objectForKey:@"video"] objectForKey:@"image"] objectForKey:@"video_url"] objectAtIndex:i] objectForKey:@"text"]];
                }
            }
            
            
            [self createScrollView];
            
            [self createButton];

            
        }
        
        self.video_Date = [[[self.videoDetails objectForKey:@"video"] objectForKey:@"video_created"] objectForKey:@"text"];
        
        self.video_Cmt_Count = [[[self.videoDetails objectForKey:@"video"] objectForKey:@"video_cmtcount"] objectForKey:@"text"];
        
        self.video_id = [[[self.videoDetails objectForKey:@"video"] objectForKey:@"video_id"] objectForKey:@"text"];
        
        
        self.videoUrl = [NSURL URLWithString:[[[self.videoDetails objectForKey:@"video"] objectForKey:@"video_url"] objectForKey:@"text"]];
        
        
        self.videoThumbUrl = [[[self.videoDetails objectForKey:@"video"] objectForKey:@"video_thumb"] objectForKey:@"text"];
        self.videoUserId = [[[self.videoDetails objectForKey:@"video"] objectForKey:@"user_id"] objectForKey:@"text"];
        
        NSLog(@"video user id = %@",self.videoUserId);

        
        self.videoUserUrl = [[[self.videoDetails objectForKey:@"video"] objectForKey:@"user_img"] objectForKey:@"text"];
        self.videoUserName = [[[self.videoDetails objectForKey:@"video"] objectForKey:@"user_name"] objectForKey:@"text"];
        self.videoTitle = [[[self.videoDetails objectForKey:@"video"] objectForKey:@"video_title"] objectForKey:@"text"];
        self.videoDesc = [[[self.videoDetails objectForKey:@"video"] objectForKey:@"video_desc"] objectForKey:@"text"];
        self.videoExt = [[[self.videoDetails objectForKey:@"video"] objectForKey:@"video_ext"] objectForKey:@"text"];
        self.videoDays = [[[self.videoDetails objectForKey:@"video"] objectForKey:@"video_days"] objectForKey:@"text"];
        self.videoLocation = [[[self.videoDetails objectForKey:@"video"] objectForKey:@"video_location"] objectForKey:@"text"];
        self.videoViewCount = [[[self.videoDetails objectForKey:@"video"] objectForKey:@"video_viwcnt"] objectForKey:@"text"];
        
        self.waveUpDown =  [[[self.videoDetails objectForKey:@"video"] objectForKey:@"video_wave_up_down"] objectForKey:@"text"];
        
        NSString *video_likecnt = [[[self.videoDetails objectForKey:@"video"] objectForKey:@"video_likecnt"] objectForKey:@"text"];
        
        self.likeCount = [video_likecnt intValue];
        
        
        NSString *video_likeusr = [[[self.videoDetails objectForKey:@"video"] objectForKey:@"video_likeusr"] objectForKey:@"text"];
        
        if([video_likeusr isEqualToString:@"1"])
        {
            self.didLike = TRUE;   
        }
        else 
            self.didLike = FALSE;
        
        NSString *video_review = [[[self.videoDetails objectForKey:@"video"] objectForKey:@"video_review"] objectForKey:@"text"];
        
        if([video_review isEqualToString:@"1"])
        {
            self.didReviewed = TRUE;   
        }
        else 
            self.didReviewed = FALSE;
        
        NSString *video_del = [[[self.videoDetails objectForKey:@"video"] objectForKey:@"video_del"] objectForKey:@"text"];
        
        if([video_del isEqualToString:@"1"])
        {
            self.canDelete = TRUE;   
        }
        else 
            self.canDelete = FALSE;
        
        
        //       / self.didReviewed = TRUE ;
        
        
    }
    
    // [[[[UIAlertView alloc] initWithTitle:@"error" message:returnString delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] autorelease] show];
    
    [returnString release];
    
}
-(void)createScrollView
{
    vl_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10,150, self.view.frame.size.width-20,(223.0/480)*curSH)];    vl_scrollView.showsHorizontalScrollIndicator = NO;
    vl_scrollView.showsVerticalScrollIndicator = YES;
    vl_scrollView.scrollsToTop = NO;
    vl_scrollView.delegate = self;
    
        
    
    vl_scrollView.backgroundColor = [UIColor colorWithRed:230.2/255 green:230.2/255 blue:230.2/255 alpha:1];    
    [self.view addSubview:vl_scrollView];
    
    
}
-(void)createButton
{
    int yPos=10;
    
    photoButtonResize *btnThumPhoto;
    
    
    for (int i = 0; i <[imagesArray count]; i++) 
    {
        
        if  (i%1==0 && i!=0) 
        {
            
            yPos=yPos+215+10;
        }
        NSLog(@"width = %f",self.view.frame.size.width-40);
        
        btnThumPhoto=[[photoButtonResize alloc]initWithFrame:CGRectMake( 10,yPos , self.view.frame.size.width-40, 210)];
        btnThumPhoto.boolResize = YES;
        btnThumPhoto.tag = 2001+i;
        
        //btnThumPhoto._delegate = self;
        
        [vl_scrollView addSubview:btnThumPhoto];
        
        NSLog(@"[imagesArray] -- %@",[imagesArray objectAtIndex:i]);
        [vl_scrollView addSubview:btnThumPhoto];
        
        
        
        
        NSString* lastComponent = [[imagesArray objectAtIndex:i] lastPathComponent];
        NSLog(@"lastComponent-- %@",lastComponent);
        NSArray *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path;
        
        path = [[searchPath objectAtIndex:0]  stringByAppendingString:[NSString stringWithFormat:@"/thumbData/%@",lastComponent]];
        
        
        if ([self checkFileExist:lastComponent ]) {
            [(photoButton*)btnThumPhoto setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
        }
        else
        {
            
            [(photoButton*)btnThumPhoto loadImage:[imagesArray objectAtIndex:i] isLast:TRUE];
            
        }
        
        
        
    }
    
    vl_scrollView.contentSize = CGSizeMake(self.view.frame.size.width-20,yPos+215); 
    
    [self performSelectorInBackground:@selector(arrangePhotos) withObject:nil];

    
    
}



-(void)arrangePhotos
{
    int yPos=10;
    float tempYPos = 0;
    for (int i = 0; i <[imagesArray count]; i++) 
    {
        
        if  (i%1==0 && i!=0) 
            yPos=yPos+tempYPos+10;   
        
        tempYPos = 0.0;
        tempYPos = [self setscrollHeight:[imagesArray objectAtIndex:i] btnindex:i ypos:yPos];
        
        
        
    }
    
    
    if  ([imagesArray count]==1) 
    {
        vl_scrollView.contentSize = CGSizeMake(self.view.frame.size.width-20,yPos+tempYPos); 
        
    }
    else
    {
        vl_scrollView.contentSize = CGSizeMake(self.view.frame.size.width-20,yPos+tempYPos);     
    }
    
    
}

-(float)setscrollHeight:(NSString *)string btnindex:(NSInteger)btnIndex ypos:
(float)yPos
{
    
    
    
    
    float imgHeight ;
    
    
    NSString* lastComponent = [string lastPathComponent];
    NSLog(@"lastComponent-- %@",lastComponent);
    NSArray *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path;
    
    path = [[searchPath objectAtIndex:0]  stringByAppendingString:[NSString stringWithFormat:@"/thumbData/%@",lastComponent]];
    
    UIImage *tempImg;
    if ([self checkFileExist:lastComponent ]) 
    {
        tempImg = [UIImage imageWithContentsOfFile:path];
        
        
    }
    else
    {
        
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:string]];
        [request setHTTPMethod:@"POST"];
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        tempImg = [UIImage imageWithData:returnData];
        
        
    }
    
    imgHeight = tempImg.size.height;
    
    
    vl_scrollView.contentSize = CGSizeMake(self.view.frame.size.width-20,yPos+imgHeight); 
    
    photoButton *tempPhotoButton = [vl_scrollView  viewWithTag:(2001+btnIndex)];
    
    
    tempPhotoButton.frame = CGRectMake(tempPhotoButton.frame.origin.x, yPos, tempPhotoButton.frame.size.width, imgHeight);
    
    
    return imgHeight;
}
-(BOOL)checkFileExist:(NSString*)filename
{
	NSLog(@"file name123==%@",filename);
	///   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [NSString stringWithFormat:@"%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/thumbData/"]];//[paths objectAtIndex:0];
    NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:filename];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataFilePath];
	//	NSLog(@"filename %@",dataFilePath);
    return fileExists;
    
}


-(void)buildBottomTab
{
    
    curSW = [[UIScreen mainScreen] bounds].size.width;
    curSH = [[UIScreen mainScreen] bounds].size.height;
    
    
    int  tabFontFize, tabheight, tabButtonW, tabButtonH;
    
    UIImage *tempImage, *tempImage2, *tempImage3,*tempImage4;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        tabFontFize = 16;
        tabheight = 50;
        tabButtonW = 70;
        tabButtonH = 24; 
        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"green_line_iphone" ofType:@"png"]];
        tempImage2 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"down_arrow" ofType:@"png"]];
        tempImage3 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"like_hand" ofType:@"png"]];
        tempImage4 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"up_arrow" ofType:@"png"]];
    }
    else
    {
        
        tabFontFize =35;
        tabheight = 82;//62
        tabButtonW = 161;
        tabButtonH = 52; 
        tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"green_line_ipad" ofType:@"png"]];
        tempImage2 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"like_ipad" ofType:@"png"]];
        
        tempImage3 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"like_hand" ofType:@"png"]];
    }    
    
    
    vl_BottomTabView = [[UIView alloc] initWithFrame:CGRectMake(0,(vl_VideoView.frame.size.height+vl_TabsView.frame.size.height+vl_UserView.frame.size.height+vl_ViewCountView.frame.size.height+106), self.view.frame.size.width ,(50.0/480)*curSH)];
    vl_BottomTabView.backgroundColor = [UIColor blackColor];
    [vl_MainView addSubview:vl_BottomTabView];
    
    
    
    
    
    
    
    
    [vl_BottomTabView release];
    
    if(appDelegate.userID) 
    {
        
        
        btnUnlike  = [UIButton buttonWithType:UIButtonTypeCustom];
        btnUnlike.frame = CGRectMake(5,7,tempImage2.size.width,tempImage2.size.height);
        (btnUnlike).titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:tabFontFize];
        [btnUnlike setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
        [btnUnlike setBackgroundImage:tempImage2 forState:UIControlStateNormal];
        [btnUnlike addTarget:self action:@selector(updateUnLikeCount) forControlEvents:UIControlEventTouchUpInside];
        [vl_BottomTabView addSubview:btnUnlike];
        
        
//        if (self.didLike==TRUE) {
//            btnUnlike.alpha = 0.4;
//        }
        
        

        
        
        btnLike  = [UIButton buttonWithType:UIButtonTypeCustom];
        btnLike.frame = CGRectMake(btnUnlike.frame.origin.x+btnUnlike.frame.size.width+2,7,tempImage4.size.width,tempImage4.size.height);
        [btnLike setBackgroundImage:tempImage4 forState:UIControlStateNormal];
        [btnLike addTarget:self action:@selector(updateLikeCount) forControlEvents:UIControlEventTouchUpInside];
        [vl_BottomTabView addSubview:btnLike];
        
        
//        if (self.didLike==TRUE) {
//            btnLike.alpha = 0.4;
//        }

        
        if ([self.waveUpDown isEqualToString:@"1"]) 
        {
            btnLike.alpha = 0.4;
        }
        else if ([self.waveUpDown isEqualToString:@"2"])
        {
            btnUnlike.alpha = 0.4;
        }
        
        
        
        textFieldRounded = [[UITextField alloc] initWithFrame:CGRectMake((65.0/320)*curSW  ,(2.0/480)*curSH , (181.0/320)*curSW, (20.0/320)*curSH )];
        textFieldRounded.borderStyle = UITextBorderStyleNone ;//UITextBorderStyleRoundedRect;
        textFieldRounded.textColor = [UIColor blackColor]; //text color
        textFieldRounded.font = [UIFont systemFontOfSize:20.0];  //font size
        //textFieldRounded.placeholder = @"<enter text>";  //place holder
        textFieldRounded.backgroundColor = [UIColor whiteColor]; //background color
        textFieldRounded.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
        textFieldRounded.keyboardType = UIKeyboardTypeDefault;  // type of the keyboard
        textFieldRounded.returnKeyType = UIReturnKeyDone;  // type of the return key
        textFieldRounded.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
        textFieldRounded.delegate = self;
        //textFieldRounded.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
        
        [vl_BottomTabView addSubview:textFieldRounded];
        
        
        UILabel *lblColor = [[UILabel alloc] initWithFrame:CGRectMake((65.0/320)*curSW  ,(35.0/480)*curSH , 181, 5)];
        
        
        // (65.0/320)*curSW  ,(37.0/480)*curSH , (181.0/320)*curSW, (5/320)*curSH )
        
        lblColor.backgroundColor = [UIColor colorWithRed:0/255.0 green:252.0/255.0 blue:254.0/255.0 alpha:1];
        //[vl_BottomTabView addSubview:lblColor];
        
        
        
        
        btnPost  = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            btnPost.frame = CGRectMake(268,7,31,18);
        }
        else
        {
            //btnPost.frame = CGRectMake((286.0/320)*curSW  ,0, (47.0/320)*curSW, (50/320)*curSH);
            btnPost.frame = CGRectMake(642,0,100,64);
            
        }
        
        
        
        btnPost.backgroundColor = [UIColor clearColor];
        
        //[btnPost setTitle:@"POST" forState:UIControlStateNormal];
        //[btnShare setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
        (btnPost).titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:tabFontFize];
//        [btnPost setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
        //[btnPost setCusImage:tempImage initWithFrame:CGRectMake(0, 0, tempImage.size.width , tempImage.size.height)];
        
        [btnPost setBackgroundImage:[UIImage imageNamed:@"btn_post"] forState:UIControlStateNormal];
        
        [btnPost setBackgroundColor:[UIColor clearColor]];
        
        [vl_BottomTabView addSubview:btnPost];
        
        [btnPost addTarget:self action:@selector(postComments) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
    
    
        UIButton *btnSignIn  = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSignIn.frame = CGRectMake(10,0,35,18);
        btnSignIn.backgroundColor = [UIColor clearColor];
        ///[btnSignIn setTitle:@"Log-in/nSignUp" forState:UIControlStateNormal];
        //[btnSignIn addTarget:self action:@selector(facebtnact:) forControlEvents:UIControlEventTouchUpInside];
        [btnSignIn addTarget:self action:@selector(redirectToLogin) forControlEvents:UIControlEventTouchUpInside];
        //(btnSignIn).titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:15];
        [btnSignIn setBackgroundImage:[UIImage imageNamed:@"img_login.png"] forState:UIControlStateNormal];
        
        //[btnSignIn setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
        [vl_BottomTabView addSubview:btnSignIn];
        
        
        
        
//        UILabel *signIn = [[UILabel alloc] initWithFrame:btnSignIn.frame];
//        signIn.numberOfLines = 2;
//        signIn.text = @"Sign-up\nLog-in";
//        signIn.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
//        signIn.textAlignment = UITextAlignmentCenter;
//        signIn.backgroundColor = [UIColor clearColor];
//        signIn.textColor =  [ UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
//        [btnSignIn addSubview:signIn];
    
    }
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    
    self.view.center = CGPointMake((384.0/768)*self.view.frame.size.width , (512.0/1024)*self.view.frame.size.height);
    
    [UIView beginAnimations:@"TEST" context:nil];
    [UIView setAnimationDuration:0.25];
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        self.view.center = CGPointMake((384.0/768)*self.view.frame.size.width , (60.0/1024)*self.view.frame.size.height);
    }
    else
    {
        
        self.view.center = CGPointMake((384.0/768)*self.view.frame.size.width , (250.0/1024)*self.view.frame.size.height);
        
    }
    
    
    [UIView commitAnimations];
    
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:@"TEST" context:nil];
    [UIView setAnimationDuration:0.25];
    self.view.center = CGPointMake((384.0/768)*self.view.frame.size.width , (512.0/1024)*self.view.frame.size.height);
    [UIView commitAnimations];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
    
}



-(void)postComments
{
    
    
    
    if ([[textFieldRounded text] length]<=0)
    {
        [[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter message to post" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] autorelease] show];
        
    }else if ([[textFieldRounded text] length]>1000)
    {
        [[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, comments cannot be longer than 1,000 characters." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] autorelease] show];
        
    }
    else
    {
        
        
        btnPost.enabled = NO;
        
        //UIDevice *myDevice = [UIDevice currentDevice];
        
        //NSString *deviceUDID = [myDevice uniqueIdentifier];
        
        
        // NSString *urlString =[NSString stringWithFormat:@"%@comment/add",@"http://122.183.212.56/maximsocialmedia/"];
        // NSString *urlString =[NSString stringWithFormat:@"%@comment/add",@"http://www.newtoybox.com/maximsocialmedia/"];
        NSString *urlString =[NSString stringWithFormat:@"%@comment/add",ServerIp];
        urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        // setting up the request object now
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        
        [request setURL:[NSURL URLWithString:urlString]];
        
        NSLog(@"urlString----%@",urlString);
        
        //int userId = 109867120; 
        
        //NSString *myParameters = [NSString stringWithFormat:@"user_id=109867120&video_id=%@&method=comment.add-video&video_desc=%@", self.video_id, [textFieldRounded text]   ];
        
        NSString *myParameters = [NSString stringWithFormat:@"user_id=%@&video_id=%d&method=comment.add-video&video_desc=%@", appDelegate.userID,appDelegate.videoTagId, [textFieldRounded text]   ];
        
        //NSString *myParameters = [NSString stringWithFormat:@"user_id=%@&video_id=%@&method=comment.add-video&video_desc=%@",appDelegate.userID, self.video_id, [textFieldRounded text]   ];
        
        
        NSLog(@"%@",myParameters);
        
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
        
        // now lets make the connection to the web
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        //NSLog(@"%@",returnString);
        
        
        
        
        
        
        
        
        
        
        
        if (returnString) 
        {
            
            
            
            
            [self fetchCommentsDetails];
            
            _comments.commentArray = self.commentArray;
            
            _comments.commentCount = self.commentCount;
            
            [_comments reloadTableView];
            
            
            textFieldRounded.text = @"";
            
            
            [textFieldRounded resignFirstResponder];
            
            
            
        }
        
    
        
        lblComments.text = [NSString stringWithFormat:@"%d",[lblComments.text intValue]+1];
        
        
        
        boolComments = 0;
        [returnString release];
        
        if (!vl_CommentView.hidden)
        {
            vl_CommentView.hidden = YES;

        }
        else
        {
            vl_CommentView.hidden = NO;
        }
        [self showComments];
        
    }
    
    btnPost.enabled = YES;
    
}


-(void)updateLikeCount
{
    waveType = 1;
    
    UIDevice *myDevice = [UIDevice currentDevice];
	
	NSString *deviceUDID = [myDevice uniqueIdentifier];
	
    
 	NSString *urlString =[NSString stringWithFormat:@"%@media/list",ServerIp];
    
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
    [request setURL:[NSURL URLWithString:urlString]];\
    
    NSLog(@"urlString----%@",urlString);
	
    
    int like_Flag;
    if (didLike) like_Flag = 0;
    else     like_Flag = 1;
    
   // NSString *myParameters = [NSString stringWithFormat:@"method=like.media-video&user_id=%@&media_id=%d&device_id=%@&like_flag=%d",appDelegate.userID, appDelegate.videoTagId, deviceUDID, like_Flag];
    
     NSString *myParameters = [NSString stringWithFormat:@"method=user.wave&user_id=%@&media_id=%d&liketype=%d&ilik_deviceid=%@&ilik_liked=%d",appDelegate.userID, appDelegate.videoTagId, mediaType,deviceUDID, waveType];
    
    NSLog(@"%@",myParameters);
    
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    // now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"updatelikeCount -- returnString ---%@",returnString);
    
    
    
    
    if (returnString) 
    {
        NSString *success = [self GetValueInXML:returnString SearchStr:@"success"];
        if ([success isEqualToString:@"1"]) {
            
            
            
            
            if (didLike) 
            {
                btnUnlike.alpha = 0.4;
                btnLike.alpha=1;
                didLike = FALSE;
                
            }
            else
            {
                btnUnlike.alpha = 1.0;
                btnLike.alpha=0.4;
                didLike = TRUE;
            }
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Thanks for voting." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
            [alertView show];
            [alertView release];
            
            
        }    
        
    }
    
    [returnString release];
    
    
    
}

-(void)updateUnLikeCount
{
    waveType = 0;
    
    UIDevice *myDevice = [UIDevice currentDevice];
	
	NSString *deviceUDID = [myDevice uniqueIdentifier];
	
    
 	NSString *urlString =[NSString stringWithFormat:@"%@media/list",ServerIp];
    
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
    [request setURL:[NSURL URLWithString:urlString]];\
    
    NSLog(@"urlString----%@",urlString);
	
    
    int like_Flag;
    if (didLike) like_Flag = 0;
    else     like_Flag = 1;
    
    // NSString *myParameters = [NSString stringWithFormat:@"method=like.media-video&user_id=%@&media_id=%d&device_id=%@&like_flag=%d",appDelegate.userID, appDelegate.videoTagId, deviceUDID, like_Flag];
    
    NSString *myParameters = [NSString stringWithFormat:@"method=user.wave&user_id=%@&media_id=%d&liketype=%d&ilik_deviceid=%@&ilik_liked=%d",appDelegate.userID, appDelegate.videoTagId, mediaType,deviceUDID, waveType];
    
    NSLog(@"%@",myParameters);
    
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    // now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"updatelikeCount -- returnString ---%@",returnString);
    
    
    
    
    if (returnString) 
    {
        NSString *success = [self GetValueInXML:returnString SearchStr:@"success"];
        if ([success isEqualToString:@"1"]) {
            
            
            if (didLike) 
            {
                
                btnLike.alpha= 1.0;
                btnUnlike.alpha=0.4;
                didLike = FALSE;
                
            }
            else
            {
                btnLike.alpha = 1.0;
                btnUnlike.alpha=0.4;
                didLike = TRUE;
                
            }
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Thanks for voting." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
            [alertView show];
            [alertView release];
            
    }    
        
}
    
    [returnString release];
}

-(void)buildComments
{
    
    int  tabFontFize, tabheight, tabButtonW, tabButtonH;
    int commentsX, commentsY, commentsW, commentsH;
    //int curSW = [[UIScreen mainScreen] bounds].size.width;
    int curSH = [[UIScreen mainScreen] bounds].size.height;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        tabFontFize = 10;
        tabheight = 124;
        tabButtonW = 70;
        tabButtonH = 24; 
        
        
        commentsX = 0;
        commentsY = 0;
        commentsW = 320;
        commentsH = 126;
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
    
    [vl_CommentView removeFromSuperview];
    
    vl_CommentView = [[UIView alloc] initWithFrame:CGRectMake(0,(vl_VideoView.frame.size.height+vl_TabsView.frame.size.height+vl_UserView.frame.size.height), self.view.frame.size.width ,(126.0/480)*curSH )];
    vl_CommentView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];
    [self.view addSubview:vl_CommentView];
    //[vl_CommentView release];
    

    self._comments = [[comments alloc] initWithFrame:CGRectMake(commentsX,commentsY,commentsW,commentsH) ];
    
    self._comments.backgroundColor = [UIColor clearColor];
    
    _comments.commentArray = self.commentArray;
    
    _comments.commentCount = self.commentCount;
    
    [_comments initcommentsView];
    
    _comments._delegate = self;
    
    NSLog(@"self comments = %@",self._comments);
    
    [vl_CommentView addSubview:self._comments];
    
    
    
    if ([video_Cmt_Count intValue]>0)
    {
        vl_CommentView.hidden = NO;
        
    }
    else
    {
        vl_CommentView.hidden = YES;
    }
        
}



-(void)buildViewsCounts
{
    int  tabFontFize, tabheight, tabButtonW, tabButtonH;
    
    int lblX, lblY, lblW, lblH, fontsize;
    
   // int curSW = [[UIScreen mainScreen] bounds].size.width;
    int curSH = [[UIScreen mainScreen] bounds].size.height;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        tabFontFize = 15;
        tabheight = 28;
        tabButtonW = 70;
        tabButtonH = 24; 
        
        lblX = 220;
        lblY = 0;
        lblW = 110;
        lblH = 28;
        fontsize=10;
        
    }
    else
    {
        
        tabFontFize = 25;
        tabheight   = 62;
        tabButtonW  = 161;
        tabButtonH  = 52; 
        
        lblX = 464;
        lblY = 0;
        lblW = 272;
        lblH = 58;
        fontsize=30;
        
    }    
    
    vl_ViewCountView = [[UIView alloc] initWithFrame:CGRectMake(0,(vl_VideoView.frame.size.height+vl_TabsView.frame.size.height+vl_UserView.frame.size.height), self.view.frame.size.width ,(27.0/480)*curSH )];
    vl_ViewCountView.backgroundColor = [UIColor clearColor];
    [vl_MainView addSubview:vl_ViewCountView];
    [vl_ViewCountView release];
    
    
    
    NSString *countString = [NSString stringWithFormat:@"%@d ago    %@ views", self.videoDays, self.videoViewCount];
    
    
    txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(lblX, lblY, lblW, lblH)];
    
    txtLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:fontsize];
    
    txtLabel.textColor = [UIColor colorWithRed:146.0/255.0 green:24.0/255.0 blue:28.0/255.0 alpha:1];
    
    txtLabel.text = countString;
    
    //[vl_ViewCountView addSubview:txtLabel];
    
    
    
    
    
    
}

-(void)buildCustomVideo
{
    
    appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.boolVideoPlayer = 0;
    
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
    
    
    playerX=(9.0/320)*curSW;
    playerY=(0/480)*curSH;
    playerW=(282.0/320)*curSW;
    playerH=(203.0/480)*curSH;
    
    
    
    
    vl_VideoView = [[UIView alloc] initWithFrame:CGRectMake(10,150, self.view.frame.size.width-20,(223.0/480)*curSH )];
    [vl_MainView addSubview:vl_VideoView];
    
    
    
    
    
    
    _customVideoPlayer = [[customVideoPlayer alloc] initWithFrame:CGRectMake(playerX, playerY+10, playerW-30, playerH)];
    
     
    _customVideoPlayer.videoUrl =  self.videoUrl;
    
    _customVideoPlayer._delegate = self;
    
    [_customVideoPlayer initCustomVideoPlayer];
    
    [vl_VideoView addSubview:_customVideoPlayer];
    
    
    avLoader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
   	avLoader.frame=CGRectMake((vl_VideoView.frame.size.width-20)/2,(vl_VideoView.frame.size.height-20)/2,20,20);
    [_customVideoPlayer addSubview:avLoader];
    
    [avLoader startAnimating];

    
    
    
    vl_VideoView.backgroundColor = [UIColor colorWithRed:230.2/255 green:230.2/255 blue:230.2/255 alpha:1];
    
    [self.view bringSubviewToFront:_customVideoPlayer];
    
    
    
    
   // UILabel *lblTitle =[[UILabel alloc]initWithFrame:CGRectMake(playerX,0 ,200 ,21)];
    
    
    NSString *videoTitle = [NSString stringWithFormat:@"  %@", self.videoTitle];
    
    UILabel *tempLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(70, -30, 220, 21)];
    tempLabel2.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    tempLabel2.textColor = [UIColor whiteColor];
    
    tempLabel2.backgroundColor = [UIColor clearColor];
    tempLabel2.textAlignment = UITextAlignmentLeft;
    tempLabel2.text = videoTitle;
    
    [vl_VideoView addSubview:tempLabel2];
    [tempLabel2 release];

    
    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(0, -34, 60, 34)];
    lblDate.font = [UIFont fontWithName:@"BigNoodleTitling" size:20];
    lblDate.textColor = [UIColor redColor];
    
    lblDate.backgroundColor = [UIColor blackColor];
    lblDate.textAlignment = UITextAlignmentCenter;
    lblDate.text = self.video_Date;
    
    [vl_VideoView addSubview:lblDate];
    [lblDate release];

    
    //[_customVideoPlayer release];
    
    
    
    //controlTabH;
    //UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(15, 162, 281, 38) ];
    //tempView.backgroundColor = [UIColor colorWithRed:0/255.0 green:135/255.0 blue:130/255.0 alpha:1 ];
    //   /[vl_VideoView addSubview:tempView];
    
    
    
    
    [vl_VideoView release];
    
    
    
}

-(void)setHidden
{
    [avLoader stopAnimating];

}


-(void)buildUser
{
    int  tabFontFize, tabheight, tabButtonW, tabButtonH;
    int lblX, lblY, lblW, lblH, fontsize;
    int lbl2X, lbl2W;
    
    curSW = [[UIScreen mainScreen] bounds].size.width;
    curSH = [[UIScreen mainScreen] bounds].size.height;
    
    photoButton *button,  *lblButton;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        tabFontFize = 15;
        tabheight = 46;
        tabButtonW = 70;
        tabButtonH = 24; 
        
        lblX = 0;
        lblY = 16;
        lblW = 220;
        lblH = 33;
        fontsize=22;
        
        lbl2X = 131;
        lbl2W = 185;
        
        button=[[photoButton alloc]initWithFrame:CGRectMake(11, 17, 26, 26)];
    }
    else
    {
        
        tabFontFize = 25;
        tabheight = 100;    //122
        tabButtonW = 161;
        tabButtonH = 52;
        
        lblX = 93;
        lblY = 48;
        lblW = 700;
        lblH = 58;
        fontsize=30;
        
        lbl2X = 294;
        lbl2W = 422;
        
        
        button=[[photoButton alloc]initWithFrame:CGRectMake(35, 44, 56, 54)];
        
    }    
    
    vl_UserView = [[UIView alloc] initWithFrame:CGRectMake(0,vl_TabsView.frame.size.height+5, self.view.frame.size.width ,(45.0/480)*curSH)];
    vl_UserView.backgroundColor = [UIColor clearColor ];
    [vl_MainView addSubview:vl_UserView];
    [vl_UserView release];
    
    //button.tag = [self.videoUserId longLongValue]; 
    
    button.videoUserId = self.videoUserId;
    
    
    [button addTarget:self action:@selector(selectedUser:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    /*URL CACHE  CHECK*/
    NSArray *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* lastComponent = [NSString stringWithFormat:@"%@.jpg",self.videoUserId];
    NSString *path = [[searchPath objectAtIndex:0]  stringByAppendingString:[NSString stringWithFormat:@"/thumbData/%@",lastComponent]];
    
    NSLog(@"path --- %@",path);
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) 
    {
        path = [NSString stringWithFormat:@"file://localhost/private%@",path];
        NSData *dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
        [(photoButton*)button setBackgroundImage:[UIImage imageWithData:dataImage] forState:UIControlStateNormal];
    }else
    {
        [(photoButton*)button loadImage:self.videoUserUrl isLast:TRUE];  
    }
    
    
    
    
    
    
    [vl_UserView addSubview:button];
    
    
    
    
    NSString *videoUserName = [NSString stringWithFormat:@"  %@", self.videoUserName];
    
    
    NSLog(@"video  user name = %@",videoUserName);
    
    //lblButton
    
    lblButton= [photoButton buttonWithType:UIButtonTypeCustom];
    lblButton.frame = CGRectMake(lblX, lblY, lblW, lblH);
    [lblButton setTitle:videoUserName forState:UIControlStateNormal];
    lblButton.videoUserId = self.videoUserId;
    [lblButton addTarget:self action:@selector(selectedUser:) forControlEvents:UIControlEventTouchUpInside];
    [lblButton setTitleColor:[UIColor colorWithRed:0/255.0 green:181/255.0 blue:220/255.0 alpha:1] forState:UIControlStateNormal];
    lblButton.titleLabel.font =[UIFont fontWithName:@"BigNoodleTitling" size:fontsize];  
    //lblButton.titleLabel.font = [UIFont boldSystemFontOfSize:fontsize];
    lblButton.titleLabel.textAlignment = UITextAlignmentLeft;
    lblButton.backgroundColor = [UIColor clearColor];
    [vl_UserView addSubview:lblButton];
    
    
    //[lblButton release];
    
    /*
    UILabel *tempLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(lblX, lblY, lblW, lblH)];
    tempLabel1.font = [UIFont fontWithName:@"HelveticaNeue" size:fontsize];
    tempLabel1.textColor = [UIColor colorWithRed:146.0/255.0 green:24.0/255.0 blue:28.0/255.0 alpha:1];

    tempLabel1.text = videoUserName;
    
    [vl_UserView addSubview:tempLabel1];
    [tempLabel1 release];
    */
    
    
//    NSString *videoTitle = [NSString stringWithFormat:@"  %@", self.videoTitle];
//    
//    UILabel *tempLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(lbl2X, lblY, lbl2W, lblH)];
//    tempLabel2.font = [UIFont fontWithName:@"HelveticaNeue" size:fontsize];
//    tempLabel2.textColor = [UIColor whiteColor];
//    
//    tempLabel2.backgroundColor = [UIColor clearColor];
//    
//    tempLabel2.text = videoTitle;
//    
//    //[vl_UserView addSubview:tempLabel2];
//    [tempLabel2 release];
   
    
    
    UIButton *btnComments=[UIButton buttonWithType:UIButtonTypeCustom];
    btnComments.frame = CGRectMake(lbl2X+140, lblY+2, (39.0/320)*curSW, (28.0/480)*curSH);
    [btnComments addTarget:self action:@selector(showComments) forControlEvents:UIControlEventTouchUpInside]; 
    
    [btnComments setBackgroundImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
    
    
    //[btnComments setTitle:video_Cmt_Count forState:UIControlStateNormal];
    
    lblComments = [[UILabel alloc]initWithFrame:CGRectMake(3,3,32,16)];
    
    lblComments.text =video_Cmt_Count;
    
    
    lblComments.font = [UIFont fontWithName:@"Helvetica" size:11];
    
    lblComments.font = [UIFont boldSystemFontOfSize:11];
    
    lblComments.textColor = [UIColor whiteColor];
    
    lblComments.textAlignment = UITextAlignmentCenter;
    
    [btnComments addSubview:lblComments];
    
    lblComments.backgroundColor = [UIColor clearColor];
    
    //(btnComments).titleLabel.font =  [UIFont fontWithName:@"BigNoodleTitling" size:18];
    //[btnComments setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    btnComments.backgroundColor = [UIColor clearColor];
    [vl_UserView addSubview:btnComments];

    
    
    
}


-(void)showComments
{
    
    if ([commentArray count]>0)
    {
    
    if (boolComments==0) 
    {

        [self buildComments];
        
        [self flagHidden];
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.5];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromTop];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        [[vl_CommentView layer] addAnimation:animation forKey:@"SwitchToView1"];
        
        boolComments=1;
        [vl_CommentView setHidden:NO];
    }
    else
    {
        [vl_CommentView setHidden:YES];
        
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.5];
        [animation setType:kCATransitionReveal];
        [animation setSubtype:kCATransitionFromBottom];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        [[vl_CommentView layer] addAnimation:animation forKey:@"SwitchToView1"];
        
        boolComments =0;
    }
    }
}



-(void)setTabbuttons
{
    
    curSW = [[UIScreen mainScreen] bounds].size.width;
    curSH = [[UIScreen mainScreen] bounds].size.height;
    
    
    
    int tabFontFize, tabheight;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        tabFontFize = 10;
        tabheight = 32;
        /*tabButtonW = 70;
         tabButtonH = 24; */
        
        // button1=[[UIButton alloc]initWithFrame:CGRectMake(15, 0, 26, 32)];
        // button2=[[UIButton alloc]initWithFrame:CGRectMake(280, 0, 26, 32)];
    }
    else
    {
        
        tabFontFize = 25;
        tabheight = 52;
        /*tabButtonW = 161;
         tabButtonH = 52; */
        // button1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 56, 54)];
        // button2=[[UIButton alloc]initWithFrame:CGRectMake(700, 0, 56, 54)];
        
    }    
    
    
    
    button1=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, (30.0/320)*curSW , (30.0/480)*curSH )];
    
    imgBack = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5,(20.0/320)*curSW , (20.0/480)*curSH )];
    
    imgBack.image = [UIImage imageNamed:@"icon_back.png"];
    
    vl_TabsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width ,(34.0/480)*curSH )];
    //vl_TabsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width ,tabheight )];
    //vl_TabsView.backgroundColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1];
    vl_TabsView.backgroundColor = [UIColor clearColor];
    [vl_MainView addSubview:vl_TabsView];
    [vl_UserView release];
    
    
    
    [button1 addTarget:self action:@selector(backtoHome) forControlEvents:UIControlEventTouchUpInside]; 
    
    //[button1 setImage:[UIImage imageNamed:@"videoDetailsback.png"] forState:UIControlStateNormal];
    
    button1.userInteractionEnabled = NO;
    //[button1 setBackgroundImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor clearColor];
    [button1 addSubview:imgBack];
    [self.view addSubview:button1];
    [button1 release];
    
    
    if (appDelegate.userID) 
    {
        
        
        button2=[[UIButton alloc]initWithFrame:CGRectMake((293.0/320)*curSW, 25, (20.0/320)*curSW , (20.0/480)*curSH )];
        
        [button2 addTarget:self action:@selector(flagSelected) forControlEvents:UIControlEventTouchUpInside]; 
        
        [button2 setBackgroundImage:[UIImage imageNamed:@"icon_flag.png"] forState:UIControlStateNormal];
        
        //button2.backgroundColor = [UIColor clearColor];
        
        [vl_TabsView addSubview:button2];
        
        [button2 release];
        
        button2.hidden=YES;
        
        if (self.didReviewed==FALSE) 
        {
            button2.hidden=NO;
            
        }
        if (self.canDelete==TRUE) 
        {
            button2.hidden=NO;
            
        }  
    }    
    
    
}


-(void)updateViewCount
{
    
    UIDevice *myDevice = [UIDevice currentDevice];
	
	NSString *deviceUDID = [myDevice uniqueIdentifier];
	
    
 	NSString *urlString =[NSString stringWithFormat:@"%@media/view-count",ServerIp];
    
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
    [request setURL:[NSURL URLWithString:urlString]];\
    
    NSLog(@"urlString----%@",urlString);
	
    
    NSString *myParameters = [NSString stringWithFormat:@"method=media.video-view_count&user_id=%@&video_id=%d&device_id=%@",appDelegate.userID, appDelegate.videoTagId, deviceUDID];
    
    NSLog(@"%@",myParameters);
    
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    // now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"updateViewCount -- returnString ---%@",returnString);
    
    if (returnString) 
    {
       // NSError *error;
        //self.commentDetails  = [XMLReader  dictionaryForXMLString:returnString error:&error];
        // NSLog(@"%@", self.commentDetails);
        
    }
    
    [returnString release];
    
    
    
}






-(void)backtoHome
{
    
    if (_customVideoPlayer!=nil) {

        [_customVideoPlayer stopAndRemoveVideo];
        [_customVideoPlayer release];
        _customVideoPlayer = nil;
    }
    
    
    [self dismissModalViewControllerAnimated:YES];
    
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

-(void)goToUserVideos:(NSString*)commentUserId
{
    [_customVideoPlayer stopVideoPlaying];
    
    _userVL = [[userVideoListing alloc] init];
    
    _userVL.setY = @"down";
    
    _userVL.pageUserId = commentUserId;
    
    
    [self presentModalViewController:_userVL animated:YES];
     
}



-(void)selectedUser:(photoButton*)sender
{
    
    [_customVideoPlayer stopVideoPlaying];

    
    _userVL = [[userVideoListing alloc] init];
    
    _userVL.pageUserId = [sender videoUserId];
    
    NSLog(@"user id = %@",[sender videoUserId]);
    
    _userVL.setY = @"down";

        
    [self presentModalViewController:_userVL animated:YES];

}

-(void)redirectToLogin
{

    appDelegate.loginFlag = TRUE;
    
    [self dismissModalViewControllerAnimated:YES];

}


- (void)viewDidAppear:(BOOL)animated
{
    
    if (appDelegate.redirectToRoot == TRUE) 
    {
        
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [_customVideoPlayer playVideo];
    }
    
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
   
    
    if (fulscreen==TRUE) 
    {
        return YES;
    }
    else
    {
        return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown && interfaceOrientation == UIInterfaceOrientationPortrait);
    }   
    
    
    
    
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown && interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
