//
//  SettingsViewController.h
//  WizardWorld
//
//  Created by neo on 2/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "epubstore_svcAppDelegate.h"

//@class epubstore_svcAppDelegate;
@interface SettingsViewController : UIViewController <UITextFieldDelegate>
{
	UIView *myView;
	epubstore_svcAppDelegate *appDelegate;
	
	UIImageView *imgV_titleBar;
	UIImageView *imgV_titleBg;
	UILabel *lbl_Title;
	UITextField *txt_slideShowSec;
}
-(void)loadPrefView;
@end
