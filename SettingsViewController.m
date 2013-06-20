    //
//  SettingsViewController.m
//  WizardWorld
//
//  Created by neo on 2/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"

#define kTFWidth 240
#define kAbtLAbelWidth 400
#define kAbtLAbelHeight 300
@implementation SettingsViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	
    [super viewDidLoad];
	//self.view.backgroundColor = [UIColor whiteColor];
	appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];	
	
	UIImage *img = nil;
	if(appDelegate.screenHeight1 == 1024)
	{
		imgV_titleBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 43)];
		img = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"top-white.png"]] ];
	}
	else
	{
		imgV_titleBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 43)];
		img = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"top-whiteiphone.png"]] ];
	}
	//imgV_titleBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 43)];
	imgV_titleBar.userInteractionEnabled  = YES;
	//img = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"top-white.png"]] ];
	imgV_titleBar.image = img;
	[img release];
	[self.view addSubview:imgV_titleBar];
	
	if(appDelegate.screenHeight1 ==1024)
	{
		imgV_titleBg = [[UIImageView alloc] initWithFrame:CGRectMake(259, 0, 250, 41)];
		img = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"head-bg.png"]] ];
	}
	else
	{
		imgV_titleBg = [[UIImageView alloc] initWithFrame:CGRectMake(85, 0, 140, 41)];
		img = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"head-bgiphone.png"]] ];
	}
	//imgV_titleBg = [[UIImageView alloc] initWithFrame:CGRectMake(259, 0, 250, 41)];
	imgV_titleBg.userInteractionEnabled  = YES;
	//img = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"head-bg.png"]] ];
	imgV_titleBg.image = img;
	[img release];
	[self.view addSubview:imgV_titleBg];
	
	
	
	if(appDelegate.screenHeight1 == 1024)
		lbl_Title = [[UILabel alloc] initWithFrame:CGRectMake(330, 0, 250, 41)];
	else
		lbl_Title = [[UILabel alloc] initWithFrame:CGRectMake(103, 0, 140, 41)];
	lbl_Title.backgroundColor = [UIColor clearColor];
	lbl_Title.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
	lbl_Title.text = @"Preferences";
	[self.view addSubview:lbl_Title];
	
	
	[imgV_titleBar release];
	[imgV_titleBg release];
	[lbl_Title release];
	
	[self loadPrefView];
}


-(void)loadPrefView
{
	
	if(myView == nil)
	{
		if(appDelegate.screenHeight1 == 1024)
			myView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 768, 950)];
		else
			myView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 480)];
		//myView.backgroundColor = [UIColor lightGrayColor];
		[myView setBackgroundColor:[UIColor blackColor]];//colorWithPatternImage:[UIImage imageNamed:@"rite-side-img-about-bg.png"]]];
		[self.view addSubview:myView];
	}
	
	
	//self.view.backgroundColor = [UIColor grayColor];
	for(UIView *subview in myView.subviews)
	{
		[subview removeFromSuperview];
	}
	
	UILabel *lbl_LinksEnable;
	if(appDelegate.screenHeight1 == 1024)
	{
		lbl_LinksEnable = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 250, 30)];
		[lbl_LinksEnable setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
	}
	else
	{
		lbl_LinksEnable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 140, 30)];
		[lbl_LinksEnable setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
	}	lbl_LinksEnable.text = @"Enable Highlight Links :";
	[lbl_LinksEnable setTextColor:[UIColor colorWithRed:240 green:240 blue:240 alpha:1.0]];
	//[lbl_LinksEnable setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
	lbl_LinksEnable.backgroundColor = [UIColor clearColor];
	[myView addSubview:lbl_LinksEnable];
	[lbl_LinksEnable release];
	

	
	UISwitch *swt_Links;// = [[UISwitch alloc] initWithFrame:CGRectMake(250, 100, 100, 50)];
	if(appDelegate.screenHeight1 == 1024)
		swt_Links = [[UISwitch alloc] initWithFrame:CGRectMake(250, 100, 100, 50)];
	else
		swt_Links = [[UISwitch alloc] initWithFrame:CGRectMake(160, 10, 30, 15)];


	swt_Links.on = 	appDelegate.IsEnabledLinks;
	swt_Links.tag = 90;
	[myView addSubview:swt_Links];
	[swt_Links addTarget:self action:@selector(SwitchOn:) forControlEvents:UIControlEventValueChanged];
	[swt_Links release];
	//Push Notification
	UISwitch *swt_PushNot ;//= [[UISwitch alloc] initWithFrame:CGRectMake(250, 180, 100, 50)];
	if(appDelegate.screenHeight1 == 1024)
		swt_PushNot = [[UISwitch alloc] initWithFrame:CGRectMake(250, 180, 100, 50)];
	else
		swt_PushNot = [[UISwitch alloc] initWithFrame:CGRectMake(160, 60, 30, 15)];
	
	swt_PushNot.on = appDelegate.ISPushNotification;
	swt_PushNot.tag = 91;
	[swt_PushNot addTarget:self action:@selector(SwitchOn:) forControlEvents:UIControlEventValueChanged];
	[myView addSubview:swt_PushNot];
	
	
	
	
	
	
	UILabel *lbl_PushNotif;// = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, 250, 30)];
	if(appDelegate.screenHeight1 == 1024)
	{
		lbl_PushNotif = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, 250, 30)];
		[lbl_PushNotif setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
	}
	else
	{
		lbl_PushNotif = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 140, 30)];
		[lbl_PushNotif setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
	}
	lbl_PushNotif.text = @"Enable Push Notification :";
	[lbl_PushNotif setTextColor:[UIColor colorWithRed:240 green:240 blue:240 alpha:1.0]];
	//[lbl_PushNotif setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
	lbl_PushNotif.backgroundColor = [UIColor clearColor];
	[myView addSubview:lbl_PushNotif];
	
	
	
	UIImageView *fullbg = [[UIImageView alloc] initWithFrame:CGRectMake(768-420, 0, 420, 968)];// 20, 125, 200, 200)];
	//fullbg.image = [UIImage imageNamed:@"rite-side-img-about-bg.png"];
	[fullbg setBackgroundColor:[UIColor blackColor]];
	[myView addSubview:fullbg];
	[fullbg release];
	
	
	//UIImageView *aboutAppImage = [[UIImageView alloc] initWithFrame:CGRectMake(768-410, 10, 418, 395)];
//	aboutAppImage.image = [UIImage imageNamed:@"app-logo-tobe-displayed.png"];
//	[myView addSubview:aboutAppImage];
	
	//[myView setAlpha:.1];
	//[aboutAppImage release];
	
	
	UILabel *abt1Label = [[UILabel alloc] initWithFrame:CGRectMake(768-410, 420, kAbtLAbelWidth, kAbtLAbelHeight)];
	//abt1Label.text =[NSString stringWithFormat:@"Dashboard, the Pop Culture Capital of the World, discovers the trailblazers, the innovators and those who are creating the most compelling content found on iPads, iPhones, Kindles, Droids, Facebook,websites, online, shelves and more.\nAs pioneers in the industry, Dashboard brings to you a first look at fresh ideas from the greatest minds in front of the world of superheroes, fantasy, sci-fi, horror, action-adventure, suspense, thrillers and much, much more.  We are covering tomorrow… Read about it TODAY! Every week – Dashboard Digital"];
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
	//versionLabel.text =[NSString stringWithFormat:@"Version 2.1"];
	versionLabel.numberOfLines = 0;
	versionLabel.backgroundColor = [UIColor clearColor];
	versionLabel.font = [UIFont systemFontOfSize:18];
	versionLabel.textAlignment = UITextAlignmentRight;
	versionLabel.textColor = [UIColor whiteColor];
	[myView addSubview:versionLabel];
	[versionLabel release];
	
	[myView release];
	 
	
	UILabel *lbl_slideShowSec;// = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, 250, 30)];
	if(appDelegate.screenHeight1 == 1024)
	{
		lbl_slideShowSec = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lbl_PushNotif.frame)+20, 250, 30)];
		[lbl_slideShowSec setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
	}
	else
	{
		lbl_slideShowSec = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lbl_PushNotif.frame)+20, 140, 30)];
		[lbl_slideShowSec setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
	}
	lbl_slideShowSec.text = @"Delay (Slide Show)   :";
	[lbl_slideShowSec setTextColor:[UIColor colorWithRed:240 green:240 blue:240 alpha:1.0]];
	//[lbl_PushNotif setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
	lbl_slideShowSec.backgroundColor = [UIColor clearColor];
	[myView addSubview:lbl_slideShowSec];
	
	// = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, 250, 30)];
	if(appDelegate.screenHeight1 == 1024)
	{
		txt_slideShowSec = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(swt_PushNot.frame), CGRectGetMaxY(lbl_PushNotif.frame)+20, swt_PushNot.frame.size.width, 30)];
		[txt_slideShowSec setFont:[UIFont fontWithName:@"Helvetica" size:22]];
	}
	else
	{
		txt_slideShowSec = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(swt_PushNot.frame), CGRectGetMaxY(lbl_PushNotif.frame)+20, swt_PushNot.frame.size.width, 30)];
		[txt_slideShowSec setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
	}
	txt_slideShowSec.borderStyle=UITextBorderStyleBezel;
	txt_slideShowSec.delegate=self;
	txt_slideShowSec.keyboardType=UIKeyboardTypeNumberPad;
	//txt_slideShowSec.ba
	txt_slideShowSec.text = [NSString stringWithFormat:@"%d",appDelegate.slideShowTime];
	[txt_slideShowSec setTextColor:[UIColor blueColor]];
	//[lbl_PushNotif setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
	txt_slideShowSec.backgroundColor = [UIColor whiteColor];
	[myView addSubview:txt_slideShowSec];
	
	UILabel *lbl_slideShowSec1;// = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, 250, 30)];
	if(appDelegate.screenHeight1 == 1024)
	{
		lbl_slideShowSec1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(txt_slideShowSec.frame)+5, CGRectGetMaxY(lbl_PushNotif.frame)+20, 250, 30)];
		[lbl_slideShowSec1 setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
	}
	else
	{
		lbl_slideShowSec1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(txt_slideShowSec.frame)+5, CGRectGetMaxY(lbl_PushNotif.frame)+20, 140, 30)];
		[lbl_slideShowSec1 setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
	}
	lbl_slideShowSec1.text = @"Sec";
	[lbl_slideShowSec1 setTextColor:[UIColor colorWithRed:240 green:240 blue:240 alpha:1.0]];
	//[lbl_PushNotif setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
	lbl_slideShowSec1.backgroundColor = [UIColor clearColor];
	[myView addSubview:lbl_slideShowSec1];
	[lbl_slideShowSec1 release];
	[lbl_slideShowSec release];
	[lbl_PushNotif release];
	[swt_PushNot release];
	
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	appDelegate.slideShowTime=[txt_slideShowSec.text intValue];
	NSUserDefaults *Store_LinksValue = [NSUserDefaults standardUserDefaults];
	[Store_LinksValue setInteger:[txt_slideShowSec.text intValue] forKey:@"delayTime"];
	[Store_LinksValue synchronize];
	[txt_slideShowSec resignFirstResponder];
}
-(void)textFieldShouldReturn:(UITextField *)textField1
{
	appDelegate.slideShowTime=[textField1.text intValue];
	NSUserDefaults *Store_LinksValue = [NSUserDefaults standardUserDefaults];
	[Store_LinksValue setInteger:[txt_slideShowSec.text intValue] forKey:@"delayTime"];
	[Store_LinksValue synchronize];
	[textField1 resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField1 shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if (range.location == 0 && string.length == 0) {
        return YES;
    }
	
    // Build up the resulting string…
    NSMutableString *fullString = [[NSMutableString alloc] init];
	
    [fullString appendString:[textField1.text substringWithRange:NSMakeRange(0, range.location)]];
    [fullString appendString:string];
	
    // Set up number formatter…
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *replaceNumber = [formatter numberFromString:fullString];
	
    [fullString release];
    [formatter release];
	
	if ((replaceNumber == nil || [replaceNumber intValue] < 3)) {
		appDelegate.slideShowTime=[textField1.text intValue];
		NSUserDefaults *Store_LinksValue = [NSUserDefaults standardUserDefaults];
		[Store_LinksValue setInteger:[txt_slideShowSec.text intValue] forKey:@"delayTime"];
		[Store_LinksValue synchronize];
	}
    return !(replaceNumber == nil || [replaceNumber intValue] < 3);
	
}

-(void)SwitchOn:(id)sender
{
	UISwitch *Swt_HighightL = (UISwitch *) sender;
	if(Swt_HighightL!=nil)
	{
		if(Swt_HighightL.tag == 90)
		{
			
			if(Swt_HighightL.on)
			{
				appDelegate.IsEnabledLinks = YES;
				NSUserDefaults *Store_LinksValue = [NSUserDefaults standardUserDefaults];
				[Store_LinksValue setBool:YES forKey:@"IsEnabledLinks"];
				[Store_LinksValue synchronize];
				
			}
			else 
			{
				appDelegate.IsEnabledLinks = NO;
				NSUserDefaults *Store_LinksValue = [NSUserDefaults standardUserDefaults];
				[Store_LinksValue setBool:NO forKey:@"IsEnabledLinks"];
				[Store_LinksValue synchronize];
			}
			

			
		}
		else if(Swt_HighightL.tag == 91)
		{
			if(Swt_HighightL.on)
			{
/*				NSLog(@"Push ON Begin"); 
				
				appDelegate.ISPushNotification = YES;
				NSUserDefaults *Store_PushValue = [NSUserDefaults standardUserDefaults];
				[Store_PushValue setBool:TRUE forKey:@"ISPushNotification"];
				[appDelegate synchronize];
				
				//write a code need to hit the server side url to enabled the push notification
				 [self sendingDetailsToServer];   //with corresponding status....... */
				NSLog(@"Push Off Begin");
				
				appDelegate.ISPushNotification = YES;
				NSUserDefaults *Store_PushValue = [NSUserDefaults standardUserDefaults];
				[Store_PushValue setBool:TRUE forKey:@"ISPushNotification"];
				[Store_PushValue synchronize];
				//write a code need to hit the server side url to disable the push notification
				[appDelegate sendingDetailsToServer];   //With corresponding status.......				
			}
			else 
			{
				NSLog(@"Push Off Begin");

				appDelegate.ISPushNotification = NO;
				NSUserDefaults *Store_PushValue = [NSUserDefaults standardUserDefaults];
				[Store_PushValue setBool:FALSE forKey:@"ISPushNotification"];
				[Store_PushValue synchronize];
				//write a code need to hit the server side url to disable the push notification
				 [appDelegate sendingDetailsToServer];   //With corresponding status.......
				
			}
		}
	}
}
	
	
-(void)viewWillDisappear:(BOOL)animated
{
	appDelegate.slideShowTime=[txt_slideShowSec.text intValue];
	NSUserDefaults *Store_LinksValue = [NSUserDefaults standardUserDefaults];
	[Store_LinksValue setInteger:[txt_slideShowSec.text intValue] forKey:@"delayTime"];
	[Store_LinksValue synchronize];
	[txt_slideShowSec resignFirstResponder];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return ((interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) || (interfaceOrientation == UIInterfaceOrientationPortrait));
	//return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) ;

}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
	
//	UIAlertView *alert = [[UIAlertView alloc] 
//						  initWithTitle:@"Warning" 
//						  message:@"You are running out of memory" 
//						  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//	[alert show];
//	[alert release];
	
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
