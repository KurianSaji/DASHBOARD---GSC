//
//  mediaPost.h
//  maximSocialVideo
//
//  Created by neo on 06/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<MobileCoreServices/MobileCoreServices.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

#import "epubstore_svcAppDelegate.h"
#import "customVideoPlayer.h"
#import "facebookdetailtable.h"
#import "XMLReader1.h"
#import "photoButton.h"
#import "userVideoListing.h"

#import "SSCameraViewController.h"
#import "avloader.h"


@interface mediaPost : UIViewController <UINavigationControllerDelegate, UIPickerViewDelegate, CLLocationManagerDelegate, MKReverseGeocoderDelegate, UITextFieldDelegate, UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{

    
    UITableView *aTableView;
    
    int curSW, curSH;
    
    UIView *vl_MainView, *vl_TabsView, *vl_UserView, *vl_VideoView, *vl_LocationView, *vl_videoDescView, *vl_BottomTabView;
    
    customVideoPlayer *_customVideoPlayer;
    
    CLLocation *location;
	
    CLLocationCoordinate2D locationCoordinate;
    
    CGFloat latit, longit;
    
    NSString *locationString;

    MKReverseGeocoder *reverseGeocoder; 
    
    //SSCameraViewController *imagePickerController;
    
    UITextField *textTitle;
    
    UITextView *textDescription;
    
    facebookdetailtable *_FBfriendsListCon;
    
    userVideoListing *_userVL;
    
    UIImagePickerController *imagePickerController;
    
    UIButton *btnStartRecord, *btnStopRecord, *btnLibrary, *btnCancel, *btnFlipCam;
    
    BOOL onFirst, fulscreen;
    
    UIImageView *backgroundImageView;

    avloader *_avloader;
    
    UILabel *nameLabel;
    
    NSDictionary *friendsList;

    epubstore_svcAppDelegate *appDelegate;
    
    //BOOL mediaPosted;
    
    NSMutableArray *tagArray;

}
 

@property(nonatomic, retain)userVideoListing *_userVL;

@property(nonatomic, retain)facebookdetailtable *_FBfriendsListCon;

@property(nonatomic, retain) NSString *locationString;

@property(nonatomic,retain) SSCameraViewController *imagePickerController;

@property(nonatomic,retain) CLLocationManager *locationManager;

@property(nonatomic,retain) MKReverseGeocoder *reverseGeocoder; ;

@property(assign)   CGFloat latit, longit;

@property(nonatomic,retain)NSDictionary *friendsList;


-(void)presentVideoMode;

-(void)postMediaWithDelay;

-(void)setTabbuttons;

-(void)backtoHome;

-(void)buildUser;

-(void)buildCustomVideo;

-(void)buildLocationView;

-(void)buildDescView;

-(void)buildBottomTab;

-(void)initMediaPost;

-(void)setFullScreenValueTrue;

-(void)setFullScreenValueFalse;

-(void)createTableView;

-(void)fetchFriendsList;

-(void)quitAndBackToHome;

@end
