//
//  Shop.h
//  DashBoard
//
//  Created by Zaah Technologies on 15/04/11.
//  Copyright 2011 Zaah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/SCNetworkReachability.h>

@class epubstore_svcAppDelegate;
@interface Shop : UIViewController {

	//UIWebView *shopview1;
	UIActivityIndicatorView *loadingIndicator;
	epubstore_svcAppDelegate *appDelegate;
}

//@property (nonatomic,retain)IBOutlet UIWebView *shopview;
@end
