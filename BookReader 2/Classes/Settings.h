//
//  Settings.h
//  BookReader
//
//  Created by pradeep on 8/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class epubstore_svcAppDelegate;

@interface Settings : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate> {
	IBOutlet UIPickerView *fontPickerview;
	IBOutlet UILabel *myTextLabel;
	IBOutlet UIButton *incButton;
	IBOutlet UIButton *decButton;
	NSMutableArray *arrayColors;
	epubstore_svcAppDelegate *appDelegate_;
}
-(IBAction)increaseFontSize;
-(IBAction)decreaseFontSize;
-(IBAction)goBack;
@end
