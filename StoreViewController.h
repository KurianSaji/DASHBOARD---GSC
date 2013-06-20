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
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/SCNetworkReachability.h>

#import <MobileCoreServices/MobileCoreServices.h>
#import "FBConnect.h"
#import"SA_OAuthTwitterController.h"
#import <MessageUI/MessageUI.h>
#import <objc/runtime.h>
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
@class Videos;

@interface StoreViewController : UIViewController <UIScrollViewDelegate,UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
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
	UIActivityIndicatorView *loadingIndicator;
	
	
	
	//Create a thread.....
	NSThread *_Thread;
	BOOL IsDownload;
	NSMutableData *receivedData;
	int BookIndex;
	float filesize;
	UIProgressView *ProgView_Download1;
	UILabel *progress_Label;
	
	int CurrentIndex;
	BOOL ISFirstTimeDownloading;
	
	
	NSMutableArray *arr_Banners;
	NSString *chkSumStr;
	NSMutableArray *arr_Advertise;
	NSMutableArray *arr_Toc;
	NSSet *productIdentifiers;
	
	double expectedContentLength;
	NSString *totalSize;
	NSString *downloadedSize;
	UIBackgroundTaskIdentifier bgTask;
	NSString *pdfPathForDelete;
	
	int selViewButtonIndex;
	
	NSFileHandle *file;
	
	float downloadedLength;
	NSString *downloadingFileName;
    UIScrollView *adevertiseScrollView;
    BOOL adScrollInProcess;
    
    UITableView *listOfPdfsDelete;
   // UIPopoverController *deleteBookControl;
    
    SA_OAuthTwitterEngine				*_engine;
	Facebook* _facebook;
	NSArray* _permissions;
    UITextView *twitterTextField ;
    UIView * twitterView;
    BOOL TwitterOpened;
    UIToolbar *topBar;
    BOOL summa;
    
    UISwitch *firstNotify;
    
}
@property (nonatomic,retain)NSURLConnection *downloadBookConnection;
@property (nonatomic,retain)NSMutableArray *allPdfs;
@property (nonatomic,retain)NSString *downloadingFileName;
@property (nonatomic,retain)NSString *pdfPathForDelete;
@property(nonatomic,retain)NSString *totalSize;
@property (nonatomic,retain)UIScrollView *scrollview;
@property (nonatomic,retain)UIView *myView;
@property (nonatomic,retain)UIView *selBookView;

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
-(void)loadImage:(UIImage*)img;
-(void)loadImage2:(UIImage*)img;
-(void)loadComicAuthorView;
//- (void)provideContent:(NSString *)productId;
-(void)loadScrollView:(id)sender;

@end
