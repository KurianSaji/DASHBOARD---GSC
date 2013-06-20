//
//  userBuildVideos.m
//  maximSocialVideo
//
//  Created by neo on 31/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "userBuildVideos.h"

#define REFRESH_HEADER_HEIGHT 52.0f


@implementation userBuildVideos

@synthesize _delegate;

@synthesize currentPage;

@synthesize videoCount;

@synthesize urlStr;

@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;


epubstore_svcAppDelegate*appDelegate;

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        pageCheck = 0;

        
        curSW = [[UIScreen mainScreen] bounds].size.width;
        curSH = [[UIScreen mainScreen] bounds].size.height;
        
        contentSize=0;
        currentPage =1;
        
        vl_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, self.frame.size.width , self.frame.size.height-20)];
        
        [vl_scrollView setContentSize: CGSizeMake(self.frame.size.width, contentSize)];
        
        vl_scrollView.scrollEnabled     =   YES;
        
        vl_scrollView.pagingEnabled     =   NO;
        
        vl_scrollView.delegate = self;
        
        vl_scrollView.backgroundColor=[UIColor clearColor];
        
        [self addSubview:vl_scrollView];
        
        NSLog(@"app data = %@",appDelegate.listData);
        
        
        videoCount = [[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"recordcnt"] objectForKey:@"text"] intValue];
        
        NSLog(@"video count = %d",videoCount);
        
        [self addPullToRefreshHeader];
        
        [self buildVideos];

    }
        
    
    
    return self;
}


-(void)buildVideos
{
    
    
    
    int vX, vW, vH;
    curSW = [[UIScreen mainScreen] bounds].size.width;
    curSH = [[UIScreen mainScreen] bounds].size.height;
    
    
    
    if (!vY)
    {
        vY = 18;
  
    }
       
    
    vW = 320;
    vH = 172;
    
    
    NSLog(@"video build count ---- %d",videoCount);
    NSString *tempVideoId, *tempVideoURL, *tempUserURL, *tempCreatedDate, *tempVideoDesc, *tempViewCount, *tempVideoUserId, *tempCommentsCount;
    if (videoCount>=1) 
    {
        for (int vI=0; vI<videoCount; vI+=1) {
            
            if (videoCount==1) 
            {
                
                
                tempVideoId = [[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"]  objectForKey:@"video_id"] objectForKey:@"text"];
                
                tempVideoURL = [[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"]  objectForKey:@"video_url"] objectForKey:@"text"];
                
                tempUserURL = [[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"]  objectForKey:@"user_img"] objectForKey:@"text"];
                
                tempCreatedDate = [[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"]  objectForKey:@"video_created"] objectForKey:@"text"];
                
                tempVideoDesc = [[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"]  objectForKey:@"video_title"] objectForKey:@"text"];
                
                tempViewCount = [[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"]  objectForKey:@"video_viewcnt"] objectForKey:@"text"];
                
                tempVideoUserId= [[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"]  objectForKey:@"user_id"] objectForKey:@"text"];
                
                tempCommentsCount = [[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"]  objectForKey:@"video_cmtcount"] objectForKey:@"text"];
                
            }else
            {    
                
                tempVideoId = [[[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectAtIndex:vI] objectForKey:@"video_id"] objectForKey:@"text"];
                
                tempVideoURL = [[[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectAtIndex:vI] objectForKey:@"video_url"] objectForKey:@"text"];
                
                tempUserURL = [[[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectAtIndex:vI] objectForKey:@"user_img"] objectForKey:@"text"];
                
                tempCreatedDate = [[[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectAtIndex:vI] objectForKey:@"video_created"] objectForKey:@"text"];
                
                tempVideoDesc = [[[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectAtIndex:vI] objectForKey:@"video_title"] objectForKey:@"text"];
                
                tempViewCount = [[[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectAtIndex:vI] objectForKey:@"video_viewcnt"] objectForKey:@"text"];
                
                tempVideoUserId = [[[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectAtIndex:vI] objectForKey:@"user_id"] objectForKey:@"text"];
                
                tempCommentsCount = [[[[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",currentPage]] objectForKey:@"videos"] objectForKey:@"video"] objectAtIndex:vI] objectForKey:@"video_cmtcount"] objectForKey:@"text"];
            }
            
            
            
            
            //vX  = 0;    //(8.0/320)*curSW;
            //if (vI!=1) 
            //{
                            //}
            
           
            vX  = (-6.0/320)*curSW;

            
            SingleVideo *tempView1 = [[SingleVideo alloc] initWithFrame:CGRectMake(vX, vY, vW, vH)];
            tempView1.backgroundColor=[UIColor clearColor];
            tempView1.userType = @"user";
            tempView1.videoThumbUrl = tempVideoURL;
            tempView1.userImageUrl = tempUserURL;
            tempView1.createdDate = tempCreatedDate;
            tempView1.videoDesc = tempVideoDesc;
            tempView1.viewCount = tempViewCount;
            tempView1.videoId  = tempVideoId;
            tempView1.videoUserId = tempVideoUserId;
            strVideoId = [[NSString alloc] init];
            strVideoId = tempVideoUserId;
            tempView1.commentsCount = tempCommentsCount;
            NSLog(@"videoDesc = %@",tempView1.videoDesc);
            //userImageUrl
            [vl_scrollView addSubview:tempView1];
            [tempView1 initSingleVideo];
            
            tempView1._delegate = self;
            
            [tempView1 release];
            

            
            
             vX =vW+33;
            
            
                
            vY = vY+172+9;
                
            contentSize = vY+100+9; 
            [vl_scrollView setContentSize: CGSizeMake(self.frame.size.width, contentSize)];

            
            
            
        }
    }
    else
    {
    
        UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(((50.0/320)*curSW), ((19.0/480)*curSH), ((250.0/320)*curSW), ((300.0/480)*curSH))];
        message.font = [UIFont fontWithName:@"HelveticaNeue" size:30];
        message.textColor = [UIColor colorWithRed:113.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:1];
        
        message.text = @"No media found";
        message.backgroundColor = [UIColor clearColor];
        [self addSubview:message];
        
        [message release];
    
    
    }
    
    if (pageCheck==0)
    {
        pageOffset = vl_scrollView.contentSize.height/2;
    }
    
    [_avloader removeFromSuperview];

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
                [self performSelectorInBackground:@selector(loadDatas) withObject:nil];
                
                pageCheck = count +1;
                [appDelegate fetchVideoListing:urlStr uid:strVideoId setCurrentPage:pageCheck];
                self.videoCount = [[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",pageCheck]]objectForKey:@"recordcnt"] objectForKey:@"text"] intValue];
                self.currentPage = pageCheck;
                [self buildVideos];
            }
        }
    }
    
    
}



-(void)loadDatas
{
    //    NSLog(@"value = %@",value);
    //    
    //    int countValue = [value integerValue];
    //    
    //    [appDelegate fetchVideoListing:urlStr uid:@"" setCurrentPage:countValue+1];
    //    self.videoCount = [[[[appDelegate.listData valueForKey:[NSString stringWithFormat:@"%d",countValue+1]]objectForKey:@"recordcnt"] objectForKey:@"text"] intValue];
    //    self.currentPage = countValue+1;
    //    [self buildVideos];
    
    NSLog(@"loading");
    _avloader  = [[avloader alloc] initWithFrame:CGRectMake(-10, -20, self.frame.size.width +10, self.frame.size.height+100)]; 
    _avloader.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
    [self addSubview:_avloader];
    [self bringSubviewToFront:_avloader];
    [_avloader initLoaderWithSize:CGSizeMake(100, 100)];
    
    [_avloader release];
}

-(void)userSelected
{

    [_delegate userSelected];
  

}

-(void)videoSelected
{
    
    
    [_delegate videoSelected];
    
}

-(void)enableLoader
{
    
    [_delegate enableLoader];
    
     
}

-(void)disableLoader
{
    
    [_delegate disableLoader];
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
