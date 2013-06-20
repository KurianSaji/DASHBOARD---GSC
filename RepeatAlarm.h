//
//  RepeatAlarm.h
//  Alarm
//
//  Created by usha on 11/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RepeatAlarm : UIViewController<UITableViewDelegate,UITableViewDataSource> {

	NSMutableArray *repeatArray;
}


-(IBAction)backAction;
@end
