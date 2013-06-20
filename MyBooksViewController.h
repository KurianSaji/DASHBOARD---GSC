//
//  MyBooksViewController.h
//  epubStore
//
//  Created by partha neo on 8/30/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "epubstore_svcAppDelegate.h"
#import "BookDetails.h"
#import "MyCustomButton.h"


@interface MyBooksViewController : UIViewController <UIScrollViewDelegate>
{
	UIView *myView, *headerView;
	UIScrollView *scrollView;
	epubstore_svcAppDelegate *appDelegate;
	NSMutableArray *bookCoverView;
	UISegmentedControl *segmentCntrl;
}
@property(nonatomic,retain)UIScrollView *scrollView;
-(void)loadHeaderView;
-(void)loadScrollView;
-(void)getPurchasedBookList;
@end
