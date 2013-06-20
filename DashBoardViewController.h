//
//  DashBoardViewController.h
//  DashBoard
//
//  Created by neo on 11/04/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/SCNetworkReachability.h>

@class Dashboardview,epubstore_svcAppDelegate;
@interface DashBoardViewController : UIViewController <UITableViewDelegate,UITabBarDelegate>{

	UIImageView *rssfeed;
	UIImageView *tp;
	UITableView *aTableView;
	IBOutlet UITabBar *tabbr;

	NSMutableArray * stories;
	NSMutableDictionary * item;
	NSString * currentElement;
	NSMutableString * currentTitle, * currentDate, * currentSummary, * currentLink;
	Dashboardview *boardViewController;
	UIWebView *web;
	epubstore_svcAppDelegate *appDelegate;
	UIButton *webhome;
}
@property(nonatomic,retain)UITableView *aTableView;
@property(nonatomic,retain)IBOutlet UITabBar *tabbr;
@property (nonatomic,retain) UIWebView *web;;
-(void)showview:(NSString *)str;
-(IBAction)comicbtn;
-(IBAction)clockbtn;
-(IBAction)videobtn;
-(IBAction)backgroundbtn;
-(IBAction)shopbtn;
-(IBAction)jukeboxbtn;
-(void) fbLogin:(id) sender;
-(void) closeFBWindow:(id) sender;
@end

