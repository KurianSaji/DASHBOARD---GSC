//
//  PlaySound.h
//  Alarm
//
//  Created by usha on 11/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class epubstore_svcAppDelegate,AlarmsViewController;
@interface PlaySound : UIViewController {
	
	
	epubstore_svcAppDelegate *appDelegate;
	AlarmsViewController *alarmview;
	IBOutlet UITableView *playListTableView;
	
	//iPad-iPhone Width and Height ratio
	float ratioWidth;
	float ratioHeight;
}

-(IBAction)saveAction;
-(IBAction)BackAction;
@end
