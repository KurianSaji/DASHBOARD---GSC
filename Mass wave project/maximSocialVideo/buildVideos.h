//
//  buildVideos.h
//  maximSocialVideo
//
//  Created by neo on 29/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SingleVideo.h"
#import "epubstore_svcAppDelegate.h"
#import "avloader.h"

//#import "mediadetails.h"


//#import "videoListingThumbDetails.h"

@protocol mmsvViewMainDelegate

-(void)videoSelected ;
-(void)userSelected ;
-(void)enableLoader;
-(void)setHiddenActivity;
-(void)refreshList;

@end


@interface buildVideos : UIView <mediadetailDelegate,UIScrollViewDelegate>
{
    avloader *_avloader;

    
    UIScrollView *vl_scrollView;
    
    SingleVideo *_SingleVideo;
    
    //videoListingThumbDetails *vl_ThumbDetails;
    
    int videoCount, contentSize;
    
    
    
    //  mediadetails *_mediadetails;
    
    int currentPage;
    
    int vY;

    NSString *urlStr;
    
    UIActivityIndicatorView *actInd;
    
    int pageOffset;
    
    int pageCheck;
    
    
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
}
@property(assign)id<mmsvViewMainDelegate>_delegate;

@property(assign) int currentPage;

//@property(nonatomic, retain)mediadetails *_mediadetails;
@property(assign) int vY,videoCount;

@property (nonatomic,retain) NSString *urlStr;


@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;

- (void)setupStrings;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;



-(void)buildVideos;

-(void)calcContentSize;

-(void)videoSelected;  

-(void)enableLoader;

-(void)disableLoader;

@end
