//
//  userVideoListing.h
//  maximSocialVideo
//
//  Created by neo on 31/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "photoButton.h"
#import "userBuildVideos.h"
#import "epubstore_svcAppDelegate.h"
#import "mediadetails.h"
#import "userSettings.h"
#import "avloader.h"
#import "photoButton.h"
#import "notifyView.h"
 
@class mediaPost;

@interface userVideoListing : UIViewController<UIPopoverControllerDelegate, UITableViewDelegate, UITableViewDataSource,userbuildVideo,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    mediaPost *_mediaPost;

    int curSW, curSH, notifyCount, newNotifyCount;
    
    UIView *vl_MainView, *vl_View, *vl_BottomTabView, *_notifyView;    
    
    UIButton *button1, *button2, *button3, *btnContent, *btnFollowing, *btnFollowers, *btnStarring;
    
    userBuildVideos *_userBuildVideos;
    
    BOOL contentSelected, followingSelected, followersSelected, starringSelected, bildListingTab, followed;
    
    NSString *userImage , *userFLname, *pageUserId;
    
    mediadetails *_mediadetails;
     
    userSettings *_userSettings;
        
    UIPopoverController *popoverController;
    
    UITableView *aTableView;
    
    NSDictionary *notifyDetails;
    
    NSArray *aNnotifyDetails;
    
    UILabel *lblNotifyCount;
    
    UIImageView *backgroundImageView;
    
    NSString *setY;
    
    avloader *_avloader;
    
    int currentPage;
    
    UIButton *btnContribute;
    
    UITableView *listTableView;
    
    BOOL boolFollow;
    
    int userCount;
    
    UILabel *message;
    
    UILabel *lblFollower;
    
    UIButton *buttonFollower;
 
    NSUserDefaults *rankDefaults;
    
    UILabel *lblRank;
    
    UILabel *lblRankText;
    
    UIImagePickerController *imagePickerController;
    
     UIButton *btnCancel, *btnStartRecord, *btnLibrary, *btnFlipCam, *btnStopRecord;
    
    NSMutableArray *userArray;
    
    NSMutableDictionary *imageDict;

}

@property(nonatomic, retain)mediadetails *_mediadetails;

@property(nonatomic, retain)userSettings *_userSettings;

@property(nonatomic, retain)NSString *pageUserId;

@property(nonatomic,retain) NSString *setY;



-(void)setNavTabbuttons;

-(void)buildUserView;

-(void)buildVideolisting;

-(void)followUser;

-(void)fetchUserDetail;

-(void)testMethod;

-(void)userSelected;

-(void)goToSettings;

-(void)buildBottomTab;

-(void)fetchNotification;

-(void)showNotifyPopup;

-(void)videoSelected;

-(void)resetNotifications;

-(void)presentVideoMode;

-(void)presentPhotoMode;

-(void)presentVideoLibrary;
-(void)presentPhotoLibrary;

-(void)enableLoader;

-(void)disableLoader;

-(void)refreshList;

@end
