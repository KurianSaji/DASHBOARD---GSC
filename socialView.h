//
//  socialView.h
//  DashBoard
//
//  Created by neo on 30/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class epubstore_svcAppDelegate;

@interface socialView : UIViewController <UITableViewDelegate,UITableViewDataSource>
{

	IBOutlet UITableView *table;
	
	NSArray *arryData;
	epubstore_svcAppDelegate *appdelegate;
}
@property(nonatomic,retain)IBOutlet UITableView *table;

-(IBAction)back;

@end
