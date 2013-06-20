//
//  login.h
//  maximSocialVideo
//
//  Created by neo on 12/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "customButton.h"
#import "FBConnect.h"
#import "FBLoginDialog.h"
#import "epubstore_svcAppDelegate.h"


@protocol loginDelegate  

-(void)fbLogedIn;

@end

@interface login : UIViewController <FBSessionDelegate, loginDelegate>
{
    
    //Facebook*_facebook;
    NSArray*_permissions;
    

    NSString *email, *first_name, *last_name, *username, *gender, *userId;
    int  friendsCount;
    
    login *_login;

    
    NSUserDefaults *rankDefaults;
    
    NSUserDefaults *loginDefaults;
}

@property(assign)id<loginDelegate>_delegate;

//@property (nonatomic, strong)NSMutableArray *friendsUid;

@property(nonatomic, retain)UIButton *btnCancel, *btnFbLogin;

@property(nonatomic, retain)UIView *lgn_MainView, *lgn_bottomView, *lgn_LoginView;


-(void)setbotomTab;

-(void)cancelLogin;

-(void)loadLoginButtons;

-(void)logoutFB;

-(NSString *) GetValueInXML:(NSString *)xmlString SearchStr:(NSString *)SearchStr;

-(void)facebtnact;

-(void)fetchfFriends;

+(FacebookMassWave*)initFb;

+(void)nilFb;

@end
