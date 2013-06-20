//
//  DetailViewController.m
//  epubstore_svc
//
//  Created by partha neo on 9/1/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import "UserXMLParser.h"
#import "epubstore_svcAppDelegate.h"

#define kTFWidth 240
#define kAbtLAbelWidth 400
#define kAbtLAbelHeight 300

static int i = 0;
static int rememberMecount = 1;

static UIView *myView;

@implementation DetailViewController

@synthesize navigationBar, popoverController, detailItem;
UITextField *emailTF;
//UITextField *userTF;
UITextField *cnfrmLabelTF;
UITextField *passwordTF;
UITextField *pwdTF;
UITextField *mailTF;
UITextField *fnTF;
UITextField *lnTF ;
UITextField *postalTF;
BOOL shouldRegister = NO;

UITextField *firstResponder;
#pragma mark -
#pragma mark Managing the popover controller

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(id)newDetailItem
{
    if (detailItem != newDetailItem) 
	{
        [detailItem release];
        detailItem = [newDetailItem retain];
        
        // Update the view.
        //navigationBar.topItem.title = [detailItem description];
		
		titleLabel.text = navigationBar.topItem.title = @"Settings"; //[detailItem description];
		navigationBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top-white.png"]];
		[titleBar setHidden:NO];
		[titleBg setHidden:NO];
		[titleLabel setHidden:NO];
		titleBar.frame = CGRectMake(0, 0, 768, 43);
		titleBg.frame = CGRectMake(768/2-250/2, 0, 250, 41);
		titleLabel.frame = CGRectMake(768/2-250/2, 0, 250, 41);

		/*
		epubstore_svcAppDelegate *appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
		appDelegate.splitViewController.delegate = self;
		*/
		
		if(myView == nil)
		{
			myView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 768, 900)];
			[myView setBackgroundColor:[UIColor blackColor]];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"rite-side-img-about-bg.png"]]];
			[self.view addSubview:myView];
		}
		
		isReg = FALSE;
		
		if([newDetailItem isEqualToString:@"Row 3"])
		{
			printf("\n Sign In / Register selected...");
			if (appDelegate.loginAuthKey!=nil) {
				navigationBar.topItem.title = @"Sign Out";
				titleLabel.text = @"Sign Out";
				navigationBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top_white_bar.png"]];
				[self loadSignOut];
			}
			else {
				navigationBar.topItem.title = @"Sign In";
				titleLabel.text = @"Sign In";
				navigationBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top_white_bar.png"]];
				[self loadSignInView];
			}

			
		}
		else if([newDetailItem isEqualToString:@"Row 1"])
		{
			printf("\n Set Reading Preferences selected...");
			titleLabel.text = @"Preferences";
			navigationBar.topItem.title = @"Preferences";
			navigationBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top_white_bar.png"]];
			[self loadPrefView];
		}
		else if([newDetailItem isEqualToString:@"Row 2"])
		{
			printf("\n About This App selected...");
			titleLabel.text = @"About";
			navigationBar.topItem.title = @"About";
			navigationBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top_white_bar.png"]];
			[self loadAboutAppView];
		}
    }

    if (popoverController != nil) 
	{
        [popoverController dismissPopoverAnimated:YES];
    }
}

#pragma mark -
#pragma mark Detail View


-(void)loadSignOut
{
//	for(UIView *subview in myView.subviews)
//	{
//		[subview removeFromSuperview];
//	}
//	UIImageView *fullbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 968)];// 20, 125, 200, 200)];
//	fullbg.image = [UIImage imageNamed:@"rite-side-img-about-bg.png"];
//	//[fullbg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rite-side-img-about-bg.png"]]];
//	[myView addSubview:fullbg];
//	[fullbg release];
//	
//	UIImageView *smallBg = [[UIImageView alloc] initWithFrame:CGRectMake(10,10, 423, 156)];// 20, 125, 200, 200)];
//	smallBg.image = [UIImage imageNamed:@"round-border.png"];
//	//[fullbg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rite-side-img-about-bg.png"]]];
//	[myView addSubview:smallBg];
//	[smallBg release];
//	
//	UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(25, 20, 350, 40)];
//	userName.text = @"Do you want to signout ";
//	userName.backgroundColor = [UIColor clearColor];
//	userName.font = [UIFont systemFontOfSize:20];
//	userName.textAlignment = UITextAlignmentCenter;
//	userName.textColor = [UIColor whiteColor];
//	[myView addSubview:userName];
//	[userName release];
//	
//	
//	UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(170, 125, 100, 27)];
//	[submitBtn addTarget:self action:@selector(logoutAction:) 
//		forControlEvents:UIControlEventTouchUpInside];
//	[submitBtn setBackgroundImage:[UIImage imageNamed:@"button-bg.png"] forState:UIControlStateNormal];
//	[submitBtn setTitle:@"Sign Out" forState:UIControlStateNormal];
//	[submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//	[myView addSubview:submitBtn];
//	[submitBtn release];
	
	
	
	
}
-(void)loadSignInView
{
//	//self.view.backgroundColor = [UIColor blackColor];
//	
//	for(UIView *subview in myView.subviews)
//	{
//		[subview removeFromSuperview];
//	}
//	
//	if(isReg == FALSE)
//	{
//		
//		UIImageView *fullbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 968)];// 20, 125, 200, 200)];
//		fullbg.image = [UIImage imageNamed:@"rite-side-img-about-bg.png"];
//		//[fullbg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rite-side-img-about-bg.png"]]];
//		[myView addSubview:fullbg];
//		[fullbg release];
//		
//		UIImageView *smallBg = [[UIImageView alloc] initWithFrame:CGRectMake(10,10, 423, 156)];// 20, 125, 200, 200)];
//		smallBg.image = [UIImage imageNamed:@"round-border.png"];
//		//[fullbg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rite-side-img-about-bg.png"]]];
//		[myView addSubview:smallBg];
//		[smallBg release];
//		
//		
//		UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 150, 40)];
//		emailLabel.text = @"Email Address";
//		emailLabel.backgroundColor = [UIColor clearColor];
//		emailLabel.font = [UIFont systemFontOfSize:16];
//		emailLabel.textAlignment = UITextAlignmentLeft;
//		emailLabel.textColor = [UIColor whiteColor];
//		[myView addSubview:emailLabel];
//		[emailLabel release];
//		
//		emailTF = [[UITextField alloc] initWithFrame:CGRectMake(170, 20, kTFWidth, 40)];
//		emailTF.placeholder = @"tap to enter";
//		emailTF.borderStyle = UITextBorderStyleRoundedRect;
//		emailTF.delegate = self;
//		emailTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//		emailTF.textAlignment = UITextAlignmentLeft;
//		emailTF.backgroundColor = [UIColor clearColor];
//		emailTF.delegate = self;
//		[myView addSubview:emailTF];
//		[emailTF release];
//		
//		UILabel *pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 70, 150, 40)];
//		pwdLabel.text = @"Password";
//		pwdLabel.backgroundColor = [UIColor clearColor];
//		pwdLabel.font = [UIFont systemFontOfSize:16];
//		pwdLabel.textAlignment = UITextAlignmentLeft;
//		pwdLabel.textColor = [UIColor whiteColor];
//		[myView addSubview:pwdLabel];
//		[pwdLabel release];
//		
//		pwdTF = [[UITextField alloc] initWithFrame:CGRectMake(170, 70, kTFWidth, 40)];
//		pwdTF.placeholder = @"tap to enter";
//		pwdTF.borderStyle = UITextBorderStyleRoundedRect;
//		pwdTF.delegate = self;
//		pwdTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//		pwdTF.textAlignment = UITextAlignmentLeft;
//		pwdTF.backgroundColor = [UIColor clearColor];
//		pwdTF.secureTextEntry = YES;
//		pwdTF.delegate = self;
//		[myView addSubview:pwdTF];
//		[pwdTF release];
//		
//		
//		UILabel *rememberMeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 120, 150, 40)];
//		rememberMeLabel.text = @"Remember Me";
//		rememberMeLabel.backgroundColor = [UIColor clearColor];
//		rememberMeLabel.font = [UIFont systemFontOfSize:14];
//		rememberMeLabel.textAlignment = UITextAlignmentLeft;
//		rememberMeLabel.textColor = [UIColor whiteColor];
//		[myView addSubview:rememberMeLabel];
//		[rememberMeLabel release];
//		
//		rememberMeButton = [[UIButton alloc] initWithFrame:CGRectMake(170, 125, 30, 30)];
//		[rememberMeButton addTarget:self action:@selector(rememberMeButtonAction:) 
//		   forControlEvents:UIControlEventTouchUpInside];
//		rememberMeButton.clipsToBounds = YES;
//		//[rememberMeButton setImage:[UIImage imageNamed:@"with-out-tick-img.png"] forState:UIControlStateNormal];
//		[rememberMeButton setImage:[UIImage imageNamed:@"tick-img.png"] forState:UIControlStateNormal];
//		[rememberMeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//		[myView addSubview:rememberMeButton];
//		[rememberMeButton release];
//		
//		
//		
//		
//		UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(170, 175, 100, 27)];
//		[submitBtn addTarget:self action:@selector(sumbitAction:) 
//			forControlEvents:UIControlEventTouchUpInside];
//		[submitBtn setBackgroundImage:[UIImage imageNamed:@"button-bg.png"] forState:UIControlStateNormal];
//		[submitBtn setTitle:@"SUBMIT" forState:UIControlStateNormal];
//		[submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//		[myView addSubview:submitBtn];
//		[submitBtn release];
//		
//		UIButton *forgotpwdBtn = [[UIButton alloc] initWithFrame:CGRectMake(290, 175, 130, 27)];
//		
//		[forgotpwdBtn addTarget:self action:@selector(fpwdAction:) 
//			   forControlEvents:UIControlEventTouchUpInside];
//		[forgotpwdBtn setBackgroundImage:[UIImage imageNamed:@"MenuBar.png"] forState:UIControlStateNormal];
//		[forgotpwdBtn setTitle:@"Forgot Password" forState:UIControlStateNormal];
//		[forgotpwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//		forgotpwdBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
//		[myView addSubview:forgotpwdBtn];
//		[forgotpwdBtn release];
//		
//		//UILabel *underlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(305, 150, 100, 1)];
////		underlineLabel.backgroundColor = [UIColor whiteColor];
////		[myView addSubview:underlineLabel];
////		[underlineLabel release];
//		
//		UIImageView *signInbg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 275, 429, 88)];// 20, 125, 200, 200)];
//		signInbg.image = [UIImage imageNamed:@"to-register-content-bg.png"];
//		//[fullbg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rite-side-img-about-bg.png"]]];
//		[myView addSubview:signInbg];
//		[signInbg release];
//		
//		UILabel *hvntLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 285, 409, 60)];
//		hvntLabel.text = @"Haven’t registered yet? You need to register and sign in to purchase books.";
//		hvntLabel.numberOfLines = 0;
//		hvntLabel.backgroundColor = [UIColor clearColor];
//		hvntLabel.font = [UIFont systemFontOfSize:18];
//		hvntLabel.textAlignment = UITextAlignmentLeft;
//		hvntLabel.textColor = [UIColor blackColor];
//		[myView addSubview:hvntLabel];
//		[hvntLabel release];
//		
//		UIButton *regBtn = [[UIButton alloc] initWithFrame:CGRectMake(275, 345, 139, 27)];
//		[regBtn addTarget:self action:@selector(registerAction:) 
//		 forControlEvents:UIControlEventTouchUpInside];
//		[regBtn setBackgroundImage:[UIImage imageNamed:@"button-bg.png"] forState:UIControlStateNormal];
//		[regBtn setTitle:@"REGISTER" forState:UIControlStateNormal];
//		[regBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//		[myView addSubview:regBtn];
//		[regBtn release];
//		
//		UIImageView *termsOfUseBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 820, 431, 49)];// 20, 125, 200, 200)];
//		termsOfUseBg.image = [UIImage imageNamed:@"privacy-butt-bg.png"];
//		[myView addSubview:termsOfUseBg];
//		[termsOfUseBg release];
//		
//		UIButton *pPolicyBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 825, 200, 39)];
//		[pPolicyBtn addTarget:self action:@selector(policyAction:) 
//			 forControlEvents:UIControlEventTouchUpInside];
//		//[pPolicyBtn setBackgroundColor:[UIColor grayColor]];
//		[pPolicyBtn setTitle:@"Privacy Policy" forState:UIControlStateNormal];
//		
//		[pPolicyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//		[myView addSubview:pPolicyBtn];
//		[pPolicyBtn release];
//		
//		UIButton *tofuseBtn = [[UIButton alloc] initWithFrame:CGRectMake(230, 825, 200, 39)];
//		[tofuseBtn addTarget:self action:@selector(termsofuseAction:) 
//			forControlEvents:UIControlEventTouchUpInside];
//		//[tofuseBtn setBackgroundColor:[UIColor grayColor]];
//		[tofuseBtn setTitle:@"Terms Of Use" forState:UIControlStateNormal];
//		[tofuseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//		[myView addSubview:tofuseBtn];
//		[tofuseBtn release];		
//		
//		
//	}
//	else if(isReg == TRUE)
//	{
//		isReg = FALSE;
//		shouldRegister =YES;
//		
//		UIImageView *fullbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 448, 1024)];// 20, 125, 200, 200)];
//		fullbg.image = [UIImage imageNamed:@"sign-in-preference-rite-side-bg.png"];
//		//[fullbg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rite-side-img-about-bg.png"]]];
//		[myView addSubview:fullbg];
//		[fullbg release];
//		
//		//UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 150, 40)];
////		userLabel.text = @"User Name";
////		userLabel.backgroundColor = [UIColor clearColor];
////		userLabel.font = [UIFont systemFontOfSize:16];
////		userLabel.textAlignment = UITextAlignmentLeft;
////		userLabel.textColor = [UIColor whiteColor];
////		[myView addSubview:userLabel];
////		[userLabel release];
////		
////		userTF = [[UITextField alloc] initWithFrame:CGRectMake(170, 20, kTFWidth, 40)];
////		userTF.placeholder = @"tap to enter";
////		userTF.borderStyle = UITextBorderStyleRoundedRect;
////		userTF.delegate = self;
////		userTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
////		userTF.textAlignment = UITextAlignmentLeft;
////		userTF.backgroundColor = [UIColor clearColor];
////		userTF.delegate = self;
////		[myView addSubview:userTF];
////		[userTF release];
//		
//		UILabel *mailLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 150, 40)];
//		mailLabel.text = @"Email Address";
//		mailLabel.backgroundColor = [UIColor clearColor];
//		mailLabel.font = [UIFont systemFontOfSize:16];
//		mailLabel.textAlignment = UITextAlignmentLeft;
//		mailLabel.textColor = [UIColor whiteColor];
//		[myView addSubview:mailLabel];
//		[mailLabel release];
//		
//		mailTF = [[UITextField alloc] initWithFrame:CGRectMake(170, 20, kTFWidth, 40)];
//		mailTF.placeholder = @"tap to enter";
//		mailTF.borderStyle = UITextBorderStyleRoundedRect;
//		mailTF.delegate = self;
//		mailTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//		mailTF.textAlignment = UITextAlignmentLeft;
//		mailTF.backgroundColor = [UIColor clearColor];
//		mailTF.delegate = self;
//		[myView addSubview:mailTF];
//		[mailTF release];
//		
//		
//		UILabel *cnfrmLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 70, 150, 40)];
//		cnfrmLabel.text = @"Password";
//		cnfrmLabel.backgroundColor = [UIColor clearColor];
//		cnfrmLabel.font = [UIFont systemFontOfSize:16];
//		cnfrmLabel.textAlignment = UITextAlignmentLeft;
//		cnfrmLabel.textColor = [UIColor whiteColor];
//		[myView addSubview:cnfrmLabel];
//		[cnfrmLabel release];
//		
//		cnfrmLabelTF = [[UITextField alloc] initWithFrame:CGRectMake(170, 70, kTFWidth, 40)];
//		cnfrmLabelTF.placeholder = @"tap to enter";
//		cnfrmLabelTF.borderStyle = UITextBorderStyleRoundedRect;
//		cnfrmLabelTF.delegate = self;
//		cnfrmLabelTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//		cnfrmLabelTF.textAlignment = UITextAlignmentLeft;
//		cnfrmLabelTF.backgroundColor = [UIColor clearColor];
//		cnfrmLabelTF.delegate=self;
//		cnfrmLabelTF.secureTextEntry = YES;
//		[myView addSubview:cnfrmLabelTF];
//		[cnfrmLabelTF release];
//		
//		UILabel *passwordLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 120, 150, 40)];
//		passwordLab.text = @"Retype Password";
//		passwordLab.backgroundColor = [UIColor clearColor];
//		passwordLab.font = [UIFont systemFontOfSize:16];
//		passwordLab.textAlignment = UITextAlignmentLeft;
//		passwordLab.textColor = [UIColor whiteColor];
//		[myView addSubview:passwordLab];
//		[passwordLab release];
//		
//		passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(170, 120, kTFWidth, 40)];
//		passwordTF.placeholder = @"tap to enter";
//		passwordTF.borderStyle = UITextBorderStyleRoundedRect;
//		passwordTF.delegate = self;
//		passwordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//		passwordTF.textAlignment = UITextAlignmentLeft;
//		passwordTF.backgroundColor = [UIColor clearColor];
//		passwordTF.delegate = self;
//		passwordTF.secureTextEntry = YES;
//		[myView addSubview:passwordTF];
//		[passwordTF release];
//		
//		
//		UILabel *fnLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 170, 150, 40)];
//		fnLabel.text = @"First Name";
//		fnLabel.backgroundColor = [UIColor clearColor];
//		fnLabel.font = [UIFont systemFontOfSize:16];
//		fnLabel.textAlignment = UITextAlignmentLeft;
//		fnLabel.textColor = [UIColor whiteColor];
//		[myView addSubview:fnLabel];
//		[fnLabel release];
//		
//		fnTF = [[UITextField alloc] initWithFrame:CGRectMake(170, 170, kTFWidth, 40)];
//		fnTF.placeholder = @"tap to enter";
//		fnTF.borderStyle = UITextBorderStyleRoundedRect;
//		fnTF.delegate = self;
//		fnTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//		fnTF.textAlignment = UITextAlignmentLeft;
//		fnTF.backgroundColor = [UIColor clearColor];
//		fnTF.delegate = self;
//		[myView addSubview:fnTF];																								
//		[fnTF release];
//		
//		UILabel *lnLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 220, 150, 40)];
//		lnLabel.text = @"Last Name";
//		lnLabel.backgroundColor = [UIColor clearColor];
//		lnLabel.font = [UIFont systemFontOfSize:16];
//		lnLabel.textAlignment = UITextAlignmentLeft;
//		lnLabel.textColor = [UIColor whiteColor];
//		[myView addSubview:lnLabel];
//		[lnLabel release];
//		
//		lnTF = [[UITextField alloc] initWithFrame:CGRectMake(170, 220, kTFWidth, 40)];
//		lnTF.placeholder = @"tap to enter";
//		lnTF.borderStyle = UITextBorderStyleRoundedRect;
//		lnTF.delegate = self;
//		lnTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//		lnTF.textAlignment = UITextAlignmentLeft;
//		lnTF.backgroundColor = [UIColor clearColor];
//		lnTF.delegate = self;
//		[myView addSubview:lnTF];
//		[lnTF release];
//		
//		UILabel *postalLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 270, 150, 40)];
//		postalLabel.text = @"Postal Code";
//		postalLabel.backgroundColor = [UIColor clearColor];
//		postalLabel.font = [UIFont systemFontOfSize:16];
//		postalLabel.textAlignment = UITextAlignmentLeft;
//		postalLabel.textColor = [UIColor whiteColor];
//		[myView addSubview:postalLabel];
//		[postalLabel release];
//		
//		postalTF = [[UITextField alloc] initWithFrame:CGRectMake(170, 270, kTFWidth, 40)];
//		postalTF.placeholder = @"";
//		postalTF.borderStyle = UITextBorderStyleRoundedRect;
//		postalTF.delegate = self;
//		postalTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//		postalTF.textAlignment = UITextAlignmentLeft;
//		postalTF.backgroundColor = [UIColor clearColor];
//		postalTF.delegate = self;
//		[myView addSubview:postalTF];
//		[postalTF release];
//		
//		UILabel *rememberMeLabel = [[UILabel alloc] initWithFrame:CGRectMake(330, 330, 200, 40)];
//		rememberMeLabel.text = @"Remember Me";
//		rememberMeLabel.backgroundColor = [UIColor clearColor];
//		rememberMeLabel.font = [UIFont systemFontOfSize:14];
//		rememberMeLabel.textAlignment = UITextAlignmentLeft;
//		rememberMeLabel.textColor = [UIColor whiteColor];
//		[myView addSubview:rememberMeLabel];
//		[rememberMeLabel release];
//		
//		rememberMeButton = [[UIButton alloc] initWithFrame:CGRectMake(300, 335, 30, 30)];
//		[rememberMeButton addTarget:self action:@selector(rememberMeButtonAction:) 
//				   forControlEvents:UIControlEventTouchUpInside];
//		rememberMeButton.clipsToBounds = YES;
//	//	[rememberMeButton setImage:[UIImage imageNamed:@"with-out-tick-img.png"] forState:UIControlStateNormal];
//		[rememberMeButton setImage:[UIImage imageNamed:@"tick-img.png"] forState:UIControlStateNormal];
//		[rememberMeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//		[myView addSubview:rememberMeButton];
//		[rememberMeButton release];
//		
//		
//		
//		
//		UILabel *promoLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 330, 300, 40)];
//		promoLabel.text = @"Send me Wizard promotions";
//		promoLabel.backgroundColor = [UIColor clearColor];
//		promoLabel.font = [UIFont systemFontOfSize:14];
//		promoLabel.textAlignment = UITextAlignmentLeft;
//		promoLabel.textColor = [UIColor whiteColor];
//		[myView addSubview:promoLabel];
//		[promoLabel release];
//		
//		promoBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 335, 30, 30)];
//		[promoBtn addTarget:self action:@selector(promoAction:) 
//		   forControlEvents:UIControlEventTouchUpInside];
//		promoBtn.clipsToBounds = YES;
//		[promoBtn setImage:[UIImage imageNamed:@"with-out-tick-img.png"] forState:UIControlStateNormal];
//		[promoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//		[myView addSubview:promoBtn];
//		[promoBtn release];
//		
//		
//		UIButton *regProcBtn = [[UIButton alloc] initWithFrame:CGRectMake(300, 387, 120, 27)];
//		[regProcBtn addTarget:self action:@selector(registerProcAction:)  forControlEvents:UIControlEventTouchUpInside];
//		[regProcBtn setBackgroundImage:[UIImage imageNamed:@"button-bg.png"] forState:UIControlStateNormal];
//		[regProcBtn setTitle:@"REGISTER" forState:UIControlStateNormal];
//		[regProcBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//		[myView addSubview:regProcBtn];
//		[regProcBtn release];
//		
//		
//		UIImageView *termsOfUseBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 820, 431, 49)];// 20, 125, 200, 200)];
//		termsOfUseBg.image = [UIImage imageNamed:@"privacy-butt-bg.png"];
//		[myView addSubview:termsOfUseBg];
//		[termsOfUseBg release];
//		
//		UIButton *pPolicyBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 825, 200, 39)];
//		[pPolicyBtn addTarget:self action:@selector(policyAction:) 
//			 forControlEvents:UIControlEventTouchUpInside];
//		//[pPolicyBtn setBackgroundColor:[UIColor grayColor]];
//		[pPolicyBtn setTitle:@"Privacy Policy" forState:UIControlStateNormal];
//		
//		[pPolicyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//		[myView addSubview:pPolicyBtn];
//		[pPolicyBtn release];
//		
//		UIButton *tofuseBtn = [[UIButton alloc] initWithFrame:CGRectMake(230, 825, 200, 39)];
//		[tofuseBtn addTarget:self action:@selector(termsofuseAction:) 
//			forControlEvents:UIControlEventTouchUpInside];
//		//[tofuseBtn setBackgroundColor:[UIColor grayColor]];
//		[tofuseBtn setTitle:@"Terms Of Use" forState:UIControlStateNormal];
//		[tofuseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//		[myView addSubview:tofuseBtn];
//		[tofuseBtn release];		
//		
//	}
}

-(void)loadPrefView
{
	//self.view.backgroundColor = [UIColor grayColor];
	for(UIView *subview in myView.subviews)
	{
		[subview removeFromSuperview];
	}
	
	
	
	
	UILabel *lbl_LinksEnable = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 250, 30)];
	lbl_LinksEnable.text = @"Enable Highlight Links :";
	[lbl_LinksEnable setTextColor:[UIColor colorWithRed:240 green:240 blue:240 alpha:1.0]];
	[lbl_LinksEnable setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
	lbl_LinksEnable.backgroundColor = [UIColor clearColor];
	[myView addSubview:lbl_LinksEnable];
	[lbl_LinksEnable release];
	
	UISwitch *swt_Links = [[UISwitch alloc] initWithFrame:CGRectMake(250, 100, 100, 50)];
	swt_Links.on = appDelegate.IsEnabledLinks;
	swt_Links.tag = 90;
	[myView addSubview:swt_Links];
	[swt_Links addTarget:self action:@selector(SwitchOn:) forControlEvents:UIControlEventValueChanged];
	[swt_Links release];
	
	UISwitch *swt_PushNot = [[UISwitch alloc] initWithFrame:CGRectMake(250, 180, 100, 50)];
	swt_PushNot.on = appDelegate.ISPushNotification;
	swt_PushNot.tag = 91;
	[swt_PushNot addTarget:self action:@selector(SwitchOn:) forControlEvents:UIControlEventValueChanged];
	[myView addSubview:swt_PushNot];
	[swt_PushNot release];
	
	
	
	
	
	UILabel *lbl_PushNotif = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, 250, 30)];
	lbl_PushNotif.text = @"Enable Push Notification :";
	[lbl_PushNotif setTextColor:[UIColor colorWithRed:240 green:240 blue:240 alpha:1.0]];
	[lbl_PushNotif setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
	lbl_PushNotif.backgroundColor = [UIColor clearColor];
	[myView addSubview:lbl_PushNotif];
	[lbl_PushNotif release];
	
	
	
	
	
	UIImageView *fullbg = [[UIImageView alloc] initWithFrame:CGRectMake(768-420, 0, 420, 968)];// 20, 125, 200, 200)];
	//fullbg.image = [UIImage imageNamed:@"rite-side-img-about-bg.png"];
	[fullbg setBackgroundColor:[UIColor blackColor]];
	[myView addSubview:fullbg];
	[fullbg release];
	
	
	UIImageView *aboutAppImage = [[UIImageView alloc] initWithFrame:CGRectMake(768-410, 10, 418, 395)];
	aboutAppImage.image = [UIImage imageNamed:@"app-logo-tobe-displayed.png"];
	[myView addSubview:aboutAppImage];
	
	//[myView setAlpha:.1];
	[aboutAppImage release];
	
	
	UILabel *abt1Label = [[UILabel alloc] initWithFrame:CGRectMake(768-410, 420, kAbtLAbelWidth, kAbtLAbelHeight)];
	abt1Label.text =[NSString stringWithFormat:@"Wizard World, the Pop Culture Capital of the World, discovers the trailblazers, the innovators and those who are creating the most compelling content found on iPads, iPhones, Kindles, Droids, Facebook,websites, online, shelves and more.\nAs pioneers in the industry, Wizard World brings to you a first look at fresh ideas from the greatest minds in front of the world of superheroes, fantasy, sci-fi, horror, action-adventure, suspense, thrillers and much, much more.  We are covering tomorrow… Read about it TODAY! Every week – Wizard World Digital"];
	abt1Label.numberOfLines = 0;
	abt1Label.backgroundColor = [UIColor clearColor];
	abt1Label.font = [UIFont systemFontOfSize:14];
	abt1Label.textAlignment = UITextAlignmentLeft;
	abt1Label.textColor = [UIColor whiteColor];
	[myView addSubview:abt1Label];
	[abt1Label release];
	
	UILabel *applogo = [[UILabel alloc] initWithFrame:CGRectMake(768-410, 187, 408, 20)];
	applogo.text =@"Application Logo to be displayed";
	applogo.numberOfLines = 0;
	applogo.backgroundColor = [UIColor clearColor];
	applogo.font = [UIFont systemFontOfSize:16];
	applogo.textAlignment = UITextAlignmentCenter;
	applogo.textColor = [UIColor blackColor];
	//[myView addSubview:applogo];
	[applogo release];
	
	UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(768-410,800, 408, 20)];
	versionLabel.text =[NSString stringWithFormat:@"Version 2.1"];
	versionLabel.numberOfLines = 0;
	versionLabel.backgroundColor = [UIColor clearColor];
	versionLabel.font = [UIFont systemFontOfSize:18];
	versionLabel.textAlignment = UITextAlignmentRight;
	versionLabel.textColor = [UIColor whiteColor];
	[myView addSubview:versionLabel];
	[versionLabel release];
	
	
	
	
	
	
	
	
	return;
	
	
	/*
	UIImageView *fullbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 968)];// 20, 125, 200, 200)];
	fullbg.image = [UIImage imageNamed:@"rite-side-img-about-bg.png"];
	//[fullbg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rite-side-img-about-bg.png"]]];
	[myView addSubview:fullbg];
	[fullbg release];
	
	UIImageView *smallBg = [[UIImageView alloc] initWithFrame:CGRectMake(10,10, 423, 156)];// 20, 125, 200, 200)];
	smallBg.image = [UIImage imageNamed:@"round-border.png"];
	//[fullbg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rite-side-img-about-bg.png"]]];
	[myView addSubview:smallBg];
	[smallBg release];
	
	
	UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 150, 40)];
	emailLabel.text = @"Email Address";
	emailLabel.backgroundColor = [UIColor clearColor];
	emailLabel.font = [UIFont systemFontOfSize:16];
	emailLabel.textAlignment = UITextAlignmentLeft;
	emailLabel.textColor = [UIColor whiteColor];
	[myView addSubview:emailLabel];
	[emailLabel release];
	
	UITextField *emailTF = [[UITextField alloc] initWithFrame:CGRectMake(170, 20, kTFWidth, 40)];
	emailTF.placeholder = @"tap to enter";
	emailTF.borderStyle = UITextBorderStyleRoundedRect;
	emailTF.delegate = self;
	emailTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	emailTF.textAlignment = UITextAlignmentLeft;
	emailTF.backgroundColor = [UIColor clearColor];
	[myView addSubview:emailTF];
	[emailTF release];
	
	UILabel *pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 70, 150, 40)];
	pwdLabel.text = @"Password";
	pwdLabel.backgroundColor = [UIColor clearColor];
	pwdLabel.font = [UIFont systemFontOfSize:16];
	pwdLabel.textAlignment = UITextAlignmentLeft;
	pwdLabel.textColor = [UIColor whiteColor];
	[myView addSubview:pwdLabel];
	[pwdLabel release];
	
	UITextField *pwdTF = [[UITextField alloc] initWithFrame:CGRectMake(170, 70, kTFWidth, 40)];
	pwdTF.placeholder = @"tap to enter";
	pwdTF.borderStyle = UITextBorderStyleRoundedRect;
	pwdTF.delegate = self;
	pwdTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	pwdTF.textAlignment = UITextAlignmentLeft;
	pwdTF.backgroundColor = [UIColor clearColor];
	[myView addSubview:pwdTF];
	[pwdTF release];
	
	UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(170, 125, 100, 27)];
	[submitBtn addTarget:self action:@selector(sumbitAction:) 
		forControlEvents:UIControlEventTouchUpInside];
	[submitBtn setBackgroundImage:[UIImage imageNamed:@"button-bg.png"] forState:UIControlStateNormal];
	[submitBtn setTitle:@"SUBMIT" forState:UIControlStateNormal];
	[submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[myView addSubview:submitBtn];
	[submitBtn release];
	
//	UIButton *forgotpwdBtn = [[UIButton alloc] initWithFrame:CGRectMake(290, 125, 130, 27)];
//	
//	[forgotpwdBtn addTarget:self action:@selector(fpwdAction:) 
//		   forControlEvents:UIControlEventTouchUpInside];
//	//[forgotpwdBtn setBackgroundImage:[UIImage imageNamed:@"MenuBar.png"] forState:UIControlStateNormal];
//	[forgotpwdBtn setTitle:@"Forgot Password" forState:UIControlStateNormal];
//	[forgotpwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//	forgotpwdBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
//	[myView addSubview:forgotpwdBtn];
//	[forgotpwdBtn release];
//	
//	UILabel *underlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(305, 150, 100, 1)];
//	underlineLabel.backgroundColor = [UIColor whiteColor];
//	[myView addSubview:underlineLabel];
//	[underlineLabel release];
	
	UIImageView *signInbg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 200, 429, 88)];// 20, 125, 200, 200)];
	signInbg.image = [UIImage imageNamed:@"to-register-content-bg.png"];
	//[fullbg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rite-side-img-about-bg.png"]]];
	[myView addSubview:signInbg];
	[signInbg release];
	
	UILabel *hvntLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 210, 409, 60)];
	hvntLabel.text = @"Haven’t registered yet? You need to register and sign in to purchase books.";
	hvntLabel.numberOfLines = 0;
	hvntLabel.backgroundColor = [UIColor clearColor];
	hvntLabel.font = [UIFont systemFontOfSize:18];
	hvntLabel.textAlignment = UITextAlignmentLeft;
	hvntLabel.textColor = [UIColor blackColor];
	[myView addSubview:hvntLabel];
	[hvntLabel release];
	
	UIButton *regBtn = [[UIButton alloc] initWithFrame:CGRectMake(275, 277, 139, 27)];
	[regBtn addTarget:self action:@selector(registerAction:) 
	 forControlEvents:UIControlEventTouchUpInside];
	[regBtn setBackgroundImage:[UIImage imageNamed:@"button-bg.png"] forState:UIControlStateNormal];
	[regBtn setTitle:@"REGISTER" forState:UIControlStateNormal];
	[regBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[myView addSubview:regBtn];
	[regBtn release];
	
	UIImageView *termsOfUseBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 820, 431, 49)];// 20, 125, 200, 200)];
	termsOfUseBg.image = [UIImage imageNamed:@"privacy-butt-bg.png"];
	[myView addSubview:termsOfUseBg];
	[termsOfUseBg release];
	
	UIButton *pPolicyBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 825, 200, 39)];
	[pPolicyBtn addTarget:self action:@selector(policyAction:) 
		 forControlEvents:UIControlEventTouchUpInside];
	//[pPolicyBtn setBackgroundColor:[UIColor grayColor]];
	[pPolicyBtn setTitle:@"Privacy Policy" forState:UIControlStateNormal];
	
	[pPolicyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[myView addSubview:pPolicyBtn];
	[pPolicyBtn release];
	
	UIButton *tofuseBtn = [[UIButton alloc] initWithFrame:CGRectMake(230, 825, 200, 39)];
	[tofuseBtn addTarget:self action:@selector(termsofuseAction:) 
		forControlEvents:UIControlEventTouchUpInside];
	//[tofuseBtn setBackgroundColor:[UIColor grayColor]];
	[tofuseBtn setTitle:@"Terms Of Use" forState:UIControlStateNormal];
	[tofuseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[myView addSubview:tofuseBtn];
	[tofuseBtn release];		
	
	*/
	
	//*****************/
}

-(void)SwitchOn:(id)sender
{
	UISwitch *Swt_HighightL = (UISwitch *)[myView viewWithTag:91];
	if(Swt_HighightL!=nil)
	{
		if(Swt_HighightL.tag == 90)
		{
		
			if(Swt_HighightL.on)
			{
				appDelegate.IsEnabledLinks = YES;
				NSUserDefaults *Store_LinksValue = [NSUserDefaults standardUserDefaults];
				[Store_LinksValue setBool:appDelegate.IsEnabledLinks forKey:@"IsEnabledLinks"];
				[Store_LinksValue synchronize];
				
			}
			else 
			{
				appDelegate.IsEnabledLinks = NO;
				NSUserDefaults *Store_LinksValue = [NSUserDefaults standardUserDefaults];
				[Store_LinksValue setBool:appDelegate.IsEnabledLinks forKey:@"IsEnabledLinks"];
				[Store_LinksValue synchronize];
			}
		}
		else if(Swt_HighightL.tag == 91)
		{
			if(Swt_HighightL.on)
			{
				
				appDelegate.ISPushNotification = YES;
				NSUserDefaults *Store_PushValue = [NSUserDefaults standardUserDefaults];
				[Store_PushValue setBool:appDelegate.IsEnabledLinks forKey:@"ISPushNotification"];
				[Store_PushValue synchronize];
				
				//write a code need to hit the server side url to enabled the push notification
				[appDelegate sendingDetailsToServer];   //with corresponding status.......
			}
			else 
			{
				appDelegate.ISPushNotification = NO;
				NSUserDefaults *Store_PushValue = [NSUserDefaults standardUserDefaults];
				[Store_PushValue setBool:appDelegate.IsEnabledLinks forKey:@"ISPushNotification"];
				[Store_PushValue synchronize];
				//write a code need to hit the server side url to disable the push notification
				[appDelegate sendingDetailsToServer];   //With corresponding status.......
			}
		}
	}
}

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
	printf("switch recieved");
}

-(void)loadAboutAppView
{
	//self.view.backgroundColor = [UIColor greenColor];
	for(UIView *subview in myView.subviews)
	{
		[subview removeFromSuperview];
	}
	
	
	UIImageView *fullbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 968)];// 20, 125, 200, 200)];
	//fullbg.image = [UIImage imageNamed:@"rite-side-img-about-bg.png"];
	[fullbg setBackgroundColor:[UIColor blackColor]];
	//[fullbg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rite-side-img-about-bg.png"]]];
	[myView addSubview:fullbg];
	[fullbg release];
	
	
	UIImageView *aboutAppImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 418, 395)];
	aboutAppImage.image = [UIImage imageNamed:@"app-logo-tobe-displayed.png"];
	[myView addSubview:aboutAppImage];
	
	//[myView setAlpha:.1];
	[aboutAppImage release];

	
	UILabel *abt1Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 420, kAbtLAbelWidth, kAbtLAbelHeight)];
	abt1Label.text =[NSString stringWithFormat:@"Wizard World, the Pop Culture Capital of the World, discovers the trailblazers, the innovators and those who are creating the most compelling content found on iPads, iPhones, Kindles, Droids, Facebook,websites, online, shelves and more.\nAs pioneers in the industry, Wizard World brings to you a first look at fresh ideas from the greatest minds in front of the world of superheroes, fantasy, sci-fi, horror, action-adventure, suspense, thrillers and much, much more.  We are covering tomorrow… Read about it TODAY! Every week – Wizard World Digital"];
	abt1Label.numberOfLines = 0;
	abt1Label.backgroundColor = [UIColor clearColor];
	abt1Label.font = [UIFont systemFontOfSize:14];
	abt1Label.textAlignment = UITextAlignmentLeft;
	abt1Label.textColor = [UIColor whiteColor];
	[myView addSubview:abt1Label];
	[abt1Label release];
	
	UILabel *applogo = [[UILabel alloc] initWithFrame:CGRectMake(15, 187, 408, 20)];
	applogo.text =@"Application Logo to be displayed";
	applogo.numberOfLines = 0;
	applogo.backgroundColor = [UIColor clearColor];
	applogo.font = [UIFont systemFontOfSize:16];
	applogo.textAlignment = UITextAlignmentCenter;
	applogo.textColor = [UIColor blackColor];
	//[myView addSubview:applogo];
	[applogo release];
	
	UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,800, 408, 20)];
	versionLabel.text =[NSString stringWithFormat:@"Version 2.1"];
	versionLabel.numberOfLines = 0;
	versionLabel.backgroundColor = [UIColor clearColor];
	versionLabel.font = [UIFont systemFontOfSize:18];
	versionLabel.textAlignment = UITextAlignmentRight;
	versionLabel.textColor = [UIColor whiteColor];
	[myView addSubview:versionLabel];
	[versionLabel release];
	
	
	
}

#pragma mark -
#pragma mark TextField related

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark Button Actions


-(void)logoutAction:(id)sender
{
	appDelegate.loginAuthKey = nil;
	navigationBar.topItem.title = @"Sign In";
	titleLabel.text = @"Sign In";
	navigationBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top_white_bar.png"]];
	[self loadSignInView];
	[appDelegate.rootViewController.tableView reloadData];
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	// set "" to authToken
	[prefs setObject:@"" forKey:@"AuthenticationKey"];
	[prefs synchronize];
	
}
-(void)sumbitAction:(id)sender
{
	if (firstResponder!=nil) {
		[self textFieldShouldReturn:firstResponder];
		firstResponder = nil;
	}
	NSString * fileUrl = [NSString stringWithFormat:@"%@/api/read?",serverIP];
	fileUrl = [fileUrl stringByAppendingFormat:@"action=login&emailAddress=%@&password=%@",emailTF.text,pwdTF.text ];
	
	
	NSURL *url = [[NSURL alloc] initWithString:fileUrl];
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	
	//Initialize the delegate.
	UserXMLParser *userDetailParser = [[UserXMLParser alloc]initXMLParser];
	
	//Set delegate
	[xmlParser setDelegate:userDetailParser];
	
	//Start parsing the XML file.
	BOOL success = [xmlParser parse];
	[xmlParser release];
	xmlParser=nil;
		//Set delegate
	//Start parsing the XML file.
	
	if(success){
		if(appDelegate.isValidLoginOrReg){
			NSString *str = [NSString stringWithFormat:@"%@",appDelegate.userDetails] ;
			
			appDelegate.loginAuthKey =[NSString stringWithFormat:@"%@",str] ;
			appDelegate.isValidLoginOrReg = NO;
			NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
			
			if (rememberMecount ==1) {
				//Save authtoken
				[prefs setObject:appDelegate.loginAuthKey forKey:@"AuthenticationKey"];
				[prefs synchronize];
			}
			else
			{
				// set "" to authToken
				[prefs setObject:@"" forKey:@"AuthenticationKey"];
				[prefs synchronize];
			}
			[appDelegate LoadAllBooksData:FALSE];
			UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Login Success" message:@"Now you can read your books" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
			[errorAlert show];
			[errorAlert release];
			for(UIView *subview in myView.subviews)
			{
				
				[subview removeFromSuperview];
			}
			[appDelegate.rootViewController.tableView reloadData];
			
		}else {
			NSString *str =[NSString stringWithFormat:@"%@", appDelegate.errorDetails] ;
			
			UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"login Error" message:str  delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
			[errorAlert show];
			[errorAlert release];
		}

	}
	else{
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Internet Unavailable" message:@"You Must be connected to Internet to view this link"  delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
	}
	[userDetailParser release];
	[xmlParser release];
	navigationBar.topItem.title = @"";
	titleLabel.text = @"";
	[appDelegate.rootViewController.tableView reloadData];
	for(UIView *subview in myView.subviews)
	{
		[subview removeFromSuperview];
	}
	
}

-(void)fpwdAction:(id)sender
{
	if (firstResponder!=nil) {
		[self textFieldShouldReturn:firstResponder];
		firstResponder = nil;
	}
	
	printf("\nfpwdAction...");
	NSString * fileUrl = [NSString stringWithFormat:@"%@/api/read?",serverIP];
	fileUrl = [fileUrl stringByAppendingFormat:@"action=forget&emailAddress=%@" ,emailTF.text];
	
	
	NSURL *url = [[NSURL alloc] initWithString:fileUrl];
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	
	//Initialize the delegate.
	UserXMLParser *userDetailParser = [[UserXMLParser alloc]initXMLParser];
	
	//Set delegate
	[xmlParser setDelegate:userDetailParser];
	
	//Start parsing the XML file.
	BOOL success = [xmlParser parse];
	[xmlParser release];
	xmlParser=nil;
	//Set delegate
	//Start parsing the XML file.
	
	
	if(success){
		if(appDelegate.isValidLoginOrReg){
			NSString *str =[NSString stringWithFormat:@"%@",appDelegate.recoveredPassWord ];
			
			appDelegate.recoveredPassWord = [NSString stringWithFormat:@"%@",str];
			UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Your new password" message:str delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
			[errorAlert show];
			[errorAlert release];
			appDelegate.isValidLoginOrReg = NO;
		}else {
			NSString *str = [NSString stringWithFormat:@"%@",appDelegate.errorDetails ];
			
			UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"login Error" message:str delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
			[errorAlert show];
			[errorAlert release];
		}
		
	}
	else{
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"login Error" message:@"symbols like '.'', .. etc and blank spaces not allowed in form details'" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
	}
	[userDetailParser release];
	[xmlParser release];
	
	
}

-(void)registerAction:(id)sender
{
	
	printf("\nregisterAction...");
	isReg = TRUE;
	[self loadSignInView];
	isReg = FALSE;
	
	 
}

-(void)policyAction:(id)sender
{
	printf("\npolicyAction...");
	for(UIView *subview in myView.subviews)
	{
		[subview removeFromSuperview];
	}
	UIImageView *fullbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 968)];// 20, 125, 200, 200)];
	fullbg.backgroundColor = [UIColor blackColor];//[UIImage imageNamed:@"rite-side-img-about-bg.png"];
	//[fullbg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rite-side-img-about-bg.png"]]];
	[myView addSubview:fullbg];
	[fullbg release];
	
	UIImageView *smallBg = [[UIImageView alloc] initWithFrame:CGRectMake(10,10, 423, 900)];// 20, 125, 200, 200)];
	smallBg.image = [UIImage imageNamed:@"round-border.png"];
	//[fullbg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rite-side-img-about-bg.png"]]];
	[myView addSubview:smallBg];
	[smallBg release];
	
	UITextView *privacyPolicyTextView =[[UITextView alloc] initWithFrame:CGRectMake(15,20, 423, 850)];// 20, 125, 200, 200)]
	
	privacyPolicyTextView.font = [UIFont systemFontOfSize:14];
	privacyPolicyTextView.textAlignment = UITextAlignmentLeft;
	privacyPolicyTextView.backgroundColor = [UIColor clearColor];
	privacyPolicyTextView.textColor = [UIColor whiteColor];
	privacyPolicyTextView.editable=FALSE;
	privacyPolicyTextView.text = @"Privacy Policy\n\nZondervan (including Zonderkidz and Vida) is part of the News America Group, which has adopted a set of Privacy Principles applicable to all its U.S.-based companies. Zondervan has implemented those Principles in this Privacy Policy, which describes how we collect, use, and share personally identifiable information (\"PII\") we obtain from and about individuals located in the U.S. both online and off-line.\n\n Children's Privacy Policy\n\nSome of our online activities are directed to children under 13. When those activities involve the collection of PII, we provide additional privacy protections. To read about our protections that relate to the online collection of PII from children under 13 click here.\n\n	From time to time Zondervan may revise this Privacy Policy to reflect industry initiatives or changes in the law, our PII collection and use practices, the features of our websites, or technology. Therefore, you should review it periodically so that you’re up to date on our most current policies and practices.\n\n	COLLECTION: COLLECTION OF PERSONALLY IDENTIFIABLE INFORMATION (\"PII\") BY ZONDERVAN \n\n	General. Zondervan collects personally identifiable information (\"PII\"—that is, information such as your full name, email address, mailing address, or telephone number) only in order to create or enhance our relationship with you. When we collect PII from you it’s because you’re voluntarily submitting the information to us in order to participate in activities like subscription registrations, surveys, sweepstakes, contests, games, forums, in connection with content or suggestions you submit to us, chats or bulletin boards, or because you want us to furnish you with products, services, or information. On those occasions when we obtain PII from a third party, we use only reputable sources of such information.\n\n	Cookies. Electronic cookies are small bits of information that the operators of Internet sites place on the hard drive of your computer. Cookies remember information about your activities on the site and enable the operator of the site to make your visits to our websites more personal and enjoyable.\n\n	At this time, HarperCollins only employs cookies to identify each user as a unique visitor, so that we can determine if you’re a new or returning user. These cookies are not associated with any PII. In the future, we may use cookies in a variety of ways, including storing your password for easy log on and relating your use of our site to your PII, so that, if you ask us to send you information about our upcoming products or promotions, cookie and/or other information about your online activities may allow us to limit the material we send you to the types of items you had viewed on our site in the past. However, if we wish to coordinate your personal and website activity information in this manner, we’ll obtain your express prior consent (i.e., \"opt in\"). Also, our cookies will not contain PII.\n\n You can always program your computer to warn you each time a cookie is being sent or to refuse cookies completely.\n\n	NOTICE: ZONDERVAN WILL PROVIDE YOU WITH NOTICE ABOUT ITS PII COLLECTION PRACTICES\n\n	When Zondervan collects PII from you, we’ll make sure you’re informed about who’s collecting the information, how and why the information is being collected, and the types of uses we’ll make of the information.\n\n This Policy describes the types of other companies that may want to send you information about their products and services and therefore may want to share your personal information (See \"Use\" below). However, we’ll notify you of your options regarding our use of your PII, including whether we can share it with outside companies, before we use it for a purpose other than the one for which it was originally collected or disclose it to third parties, typically at the time of collection (See \"Choice\" below).\n\n	Sometimes we collect PII from consumers in manual format, such as a post card or subscription form. Providing detailed notice in those situations often proves impractical, so consumers will instead be provided with a short notice that describes how to obtain the full text of this Policy and other relevant information from us.\n\n	Zondervan’s websites may be linked to Internet sites operated by other companies. Some of these third party sites may be co-branded with a Zondervan logo, even though they’re not operated or maintained by Zondervan, such as websites owned and operated by our authors. Zondervan's websites may also carry advertisements from other companies. Although we choose our business partners and advertisers carefully, Zondervan is not responsible for the privacy practices of websites operated by third parties that are linked to or from our sites, or for the privacy practices of third parties that advertise on our websites. Once you've left a Zondervan website via such a link or by clicking on an advertisement, you should check the applicable privacy policy of the third party to determine how they’ll handle any PII they collect from you.\n\nZondervan's websites may also be linked to sites operated by companies affiliated with Zondervan. Visitors to those affiliated sites should still refer to their separate privacy policies and practices, which may differ in some respects from this Policy.\n\nCHOICE: ZONDERVAN WILL PROVIDE YOU WITH CHOICES ABOUT THE USE OF YOUR PII\n\n	Zondervan will provide you with the opportunity to choose whether your PII may be used for purposes different from the purpose for which it was submitted. You’ll also be able to choose whether your information is shared with companies that are not affiliated with Zondervan (i.e., not part of the News America Group).\n\n	USE: ZONDERVAN'S USE OF PII\n\nZondervan will use your PII in a manner that’s consistent with this Policy and only for the purpose for which it’s submitted, unless other uses are disclosed and you allow us to use your information in these other ways.\n\n	Zondervan may share your PII with companies that are affiliated with us, that is, are part of the News America Group of companies. We may also share your PII with companies that are not affiliated with Zondervan but would like to send you information about their products and services. For example, Zondervan may offer a sweepstakes or contest in conjunction with a co-sponsor, and the co-sponsor may send you information concerning its products or services. However, you’ll always have the opportunity to instruct us not to share your information with third parties.\n\n	Zondervan's employees, agents, and contractors must have a legitimate business reason to obtain access to your PII. Outside contractors or agents who help us manage our information activities (i.e., sweepstakes administration, order fulfillment, statistical analyses) may only use PII to provide Zondervan with a specific service and not for any other purpose.\n\nIf Zondervan obtains PII from a third party, such as a business partner, our use of this information is governed by this Policy.\n\n	There may be instances when Zondervan may disclose PII without providing you with a choice in order to protect the legal rights of Zondervan, other companies within the News America Group or their employees, agents, and contractors; to protect the safety and security of visitors to our websites; to protect against fraud or for risk management purposes; or to comply with the law or legal process. In addition, if Zondervan sells all or part of its business or makes a sale or transfer of assets or is otherwise involved in a merger or business transfer, Zondervan may transfer your PII to a third party as part of that transaction.\n\n\n\nSECURITY: ZONDERVAN PROTECTS THE SECURITY OF PIIZondervan uses reasonable administrative, technical, personnel, and physical measures to safeguard PII in its possession against loss, theft, and unauthorized use, disclosure, or modification. In addition, we use reasonable methods to make sure that PII is accurate, up-to-date, and appropriately complete.\n\nACCESS: HOW TO ACCESS OR CORRECT YOUR PII, OR STOP ALL FUTURE COMMUNICATIONS FROM ZONDERVAN\n\nYou may review PII about you from our records at anytime. If you’d like to know the types of information that Zondervan collects from visitors to its websites, please send your request using our CONTACT US page [LINK TO THE CONTACT US PAGE]. Or write to Zondervan, Attn: Internet Team, 5300 Patterson Avenue SE, Grand Rapids, MI 49530. If you’d like to know whether Zondervan has collected PII about you, please send us the activities that you participated in on our websites which requested PII. After reviewing the relevant databases, we’ll confirm whether we’ve collected such information about you.\n\nPrior to changing any information about you or stopping to communicate with you, Zondervan requires that you provide proof of your name and address, such as a valid driver's license. Once we determine that the information provided is satisfactory, we’ll immediately modify the information about you and/or refrain from collecting PII about you and/or communicating with you in the future, if you so request. However, there may be residual information that will remain within our databases that may or may not contain PII. This residual information will not be given to any third party or used for any commercial purpose.\n\n	REMEDIES AND COMPLIANCE: HOW TO CONTACT ZONDERVAN ABOUT PRIVACY CONCERNS\n\nIf you have any complaints about Zondervan's compliance with this Policy, have been unable to obtain or modify your PII, or to prevent Zondervan from collecting your PII, or to stop Zondervan from communicating with you, please contact Kyran Cassidy, Esq., Assistant General Counsel at: HarperCollins Publishers Inc., 10 East 53rd Street, New York, NY 10022; kyran.cassidy@harpercollins.com; or tel. no.: (212) 207-7969.\n\n	Last Updated April 26, 2005\n\n© 2005 Zondervan. All Rights Reserved.\n\n  KIDS AND INTERNET SAFETYWe at Zondervan (including Zonderkidz and Vida) understand that the Internet presents an opportunity for us to reach the public in new and exciting ways with information about our programming, fun games, exciting sweepstakes and contests, email, chat rooms, bulletin boards, and other forms of interactivity. Zondervan also recognizes the privacy concerns of parents, and the importance of protecting the privacy of the information we collect from children on our websites. Parents of children can be confident that any personal information that may be provided to our websites will be collected and maintained in accordance with the Children's Online Privacy Protection Act (\"COPPA\"). Zondervan encourages parents to supervise their children's activities online and to participate with their children's online activities whenever possible. However, we understand that parents may not always be able to supervise their children's activities on the Internet. That's why Zondervan has developed websites that parents can feel are safe for their children and kids will find cool, informative, educational, and fun! Because there's always room for improvement, Zondervan welcomes any suggestions on how to make our site a better, safer place to hang out.\n\nCOLLECTION AND USE OF PERSONALLY IDENTIFIABLE INFORMATION FROM CHILDREN UNDER 13\n\nWhen a visitor to our site is under the age of 13, Zondervan does not require the disclosure of more personally identifiable information (\"PII\") than is reasonably necessary for him or her to participate in an activity as a condition of such participation. Zondervan may use different types of PII submitted to our websites by children under 13 in a variety of ways, which are described below. In each instance, we comply with the parental consent requirements of COPPA.1. Use of a Child's Information by Zondervan\n\n— We may collect a child's email address in connection with a contest, sweepstakes, or game for the sole purpose of communicating with the child on a one-time-only basis (i.e., to contact a contest winner). This information will not be used to re-contact the child, and will be deleted from our records when the contest or game is over. Parental consent will be obtained before we send the winner a prize.\n\n— We may collect a child's email address in order to respond more than once to a child's specific request. For example, the child may want to subscribe to an online newsletter or receive other online communications from Zondervan. In these instances Zondervan will also obtain a parent's email address along with the child's. Before any further contact with the child, Zondervan will send an email to the parent (a) notifying him or her we have collected the child's email address in order to respond more than once to the child's request for a subscription, information, etc; (b) informing the parent that he or she can refuse us permission to contact the child, and how to do so; and (c) informing the parent that if he or she does not respond to the email within 72 hours, Zondervan may use the child's information for the purpose for which it was submitted.\n\n— We may collect a child's PII (including name, email address, mailing address, and phone number) for such activities as chats, forums, surveys, games, guestbooks, bulletin boards, requests for suggestions, subscription registrations, content submissions, requests for products or services, or requests for additional information. In these instances we will initially collect only the child's name and online contact information and the email address of the child's parent. Before using this information for any purpose, we will send the parent an email that (a) informs the parent that we wish to collect and use the child's personal information and need the parent's consent to do so, and (b) provides the parent with a link to access to this Privacy Policy, which describes our information collection and use policies as required by COPPA. If the proposed use of the child's personal information does not involve disclosure to a third party, then Zondervan will ask the parent to provide consent by return email. Upon receipt of the email consent, we will send the parent a confirming email. If the proposed use of the child's PII involves disclosure to third parties, the email we send to the parent will ask the parent either to (i) return by postal mail or fax a consent form that will be attached to the email, or (ii) call a toll-free number where consent can be given over the phone. If parental consent is not obtained by one of these methods within one week, Zondervan will delete all of the child's and parent's PII from its records. In addition, parents can revoke a prior consent at any time.\n\n— We may collect a child's name and email address to the extent reasonably necessary to protect the security of this Site, to protect against liability or as required or permitted by law. Information collected for these reasons will not be used for any other purpose.\n\n2. Sharing Children's Personal Information With Third Parties. Zondervan may share a child's PII with other News America Group affiliates who may send you information about their products or services. These third parties have agreed to maintain the confidentiality, security, and integrity of the personal information they obtain from Zondervan. As noted above, parents may exercise their option not to consent to the disclosure of their child's PII to third parties. Parents may consent to Zondervan's collection and use of a child's PII without consenting to the disclosure of the information to third parties.\n\n\n\n	LINKS/CO-BRANDED SITES\n\nAs noted in the Privacy Policy, our websites may link directly to sites operated by third party advertisers, business partners, and affiliated companies. Those sites, which are not controlled by Zondervan, may collect PII from your child. Parents should therefore check the relevant site's privacy policy to understand how it collects and uses children's personal information. Zondervan will not share in any personal information obtained by a site from a child under the age of 13 unless that site follows the requirements of COPPA.\n\n	REVIEWING AND MAKING CHANGES TO PERSONALLY IDENTIFIABLE INFORMATION COLLECTED FROM CHILDREN UNDER 13\n\n	Parents of children under age 13 may review or delete personal information about their children from our records at any time. If you’d like to know the types of information we collect about children, please contact us using our Contact Us page or write to us at Zondervan, Attn: Internet Marketing, 5300 Patterson Avenue SE, Grand Rapids, MI 49530. If you’d like to know whether we’ve collected personal information about your child, please provide us with the activities that he or she participated in on one of our websites which requested personal information. After reviewing the relevant databases, we’ll confirm whether we’ve collected such information about your child.\n\n	Prior to changing or deleting such information, we require that you provide us with proof of your name and address, such as a valid driver's license, and proof that your child resides with you or is otherwise in your custody. Once we’ve determined such information is satisfactory, we’ll immediately delete or modify your child's information in our database and/or refrain from collecting any other personally identifiable information from your child in the future, if you so request. However, there may be residual information that will remain within our databases that may or may not contain personally identifiable information. This residual information will not be given to any other third party or used for any commercial purpose.\n\n	Last Updated April 26, 2005\n\n©2005 Zondervan. All Rights Reserved.\n\n";
	[myView addSubview:privacyPolicyTextView];
	[privacyPolicyTextView release];
	
}

-(void)termsofuseAction:(id)sender
{
	printf("\ntermsofuseAction...");
	for(UIView *subview in myView.subviews)
	{
		[subview removeFromSuperview];
	}
	UIImageView *fullbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 968)];// 20, 125, 200, 200)];
	fullbg.backgroundColor = [UIColor blackColor];//.image = [UIImage imageNamed:@"rite-side-img-about-bg.png"];
	//[fullbg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rite-side-img-about-bg.png"]]];
	[myView addSubview:fullbg];
	[fullbg release];
	
	UIImageView *smallBg = [[UIImageView alloc] initWithFrame:CGRectMake(10,10, 423, 900)];// 20, 125, 200, 200)];
	smallBg.image = [UIImage imageNamed:@"round-border.png"];
	//[fullbg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rite-side-img-about-bg.png"]]];
	[myView addSubview:smallBg];
	[smallBg release];
	
    //UIWebView *webview =[[UIWebView alloc] initWithFrame:CGRectMake(15,15, 423, 850)];// 20, 125, 200, 200)];
	UITextView *termsTextView =[[UITextView alloc] initWithFrame:CGRectMake(15,20, 423, 850)];// 20, 125, 200, 200)]
	
	termsTextView.font = [UIFont systemFontOfSize:14];
	termsTextView.textAlignment = UITextAlignmentLeft;
	termsTextView.backgroundColor = [UIColor clearColor];
	termsTextView.textColor = [UIColor whiteColor];
	termsTextView.editable=FALSE;
	termsTextView.text = @"Terms of Use \n\n\nOwnership\n\n\nWelcome to the Web site at www.zondervan.com whichis owned by The Zondervan Corporation L.L.C. (\"ZONDERVAN\"). This Site is operated by ZONDERVAN, and materials on the Site are owned, for the most part, by ZONDERVAN. The Site may also include materials owned by third parties and posted on the Site by virtue of a license, grant or some other form of agreement between the third party and ZONDERVAN.\n\n\nZONDERVAN has created this Site for your personal enjoyment, entertainment and education. However, you are only authorized to access this Site or to use the materials contained in the Site (regardless of whether your access or use is intended) if you agree to abide by all applicable laws, and to these Terms of Use which constitute an Agreement between you and ZONDERVAN. Please read these Terms of Use carefully and save them. If you do not agree with them, you should leave this Site immediately. Any questions or comments regarding, or problems with, this Site should be sent to the Site Administrator on the Contact Us page.\n\n\nZONDERVAN reserves the right to modify or amend this Agreement without notice at any time. It is therefore important that you read this page regularly to ensure you are updated as to any changes.\n\n\nIf you become aware of misuse of this Site by any person, please contact the Site Administrator with your concerns.\n\n\nAccess and Use\n\nAll materials contained in this Site are protected by international trademark and copyright laws and must only be used for personal, non-commercial purposes. This means that you may only view or download material from this Site for your own use and you must keep all copyright and other proprietary notices attached to the downloaded material.\n\nThe reproduction, duplication, distribution (including by way of e-mail, facsimile or other electronic means), publication, modification, copying or transmission of material from this Site is STRICTLY PROHIBITED unless you have obtained the prior written consent of ZONDERVAN or unless it is expressly permitted by this Site. The material covered by this prohibition includes, without limitation, any text, graphics, logos, photographs, audio or video material or stills from audiovisual material available on this Site. The use of materials from this Site on any other Web site or networked computer environment is similarly prohibited. Requests for permission to reproduce or distribute in digital form the online materials found on this Site can be made by contacting ZONDERVAN in writing ZPermissions@zondervan.com. \n\nYou are also strictly prohibited from creating works or materials that derive from or are based on the materials contained in this Site including, without limitation, fonts, icons, link buttons, wallpaper, desktop themes, on-line postcards and greeting cards and unlicensed merchandise. This prohibition applies regardless of whether the derivative materials are sold, bartered or given away.\n\nBulletin Boards, Chat Rooms & Blogs \n\nYou are welcome to post, transmit or submit messages and other materials (which include uploading files, inputting data or any other materials or engaging in any form of communication in connection with this Site) (collectively \"Messages\") to bulletin boards, chat rooms, blogs or other public areas within, or in connection with, this Site (collectively \"Forums\"). However, ZONDERVAN accepts no responsibility whatsoever in connection with or arising from such Messages.\n\nZONDERVAN does not endorse and has no control over the content of Messages submitted by others to Forums. Messages submitted to Forums are not necessarily reviewed by ZONDERVAN prior to posting and do not necessarily reflect the opinions or policies of ZONDERVAN. ZONDERVAN makes no warranties, express or implied, as to the content of the Messages in the Forums or the accuracy and reliability of any Messages and other materials in the Forums. Nonetheless, ZONDERVAN reserves the right to prevent you from submitting Materials to Forums and to edit, restrict or remove such Messages for any reason at any time.\n\nZONDERVAN assumes no responsibility for actively monitoring Forums for inappropriate Messages. If at any time ZONDERVAN chooses, in its sole discretion, to monitor the Forums, ZONDERVAN nonetheless assumes no responsibility for the content of the Messages, no obligation to modify or remove any inappropriate Messages, and no responsibility for the conduct of the user submitting any Message. In submitting Messages to Forums, you agree to strictly limit yourself to discussions about the subject matter for which the Forums are intended. You agree that ZONDERVAN accepts no liability whatsoever if it determines to prevent your Messages from being submitted or if it edits, restricts or removes your Messages. You also agree to permit any other user of this Site to access, view, store or reproduce the material for that other user's personal use and not to restrict or inhibit the use of the Site by any other person.\n\nYou agree that you will not submit Messages to Forums that:\n\nare unlawful, threatening, obscene, vulgar, pornographic, profane or indecent including any communication that constitutes (or encourages conduct that would constitute) a criminal offense, gives rise to civil liability or otherwise violates any local, state, national or international law;\nviolate the copyright, trademark or other intellectual property rights of any other person. By submitting Messages to Forums, you represent to ZONDERVAN that you are the rightful owner of such material or that you have first obtained permission to submit the material from the rightful owner;\nimproperly assume or claim the identity, characteristics or qualifications of another person;\nare for purposes of spamming;\ncontain any virus or other harmful component;\nare libelous, or an invasion of privacy or publicity rights or any other third party rights; or\nare for commercial purposes or contain advertising or are intended to solicit a person to buyorsell services or to make donations.\nYou agree that any Message whatsoever submitted by you becomes the property of ZONDERVAN and may be used, copied, sublicensed, adapted, edited, transmitted, distributed, publicly performed, published, displayed or deleted as ZONDERVAN sees fit.\n\nYou agree to release ZONDERVAN, its parents and affiliates together with their respective employees, agents, officers, directors and shareholders, from any and all liability and obligations whatsoever in connection with or arising from your use of Forums. If at any time you are not happy with the Forums or object to any material within Forums, your sole remedy is to cease using them.\n\nEmployment Opportunities\n\nZONDERVAN may, from time to time, post ZONDERVAN employment opportunities on the Site and/or invite users to submit resumes to it. If you choose to submit your name, contact information, resume and/or other personal information to ZONDERVAN in response to employment listings, you are authorizing ZONDERVAN to utilize this information for all lawful and legitimate hiring and employment purposes. ZONDERVAN also reserves the right, at its sole discretion, to forward the information you submit to its parents, subsidiaries and affiliates for legitimate business purposes. Nothing in these Terms of Use or contained in the Site shall constitute a promise by ZONDERVAN to interview, hire or employ any individual who submits information to it, nor shall anything in these Terms of Use or contained in the Site constitute a promise that ZONDERVAN will review any or all of the information submitted to it by users.\n\nLinked Sites\n\nIf ZONDERVAN has provided links or pointers to other web sites, no inference or assumption should be made and no representation should be implied that ZONDERVAN is connected with, operates or controls these web sites.\n\nZONDERVAN is not responsible for the content or practices of third party Web sites that may be linked to this Site. This Site may also be linked to other Web sites operated by companies affiliated or connected with ZONDERVAN. When visiting other web sites, however, you should refer to each such Web site’s individual \"Terms of Use\" and not rely on this Agreement.\n\nDisclaimer of Liability and Warranties\n\nWhile ZONDERVAN does its best to ensure the optimal performance of the Site, you agree that you use this Site and rely on material contained in this Site at your own risk.\n\nThe Site, and all materials in this Site, are provided \"as is\" and, to the fullest extent permitted by law, are provided without warranties of any kind either express or implied. This means, without limitation, that ZONDERVAN DOES NOT WARRANT that the Site is fit for any particular purpose; that the functions contained in the materials in the Site will be uninterrupted; that defects will be corrected; that the Site is free of viruses and other harmful components or that the Site is accurate, error free or reliable.\n\nYou acknowledge that ZONDERVAN, its parents and affiliates together with their respective employees, agents, directors, officers and shareholders, IS NOT LIABLE for any delays, inaccuracies, failures, errors, omissions, interruptions, deletions, defects, viruses, communication line failures or for the theft, destruction, damage or unauthorized access to your computer system or network.\n\nYou acknowledge that ZONDERVAN is not liable for any defamatory, offensive or illegal conduct or material found in connection with this Site, including such conduct or material transmitted by any means by any other person.\n\nYou acknowledge that ZONDERVAN is not liable for any damages, including, without limitation, direct, incidental, special, consequential or punitive damages, in connection with or arising from your use or from your inability to use the Site.\n\nIndemnity\n\nYou agree to defend, indemnify and hold harmless ZONDERVAN, its parents and affiliates together with their respective employees, agents, directors, officers and shareholders, from and against all the liabilities, claims, damages and expenses (including reasonable attorney’s fees and costs) arising out of your use of this Site, your breach or alleged breach of this Agreement or your breach or alleged breach of the copyright, trademark, proprietary or other rights of third parties.\n\nOther\n\nThis Agreement operates to the fullest extent permissible by law. If any provision of this Agreement is unlawful, void or unenforceable, that provision is deemed severable from this Agreement and does not affect the validity and enforceability of any remaining provisions.\n\nThis Agreement is governed by, and construed in accordance with, the laws of the State of New York without giving effect to any principles of conflicts of law. You agree to submit to the exclusive jurisdiction of the courts of the State of New York or, if appropriate, the United States District Court for the Southern District of New York for resolution of any dispute, action or proceeding arising in connection with this Agreement or your use or non-use of the Site, and you further irrevocably waive any right you may have to trial by jury in any such dispute, action or proceeding.\n\nNOTICE AND PROCEDURE FOR MAKING CLAIMS OF COPYRIGHT INFRINGEMENT \n\nZONDERVAN will process notices of alleged infringement which it receives and will take appropriate actions as required by the Digital Millennium Copyright Act (the \"DMCA\") and other applicable intellectual property laws. Pursuant to the DMCA, notifications of claimed copyright infringement should be sent to ZONDERVAN's Designated Agent.\n\nService Provider(s): The Zondervan Corporation\n\nName/Contact Information of Designated Agent: \n\nKyran Cassidy\nAsst. General Counsel\n\nHarperCollins Publishers\n10 East 53rd Street\nNew York, New York 10022\nTelephone: (212) 207-7969\nFax: (212) 207-7552\nE-mail: kyran.cassidy@harpercollins.com\nTo be effective, the notification must be in writing and contain the following information (DMCA, 17 U.S.C. §512(c)(3)): \n\n1.	Physical or electronic signature of a person authorized to act on behalf of the owner of an exclusive right that is allegedly infringed;\n\n2.	Identification of the copyrighted work claimed to have been infringed, or, if multiple copyrighted works at a single online side are covered by a single notification, a representative list of such works at that site;\n\n3.	Identification of the material that is claimed to be infringing or to be the subject of infringing activity and that is to be removed or access to which is to be disabled, and information reasonably sufficient to permit the service provider to locate the material;\n\n4.	Information reasonably sufficient to permit the service provider to contact the complaining party, such as an address, telephone number, and, if available, an electronic mail address at which the complaining party may be contacted;\n\n5.	A statement that the complaining party has a good faith belief that use of the material in the manner complained of is not authorized by the copyright owner, its agent, or the law;\n\n6.	A statement that the information in the notification is accurate, and under penalty of perjury, that the complaining party is authorized to act on behalf of the owner of an exclusive right that is allegedly infringed.\n\n© 2007 The Zondervan Corporation. All Rights Reserved.";
	[myView addSubview:termsTextView];
	[termsTextView release];
	
    
	
	

	
	
}

-(void)promoAction:(id)sender
{
	printf("\npromoAction...");
	if(i == 0)
	{
		i = 1;
		[promoBtn setImage:[UIImage imageNamed:@"tick-img.png"] forState:UIControlStateNormal]; 
	}
	else if(i == 1)
	{
		i = 0;
		[promoBtn setImage:[UIImage imageNamed:@"with-out-tick-img.png"] forState:UIControlStateNormal];
	}	
}

-(void)rememberMeButtonAction:(id)sender
{
	printf("\n rememberMeButtonAction...");
	if(rememberMecount == 0)
	{
		rememberMecount = 1;
		[rememberMeButton setImage:[UIImage imageNamed:@"tick-img.png"] forState:UIControlStateNormal]; 
	}
	else if(rememberMecount == 1)
	{
		rememberMecount = 0;
		[rememberMeButton setImage:[UIImage imageNamed:@"with-out-tick-img.png"] forState:UIControlStateNormal];
	}
	
	
}

-(void)registerProcAction:(id)sender
{
	printf("\nregisterProcAction...");
	if (firstResponder!=nil) {
		[self textFieldShouldReturn:firstResponder];
		firstResponder = nil;
	}
	if (![cnfrmLabelTF.text isEqualToString:passwordTF.text] ) {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Password Mismatch" message:@"Please enter the correct password in both fields" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
		return;
	}
	NSString * fileUrl = [NSString stringWithFormat:@"%@/api/read?",serverIP];
	fileUrl = [fileUrl stringByAppendingFormat:@"action=signup&password=%@&emailAddress=%@&firstName=%@&lastName=%@&postalCode=%@&promotionFlag=%d&",cnfrmLabelTF.text,
			   mailTF.text,fnTF.text,lnTF.text,postalTF.text,i];
	
	
	
	NSURL *url = [[NSURL alloc] initWithString:fileUrl];
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	
	//Initialize the delegate.
	UserXMLParser *userDetailParser = [[UserXMLParser alloc]initXMLParser];
	
	//Set delegate
	[xmlParser setDelegate:userDetailParser];
	
	//Start parsing the XML file.
	BOOL success = [xmlParser parse];
	[xmlParser release];
	xmlParser=nil;
	//Set delegate
	//Start parsing the XML file.
	
	if(success){
		if(appDelegate.isValidLoginOrReg){
			NSString *str = [NSString stringWithFormat:@"%@",appDelegate.userDetails] ;
			
			appDelegate.loginAuthKey = [NSString stringWithFormat:@"%@",str];
			appDelegate.isValidLoginOrReg = NO;
			NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
			if (rememberMecount ==1) {
				//Save authtoken
				[prefs setObject:appDelegate.loginAuthKey forKey:@"AuthenticationKey"];
				[prefs synchronize];
			}
			else
			{
				// set "" to authToken
				[prefs setObject:@"" forKey:@"AuthenticationKey"];
				[prefs synchronize];
			}
			
			[appDelegate LoadAllBooksData:FALSE];
			
			UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Registration Success" message:@"Now you can read your books" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
			[errorAlert show];
			[errorAlert release];
			for(UIView *subview in myView.subviews)
			{
				[subview removeFromSuperview];
			}
			[appDelegate.rootViewController.tableView reloadData];
			
		}else {
			NSString *str = [NSString stringWithFormat:@"%@", appDelegate.errorDetails] ;
			
			UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Registration Error" message:str delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
			[errorAlert show];
			[errorAlert release];
		}
		
	}
	else{
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Internet Unavailable" message:@"You Must be connected to Internet to view this link"  delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
	}
	[userDetailParser release];
	[xmlParser release];
	
}


#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc 
		willHideViewController:(UIViewController *)aViewController 
		withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc
{    
    barButtonItem.title = @"Root List";
//Commented by karpaga    [navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:YES];
//Commented by karpaga    self.popoverController = pc;
	NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;	
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc 
		willShowViewController:(UIViewController *)aViewController 
		invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem 
{    
//Commented by karpaga    [navigationBar.topItem setLeftBarButtonItem:nil animated:YES];
 //Commented by karpaga   self.popoverController = nil;
	
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;	
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark -
#pragma touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{ 
                  	
	for (UITextField *textField in [myView subviews] ) {
		if ([textField isFirstResponder]) {
			[textField resignFirstResponder];
			return;
		}
	}
	

} 


#pragma mark -
#pragma mark View lifecycle


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
}

 


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.view setBackgroundColor:[UIColor blackColor]];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"rite-side-img-about-bg.png"]]];
	for(UIView *subview in myView.subviews)
	{
		[subview removeFromSuperview];
	}
	
	
}

- (BOOL)textFielsShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	firstResponder = nil;
	firstResponder = textField;
	[textField becomeFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
		
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	self.detailItem=@"Row 2";
	self.detailItem=@"Row 1";
}

/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

- (void)viewDidUnload 
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Memory management


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


- (void)dealloc
{
    [popoverController release];
    [navigationBar release];
    [promoBtn release];
	[rememberMeButton release];
    [detailItem release];
	[myView release];
    [super dealloc];
}

@end
