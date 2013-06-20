//
//  mmsvViewController.h
//  maximSocialVideo
//
//  Created by neo on 28/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



#import "buildVideos.h"
#import "customButton.h"
//#import "FBConnect.h"
//#import "FBLoginDialog.h"
#import "login.h"
#import "mediadetails.h"
#import "userVideoListing.h"
#import "mediaPost.h"
#import "avloader.h"

@interface mmsvViewController : UIViewController <mmsvViewMainDelegate, loginDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
{
    
    UIActivityIndicatorView *actInd;
    
    NSUserDefaults *rankDefaults;
    
    UIView *vl_MainView, *vl_TabsView, *vl_BannerView, *vl_bottomView;
    
    UIImageView *backgroundImageView;
    
    UIButton *btnFeature, *btnHot, *btnFeed, *btnSignIn, *btnShare, *btnLogedUser,*btnRecent;
    
    
    BOOL featureSelected, hotSelected, feedSelected, recentSelected; 
    
    
    buildVideos *_buildVideos;
    
    //FBSession* _session;
	FBLoginDialog *_loginDialog;
	UIButton *_postGradesButton;
	UIButton *_logoutButton;
	NSString *_facebookName;
	BOOL _posting;
	NSMutableArray *friendsUid;
	UITextView *txtView;
	
	UITableView *aTableView;
    
    
    
    //Facebook*_facebook;
    NSArray*_permissions;
    
    
    
    
    
    
    NSString *email, *first_name, *last_name, *username, *gender;
    int userId, friendsCount;
    
    login *_login;
    
    mediadetails *_mediadetails;
    
    userVideoListing *_userVL;
    
    mediaPost *_mediaPost;
    
    int curSW, curSH; 
    
    NSString *selectedTab;
    
    UIButton *btnCancel, *btnStartRecord, *btnLibrary, *btnFlipCam, *btnStopRecord;
    
    UIImagePickerController *imagePickerController;
    
    BOOL redirectToPost;
    
    avloader *_avloader;
    
    int currentPage;
    
    UIImageView *loginImageView;
    
    UIButton *btnLogin;
    
    UIButton *btnCamera;
    
    UILabel *lblRank;
    
    UILabel *lblRankText;
    
     NSString *userImage , *userFLname, *pageUserId;
    
    NSMutableArray *userArray;
    
    
    NSMutableDictionary *imageDict;
    
    BOOL videoCaptureFlag;
    
    UIView *loadingView;
    
    UIActivityIndicatorView *activityView;
    
    BOOL boolLoading;
    
    NSUserDefaults *loginDefaults;
    
} 

@property(assign)int curSW, curSH;

@property(nonatomic, retain)mediadetails *_mediadetails;

@property(nonatomic, retain)userVideoListing *_userVL;

@property(nonatomic, retain)mediaPost *_mediaPost;

@property (nonatomic, strong)NSMutableArray *friendsUid;

//@property (nonatomic, strong) FBSession *session;

@property (nonatomic, retain) FBLoginDialog *loginDialog;

@property (nonatomic, copy) NSString *facebookName;

@property (nonatomic, assign) BOOL posting;


-(void)setTabbuttons;

- (void)setAddBanners;

-(void)buildVideos;

-(void)setbotomTab;

-(void)selectedShare;

-(void)getMyFBDetails;

-(void)loginToWeb;

-(void)redirectToLogin;

-(void)fbLogedIn;

-(void)loading;

-(void)loadActivity;

- (void) showTabBar:(UITabBarController *) tabbarcontroller;

-(void)videoSelected;

-(void)userSelected;

-(void)presentVideoMode;

-(void)presentPhotoMode;

-(void)dismissCamera;

-(void)postMediaWithDelay;

-(void)setHiddenActivity;

-(void)bottomTabLogout;

-(void)fetchUserDetail;

-(void)postPhotoWithDelay;

-(void)presentVideoLibrary;

-(void)presentPhotoLibrary;

-(void)refreshList;

-(void)buildVideos:(int)vI setPage:(int)curPage;

-(void)LoadIcon;

-(void)hideActivity;

@end
