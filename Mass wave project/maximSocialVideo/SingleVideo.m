//
//  SingleVideo.m
//  maximSocialVideo
//
//  Created by neo on 29/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SingleVideo.h"

@implementation SingleVideo

@synthesize videoThumbUrl, userImageUrl, createdDate, videoDesc, viewCount, videoId, videoUserId, videoConversion,commentsCount;

@synthesize userType;

//@synthesize _mediadetails;

@synthesize _delegate;

epubstore_svcAppDelegate *appDelegate;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    
    
    
    
    return self;
}
-(void)initSingleVideo
{
        
    sv_mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    sv_mainView.backgroundColor=[UIColor clearColor];
    [self addSubview:sv_mainView];
    
    [self setVideoThumb];
    
    [self setVideoDetails];
    
    [sv_mainView release];


}


-(void)setVideoDetails
{
    
    int curSW = [[UIScreen mainScreen] bounds].size.width;
    int curSH = [[UIScreen mainScreen] bounds].size.height;
    
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(70, 0, (240.0/320)*curSW, (170.0/480)*curSH)];
    
    photoButton *btnUser;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        
        sv_detailView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 55, 80)];
        btnUser=[[photoButton alloc]initWithFrame:CGRectMake(12, 56, 27, 28)];

    }
    else
    {    
        sv_detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 213, 327, 67)];
        btnUser=[[photoButton alloc]initWithFrame:CGRectMake(12, 8, 56, 54)];

    }
    
    
    backgroundView.backgroundColor=[UIColor colorWithRed:230.2/255 green:230.2/255 blue:230.2/255 alpha:1];
    [self addSubview:backgroundView];
    [self sendSubviewToBack:backgroundView];
    
    
    //sv_detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 99, 140, 32)];
    //sv_detailView.layer.borderColor = [UIColor redColor].CGColor;
   //   sv_detailView.layer.borderWidth = 1;
    
    
    //sv_detailView.backgroundColor=[UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1 ];
    sv_detailView.backgroundColor = [UIColor clearColor];
    [sv_mainView addSubview:sv_detailView];
   
    
    
    
    NSLog(@"video user id = %d",[videoUserId intValue]);
    
    
    btnUser.tag = [videoUserId intValue];
    btnUser.videoUserId = videoUserId;
    
    [btnUser addTarget:self action:@selector(userSelected:) forControlEvents:UIControlEventTouchUpInside];
    [sv_detailView addSubview:btnUser];
    
    
    
    NSArray *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* lastComponent = [NSString stringWithFormat:@"%@.jpg",videoUserId];
    NSString *path = [[searchPath objectAtIndex:0]  stringByAppendingString:[NSString stringWithFormat:@"/thumbData/%@",lastComponent]];
    
    NSLog(@"path --- %@",path);
    
    if (appDelegate.reachability==FALSE || [[NSFileManager defaultManager]fileExistsAtPath:path]) 
    {
        path = [NSString stringWithFormat:@"file://localhost/private%@",path];
        NSData *dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
        [(photoButton*)btnUser setBackgroundImage:[UIImage imageWithData:dataImage] forState:UIControlStateNormal];
    }else
    {
        [(photoButton*)btnUser loadImage:userImageUrl isLast:TRUE]; 
    }
       
     
     
 
    
    
    
    
    int lblFontSize;
    UILabel *videoName;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {    
        //videoName = [[UILabel alloc] initWithFrame:CGRectMake(28, 4, 113, 13)];
        lblFontSize = 12;
    }
    else
    {
        //videoName = [[UILabel alloc] initWithFrame:CGRectMake(68, 4, 259, 37)];
        lblFontSize = 20;
    }
    
    
    
    videoName = [[UILabel alloc] initWithFrame:CGRectMake((15.0/320)*curSW , (6.0/480)*curSH, (210.0/320)*curSW, (13.0/480)*curSH)];
    
    
    videoName.text =videoDesc;
    videoName.font = [UIFont fontWithName:@"Helvetica" size:lblFontSize];
    videoName.font = [UIFont boldSystemFontOfSize:12];

    videoName.textColor = [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1];
    videoName.textAlignment = UITextAlignmentLeft; 
    videoName.backgroundColor = [UIColor clearColor];
    
    [backgroundView addSubview:videoName];
    //[sv_detailView addSubview:videoName];
    [videoName release];
    
    
    UILabel *videoCreatedDate ;
   //if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        videoCreatedDate = [[UILabel alloc] initWithFrame:CGRectMake(-13, 0, 76, 18)];
//    else
//        videoCreatedDate = [[UILabel alloc] initWithFrame:CGRectMake(68, 37, 129, 30)];
     
    
   // videoCreatedDate = [[UILabel alloc] initWithFrame:CGRectMake((28.0/320)*curSW , (17.0/480)*curSH, (56.0/320)*curSW, (115.0/480)*curSH)];
                        
                        
    
    
    videoCreatedDate.text =createdDate;
//    videoCreatedDate.font = [UIFont fontWithName:@"HelveticaNeue" size:lblFontSize];
//    videoCreatedDate.font = [UIFont boldSystemFontOfSize:lblFontSize];
    [videoCreatedDate setFont:[UIFont fontWithName:@"BigNoodleTitling" size:22]];
    videoCreatedDate.textColor = [UIColor whiteColor];
    videoCreatedDate.textAlignment = UITextAlignmentCenter;
    videoCreatedDate.backgroundColor = [UIColor clearColor];
    [sv_detailView addSubview:videoCreatedDate];
    //videoCreatedDate.layer.borderColor  = [UIColor whiteColor].CGColor;
    //videoCreatedDate.layer.borderWidth = 1;
    [videoCreatedDate release];
    
    
    
    //UIImageView *commentsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 22,(39.0/320)*curSW, (28.0/480)*curSH)];
    
    UIButton *commentsImageView = [[UIButton alloc] initWithFrame:CGRectMake(6, 22,(39.0/320)*curSW, (28.0/480)*curSH)];
                                      
    //commentsImageView.image = [UIImage imageNamed:@"comment.png"];
    
    [commentsImageView setBackgroundImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
    
    [commentsImageView setBackgroundColor:[UIColor clearColor]];
    
    commentsImageView.tag = [videoId intValue];
    
    [commentsImageView addTarget:self action:@selector(goToVideoDetails:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lblComment = [[UILabel alloc] initWithFrame:CGRectMake(3, 3, 32, 16)];
    
    lblComment.font = [UIFont fontWithName:@"Helvetica" size:11];
    
    lblComment.font = [UIFont boldSystemFontOfSize:11];

    lblComment.text = commentsCount;
    
    NSLog(@"comments count = %@",commentsCount);
    
    lblComment.backgroundColor = [UIColor clearColor];
    
    lblComment.textAlignment = UITextAlignmentCenter;
    
    lblComment.textColor = [UIColor whiteColor];
    
    lblComment.textAlignment = UITextAlignmentCenter;
    
    [commentsImageView addSubview:lblComment];
    
    [sv_detailView addSubview:commentsImageView];
    
     
    UILabel *videoViewCount ;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        videoViewCount = [[UILabel alloc] initWithFrame:CGRectMake(172, 152, 56, 15)];
    else
        videoViewCount = [[UILabel alloc] initWithFrame:CGRectMake(197, 37, 129, 30)];
    videoViewCount.text = [NSString stringWithFormat:@"%@ VIEWS",viewCount];
    videoViewCount.font = [UIFont fontWithName:@"HelveticaNeue" size:lblFontSize];
    videoViewCount.font = [UIFont boldSystemFontOfSize:lblFontSize];
    videoViewCount.textColor = [UIColor colorWithRed:137/255.0 green:9/255.0 blue:28/255.0 alpha:1];
    videoViewCount.textAlignment = UITextAlignmentCenter;
    videoViewCount.backgroundColor = [UIColor clearColor];
    [sv_detailView addSubview:videoViewCount];
    [videoViewCount release];
    
     
    [backgroundView addSubview:videoViewCount];
    
    [backgroundView bringSubviewToFront:videoViewCount];
    
    [btnUser release];
    [sv_detailView release];
    

}


-(void)goToVideoDetails:(id)sender
{
    
    
    [self performSelectorInBackground:@selector(loadActivity) withObject:nil];

    appDelegate.boolComments = 1;
    NSLog(@"video id = %d",[sender tag]);
    if (appDelegate.reachability==FALSE)
    {
        [[[[UIAlertView alloc] initWithTitle:@"Message" message:@"No network connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease] show];
        return;
    }
    if ([commentsCount intValue]>0)
    {
    
        {
            appDelegate.videoTagId = [sender tag];
            [_delegate videoSelected];
            
        }
    }
    
    //[_avloader removeFromSuperview];
    [_delegate disableLoader];
    
}



-(void)setVideoThumb
{
    photoButtonResize *btnVideo;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        btnVideo=[[photoButtonResize alloc]initWithFrame:CGRectMake(85, 25, 210, 125)];
        
    }
    else
    {
        btnVideo=[[photoButtonResize alloc]initWithFrame:CGRectMake(0, 0, 327, 200)];
    
    }
     
    btnVideo.tag = [videoId intValue];
    btnVideo.videoUserId = videoId;
    
    
    
    [sv_mainView addSubview:btnVideo];
    
    
    [btnVideo addTarget:self action:@selector(videoSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    /**/
    
    
    NSArray *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* lastComponent = [self.videoThumbUrl lastPathComponent];
    NSString *path = [[searchPath objectAtIndex:0]  stringByAppendingString:[NSString stringWithFormat:@"/thumbData/%@",lastComponent]];
   
    
    
    
    
    
    NSLog(@"path --- %@",path);
    
     
    
    
    //if (appDelegate.reachability==FALSE || [[NSFileManager defaultManager] fileExistsAtPath:path]) 
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) 
    {

        path = [NSString stringWithFormat:@"file://localhost/private%@",path];
        NSData *dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];

        
        
        
        UIImage *tempImg = [UIImage imageWithData:dataImage];
        UIImage *tempImg3;
        if (tempImg.size.width>tempImg.size.height) {
            tempImg3 =[tempImg imageAtRect:CGRectMake((tempImg.size.width-tempImg.size.height)/2.0, 0, tempImg.size.width, 210)];
        }
        else{
            tempImg3 =[tempImg imageAtRect:CGRectMake(0, (tempImg.size.height-210)/2, tempImg.size.width , 210)];
        }
        
        UIImage *tempImg2 = [photoButtonResize imageWithImage:tempImg3 scaledToSize:CGSizeMake(280, 210)];
        
        
        
        
        
        
        
        [(photoButtonResize*)btnVideo setBackgroundImage:tempImg2 forState:UIControlStateNormal];
        
        NSLog(@"lastComponent-- %@",lastComponent);

    }
    else
    {
    
        [(photoButtonResize*)btnVideo loadImage:self.videoThumbUrl isLast:TRUE];
    
    }
    
       
     

    
    
     [btnVideo release];
    
    
    
}

 




-(void)userSelected:(id)sender
{
    
    if ([userType isEqualToString:@"other"])
    {
        [self performSelectorInBackground:@selector(loadActivity) withObject:nil];
        
        if (appDelegate.reachability==FALSE)
        {
            [[[[UIAlertView alloc] initWithTitle:@"Message" message:@"No network connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease] show];
            return;
            
        }
        
        appDelegate.selectedUserId = videoUserId ;
        [_delegate userSelected];
        //[_avloader removeFromSuperview];
        
        [_delegate disableLoader];
    }
    

}


-(void)videoSelected:(id)sender
{
    
    
    [self performSelectorInBackground:@selector(loadActivity) withObject:nil];
    appDelegate.boolComments = 0;
    if (appDelegate.reachability==FALSE)
    {
    
        [[[[UIAlertView alloc] initWithTitle:@"Message" message:@"No network connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease] show];
        return;
        
    }
    
    {
        appDelegate.videoTagId = [sender tag];
    
        
        [_delegate videoSelected];


    }
    
    //[_avloader removeFromSuperview];
    [_delegate disableLoader];
   
}


-(void)loadActivity
{
//    _avloader  = [[avloader alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width , self.frame.size.height+100)]; 
//    _avloader.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
//    [self addSubview:_avloader];
//    [self bringSubviewToFront:_avloader];
//    
//    
//    [_avloader initLoaderWithSize:CGSizeMake(100, 100)];
    [_delegate enableLoader];
    
}



-(void)dealloc
{

   // [sv_mainView release];
    
   // [sv_detailView release];

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
