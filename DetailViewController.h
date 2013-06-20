//
//  DetailViewController.h
//  epubstore_svc
//
//  Created by partha neo on 9/1/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
@class epubstore_svcAppDelegate;
@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, 
													UISplitViewControllerDelegate,
													UITextFieldDelegate> 
{    
	epubstore_svcAppDelegate *appDelegate;
    UIPopoverController *popoverController;
    UINavigationBar *navigationBar;
    
    id detailItem;
	UIToolbar *toolbar;

	//UIView *myView;
	
	BOOL isReg;
	
	UIButton *promoBtn;
	UIButton *rememberMeButton;
	
	IBOutlet UIImageView *titleBar;
	IBOutlet UIImageView *titleBg;
	IBOutlet UILabel *titleLabel;
}

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;

@property (nonatomic, retain) id detailItem;

-(void)loadSignInView;
-(void)loadPrefView;
-(void)loadAboutAppView;
-(void)loadSignOut;

@end
