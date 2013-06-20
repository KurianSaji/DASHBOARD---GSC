//
//  buildVideos.m
//  maximSocialVideo
//
//  Created by neo on 29/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "buildVideos.h"

#define REFRESH_HEADER_HEIGHT 52.0f

@implementation buildVideos

@synthesize _delegate;
@synthesize vY,videoCount;
@synthesize currentPage;
@synthesize urlStr;

@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;



epubstore_svcAppDelegate *appDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        pageCheck = 0;
       
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            contentSize=0;//302;
            
        }
        else
        {
            contentSize=0;//696;
        }
        
        vl_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, self.frame.size.width , self.frame.size.height-20)];
        [vl_scrollView setContentSize: CGSizeMake(self.frame.size.width, contentSize)];
        vl_scrollView.scrollEnabled  = YES;
        vl_scrollView.pagingEnabled=NO;
        vl_scrollView.delegate = self;
        vl_scrollView.backgroundColor=[UIColor clearColor];
        [self addSubview:vl_scrollView];
        
        [self addPullToRefreshHeader];
        
        [self buildVideos];
        
    }
    
    return self;
}




-(void)buildVideos
{
    

    int vX, vW, vH;
    int curSW = [[UIScreen mainScreen] bounds].size.width;
    
    
    
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if (!self.vY) {
            self.vY = 18;
        }
        
        vW = 320;
        vH = 172;
        
        
        
        
    }
    else
    {
        //vY = 35;
        vW = 325;
        vH = 202; 
        
    }
    
    
    NSString *tempVideoId, *tempVideoURL, *tempUserURL, *tempCreatedDate, *tempVideoDesc, *tempViewCount, *tempVideoUserId, *tempVideoConversion, *tempCommentsCount;
    
    
    for (int vI=0; vI<videoCount; vI+=1) {
        
        if (videoCount==1) {
            
            
            
            tempVideoId = [[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"]  objectForKey:@"video_id"] objectForKey:@"text"];
            
            tempVideoURL = [[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]]  objectForKey:@"videos"] objectForKey:@"video"]  objectForKey:@"video_url"] objectForKey:@"text"];
            
            tempVideoConversion = [[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"]  objectForKey:@"video_conversion"] objectForKey:@"text"];
            
             
            
            tempUserURL = [[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"]  objectForKey:@"user_img"] objectForKey:@"text"];
            
            tempCreatedDate = [[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"]  objectForKey:@"video_created"] objectForKey:@"text"];
            
            tempVideoDesc = [[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"]  objectForKey:@"video_title"] objectForKey:@"text"];
            
            tempViewCount = [[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"]  objectForKey:@"video_viewcnt"] objectForKey:@"text"];
            
            tempVideoUserId = [[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"]  objectForKey:@"user_id"] objectForKey:@"text"];
            
            tempCommentsCount = [[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"]  objectForKey:@"video_cmtcount"] objectForKey:@"text"];
            
            
            
        }else
        {    
            
            tempVideoId = [[[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectAtIndex:vI] objectForKey:@"video_id"] objectForKey:@"text"];
            
                         
            tempVideoURL = [[[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectAtIndex:vI] objectForKey:@"video_url"] objectForKey:@"text"];
            
            tempVideoConversion = [[[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectAtIndex:vI] objectForKey:@"video_conversion"] objectForKey:@"text"];
            
            
            tempUserURL = [[[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectAtIndex:vI] objectForKey:@"user_img"] objectForKey:@"text"];
            
            tempCreatedDate = [[[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectAtIndex:vI] objectForKey:@"video_created"] objectForKey:@"text"];
            
            tempVideoDesc = [[[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectAtIndex:vI] objectForKey:@"video_title"] objectForKey:@"text"];
            
            tempViewCount = [[[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectAtIndex:vI] objectForKey:@"video_viewcnt"] objectForKey:@"text"];
            
            tempVideoUserId = [[[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectAtIndex:vI] objectForKey:@"user_id"] objectForKey:@"text"];
            
            tempCommentsCount = [[[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectAtIndex:vI] objectForKey:@"video_cmtcount"] objectForKey:@"text"];
            
        }
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {    
            //vX  = 14;
            
            //if (vI!=1) {
                //contentSize +=(182); 
                contentSize =vY+172+9;
                [vl_scrollView setContentSize: CGSizeMake(self.frame.size.width, contentSize)];
            //}
        }
        else
        {
           // vX  = 32;
            
            if (vI!=1) {
                contentSize +=(696/2); 
                [vl_scrollView setContentSize: CGSizeMake(self.frame.size.width, contentSize)];
                
            }
            
        }
        
        vX  = (0.0/320)*curSW;
        
        SingleVideo *tempView1 = [[SingleVideo alloc] initWithFrame:CGRectMake(vX, vY, vW, vH)];
        tempView1.backgroundColor=[UIColor clearColor];
        tempView1.userType = @"other";

        tempView1.videoThumbUrl = tempVideoURL;
        tempView1.userImageUrl = tempUserURL;
        tempView1.createdDate = tempCreatedDate;
        tempView1.videoDesc = tempVideoDesc;
        tempView1.viewCount = tempViewCount;
        tempView1.videoId  = tempVideoId;
        
        
        tempView1.videoUserId = tempVideoUserId;
        tempView1.commentsCount =tempCommentsCount;

        tempView1.videoConversion = tempVideoConversion;
        //userImageUrl
        [vl_scrollView addSubview:tempView1];
        [tempView1 initSingleVideo];
        
        tempView1._delegate = self;
        
        [tempView1 release];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {    
            vX =vW+33; 
            
        }
        else
        {
            vX =vW+85; 
            
        }
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {    
                vY = vY+172+9; 
                
            }
            else
            {
                vY = vY+202+109;
                ;
            }
            
        }
    if (pageCheck==0)
    {
        pageOffset = vl_scrollView.contentSize.height/2;
    }
    
    //[_avloader removeFromSuperview];
    
    [self disableLoader];
}


- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    27, 44);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [vl_scrollView addSubview:refreshHeaderView];
    
    [self setupStrings];
}

- (void)setupStrings{
    textPull = [[NSString alloc] initWithString:@"Pull down to refresh..."];
    textRelease = [[NSString alloc] initWithString:@"Release to refresh..."];
    textLoading = [[NSString alloc] initWithString:@"Loading..."];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
       [_delegate refreshList];
    }
}

-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    
    
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            scrollView.contentInset =  UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            // User is scrolling above the header
            refreshLabel.text = self.textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = self.textPull;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }else
    {

    
        float scrollContentSizeHeight = scrollView.contentSize.height;
        float scrollOffset = scrollView.contentOffset.y;
        
        if (scrollOffset > scrollContentSizeHeight/2)
        {
            int count = scrollOffset/pageOffset;
       
            

                   
            int totalCount = [[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"total"] objectForKey:@"text"] intValue];
            float pageCount = roundf(totalCount/30.0);
            

            
            if (count+1<=pageCount && count+1>pageCheck)
            {
                [self performSelectorInBackground:@selector(enableLoader) withObject:nil];
                isLoading = YES;
                pageCheck = count +1;
                [appDelegate fetchVideoListing:urlStr uid:@"" setCurrentPage:pageCheck];
                self.videoCount = [[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",pageCheck]]objectForKey:@"recordcnt"] objectForKey:@"text"] intValue];
                self.currentPage = pageCheck;
                [self buildVideos];
                isLoading = NO;
            }
            
        
            
        }
    }
   
    
}


//-(void)loadDatas
-(void)enableLoader
{
    
    [_delegate enableLoader];

//    _avloader  = [[avloader alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width , self.frame.size.height+100)]; 
//    _avloader.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
//    [self addSubview:_avloader];
//    [self bringSubviewToFront:_avloader];
//    [_avloader initLoaderWithSize:CGSizeMake(100, 100)];
//    
//    [_avloader release];
}

-(void)disableLoader
{

    [_delegate setHiddenActivity];
}
-(void)videoSelected
{
    
    
    [_delegate videoSelected];
    
}
-(void)userSelected
{

    [_delegate userSelected];

}
-(void)dealloc
{
    
    
    [vl_scrollView release];
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
