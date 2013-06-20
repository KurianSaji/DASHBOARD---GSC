//
//  test2.h
//  Comic Store
//
//  Created by neo on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassicalScrollViewController.h"

@interface test2 : UITableViewController 
{
	ClassicalScrollViewController *cls;
	NSArray *Arr_NofPages;
}
@property(nonatomic, retain)NSArray *Arr_NofPages;

@property(nonatomic, retain)ClassicalScrollViewController *cls;
@end
