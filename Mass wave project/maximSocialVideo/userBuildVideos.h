//
//  userBuildVideos.h
//  maximSocialVideo
//
//  Created by neo on 31/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleVideo.h"
#import "avloader.h"


@protocol userbuildVideo

-(void)userSelected;
-(void)videoSelected;

-(void)enableLoader;
-(void)disableLoader;

-(void)refreshList;

@end

@interface userBuildVideos : UIView <UIScrollViewDelegate,mediadetailDelegate>
{

    UIScrollView *vl_scrollView;
    
    SingleVideo *_SingleVideo;
    
    int videoCount, contentSize, curSW, curSH;
    
    int currentPage;
    
    NSString *urlStr;

    int vY;
    
    NSString *strVideoId;
    
    avloader *_avloader;
    
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


@property(assign)id<userbuildVideo>_delegate;

@property (assign) int currentPage;

@property(assign) int videoCount;

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
-(void)loadDatas;

-(void)enableLoader;
-(void)disableLoader;

@end
