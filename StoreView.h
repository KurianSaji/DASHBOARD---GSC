//
//  StoreView.h
//  Alarm
//
//  Created by Zaah Technologies India PVT on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@class AlarmsViewController;
@class epubstore_svcAppDelegate;
@interface StoreView : UIViewController<UIScrollViewDelegate,UIWebViewDelegate,SKProductsRequestDelegate> {
	epubstore_svcAppDelegate *appdelegate;
	AlarmsViewController *alrm;
	NSSet *clockproductIdentifiers;
	//iPad-iPhone Width and Height ratio
	float ratioWidth;
	float ratioHeight;
}
-(void)btnToAlarmAction;
-(void)buyNowAction;
- (void)purchaseProUpgrade;
- (BOOL)canMakePurchases;
-(void)buyNowAction1;
//- (void)scrollViewDidScroll:(UIScrollView *)scroll;

@end
