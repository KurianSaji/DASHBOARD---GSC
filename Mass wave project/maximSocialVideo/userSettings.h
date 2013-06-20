//
//  userSettings.h
//  maximSocialVideo
//
//  Created by neo on 03/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "epubstore_svcAppDelegate.h"
#import "customButton.h"
#import "photoButton.h"

//#import "FBConnect.h"
//#import "FBLoginDialog.h"

#import "login.h";

@interface userSettings : UIViewController <FBSessionDelegate>
{
    UIView *vl_MainView, *vl_TabsView, *vl_UserView, *vl_InfoView, *vl_FNameView,  *vl_LNameView,
    *vl_UNameView, *vl_EmailView, *vl_BottomTabView, *vl_AboutView;
    
    int curSW, curSH;

    NSString *userFname, *userLname, *userName, *email; 

    //Facebook*_facebook;
    
    UIImageView *backgroundImageView;
    
    NSUserDefaults *loginDefaults;

    
}

-(void)fetchUserSettings;

-(void)setTabbuttons;

-(void)buildInfo;

-(void)buildBottomTab;

@end
