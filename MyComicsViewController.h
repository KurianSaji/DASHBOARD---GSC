//
//  MyComicsViewController.h
//  Comic Store
//
//  Created by Zaah Technologies India PVT on 10/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//
//  StoreViewController.h
//  epubStore
//
//  Created by partha neo on 8/30/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "epubstore_svcAppDelegate.h"
#import "BookDetails.h"
#import "MyCustomButton.h"
#import "OneBookDetails.h"
#import <StoreKit/StoreKit.h>
@interface MyComicsViewController : UIViewController <UIScrollViewDelegate>
{
	UIView *myView;
	UIToolbar *topToolBar;
	UIView *authorView, *bookstoreView;
	UISegmentedControl *segmentCntrl;
	UILabel *segLabel;
	UIScrollView *scrollview;
	epubstore_svcAppDelegate *appDelegate;	
	NSMutableArray *booksArray;
	UIView *bioView;
	//UIButton *backButton;	
	
	UIView *selBookView;
	NSTimer *myTimer;
	
	NSString *kInAppPurchaseProUpgradeProductId;
	
	SKProduct *proUpgradeProduct;
	SKProductsRequest *productsRequest;
	

	
	NSString *pdfPathTemp;
	NSString *pdfBookIDTemp;
	
	
}
@property (nonatomic,retain)UIScrollView *scrollview;

@property (nonatomic,retain)NSString *pdfPathTemp;
@property (nonatomic,retain)NSString *pdfBookIDTemp;


-(void)reloadToolBar;
-(void)loadScrollView;
-(void)loadAuthorView;
-(OneBookDetails *)loadBookDescription:(NSString *)descXmlUrl;
-(void)loadAuthorXml;
- (void) _showAlert:(NSString*)title comment:(NSString *)comment;
-(void)createDiscriptionView :(NSString *)descriptionXmlUrl;
-(void)closepopupAction:(id)sender;
-(void)loginInPurchase;
- (void)requestProUpgradeProductData;
- (BOOL)canMakePurchases;
- (void)purchaseProUpgrade;

- (void)provideContent:(NSString *)productId;
@end
