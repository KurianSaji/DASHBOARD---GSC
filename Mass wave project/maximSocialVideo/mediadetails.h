//
//  mediadetails.h
//  maximSocialVideo
//
//  Created by neo on 19/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "customVideoPlayer.h"
#import "comments.h"
#import "XMLReader.h"
#import "photoButton.h"
#import "epubstore_svcAppDelegate.h"


@class userVideoListing;







@interface mediadetails : UIViewController <UITextFieldDelegate,UIScrollViewDelegate>
{
    UIImageView *backgroundImageView;
    
    UIView *vl_MainView, *vl_TabsView, *vl_UserView, *vl_VideoView, *vl_ViewCountView, *vl_CommentView, *vl_BottomTabView, *vl_FlagView;
    
    
    customVideoPlayer *_customVideoPlayer;
    comments *_comments;
    
    
    UILabel *txtLabel;
    
    NSDictionary *videoDetails, *commentDetails;
    
    
    NSURL *videoUrl;
    
    NSString  *videoThumbUrl, *videoUserId, *videoUserUrl, *videoUserName, *videoTitle, *videoDesc, *videoExt, *videoDays, *videoLocation, *videoViewCount, *video_id, *video_Date, *video_Cmt_Count,*waveUpDown;
    
    int commentCount, likeCount;
    
    NSArray *commentArray;
    
    
    UIButton *btnPost;
    
    UITextField * textFieldRounded;
    
    BOOL didLike, didReviewed, canDelete, onFirst;
    
    UIButton *btnLike,*btnUnlike;
    
    UILabel *lblLikeCount; 
    
    UIImageView *likeIV;
    
    
    int curSW, curSH;
    
    UIButton *btnReview, *btnDelete, *btnCancel;
    
    //flag buttons
    UIButton *button1, *button2;
    
    userVideoListing *_userVL;

    BOOL fulscreen;
    
    BOOL boolComments;

    UILabel *lblComments;
    
    UIActivityIndicatorView *avLoader;
    
    NSMutableArray *imagesArray;
    
    UIScrollView *vl_scrollView;

    int imgCount;
    
    UIImageView *imgBack;
    
    int waveType;
    
    int mediaType;
    
    NSString *videoType;
}

@property(nonatomic, retain)userVideoListing *_userVL;

@property(assign)int curSW, curSH;

@property(nonatomic, retain)UIImageView *likeIV;

@property(nonatomic, retain)UIButton *btnLike;

@property(nonatomic, retain)UILabel *lblLikeCount;

@property(assign)BOOL didLike, didReviewed, canDelete;

@property(nonatomic, retain)UITextField * textFieldRounded;

@property(nonatomic, retain)UIButton *btnPost;

@property(assign)int commentCount, likeCount;

@property(nonatomic, retain)NSArray *commentArray;


@property(nonatomic, retain)NSURL *videoUrl;

@property(nonatomic, retain)NSString  *videoThumbUrl, *videoUserId, *videoUserUrl, *videoUserName, *videoTitle, *videoDesc, *videoExt, *videoDays, *videoLocation, *videoViewCount, *video_id, *video_Date, *video_Cmt_Count, *waveUpDown; 

@property(nonatomic, retain) NSDictionary *videoDetails, *commentDetails;

@property(nonatomic, retain)UILabel *txtLabel;

@property(nonatomic, retain)customVideoPlayer *_customVideoPlayer;
@property(nonatomic, retain)comments *_comments;

-(void)fetchCommentsDetails;
-(void)fetchVideoDetails;


-(void)buildBottomTab;
-(void)buildComments;
-(void)buildViewsCounts;
-(void)buildCustomVideo;
-(void)buildUser;
-(void)setTabbuttons;
-(void)updateViewCount;
-(void)backtoHome;
-(void)updateLikeCount;
-(void)buildFlagForReview;

-(void)sendFlagForReview;
-(void)deleteVideo;
-(void)cancelFlag;
-(void)fetchNotification;
-(void)goToUserVideos:(int)commentUserId;
-(void)onExitFullScreen;
-(void)checkIsInFullScreen1;

-(void)showComments;

-(NSString *) GetValueInXML:(NSString *)xmlString SearchStr:(NSString *)SearchStr;

-(void)createScrollView;
-(void)createButton;

-(float)setscrollHeight:(NSString *)string btnindex:(NSInteger)btnIndex ypos:
(float)yPos ;

-(BOOL)checkFileExist:(NSString*)filename;


@end
