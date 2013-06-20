//
//  StoreViewController.m
//  epubStore
//
//  Created by partha neo on 8/30/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "StoreViewController.h"
#import <StoreKit/StoreKit.h>
#import "Book.h";
#import "BookIndexViewController.h"
#import "Shelf.h"
#import "BookDetails.h"
#import "OneBookDetails.h"
#import "RelatedBookDeatails.h"
#import "BookDetailParser.h";
#import "UserXMLParser.h"
#import "AuthorXmlParser.h"
#import "AboutAuthorMyComic.h"
#import "TocXmlParser.h"
#import "TocOfBook_Class.h"
#import "ClassicalScrollViewController.h"

#import "Baners_Class.h";
#import "BannersParser.h"
#import "Advertise_Class.h";
#import "AdvertiseParser.h"
#import "Videos.h"
#import "SA_OAuthTwitterEngine.h"
#define kOAuthConsumerKey				@"gKKNHPCJR4ogFjWT9vjgg"		//REPLACE ME  Twitter
#define kOAuthConsumerSecret			@"1FOKxqZI4FCT1zjKMA6vdE16jZD5STGVB5wGzxrpKc"
@implementation StoreViewController
@synthesize scrollview,allPdfs;
@synthesize myView,downloadingFileName;
@synthesize selBookView,totalSize,pdfPathForDelete,downloadBookConnection;

NSString *kInAppPurchaseProUpgradeProductId =@"ComicBook0001";
static NSString* kAppId = @"180294668651052";
SKProduct *proUpgradeProduct;
SKProductsRequest *productsRequest;

BOOL isAbtAuth = FALSE;

NSInteger idnumber=0;
NSInteger nRow = 2;
NSInteger nCol = 2;
NSInteger totCnt = 4;
AboutAuthorMyComic *aboutAuthorMyComic;
AuthorXmlParser *authorXmlObj;

NSData *readimg;
NSData *downloadimg;
NSString *readpath;
NSString *downloadpath;

int ipadScrollx = 768;
int iphoneScrollx = 300;
int selectedBookIndex=0;
int purchasecheck=0;
NSString * selectedbookISBNnumber;
BOOL show_All = FALSE;
BOOL show_Free = FALSE;
BOOL show_featured = FALSE;
BOOL show_new   = FALSE;
BOOL downloading_Progress = FALSE;

NSMutableArray *sortedArray;
UIView *downloadingOverlayView;

NSString *author_Name;
NSString *author_Photo_Url;
NSString *author_Description;

//For sign up
UITextField *textfieldName;
UITextField *textfieldPassword;

UIImageView *bigBannerImgViw;
UIImageView *smallBannerImgViw1;
UIImageView *smallBannerImgViw2;
UIImageView *smallBannerImgViw3;


//PDF Variables
PSPDFDocument *document;
PSPDFViewController *pdfController;
UINavigationController *navController;
//End of PDF Variables;

UIScrollView *bannerScrollView;

//UIView *authorViewNew;
BOOL _isDataSourceAvailable;

NSString *bookName;
int tag=0;
NSString *kInAppPurchaseProUpgradeProductId;

int indexx;
int nof =0;
int newindex;

BookDetails *book;
BookDetails *Purchasebook;
BOOL chosenBook;
UIButton *btn;

UIActionSheet *aSheet;


#pragma mark -
#pragma mark Initialization

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 if ((self = [super initWithStyle:style])) {
 }
 return self;
 }
 */

-(id) init
{
	NSLog(@"init storeView Controller");
	if(self = [super init])
	{
			}	
	return self;
}

#pragma mark -
#pragma mark View lifecycle



- (BOOL)isDataSourceAvailable
{
	static BOOL checkNetwork = YES;
	
	if (checkNetwork) 
	{ 
		checkNetwork = NO;
		
		Boolean success;    
		const char *host_name = "www.google.com";
		
		SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
		SCNetworkReachabilityFlags flags;
		success = SCNetworkReachabilityGetFlags(reachability, &flags);
		_isDataSourceAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
		CFRelease(reachability);
	}
	return _isDataSourceAvailable;
}


-(void)viewDidLoad 
{
	
	[super viewDidLoad];
	
//	[[NSNotificationCenter defaultCenter] addObserver:myObject selector:@selector(methodToCall) name:@"notificationName" object:nil];
		appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate.window setBackgroundColor:[UIColor blackColor]];
	
	
		[appDelegate.videoVC.view setHidden:TRUE];
		
		//appDelegate.shopview.hidden=YES;
		show_All = TRUE;
		IsDownload = NO;
		BookIndex = 0;
		filesize = 0;
		CurrentIndex = 1000;
		ISFirstTimeDownloading = YES;
		
		
//		UIImageView *imgvw;
		//self.view.backgroundColor = [UIColor blackColor];//background_top.png
//		//Memory leak	
	if(appDelegate.screenHeight1 == 1024)
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"magBg_ipad.png"]];
    else
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"magBg_iphone.png"]];
    
//		UIImage *imge = [UIImage imageNamed:@"background_top.png"];
//		//self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background_top.png"]];
//		if(imgvw == nil)
//		imgvw = [[UIImageView alloc]initWithImage:imge];
//		[imgvw setFrame:CGRectMake(0, 0, 768, 523)];
//		[self.view addSubview:imgvw];
//		[imgvw release];
		
////	if(appDelegate.screenHeight1 == 1024)
		myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768.0*appDelegate.screenWidth1/768, 1024.0*appDelegate.screenHeight1/1024)];
/*	else
		myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,480)];
*/	myView.backgroundColor = [UIColor clearColor];
		[self.view addSubview:myView];

		
		//UIImage *img = nil;
    
    self.allPdfs=[[NSMutableArray alloc]init];
    
    
   // NSLog(@"list of pdfs%@",allPdfs);
		//img = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"top_bar.png"]] ];
//		UIImageView * imgview_topBar = [[UIImageView alloc] initWithImage:img];
//		[img release];
		//imgview_topBar.frame = CGRectMake(0, 0, 768, 44);
//		[self.view addSubview:imgview_topBar];
//		[imgview_topBar release];
		
		
////	if(appDelegate.screenHeight1 == 1024)
		authorView = [[UIView alloc] initWithFrame:CGRectMake(30.0*appDelegate.screenWidth1/768, 20.0*appDelegate.screenHeight1/480, (768.0-60.0)*appDelegate.screenWidth1/768, 325.0*appDelegate.screenHeight1/1024)];
/*	else
		authorView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 320, 210)];
*/	authorView.backgroundColor =[UIColor clearColor];
		authorView.tag = 88;
		[myView addSubview:authorView];
		
		
		//************ Remove this AuthorViewNew.....
////	if(appDelegate.screenHeight1 == 1024)
		//authorViewNew = [[UIView alloc] initWithFrame:CGRectMake(106.0*appDelegate.screenWidth1/768, 201.0*appDelegate.screenHeight1/1024, 555.0*appDelegate.screenWidth1/768, 621.0*appDelegate.screenHeight1/1024)];
/*	else
		authorViewNew = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 100, 100)];
*/	//authorViewNew.hidden = YES;
		//img = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"popup_bg.png"]] ];
		//authorViewNew.backgroundColor = [UIColor colorWithPatternImage:img];
		//[img release];
		
		
	UIView *shinyMenu;
    int titleFontSize=13;
	if(appDelegate.screenHeight1 == 1024)
    {
        titleFontSize=20;
    }
		shinyMenu = [[UIView alloc] initWithFrame:CGRectMake(0, 235.0*appDelegate.screenHeight1/480, 768.0*appDelegate.screenWidth1/768, 25.0*appDelegate.screenHeight1/480)];
    UILabel *shinyTitle=[[UILabel alloc]initWithFrame:CGRectMake(8.0*appDelegate.screenWidth1/320, 5.0*appDelegate.screenHeight1/1024, appDelegate.screenWidth1, 22.0*appDelegate.screenHeight1/480)];
    
    [shinyMenu addSubview:shinyTitle];
    
		shinyTitle.backgroundColor = [UIColor clearColor];
    shinyMenu.backgroundColor = [UIColor colorWithRed:73.0/255 green:73.0/255 blue:73.0/255 alpha:1];
        [shinyMenu setColorAtRect:CGRectMake(0, 0, shinyMenu.frame.size.width, 4.0*appDelegate.screenHeight1/480) color:[UIColor yellowColor]];
		//[myView addSubview:shinyMenu];
    shinyTitle.text=@"MAGAZINES";
    shinyTitle.textColor=[UIColor whiteColor];
    shinyTitle.font=[UIFont boldSystemFontOfSize:titleFontSize];
    shinyTitle.textAlignment=UITextAlignmentLeft;
    
    UIButton *deleteB=[UIButton buttonWithType:UIButtonTypeCustom];
    deleteB.frame=CGRectMake(CGRectGetMaxX(shinyMenu.frame)-50, 0, 50, shinyMenu.frame.size.height);
    if (appDelegate.screenWidth1==320) {
        deleteB.frame=CGRectMake((CGRectGetMaxX(shinyMenu.frame)-(85.0*768)/appDelegate.screenWidth1)+85, 0, (85.0*768)/appDelegate.screenWidth1, shinyMenu.frame.size.height);
    }
    objc_setAssociatedObject(self.view, @"deleteB", deleteB, OBJC_ASSOCIATION_RETAIN);
    //[deleteB setTitle:@"Delete Books" forState:UIControlStateNormal];
    [deleteB setImage:[UIImage imageNamed:@"dowload_list.png"] forState:UIControlStateNormal] ;
    [deleteB addTarget:self action:@selector(showAllBooksForDelete) forControlEvents:UIControlEventTouchUpInside];
    [shinyMenu addSubview:deleteB];
    
   // self.allPdfs=[self getPDFS];
    //NSLog(@"total pdf %d",[[self getPDFS] count]);
    
    if ([[self getPDFS] count]==0) {
        deleteB.hidden=YES;
    }
    
    
    
    listOfPdfsDelete=[[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(shinyMenu.frame)-300*(appDelegate.screenWidth1/768), CGRectGetMaxY(shinyMenu.frame), 300*(appDelegate.screenWidth1/768), 400*(appDelegate.screenHeight1/1024)) style:UITableViewStylePlain];
    if (appDelegate.screenWidth1==320) {
        listOfPdfsDelete.frame=CGRectMake(CGRectGetMaxX(shinyMenu.frame)-(300.0/768.0)*appDelegate.screenWidth1, CGRectGetMaxY(shinyMenu.frame), (300.0/768.0)*appDelegate.screenWidth1, (400.0/1024)*appDelegate.screenHeight1);
    }
    
    listOfPdfsDelete.delegate=self;
    listOfPdfsDelete.dataSource=self;
    [self.view addSubview:listOfPdfsDelete];
    listOfPdfsDelete.hidden=YES;
    listOfPdfsDelete.layer.borderWidth=5.0;
    listOfPdfsDelete.layer.borderColor=[UIColor darkGrayColor].CGColor;
    listOfPdfsDelete.layer.shadowOffset = CGSizeMake(-1, -1);
    listOfPdfsDelete.layer.shadowRadius = 15;
    listOfPdfsDelete.layer.shadowOpacity = 0.5;
    listOfPdfsDelete.layer.shadowColor=[UIColor blackColor].CGColor;
    listOfPdfsDelete.layer.shadowPath = [UIBezierPath bezierPathWithRect:listOfPdfsDelete.bounds].CGPath;
    listOfPdfsDelete.editing=YES;
		[shinyMenu release];
		
		
        if(appDelegate.screenHeight1 == 1024)  
		scrollview = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0*appDelegate.screenWidth1/768, 262.0*appDelegate.screenHeight1/480, 768.0*appDelegate.screenWidth1/768, 410.0*appDelegate.screenHeight1/1024)];//[[UIScreen mainScreen] bounds]];
	else
		scrollview = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0*appDelegate.screenWidth1/768, 262.0*appDelegate.screenHeight1/480, 768.0*appDelegate.screenWidth1/768, 170.0*appDelegate.screenHeight1/480)];
	scrollview.backgroundColor = [UIColor clearColor];
		scrollview.scrollEnabled = TRUE;
		scrollview.alwaysBounceVertical = TRUE;
		scrollview.alwaysBounceHorizontal = FALSE;
		scrollview.directionalLockEnabled=YES;
		scrollview.delegate = self;
////	if(appDelegate.screenHeight1 == 1024)
		[scrollview setContentSize:CGSizeMake(768.0*appDelegate.screenWidth1/768, 800.0*appDelegate.screenHeight1/1024)];
/*	else
		[scrollview setContentSize:CGSizeMake(0, [appDelegate.bookListArray count]*115+50)];		
*/    [myView addSubview:scrollview];
		//[scrollview release];
		
		//Over Lay View 
		if (downloadingOverlayView ==nil) 
		{
////			if(appDelegate.screenHeight1 == 1024)
				downloadingOverlayView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768.0*appDelegate.screenWidth1/768, 1024.0*appDelegate.screenHeight1/1024)];
/*			else
				downloadingOverlayView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,480)];
*/			[downloadingOverlayView setAlpha:0.85];
			[downloadingOverlayView setBackgroundColor:[UIColor grayColor]];
			[self.view  addSubview:downloadingOverlayView];
			UIActivityIndicatorView *downloadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
////			if(appDelegate.screenHeight1 == 1024)
				downloadingIndicator.frame = CGRectMake(369.0*appDelegate.screenWidth1/768,497.0*appDelegate.screenHeight1/1024, 30.0*appDelegate.screenWidth1/768, 30.0*appDelegate.screenHeight1/1024);
/*			else
				downloadingIndicator.frame = CGRectMake(153.85,233.01, 15.0, 15.0);
*/			[downloadingIndicator startAnimating];
			[downloadingOverlayView addSubview:downloadingIndicator];
			[downloadingIndicator release];
			
			/*		UIImageView *uiloadimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
			 uiloadimage.image = [UIImage imageNamed:@"loading_b2.jpg"];
			 uiloadimage.backgroundColor = [UIColor clearColor];
			 downloadingOverlayView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
			 [downloadingOverlayView setAlpha:0.85];
			 [downloadingOverlayView setBackgroundColor:[UIColor grayColor]];
			 [self.view  addSubview:downloadingOverlayView];
			 [downloadingOverlayView addSubview:uiloadimage];
			 [uiloadimage release];*/
		}
		[downloadingOverlayView setHidden:TRUE];
		
		
		/* selected book's popup view */
////	if(appDelegate.screenHeight1 == 1024)
		selBookView = [[UIView alloc] initWithFrame:CGRectMake(84.0*appDelegate.screenWidth1/768, 150.0*appDelegate.screenHeight1/1024, 600.0*appDelegate.screenWidth1/768, 700.0*appDelegate.screenHeight1/1024)];
/*	else
		selBookView = [[UIView alloc] initWithFrame:CGRectMake(5,35, 310,363)];
*/	selBookView.hidden = YES;
		selBookView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-back.png"]];
		[myView addSubview:selBookView];
		
		//[selBookView release];
		
		//[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	
	//[NSTimer timerWithTimeInterval:0.3 target:self selector:@selector(LoadAdvertise:) userInfo:nil repeats:NO];
	//[NSTimer timerWithTimeInterval:0.3 target:self selector:@selector(loadScrollView:) userInfo:nil repeats:NO];
	
	loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
////	if(appDelegate.screenHeight1 == 1024)
		loadingIndicator.frame = CGRectMake(369.0*appDelegate.screenWidth1/768,497.0*appDelegate.screenHeight1/1024, 30.0*appDelegate.screenWidth1/768, 30.0*appDelegate.screenHeight1/1024);
/*	else
		loadingIndicator.frame = CGRectMake(153.85,233.01, 20.0, 20.0);
*/	[loadingIndicator startAnimating];
	[self.view addSubview:loadingIndicator];
	[loadingIndicator release];
	
	
	[self performSelector:@selector(loadScrollView:) withObject:nil afterDelay:0.1];
////	[self performSelector:@selector(LoadAdvertise:) withObject:nil afterDelay:0.1];
		//[self LoadAdvertise:nil];
//		[self loadScrollView:nil];	
    if (appDelegate.screenWidth1==320) 
    {
        UIImage *topImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"topimage_ipad" ofType:@"png"]];
        UIImageView *topCoverImage=[[UIImageView alloc]initWithFrame:CGRectMake(-7, -4, topImage.size.width/2, topImage.size.height/2)];
        [topCoverImage setImage:topImage];
        [self.view addSubview:topCoverImage];
        [topCoverImage release];
       // [topImage release];
    }
    else
    {
        UIImage *topImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"topimage_ipad" ofType:@"png"]];
        UIImageView *topCoverImage=[[UIImageView alloc]initWithFrame:CGRectMake(-12, -4, topImage.size.width, topImage.size.height)];
        [topCoverImage setImage:topImage];
        [self.view addSubview:topCoverImage];
        [topCoverImage release];
       // [topImage release];
    }
    
    //UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
//    [btn setTitle:@"i" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    btn.titleLabel.font=[UIFont fontWithName:@"HoeflerText-BlackItalic" size:32];
//    if (appDelegate.screenWidth1==320) 
//    {
//        btn.titleLabel.font=[UIFont fontWithName:@"HoeflerText-BlackItalic" size:17];
//    }
    
    ////	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
	
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"Information.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionSheetAction) forControlEvents:UIControlEventTouchUpInside];
	
    btn.frame=CGRectMake(appDelegate.screenWidth1-((35.0/768)*appDelegate.screenWidth1), (10.0/1024)*appDelegate.screenHeight1, (30.0/768)*appDelegate.screenWidth1, (30.0/1024)*appDelegate.screenHeight1);
    [self.view addSubview:btn];
    
    topBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, appDelegate.screenWidth1, 44)];
    UIView *topBarView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, appDelegate.screenWidth1, 44)];
    UIButton *postBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [postBtn setTitle:@"Post" forState:UIControlStateNormal];
    postBtn.frame=CGRectMake(appDelegate.screenWidth1-90, 5, 70, 35);
    [postBtn addTarget:self action:@selector(twitteract) forControlEvents:UIControlEventTouchUpInside];
    [topBarView addSubview:postBtn];
    [topBarView setBackgroundColor:[UIColor clearColor]];
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
    backBtn.frame=CGRectMake(0, 5, 70, 35);
    [backBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [topBarView addSubview:backBtn];
    
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [postBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *tabBtn2=[[UIBarButtonItem alloc]initWithCustomView:topBarView];
    NSArray *items=[[NSArray alloc]initWithObjects:tabBtn2,nil];
    [topBar setItems:items];
    [topBarView release];
    [tabBtn2 release];
    [items release];
    
 }
 

-(void)showAllBooksForDelete
{
    if ([listOfPdfsDelete isHidden]) {
        allPdfs=[self getPDFS];
        listOfPdfsDelete.hidden=NO;
        [listOfPdfsDelete reloadData];
    }
    else{
        for (UIView *view in self.view.subviews) {
            if (view != listOfPdfsDelete) {
                if ([view alpha]==0.5) {
                    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Do you want cancel downloading?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:[NSArray arrayWithObject:@"YES"]];
                    [errorAlert show];
                    [errorAlert release];
                    return;
                }
            }
        }
        listOfPdfsDelete.hidden=YES;
    }
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	
    return 1;
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [allPdfs count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    }
    
    
    cell.textLabel.text=[[[[allPdfs objectAtIndex:indexPath.row] lastPathComponent] componentsSeparatedByString:@"."] objectAtIndex:0];
    cell.textLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:(20.0*appDelegate.screenWidth1)/768];
    cell.textLabel.textColor=[UIColor darkTextColor];
    cell.textLabel.textAlignment=UITextAlignmentLeft;
   // cell.layer.borderWidth=2;
   // cell.layer.borderColor=[UIColor darkGrayColor].CGColor;
    // cell.selectionStyle=UITableViewCellSelectionStyleGray;
//    UIButton *editButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    editButton.tag=-1000000-indexPath.row;
//    editButton.frame=CGRectMake(0, 0, 80*(appDelegate.screenWidth1/768), 40);
//    [editButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [editButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
//    [editButton setTitle:@"DELETE" forState:UIControlStateNormal];
//    //editButton.tag=indexPath.row;
//    cell.accessoryView=editButton;
    
    return cell;
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return (50.0*appDelegate.screenHeight1)/1024;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Detemine if it's in editing mode
   // if (self.editing) {
        return UITableViewCellEditingStyleDelete;
    //}
    //return UITableViewCellEditingStyleNone;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	
//	if (indexPath.section == 0) {
//		return NO;
//	}
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
        // int buttonTag=[(UIButton *)sender tag];
        //NSLog(@"%@",[allPdfs objectAtIndex:buttonTag+1000000]);
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:[allPdfs objectAtIndex:indexPath.row]] error:NULL];
        //BOOL fileExists = [fileManager fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:[allPdfs objectAtIndex:indexPath.row]]];
        allPdfs=[self getPDFS];
    if ([allPdfs count]==0) {
        listOfPdfsDelete.hidden=YES;
        [objc_getAssociatedObject(self.view, @"deleteB") setHidden:YES];
    }
        [listOfPdfsDelete reloadData];
    for (UIView *view in self.view.subviews) {
        if (view != listOfPdfsDelete) {
            if ([view alpha]==0.5) {
                listOfPdfsDelete.hidden=YES;
                    BookDetails *book = [sortedArray objectAtIndex:CurrentIndex];
                NSString *StrBookUrl = [NSString stringWithFormat:@"%@",book.MagazinePDFFilePath];
                StrBookUrl=[StrBookUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL * bookURL = [[NSURL alloc]initWithString:StrBookUrl];//bookdetailsObj.MagazinePDFFilePath];
                NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:bookURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:180.0];
                if (receivedData) {
                    [receivedData release];
                    receivedData=nil;
                }
                NSString * filename = [NSString stringWithFormat:@"/%@__%@",book.Name,book.IDValue];
                NSLog(@"the file name is %@",filename);
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:filename ];
                
                int fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:[NSString stringWithFormat:@"%@/temp/%@.pdf",dataFilePath,book.Name] error:nil] fileSize];

                if(fileSize)
                {
                
                    [theRequest setValue:[NSString stringWithFormat:@"%d-%d",fileSize+1,filesize] forHTTPHeaderField:@"Range"];

                }
               
                receivedData = [[NSMutableData alloc] initWithLength:0];
                
                
				downloadBookConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self startImmediately:YES];
                
				if (downloadBookConnection) {
					UIApplication *app = [UIApplication sharedApplication];
					
					bgTask = [app beginBackgroundTaskWithExpirationHandler:^{ 
						[app endBackgroundTask:bgTask]; 
						bgTask = UIBackgroundTaskInvalid;
					}];
                    
				}
                
                //				[StrBookUrl release];
				[bookURL release];
                for (UIView *view in self.view.subviews) {
                    if (view!=listOfPdfsDelete) {
                        if (![NSStringFromCGRect(view.frame) isEqualToString:NSStringFromCGRect(CGRectMake(0, 235.0*appDelegate.screenHeight1/480, 768.0*appDelegate.screenWidth1/768, 25.0*appDelegate.screenHeight1/480))]) {
                            view.userInteractionEnabled=YES;
                            view.alpha=1.0;
                        }
                        
                    }
                }
                return;
            }
        }
    }
    [self loadScrollViewContents];

    
}



-(NSMutableArray*)getPDFS
{
    [self.allPdfs removeAllObjects];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm subpathsAtPath:documentsDirectory];
    for (id obj in dirContents) {
        CFStringRef fileExtension = (CFStringRef) [obj pathExtension];
        NSArray *temArray=[obj pathComponents];
        BOOL isNot=NO;
        for (id temp in temArray) {
            if ([temp isEqualToString:@"temp"]) {
                isNot=YES;
            }
        }
        if (!isNot) {
            CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
            if (UTTypeConformsTo(fileUTI, kUTTypePDF)){
                [allPdfs addObject:obj];
            }
            CFRelease(fileUTI);
        }
    }
    return self.allPdfs;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"store view will appear");
	[appDelegate.window setBackgroundColor:[UIColor blackColor]];
	appDelegate.shopview.hidden=YES;
	//[self LoadRemaingBanners:nil];
}


#pragma mark PDFEngine
#pragma mark -
-(void) OpenPDFReader:(NSString *)pdfFile :(NSString *)Booktitle
{
//	    NSString *path = [[[[NSBundle mainBundle]   resourcePath] stringByAppendingPathComponent:@""] stringByAppendingPathComponent:@"PSPDFKit.pdf"];
//	document = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:pdfFile]];//pdfFile]];
////	[document setIsEnabledLinks:appDelegate.IsEnabledLinks];
//    //PSPDFDocument *document = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:path]];
//	if (pdfController!=nil)
//	{
//		[pdfController release];
//		pdfController=nil;
//	}
//    pdfController = [[PSPDFViewController alloc] initWithDocument:document];
//	pdfController.document.title=Booktitle;
//	pdfController.document.aspectRatioEqual =NO;
//	if (navController!=nil)
//	{
//		[navController release];
//		navController=nil;
//	}
//	navController = [[UINavigationController alloc] initWithRootViewController:pdfController];
//	[self presentModalViewController:navController animated:YES];
	//    self.rootViewController = navController;	
    
   // NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Sample.pdf"];
    document = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:pdfFile]];
    
    // open view controller
    
    pdfController = [[PSPDFViewController alloc] initWithDocument:document] ;
    pdfController.pageCurlEnabled=YES;
    if (navController) {
        [navController release];
        navController=nil;
    }
    navController = [[UINavigationController alloc] initWithRootViewController:pdfController];
    [pdfController release];
    pdfController=nil;
    //[[PSPDFCache sharedPSPDFCache] clearCache];
    [self presentModalViewController:navController animated:YES];
}

#pragma mark -


// Content View has been given the index as tag no .
// and all the imageview have been given with 21 as tag no to have identification .

-(void)loadScrollView:(id)sender
{	

	
	
	//Banner ScroView............
	//if (bannerScrollView!=nil ) {
//		for(UIView *subview in bannerScrollView.subviews)
//		{
//			[subview removeFromSuperview];
//		}
//		[bannerScrollView removeFromSuperview];
//		[bannerScrollView release];
//		bannerScrollView=nil;
//	}
	if(bannerScrollView==nil)
	{
        
        ////		if(appDelegate.screenHeight1 == 1024)
        bannerScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0.0*appDelegate.screenWidth1/768, 0.0*appDelegate.screenHeight1/480,(768.0-60.0)*appDelegate.screenWidth1/768, 162*appDelegate.screenHeight1/480.0)];
        /*		else
         bannerScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(2, 3,300, 117)];
         */		bannerScrollView.pagingEnabled=TRUE;
        ////		if(appDelegate.screenHeight1 == 1024)
        [bannerScrollView setContentSize:CGSizeMake((768.0-60.0)*appDelegate.screenWidth1/768, 162*appDelegate.screenHeight1/480.0)];
        /*		else
         [bannerScrollView setContentSize:CGSizeMake(300, 117)];	
         */		[authorView addSubview:bannerScrollView];
		bannerScrollView.backgroundColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.1];
	}
	
	
	
    //Downlload the Banners data
	[self DownloadBanners:nil];
	[self DownloadAdvertise:nil];
	
	sortedArray = [[NSMutableArray alloc]init];
	
	
	NSUserDefaults *Store_LinksValue = [NSUserDefaults standardUserDefaults];
	
	//NIKHIL NEW CODE
	
	if([Store_LinksValue integerForKey:@"gotComicAtleastOnce"]!=777)
	{
		
		NSString *str =@"http://www.google.com";
		NSURL *url = [[NSURL alloc] initWithString:str];
		NSData *data = [[NSData alloc]initWithContentsOfURL:url];
		if(data==nil)
		{
			
			UIView *errView;
			UILabel *errlabel;
////			if(appDelegate.screenHeight1 == 1024)
				errView= [[UIView alloc] initWithFrame:CGRectMake(0, 0,768.0*appDelegate.screenWidth1/768 , 1024.0*appDelegate.screenHeight1/1024)];
/*			else
				errView= [[UIView alloc] initWithFrame:CGRectMake(0, 0,320,480)];
*/			if(appDelegate.screenHeight1 == 1024)
				errlabel= [[UILabel alloc] initWithFrame:CGRectMake(70, 500,668 , 100)];
			else{
				errlabel= [[UILabel alloc] initWithFrame:CGRectMake(70, 500,320 , 100)];
				errlabel.center=self.view.center;
				errlabel.textAlignment=UITextAlignmentCenter;
				errlabel.numberOfLines=3;
			}
			errlabel.text=@"This application requires active internet connection. Please connect to internet." ;
			[errView addSubview:errlabel];
			[errView setBackgroundColor:[UIColor blackColor]];
			[errlabel setBackgroundColor:[UIColor clearColor]];
			[errlabel setTextColor:[UIColor whiteColor]];
			
			[self.view addSubview:errView];
			
			[errView release];
			[errlabel release];
			[url release];
			
			return;
			
		}
		else 
		{
			
			[Store_LinksValue setInteger:777 forKey:@"gotComicAtleastOnce"];
			[Store_LinksValue synchronize];
		}
		[url release];
		[data release];
	}
	
	
	///NIKHIL NEW CODE - END 
	
	
	
	//[scrollview setContentSize:CGSizeMake(750, 800+(height*182)+950)];
	

	[NSThread detachNewThreadSelector:@selector(loadBannerAtIndex:)  toTarget:self withObject:0];
	[NSThread detachNewThreadSelector:@selector(LoadAddvertisements:) toTarget:self withObject:nil];
	
	
	//[self performSelectorInBackground:@selector(loadBannerAtIndex:) withObject:0];
	//[self performSelectorInBackground:@selector(LoadAddvertisements:) withObject:nil];
	[self loadScrollViewContents];
    [self ResumeDownloadingBooks:nil];
	
	[loadingIndicator stopAnimating];
	
	//************/
}

-(void)loadScrollViewContents{
    for (UIView *view in scrollview.subviews) {
        [view removeFromSuperview];
    }
    [sortedArray removeAllObjects];
	if (show_All)
	{
		for (int i =0; i<[appDelegate.bookListArray count]; i++) 
		{
			[sortedArray addObject:[appDelegate.bookListArray objectAtIndex:i]];
		}
	}
	
	
	int height = 0;//(([sortedArray count]+1) - totCnt)/(totCnt);
	int i = 0;
	int singleContentViewSize = 0;
    
	int Count = ceil((([sortedArray count]/nRow)+height)+0.1);
	if(Count == 1)
		nCol = 1;
	
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	int fontSize1=10;
    int fontSize2=8;
    if (appDelegate.screenHeight1==1024) 
    {
        fontSize1=15;
        fontSize2=13;
    }
    
    ////	if(appDelegate.screenHeight1 == 1024)
	{
		for(int row = 0; row < Count; row++)
		{
			for(int col = 0; col < nCol; col++)
			{
				if(i < [sortedArray count])
				{
					if(appDelegate.bookListArray == nil)
						[appDelegate.bookListArray retain];
					BookDetails *bookdetailsObj = (BookDetails *)[sortedArray objectAtIndex:i];
					[bookdetailsObj retain];
					
					selectedBookIndex = [bookdetailsObj.IDValue intValue];
					
					UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(((159*col))*appDelegate.screenWidth1/320.0, ((68*row)+0)*appDelegate.screenHeight1/480.0, 158*appDelegate.screenWidth1/320.0, 66*appDelegate.screenHeight1/480.0)];
					contentView.tag = 900+i;
					contentView.backgroundColor = [UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1];
                    
					
					UIImageView *coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(30*appDelegate.screenWidth1/768.0, 12*appDelegate.screenHeight1/1024.0, 75*appDelegate.screenWidth1/768.0, 115*appDelegate.screenHeight1/1024.0)];
					coverImage.tag = 9999;
					
					NSArray *arr_Stings = [bookdetailsObj.CatalogImage componentsSeparatedByString:@"/"];
					
					NSString * filename = [arr_Stings objectAtIndex:[arr_Stings count]-1];// [NSString stringWithFormat:@"%@_Cata.png",bookdetailsObj.Name];
					NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
					NSString *documentsDirectory = [paths objectAtIndex:0];
					NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:filename];
					BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataFilePath];
					if(fileExists)
					{
						UIImage *img = [UIImage imageWithContentsOfFile:dataFilePath];
						if(img!=nil)
							coverImage.image =  img;
						
					}
					else 
					{
						NSURL *url = [[NSURL alloc] initWithString:bookdetailsObj.CatalogImage];
						NSLog(@"###%@###",url);
						NSData *data = [[NSData alloc] initWithContentsOfURL:url];
						if(data!=nil)
						{
							//save this image.......
							coverImage.image = [UIImage imageWithData:data];
							[data writeToFile:[DOCUMENTS_FOLDER stringByAppendingPathComponent:filename] atomically:YES];
						}
						[url release];
						[data release];
					}
					[contentView addSubview:coverImage];
					[coverImage release];
					
					UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120*appDelegate.screenWidth1/768.0, 16*appDelegate.screenHeight1/1024.0, 250*appDelegate.screenWidth1/768.0, 20*appDelegate.screenHeight1/1024.0)];
					titleLabel.text = bookdetailsObj.Name;//bookdetailsObj.bookTitle;
					titleLabel.numberOfLines = 0;
					//	titleLabel.font=[UIFont  fontWithName:@"Verdana-Bold" size:14];
					[titleLabel setBackgroundColor:[UIColor clearColor]];
					titleLabel.textColor = [UIColor blackColor];
					[contentView addSubview:titleLabel];
                    [titleLabel setFont:[UIFont fontWithName:@"Trebuchet-BoldItalic" size:fontSize1]];
					[titleLabel release];
					
					UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(120*appDelegate.screenWidth1/768.0, 31*appDelegate.screenHeight1/1024.0, 250*appDelegate.screenWidth1/768.0, 50*appDelegate.screenHeight1/1024.0)];
					descLabel.text = bookdetailsObj.Description;//bookdetailsObj.description;
					descLabel.textColor = [UIColor blackColor];
					descLabel.numberOfLines = 3;
					descLabel.backgroundColor = [UIColor clearColor];
					descLabel.font = [UIFont systemFontOfSize:fontSize2];
					[contentView addSubview:descLabel];
					[descLabel release];
					
					UILabel *descLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(120*appDelegate.screenWidth1/768.0, 76*appDelegate.screenHeight1/1024.0, 250*appDelegate.screenWidth1/768.0, 30*appDelegate.screenHeight1/1024.0)];
					if([bookdetailsObj.Price intValue]>0)
					{
						descLabel1.text = [NSString stringWithFormat:@"$ %.2f", [bookdetailsObj.Price floatValue]];//bookdetailsObj.description;
					}
					//if ([descLabel1.text isEqualToString:@""]) {
					else{
						descLabel1.text = @"$ Free";//bookdetailsObj.description;
					}
                    
                    
					descLabel1.textColor = [UIColor blackColor];
					descLabel.numberOfLines = 2;
					descLabel1.backgroundColor = [UIColor clearColor];
					descLabel1.font = [UIFont systemFontOfSize:fontSize2];
					[contentView addSubview:descLabel1];
					[descLabel1 release];
					
					////*********Book Selection Action   ************ ////
					MyCustomButton *bookBtn = [[MyCustomButton alloc] initWithIndex:selectedBookIndex];
					//[bookBtn setFrame:CGRectMake(0, 0, 375, 126)];
					[bookBtn setFrame:coverImage.frame];
					bookBtn.tag=850+i;
					[bookBtn addTarget:self action:@selector(selBookAction:) forControlEvents:UIControlEventTouchUpInside];	
					[contentView addSubview:bookBtn];
					[bookBtn release];	
					
					//if(row*2+col+1!= [sortedArray count])
					[scrollview addSubview:contentView];
					singleContentViewSize = contentView.frame.size.height;
					singleContentViewSize +=10;					
					
					UIButton *costButton = [[UIButton alloc] initWithFrame:CGRectMake(235*appDelegate.screenWidth1/768.0, 100*appDelegate.screenHeight1/1024.0, 110*appDelegate.screenWidth1/768.0,32*appDelegate.screenHeight1/1024.0)];
					NSLog(@"%f -- %f",110*appDelegate.screenWidth1/768.0,32*appDelegate.screenHeight1/1024.0);
					[costButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
					[costButton addTarget:self action:@selector(Downloading:) forControlEvents:UIControlEventTouchUpInside];
					NSString *strFileName = [NSString stringWithFormat:@"%@__%@/%@.pdf",bookdetailsObj.Name,bookdetailsObj.IDValue,bookdetailsObj.Name];
                    //[costButton setBackgroundColor:[UIColor colorWithRed:204.0/255 green:51.0/255 blue:59.0/255 alpha:1]];
                    
                    if (appDelegate.screenWidth1==768)
                        [costButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"magBtn_ipad.png"]]];
                    else
                        [costButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"magBtn.png"]]];
                    
                   // [costButton setImage:[UIImage imageNamed:@"magBtn.png"] forState:UIControlStateNormal];
					if([appDelegate checkFileExist:strFileName])
					{
                        //	[costButton setBackgroundImage:[UIImage imageNamed:@"read.png"] forState:UIControlStateNormal];
                        
                        [costButton setTitle:@"READ" forState:UIControlStateNormal];
                        
						//[costButton setTitle:@"Read" forState:UIControlStateDisabled];
						bookdetailsObj.IsDownloading_Or_Downloaded = YES;
						//readpath = [[NSBundle mainBundle]pathForResource:@"read" ofType:@"png"];
						//					readimg=[NSData dataWithContentsOfFile:readpath];
					}
					else 
					{
						purchasecheck = [bookdetailsObj.Purchased intValue];
						NSLog(@"downloading book product id===>%@",bookdetailsObj.ItunesProductID);
						if(purchasecheck == 1)
						{
                            //	[costButton setBackgroundImage:[UIImage imageNamed:@"Buy-Now1.png"] forState:UIControlStateNormal];
                            [costButton setTitle:@"BUY NOW" forState:UIControlStateNormal];
						}
						else
						{
//                            [costButton setBackgroundColor:[UIColor clearColor]];
//                            [costButton setBackgroundImage:[UIImage imageNamed:@"btn_download.png"] forState:UIControlStateNormal];
                            [costButton setTitle:@"DOWNLOAD" forState:UIControlStateNormal];
                            
						}
					}
                    if (appDelegate.screenWidth1==768) 
                    {
                        costButton.titleLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:15];
                    }
                    else
                    {
                        costButton.titleLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:7];
                    }
                    [costButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
					costButton.tag = 800+i;
                    /*		costButton.titleLabel.textColor = [UIColor whiteColor];
                     costButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
                     costButton.titleLabel.shadowColor = [UIColor grayColor];
                     */		[contentView addSubview:costButton];
					[costButton release];
					
					[contentView release];
					[bookdetailsObj release];
					bookdetailsObj = nil;
					i++;
				}
                else
                {
                    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(((159*(col)))*appDelegate.screenWidth1/320.0, ((68*row)+0)*appDelegate.screenHeight1/480.0, 158*appDelegate.screenWidth1/320.0, 66*appDelegate.screenHeight1/480.0)];
					
					contentView.backgroundColor = [UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1];
                    [scrollview addSubview:contentView];
                    [contentView release];
                }
			}
		}
	}
    if ([sortedArray count]<=4) 
     {
         [scrollview setContentSize:CGSizeMake(768*appDelegate.screenWidth1/768.0,scrollview.frame.size.height)];	
         
     }
     else 
     {
         [scrollview setContentSize:CGSizeMake(768*appDelegate.screenWidth1/768.0,(([sortedArray count]+1)/2*66)*appDelegate.screenHeight1/480.0)];	
    }
    [pool drain];

}
-(void)viewDidAppear:(BOOL)animated
{
	//Load Remaining Banners After Complete Data Displayed
	[self LoadRemaingBanners:nil];
}

-(void)LoadRemaingBanners:(id)Sender
{
	int Count = [arr_Banners count];
	for(int j=1;j<Count;j++)
	{
		[self loadBannerAtIndex:j];
	}
}

-(void)loadBannerAtIndex:(NSInteger)Index
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	//Adding th Loader 
    
	UIActivityIndicatorView *IndicatorView;
////	if(appDelegate.screenHeight1 == 1024)
		IndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(350*appDelegate.screenWidth1/768.0, 125*appDelegate.screenHeight1/1024.0, 50*appDelegate.screenWidth1/768.0, 50*appDelegate.screenHeight1/1024.0)];
/*	else
		IndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(146.12, 59, 21, 23.4)];
*/	IndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	IndicatorView.tag = 50;
	[bannerScrollView addSubview:IndicatorView];
	[IndicatorView startAnimating];
	UIButton *btnAdv;
////	if(appDelegate.screenHeight1 == 1024)
		btnAdv = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,(768.0-60)*appDelegate.screenWidth1/768.0, 162*appDelegate.screenHeight1/480.0)];
/*	else
		btnAdv = [[UIButton alloc] initWithFrame:CGRectMake(bannerScrollView.contentSize.width-300, 0,300, 117)];
*/
	[bannerScrollView addSubview:btnAdv];

//	UIImageView *tmpImgView = [[UIImageView alloc]initWithFrame:CGRectMake(bannerScrollView.contentSize.width-724, 0,724, 281)];
//	[bannerScrollView addSubview:tmpImgView];
	NSString * filename;
//	if (chkSumStr!=nil)
//		filename = [[NSString alloc] initWithFormat:@"%@",chkSumStr];
//	else
		filename = [NSString stringWithFormat:@"Banner_(%i).jpg",Index];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:filename];
	//[filename release];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataFilePath];
	if(fileExists)
	{
		[btnAdv setBackgroundImage:[UIImage imageWithContentsOfFile:dataFilePath] forState:UIControlStateNormal];
		[btnAdv addTarget:self action:@selector(BannerBntClicked:) forControlEvents:UIControlEventTouchUpInside];		
		//tmpImgView.image =  [UIImage imageWithContentsOfFile:dataFilePath];
		
	}
	else 
	{
		Baners_Class *obj_bannerClass = [arr_Banners objectAtIndex:Index];
		NSURL *url = [[NSURL alloc] initWithString:obj_bannerClass.imageURL];
		NSData *data = [[NSData alloc] initWithContentsOfURL:url];
		if(data!=nil)
		{
			[btnAdv setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
			[btnAdv addTarget:self action:@selector(BannerBntClicked:) forControlEvents:UIControlEventTouchUpInside];		
//			tmpImgView.image=[UIImage imageWithData:data];
			//Save Corrresponding banner image 
//			if (chkSumStr!=nil)
//				[data writeToFile:[DOCUMENTS_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",chkSumStr]] atomically:YES];
//			else
				[data writeToFile:[DOCUMENTS_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"Banner_(%i).jpg",Index]] atomically:YES];
			
		}
		[url release];
		[data  release];
	}
	[btnAdv release];
	
	
	@try 
	{
		UIActivityIndicatorView *IndView = (UIActivityIndicatorView *)[bannerScrollView viewWithTag:50];
		if(IndView!=nil)
		{
			[IndView stopAnimating];
			[IndView removeFromSuperview];
		}
	}
	@catch (NSException * e)
	{
		//No Indicator View I Got .........
	}
	@finally 
	{
		
	}
	
	[IndicatorView stopAnimating];
	[IndicatorView release];
	if(Index!=[arr_Banners count]-1)
////		if(appDelegate.screenHeight1 == 1024)
			[bannerScrollView setContentSize:CGSizeMake(bannerScrollView.contentSize.width+(ipadScrollx*appDelegate.screenWidth1/768.0), 162*appDelegate.screenHeight1/480.0)];//bannerScrollView.contentSize.width+ipadScrollx
/*		else
			[bannerScrollView setContentSize:CGSizeMake(bannerScrollView.contentSize.width+iphoneScrollx, 117)];
*/	
	[pool drain];
}

-(void)LoadAddvertisements:(id)Sender
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self LoadAdvertise:nil];
	if(arr_Advertise!=nil)
	{
		int Count = [arr_Advertise count];
		for(int j=0;j<Count;j++)
		{
			NSString * filename = [NSString stringWithFormat:@"Addv_(%i).jpg",j];
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:filename] ;
			//[filename release];
			//BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataFilePath];
/*			if(fileExists)
			{
			//	if(j<3)
				{
					UIButton *btnAdv = (UIButton *)[self.view viewWithTag:250+j];
					if(btnAdv!=nil)
					{
						[btnAdv setImage:[UIImage imageWithContentsOfFile:dataFilePath] forState:UIControlStateNormal];
						
						//[btnAdv addTarget:self action:@selector(AdvertiseBntClicked:) forControlEvents:UIControlEventTouchUpInside];
					
						UIActivityIndicatorView *actInd = (UIActivityIndicatorView *)[btnAdv viewWithTag:50];
						if(actInd!=nil)
						{
							[actInd stopAnimating];
							[actInd removeFromSuperview];
						}					
					}
				}
			}
			else 
*/			{
				Advertise_Class *obj_Advertise = [arr_Advertise objectAtIndex:j];
				NSURL *url = [[NSURL alloc] initWithString:obj_Advertise.imageURL];
				NSData *data = [[NSData alloc] initWithContentsOfURL:url];
				if(data!=nil)
				{
				//	if(j<3)
					{
						UIButton *btnAdv = (UIButton *)[self.view viewWithTag:250+j];
						if(btnAdv!=nil)
						{
							[btnAdv setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
							UIActivityIndicatorView *actInd = (UIActivityIndicatorView *)[btnAdv viewWithTag:50];
							if(actInd!=nil)
							{
								[actInd stopAnimating];
								[actInd removeFromSuperview];
							}
													}
					}
					[data writeToFile:[DOCUMENTS_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"Addv_(%i).jpg",j]] atomically:YES];
				}
				[url release];
				[data release];
			}
			//[dataFilePath release];
		}
	}
	else 
	{
		int Count = 3;
		for(int j=0;j<Count;j++)
		{
			NSString * filename = [NSString stringWithFormat:@"Addv_(%i).jpg",j];
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:filename];
			//[filename release];
			BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataFilePath];
			if(fileExists)
			{
				if(j<3)
				{
					UIButton *btnAdv = (UIButton *)[self.view viewWithTag:250+j];
					if(btnAdv!=nil)
					{
						[btnAdv setImage:[UIImage imageWithContentsOfFile:dataFilePath] forState:UIControlStateNormal];
						
						[btnAdv addTarget:self action:@selector(AdvertiseBntClicked:) forControlEvents:UIControlEventTouchUpInside];
						
						UIActivityIndicatorView *actInd = (UIActivityIndicatorView *)[btnAdv viewWithTag:50];
						if(actInd!=nil)
						{
							[actInd stopAnimating];
							[actInd removeFromSuperview];
						}							
					}
				}
			}
			//[dataFilePath release];
		}
	}
	[pool drain];
}

-(void)ResumeDownloadingBooks:(id)Sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *data = [defaults objectForKey:@"DownloadingBooks"];
	NSArray *arr_BooksDownload = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	if(arr_BooksDownload!=nil)
	{
		appDelegate.Arr_DownloadingBooks = arr_BooksDownload;
	}
	
	int DownBookCount = [appDelegate.Arr_DownloadingBooks count];
	//int BooksCount = [sortedArray count];
	//BOOL IsReceived = NO;
	BOOL IsGoingToDownload = NO;
	for(int j=0;j<DownBookCount;j++)
	{
		int idx1 = [[appDelegate.Arr_DownloadingBooks objectAtIndex:j] intValue];
		if(IsGoingToDownload)
		{
			NSLog(@"Inside if download resume==>%d",idx1);
			[self StartLoader:idx1];
		}	
		else 
		{
			NSLog(@"Inside else download resume==>%d",idx1);
			CurrentIndex= idx1;
			BookDetails *book = [sortedArray objectAtIndex:CurrentIndex];
			[self StartLoader:CurrentIndex];
			[self performSelector:@selector(DownloadThisBook:) withObject:book afterDelay:0.5];
			IsGoingToDownload = YES;
		}
	}
	
	
	
	
}


//-(void)ResumeDownloadingBooks:(id)Sender
//{
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//	NSData *data = [defaults objectForKey:@"DownloadingBooks"];
//	NSArray *arr_BooksDownload = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//	if(arr_BooksDownload!=nil)
//	{
//		appDelegate.Arr_DownloadingBooks = arr_BooksDownload;
//	}
//	
//	int DownBookCount = [appDelegate.Arr_DownloadingBooks count];
//	int BooksCount = [sortedArray count];
//	BOOL IsReceived = NO;
//	BOOL IsGoingToDownload = NO;
//	for(int j=0;j<DownBookCount;j++)
//	{
//		NSString *BookName = [appDelegate.Arr_DownloadingBooks objectAtIndex:j];
//		NSLog(@"Download books resuming ==>%@",BookName);
//		for(int k=0;k<BooksCount;k++)
//		{
//			BookDetails *book = [sortedArray objectAtIndex:k];
//			NSLog(@"Download books resuming ==>%@",BookName);
//			if([BookName isEqualToString:book.Name] ) 
//			{
//				if(IsGoingToDownload)
//				{
//					[self StartLoader:k];
//				}	
//				else 
//				{
//					CurrentIndex= k;
//					BookDetails *book = [sortedArray objectAtIndex:j];
//					[self StartLoader:CurrentIndex];
//					[self performSelector:@selector(DownloadThisBook:) withObject:book afterDelay:0.5];
//					IsGoingToDownload = YES;
//				}
//			}
//		}
//		
//	}
	
//	for(int j=0;j<DownBookCount;j++)
//	{
//		int idx1 = [[appDelegate.Arr_DownloadingBooks objectAtIndex:j] intValue];
//		if(IsGoingToDownload)
//		{
//			NSLog(@"Inside if download resume==>%d",idx1);
//			[self StartLoader:idx1];
//		}	
//		else 
//		{
//			NSLog(@"Inside else download resume==>%d",idx1);
//			CurrentIndex= idx1;
//			BookDetails *book = [sortedArray objectAtIndex:CurrentIndex];
//			[self StartLoader:CurrentIndex];
//			[self performSelector:@selector(DownloadThisBook:) withObject:book afterDelay:0.5];
//			IsGoingToDownload = YES;
//		}
//	}
//	
//	

//	
//}


-(void)LoadAdvertise:(id)Sender
{
	adevertiseScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake((13)*appDelegate.screenWidth1/320.0, 190*appDelegate.screenHeight1/480.0, 3*(100*appDelegate.screenWidth1/320.0), 38*appDelegate.screenHeight1/480.0)];	
    UIColor *arr_cols[3];
    arr_cols[0]=[UIColor orangeColor];
    arr_cols[1]=[UIColor blueColor];
    arr_cols[2]=[UIColor greenColor];
    
    int adCount=[arr_Advertise count];
    if (!adCount) 
    {
        adCount=3;
    }
    adevertiseScrollView.contentSize=CGSizeMake(adCount*(98*appDelegate.screenWidth1/320.0), 38*appDelegate.screenHeight1/480.0);
    if (adCount) 
    {
        for (int i=0; i<adCount; i++) 
        {
            CustomButton *btn_Addver = [[CustomButton alloc] initWithFrame:CGRectMake((98*(i))*appDelegate.screenWidth1/320.0, 0*appDelegate.screenHeight1/480.0,98*appDelegate.screenWidth1/320.0, 38*appDelegate.screenHeight1/480.0)];
            btn_Addver.backgroundColor = [UIColor colorWithRed:2550. green:255.0 blue:255.0 alpha:0.1];
           // [btn_Addver setColorAtRect:CGRectMake(0, 0, btn_Addver.frame.size.width, 4*appDelegate.screenHeight1/480.0) color:arr_cols[i%3]];
            btn_Addver.tag = 250+i;
            [btn_Addver addTarget:self action:@selector(AdvertiseBntClicked:) forControlEvents:UIControlEventTouchUpInside];
            [adevertiseScrollView addSubview:btn_Addver];
        }
    }
    [adevertiseScrollView setScrollEnabled:FALSE];
    [myView addSubview:adevertiseScrollView];
    /*    
     CustomButton *btn_Addver1;
     CustomButton *btn_Addver2;
     CustomButton *btn_Addver3;
     btn_Addver1 = [[CustomButton alloc] initWithFrame:CGRectMake((0)*appDelegate.screenWidth1/320.0, 0*appDelegate.screenHeight1/480.0,95*appDelegate.screenWidth1/320.0, 38*appDelegate.screenHeight1/480.0)];
     btn_Addver2 = [[CustomButton alloc] initWithFrame:CGRectMake((0+95)*appDelegate.screenWidth1/320.0, 0*appDelegate.screenHeight1/480.0, 95*appDelegate.screenWidth1/320.0, 38*appDelegate.screenHeight1/480.0)];
     btn_Addver3 = [[CustomButton alloc] initWithFrame:CGRectMake((0+95+95)*appDelegate.screenWidth1/320.0, 0*appDelegate.screenHeight1/480.0, 95*appDelegate.screenWidth1/320.0, 38*appDelegate.screenHeight1/480.0)];	
     
     btn_Addver1.backgroundColor = [UIColor colorWithRed:2550. green:255.0 blue:255.0 alpha:0.1];
     btn_Addver2.backgroundColor = [UIColor colorWithRed:2550. green:255.0 blue:255.0 alpha:0.1];
     btn_Addver3.backgroundColor = [UIColor colorWithRed:2550. green:255.0 blue:255.0 alpha:0.1];
     [btn_Addver1 setColorAtRect:CGRectMake(0, 0, btn_Addver1.frame.size.width, 4*appDelegate.screenHeight1/480.0) color:[UIColor orangeColor]];
     [btn_Addver2 setColorAtRect:CGRectMake(0, 0, btn_Addver1.frame.size.width, 4*appDelegate.screenHeight1/480.0) color:[UIColor blueColor]];
     [btn_Addver3 setColorAtRect:CGRectMake(0, 0, btn_Addver1.frame.size.width, 4*appDelegate.screenHeight1/480.0) color:[UIColor greenColor]];
     
     btn_Addver1.tag = 250;
     btn_Addver2.tag = 251;
     btn_Addver3.tag = 252;
     
     [btn_Addver1 addTarget:self action:@selector(AdvertiseBntClicked:) forControlEvents:UIControlEventTouchUpInside];
     [btn_Addver2 addTarget:self action:@selector(AdvertiseBntClicked:) forControlEvents:UIControlEventTouchUpInside];
     [btn_Addver3 addTarget:self action:@selector(AdvertiseBntClicked:) forControlEvents:UIControlEventTouchUpInside];
     
     ////	if(appDelegate.screenHeight1 == 1024)
     {
     [adevertiseScrollView addSubview:btn_Addver1];
     [adevertiseScrollView addSubview:btn_Addver2];
     [adevertiseScrollView addSubview:btn_Addver3];
     }
     
     
     /*	
     //Adding the UIactivity indicaters..........
     UIActivityIndicatorView *IndicatorView1 = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 40, 20, 20)];
     IndicatorView1.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
     IndicatorView1.tag = 50;
     [btn_Addver1 addSubview:IndicatorView1];
     [IndicatorView1 startAnimating];
     [IndicatorView1 release];
     
     UIActivityIndicatorView *IndicatorView2 = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 40, 20, 20)];
     IndicatorView2.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
     IndicatorView2.tag = 50;
     [btn_Addver2 addSubview:IndicatorView2];
     [IndicatorView2 startAnimating];
     [IndicatorView2 release];
     
     UIActivityIndicatorView *IndicatorView3 = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 40, 20, 20)];
     IndicatorView3.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
     IndicatorView3.tag = 50;
     [btn_Addver3 addSubview:IndicatorView3];
     [IndicatorView3 startAnimating];
     [IndicatorView3 release];
     
     
     [btn_Addver1 release];
     [btn_Addver2 release];
     [btn_Addver3 release];
     */    
    
//    NSString *imageName=@"blue_prev1";
//    if (appDelegate.screenWidth1==768) 
//    {
//        imageName=@"blue_prev2";
//    }
//    UIImage *btnImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imageName ofType:@"png"]];
//    UIButton *prevAdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    prevAdBtn.frame=CGRectMake((30)*appDelegate.screenWidth1/768.0, 189*appDelegate.screenHeight1/480.0, btnImage.size.width, btnImage.size.height);
//    [prevAdBtn setImage:btnImage forState:UIControlStateNormal];
//    [prevAdBtn addTarget:self action:@selector(gotoPrevBanner) forControlEvents:UIControlEventTouchUpInside];   
//    [myView addSubview:prevAdBtn];
//    
//    if (adCount==3) 
//    {
//        [prevAdBtn setImage:btnImage forState:UIControlStateHighlighted];
//    }
//    
//    NSString *imageName2=@"blue_next1";
//    if (adCount==3) 
//    {
//        imageName2=@"blue_next11";
//    }
//    if (appDelegate.screenWidth1==768) 
//    {
//        imageName2=@"blue_next2";
//        if (adCount==3) 
//        {
//            imageName2=@"blue_next21";
//        }
//    }
//    UIImage *btnImage2=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imageName2 ofType:@"png"]];
//    UIButton *nextAdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    if (appDelegate.screenWidth1==320) 
//    {
//        nextAdBtn.frame=CGRectMake((25+95+95+82)*appDelegate.screenWidth1/320.0, 189*appDelegate.screenHeight1/480.0, btnImage2.size.width, btnImage2.size.height);
//    }
//    else
//    {
//        nextAdBtn.frame=CGRectMake(((appDelegate.screenWidth1-30)*appDelegate.screenWidth1/768.0)-btnImage2.size.width, 189*appDelegate.screenHeight1/480.0, btnImage2.size.width, btnImage2.size.height);
//    }
//    [nextAdBtn setImage:btnImage2 forState:UIControlStateNormal];
//    [nextAdBtn addTarget:self action:@selector(gotoNextBanner) forControlEvents:UIControlEventTouchUpInside];    
//    [myView addSubview:nextAdBtn];
//    if (adCount==3) 
//    {
//        [nextAdBtn setImage:btnImage2 forState:UIControlStateHighlighted];
//    }
    //[btnImage release];
    //[btnImage2 release];
}
-(void)gotoNextBanner
{
    if (adScrollInProcess) 
    {
        return;
    }
    int width=adevertiseScrollView.contentSize.width;
    int presentPoint=adevertiseScrollView.contentOffset.x;
    if (presentPoint+adevertiseScrollView.frame.size.width<width) 
    {
        adScrollInProcess=TRUE;
        //    adevertiseScrollView.contentOffset=CGPointMake(((95*appDelegate.screenWidth1/320.0)+adevertiseScrollView.contentOffset.x), 0);
        [adevertiseScrollView setContentOffset:CGPointMake(((94*appDelegate.screenWidth1/320.0)+adevertiseScrollView.contentOffset.x), 0) animated:TRUE];
        [self performSelector:@selector(enableAdscroll) withObject:nil afterDelay:1];
    }
}
-(void)gotoPrevBanner
{
    if (adScrollInProcess) 
    {
        return;
    }
    //int width=adevertiseScrollView.contentSize.width;
    int presentPoint=adevertiseScrollView.contentOffset.x;
    if (presentPoint>0) 
    {
        adScrollInProcess=TRUE;
        //   adevertiseScrollView.contentOffset=CGPointMake(adevertiseScrollView.contentOffset.x-(95*appDelegate.screenWidth1/320.0), 0);
        [adevertiseScrollView setContentOffset:CGPointMake(adevertiseScrollView.contentOffset.x-(94*appDelegate.screenWidth1/320.0), 0) animated:TRUE];
        [self performSelector:@selector(enableAdscroll) withObject:nil afterDelay:1];
    }
}
-(void)enableAdscroll
{
    adScrollInProcess=FALSE;
}
-(void)BannerBntClicked:(id)Sender
{
    [listOfPdfsDelete setHidden:YES];
	Baners_Class *obj_bannerClass = [arr_Banners objectAtIndex:0];
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
	
	appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.videoVC.view setHidden:TRUE];
	
	//appDelegate.shopview.hidden=YES;
	[appDelegate.window setBackgroundColor:[UIColor blackColor]];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
	[UIView commitAnimations];	
	//appDelegate.shopview.hidden=NO;
	
	NSLog(@"Banner btn Clicked %@",obj_bannerClass.BannerURL);
	UIWebView *WebView;
    
////	if(appDelegate.screenHeight1 == 1024)
		WebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768*appDelegate.screenWidth1/768.0, 1024*appDelegate.screenHeight1/1024.0)];
/*	else
		WebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
*/	WebView.clearsContextBeforeDrawing = YES;
	WebView.tag = 150;
	WebView.delegate = self;
	[WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:obj_bannerClass.BannerURL]]];
	[WebView setScalesPageToFit:YES];
	WebView.opaque = NO;
	[self.view addSubview:WebView];
	
	//Create a Close btn To close the web View.......
	UIButton *btn_closeWebView ;
	if(appDelegate.screenHeight1 == 1024) 
		btn_closeWebView = [[UIButton alloc] initWithFrame:CGRectMake(720*appDelegate.screenWidth1/768.0,25*appDelegate.screenHeight1/1024.0, 27, 26)];
	else
		btn_closeWebView = [[UIButton alloc] initWithFrame:CGRectMake(300,5, 17, 16)];
	[btn_closeWebView setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
	[WebView addSubview:btn_closeWebView];
	[btn_closeWebView addTarget:self action:@selector(CloseBntClicked_WebView:) forControlEvents:UIControlEventTouchUpInside];
	[btn_closeWebView release];
	
	[WebView release];
}
-(void)AdvertiseBntClicked:(id)Sender
{
    [listOfPdfsDelete setHidden:YES];
    if (![arr_Advertise count]) 
    {
        return;
    }
	downloadingOverlayView.hidden = NO;
	int tag = [Sender tag]-250;
	Advertise_Class *Obj_AdvClass = [arr_Advertise objectAtIndex:tag]; 
	
	appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.videoVC.view setHidden:TRUE];
	
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
	//appDelegate.shopview.hidden=YES;
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
	[UIView commitAnimations];	
	//appDelegate.shopview.hidden=NO;
	
	UIWebView *WebView ;
	NSLog(@"the Adv btn Clicked %i",tag);
////	if(appDelegate.screenHeight1 == 1024) 
		WebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768*appDelegate.screenWidth1/768.0, 1024*appDelegate.screenHeight1/1024.0)];
/*	else
		WebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320,480)];
*/	WebView.clearsContextBeforeDrawing = YES;
	WebView.tag = 150;
	WebView.delegate = self;
	[WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:Obj_AdvClass.link]]];
	[WebView setScalesPageToFit:YES];
	WebView.opaque = NO;
	[self.view addSubview:WebView];
	
	//Create a Close btn To close the web View.......
	UIButton *btn_closeWebView;
	if(appDelegate.screenHeight1 == 1024)
		btn_closeWebView = [[UIButton alloc] initWithFrame:CGRectMake(720*appDelegate.screenWidth1/768.0,25*appDelegate.screenHeight1/1024.0, 27, 26)];
	else
		btn_closeWebView = [[UIButton alloc] initWithFrame:CGRectMake(290,5, 27, 26)];
	[btn_closeWebView setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
	[WebView addSubview:btn_closeWebView];
	[btn_closeWebView addTarget:self action:@selector(CloseBntClicked_WebView:) forControlEvents:UIControlEventTouchUpInside];
	[btn_closeWebView release];
	
	
	[WebView release];
	
}



//Showing laoder on webview while loading
- (void)webViewDidStartLoad:(UIWebView *)webView
{
	@try 
	{
		//Catch the web view 
		UIWebView *webView = (UIWebView *)[self.view viewWithTag:150];
		if(webView!=nil)
		{
			//Showing The Activity indicator.......  
			UIActivityIndicatorView *actInd_webView;
////			if(appDelegate.screenHeight1 == 1024)
				actInd_webView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(350*appDelegate.screenWidth1/768.0, 500*appDelegate.screenHeight1/1024.0, 35*appDelegate.screenWidth1/768.0, 35*appDelegate.screenHeight1/1024.0)];
/*			else
				actInd_webView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(146.12, 234.4, 15, 16.4)];
*/			actInd_webView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
			[actInd_webView startAnimating];
			[webView addSubview:actInd_webView];
			actInd_webView.tag = 151;
			[actInd_webView release];
		}
	}
	@catch (NSException * e) 
	{
		//Handle the execption	.......
	}
	@finally 
	{
		//
	}
	
}

//Removing loader on web view after loading
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	@try 
	{
		//Catch the web view 
		UIWebView *webView = (UIWebView *)[self.view viewWithTag:150];
		if(webView!=nil)
		{
			UIActivityIndicatorView *actInd_webView = (UIActivityIndicatorView *)[webView viewWithTag:151];
			if(actInd_webView!=nil)
			{
				[actInd_webView stopAnimating];
				[actInd_webView removeFromSuperview];
			}
		}
	}
	@catch (NSException * e) 
	{
		//Handle the execption	.......
	}
	@finally 
	{
		//
	}
	
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	
	@try 
	{
		//Catch the web view 
		UIWebView *webView = (UIWebView *)[self.view viewWithTag:150];
		if(webView!=nil)
		{
			UIActivityIndicatorView *actInd_webView = (UIActivityIndicatorView *)[webView viewWithTag:151];
			if(actInd_webView!=nil)
			{
				[actInd_webView stopAnimating];
				[actInd_webView removeFromSuperview];
			}
		}
	}
	@catch (NSException * e) 
	{
		//Handle the execption	.......
	}
	@finally 
	{
		//
	}
	//Failed to download.......
	//UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Internet Unavailable" message:@"You Must be connected to Internet to view this link" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//	[alert show];
//	[alert release];
	
	
}





-(void)CloseBntClicked_WebView:(id)sender
{
	downloadingOverlayView.hidden = TRUE;
	appDelegate.shopview.hidden=YES;
	@try 
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		//appDelegate.shopview.hidden=YES;
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
		[UIView commitAnimations];
		//appDelegate.shopview.hidden=NO;
		
		//Catch the web view 
		UIWebView *webView = (UIWebView *)[self.view viewWithTag:150];
		if(webView!=nil)
		{
			[webView removeFromSuperview];
		}
	}
	@catch (NSException * e) 
	{
		//Handle the execption	.......
	}
	@finally 
	{
		//
	}
	
}



-(void)loadImage:(UIImage*)img;
{
	if(bigBannerImgViw.image==nil&&img.size.height>50)
		bigBannerImgViw.image=img;
}


-(void)loadImage2:(UIImage*)img;
{
	
	if(smallBannerImgViw1.image==nil)
		
		smallBannerImgViw1.image=img;
	
	else if(smallBannerImgViw2.image==nil)
	{
		smallBannerImgViw2.image=img;
	}
	else if(smallBannerImgViw3.image==nil)
	{
		smallBannerImgViw3.image=img;
	}
	

	
	
	
	
	
}


#pragma mark -
#pragma mark Button Actions


-(void)selBookAction:(id)sender
{
    [listOfPdfsDelete setHidden:YES];
	downloadingOverlayView.hidden=FALSE;
	NSLog(@"selBookAction storeView Controller");
		
	selectedBookIndex=[sender index];
	selViewButtonIndex=[sender tag];
	int tag = [sender tag]-850;
	BookIndex = tag;
	//[self bookContent:BookIndex];
	
	BookDetails *book = [sortedArray objectAtIndex:BookIndex];
	NSString *Str_FileName = [NSString stringWithFormat:@"%@.pdf",book.Name];
	if([appDelegate checkFileExist:Str_FileName])
		book.IsDownloading_Or_Downloaded = YES;
	//[Str_FileName release];
	
	for(UIView *subview in selBookView.subviews)
	{
		[subview removeFromSuperview];
	}
	
	//[selBookView removeFromSuperview];
	
	[self.view addSubview:selBookView];
	selBookView.hidden = NO;
	if(sortedArray == nil)
		[sortedArray retain];
	
	[self performSelector:@selector(pathContent)];
	
}


-(void)pathContent
{
	NSString * descriptionUrl = [NSString stringWithFormat:@"%@/api/read?action=detailbook&authKey=%@&bookId=%d",serverIP,appDelegate.loginAuthKey,selectedBookIndex];
	[self createDiscriptionView:descriptionUrl];	
	NSLog(@"fdghgfhgfhfgdgghkm");
	NSLog(@"jfhdfhgvtry");
	//[descriptionUrl release];
}
	

-(void)bookContent:(NSInteger)indexno
{
	BookDetails *book = [sortedArray objectAtIndex:BookIndex];
	NSString *Str_FileName = [NSString stringWithFormat:@"%@.pdf",book.Name];
	if([appDelegate checkFileExist:Str_FileName])
		book.IsDownloading_Or_Downloaded = YES;
	//[Str_FileName release];
	
	for(UIView *subview in selBookView.subviews)
	{
		[subview removeFromSuperview];
	}
	
	//[selBookView removeFromSuperview];
	
	[self.view addSubview:selBookView];
	selBookView.hidden = NO;
	if(sortedArray == nil)
		[sortedArray retain];
	
	NSString * descriptionUrl = [NSString stringWithFormat:@"%@/api/read?action=detailbook&authKey=%@&bookId=%d",serverIP,appDelegate.loginAuthKey,selectedBookIndex];
	[self createDiscriptionView:descriptionUrl];	
	NSLog(@"fdghgfhgfhfgdgghkm");
	NSLog(@"jfhdfhgvtry");
	//[descriptionUrl release];
}



-(void)Downloading:(id)sender  //readimg downloadimg
{
    [listOfPdfsDelete setHidden:YES];
	int tag=0;
	btn = (UIButton *)sender;
	//nikhil added this on 6th july 2011
	if(![btn.currentTitle isEqualToString:@"READ"])
	if(IsDownload)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Another file is downloading. Please wait...." delegate:self  cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
		[alert show];
		//alert.tag = 200;
		[alert release];
		return;
		
	}
	//end of nikhil added this on 6th july 2011
	
	//if([btn.currentTitle isEqualToString:@"Download"] || [btn.currentTitle isEqualToString:@"Read"] )
	if(([btn.currentTitle isEqualToString:@"READ"]) || ([btn.currentTitle isEqualToString:@"BUY NOW"]))
	{
		
		BookIndex = [sender tag]-800;
		tag = BookIndex;
		BookDetails *book = (BookDetails *)[sortedArray  objectAtIndex:tag];
		
		if ([btn.currentTitle isEqualToString:@"BUY NOW"])
		{
			downloadingOverlayView.hidden=FALSE;
			Purchasebook=book;
			[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
			BookDetails *book = (BookDetails *)[sortedArray  objectAtIndex:tag];
			selectedBookIndex = [book.IDValue intValue];
			//NSInteger bookid = selectedBookIndex;
			//NSString *bkname = @"DashboardComic0";
			//NSString *bookname = bookdetailsObj.Name;
			//bookName = [bkname stringByAppendingFormat:@"%d",bookid];
			bookName = book.ItunesProductID;
			NSLog(@"downloading books in process product id==>%@",bookName);
			kInAppPurchaseProUpgradeProductId =bookName;
			
			NSLog(@"before transaction success");
			[self requestProUpgradeProductData];
			NSLog(@"transaction success");
		}
		else {
			downloadingOverlayView.hidden=TRUE;
			//ClassicalScrollViewController *classicalScrollViewController = [[ClassicalScrollViewController alloc] init] ; //]WithNibName:@"ClassicalScrollViewController" bundle:nil];
//			classicalScrollViewController.ABook = book;
//			classicalScrollViewController.StrFilename = book.Name;
//			classicalScrollViewController.string_bookId =  [[NSString alloc] initWithFormat:@"%@",book.ISBNNumber];
//			classicalScrollViewController.string_bookCount = [[NSString alloc] initWithFormat:@"%d",78];
//			[self presentModalViewController:classicalScrollViewController animated:FALSE];
//			[classicalScrollViewController release];
			
			//NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@__%@/%@",book.Name,book.IDValue,book.Name]];
			NSString *pdfPath = [NSString stringWithFormat:@"%@.pdf",dataFilePath];
			//[dataFilePath release];
			
			NSLog(@"the file path is %@",pdfPath);
			
			[self OpenPDFReader:pdfPath:book.Name];
			
		}

	}
	else if([btn.currentTitle isEqualToString:@"Download Now"])
	{
		tag = BookIndex;

//		BookIndex = [sender tag]-800;
		tag = BookIndex;
		BookDetails *book = (BookDetails *)[sortedArray  objectAtIndex:tag];
		//NSLog(@"the book name %@ \n %@",book.Name,book.MagazinePDFFilePath);
		if(appDelegate.Arr_DownloadingBooks==nil)
		{
			appDelegate.Arr_DownloadingBooks = [[NSMutableArray alloc] init];
		}
		//		[appDelegate.Arr_DownloadingBooks addObject:book.Name];
		[appDelegate.Arr_DownloadingBooks addObject:[NSString stringWithFormat:@"%d",BookIndex]];
		
		book.IsDownloading_Or_Downloaded = YES;
		//[self DownloadTocFielFor:1];
		if ([appDelegate isDataSourceAvailable])
		[self StartLoader:BookIndex];
		if(ISFirstTimeDownloading)
		{
			ISFirstTimeDownloading = NO;
			CurrentIndex = BookIndex;
			[self DownloadThisBook:book];
		}	
		
//		downloadingOverlayView.hidden=FALSE;
//		Purchasebook=book;
//		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//		BookDetails *book = (BookDetails *)[sortedArray  objectAtIndex:tag];
//		selectedBookIndex = [book.IDValue intValue];
//		NSInteger bookid = selectedBookIndex;
//		NSString *bkname = @"DashboardComic0";
//		bookName = book.ItunesProductID;
//		kInAppPurchaseProUpgradeProductId =bookName;
//		[self requestProUpgradeProductData];
		 
		
	}
	else if([btn.currentTitle isEqualToString:@"DOWNLOAD"])
	{
		BookIndex = [sender tag]-800;
		tag = BookIndex;
		BookDetails *book = (BookDetails *)[sortedArray  objectAtIndex:tag];
		//NSLog(@"the book name %@ \n %@",book.Name,book.MagazinePDFFilePath);
		if(appDelegate.Arr_DownloadingBooks==nil)
		{
			appDelegate.Arr_DownloadingBooks = [[NSMutableArray alloc] init];
		}
//		[appDelegate.Arr_DownloadingBooks addObject:book.Name];
		[appDelegate.Arr_DownloadingBooks addObject:[NSString stringWithFormat:@"%d",BookIndex]];
	
		book.IsDownloading_Or_Downloaded = YES;
		//[self DownloadTocFielFor:1];
		if ([appDelegate isDataSourceAvailable])
		[self StartLoader:BookIndex];
		if(ISFirstTimeDownloading)
		{
			ISFirstTimeDownloading = NO;
			CurrentIndex = BookIndex;
			[self DownloadThisBook:book];
		}	
		
	}
	
}


- (void)provideContent:(NSString *)productId
{
    //check the productId and unlock content
	
	appDelegate.productIdName = productId;
	
	if([appDelegate.productIdName isEqualToString:kInAppPurchaseProUpgradeProductId])
	{
		
		[downloadingOverlayView setHidden:TRUE];
		
		NSLog(@"the book name %@ \n %@",Purchasebook.Name,Purchasebook.MagazinePDFFilePath);
		if(appDelegate.Arr_DownloadingBooks==nil)
		{
			appDelegate.Arr_DownloadingBooks = [[NSMutableArray alloc] init];
		}

		
		[appDelegate.Arr_DownloadingBooks addObject:[NSString stringWithFormat:@"%d",BookIndex]];
		
		Purchasebook.IsDownloading_Or_Downloaded = YES;
		//[self DownloadTocFielFor:1];
		if ([appDelegate isDataSourceAvailable])
		[self StartLoader:BookIndex];
		if(ISFirstTimeDownloading)
		{
			ISFirstTimeDownloading = NO;
			CurrentIndex = BookIndex;
			[self DownloadThisBook:Purchasebook];
		}
		
	}
	
	
	
	
    
}






//FROM HERE EVERYTHING TILL THE line before @end has to be copied and pasted on the clas that u are using for in app purchase





- (void)requestProUpgradeProductData
{	
	productIdentifiers = [NSSet setWithObject:kInAppPurchaseProUpgradeProductId ];
	appDelegate.storeproductidentifier = productIdentifiers;
	if(appDelegate.storeproductidentifier == productIdentifiers)
	{
		productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
		productsRequest.delegate = self;
		[productsRequest start];
	}
   
	
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
   // NSArray *products = response.products;
	appDelegate.productArray = response.products;
	if(appDelegate.productArray == response.products)
    {
		proUpgradeProduct = [appDelegate.productArray count] == 1 ? [[appDelegate.productArray objectAtIndex:0] retain] : nil;
		if (proUpgradeProduct)
		{
			NSLog(@"Product title: %@" , proUpgradeProduct.localizedTitle);
			NSLog(@"Product description: %@" , proUpgradeProduct.localizedDescription);
			NSLog(@"Product price: %@" , proUpgradeProduct.price);
			NSLog(@"Product id: %@" , proUpgradeProduct.productIdentifier);
			
			
			if([self canMakePurchases])
				[self purchaseProUpgrade];
			else
				[downloadingOverlayView setHidden:TRUE];
		}
		
		for (NSString *invalidProductId in response.invalidProductIdentifiers)
		{
			NSLog(@"Invalid product id: %@" , invalidProductId);
			[downloadingOverlayView setHidden:TRUE];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"invalid product id ! : %@",invalidProductId] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
			[alert show]; 
			[alert release];
			
		}
		
		// finally release the reqest we alloc/init’ed in requestProUpgradeProductData
		//[productsRequest release];
		if(appDelegate.storeproductidentifier == productIdentifiers)
		{
			[productsRequest release];
		}
	}
    
    
	//[[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}


- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
	if (![appDelegate isDataSourceAvailable])
	{
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:@"Network Connection Error" 
							  message:@"You need to be connected to the internet to use this feature." 
							  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		alert.delegate=self;
		[alert show];
		[alert release];
	}
	else {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"ERROR :1 %@" , [error description] ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		[alert show]; 
		[alert release];
	}
	
}


- (void)requestDidFinish:(SKRequest *)request
{
	
	
}


#pragma -
#pragma Public methods

//
// call this method once on startup
//
- (void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestProUpgradeProductData];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//
- (void)purchaseProUpgrade
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:kInAppPurchaseProUpgradeProductId];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseProUpgradeProductId])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}




//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
   // NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
    }
    else
    {
        // send out a notification for the failed transaction
		// [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
		
//		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"transaction failed : %@",transaction.payment.productIdentifier ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		[alert show]; 
		[alert release];
    }
	[downloadingOverlayView setHidden:TRUE];
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
	[downloadingOverlayView setHidden:TRUE];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
	[downloadingOverlayView setHidden:TRUE];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
		
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
		
    }
	[downloadingOverlayView setHidden:TRUE];
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
		
		//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"transaction state: %d",transaction.transactionState ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		//[alert show]; 
		//[alert release];
		
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

// Sent when transactions are removed from the queue (via finishTransaction:).
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
	
}

// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
	
}

// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue 
{
	
}
//////




-(void)DownloadThisBook:(BookDetails*)book
{
	if (![appDelegate isDataSourceAvailable])
	{
		ISFirstTimeDownloading=YES;
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:@"Network Connection Error" 
							  message:@"You need to be connected to the internet to use this feature." 
							  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		alert.delegate=self;
		[alert show];
		[alert release];
	}
	else {
		if(!IsDownload)
		{
			IsDownload = YES;
			//BookIndex = tag;
			book.IsDownloading_Or_Downloaded = YES;
			NSString *StrBookUrl = [NSString stringWithFormat:@"%@",book.MagazinePDFFilePath];
			StrBookUrl=[StrBookUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			NSURL * bookURL = [[NSURL alloc]initWithString:StrBookUrl];//bookdetailsObj.MagazinePDFFilePath];
			NSLog(@"karpaga==>###### bookurl %@",bookURL);
			NSURLRequest *theRequest = [NSURLRequest requestWithURL:bookURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:180.0];
            if (receivedData) {
                [receivedData release];
                receivedData=nil;
            }
			receivedData = [[NSMutableData alloc] initWithLength:0];
			
			
				downloadBookConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self startImmediately:YES];
            
				if (downloadBookConnection) {
					UIApplication *app = [UIApplication sharedApplication];
					
					bgTask = [app beginBackgroundTaskWithExpirationHandler:^{ 
						[app endBackgroundTask:bgTask]; 
						bgTask = UIBackgroundTaskInvalid;
					}];
				}

//				[StrBookUrl release];
				[bookURL release];
			
		}
		else 
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Another file is downloading. Please wait...." delegate:self  cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
			[alert show];
			alert.tag = 200;
			[alert release];
		}
	}

	
	
}
-(NSString *)getSize:(double)contentLength
{
	if (contentLength >= 1073741824)
	{
		contentLength = contentLength / 1073741824;
		return [NSString stringWithFormat:@"%.2f GB",contentLength];
	}
	else if (contentLength >= 1048576)
	{
		contentLength = contentLength / 1048576;
		
		return [NSString stringWithFormat:@"%.2f MB",contentLength];
	}
	else if (contentLength >= 1024)
	{
		contentLength = contentLength / 1024;
		return [NSString stringWithFormat:@"%.2f KB",contentLength];
	}
	else if (contentLength > 1)
	{
		return [NSString stringWithFormat:@"%.2f Bytes",contentLength];
	}
	
	else
	{
		return [NSString stringWithFormat:@"%.2f Byte",contentLength];
	}
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
	
	
	NSLog(@"PDF download respose==>%@",response);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [receivedData setLength:0];
	filesize = [[NSNumber numberWithLong: [response expectedContentLength]] floatValue];
	self.totalSize=[self getSize:[response expectedContentLength]];
	[self closeAction:nil];
	NSLog(@"Received the Respons %@ the file isze is %f",response,filesize );
	
	
	UIView *vi = (UIView *)[scrollview viewWithTag:900+CurrentIndex];
	if(vi!=nil )
	{
		for(UIView *vie in vi.subviews)
		{
			if(vie.tag == 1000+CurrentIndex)
			{
				ProgView_Download1 = (UIProgressView *)vie;
				
			}
			if(vie.tag == -1000+CurrentIndex)
			{
				progress_Label =(UILabel *) vie;
				progress_Label.text=[NSString stringWithFormat:@"0 of %@",self.totalSize];
			}
		}
	}
	
	
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
	downloadedLength=+downloadedLength+[data1 length];
	downloadedSize=[self getSize:downloadedLength];
	
    float progress =   downloadedLength/filesize;
	
	
	
	//NSLog(@"Getting The Data %i and rec %i pro %f" ,data1,receivedData,progress);
	if(ProgView_Download1!=nil)
		ProgView_Download1.progress = progress;
	if(progress_Label!=nil)
		progress_Label.text=[NSString stringWithFormat:@"%@ of %@",downloadedSize,self.totalSize];
	if (!file) {
        //NSLog(@"filesize==>%f",filesize);
		BookDetails *book = (BookDetails *)[sortedArray  objectAtIndex:CurrentIndex];
		//NSString *strFileName = [[NSString alloc] initWithFormat:@"%@__%@/%@.pdf",bookdetailsObj.Name,bookdetailsObj.IDValue,bookdetailsObj.Name];
		NSString * filename = [NSString stringWithFormat:@"/%@__%@",book.Name,book.IDValue];
		NSLog(@"the file name is %@",filename);
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:filename ] retain];
		[[ NSFileManager defaultManager] createDirectoryAtPath:dataFilePath attributes:nil];
		[[ NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/temp",dataFilePath] attributes:nil];
		[[ NSFileManager defaultManager] createFileAtPath:[NSString stringWithFormat:@"%@/temp/%@.pdf",dataFilePath,book.Name] contents: nil attributes: nil];
		file =[[NSFileHandle fileHandleForUpdatingAtPath:[NSString stringWithFormat:@"%@/temp/%@.pdf",dataFilePath,book.Name]] retain];
		self.downloadingFileName=[NSString stringWithFormat:@"%@/%@.pdf",dataFilePath,book.Name];
	}
		if (file) {
			[file seekToEndOfFile];
			[file writeData:data1];
		}
    [progress_Label setTextColor:[UIColor blackColor]];
			//[file closeFile];
    if (appDelegate.screenWidth1==768) 
    {
       // progress_Label.font=[UIFont systemFontOfSize:13];
    }
    else
    {
        progress_Label.font=[UIFont systemFontOfSize:6];
        progress_Label.numberOfLines=2;
    }
    
            
	
	
   /* [receivedData appendData:data];
	downloadedSize=[self getSize:[receivedData length]];
	NSNumber* curLength = [NSNumber numberWithLong:[receivedData length] ];
	
	float cl = [curLength floatValue];
    float progress =   cl/filesize;
	
	NSLog(@"Getting The Data %i and rec %i pro %f" ,data,receivedData,progress);
	if(ProgView_Download1!=nil)
		ProgView_Download1.progress = progress;
	if(progress_Label!=nil)
		progress_Label.text=[NSString stringWithFormat:@"%@ of %@",downloadedSize,self.totalSize];
	data=nil;*/
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	self.downloadingFileName=nil;
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
   // [connection release];
	IsDownload = NO;
	
	BookDetails *book = [sortedArray objectAtIndex:CurrentIndex];
	book.IsDownloading_Or_Downloaded = NO;
	
	
	downloading_Progress = FALSE;
//	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Download Book" message:@"You must be connected to Internet to download this book" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Download Book" message:[error description] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
	NSString *errorIdentifier = [NSString stringWithFormat:@"(%@)[%d]",error.domain,error.code];
	if (downloadBookConnection) {
        [downloadBookConnection release];
        downloadBookConnection=nil;
    }

	NSLog(@"The Connection Fail %@",errorIdentifier);
}

- (NSCachedURLResponse *) connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    NSLog(@"the cache the responsse %@",cachedResponse);
	return nil;
	
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection 
{
	downloadedLength=0.0;
	self.downloadingFileName=nil;
	[file closeFile];
	file=nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //[connection release];
	NSLog(@"the Downloading Over");
	IsDownload = NO;
	
	downloading_Progress = FALSE;
	[self StopLoader:nil];
	if (filesize>1024.0)
	{
		BookDetails *book = [sortedArray objectAtIndex:CurrentIndex];
		UILocalNotification *localNot = [[UILocalNotification alloc] init];
		localNot.alertBody = [NSString stringWithFormat:@"Download complete %@",book.Name];
		//localNot.alertAction = @"Name on the button";
		localNot.timeZone=[NSTimeZone defaultTimeZone];
		localNot.fireDate = [NSDate date];
		NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Download Book", @"Download", nil];
		localNot.userInfo = infoDict;
		localNot.soundName = UILocalNotificationDefaultSoundName;
		[[UIApplication sharedApplication] scheduleLocalNotification:localNot];
		
		
		NSString * filename = [NSString stringWithFormat:@"/%@__%@",book.Name,book.IDValue];
		NSLog(@"the file name is %@",filename);
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:filename ] ;
		NSError *error;
	//	BOOL success = [[NSFileManager defaultManager] moveFileAtPath:[NSString stringWithFormat:@"%@/temp/%@.pdf",dataFilePath,book.Name] toPath:[NSString stringWithFormat:@"%@/%@.pdf",dataFilePath,book.Name] error:&error];
		//BOOL success = [[NSFileManager defaultManager] copyItemAtPath:[NSString stringWithFormat:@"%@/temp/%@.pdf",dataFilePath,book.Name] toPath:[NSString stringWithFormat:@"%@/%@.pdf",dataFilePath,book.Name] error:&error];	
		[[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/temp/%@.pdf",dataFilePath,book.Name] error:&error];
        if ([[self getPDFS] count]>0) {
            [objc_getAssociatedObject(self.view, @"deleteB") setHidden:NO];
        }
        
		//[self movieReceived];
	}
	else {
		UIView *vi = (UIView *)[scrollview viewWithTag:900+CurrentIndex];
		NSLog(@"to contview = %i",900+CurrentIndex);
		if(vi!=nil)
		{
			UIButton *btn = (UIButton *)[vi viewWithTag:800+CurrentIndex];
			if(btn!=nil)
			{
				btn.hidden = NO;
				//[btn setTitle:@"Read" forState:UIControlStateNormal];
				
				if([book.Purchased intValue] == 1)
				{
					//[btn setBackgroundImage:[UIImage imageNamed:@"Buy-Now1.png"] forState:UIControlStateNormal];
                    [btn setTitle:@"BUY NOW" forState:UIControlStateNormal];
					
				}
				else
				{
					//[btn setBackgroundImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
                    [btn setTitle:@"DOWNLOAD" forState:UIControlStateNormal];
				}
			}		
		}
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Download Book" message:@"Book path URL was not found" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
	}
    if (downloadBookConnection) {
        [downloadBookConnection release];
        downloadBookConnection=nil;
    }
    
}



-(void)StartLoader:(NSInteger)Index
{
	//Get the Corresponding Content View to place Progress bar
	UIView *vi = (UIView *)[scrollview viewWithTag:900+Index];
   // vi.backgroundColor=[UIColor redColor];
	if(vi!=nil)
	{
		//Add the Progress bar  
		UIProgressView *ProgView_Download = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
////		if(appDelegate.screenHeight1 == 1024)
			ProgView_Download.frame = CGRectMake(120*appDelegate.screenWidth1/768.0, 115*appDelegate.screenHeight1/1024.0, 100*appDelegate.screenWidth1/768.0, 20*appDelegate.screenHeight1/1024.0);
/*		else
			ProgView_Download.frame = CGRectMake(46,46,50,9.4);		ProgView_Download.progress = 0;
*/		ProgView_Download.tag = 1000+Index;
		[vi addSubview:ProgView_Download];
		[ProgView_Download release];
		
		UILabel *progressLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(ProgView_Download.frame)+1,CGRectGetMinY(ProgView_Download.frame)-5 , 160, 20)];
		progressLabel.tag = -1000+Index;
		progressLabel.backgroundColor=[UIColor clearColor];
		progressLabel.textColor=[UIColor whiteColor];
		progressLabel.font=[UIFont systemFontOfSize:14];
		[vi addSubview:progressLabel];
		[progressLabel release];
		
		NSLog(@"the Progress bar tag value is %i",1000+Index);
		//Hide the button when downloading
		UIButton *btn = (UIButton *)[vi viewWithTag:800+Index];
		if(btn!=nil)
		{
			btn.hidden = YES;
			
		}
		
	}
	
	
	
}
//-(void)StopLoader:(id)sender
//{
//	if (receivedData!=nil) 
//	{
//		BookDetails *book = (BookDetails *)[sortedArray  objectAtIndex:CurrentIndex];
//		NSString * filename = [[NSString alloc] initWithFormat:@"/%@__%@",book.Name,book.IDValue];
//		NSLog(@"the file name is %@",filename);
//		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//		NSString *documentsDirectory = [paths objectAtIndex:0];
//		NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:filename] retain];
//		[[ NSFileManager defaultManager] createDirectoryAtPath:dataFilePath attributes:nil];
//		[receivedData writeToFile:dataFilePath atomically:YES];
//		[[Shelf sharedShelf] createBookFromCatalogEntry:receivedData Name:[NSString stringWithFormat:@"%@/%@.pdf",filename, book.Name]];
//		NSLog(@"Download competed %@/%@",dataFilePath,book.Name);
//		
//		[dataFilePath release];
//		[receivedData release];
//		receivedData=nil;
//		
//		[filename release];
//		
//		//write a code for Read Toc
//		[self DownloadTocFielFor:CurrentIndex];
//
//	}
//		UIView *vi = (UIView *)[scrollview viewWithTag:900+CurrentIndex];
//		NSLog(@"to contview = %i",900+CurrentIndex);
//		if(vi!=nil)
//		{
//			UIButton *btn = (UIButton *)[vi viewWithTag:800+CurrentIndex];
//			if(btn!=nil)
//			{
//				btn.hidden = NO;
//				//[btn setTitle:@"Read" forState:UIControlStateNormal];
//				[btn setBackgroundImage:[UIImage imageNamed:@"read.png"] forState:UIControlStateNormal];
//				
//			}
//			UIProgressView *ProgView = (UIProgressView *)[vi viewWithTag:1000+CurrentIndex];
//			if(ProgView!=nil)
//			{
//				[ProgView removeFromSuperview];
//			}
//			UIProgressView *ProgView1 = (UIProgressView *)[selBookView viewWithTag:1000+CurrentIndex];
//			if(ProgView1!=nil)
//			{
//				[ProgView1 removeFromSuperview];
//			}
//			
//		}
//		
//	int DownCount = [appDelegate.Arr_DownloadingBooks count];
//	int BooksCount = [sortedArray count];
//	BOOL IsStartDownload = NO;
//	int Index;
//	
//	BOOL IsReceived = NO;
//	if(CurrentIndex!=1000)
//	{
//		BookDetails *currentBook = [sortedArray objectAtIndex:CurrentIndex];
//		for(int j=0;j<DownCount;j++)
//		{
//			NSString *BookName = [appDelegate.Arr_DownloadingBooks objectAtIndex:j];
//			if(![currentBook.Name isEqualToString:BookName])
//			{
//				for(int k=0;k<BooksCount;k++)
//				{
//					BookDetails *book = [sortedArray objectAtIndex:k];
//					if([BookName isEqualToString:book.Name] ) 
//					{
//						Index = k;
//						BookDetails *book = [sortedArray objectAtIndex:j];
//						IsStartDownload = YES;
//						[self performSelector:@selector(DownloadThisBook:) withObject:book afterDelay:0.5];
//						IsReceived = YES;
//						break;
//					}
//				}
//			}
//			if(IsReceived)
//			{
//			break;
//			}
//		
//		}
//	}
//	else 
//	{
//		if([appDelegate.Arr_DownloadingBooks count]>0)
//		{
//			
//			for(int j=0;j<DownCount;j++)
//			{
//				NSString *BookName = [appDelegate.Arr_DownloadingBooks objectAtIndex:j];
//				for(int k=0;k<BooksCount;k++)
//				{
//					BookDetails *book = [sortedArray objectAtIndex:k];
//					if([BookName isEqualToString:book.Name] ) 
//					{
//						CurrentIndex = k;
//						BookDetails *currentBook = [sortedArray objectAtIndex:CurrentIndex];
//						[self performSelector:@selector(DownloadThisBook:) withObject:currentBook afterDelay:0.5];
//						
//					}
//				}
//			}
//		}
//	}
//	for (int j=0; j<DownCount; j++) 
//	{
//		NSString *BookName = [appDelegate.Arr_DownloadingBooks objectAtIndex:j];
//		BookDetails *book = [sortedArray objectAtIndex:CurrentIndex];
//		if([BookName isEqualToString:book.Name])
//		{
//			[appDelegate.Arr_DownloadingBooks removeObject:BookName];
//			break;
//		}
//	}
//	DownCount = [appDelegate.Arr_DownloadingBooks count];
//	if(DownCount ==0)
//	{
//		ISFirstTimeDownloading = YES;
//	}
//	if(IsStartDownload)
//	{
//		CurrentIndex = Index;
//	}
//}
//

-(void)StopLoader:(id)sender
{
	/*if (receivedData!=nil) 
	{
		BookDetails *book = (BookDetails *)[sortedArray  objectAtIndex:CurrentIndex];
		NSString * filename = [[NSString alloc] initWithFormat:@"/%@__%@",book.Name,book.IDValue];
		NSLog(@"the file name is %@",filename);
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:filename] retain];
		[[ NSFileManager defaultManager] createDirectoryAtPath:dataFilePath attributes:nil];
		//[receivedData writeToFile:dataFilePath atomically:YES];
		//[[Shelf sharedShelf] createBookFromCatalogEntry:receivedData Name:[NSString stringWithFormat:@"%@/%@.pdf",filename, book.Name]];
		
		NSLog(@"Download competed %@/%@",dataFilePath,book.Name);
		
		[dataFilePath release];
		[receivedData release];
		receivedData=nil;
		
		[filename release];
		
		//write a code for Read Toc
		//[self DownloadTocFielFor:CurrentIndex];
		
	}*/
	UIView *vi = (UIView *)[scrollview viewWithTag:900+CurrentIndex];
	NSLog(@"to contview = %i",900+CurrentIndex);
	if(vi!=nil)
	{
		UIButton *btn = (UIButton *)[vi viewWithTag:800+CurrentIndex];
		if(btn!=nil)
		{
			btn.hidden = NO;
			[btn setTitle:@"READ" forState:UIControlStateNormal];
			//[btn setBackgroundImage:[UIImage imageNamed:@"read.png"] forState:UIControlStateNormal];
			
		}
		UIProgressView *ProgView = (UIProgressView *)[vi viewWithTag:1000+CurrentIndex];
		if(ProgView!=nil)
		{
			[ProgView removeFromSuperview];
		}
		UIProgressView *ProgView1 = (UIProgressView *)[selBookView viewWithTag:1000+CurrentIndex];
		if(ProgView1!=nil)
		{
			[ProgView1 removeFromSuperview];
		}
		UILabel *progressLabel = (UILabel *)[vi viewWithTag:-1000+CurrentIndex];
		if(progressLabel!=nil)
		{
			[progressLabel removeFromSuperview];
		}
		UILabel *progressLabel1 = (UILabel *)[selBookView viewWithTag:-1000+CurrentIndex];
		if(progressLabel1!=nil)
		{
			[progressLabel1 removeFromSuperview];
		}
		
	}
	
	int DownCount = [appDelegate.Arr_DownloadingBooks count];
	//int BooksCount = [sortedArray count];
	BOOL IsStartDownload = NO;
	int Index;
	
	BOOL IsReceived = NO;
	if(CurrentIndex!=1000)
	{
		//Multiple Book Issue
		//BookDetails *currentBook = [sortedArray objectAtIndex:CurrentIndex];
		//BookDetails *currentBook = [sortedArray objectAtIndex:CurrentIndex];
		for(int j=0;j<DownCount;j++)
		{
			int bIdx = [[appDelegate.Arr_DownloadingBooks objectAtIndex:j] intValue];
			if(CurrentIndex!=bIdx)
			{
				NSLog(@"Download...1");
				Index=bIdx;
				BookDetails *book = [sortedArray objectAtIndex:bIdx];
				IsStartDownload = YES;
				[self performSelector:@selector(DownloadThisBook:) withObject:book afterDelay:0.5];
				IsReceived = YES;
				break;
			}
			if(IsReceived)
			{
				break;
			}
			
		}
	}
	else 
	{
		if([appDelegate.Arr_DownloadingBooks count]>0)
		{
			for(int j=0;j<DownCount;j++)
			{
				NSLog(@"Download...2");
				int bIdx1 = [[appDelegate.Arr_DownloadingBooks objectAtIndex:j] intValue];
				CurrentIndex = bIdx1;
				Index=bIdx1;
				BookDetails *currentBook = [sortedArray objectAtIndex:CurrentIndex];
				[self performSelector:@selector(DownloadThisBook:) withObject:currentBook afterDelay:0.5];
				break;
			}
		}
	}
	for (int j=0; j<DownCount; j++) 
	{
		int bIdx2 = [[appDelegate.Arr_DownloadingBooks objectAtIndex:j] intValue];
		if(CurrentIndex==bIdx2)
		{
			[appDelegate.Arr_DownloadingBooks removeObject:[NSString stringWithFormat:@"%d",bIdx2]];
			// Save data if appropriate....................................
			NSUserDefaults *DownloadingDetails = [NSUserDefaults standardUserDefaults];
			NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appDelegate.Arr_DownloadingBooks];
			[DownloadingDetails setObject:data forKey:@"DownloadingBooks"];			
			break;
		}
	}
	DownCount = [appDelegate.Arr_DownloadingBooks count];
	if(DownCount ==0)
	{
		ISFirstTimeDownloading = YES;
	}
	if(IsStartDownload)
	{
		CurrentIndex = Index;
	}
}


-(void)DownloadTocFielFor:(NSInteger)Index
{
	//http://122.183.249.154/wizardworld/api/read?action=pagecontent&authKey=%28null%29&bookId=18
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	BookDetails *book = (BookDetails *)[sortedArray  objectAtIndex:CurrentIndex];
	NSString * filename = [NSString stringWithFormat:@"Toc_%@.xml", book.IDValue];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:filename];
	
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataFilePath];
	if(fileExists)
	{
		//Do Nothing if Exist
	}
	else 
	{
		NSString *allBooksUrl = [NSString stringWithFormat:@"%@/api/read?action=pagecontent&authKey=&bookId=%@",serverIP, book.IDValue];
		NSURL *url = [[NSURL alloc] initWithString:allBooksUrl];
		NSData *data = [[NSData alloc] initWithContentsOfURL:url];
		if(data!=nil)
		{
			//Save Corrresponding folder 
			NSLog(@"the Path to store toc is %@",[DOCUMENTS_FOLDER stringByAppendingPathComponent:filename]);
			[data writeToFile:[DOCUMENTS_FOLDER stringByAppendingPathComponent:filename] atomically:YES];
		}
		[data release];
		[url release];
		//[allBooksUrl release];
	}
	//[filename release];
	//[dataFilePath release];
		
	[pool drain];
}
			 
-(void)DownloadBanners:(id)sender
{
NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	
	//write a code for download the toc file 
	NSString *Str_Url = [NSString stringWithFormat:@"%@/api/read?action=banner&authKey=%28null%29",serverIP];
	NSLog(@"Str_Url %@",Str_Url);
	NSURL *url = [[NSURL alloc] initWithString:Str_Url];//bookdetailsObj.CatalogImage];
	//[Str_Url release];
	//NSString *allBooksUrl = [[NSBundle mainBundle] pathForResource:@"Banners" ofType:@"xml"];
	//NSURL *url = [NSURL fileURLWithPath:allBooksUrl];
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	BannersParser *obj_Banners = [[BannersParser alloc]initXMLParser];
	[xmlParser setDelegate:obj_Banners];
	BOOL success = [xmlParser parse];
	[xmlParser release];
	xmlParser=nil;
	if(success)
	{
		//write a code when succed
		//arr_Banners = [[NSArray alloc] initWithArray:obj_Banners.Arr_Banners]; 
        arr_Banners = obj_Banners.Arr_Banners;
	}
	else 
	{
		//parsing failed
	}
	[url release];
	[xmlParser release];
	[obj_Banners release];
	
[pool drain];

}

-(void)DownloadAdvertise:(id)sender
{
	//write a code for download the toc file 
NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *Str_Url = [NSString stringWithFormat:@"%@/api/read?action=advertisement&authKey=%28null%29",serverIP];
	NSURL *url = [[NSURL alloc] initWithString:Str_Url];
	//[Str_Url release];
	//NSString *allBooksUrl = [[NSBundle mainBundle] pathForResource:@"Addvertisement" ofType:@"xml"];
	//NSURL *url = [NSURL fileURLWithPath:allBooksUrl];
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	AdvertiseParser *Obj_Advertis = [[AdvertiseParser alloc]initXMLParser];
	[xmlParser setDelegate:Obj_Advertis];
	BOOL success = [xmlParser parse];
	[xmlParser release];
	xmlParser=nil;
	if(success)
	{
		//write a code when succed
		//arr_Advertise = [[NSArray alloc] initWithArray:Obj_Advertis.Arr_Advertise]; 
        arr_Advertise=Obj_Advertis.Arr_Advertise;
	}
	else 
	{
		//parsing failed
	}
	
	[url release];
	[xmlParser release];
	[Obj_Advertis release];
	
[pool drain];
	
}


//*************  stop this function when execute the loading ok..........**************//

//*************  stop this function when execute the loading ok..........**************//
-(void)createDiscriptionView :(NSString *)descriptionXmlUrl
{
	[downloadingOverlayView setHidden:FALSE];
	OneBookDetails *oneBookDet = [self loadBookDescription:descriptionXmlUrl];
	if (oneBookDet ==nil) 
	{
		selBookView.hidden = TRUE;
		return;
	}
			
		selectedbookISBNnumber = oneBookDet.ISBNNumber;
		//**************      if i commented this what will happen     *************//  
		[self buyAction:nil];
		
	UILabel *bookTitleLabel;
////	if(appDelegate.screenHeight1 == 1024)
	{
		bookTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 560*appDelegate.screenWidth1/768.0, 35*appDelegate.screenHeight1/1024.0)];
		
	}
/*	else
		bookTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 152,32)];
*/	bookTitleLabel.text = oneBookDet.Name;
		bookTitleLabel.font = [UIFont systemFontOfSize:25];
		bookTitleLabel.textAlignment = UITextAlignmentCenter;
		bookTitleLabel.backgroundColor = [UIColor clearColor];
		bookTitleLabel.textColor = [UIColor whiteColor];
		[selBookView addSubview:bookTitleLabel];
		[bookTitleLabel release];
		
	UIButton *closeBtn;
////	if(appDelegate.screenHeight1 == 1024)
		closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(560*appDelegate.screenWidth1/768.0, 0, 35*appDelegate.screenWidth1/768.0, 35*appDelegate.screenHeight1/1024.0)];
/*	else
		closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(295, 0, 15, 15)];
*/	[closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_close.png"]	forState:UIControlStateNormal];	
		closeBtn.clipsToBounds = YES;
		[closeBtn addTarget:self action:@selector(closepopupAction:) forControlEvents:UIControlEventTouchUpInside];
		[selBookView addSubview:closeBtn];
		[closeBtn release];
		
	UIImageView *textBg;
////	if(appDelegate.screenHeight1 == 1024)
		textBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 35*appDelegate.screenHeight1/1024.0, 280*appDelegate.screenWidth1/768.0,665*appDelegate.screenHeight1/1024.0)];
/*	else
		textBg = [[UIImageView alloc] initWithFrame:CGRectMake(0,19,145,345)];
*/	textBg.image = [UIImage imageNamed:@"bg-text.png"];
		textBg.alpha = 0.25;
		[selBookView addSubview:textBg];
		[textBg release];
		
	
	if(chosenBook == TRUE)
	{
		chosenBook=FALSE;
		for(int i=0; i<[sortedArray count]; i++)
		{
			book = [sortedArray objectAtIndex:i];
			if(indexx == [book.IDValue intValue])
			{
				newindex = i;
				
			}
			else 
			{
				NSLog(@"no");
			}
			
		}
	}
	else {
		
		newindex=BookIndex;
	}

	book = [sortedArray objectAtIndex:newindex];
		
		NSArray *arr_Strings = [book.PopupImage componentsSeparatedByString:@"/"];
		
	UIImageView *selBookImage;
	
////	if(appDelegate.screenHeight1 == 1024) 
		selBookImage = [[UIImageView alloc] initWithFrame:CGRectMake(32.5*appDelegate.screenWidth1/768.0, 60*appDelegate.screenHeight1/1024.0, 215*appDelegate.screenWidth1/768.0, 331*appDelegate.screenHeight1/1024.0)];
/*	else
		selBookImage = [[UIImageView alloc] initWithFrame:CGRectMake(15,32, 115,173)];
*/	NSString *imagePath = [arr_Strings objectAtIndex:[arr_Strings count]-1];// [NSString stringWithFormat:@"%@_pop.png",book.Name];
		NSLog(@"Image Name %@",imagePath);
		//Check Image And assign if it has or no image 
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:imagePath];
		BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataFilePath];
		if(fileExists) 
		{
			selBookImage.image = [UIImage imageWithContentsOfFile:dataFilePath];
			
		}
		else
		{
			NSURL *url_popimg = [[NSURL alloc] initWithString:book.PopupImage];
			NSData *data = [[NSData alloc] initWithContentsOfURL:url_popimg];
			if(data!=nil)
			{
				selBookImage.image = [UIImage imageWithData:data];
				[data writeToFile:[DOCUMENTS_FOLDER stringByAppendingPathComponent:imagePath] atomically:YES];
				[data release];
			}
			[url_popimg release];
		}
		
		
		selBookImage.tag = selectedBookIndex+1;
		[selBookView addSubview:selBookImage];
		[selBookImage release];
		
		//[arr_Strings release];
		
		
		//Check if the file is in downloading list.......
		
		
		if(!book.IsDownloading_Or_Downloaded)
		{
			UIButton *buyBtn; 
            buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(45.5*appDelegate.screenWidth1/768.0, 436*appDelegate.screenHeight1/1024.0, 189*appDelegate.screenWidth1/768.0, 39*appDelegate.screenHeight1/1024.0)];
			if(appDelegate.screenHeight1 == 1024)
			{
            
            }	
			else
			{
			////	buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(22,225.4, 101,23)];
				//buyBtn.font = [UIFont fontWithName:@"Helvetica" size:12.0];
				buyBtn.font = [UIFont systemFontOfSize:13.0];
			}			
			[buyBtn setBackgroundImage:[UIImage imageNamed:@"bg_buynow.png"]  forState:UIControlStateNormal];
			[buyBtn setTitle:@"Download Now" forState:UIControlStateNormal];
			[buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			[buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
			buyBtn.clipsToBounds = YES;
			[buyBtn addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
			[selBookView addSubview:buyBtn];
			[buyBtn release];
		}
		else 
		{
			//Downloading the book Now.............
			UIView *vi = (UIView *)[scrollview viewWithTag:900+BookIndex];
			if(vi!=nil)
			{
				UIProgressView *ProgView = (UIProgressView *)[vi viewWithTag:1000+BookIndex];
				ProgView.frame = CGRectMake(35,450,200,20);						
				[selBookView addSubview:ProgView];
				
				UILabel *progressLabel = (UILabel *)[vi viewWithTag:-1000+BookIndex];
				progressLabel.frame =CGRectMake(CGRectGetMinX(ProgView.frame),CGRectGetMaxY(ProgView.frame)+10 , 160, 20);
				[selBookView addSubview:progressLabel];
			}
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@__%@/%@",book.Name,book.IDValue,book.Name]];
			self.pdfPathForDelete = [NSString stringWithFormat:@"%@.pdf",dataFilePath];
			//[dataFilePath release];
			if (![self.pdfPathForDelete isEqualToString:self.downloadingFileName]) {
				
			BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.pdfPathForDelete];
			if (fileExists) {
				
					UIButton *buyBtn; 
                buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(45.5*appDelegate.screenWidth1/768.0, 436*appDelegate.screenHeight1/1024.0, 189*appDelegate.screenWidth1/768.0, 39*appDelegate.screenHeight1/1024.0)];
					if(appDelegate.screenHeight1 == 1024)
					{}	
					else
					{
					////	buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(22,225.4, 101,23)];
						//buyBtn.font = [UIFont fontWithName:@"Helvetica" size:12.0];
						buyBtn.font = [UIFont systemFontOfSize:13.0];
					}			
					[buyBtn setBackgroundImage:[UIImage imageNamed:@"bg_buynow.png"]  forState:UIControlStateNormal];
					[buyBtn setTitle:@"Delete Book" forState:UIControlStateNormal];
					buyBtn.tag=-selectedBookIndex;
					[buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
					[buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
					buyBtn.clipsToBounds = YES;
					[buyBtn addTarget:self action:@selector(removeAction:) forControlEvents:UIControlEventTouchUpInside];
					[selBookView addSubview:buyBtn];
					[buyBtn release];
				}
			}
				
		}
		
		
		
		
		
		
	UILabel *intrLabel;
    intrLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*appDelegate.screenWidth1/768.0, 490*appDelegate.screenHeight1/1024.0, 260*appDelegate.screenWidth1/768.0, 40*appDelegate.screenHeight1/1024.0)];
	if(appDelegate.screenHeight1 == 1024)
	{
	//	intrLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 490, 260, 40)];
		intrLabel.font = [UIFont systemFontOfSize:12];
	}
	else
	{
	//	intrLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.3,260,134.2,31)];
		intrLabel.font = [UIFont systemFontOfSize:10];
	}		intrLabel.text = @"You may also be interested in following book(s)";
		intrLabel.numberOfLines = 0;
		intrLabel.font = [UIFont systemFontOfSize:12];
		intrLabel.textAlignment = UITextAlignmentLeft;
		intrLabel.backgroundColor = [UIColor clearColor];
		intrLabel.textColor = [UIColor redColor];
		[selBookView addSubview:intrLabel];
		[intrLabel release];
		
		
		
		// related books and their shadows images 
		UIImageView *relatedBook[3];
		UIButton * relatedButton[3];
////	if(appDelegate.screenHeight1 ==1024)
	{
		relatedBook[0] = [[UIImageView alloc] initWithFrame:CGRectMake(15*appDelegate.screenWidth1/768.0, 535*appDelegate.screenHeight1/1024.0, 80*appDelegate.screenWidth1/768.0, 120*appDelegate.screenHeight1/1024.0)];
		relatedButton[0] = [[UIButton alloc] initWithFrame:CGRectMake(15*appDelegate.screenWidth1/768.0, 535*appDelegate.screenHeight1/1024.0, 80*appDelegate.screenWidth1/768.0, 120*appDelegate.screenHeight1/1024.0)];
		[relatedButton[0] addTarget:self action:@selector(relatedBookButtonAct:) forControlEvents:UIControlEventTouchUpInside];
		relatedBook[0].tag = selectedBookIndex+20+1;
		[selBookView addSubview:relatedBook[0]];
		[selBookView addSubview:relatedButton[0]];
		
		relatedBook[1] = [[UIImageView alloc] initWithFrame:CGRectMake(100*appDelegate.screenWidth1/768.0, 535*appDelegate.screenHeight1/1024.0, 80*appDelegate.screenWidth1/768.0, 120*appDelegate.screenHeight1/1024.0)];
		relatedButton[1] = [[UIButton alloc] initWithFrame:CGRectMake(100*appDelegate.screenWidth1/768.0, 535*appDelegate.screenHeight1/1024.0, 80*appDelegate.screenWidth1/768.0, 120*appDelegate.screenHeight1/1024.0)];
		[relatedButton[1] addTarget:self action:@selector(relatedBookButtonAct:) forControlEvents:UIControlEventTouchUpInside];
		relatedBook[1].tag = selectedBookIndex+20+2;
		[selBookView addSubview:relatedBook[1]];
		[selBookView addSubview:relatedButton[1]];
		
		relatedBook[2] = [[UIImageView alloc] initWithFrame:CGRectMake(185*appDelegate.screenWidth1/768.0, 535*appDelegate.screenHeight1/1024.0, 80*appDelegate.screenWidth1/768.0, 120*appDelegate.screenHeight1/1024.0)];
		relatedButton[2] = [[UIButton alloc] initWithFrame:CGRectMake(185*appDelegate.screenWidth1/768.0, 535*appDelegate.screenHeight1/1024.0, 80*appDelegate.screenWidth1/768.0, 120*appDelegate.screenHeight1/1024.0)];
		relatedBook[2].tag = selectedBookIndex+20+3;
		[relatedButton[2] addTarget:self action:@selector(relatedBookButtonAct:) forControlEvents:UIControlEventTouchUpInside];
		[selBookView addSubview:relatedBook[2]];
		[selBookView addSubview:relatedButton[2]];
	}
/*	else 
	{
		relatedBook[0] = [[UIImageView alloc] initWithFrame:CGRectMake(18, 295, 34,50)];
		relatedButton[0] = [[UIButton alloc] initWithFrame:CGRectMake(18, 295, 34,50)];
		[relatedButton[0] addTarget:self action:@selector(relatedBookButtonAct:) forControlEvents:UIControlEventTouchUpInside];
		relatedBook[0].tag = selectedBookIndex+20+1;
		[selBookView addSubview:relatedBook[0]];
		[selBookView addSubview:relatedButton[0]];
		
		relatedBook[1] = [[UIImageView alloc] initWithFrame:CGRectMake(56, 295, 34,50)];
		relatedButton[1] = [[UIButton alloc] initWithFrame:CGRectMake(56, 295, 34,50)];
		[relatedButton[1] addTarget:self action:@selector(relatedBookButtonAct:) forControlEvents:UIControlEventTouchUpInside];
		relatedBook[1].tag = selectedBookIndex+20+2;
		[selBookView addSubview:relatedBook[1]];
		[selBookView addSubview:relatedButton[1]];
		
		relatedBook[2] = [[UIImageView alloc] initWithFrame:CGRectMake(94, 295, 34,50)];
		relatedButton[2] = [[UIButton alloc] initWithFrame:CGRectMake(94, 295, 34,50)];
		relatedBook[2].tag = selectedBookIndex+20+3;
		[relatedButton[2] addTarget:self action:@selector(relatedBookButtonAct:) forControlEvents:UIControlEventTouchUpInside];
		[selBookView addSubview:relatedBook[2]];
		[selBookView addSubview:relatedButton[2]];
	}		
*/		
		
		// Assign Image for Related Books :-
		int totalRelatedBook = 0;
		if (oneBookDet.RealatedBookArray!=nil)
		{
			NSArray *Arr_related = [[NSArray alloc] initWithArray:oneBookDet.RealatedBookArray];
			
			for (int i =0; i<3;i++) 
			{
				RelatedBookDeatails *rltdBkDet = nil;
				if (i<[Arr_related count]) 
				{
					rltdBkDet = [(RelatedBookDeatails*)[Arr_related objectAtIndex:i] retain]; 
				}
				
				if (rltdBkDet==nil) 
				{
					relatedBook[i].image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"NotAvilable.png"]] ];
					relatedBook[i].hidden = TRUE;
					relatedButton[i].hidden = TRUE;
					[relatedBook[i] release];
					[relatedButton[i] release];
					
				}
				else if(rltdBkDet.ReleatedCoverPhoto!=nil || ![rltdBkDet.ReleatedCoverPhoto isEqualToString:@""])
				{
					//NSInteger idnumber = rltdBkDet.ReleatedIDValue;
					//RelatedBookDeatails *rbd_Obj = [rltdBkDet retain];
					
					relatedButton[i].tag = [rltdBkDet.ReleatedIDValue intValue];
					
					//[rbd_Obj.ReleatedIDValue intValue];
					//Name was getting changed in server side to avoid that we are doing this
					NSArray *arr_Strings = [rltdBkDet.ReleatedCoverPhoto componentsSeparatedByString:@"/"];
					
					NSString *imageName = [arr_Strings objectAtIndex:[arr_Strings count]-1];
					imageName = [NSString stringWithFormat:@"Rel%d%",i,imageName];
					NSString *imagePath = [NSString stringWithFormat:@"/RelatedBooks/%@",imageName];
					totalRelatedBook++;
					
					NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
					NSString *documentsDirectory = [paths objectAtIndex:0];
					NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:imagePath];
					BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataFilePath];
					if (fileExists) 
					{
						//Read the Saved image and assign.........
						relatedBook[i].image = [UIImage imageWithContentsOfFile:dataFilePath];
						[relatedBook[i] release];
						[relatedButton[i] release];
					}
					else
					{
						//Download it and assign them......
						
						NSURL *url = [[NSURL alloc] initWithString:rltdBkDet.ReleatedCoverPhoto];
						NSLog(@"###relaed cover photo url%@###",url);
						NSData *data = [[NSData alloc] initWithContentsOfURL:url];
						if(data!=nil)
						{
							//save this image.......
							relatedBook[i].image = [UIImage imageWithData:data];
							[relatedBook[i] release];
							[relatedButton[i] release];
							[data writeToFile:[DOCUMENTS_FOLDER stringByAppendingPathComponent:imageName] atomically:YES];
							[data release];
						}
						[url release];
					}
					//[arr_Strings release];
				}
			}
			
		}
		else 
		{
			for (int i =0; i<3;i++)
			{
				relatedBook[i].image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"NotAvilable.png"]] ];
				relatedBook[i].hidden = TRUE;
				relatedButton[i].hidden = TRUE;
				[relatedBook[i] release];
				relatedButton[i].tag = 0;
				[relatedButton[i] release];
			}
		}
		
		
////	if(appDelegate.screenHeight1 == 1024) 
	{
		UIImageView *bookShadow1 = [[UIImageView alloc] initWithFrame:CGRectMake(15*appDelegate.screenWidth1/768.0, 660*appDelegate.screenHeight1/1024.0, 80*appDelegate.screenWidth1/768.0, 38*appDelegate.screenHeight1/1024.0)];
		bookShadow1.image = [UIImage imageNamed:@"image_small_shadow.png"];
		[selBookView addSubview:bookShadow1];
		[bookShadow1 release];
		
		UIImageView *bookShadow2 = [[UIImageView alloc] initWithFrame:CGRectMake(100*appDelegate.screenWidth1/768.0, 660*appDelegate.screenHeight1/1024.0, 80*appDelegate.screenWidth1/768.0, 38*appDelegate.screenHeight1/1024.0)];
		bookShadow2.image = [UIImage imageNamed:@"image_small_shadow.png"];
		[selBookView addSubview:bookShadow2];
		[bookShadow2 release];
		
		UIImageView *bookShadow3 = [[UIImageView alloc] initWithFrame:CGRectMake(185*appDelegate.screenWidth1/768.0, 660*appDelegate.screenHeight1/1024.0, 80*appDelegate.screenWidth1/768.0, 38*appDelegate.screenHeight1/1024.0)];
		bookShadow3.image = [UIImage imageNamed:@"image_small_shadow.png"];
		[selBookView addSubview:bookShadow3];
		[bookShadow3 release];
	}
/*	else 
	{
		UIImageView *bookShadow1 = [[UIImageView alloc] initWithFrame:CGRectMake(18, 347, 34, 18)];//18, 295, 34,50
		bookShadow1.image = [UIImage imageNamed:@"image_small_shadow.png"];
		[selBookView addSubview:bookShadow1];
		[bookShadow1 release];
		
		UIImageView *bookShadow2 = [[UIImageView alloc] initWithFrame:CGRectMake(56, 347, 34, 18)];//56, 295, 34,50
		
		bookShadow2.image = [UIImage imageNamed:@"image_small_shadow.png"];
		[selBookView addSubview:bookShadow2];
		[bookShadow2 release];
		
		UIImageView *bookShadow3 = [[UIImageView alloc] initWithFrame:CGRectMake(94, 347, 34, 18)];//94, 295, 34,50
		bookShadow3.image = [UIImage imageNamed:@"image_small_shadow.png"];
		[selBookView addSubview:bookShadow3];
		[bookShadow3 release];
	}
*/	
		
		
		// book title,subtitle, description 
	UILabel *bookTitle; 
    bookTitle = [[UILabel alloc] initWithFrame:CGRectMake(295*appDelegate.screenWidth1/768.0, 55*appDelegate.screenHeight1/1024.0, 280*appDelegate.screenWidth1/768.0, 20*appDelegate.screenHeight1/1024.0)];
	if(appDelegate.screenHeight1 == 1024)
	{
	//	bookTitle = [[UILabel alloc] initWithFrame:CGRectMake(295, 55, 280, 20)];
		bookTitle.font =[UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
	}
	else
	{
	//	bookTitle = [[UILabel alloc] initWithFrame:CGRectMake(152,32, 152, 25)];
		bookTitle.font =[UIFont fontWithName:@"TrebuchetMS-Bold" size:12];
	}	
		bookTitle.textAlignment = UITextAlignmentLeft;
		bookTitle.backgroundColor = [UIColor clearColor];
		bookTitle.textColor = [UIColor redColor];
		bookTitle.lineBreakMode = UILineBreakModeWordWrap;
		bookTitle.numberOfLines = 0;
		/*to set UILabel height dynamically */
		NSString *titleStr =oneBookDet.Name;// bookdetailsObj.description;
		CGSize maximumLabelSize1 = CGSizeMake(280,9999);
		CGSize expectedLabelSize1 = [titleStr sizeWithFont:bookTitle.font 
										 constrainedToSize:maximumLabelSize1 
											 lineBreakMode:bookTitle.lineBreakMode];
		CGRect newFrame1 = bookTitle.frame;
		newFrame1.size.height = expectedLabelSize1.height;
		bookTitle.frame = newFrame1;
		bookTitle.text = oneBookDet.Name;//bookdetailsObj.description;
		[selBookView addSubview:bookTitle];
		[bookTitle release];
		
		
		//UILabel *byAuthor = [[UILabel alloc] initWithFrame:CGRectMake(295,55+20, 280, 40)];
		
		float descY = 55+20+40 + 10.0;
		float descHeight = 500.0 - descY;
		
	UITextView *desc; 
    desc = [[UITextView alloc] initWithFrame:CGRectMake(290*appDelegate.screenWidth1/768.0, descY*appDelegate.screenHeight1/1024.0, 280*appDelegate.screenWidth1/768.0, descHeight*appDelegate.screenHeight1/1024.0)];
	if(appDelegate.screenHeight1 == 1024)
	{
	//	desc = [[UITextView alloc] initWithFrame:CGRectMake(290, descY, 280, descHeight)];
		desc.font = [UIFont fontWithName:@"ArialMT" size:13];
	}
	else
	{
	//	desc = [[UITextView alloc] initWithFrame:CGRectMake(152, descY-60, 152, descHeight-100)];
		desc.font = [UIFont fontWithName:@"ArialMT" size:11];
	}
	desc.textAlignment = UITextAlignmentLeft;
		desc.backgroundColor = [UIColor clearColor];
		desc.textColor = [UIColor blackColor];
		desc.editable=FALSE;
		desc.text = oneBookDet.Description;
		[selBookView addSubview:desc];
		[desc release];
		//[downloadingOverlayView setHidden:FALSE];
		
		
	
}



/*************
-(void)createDiscriptionView :(NSString *)descriptionXmlUrl
{
	
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	
	OneBookDetails *oneBookDet = [self loadBookDescription:descriptionXmlUrl];
	if (oneBookDet ==nil) 
	{
		selBookView.hidden = TRUE;
		return;
	}
	
	
	
	selectedbookISBNnumber = oneBookDet.ISBNNumber;
	//**************      if i commented this what will happen     ************* //
	[self buyAction:nil];
	
	UILabel *bookTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 560, 35)];
	bookTitleLabel.text = oneBookDet.Name;
	bookTitleLabel.font = [UIFont systemFontOfSize:25];
	bookTitleLabel.textAlignment = UITextAlignmentCenter;
	bookTitleLabel.backgroundColor = [UIColor clearColor];
	bookTitleLabel.textColor = [UIColor whiteColor];
	[selBookView addSubview:bookTitleLabel];
	[bookTitleLabel release];
	
	UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(560, 0, 35, 35)];
	[closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_close.png"]	forState:UIControlStateNormal];	
	closeBtn.clipsToBounds = YES;
	[closeBtn addTarget:self action:@selector(closepopupAction:) forControlEvents:UIControlEventTouchUpInside];
	[selBookView addSubview:closeBtn];
	[closeBtn release];
	
	UIImageView *textBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 35, 280,665)];
	textBg.image = [UIImage imageNamed:@"bg-text.png"];
	textBg.alpha = 0.25;
	[selBookView addSubview:textBg];
	[textBg release];
	
	BookDetails *book = [sortedArray objectAtIndex:BookIndex];
	NSArray *arr_Strings = [book.PopupImage componentsSeparatedByString:@"/"];

	UIImageView *selBookImage = [[UIImageView alloc] initWithFrame:CGRectMake(32.5, 60, 215, 331)];
	NSString *imagePath = [arr_Strings objectAtIndex:[arr_Strings count]-1];// [NSString stringWithFormat:@"%@_pop.png",book.Name];
	NSLog(@"Image Name %@",imagePath);
	//Check Image And assign if it has or no image 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:imagePath] retain];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataFilePath];
	if(fileExists) 
	{
		selBookImage.image = [UIImage imageWithContentsOfFile:dataFilePath];
		
	}
	else
	{
		NSURL *url_popimg = [[NSURL alloc] initWithString:book.PopupImage];
		NSData *data = [[NSData alloc] initWithContentsOfURL:url_popimg];
		if(data!=nil)
		{
		selBookImage.image = [UIImage imageWithData:data];
		[data writeToFile:[DOCUMENTS_FOLDER stringByAppendingPathComponent:imagePath] atomically:YES];
		
		}
		[data release];
		[url_popimg release];
	}
	[dataFilePath release];
	
	selBookImage.tag = selectedBookIndex+1;
	[selBookView addSubview:selBookImage];
	[selBookImage release];
	
	//[arr_Strings release];
	
	
	//Check if the file is in downloading list.......
	
	
	if(!book.IsDownloading_Or_Downloaded)
	{
		UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(45.5, 436, 189, 39)];
		[buyBtn setBackgroundImage:[UIImage imageNamed:@"bg_buynow.png"]  forState:UIControlStateNormal];
		[buyBtn setTitle:@"Download Now" forState:UIControlStateNormal];
		[buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		buyBtn.clipsToBounds = YES;
		[buyBtn addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
		[selBookView addSubview:buyBtn];
		[buyBtn release];
	}
	else 
	{
		//Downloading the book Now.............
		UIView *vi = (UIView *)[scrollview viewWithTag:900+BookIndex];
		if(vi!=nil)
		{
			UIProgressView *ProgView = (UIProgressView *)[vi viewWithTag:1000+BookIndex];
			ProgView.frame = CGRectMake(35,450,200,20);						
			[selBookView addSubview:ProgView];
		}
	}

	
	
	
	
	
	UILabel *intrLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 490, 260, 40)];
	intrLabel.text = @"You may also be interested in following book(s)";
	intrLabel.numberOfLines = 0;
	intrLabel.font = [UIFont systemFontOfSize:12];
	intrLabel.textAlignment = UITextAlignmentLeft;
	intrLabel.backgroundColor = [UIColor clearColor];
	intrLabel.textColor = [UIColor redColor];
	[selBookView addSubview:intrLabel];
	[intrLabel release];
	
	
	
	// related books and their shadows images
	UIImageView *relatedBook[3];
	UIButton * relatedButton[3];
	relatedBook[0] = [[UIImageView alloc] initWithFrame:CGRectMake(15, 535, 80, 120)];
	relatedButton[0] = [[UIButton alloc] initWithFrame:CGRectMake(15, 535, 80, 120)];
	[relatedButton[0] addTarget:self action:@selector(relatedBookButtonAct:) forControlEvents:UIControlEventTouchUpInside];
	relatedBook[0].tag = selectedBookIndex+20+1;
	[selBookView addSubview:relatedBook[0]];
	[selBookView addSubview:relatedButton[0]];
	
	relatedBook[1] = [[UIImageView alloc] initWithFrame:CGRectMake(100, 535, 80, 120)];
	relatedButton[1] = [[UIButton alloc] initWithFrame:CGRectMake(100, 535, 80, 120)];
	[relatedButton[1] addTarget:self action:@selector(relatedBookButtonAct:) forControlEvents:UIControlEventTouchUpInside];
	relatedBook[1].tag = selectedBookIndex+20+2;
	[selBookView addSubview:relatedBook[1]];
	[selBookView addSubview:relatedButton[1]];
	
	relatedBook[2] = [[UIImageView alloc] initWithFrame:CGRectMake(185, 535, 80, 120)];
	relatedButton[2] = [[UIButton alloc] initWithFrame:CGRectMake(185, 535, 80, 120)];
	relatedBook[2].tag = selectedBookIndex+20+3;
	[relatedButton[2] addTarget:self action:@selector(relatedBookButtonAct:) forControlEvents:UIControlEventTouchUpInside];
	[selBookView addSubview:relatedBook[2]];
	[selBookView addSubview:relatedButton[2]];
	
	
	
	// Assign Image for Related Books :-
	int totalRelatedBook = 0;
	if (oneBookDet.RealatedBookArray!=nil)
	{
		NSArray *Arr_related = [[NSArray alloc] initWithArray:oneBookDet.RealatedBookArray];
		for (int i =0; i<3;i++) 
		{
			RelatedBookDeatails *rltdBkDet = nil;
			if (i<[Arr_related count]) 
			{
				rltdBkDet = [(RelatedBookDeatails*)[Arr_related objectAtIndex:i] retain]; 
			}
			
			if (rltdBkDet==nil) 
			{
				relatedBook[i].image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"NotAvilable.png"]] ];
				relatedBook[i].hidden = TRUE;
				relatedButton[i].hidden = TRUE;
				[relatedBook[i] release];
				[relatedButton[i] release];
				
			}
			else if(rltdBkDet.ReleatedCoverPhoto!=nil || ![rltdBkDet.ReleatedCoverPhoto isEqualToString:@""])
			{
				
				//RelatedBookDeatails *rbd_Obj = [rltdBkDet retain];
				relatedButton[i].tag = 12;//[rbd_Obj.ReleatedIDValue intValue];
				
				//Name was getting changed in server side to avoid that we are doing this
				NSArray *arr_Strings = [rltdBkDet.ReleatedCoverPhoto componentsSeparatedByString:@"/"];
			
				NSString *imageName = [arr_Strings objectAtIndex:[arr_Strings count]-1];
				imageName = [[NSString alloc] initWithFormat:@"Rel%d%",i,imageName];
				NSString *imagePath = [[NSString alloc] initWithFormat:@"/RelatedBooks/%@",imageName];
				totalRelatedBook++;
				
				NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *documentsDirectory = [paths objectAtIndex:0];
				NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:imagePath] retain];
				[imagePath release];
				BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataFilePath];
				if (fileExists) 
				{
					//Read the Saved image and assign.........
					relatedBook[i].image = [UIImage imageWithContentsOfFile:dataFilePath];
					[relatedBook[i] release];
					[relatedButton[i] release];
				}
				else
				{
					//Download it and assign them......
					
					NSURL *url = [[NSURL alloc] initWithString:rltdBkDet.ReleatedCoverPhoto];
					NSLog(@"###relaed cover photo url%@###",url);
					NSData *data = [[NSData alloc] initWithContentsOfURL:url];
					if(data!=nil)
					{
						//save this image.......
						relatedBook[i].image = [UIImage imageWithData:data];
						[relatedBook[i] release];
						[relatedButton[i] release];
						[data writeToFile:[DOCUMENTS_FOLDER stringByAppendingPathComponent:imageName] atomically:YES];
						
					}
					[data release];
					[url release];
				}
				[imageName release];
				[rltdBkDet release]; 
				[dataFilePath release];
				if(arr_Strings!=nil)
				{
					[arr_Strings release];
					arr_Strings = nil;
				}
			}
		}
		[Arr_related release];
		
	}
	else 
	{
		for (int i =0; i<3;i++)
		{
			relatedBook[i].image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"NotAvilable.png"]] ];
			relatedBook[i].hidden = TRUE;
			relatedButton[i].hidden = TRUE;
			[relatedBook[i] release];
			relatedButton[i].tag = 0;
			[relatedButton[i] release];
		}
	}
	UIImageView *bookShadow1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 660, 80, 38)];
	bookShadow1.image = [UIImage imageNamed:@"image_small_shadow.png"];
	[selBookView addSubview:bookShadow1];
	[bookShadow1 release];
	
	UIImageView *bookShadow2 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 660, 80, 38)];
	bookShadow2.image = [UIImage imageNamed:@"image_small_shadow.png"];
	[selBookView addSubview:bookShadow2];
	[bookShadow2 release];
	
	UIImageView *bookShadow3 = [[UIImageView alloc] initWithFrame:CGRectMake(185, 660, 80, 38)];
	bookShadow3.image = [UIImage imageNamed:@"image_small_shadow.png"];
	[selBookView addSubview:bookShadow3];
	[bookShadow3 release];
	
	
	// book title,subtitle, description
	UILabel *bookTitle = [[UILabel alloc] initWithFrame:CGRectMake(295, 55, 280, 20)];
	bookTitle.font =[UIFont fontWithName:@"TrebuchetMS-Bold" size:20];// [UIFont boldSystemFontOfSize:18];
	bookTitle.textAlignment = UITextAlignmentLeft;
	bookTitle.backgroundColor = [UIColor clearColor];
	bookTitle.textColor = [UIColor redColor];
	bookTitle.lineBreakMode = UILineBreakModeWordWrap;
	bookTitle.numberOfLines = 0;
	/*to set UILabel height dynamically * /
	NSString *titleStr =oneBookDet.Name;// bookdetailsObj.description;
	CGSize maximumLabelSize1 = CGSizeMake(280,9999);
	CGSize expectedLabelSize1 = [titleStr sizeWithFont:bookTitle.font 
									 constrainedToSize:maximumLabelSize1 
										 lineBreakMode:bookTitle.lineBreakMode];
	CGRect newFrame1 = bookTitle.frame;
	newFrame1.size.height = expectedLabelSize1.height;
	bookTitle.frame = newFrame1;
	bookTitle.text = oneBookDet.Name;//bookdetailsObj.description;
	[selBookView addSubview:bookTitle];
	[bookTitle release];
	

	//UILabel *byAuthor = [[UILabel alloc] initWithFrame:CGRectMake(295,55+20, 280, 40)];

	float descY = 55+20+40 + 10.0;
	float descHeight = 500.0 - descY;
	
	UITextView *desc = [[UITextView alloc] initWithFrame:CGRectMake(290, descY, 280, descHeight)];
	desc.font = [UIFont fontWithName:@"ArialMT" size:13];
	desc.textAlignment = UITextAlignmentLeft;
	desc.backgroundColor = [UIColor clearColor];
	desc.textColor = [UIColor blackColor];
	desc.editable=FALSE;
	desc.text = oneBookDet.Description;
	[selBookView addSubview:desc];
	[desc release];
	[downloadingOverlayView setHidden:FALSE];
	
	[arr_Strings release];
	arr_Strings = nil;
	
	//[pool release];
	
	
}




*************/     





-(void)relatedBookButtonAct:(id)sender
{
	indexx = [sender tag];
	chosenBook = TRUE;
	if (indexx ==0) 
	{
		return;
	}
	selectedBookIndex = indexx;
	[self closepopupAction:nil];
	[downloadingOverlayView setHidden:TRUE];
	//BookIndex=0;
	
	//selectedBookIndex=[sender index];
	printf("\nselBookAction... %d",indexx);
	
	
	for(UIView *subview in selBookView.subviews)
	{
		[subview removeFromSuperview];
	}
	[selBookView removeFromSuperview];
	[self.view addSubview:selBookView];
	selBookView.hidden = NO;
	//http://www.adminmyapp.com/dashboard/api/read?action=detailbook&authKey=(null)&bookId=86
	NSString * descriptionUrl = [NSString stringWithFormat:@"%@/api/read?action=detailbook&authKey=%@&bookId=%d",serverIP,appDelegate.loginAuthKey,indexx];
	//NSString * descriptionUrl = [[NSString alloc] initWithFormat:@"http://www.adminmyapp.com/dashboard/api/read?action=detailbook&authKey=(null)&bookId=86"]; //,serverIP,appDelegate.loginAuthKey,indexx];
	[self createDiscriptionView:descriptionUrl];
	
	
	NSLog(@"rrrrrrrrrrrrrrrrrrrrr");
	//[descriptionUrl release];
	
}

/********************* Download Book Description Xml and save that in ************************/
-(OneBookDetails *)loadBookDescription:(NSString *)descXmlUrl
{
	
	NSURL *url = [[NSURL alloc] initWithString:descXmlUrl];
	NSData *xmlData = [[NSData alloc]initWithContentsOfURL:url];
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
	
    BookDetailParser *bookDetailParser = [[BookDetailParser alloc]initXMLParser];
	[xmlParser setDelegate:bookDetailParser];
	BOOL success = [xmlParser parse];
	[xmlParser release];
	xmlParser=nil;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:@"description.xml"];
	if(!success) //Karpaga
	{
		[self _showAlert:@"Internet Unavailable" comment:@"Data not found for this book...."];
		return nil;
		
	}
	if(success)
	{
		//*****************Run a thread to download the Book
		[xmlData writeToFile:dataFilePath atomically:YES];
		if (appDelegate.booksDetailsArray==nil) 
		{
			return nil;
		}
		else if([appDelegate.booksDetailsArray count] < 1)
		{
			
		}
		else 
		{
			[appDelegate.booksDetailsArray retain];
			OneBookDetails* oneBookDetai = (OneBookDetails *)[appDelegate.booksDetailsArray objectAtIndex:0];
			[oneBookDetai retain];
			[self DownloadCover:oneBookDetai];
			//[NSThread detachNewThreadSelector:@selector(DownloadCover:) toTarget:self withObject:oneBookDetai];	
			if (oneBookDetai.RealatedBookArray!=nil) 
			{
				[self DownloadRelatedBooks:oneBookDetai.RealatedBookArray];
				
				//[NSThread detachNewThreadSelector:@selector(DownloadRelatedBooks:) toTarget:self withObject:oneBookDetai.RealatedBookArray ];
			}
			else 
			{
				//Change the images to no book simillar to them...... 
				
			}
			return oneBookDetai;
			
		}
	 
	}
	else
	{
		NSLog(@"Error Error Error!!!");
	}
	//[dataFilePath release];
	[xmlData release];
	[url release];
	[xmlParser release];
	
	
    return nil;
}
// 

#pragma mark -
#pragma mark Downloading Functions

-(void)DownloadCover:(OneBookDetails *)onebkDetail
{
	NSLog(@"DownloadCover storeView Controller");
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
	NSString *myurl = onebkDetail.CoverPhoto ;
	NSString *ISBNNumber = @"";//[NSString stringWithFormat:@"%@",onebkDetail.ISBNNumber];
	NSLog(@"MyURL %@",myurl);
	
	if (myurl!=nil) 
	{
		NSString *imageName = @"BookLarge.jpg";
		NSString * fileName  = [NSString stringWithFormat:@"/%@",imageName];
		if(![appDelegate checkFileExist:fileName])
		{
			NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:myurl]];
			UIImage *img = [UIImage imageWithData:imageData];
			if (img==nil) 
			{
				NSLog(@"No Image");
				//////img = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"no_image1.png"]] ];
				
			}
			//[self saveImage :img withName:[NSString stringWithFormat:@"/%@/%@%@",ISBNNumber,ISBNNumber,imageName]];
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *docDirectory = [paths objectAtIndex:0];
			
			
			NSString *dataFilePath = [docDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",ISBNNumber]];
			[[ NSFileManager defaultManager] createDirectoryAtPath:dataFilePath attributes:nil];
			
			[appDelegate saveImage :img withName:[dataFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",imageName]]];
			
			UIImageView *largeImageView =[selBookView viewWithTag:selectedBookIndex+1];
			largeImageView.image =img;
			//[img release];
			[imageData release];
			//[dataFilePath release];
		}
		else 
		{
			
			NSLog(@"FileExists");
		}
		
	}
	
	//[pool release]; 
}


-(void)DownloadRelatedBooks:(NSMutableArray *)relatedBookArray
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
	if(relatedBookArray == nil)
		[relatedBookArray retain];
	for (int h=0 ; h<[relatedBookArray count];h++) 
	{
		RelatedBookDeatails *relatedDetailsObj = [relatedBookArray objectAtIndex:h];
		//NSString *ISBNNumber = [NSString stringWithFormat:@"%@",selectedbookISBNnumber];
		//if (myurl!=nil) 
		{
			NSArray *arr_str = [relatedDetailsObj.ReleatedCoverPhoto componentsSeparatedByString:@"/"];
			
			NSString *imageName = [arr_str objectAtIndex:[arr_str count]-1];
			imageName = [NSString stringWithFormat:@"Rel%d%@",h,imageName];
			//NSString *fileName = [NSString stringWithFormat:@"/%@/RelatedBooks/%@",imageName];
			//[imageName release];
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *docDirectory = [paths objectAtIndex:0];
			NSString *dataFilePath = [docDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/RelatedBooks"]];
			//[fileName release];
			BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataFilePath];
			if(fileExists)
			{
				//Get and assign it..........
				[UIImage imageWithContentsOfFile:dataFilePath];
				
				
			}
			else 
			{
				//Download it from the Net......
				NSURL *url = [[NSURL alloc] initWithString:relatedDetailsObj.ReleatedCoverPhoto];
				NSData *data = [[NSData alloc] initWithContentsOfURL:url];
				if(data!=nil)
				{
					[[NSFileManager defaultManager] createDirectoryAtPath:dataFilePath attributes:nil];
					UIImageView *largeImageView = (UIImageView *)[selBookView viewWithTag:selectedBookIndex+20+(h+1)];
					largeImageView.image =[UIImage imageWithData:data];
					[data writeToFile:[DOCUMENTS_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"Rel_(%i).jpg",h]] atomically:YES];
				}
				[url release];
				[data release];
				
			}
			//[dataFilePath release];
			//[arr_str release];

		}
	}
	[pool drain];
}


#pragma mark -
#pragma mark Description Btn Act
-(void)closepopupAction:(id)sender
{
	printf("\nclosepopupAction...");
	//[self performSelector:@selector(loadScrollView:)];
	selBookView.hidden = YES;
	[downloadingOverlayView setHidden:TRUE];
	
	
	BookDetails *book = [sortedArray objectAtIndex:BookIndex];
	if(!book.IsDownloading_Or_Downloaded)
	{
	}
	else 
	{
		UIView *vi = (UIView *)[scrollview viewWithTag:900+CurrentIndex];
		if(vi!=nil)
		{
			UIProgressView *ProgView = (UIProgressView *)[selBookView viewWithTag:1000+BookIndex];
//			if(appDelegate.screenHeight1 == 1024) 
				ProgView.frame = CGRectMake(120*appDelegate.screenWidth1/768.0, 115*appDelegate.screenHeight1/1024.0, 100*appDelegate.screenWidth1/768.0, 20*appDelegate.screenHeight1/1024.0);
            [vi addSubview:ProgView];
/*			else
				ProgView.frame = CGRectMake(46,46,50,9.4);			[vi addSubview:ProgView];
*/			
			UILabel *progressLabel = (UILabel *)[selBookView viewWithTag:-1000+BookIndex];
			progressLabel.frame =CGRectMake(CGRectGetMaxX(ProgView.frame)+6,CGRectGetMinY(ProgView.frame)-5 , 160, 20);
			[vi addSubview:progressLabel];
		}
	}
	
	
	//[downloadingOverlayView removeFromSuperview];
	//[downloadingOverlayView release];
}





-(void)closeAction:(id)sender
{
	[downloadingOverlayView setHidden:TRUE];
	printf("\n closeAction...");
	isAbtAuth = NO;
	bioView.hidden = YES;
	selBookView.hidden = YES;
	
	//backButton.hidden = YES;
}

/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

 
 




#pragma mark -
#pragma mark Table view data source

/*
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 // Return the number of sections.
 return <#number of sections#>;
 }
 
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 // Return the number of rows in the section.
 return <#number of rows in section#>;
 }
 
 
 // Customize the appearance of table view cells.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
 static NSString *CellIdentifier = @"Cell";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell == nil) {
 cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
 }
 
 // Configure the cell...
 
 return cell;
 }
 
 */
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */



#pragma mark -
#pragma mark Table view delegate


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	NSLog(@"didReceiveMemoryWarning storeviewcontoller=========================");
    if (navController) {
        [PSPDFDocument release];
        [navController dismissModalViewControllerAnimated:YES];
        [navController release];
        navController=nil;
        //[[PSPDFCache sharedPSPDFCache] clearCache];
    }
    /*if (downloadBookConnection) {
        
        [downloadBookConnection cancel];
        //BookDetails *book = [sortedArray objectAtIndex:CurrentIndex];
        if ([[self getPDFS] count]>0) {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Low Memory" message:@"Would you like to delete already downloaded book for continue downloading?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
            [errorAlert show];
            [errorAlert release];
            return;
        }
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Low Memory" message:@"Download Cancelled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
        BookDetails *book = [sortedArray objectAtIndex:CurrentIndex];
        book.IsDownloading_Or_Downloaded = NO;
        [self loadScrollViewContents];
        downloadedLength=0.0;
        self.downloadingFileName=nil;
        [file closeFile];
        file=nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [downloadBookConnection release];
        downloadBookConnection=nil;
        NSLog(@"the Downloading Over");
        IsDownload = NO;
        downloading_Progress = FALSE;
        ISFirstTimeDownloading=YES;
        
    }*/
    
    
   

    // Relinquish ownership any cached data, images, etc that aren't in use.
	
	
//	UIAlertView *alert = [[UIAlertView alloc] 
//						  initWithTitle:@"Warning" 
//						  message:@"You are running out of memory" 
//						  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//	[alert show];
//	[alert release];
	
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Overriden to allow any orientation.
	return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
	//return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
	//return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) ;

}


- (void)dealloc 
{
	
	[downloadingOverlayView release];
	[myView release];
	[authorView release];
	//[authorViewNew release];
	[bannerScrollView release];
	
	
	[segLabel release];
	[segmentCntrl release];
	//[backButton release];
	[bioView release];
	[selBookView release];
	[textfieldName release];
	[textfieldPassword release];
	[bigBannerImgViw release];
	[smallBannerImgViw1 release];
	[smallBannerImgViw2 release];
	[smallBannerImgViw3 release];
    [super dealloc];
}



-(void)buyAction:(id)sender
{
    [listOfPdfsDelete setHidden:YES];
	printf("\nbuyAction karpaga...");
	
	//[downloadingOverlayView removeFromSuperview];
//	[downloadingOverlayView release];
//	
//	 //comented by 
//		if (appDelegate.loginAuthKey==nil||[appDelegate.loginAuthKey isEqualToString:@""]) {
//		//[self _showAlert:@"Please Login" comment:@"Login in your account to buy book"];
//		[self closeAction:sender];
//		[self loginInPurchase];
//		return;
//		appDelegate.loginAuthKey =@"9650ef957e71f654013e1319f3c72268";
	//}
	 
	 
	 
	//[downloadingOverlayView setHidden:TRUE];
	
	NSString *title = [(UIButton *)sender currentTitle];
	
//	if(btn.currentBackgroundImage == [UIImage imageNamed:@"download.png"] || [title isEqualToString:@"Download Now"])
	if ([title isEqualToString:@"Download Now"]) 
	{
		
		//[self closeAction:sender];
		//		[downloadingOverlayView setHidden:FALSE];
		//		kInAppPurchaseProUpgradeProductId = [NSString stringWithString:selectedbookISBNnumber];
		//		[self requestProUpgradeProductData];
		//		
		//		if([self canMakePurchases]==YES)
		//			[self purchaseProUpgrade]; 
		//		return;
		//if (downloading_Progress==TRUE) 
//		{
//			[self _showAlert:@"Please wait" comment:@"Another book downloading is in progress. "];
//			[self closeAction:sender];
//			return;
//		}
//		else {
//			
//			@try {
				
				
				appDelegate.bookPurchased =TRUE;
				[self Downloading:sender];
//				[self performSelector:@selector(Downloading:) withObject:sender afterDelay:0.1];
//				[NSThread detachNewThreadSelector:@selector(Downloading:) toTarget:sender withObject:nil];	
				
			//}
//			@catch (NSException * e) {
//				
//			}
			
//		}
		
		downloading_Progress = TRUE;
		
		[self closeAction:sender];
		
	}
	else {
		//[self _showAlert:@"Book Purchase " comment:@"Comming soon .."];
		//return;
		/************ 
		 commented by
		
		[self closeAction:sender];
		[downloadingOverlayView setHidden:FALSE];
		kInAppPurchaseProUpgradeProductId = [NSString stringWithString:selectedbookISBNnumber];
		[self requestProUpgradeProductData];
		
		if([self canMakePurchases]==YES)
			[self purchaseProUpgrade]; 
		 ************/
	}
	
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(![listOfPdfsDelete isHidden]){
        [listOfPdfsDelete setHidden:YES];
        for (UIView *view in self.view.subviews) {
            if (view != listOfPdfsDelete) {
                if ([view alpha]==0.5) {
                    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Do you want cancel downloading?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
                    [errorAlert show];
                    [errorAlert release];
                    return;
                }
            }
        }
    }
    
}

-(void)deleteAction:(id)sender
{
    int buttonTag=[(UIButton *)sender tag];
    NSLog(@"%@",[allPdfs objectAtIndex:buttonTag+1000000]);
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	[fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:[allPdfs objectAtIndex:buttonTag+1000000]] error:NULL];
	//BOOL fileExists = [fileManager fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:[allPdfs objectAtIndex:buttonTag+1000000]]];
    allPdfs=[self getPDFS];
    [listOfPdfsDelete reloadData];
    
    
    [self loadScrollViewContents]; 
}


-(void)removeAction:(id)sender
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:self.pdfPathForDelete error:NULL];
    if ([[self getPDFS] count]==0) {
        [objc_getAssociatedObject(self.view, @"deleteB") setHidden:YES];
    }
	BOOL fileExists = [fileManager fileExistsAtPath:self.pdfPathForDelete];
	//int buttonTag=[(UIButton *)sender tag];
	UIView *contentView=[scrollview viewWithTag:selViewButtonIndex+50];
	UIButton *costButton = [contentView viewWithTag:selViewButtonIndex-50];
	
	//[costButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
	[costButton addTarget:self action:@selector(Downloading:) forControlEvents:UIControlEventTouchUpInside];
	NSString *strFileName = [NSString stringWithFormat:@"%@__%@/%@.pdf",book.Name,book.IDValue,book.Name];
	if([appDelegate checkFileExist:strFileName])
	{
		//[costButton setBackgroundImage:[UIImage imageNamed:@"read.png"] forState:UIControlStateNormal];
		[costButton setTitle:@"Read" forState:UIControlStateDisabled];
		book.IsDownloading_Or_Downloaded = YES;
		//readpath = [[NSBundle mainBundle]pathForResource:@"read" ofType:@"png"];
		//					readimg=[NSData dataWithContentsOfFile:readpath];
	}
	else 
	{
		purchasecheck = [book.Purchased intValue];
		NSLog(@"downloading book product id===>%@",book.ItunesProductID);
		if(purchasecheck == 1)
		{
			//[costButton setBackgroundImage:[UIImage imageNamed:@"Buy-Now1.png"] forState:UIControlStateNormal];
            [costButton setTitle:@"BUY NOW" forState:UIControlStateNormal];
			
		}
		else
		{
			//[costButton setBackgroundImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
            [costButton setTitle:@"DOWNLOAD" forState:UIControlStateNormal];
		}
	}
	//[strFileName release];
	//costButton.tag = 800+i;
	//costButton.titleLabel.textColor = [UIColor whiteColor];
	//costButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
	//costButton.titleLabel.shadowColor = [UIColor grayColor];
	//[contentView addSubview:costButton];
	//[costButton release];
	
	//[contentView release];
	if (!fileExists) {
		
		book.IsDownloading_Or_Downloaded=NO;
		for(UIView *subview in selBookView.subviews)
		{
			[subview removeFromSuperview];
		}
		[selBookView removeFromSuperview];
		[self.view addSubview:selBookView];
		NSString * descriptionUrl = [NSString stringWithFormat:@"%@/api/read?action=detailbook&authKey=%@&bookId=%d",serverIP,appDelegate.loginAuthKey,selectedBookIndex];
		[self createDiscriptionView:descriptionUrl];
		
	}
	
}

-(void)loginInPurchase
{
	
	[downloadingOverlayView setHidden:FALSE];
	
	
	
	
	UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Please Login!" message:@"\n \n \n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	[alertview setTag:3];
	// Adds a username Field
	textfieldName = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)]; textfieldName.placeholder = @"Username";
	[textfieldName setBackgroundColor:[UIColor whiteColor]]; [alertview addSubview:textfieldName];
	textfieldName.keyboardType = UIKeyboardTypeAlphabet;
	textfieldName.keyboardAppearance = UIKeyboardAppearanceAlert;
	textfieldName.autocorrectionType = UITextAutocorrectionTypeNo;
	
	// Adds a password Field
	textfieldPassword = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 80.0, 260.0, 25.0)]; textfieldPassword.placeholder = @"Password";
	[textfieldPassword setSecureTextEntry:YES];
	[textfieldPassword setBackgroundColor:[UIColor whiteColor]]; [alertview addSubview:textfieldPassword];
	textfieldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
	textfieldPassword.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	textfieldPassword.keyboardAppearance = UIKeyboardAppearanceAlert;
	textfieldPassword.autocorrectionType = UITextAutocorrectionTypeNo;
	textfieldPassword.secureTextEntry = YES;
	// Move a little to show up the keyboard
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0.0, 80.0);
	[alertview setTransform:transform];
	
	// Show alert on screen.
	[alertview show];
	[alertview release];
	
	//...
	
	// Don't forget to release these after getting their values
	//[utextfield release];
	//[ptextfield release];
	
}

- (void) _showAlert:(NSString*)title comment:(NSString *)comment

{
	
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:comment delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	
	[alertView show];
	
	[alertView release];
	
}




//
//- (void)requestProUpgradeProductData
//{
//	NSSet *productIdentifiers = [NSSet setWithObject:kInAppPurchaseProUpgradeProductId ];
//	productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
//	productsRequest.delegate = self;
//	[productsRequest start];
//	
//	// we will release the request object in the delegate callback
//}
//
//#pragma mark -
//#pragma mark SKProductsRequestDelegate methods
//
//- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
//{
//	NSArray *products = response.products;
//	proUpgradeProduct = [products count] == 1 ? [[products objectAtIndex:0] retain] : nil;
//	//[downloadingOverlayView setHidden:TRUE];
//	if (proUpgradeProduct)
//	{
//		NSLog(@"Product title: %@" , proUpgradeProduct.localizedTitle);
//		NSLog(@"Product description: %@" , proUpgradeProduct.localizedDescription);
//		NSLog(@"Product price: %@" , proUpgradeProduct.price);
//		NSLog(@"Product id: %@" , proUpgradeProduct.productIdentifier);
//		
//		//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"title:%@, desc:%@, price:%@, id:%@",proUpgradeProduct.localizedTitle,proUpgradeProduct.localizedDescription,proUpgradeProduct.price,proUpgradeProduct.productIdentifier] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
//		//[alert show]; 
//		//[alert release];
//		
//	}
//	
//	for (NSString *invalidProductId in response.invalidProductIdentifiers)
//	{
//		NSLog(@"Invalid product id: %@" , invalidProductId);
//		
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Unable to purchase the book with id : %@",invalidProductId] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
//		[alert show]; 
//		[alert release];
//		
//		[downloadingOverlayView setHidden:TRUE];
//		
//		
//	}
//	
//	// finally release the reqest we alloc/init’ed in requestProUpgradeProductData
//	[productsRequest release];
//	
//	//[[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
//}
//
//
//- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
//{
//	
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"ERROR : %@" , [error description] ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
//	[alert show]; 
//	[alert release];
//	[downloadingOverlayView setHidden:TRUE];
//}
//
//
//- (void)requestDidFinish:(SKRequest *)request
//{
//	
//	
//}
//
//
//#pragma -
//#pragma Public methods
//
////
//// call this method once on startup
////
//- (void)loadStore
//{
//	// restarts any purchases if they were interrupted last time the app was open
//	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//	
//	// get the product description (defined in early sections)
//	[self requestProUpgradeProductData];
//}

//
// call this before making a purchase
//
//- (BOOL)canMakePurchases
//{
//	return [SKPaymentQueue canMakePayments];
//}
//
////
//// kick off the upgrade transaction
////
//- (void)purchaseProUpgrade
//{
//	SKPayment *payment = [SKPayment paymentWithProductIdentifier:kInAppPurchaseProUpgradeProductId];
//	[[SKPaymentQueue defaultQueue] addPayment:payment];
//}
//
//#pragma -
//#pragma Purchase helpers
//
////
//// saves a record of the transaction by storing the receipt to disk
////
//- (void)recordTransaction:(SKPaymentTransaction *)transaction
//{
//	if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseProUpgradeProductId])
//	{
//		// save the transaction receipt to disk
//		[[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceipt" ];
//		[[NSUserDefaults standardUserDefaults] synchronize];
//	}
//}
//
////
//// enable pro features
////
//- (void)provideContent:(NSString *)productId
//{
//	//if ([productId isEqualToString:kInAppPurchaseProUpgradeProductId])
//	{
//		// enable the pro features
//		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isProUpgradePurchased" ];
//		[[NSUserDefaults standardUserDefaults] synchronize];
//		
//		//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Would you like to read the book you just purchased ?"] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil]; 
//		//[alert show]; 
//		//[alert release];
//		
//		NSString * setOrderInfoUrl = [NSString stringWithFormat:@"%@/api/read?action=setorderinfo&authKey=%@&bookId=%d",serverIP,appDelegate.loginAuthKey,selectedBookIndex];
//		NSURL *url = [[NSURL alloc] initWithString:setOrderInfoUrl];
//		NSLog(@"###### providecontent %@",url);
//		NSData *data = [[NSData alloc]initWithContentsOfURL:url];
//		
//		NSString * str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//		if ([str rangeOfString:@"<IsSuccess>1"].location !=NSNotFound) {
//			downloading_Progress = FALSE;
//		}
//		else {
//			// There may be problem in purchase  
//		}
//		
//		downloading_Progress = FALSE;
//		
//		
//		
//		[downloadingOverlayView setHidden:TRUE];
//	}
//}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([[alertView message] isEqualToString:@"Do you want cancel downloading?"]) {
        if ([title isEqualToString:@"YES"]) {
            BookDetails *book = [sortedArray objectAtIndex:CurrentIndex];
            book.IsDownloading_Or_Downloaded = NO;
            [self loadScrollViewContents];
            downloadedLength=0.0;
            self.downloadingFileName=nil;
            [file closeFile];
            file=nil;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [downloadBookConnection release];
            downloadBookConnection=nil;
            NSLog(@"the Downloading Over");
            IsDownload = NO;
            downloading_Progress = FALSE;
            ISFirstTimeDownloading=YES;
            for (UIView *view in self.view.subviews) {
                if (view!=listOfPdfsDelete) {
                    if (![NSStringFromCGRect(view.frame) isEqualToString:NSStringFromCGRect(CGRectMake(0, 235.0*appDelegate.screenHeight1/480, 768.0*appDelegate.screenWidth1/768, 25.0*appDelegate.screenHeight1/480))]) {
                        view.userInteractionEnabled=YES;
                        view.alpha=1.0;
                    }
                    
                }
            }
        }
        else{
            listOfPdfsDelete.hidden=NO;
        }
        return;
    }
    if ([[alertView message]isEqualToString:@"Would you like to delete already downloaded book for continue downloading?"]) {
        if ([title isEqualToString:@"YES"]) {
            //BookDetails *book = [sortedArray objectAtIndex:CurrentIndex];
            listOfPdfsDelete.hidden=NO;
            for (UIView *view in self.view.subviews) {
                if (view!=listOfPdfsDelete) {
                    if (![NSStringFromCGRect(view.frame) isEqualToString:NSStringFromCGRect(CGRectMake(0, 235.0*appDelegate.screenHeight1/480, 768.0*appDelegate.screenWidth1/768, 25.0*appDelegate.screenHeight1/480))]) {
                        view.userInteractionEnabled=NO;
                        view.alpha=0.5;
                    }
                    
                }
            }
            return;
        }
        else{
            BookDetails *book = [sortedArray objectAtIndex:CurrentIndex];
            book.IsDownloading_Or_Downloaded = NO;
            [self loadScrollViewContents];
            downloadedLength=0.0;
            self.downloadingFileName=nil;
            [file closeFile];
            file=nil;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [downloadBookConnection release];
            downloadBookConnection=nil;
            NSLog(@"the Downloading Over");
            IsDownload = NO;
            downloading_Progress = FALSE;
            ISFirstTimeDownloading=YES;
            for (UIView *view in self.view.subviews) {
                if (view!=listOfPdfsDelete) {
                    if (![NSStringFromCGRect(view.frame) isEqualToString:NSStringFromCGRect(CGRectMake(0, 235.0*appDelegate.screenHeight1/480, 768.0*appDelegate.screenWidth1/768, 25.0*appDelegate.screenHeight1/480))]) {
                        view.userInteractionEnabled=YES;
                        view.alpha=1.0;
                    }
                    
                }
            }
        }
        return;
        
    }
    
    
    
	
	if (alertView.tag == 3) {
		if (buttonIndex != [alertView cancelButtonIndex])
		{
			NSLog(@"Name: %@", textfieldName.text);
			NSLog(@"Name: %@", textfieldPassword.text);
			
			
			NSString * fileUrl = [NSString stringWithFormat:@"%@/api/read?",serverIP];
			fileUrl = [fileUrl stringByAppendingFormat:@"action=login&emailAddress=%@&password=%@",textfieldName.text,textfieldPassword.text ];
			
			
			NSURL *url = [[NSURL alloc] initWithString:fileUrl];
			//[fileUrl release];
			NSLog(@"###### send user detail %@",url);
			NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
			
			//Initialize the delegate.
			UserXMLParser *userDetailParser = [[UserXMLParser alloc]initXMLParser];
			
			//Set delegate
			[xmlParser setDelegate:userDetailParser];
			
			//Start parsing the XML file.
			BOOL success = [xmlParser parse];
			[xmlParser release];
			xmlParser=nil;
			//Set delegate
			//Start parsing the XML file.
			
			if(success)
			{
				if(appDelegate.isValidLoginOrReg){
					NSString *str = [NSString stringWithFormat:@"%@",appDelegate.userDetails] ;
					NSLog(@"loginAuthKey %@",str);
					appDelegate.loginAuthKey =[NSString stringWithFormat:@"%@",str] ;
					appDelegate.isValidLoginOrReg = NO;
					
					[appDelegate LoadAllBooksData:FALSE];
					UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Login Success" message:@"Now you can read your books" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
					[errorAlert show];
					[errorAlert release];
					
				}else {
					NSString *str =[NSString stringWithFormat:@"%@", appDelegate.errorDetails] ;
					NSLog(@"loginAuthKey %@",str);
					UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"login Error" message:str  delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
					[errorAlert show];
					[errorAlert release];
				}
				
			}
			else{
				UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Internet Unavailable" message:@"You Must be connected to Internet to view this link"  delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
				[errorAlert show];
				[errorAlert release];
			}
			[userDetailParser release];
			[xmlParser release];
			
		}
		else {
			[downloadingOverlayView setHidden:TRUE];
		}
		
		
	}
	else if(alertView.tag == 200)
	{
		//Do Nothing For 
	}
	else
	{
		if(buttonIndex==1)
		{
			
			Book* book = [[[Shelf sharedShelf] books] objectAtIndex: selectedBookIndex+1];
			
			BookIndexViewController* bookIndexViewController = [[[BookIndexViewController alloc] initWithBook: book] autorelease];
			
			UINavigationController* navigationController = [[[UINavigationController alloc] initWithRootViewController: bookIndexViewController] autorelease];
			if (navigationController != nil) {
				[self presentModalViewController: navigationController animated: YES];
			}
		}
		else {
			NSLog(@"clickedButtonAtIndex ");
			[downloadingOverlayView setHidden:TRUE];
		}
		
		
		
	}
	
	
	
	
}
//
// removes the transaction from the queue and posts a notification with the transaction result
//
//- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
//{
//	// remove the transaction from the payment queue.
//	[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//	
//	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
//	if (wasSuccessful)
//	{
//		// send out a notification that we’ve finished the transaction
//		//    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
//		
//		//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"transaction success : " ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
//		//[alert show]; 
//		//[alert release];
//	}
//	else
//	{
//		// send out a notification for the failed transaction
//		//  [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
//		
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Transaction failed : %@", transaction.payment.productIdentifier ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
//		[alert show]; 
//		[alert release];
//		
//	}
//	[downloadingOverlayView setHidden:TRUE];
//}
//
////
//// called when the transaction was successful
////
//- (void)completeTransaction:(SKPaymentTransaction *)transaction
//{
//	[self recordTransaction:transaction];
//	[self provideContent:transaction.payment.productIdentifier];
//	[self finishTransaction:transaction wasSuccessful:YES];
//	//[downloadingOverlayView setHidden:TRUE];
//}
//
////
//// called when a transaction has been restored and and successfully completed
////
//- (void)restoreTransaction:(SKPaymentTransaction *)transaction
//{
//	[self recordTransaction:transaction.originalTransaction];
//	[self provideContent:transaction.originalTransaction.payment.productIdentifier];
//	[self finishTransaction:transaction wasSuccessful:YES];
//	//[downloadingOverlayView setHidden:TRUE];
//}

//
// called when a transaction has failed
//
//- (void)failedTransaction:(SKPaymentTransaction *)transaction
//{
//	if (transaction.error.code != SKErrorPaymentCancelled)
//	{
//		// error!
//		[self finishTransaction:transaction wasSuccessful:NO];
//	}
//	else
//	{
//		// this is fine, the user just cancelled, so don’t notify
//		[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//	}
//	[downloadingOverlayView setHidden:TRUE];
//}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
//- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
//{
//	for (SKPaymentTransaction *transaction in transactions)
//	{
//		
//		//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"transaction state: %d",transaction.transactionState ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
//		//	[alert show]; 
//		//	[alert release];
//		
//		switch (transaction.transactionState)
//		{
//			case SKPaymentTransactionStatePurchased:
//				[self completeTransaction:transaction];
//				break;
//			case SKPaymentTransactionStateFailed:
//				[self failedTransaction:transaction];
//				break;
//			case SKPaymentTransactionStateRestored:
//				[self restoreTransaction:transaction];
//				break;
//			default:
//				break;
//		}
//	}
//}


//
//// Sent when transactions are removed from the queue (via finishTransaction:).
//- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
//{
//	
//}
//
//// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
//- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
//{
//	
//}
//
//// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
//- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue 
//{
//	
//}
-(void)actionSheetAction{
	
    NSLog(@"inside actionsheet");
    aSheet=[[UIActionSheet alloc]initWithTitle:nil 
                              delegate:self 
                              cancelButtonTitle:@"Cancel" 
                              destructiveButtonTitle:nil 
                              otherButtonTitles:@"Tell a Friend",@"Tweet This",@"Facebook",@"Other Apps",@"",nil];
      
    [aSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    
    UIButton *notifc;
    if(appDelegate.screenWidth1 == 320)
       notifc  = [[UIButton alloc]initWithFrame:CGRectMake(45, 238, 140, 38)];
    else
    {
      notifc  = [[UIButton alloc]initWithFrame:CGRectMake(30, 200, 140, 38)];
    }
    
    [notifc setBackgroundColor:[UIColor clearColor]];
    [notifc setTitle:@"Notification" forState:UIControlStateNormal];
    [notifc setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [notifc setFont:[UIFont boldSystemFontOfSize:22]];
    [aSheet addSubview:notifc];
    
    if(appDelegate.screenWidth1 == 320)
        firstNotify = [[UISwitch alloc]initWithFrame:CGRectMake(182, 242, 137, 38)];
    else
    {
        NSLog(@"inside actionsheet12");
        firstNotify = [[UISwitch alloc]initWithFrame:CGRectMake(165, 205, 137, 38)];
    }
    
    [firstNotify addTarget:self action:@selector(SwitchOn:) forControlEvents:UIControlEventTouchUpInside];
    [firstNotify setTag:90];
    [firstNotify setOn:appDelegate.IsEnabledLinks];
    [aSheet addSubview:firstNotify];
    
    [aSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    
    if(appDelegate.screenWidth1 == 320)
        [aSheet setBounds:CGRectMake(0,0,320,380)];
    else    
    {
        NSLog(@"inside actionsheet13");
        [aSheet setFrame:CGRectMake(0,0,320,650)];
    }   
	
	//[aSheet release];
	
	
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	
	if(buttonIndex ==0)
	{
		[self emailact];
		
	}else if(buttonIndex ==1)
	{
		//Change For Twitter
		[self openTwitterPage];
		
		
	}
	else if(buttonIndex ==2)
	{
		[self facebtnact];
		
	}
	else if(buttonIndex ==3)
	{
		
		[[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"http://itunes.apple.com/us/artist/alpha-media-group-inc./id393395810"]];
	}
	
}

-(void)SwitchOn:(id)sender
{
	NSLog(@"switchOn...");
	UISwitch *Swt_HighightL = (UISwitch *)[aSheet viewWithTag:90];
	if(Swt_HighightL!=nil)
	{
		if(Swt_HighightL.tag == 90)
		{
			
			if(Swt_HighightL.on)
			{
                appDelegate.ISPushNotification = YES;
				appDelegate.IsEnabledLinks = YES;
				appDelegate.isSwitch=appDelegate.IsEnabledLinks;
				
				[appDelegate.prefs setBool:YES forKey:@"IsEnabledLinks"];
                [appDelegate.prefs setBool:YES forKey:@"ISPushNotification"];
				[appDelegate.prefs synchronize];
				
			}
			else 
			{
                appDelegate.ISPushNotification = NO;
				appDelegate.IsEnabledLinks = NO;
				appDelegate.isSwitch=appDelegate.IsEnabledLinks;
				
				[appDelegate.prefs setBool:NO forKey:@"IsEnabledLinks"];
                [appDelegate.prefs setBool:NO forKey:@"ISPushNotification"];
				[appDelegate.prefs synchronize];
			}
		}
	}
}

-(IBAction)emailact{
	
	MFMailComposeViewController *controller= [[MFMailComposeViewController alloc] init];
	
	
	controller.mailComposeDelegate = self;
	
    [controller setSubject:@"I hooked up my phone with the GraffitiSprayCan Dash App. Check it."];	
	//	UIImage *roboPic = [self getphotofrompaint];//[UIImage imageWithContentsOfFile:dataFilePath];
	//	NSData *imageData = UIImagePNGRepresentation(roboPic);
	// 	[controller addAttachmentData:imageData mimeType:@"image/png" fileName:@"concreteImmortalz.png"];
	NSString *emailBody = @"http://itunes.apple.com/us/artist/alpha-media-group-inc./id393395810";
	[controller setMessageBody:emailBody isHTML:NO]; 
	//UIImage  *img  = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Fol3Image2" ofType:@"jpg"]];
	//NSData *dataObj = UIImageJPEGRepresentation(img, 1.0);
	
	
	//[controller addAttachmentData:dataObj mimeType:@"image/jpg" fileName:@"HDWallpaper"];
	
	if(controller!=nil){
        [self presentModalViewController:(UIViewController*)controller animated:YES];
	}
    //[img release];
	[controller release];
	
	
	
}
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
	[self.view setHidden:FALSE];
	if(result==MFMailComposeResultSent){
		UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Mail Sent" 
												  message:nil 
												 delegate:self 
										cancelButtonTitle:@"OK" 
										otherButtonTitles:nil];
		[fb show];
		[fb release];
	}
	else if(result==MFMailComposeResultCancelled){
		UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Mail Cancelled" 
												  message:nil 
												 delegate:self 
										cancelButtonTitle:@"OK" 
										otherButtonTitles:nil];
		[fb show];
		[fb release];
	}
	else if(result==MFMailComposeResultFailed){
		UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Mail Failed" 
												  message:nil 
												 delegate:self 
										cancelButtonTitle:@"OK" 
										otherButtonTitles:nil];
		[fb show];
		[fb release];
	}
	
	
}
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return nil;//[[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	NSLog(@"Authenicated for %@", username);
	//NSLog(@"twitterText for %@", twitterText);
	[_engine sendUpdate: [NSString stringWithFormat:@"%@",twitterTextField.text]];
	[twitterTextField release];
	twitterTextField = nil;
}
- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Failed!");
	UIAlertView *status=[[UIAlertView alloc]initWithTitle:@"Twitter Authentication Failed!" 
												  message:nil 
												 delegate:self 
										cancelButtonTitle:@"OK" 
										otherButtonTitles:nil];
	[status show];
	[status release];
	[self dismissModalViewControllerAnimated:YES];
	[topBar removeFromSuperview];
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Canceled.");
	UIAlertView *status=[[UIAlertView alloc]initWithTitle:@"Twitter Authentication Canceled" 
												  message:nil 
												 delegate:self 
										cancelButtonTitle:@"OK" 
										otherButtonTitles:nil];
	[status show];
	[status release];
	[self dismissModalViewControllerAnimated:YES];
    [topBar removeFromSuperview];
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	NSLog(@"Request %@ succeeded", requestIdentifier);
	UIAlertView *status=[[UIAlertView alloc]initWithTitle:@"Tweet posted successfully" 
												  message:nil 
												 delegate:self 
										cancelButtonTitle:@"OK" 
										otherButtonTitles:nil];
	[status show];
	[status release];
	[self dismissModalViewControllerAnimated:YES];
    [topBar removeFromSuperview];
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
    [topBar removeFromSuperview];
}



//=============================================================================================================================
#pragma mark ViewController Stuff

-(void)openTwitterPage
{
    //	[self.navigationController.navigationBar setHidden:NO];
	TwitterOpened = YES;
    //	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Post", @selector(twitteract));
    //	self.navigationItem.leftBarButtonItem = BARBUTTON(@"Back", @selector(action:));
    
    
    
    ////	self.title=@"Tweet This";
	
	twitterView = [[UIView alloc]initWithFrame:CGRectMake(0,0, appDelegate.screenWidth1, appDelegate.screenHeight1)];
	UIImage  *img  = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Twitter" ofType:@"jpg"]];
	UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, appDelegate.screenWidth1, appDelegate.screenHeight1)];
	imageView.image = img;
	
	
	twitterTextField = [[UITextView alloc] initWithFrame:CGRectMake(10,100, appDelegate.screenWidth1-20, 200)];
	
    twitterTextField.textColor = [UIColor blackColor];
	
    twitterTextField.font = [UIFont fontWithName:@"Arial" size:18];
	
    twitterTextField.delegate = self;
	
    twitterTextField.backgroundColor = [UIColor whiteColor];
	twitterTextField.text =@"I hooked up my phone with the GraffitiSprayCan Dash App. Check it.http://itunes.com/apps/zaahtechnologiesinc";
	//  twitterTextField.placeholder = @"Enter Text To Tweet";
	
	//   twitterTextField.returnKeyType = UIReturnKeyDefault;
	
	// twitterTextField.keyboardType = UIKeyboardTypeDefault; 
	
    twitterTextField.scrollEnabled = YES;
	
    twitterTextField.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	
	
	
	[twitterView addSubview:imageView];
	
	
	[twitterView addSubview:twitterTextField];
	
	[self.view addSubview:twitterView];
	//[img release];
	[imageView release];
	
	//[twitterTextField release];
	
	//[twitterView release];
	[self.view addSubview:topBar];
	
}



-(IBAction)twitteract {
	if (![appDelegate isDataSourceAvailable])
	{
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:@"Network Connection Error" 
							  message:@"You need to be connected to the internet to use this feature." 
							  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		alert.delegate=self;
		[alert show];
		[alert release];
	}
	else{
        if ([twitterTextField hasText]==FALSE) {
            UIAlertView *status=[[UIAlertView alloc]initWithTitle:@"Please enter text to tweet" 
                                                          message:nil 
                                                         delegate:self 
                                                cancelButtonTitle:@"OK" 
                                                otherButtonTitles:nil];
            [status show];
            [status release];
            return;
            
        }
        
        TwitterOpened = NO;
        ////	topLabel.text= @"Categories";
        //self.title = @"Categories";
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
        btn.backgroundColor = [UIColor darkGrayColor];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [btn addTarget:self action:@selector(actionSheetAction) forControlEvents:UIControlEventTouchUpInside];
        
        for(UIView *s in twitterView.subviews )
        {
            [s removeFromSuperview];
        }
        
        //[twitterTextField release];
        [twitterView removeFromSuperview];
        [twitterView release];
        
        if (_engine) [_engine release];
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
        _engine.consumerKey = kOAuthConsumerKey;
        _engine.consumerSecret = kOAuthConsumerSecret;
        
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
        
        if (controller) 
            [self presentModalViewController: controller animated: YES];
        else {
            [_engine sendUpdate: [NSString stringWithFormat: @"Already Updated. %@", [NSDate date]]];
        }
	}
	[self.navigationController.navigationBar setHidden:YES];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"]) {
		
		[textView resignFirstResponder];
		
	}
    return YES;
	
}

-(void)action:(id)sender{
    
	if(TwitterOpened ==YES)
	{
        [topBar removeFromSuperview];
        //    [self.navigationController.navigationBar setHidden:YES];
		TwitterOpened =NO;
        ////		topLabel.text= @"Categories";
		//self.title = @"Categories";
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
		[btn addTarget:self action:@selector(actionSheetAction) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = nil;
		for(UIView *s in twitterView.subviews )
		{
			[s removeFromSuperview];
		}
		
		[twitterTextField release];
		twitterTextField = nil;
		[twitterView removeFromSuperview];
		[twitterView release];
		
		
		return;
	}
	
}

-(IBAction)facebtnact
{
	
	_permissions =  [[NSArray arrayWithObjects: @"read_stream",@"user_photos",@"user_videos",@"publish_stream ",nil] retain];
	_facebook = [[Facebook alloc] init];
	
	if(appDelegate.facebookLogin == TRUE)
	{
		appDelegate.facebookLogin = FALSE;
		[_facebook logout:self];
	}
	[_facebook authorize:kAppId permissions:_permissions delegate:self];
	
}


-(void) fbDidLogin 
{
	NSLog(@"did  login");
	
	
	//UIImage  *img  = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Fol3Image2" ofType:@"jpg"]];
	//	NSData *dataObj = UIImageJPEGRepresentation(img, 1.0);
	//	
	//	NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:dataObj, @"picture",
	//									@"my pencil",@"caption",nil];
	//	
	//	
	//	[_facebook requestWithMethodName: @"facebook.photos.upload" 
	//						   andParams: params
	//					   andHttpMethod: @"POST" 
	//						 andDelegate: self]; 
	
	[self publishStream];
	
	
	
	
}

- (void) publishStream{
	
	SBJSON *jsonWriter = [[SBJSON new] autorelease];
	
	NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys: 
														   @"Always Running",@"text",@"http://itsti.me/",@"href", nil], nil];
    
    
    NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *strLink = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Itunes_Link"]];
	
	//NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
	NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
								@"I hooked up my phone with the GraffitiSprayCan Dash App. Check it. ", @"name",strLink,@"caption",nil];//@"http://itunes.com/elitegudz/",@"href", nil];
	NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   kAppId, @"api_key",
								   @"Share on Facebook",@"user_message_prompt",
								   
								   attachmentStr, @"attachment",
								   nil];	    
	
	
	[_facebook dialog: @"stream.publish"
			andParams: params
		  andDelegate:self];
	
}

- (void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"did not login");
	
	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Unable To Login" 
											  message:nil 
											 delegate:self 
									cancelButtonTitle:@"OK" 
									otherButtonTitles:nil];
	[fb show];
	[fb release];
}

/**
 * Callback for facebook logout
 */ 
-(void) fbDidLogout {
	
	//	[_facebook release];
	
	
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Callback when a request receives Response
 */ 
- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response{
	
	NSLog(@"received response  %@",response );
	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Success" 
											  message:@"Your Image Posted" 
											 delegate:self 
									cancelButtonTitle:@"OK" 
									otherButtonTitles:nil];
	[fb show];
	[fb release];
	
}

/**
 * Called when an error prevents the request from completing successfully.
 */
/*- (void)request:(FBRequest*)request didFailWithError:(NSError*)error{
 NSLog(@"%@",error);
 UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Unable To Connect" 
 message:nil 
 delegate:self 
 cancelButtonTitle:@"OK" 
 otherButtonTitles:nil];
 [fb show];
 [fb release];
 
 
 }
 */
/**
 * Called when a request returns and its response has been parsed into an object.
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on thee format of the API response.
 */
- (void)request:(FBRequest*)request didLoad:(id)result {
	
	
	
	NSLog(@"result is ---- %d",result );
	[_facebook logout:self];
	
	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Logged Out" 
											  message:nil 
											 delegate:self 
									cancelButtonTitle:@"OK" 
									otherButtonTitles:nil];
	[fb show];
	[fb release];
}





///////////////////////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/** 
 * Called when a UIServer Dialog successfully return
 */
- (void)dialogDidComplete:(FBDialog*)dialog withPost:(NSString *)currentPostID{
	NSLog(@"feed to delete and %@ rrrr ", currentPostID);
	//[_facebook logout:self];
	
	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Message posted successfully" 
											  message:nil 
											 delegate:self 
									cancelButtonTitle:@"OK" 
									otherButtonTitles:nil];
	[fb show];
	[fb release];
}



@end