//
//  AlarmDetails.h
//  Alarm
//
//  Created by usha on 11/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class AlarmsViewController;
@class epubstore_svcAppDelegate;
@interface AlarmDetails : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	
	IBOutlet UIDatePicker *timePicker;
	epubstore_svcAppDelegate *appdelegate;
	NSString *myDateString;
	UISwitch *almSwitch;
	UISwitch *repeatSwitch;
	UISlider *slider;
	NSMutableArray *alarmItems;
	int EditIndex;
	int localArrayIndex;
	AlarmsViewController *alarm;
}


-(IBAction)pickerTimeAction;
-(IBAction)saveAlarmActiom;
-(IBAction)BackAction;
-(void)callTimer;

@property (nonatomic,retain)IBOutlet UIDatePicker *timePicker;
@property (nonatomic,retain) NSString *myDateString;
@property (nonatomic, retain) UISlider *slider;
@property (nonatomic,assign)int EditIndex;
@property (nonatomic,assign)int localArrayIndex;
@end
