//
//  BookIndexViewController.h
//  BookReader
//
//  Created by Zaah Technologies India PVT on 9/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"
#import "NCXNavigationDefinition.h"


@interface BookIndexViewController : UIViewController {
	Book* book_;
	UITableView *tableView;
	NCXNavigationDefinition* navigationDefinition_;
	UILabel *bookHeadingLabel;
	UIButton *mybookButton;
}
@property (nonatomic, retain) IBOutlet UIButton *mybookButton;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UILabel *bookHeadingLabel;
- (id) initWithBook: (Book*) book;
-(IBAction)gotoMyBooks;
@end
