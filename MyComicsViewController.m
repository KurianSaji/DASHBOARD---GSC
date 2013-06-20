//
//  MyComicsViewController.m
//  Comic Store
//
//  Created by Zaah Technologies India PVT on 10/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyComicsViewController.h"

#import "Book.h";
#import "BookIndexViewController.h"
#import "Shelf.h"
#import "BookDetails.h"
#import "OneBookDetails.h"
#import "RelatedBookDeatails.h"
#import "BookDetailParser.h";
#import "UserXMLParser.h"
#import "AnimatedGif.h"


#import "ClassicalScrollViewController.h"
//#import "PDFExtracter.h"

#define HORIZ_SWIPE_DRAG_MIN 10 

@implementation MyComicsViewController

@synthesize scrollview,pdfBookIDTemp,pdfPathTemp ;

BOOL _isAbtAuth ;
UIView *_downloadingOverlayView;


NSInteger _nRow;
NSInteger _nCol;
NSInteger _totCnt ;

//PDFExtracter *pdf2Images;

int _selectedBookIndex;
NSString * _selectedbookISBNnumber;
//BOOL _show_All ;
//BOOL _show_Free ;
//BOOL _show_featured;;
//BOOL _show_new   ;
BOOL _downloading_Progress ;

NSMutableArray *_sortedArray;
UIView *_author_Name;
UIView *_downloadingOverlayView;
NSString *author_Name;
NSString *__author_Photo_Url;
NSString *__author_Description;

//For sign up
UITextField *_textfieldName;
UITextField *_textfieldPassword;

NSMutableArray * myBookSortedArray;
NSMutableArray *downloaderStackArray;
BOOL _bookOpenToRead = FALSE;

BOOL viewAppearingFirstTime=TRUE;


UIImageView *imgView1;
UIImageView *imgView2;
UIImageView *imgView3;

UIImageView *tempImageView;


NSMutableArray *loaderObjArray =nil;
NSMutableArray *costButtonObjArray =nil;


int pdfProcessCount=0;
static int ThreadCounter = 0;


CGPoint startTouchPosition;

NSMutableArray *imageArray;
int imagesOffset=0;

BOOL scrollLocked=FALSE;

int zoomOutScale=40;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{ 
	
	if(scrollLocked==TRUE)return;
	
	
	UITouch *touch = [touches anyObject]; 
	startTouchPosition = [touch locationInView:self.view]; 
} 

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	if(scrollLocked==TRUE)return;
	
	UITouch *touch = [touches anyObject]; 
	CGPoint endTouchPosition= [touch locationInView:self.view];
	
	if (fabsf(startTouchPosition.x - endTouchPosition.x) >= HORIZ_SWIPE_DRAG_MIN ) 
	{ 
		// Horizontal Swipe
		if (startTouchPosition.x < endTouchPosition.x) {
			
			if(imagesOffset >0)
			{
				scrollLocked=TRUE;
				
				NSLog(@"right");
				
				tempImageView.frame=CGRectMake(-195, 112, 195, 302);
				
				tempImageView.image=[UIImage imageWithContentsOfFile: [imageArray objectAtIndex:imagesOffset-1]];
				
				[UIView beginAnimations:nil context:nil];
				
				[UIView setAnimationDuration:.8];
				
				tempImageView.frame=CGRectMake(39, 112, 195, 302);//(534, 112, 195, 302);
				
				imgView1.frame=CGRectMake(273, 78, 223, 336);//(-195, 112, 195, 302);
				
				imgView2.frame=CGRectMake(534, 112, 195, 302);
				
				imgView3.frame=CGRectMake(768, 112, 195, 302);
				
				
				
				[UIView commitAnimations];
				
				[self performSelector:@selector(repositionImageViewsRight) withObject:nil afterDelay:1 ];
				
				imagesOffset--;
				
			}
			
			
			
		}
		else 
		{
			if(imagesOffset <[imageArray count]-3)
			{
				scrollLocked=TRUE;
				
				NSLog(@"left");
				
				tempImageView.frame=CGRectMake(768, 112, 195, 302);
				
				tempImageView.image=[UIImage imageWithContentsOfFile: [imageArray objectAtIndex:imagesOffset+3]];
				
				[UIView beginAnimations:nil context:nil];
				
				[UIView setAnimationDuration:.8];
				
				imgView1.frame=CGRectMake(-195, 112, 195, 302);
				
				imgView2.frame=CGRectMake(39, 112, 195, 302);
				
				imgView3.frame=CGRectMake(273, 78, 223, 336);
				
				tempImageView.frame=CGRectMake(534, 112, 195, 302);
				
				[UIView commitAnimations];
				
				[self performSelector:@selector(repositionImageViewsLeft) withObject:nil afterDelay:1 ];
				
				imagesOffset++;
				
			}
			
			
		}
		
	} else {
		if(CGRectContainsPoint(imgView1.frame,endTouchPosition)) {
			
			
		} 
		else if(CGRectContainsPoint(imgView2.frame,endTouchPosition)) {
			
			
		} 
		else if(CGRectContainsPoint(imgView3.frame,endTouchPosition)) {
			
			
		}
		
	}
	
	
	
	
  	
}


-(void)repositionImageViewsRight
{
	
	imgView3.image=imgView2.image;
	imgView2.image=imgView1.image;
	imgView1.image=tempImageView.image;
	
	tempImageView.image=nil;
	
	
	imgView1.frame=CGRectMake(39, 112, 195, 302);
	imgView2.frame=CGRectMake(273, 78, 223, 336);
	imgView3.frame=CGRectMake(534, 112, 195, 302);
	
	tempImageView.frame=CGRectMake(768, 112, 195, 302);
	
	scrollLocked=FALSE;
	
}

-(void)repositionImageViewsLeft
{
	
	imgView1.image=imgView2.image;
	imgView2.image=imgView3.image;
	imgView3.image=tempImageView.image;
	
	tempImageView.image=nil;
	
	
	imgView1.frame=CGRectMake(39, 112, 195, 302);
	imgView2.frame=CGRectMake(273, 78, 223, 336);
	imgView3.frame=CGRectMake(534, 112, 195, 302);
	
	tempImageView.frame=CGRectMake(768, 112, 195, 302);
	
	scrollLocked=FALSE;
	
}






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
	NSLog(@"init MyComicsViewController");
	//self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"StoreBG.png"]];
_isAbtAuth = FALSE;
	//
	_nRow = 2;
	_nCol = 2;
	_totCnt = 4;
	
	//
	_selectedBookIndex=0;
	
	//_show_All = FALSE;
	//	_show_Free = FALSE;
	//	_show_featured = FALSE;
	//	_show_new   = FALSE;
	_downloading_Progress = FALSE;
	if(self = [super init])
	{
		//NSLog(@"%@", [UIFont familyNames]);
		//[self loadAuthorXml];
		
		self.view.backgroundColor = [UIColor blackColor];
		//self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"StoreBG.png"]];
		myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
		myView.backgroundColor = [UIColor clearColor];
		[self.view addSubview:myView];
		
		topToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 768, 44)]; // height was 40
		[topToolBar sizeToFit];
		topToolBar.barStyle = UIBarStyleBlackOpaque;
		topToolBar.hidden = TRUE;
		
		UIImageView * imgview_topBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_bar.png"]];
		imgview_topBar.frame = CGRectMake(0, 0, 768, 44);
		[self.view addSubview:imgview_topBar];
		[imgview_topBar release];
		
		authorView = [[UIView alloc] initWithFrame:CGRectMake(12, 44, 745, 290)];//(0, 40, 768, 328)];
		authorView.backgroundColor =[UIColor clearColor];// [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_mainheader.png"]];
		//[myView addSubview:authorView];
		
		
		imgView1 =[[UIImageView alloc]initWithFrame:CGRectMake(39, 112, 195, 302)];
		imgView2=[[UIImageView alloc]initWithFrame:CGRectMake(273, 78, 223, 336)];
		imgView3 =[[UIImageView alloc]initWithFrame:CGRectMake(534, 112, 195, 302)];
		
		tempImageView=[[UIImageView alloc]initWithFrame:CGRectMake(768, 112, 195, 302)];
		
		imgView1.backgroundColor=[UIColor blackColor];
		imgView2.backgroundColor=[UIColor blackColor];
		imgView3.backgroundColor=[UIColor blackColor];
		
		//tempImageView.backgroundColor=[UIColor blackColor];
		
		[self.view addSubview:imgView1];
		[self.view addSubview:imgView2];
		[self.view addSubview:imgView3];
		
		[self.view addSubview:tempImageView];
		
		//toptextView = [[UIView alloc] initWithFrame:CGRectMake(0, 330, 768, 35)];
		//toptextView.backgroundColor = [UIColor clearColor];
		//toptextView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MenuBar.png"]];
		/*UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 330, 768, 35)];
		 tmpView.alpha = 1.0;
		 tmpView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MenuBar.png"]];
		 //tmpView.image = [UIImage imageNamed:@"MenuBar.jpeg"];
		 [toptextView addSubview:tmpView];
		 [tmpView release];*/
		
		UIImageView *shinyMenu = [[UIImageView alloc] initWithFrame:CGRectMake(7, 334, 754, 53)];
		shinyMenu.frame = CGRectMake(0, 481, 768, 47);
		shinyMenu.image = [UIImage imageNamed:@"head_mycomics.png"];
		shinyMenu.backgroundColor = [UIColor clearColor];
		[myView addSubview:shinyMenu];
		[shinyMenu release];
		
		//[myView addSubview:toptextView];
		
		segLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 340, 150, 35)];
		segLabel.backgroundColor = [UIColor clearColor];
		segLabel.textColor = [UIColor whiteColor];
		segLabel.font = [UIFont boldSystemFontOfSize:18];
		[myView addSubview:segLabel];
		segLabel.hidden = TRUE;
		NSArray *itemsSeg = [NSArray arrayWithObjects: @"Featured", @"New", @"Free",@"All", nil];
		
		segmentCntrl = [[UISegmentedControl alloc] initWithItems:itemsSeg];
		//segmentCntrl.opaque = YES;
		segmentCntrl.tintColor = [UIColor colorWithRed:125.0/255.0 green:150.0/255.0 blue:180.0/255.0 alpha:1.0];
		segmentCntrl.segmentedControlStyle = UISegmentedControlStyleBar;
		[segmentCntrl setFrame:CGRectMake(254, 5, 250, 26)];
		[segmentCntrl setSelectedSegmentIndex:3];
		[segmentCntrl addTarget:self action:@selector(segmentAction:) 
			   forControlEvents:UIControlEventValueChanged];
		
		scrollview = [[UIScrollView alloc] initWithFrame: CGRectMake(7, 530, 750, 565)];//[[UIScreen mainScreen] bounds]];
		scrollview.backgroundColor = [UIColor clearColor];
		scrollview.scrollEnabled = TRUE;
		scrollview.alwaysBounceVertical = TRUE;
		scrollview.alwaysBounceHorizontal = FALSE;
		scrollview.directionalLockEnabled=YES;
		scrollview.delegate = self;
		[scrollview setContentSize:CGSizeMake(768, 800)];
		[myView addSubview:scrollview];
		
		//Over Lay View 
		if (_downloadingOverlayView ==nil) {
			UIActivityIndicatorView *downloadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
			
			
			downloadingIndicator.frame = CGRectMake(369,497, 30.0, 30.0);
			
			[downloadingIndicator startAnimating];	  
			_downloadingOverlayView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
			[_downloadingOverlayView setAlpha:0.85];
			[_downloadingOverlayView setBackgroundColor:[UIColor grayColor]];
			[self.view  addSubview:_downloadingOverlayView];
			[_downloadingOverlayView addSubview:downloadingIndicator];
			[downloadingIndicator release];
		}
		[_downloadingOverlayView setHidden:TRUE];
		
		
		
		
		// Author popup view
		
		bioView = [[UIView alloc] initWithFrame:CGRectMake(84, 150, 600, 700)];//(100, 150, 600, 470)];//(134, 262, 500, 500)];
		bioView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-back.png"]];
		bioView.hidden = YES;
		
		UIImageView *authorImage = [[UIImageView alloc] initWithFrame:CGRectMake(32, 50, 526, 318)];
		authorImage.image = [UIImage imageNamed:@"bill_header.png"];
		authorImage.backgroundColor = [UIColor clearColor];
		[bioView addSubview:authorImage];
		[authorImage release];
		
		UIImageView *authorBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(32, 368, 526, 304)];
		authorBgImage.image = [UIImage imageNamed:@"bill_back.png"];
		authorBgImage.backgroundColor = [UIColor clearColor];
		[bioView addSubview:authorBgImage];
		[authorBgImage release];
		
		//		UIImageView *titleBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 600, 53)];
		//		titleBar.image = [UIImage imageNamed:@"popup_top_bar.png"];
		//		titleBar.backgroundColor = [UIColor clearColor];
		//		[bioView addSubview:titleBar];
		//		[titleBar release];
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 460, 30)];
		titleLabel.text = @"BILL HYBELS";
		titleLabel.font = [UIFont fontWithName:@"Cochin" size:20];//[UIFont boldSystemFontOfSize:18];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.textColor = [UIColor whiteColor];
		titleLabel.textAlignment = UITextAlignmentCenter;
		[bioView addSubview:titleLabel];
		[titleLabel release];		
		
		UILabel *authorNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 378, 506, 30)];
		authorNameLabel.text = @"BILL HYBELS";
		authorNameLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:18];//[UIFont boldSystemFontOfSize:18];
		authorNameLabel.backgroundColor = [UIColor clearColor];
		authorNameLabel.textColor = [UIColor blackColor];
		authorNameLabel.textAlignment = UITextAlignmentLeft;
		[bioView addSubview:authorNameLabel];
		[authorNameLabel release];		
		
		UIImageView *authImage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 410, 506, 1)];// 20, 125, 200, 200)];
		//authImage.image = [UIImage imageNamed:@"img_billhybelsphoto.png"];
		[authImage setBackgroundColor:[UIColor darkGrayColor]];
		[bioView addSubview:authImage];
		[authImage release];
		
		
		UITextView *biography = [[UITextView alloc] initWithFrame:CGRectMake(37, 415, 518, 270)];
		biography.font = [UIFont systemFontOfSize:14];
		biography.textAlignment = UITextAlignmentLeft;
		biography.backgroundColor = [UIColor clearColor];
		biography.textColor = [UIColor blackColor];
		biography.editable=FALSE;
		biography.text = @"Bill Hybels is the founding and senior pastor of Willow Creek Community Church in South Barrington, Ill., and chairman of the board for the Willow Creek Association. The bestselling author of more than twenty books, including Axiom, Holy Discontent, Just Walk Across the Room, The Volunteer Revolution, Courageous Leadership, and classics such as Too Busy Not to Pray and Becoming a Contagious Christian, Hybels is known worldwide as an expert in training Christian leaders to transform individuals and their communities through the local church. Hybels received a bachelor’s degree in Biblical Studies and an honorary Doctorate of Divinity from Trinity College in Deerfield, Ill. He and his wife, Lynne, have two adult children and one grandson, Henry. ";
		[bioView addSubview:biography];
		[biography release];
		
		//		UILabel *bioLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 415, 506, 180)];
		//		bioLabel.text = @"Bill Hybels is the founding and senior pastor of Willow Creek Community Church in South Barrington, Ill., and chairman of the board for the Willow Creek Association. The bestselling author of more than twenty books, including Axiom, Holy Discontent, Just Walk Across the Room, The Volunteer Revolution, Courageous Leadership, and classics such as Too Busy Not to Pray and Becoming a Contagious Christian, Hybels is known worldwide as an expert in training Christian leaders to transform individuals and their communities through the local church. Hybels received a bachelor’s degree in Biblical Studies and an honorary Doctorate of Divinity from Trinity College in Deerfield, Ill. He and his wife, Lynne, have two adult children and one grandson, Henry.";
		//		bioLabel.numberOfLines = 0;
		//		bioLabel.font = [UIFont systemFontOfSize:14];
		//		[bioLabel setBackgroundColor:[UIColor clearColor]];
		//		[bioView addSubview:bioLabel];
		//		[bioLabel release];
		
		UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0+18, 0, 55, 35)];
		[backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
		backButton.clipsToBounds = NO;
		[backButton addTarget:self action:@selector(backAction:) 
			 forControlEvents:UIControlEventTouchUpInside];
		backButton.hidden = NO;
		[bioView addSubview:backButton];
		[backButton release];
		
		UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(560, 0, 35, 35)];
		[closeButton setImage:[UIImage imageNamed:@"icon_close.png"] forState:UIControlStateNormal];
		closeButton.clipsToBounds = NO;
		[closeButton addTarget:self action:@selector(closeAction:) 
			  forControlEvents:UIControlEventTouchUpInside];
		closeButton.hidden = NO;
		[bioView addSubview:closeButton];
		[closeButton release];
		
		[myView addSubview:bioView];
		
		
		/* selected book's popup view */
		
		selBookView = [[UIView alloc] initWithFrame:CGRectMake(84, 150, 600, 700)];
		selBookView.hidden = YES;
		selBookView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-back.png"]];
		//selBookView.backgroundColor = [UIColor clearColor];
		[myView addSubview:selBookView];
		
		//[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
		[self reloadToolBar];
		
		appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
		
		/*if(booksArray != nil)
		 {
		 [booksArray removeAllObjects];
		 [booksArray release];
		 }*/
		
		//booksArray = [appDelegate getBookDetails];
		
		printf("\n books count is:: %d", [booksArray count]);
		[self getPurchasedBookList]; 
		[self loadScrollView];
			
		//[self loadAuthorView];
		
	}	
	_bookOpenToRead = FALSE;
	return self;
}

#pragma mark -
#pragma mark View lifecycle

/*
 - (void)viewDidLoad {
 [super viewDidLoad];
 
 // Uncomment the following line to preserve selection between presentations.
 self.clearsSelectionOnViewWillAppear = NO;
 
 // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
 // self.navigationItem.rightBarButtonItem = self.editButtonItem;
 }
 */

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];	
	
	
	if (appDelegate.loginAuthKey ==nil ||[appDelegate.loginAuthKey isEqualToString:@""]) {
		for(UIView *subview in scrollview.subviews)
		{
			[subview removeFromSuperview];
		}
		//[self loadHeaderView];
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Sign In" message:@"Please Sign In to your account, to view your books." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
		errorAlert.tag = 5;
		[errorAlert show];
		[errorAlert release];
		
			return;
	}
	
	//if(appDelegate.bookPurchased==FALSE && viewAppearingFirstTime==FALSE)return;
	
	
	
	
	if (appDelegate.bookPurchased ==TRUE) {
		
		appDelegate.bookPurchased =FALSE;
		@try {
			[appDelegate.bookListArray removeAllObjects];
			[appDelegate.booksDetailsArray removeAllObjects];
			[appDelegate.bookListArray release];
			[appDelegate.booksDetailsArray release];
			
			[appDelegate LoadAllBooksData:segmentCntrl.selectedSegmentIndex];
		}
		@catch (NSException * e) {
			
		}


		
		_bookOpenToRead = FALSE;
	}
	if (_bookOpenToRead ==FALSE) {
		
		[self getPurchasedBookList]; 
		[self loadScrollView];
		if ([downloaderStackArray count]>0) {
    
			for (int k =0; k<[downloaderStackArray count]; k++) {
				
		        [NSThread detachNewThreadSelector:@selector(DownloadEpubBooks:) toTarget:self withObject:[downloaderStackArray objectAtIndex:k]];
				
			}
		}
		_bookOpenToRead = TRUE;
	}
	else {
		//_bookOpenToRead = FALSE;
	}
	if ([loaderObjArray count]>0) {
		for (int k =0;k<[loaderObjArray count]; k++) {
			UIImageView * img = (UIImageView*)[loaderObjArray objectAtIndex:k];
			[img startAnimating];
		}
		
	}
	//viewAppearingFirstTime=FALSE;
}


// Content View has been given the index as tag no .
// and all the imageview have been given with 21 as tag no to have identification .

-(void)DownloadEpubBooks:(NSString *)UrlWithIndex
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSLog(@"Epub Url %@",UrlWithIndex);
	/***********  Parse The Index ***********/
	NSRange end = [UrlWithIndex rangeOfString: @"##$##"];
	int lenght =  [UrlWithIndex length]; 
	lenght = lenght -(end.location+end.length);
	NSString *indexStr = [UrlWithIndex substringWithRange: NSMakeRange (end.location+end.length,lenght)];
	int index = [indexStr intValue];
	
	/***********  Parse Url and BookName ***********/
	UrlWithIndex = [UrlWithIndex substringWithRange:NSMakeRange(0,end.location)];
	NSString *bookName = [UrlWithIndex lastPathComponent];
	NSString *fileUrl = [UrlWithIndex stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@",bookName] withString:@""];
	NSString *ISBN_number = [fileUrl lastPathComponent]; 
	bookName =[bookName stringByReplacingOccurrencesOfString:@"-" withString:@" "];
	
	NSLog(@"ISBN_number  %@",ISBN_number);
	
	/***********  Download Book ***********/
	
	NSURL * bookURL = [[NSURL alloc]initWithString:UrlWithIndex];
	//bookURL =[[NSURL alloc]initWithString:@"http://www.test.com/text2.pdf"];
	NSString * filename = [NSString stringWithFormat:@"/%@",ISBN_number];  // no need to give .epub here 
	
	//NSData *epubBookData = [[NSData alloc]initWithContentsOfURL:bookURL];
	//	NSURL * bookURL1 = [[NSURL alloc]initWithString:@"http://122.183.249.152/comicstory/epub/upload/cover/large/12.jpg"]; //@"http://www.concreteimmortalz.com/comicstore/45.pdf"];
	//NSData *epubBookData [[NSData alloc]initWithContentsOfURL:bookURL1 options:NSUTF8StringEncoding error:&err1];
	
	//www.themasterplanner.com/MP-sampler.pdf
	
	
	
	
    
	NSData *epubBookData =[[NSData alloc]initWithContentsOfURL:bookURL];
	if (epubBookData!=nil) {
		/*********** save Book  **************/
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:filename] retain];
		[[ NSFileManager defaultManager] createDirectoryAtPath:dataFilePath attributes:nil];
		dataFilePath = [dataFilePath stringByAppendingString:[NSString stringWithFormat:@"/%@",bookName]];
		NSLog(@"File Writed in %@",dataFilePath);
		[epubBookData writeToFile:dataFilePath atomically:YES];
		
		/*
		
		pdf2Images = [[PDFExtracter alloc]init];
		
		pdf2Images.pdfPath= [NSString stringWithFormat:@"%@", dataFilePath];
		pdf2Images.pdfBookID=[NSString stringWithFormat:@"%@", ISBN_number];
		
		*/
		
		 //self.pdfPathTemp=[NSString stringWithFormat:@"%@", dataFilePath];
		// self.pdfBookIDTemp=[NSString stringWithFormat:@"%@", ISBN_number];
		
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		[prefs setObject:dataFilePath forKey:ISBN_number];
			//self.pdfPath = [prefs stringForKey:self.string_bookId];
		[prefs synchronize];
		
		//[prefs release];
		
		
		
		//[self presentModalViewController:pdf2Images animated:YES];
		
		//[self performSelectorOnMainThread:@selector(pdfProcess1:) withObject:[NSString stringWithFormat:@"%@$###$%@", dataFilePath,ISBN_number] waitUntilDone:FALSE];
	//	if(pdfProcessCount==0)
//		{
//			pdfProcessCount=1;
//		[self performSelectorOnMainThread:@selector(pdfProcess1:) withObject:[NSString stringWithFormat:@"%@$###$%@", dataFilePath,ISBN_number] waitUntilDone:FALSE];
//		}
//		
//		else  if(pdfProcessCount==1)
//		{
//			pdfProcessCount=2;
//			[self performSelectorOnMainThread:@selector(pdfProcess2:) withObject:[NSString stringWithFormat:@"%@$###$%@", dataFilePath,ISBN_number] waitUntilDone:FALSE];
//		}
//		else  if(pdfProcessCount==2)
//		{
//			pdfProcessCount=3;
//			[self performSelectorOnMainThread:@selector(pdfProcess3:) withObject:[NSString stringWithFormat:@"%@$###$%@", dataFilePath,ISBN_number] waitUntilDone:FALSE];
//		}
//		else 		if(pdfProcessCount==3)
//		{
//				pdfProcessCount=1;
//			[self performSelectorOnMainThread:@selector(pdfProcess4:) withObject:[NSString stringWithFormat:@"%@$###$%@", dataFilePath,ISBN_number] waitUntilDone:FALSE];
//		}
		
		
		
		
		//[pdf2Images release];
		
		
		
		
		//[[Shelf sharedShelf] createBookFromCatalogEntry: epubBookData Name:[NSString stringWithFormat:@"%@.epub",bookName]];
		//	[epubBookData release];
		
		
		/***********  Loader Bar Disable ***********/
		
		
		//if(0)
		{
		
		UIView *contentView1= [scrollview viewWithTag:index+1];
		UIImageView *loader = [contentView1 viewWithTag:25];
		UIButton *costButton = [contentView1 viewWithTag:786];
		[loader setHidden:TRUE];
		[costButton setTitle:@"READ" forState:UIControlStateNormal];
		contentView1.userInteractionEnabled = TRUE;
			
		}
	}
	else
	{
		// Download Failed
		NSLog(@"Download Failed %@",bookName);
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Download Book" message:@"You must be connected to Internet to download this book" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
		
		UIView *contentView1= [scrollview viewWithTag:index+1];
		UIImageView *loader = [contentView1 viewWithTag:25];
		UIButton *costButton = [contentView1 viewWithTag:786];
		[loader setHidden:TRUE];
		[costButton setTitle:@"RESUME" forState:UIControlStateNormal];
		contentView1.userInteractionEnabled = TRUE;
		
	}
    ThreadCounter ++;
	if (ThreadCounter<[downloaderStackArray count]) {
		  [NSThread detachNewThreadSelector:@selector(DownloadEpubBooks:) toTarget:self withObject:[downloaderStackArray objectAtIndex:ThreadCounter]];
	}
	[pool release]; 
	
}
/*

-(void)pdfProcess1:(NSString *)PdfPath_bookId
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSArray *chunks = [PdfPath_bookId componentsSeparatedByString: @"$###$"];
	
	PDFExtracter *pdf2Images = [[PDFExtracter alloc]init];
	
	pdf2Images.pdfPath= [chunks objectAtIndex:0];
	pdf2Images.pdfBookID=[chunks objectAtIndex:1];
	
	[pdf2Images startProcessing];
	
	[pdf2Images release];
	[pool release];
}


-(void)pdfProcess2:(NSString *)PdfPath_bookId
{
	
	NSArray *chunks = [PdfPath_bookId componentsSeparatedByString: @"$###$"];
	
	PDFExtracter *pdf2Images = [[PDFExtracter alloc]init];
	
	pdf2Images.pdfPath= [chunks objectAtIndex:0];
	pdf2Images.pdfBookID=[chunks objectAtIndex:1];
	
	[pdf2Images startProcessing];
	
	//[pdf2Images release];
}


-(void)pdfProcess3:(NSString *)PdfPath_bookId
{
	
	NSArray *chunks = [PdfPath_bookId componentsSeparatedByString: @"$###$"];
	
	PDFExtracter *pdf2Images = [[PDFExtracter alloc]init];
	
	pdf2Images.pdfPath= [chunks objectAtIndex:0];
	pdf2Images.pdfBookID=[chunks objectAtIndex:1];
	
	[pdf2Images startProcessing];
	
	//[pdf2Images release];
}


-(void)pdfProcess4:(NSString *)PdfPath_bookId
{
	
	NSArray *chunks = [PdfPath_bookId componentsSeparatedByString: @"$###$"];
	
	PDFExtracter *pdf2Images = [[PDFExtracter alloc]init];
	
	pdf2Images.pdfPath= [chunks objectAtIndex:0];
	pdf2Images.pdfBookID=[chunks objectAtIndex:1];
	
	[pdf2Images startProcessing];
	
	//[pdf2Images release];
}
*/

-(void)getPurchasedBookList
{
	_sortedArray = nil;
	downloaderStackArray = nil;
	if(loaderObjArray != nil)
	{
		[loaderObjArray release];
		loaderObjArray =nil;
		[costButtonObjArray release];
		costButtonObjArray = nil;
		
		
	}
	
	_sortedArray = [[NSMutableArray alloc]init];
	downloaderStackArray = [[NSMutableArray alloc]init];
	costButtonObjArray = [[NSMutableArray alloc]init];
	loaderObjArray = [[NSMutableArray alloc]init];
	for(int ind = 1; ind < [appDelegate.bookListArray count]; ind++)
	{
		BookDetails *mybookDetail = (BookDetails *)[appDelegate.bookListArray objectAtIndex:ind];
		if (![mybookDetail.Purchased isEqualToString:@"0"]){//||[mybookDetail.Purchased isEqualToString:@"0"]) {
			
			[_sortedArray addObject:[appDelegate.bookListArray objectAtIndex:ind]];
		}
		//[mybookDetail release];
	}
}

-(void)loadScrollView
{	
	
	//  _sortedArray = appDelegate.bookListArray;
	//[sortedArray release];
	//_sortedArray = [[NSMutableArray alloc]init];
	if ([_sortedArray count]<=0) {
		return;
	}
	if (appDelegate.NoWifiConnection == TRUE) {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Internet Unavailable" message:@"You Must be connected to Internet to view this link"  delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
		return;
	}
	//int hhhh=[_sortedArray count];
	int height = (int)([_sortedArray count]+1 - _totCnt)/(_totCnt); //this was the problem that caused infinite waiting time when clicking 
	int i = 0;
	int singleContentViewSize = 0;
	[scrollview setContentSize:CGSizeMake(750, 800+(height*182)+950)];
	
	for(int row = 0; row < (([_sortedArray count]/_nRow)+height); row++)
	{
		for(int col = 0; col < _nCol; col++)
		{
			if(i < [_sortedArray count])
				
			{
				NSMutableArray *arrayTemp = [[NSMutableArray alloc] init];
				
				NSLog(@"ALL LOAD VIEW %d",i);
				[appDelegate.bookListArray retain];
				
			    BookDetails *bookdetailsObj = (BookDetails *)[_sortedArray objectAtIndex:i];
				[bookdetailsObj retain];
				[arrayTemp addObject:bookdetailsObj.Name];
				[arrayTemp addObject:bookdetailsObj.Author];
				[arrayTemp addObject:bookdetailsObj.Description];
				//[arrayTemp addObject:@""];
				_selectedBookIndex = [bookdetailsObj.IDValue intValue];
				[arrayTemp addObject:bookdetailsObj.Price];
				NSString *imagePath = [NSString stringWithFormat:@"/%@/%@",bookdetailsObj.ISBNNumber,[bookdetailsObj.CatalogImage lastPathComponent]];
				NSString *imagePath2 = [NSString stringWithFormat:@"/%@/%@",bookdetailsObj.ISBNNumber,[bookdetailsObj.CatalogImage lastPathComponent]];
				
				
				UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((380*col)+5, (133*row)+5, 375, 126)];
				contentView.tag = i+1;
				contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_small.png"]];
				UIImageView *coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 2, 75, 115)];
				coverImage.tag = 9999;
				if (![appDelegate checkFileExist:imagePath]) {
					coverImage.image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"images.jpg"]] ];
				}
				else
			    {
					{
						NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
						NSString *documentsDirectory = [paths objectAtIndex:0];
						NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:imagePath] retain];
						coverImage.image = [UIImage imageWithContentsOfFile:dataFilePath];
					}
					
					{
						NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
						NSString *documentsDirectory = [paths objectAtIndex:0];
						NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:imagePath2] retain];
						
						if(imageArray==nil)
							imageArray=[[NSMutableArray alloc] init];
						
						[imageArray addObject:dataFilePath];
						//[imageArray in
						
						if(imgView1.image==nil)
							imgView1.image=[UIImage imageWithContentsOfFile: [imageArray objectAtIndex:0]];
						else if(imgView2.image==nil)
							imgView2.image=[UIImage imageWithContentsOfFile: [imageArray objectAtIndex:1]];
						else if(imgView3.image==nil)
							imgView3.image=[UIImage imageWithContentsOfFile: [imageArray objectAtIndex:2]];
					}
				}
				
				[contentView addSubview:coverImage];
				[coverImage release];
				
				UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 2, 250, 20)];
				titleLabel.text = [arrayTemp objectAtIndex:0];//bookdetailsObj.bookTitle;
				titleLabel.numberOfLines = 0;
				titleLabel.font=[UIFont  fontWithName:@"Verdana-Bold" size:14];
				[titleLabel setBackgroundColor:[UIColor clearColor]];
				titleLabel.textColor = [UIColor redColor];
				[contentView addSubview:titleLabel];
				
				// titleLabel Will Be Released Later ,since its TAG NO is used to point the index for failed DownloadURL (index for downloaderStackArray) ..... 
				//[titleLabel release];
				
				UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 24, 250, 34)];
				subtitleLabel.text = [arrayTemp objectAtIndex:1];//bookdetailsObj.subTitle;
				subtitleLabel.numberOfLines = 0;
				subtitleLabel.textColor = [UIColor whiteColor];
				subtitleLabel.backgroundColor = [UIColor clearColor];
				subtitleLabel.font = [UIFont boldSystemFontOfSize:13];
				//[contentView addSubview:subtitleLabel];
				[subtitleLabel release];
				
				UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 24, 250, 70)];
				descLabel.text = [arrayTemp objectAtIndex:2];//bookdetailsObj.description;
				descLabel.textColor = [UIColor whiteColor];
				descLabel.numberOfLines = 0;
				descLabel.backgroundColor = [UIColor clearColor];
				descLabel.font = [UIFont systemFontOfSize:13];
				[contentView addSubview:descLabel];
				[descLabel release];
				
				
				NSString *bookName = [bookdetailsObj.MagazinePDFFilePath lastPathComponent];
				bookName =[bookName stringByReplacingOccurrencesOfString:@"-" withString:@" "];
				
				NSString * filename = [NSString stringWithFormat:@"/%@/%@",bookdetailsObj.ISBNNumber,bookName];
				
				UIButton *costButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 100, 75, 20)];
				costButton.tag =786;
				[costButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
				//[costButton addTarget:self action:@selector(selBookAction:) forControlEvents:UIControlEventTouchUpInside];
				//[costButton setTitle:bookdetailsObj.cost forState:UIControlStateNormal];
				//[costButton setTitle:[NSString stringWithFormat:@"%@",[arrayTemp objectAtIndex:3]] forState:UIControlStateNormal];
				[costButton setTitle:@"READ" forState:UIControlStateNormal];
				if ([[arrayTemp objectAtIndex:3] isEqualToString:@"$0"]) {
					[costButton setTitle:@"READ" forState:UIControlStateNormal];
				}
				
				costButton.titleLabel.textColor = [UIColor whiteColor];
				costButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
				costButton.titleLabel.shadowColor = [UIColor grayColor];
				
				
				[contentView addSubview:costButton];
				
				if (![appDelegate checkFileExist:filename]) {
					
					
					NSURL 			* firstUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"loader" ofType:@"gif"]];
					UIImageView 	* loader = 	[AnimatedGif getAnimationForGifAtUrl: firstUrl];
					[loader setFrame:CGRectMake(100,100,240,30)];
					//loader.frame = contentView.frame;
					[contentView addSubview:loader];
					/* Tag is Given for disabling the loader view */
					[loader startAnimating];
					[loaderObjArray addObject:loader];
					[costButtonObjArray addObject:costButton];
					
					
					[loader setTag:25];
					contentView.userInteractionEnabled = FALSE;
					//[loader release];
					[costButton setTitle:@"WAIT" forState:UIControlStateNormal];
					
					
					
					/*     Added the url with the button index to disable the loader image */
					[downloaderStackArray addObject:[NSString stringWithFormat:@"%@##$##%d",bookdetailsObj.MagazinePDFFilePath,i]];
					/*NOTE :- titleLabel Tag Should Be downloaderStackArray current index For download Again When Failed */
						[titleLabel setTag:88888+[downloaderStackArray count]-1];
					
				}
				
				
				[titleLabel release];
				[costButton release];
				
				
				
				
				
				
				MyCustomButton *bookBtn = [[MyCustomButton alloc] initWithIndex:_selectedBookIndex];
				[bookBtn setFrame:CGRectMake(0, 0, 375, 126)];
				[bookBtn addTarget:self action:@selector(selBookAction:) 	  forControlEvents:UIControlEventTouchUpInside];	
				[contentView addSubview:bookBtn];
				bookBtn.tag = 350+i;
				[bookBtn release];				
				[scrollview addSubview:contentView];
				
				
				
				UIImageView *statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(350, 0,14,126)];
				statusImageView.image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"classic.png"]] ];
				
				[contentView addSubview:statusImageView];
				singleContentViewSize = contentView.frame.size.height;
				singleContentViewSize +=40;
				
				[statusImageView release];
				[contentView release];
				
				i++;
				[arrayTemp release];
				
				[bookdetailsObj release];
				bookdetailsObj = nil;
				
			}
		}
	}
	//[scrollview setContentSize:CGSizeMake(750,[sortedArray count]*singleContentViewSize)];	
	if ([_sortedArray count]<=6) {
		[scrollview setContentSize:CGSizeMake(750,scrollview.frame.size.height)];	
	}
	else {
		[scrollview setContentSize:CGSizeMake(750,(([_sortedArray count]+1)/2*singleContentViewSize))];	
	}
	
	
}


-(void)loadAuthorView
{
    NSLog(@"loadAuthorView MyComicsViewController");
	UIButton *btnAuthorView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 745, 290)];
	[btnAuthorView setImage:[UIImage imageNamed:@"img_mainheader.png"] forState:UIControlStateNormal];
	btnAuthorView.clipsToBounds = YES;
	[btnAuthorView addTarget:self action:@selector(authorBio:) forControlEvents:UIControlEventTouchUpInside];
	[authorView addSubview:btnAuthorView];
	[btnAuthorView release];
	
	UILabel *authorBio = [[UILabel alloc] initWithFrame:CGRectMake(305, 225, 380, 60)];
	authorBio.text = @"Bill Hybels is the founding and senior pastor of Willow Creek Community Church in South Barrington, Ill., and chairman of the board for the Willow Creek Association.";
	authorBio.numberOfLines = 0;	
	authorBio.textColor = [UIColor whiteColor];
	authorBio.alpha = 0.5;
	authorBio.textAlignment = UITextAlignmentLeft;
	authorBio.backgroundColor = [UIColor clearColor];
	authorBio.font = [UIFont fontWithName:@"Helvetica" size:14];
	[authorView addSubview:authorBio];
	[authorBio release];
	
	UIButton *authorBioView = [[UIButton alloc] initWithFrame:CGRectMake(695, 240, 35, 31)];
	[authorBioView setImage:[UIImage imageNamed:@"btn_go.png"] forState:UIControlStateNormal];
	authorBioView.clipsToBounds = YES;
	[authorBioView addTarget:self action:@selector(authorBio:) forControlEvents:UIControlEventTouchUpInside];
	[authorView addSubview:authorBioView];
	[authorBioView release];
	
}

-(void)loadAuthorXml
{
	NSLog(@"loadAuthorXml MyComicsViewController");
	NSString * AuthorUrl = [NSString stringWithFormat:@"%@/api/read?action=author",serverIP];
	NSURL *url = [[NSURL alloc] initWithString:AuthorUrl];
	NSData *xmlData = [[NSData alloc]initWithContentsOfURL:url];
	
	if (xmlData ==nil) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:@"Author.xml"] retain];
		
		xmlData = [[NSData alloc]initWithContentsOfFile:dataFilePath];
		if (xmlData==nil) {
			xmlData = [[NSData alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Author" ofType:@"xml"]];
			
		}
		
	}
	NSString * xmlString = [[NSString alloc] initWithData:xmlData encoding:NSASCIIStringEncoding];
	
	
	/*********************** Author Xml Parser *****************************/
	NSRange end = [xmlString rangeOfString: @"</Name>"];
	NSRange start = [xmlString rangeOfString: @"<Name>"];
	int i =  end.location-(start.location+start.length);
	author_Name = [xmlString substringWithRange: NSMakeRange (start.location+start.length,i)];
	
	end = [xmlString rangeOfString: @"</Photo>"];
	start = [xmlString rangeOfString: @"<Photo>"];
	i =  end.location-(start.location+start.length);
	__author_Photo_Url = [xmlString substringWithRange: NSMakeRange (start.location+start.length,i)];
	
	end = [xmlString rangeOfString: @"</Description>"];
	start = [xmlString rangeOfString: @"<Description>"];
	i =  end.location-(start.location+start.length);
	__author_Description = [xmlString substringWithRange: NSMakeRange (start.location+start.length,i)];
	
	
}

-(void)reloadToolBar
{
	NSLog(@"reloadToolBar MyComicsViewController");
	//Add buttons to the array
	
	[topToolBar addSubview:segmentCntrl];
	[myView addSubview:topToolBar];
	
	if(segmentCntrl.selectedSegmentIndex == 0)
	{
		segLabel.text = @"Featured";
	}
	else if(segmentCntrl.selectedSegmentIndex == 1)
	{
		segLabel.text = @"New";
	}
	else if(segmentCntrl.selectedSegmentIndex == 2)
	{
		segLabel.text = @"Free";
	}
	else if(segmentCntrl.selectedSegmentIndex == 3)
	{
		segLabel.text = @"All";
	}
	
}

#pragma mark -
#pragma mark Button Actions

-(void)authorBio:(id)sender
{
	printf("\n authorBio action...");
	bioView.hidden = NO;
	//backButton.hidden = NO;
	//[myView bringSubviewToFront:backButton];
}

-(void)backAction:(id)sender
{
	printf("\n backAction...");
	if(_isAbtAuth == NO)
	{
		bioView.hidden = YES;
	}
	else if(_isAbtAuth == YES)
	{
		_isAbtAuth = NO;
		selBookView.hidden = NO;
		bioView.hidden = YES;
	}
	//backButton.hidden = YES;
}

-(void)closeAction:(id)sender
{
	printf("\n closeAction...");
	_isAbtAuth = NO;
	bioView.hidden = YES;
	selBookView.hidden = YES;
	[_downloadingOverlayView setHidden:TRUE];
	//backButton.hidden = YES;
}



-(void)selBookAction:(id)sender
{
	NSLog(@"selBookAction MyComicsViewController");
	UIButton *buttonSel = (UIButton *)sender;
	_selectedBookIndex=[sender index];
	UIView * contentView1 = [buttonSel superview];
	NSLog(@"contentView TAG%d",contentView1.tag);
	UIButton *costButton = [contentView1 viewWithTag:786];
	NSString *title = [costButton currentTitle];
	
	
	if ([title isEqualToString:@"READ"]) {
		
		//Extract Pdf Here 
		
		
		BookDetails *readingBook ;
		
		
		
		for(int x=0;x<[_sortedArray count];x++)
		{
			
			readingBook = (BookDetails *)[_sortedArray objectAtIndex:x];
			NSLog(@"--read book---");
		    [readingBook retain];
			
			NSLog(@"reading book id = %@",readingBook.IDValue);
			
			NSLog(@"selected index book id = %d",_selectedBookIndex);
			
			NSLog(@"-----");
			
			if([readingBook.IDValue intValue]  ==_selectedBookIndex)
			{
			    _bookOpenToRead = TRUE;
				ClassicalScrollViewController *classicalScrollViewController = [[ClassicalScrollViewController alloc] init] ; //]WithNibName:@"ClassicalScrollViewController" bundle:nil];
				classicalScrollViewController.string_bookId =  [[NSString alloc] initWithFormat:@"%@",readingBook.ISBNNumber];
				classicalScrollViewController.string_bookCount = [[NSString alloc] initWithFormat:@"%d",78];
				[self presentModalViewController:classicalScrollViewController animated:FALSE];
				//[appDelegate.navController1 setViewControllers:[NSArray arrayWithObjects: classicalScrollViewController,nil]];
				//[appDelegate.tabBarController setSelectedViewController:classicalScrollViewController];
				//[self.navigationController pushViewController:classicalScrollViewController animated:FALSE];
				[classicalScrollViewController release];
				
				return;
				
			}
			else {
				[readingBook release];
			}

			
		}
			
		
		
		
		

		
		

		
		
		
		
		return;
	}
	
	
	
	
	if ([title isEqualToString:@"RESUME"]) {
		// get the superview tag :
		
		[costButton setTitle:@"WAIT" forState:UIControlStateNormal];
		contentView1.userInteractionEnabled = TRUE;
		UIImageView *loader = [contentView1 viewWithTag:25];
		
		[loader setHidden:FALSE];
		
		
		//[downloaderStackArray removeAllObjects];
		//		[self loadScrollView];
		//		if ([downloaderStackArray count]>0) {
		//			for (int k =0; k<[downloaderStackArray count]; k++) {
		//		        [NSThread detachNewThreadSelector:@selector(DownloadEpubBooks:) toTarget:self withObject:[downloaderStackArray objectAtIndex:k]];
		//				
		//			}
		//		}
		
		
		for(UIView *subview in contentView1.subviews)
		{
			
			int tagIndexNO = [subview tag];
			if (tagIndexNO >88888) {
				
				[NSThread detachNewThreadSelector:@selector(DownloadEpubBooks:) toTarget:self withObject:[downloaderStackArray objectAtIndex:tagIndexNO-88888]];
				break;
			}
		}
		
	}
	
	
	return;
	
	
	
	
	[_downloadingOverlayView setHidden:FALSE];
	
	
	_selectedBookIndex=[sender index];
	
	printf("\nselBookAction... %d", [sender index]);
	
	for(UIView *subview in selBookView.subviews)
	{
		[subview removeFromSuperview];
	}
	//	UIImageView *topview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
	//	[topview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"122.png"]]];
	//	[myView addSubview: topview];
	//	[myView bringSubviewToFront:selBookView];
	[selBookView removeFromSuperview];
	[self.view addSubview:selBookView];
	selBookView.hidden = NO;
	[_sortedArray retain];
	//NSLog([appDelegate.bookListArray description]);
	//BookDetails *bookdetailsObj = (BookDetails *)[_sortedArray objectAtIndex:_selectedBookIndex];
	//[bookdetailsObj retain];
	
	//NSString * idvalue =bookdetailsObj.IDValue;
	
	NSString * descriptionUrl = [NSString stringWithFormat:@"%@/api/read?action=detailbook&authKey=%@&bookId=%d",serverIP,appDelegate.loginAuthKey,_selectedBookIndex];
	
	
	[self createDiscriptionView:descriptionUrl];
	
}

-(void)createDiscriptionView :(NSString *)descriptionXmlUrl
{
	OneBookDetails *oneBookDet = [self loadBookDescription:descriptionXmlUrl];
	
	
	NSMutableArray *arrayofSelectedComic = [[NSMutableArray alloc] init];
	
	[arrayofSelectedComic addObject:oneBookDet.Name];
	[arrayofSelectedComic addObject:oneBookDet.Author];
	[arrayofSelectedComic addObject:oneBookDet.Description];
	[arrayofSelectedComic addObject:oneBookDet.Price];
	
	_selectedbookISBNnumber = oneBookDet.ISBNNumber;
	
	//BookDetails *bookdetailsObj = [booksArray objectAtIndex:[sender index]];
	
	//	UIImageView *topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 600, 40)];
	//	topImage.image = [UIImage imageNamed:@"popup_top_bar.png"];	
	//	[selBookView addSubview:topImage];
	//	[topImage release];	
	
	UILabel *bookTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 560, 35)];
	//bookTitleLabel.text = bookdetailsObj.bookTitle;
	bookTitleLabel.text = [arrayofSelectedComic objectAtIndex:0];
	//bookTitleLabel.font = [UIFont boldSystemFontOfSize:16];
	bookTitleLabel.font = [UIFont systemFontOfSize:25];
	bookTitleLabel.textAlignment = UITextAlignmentCenter;
	bookTitleLabel.backgroundColor = [UIColor clearColor];
	bookTitleLabel.textColor = [UIColor whiteColor];
	[selBookView addSubview:bookTitleLabel];
	[bookTitleLabel release];
	
	UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(560, 0, 35, 35)];
	[closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_close.png"]
						forState:UIControlStateNormal];	
	closeBtn.clipsToBounds = YES;
	[closeBtn addTarget:self action:@selector(closepopupAction:) 
	   forControlEvents:UIControlEventTouchUpInside];
	[selBookView addSubview:closeBtn];
	[closeBtn release];
	
	
	UIImageView *selBookImage = [[UIImageView alloc] initWithFrame:CGRectMake(18, 50, 260, 340)];
	//selBookImage.image = [UIImage imageNamed:bookdetailsObj.coverImage];
	NSString *imagePath = [NSString stringWithFormat:@"/%@/BookLarge.jpg",_selectedbookISBNnumber];
	NSLog(@"Image Name %@",imagePath);
	
	//Check Image And assign if it has or no image 
	if (![appDelegate checkFileExist:imagePath]) {
		selBookImage.image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"largeBook.png"]]];
	}
	else
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:imagePath] retain];
		selBookImage.image = [UIImage imageWithContentsOfFile:dataFilePath];
	}
	
	
	selBookImage.tag = _selectedBookIndex+1;
	[selBookView addSubview:selBookImage];
	[selBookImage release];
	
	
	UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(45, 436, 189, 39)];
	
	[buyBtn setBackgroundImage:[UIImage imageNamed:@"buy-now-button-bg.png"]
					  forState:UIControlStateNormal];
	NSString *makeStr = @"BUY NOW ";
	//	makeStr = [makeStr stringByAppendingString:bookdetailsObj.cost];
	makeStr = [makeStr stringByAppendingString:[NSString stringWithFormat:@"%@",[arrayofSelectedComic objectAtIndex:3]]];
	if ([[arrayofSelectedComic objectAtIndex:3] isEqualToString:@"$0"]) {
		makeStr = @"Download Now";
	}
	[buyBtn setTitle:makeStr forState:UIControlStateNormal];
	[buyBtn setTitleColor:[UIColor colorWithRed:14.0/255.0 green:14.0/255.0 blue:14.0/255.0 alpha:1.0] forState:UIControlStateNormal];
	[buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	buyBtn.clipsToBounds = YES;
	
	[buyBtn addTarget:self action:@selector(buyAction:) 
	 forControlEvents:UIControlEventTouchUpInside];
	[selBookView addSubview:buyBtn];
	[buyBtn release];
	
	UILabel *intrLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 490, 260, 40)];
	intrLabel.text = @"You may also be interested in following book(s)";
	intrLabel.numberOfLines = 0;
	intrLabel.font = [UIFont systemFontOfSize:12];
	intrLabel.textAlignment = UITextAlignmentLeft;
	intrLabel.backgroundColor = [UIColor clearColor];
	intrLabel.textColor = [UIColor blackColor];
	[selBookView addSubview:intrLabel];
	[intrLabel release];
	
	
	// related books and their shadows images
	UIImageView *relatedBook[3];
	UIButton * relatedButton[3];
	relatedBook[0] = [[UIImageView alloc] initWithFrame:CGRectMake(15, 535, 80, 120)];
	relatedButton[0] = [[UIButton alloc] initWithFrame:CGRectMake(15, 535, 80, 120)];
	//relatedButton[0].tag = 0;
	[relatedButton[0] addTarget:self action:@selector(relatedBookButtonAct:) forControlEvents:UIControlEventTouchUpInside];
	//book1.image = [UIImage imageNamed:bookdetailsObj.coverImage];	
	
	relatedBook[0].tag = _selectedBookIndex+20+1;
	[selBookView addSubview:relatedBook[0]];
	[selBookView addSubview:relatedButton[0]];
	//[book1 release];
	
	relatedBook[1] = [[UIImageView alloc] initWithFrame:CGRectMake(100, 535, 80, 120)];
	//book2.image = [UIImage imageNamed:bookdetailsObj.coverImage];
	relatedButton[1] = [[UIButton alloc] initWithFrame:CGRectMake(100, 535, 80, 120)];
	//relatedButton[1].tag = 1;
	[relatedButton[1] addTarget:self action:@selector(relatedBookButtonAct:) forControlEvents:UIControlEventTouchUpInside];
	
	relatedBook[1].tag = _selectedBookIndex+20+2;
	[selBookView addSubview:relatedBook[1]];
	[selBookView addSubview:relatedButton[1]];
	//[book2 release];
	
	relatedBook[2] = [[UIImageView alloc] initWithFrame:CGRectMake(185, 535, 80, 120)];
	relatedButton[2] = [[UIButton alloc] initWithFrame:CGRectMake(185, 535, 80, 120)];
	//relatedButton[2].tag = 2;
	//book3.image = [UIImage imageNamed:bookdetailsObj.coverImage];	
	relatedBook[2].tag = _selectedBookIndex+20+3;
	[relatedButton[2] addTarget:self action:@selector(relatedBookButtonAct:) forControlEvents:UIControlEventTouchUpInside];
	
	[selBookView addSubview:relatedBook[2]];
	[selBookView addSubview:relatedButton[2]];
	//[relatedBook[2] release];
	
	
	
	// Assign Image for Related Books :-
	int totalRelatedBook = 0;
	if (oneBookDet.RealatedBookArray!=nil) {
		
		for (int i =0; i<3;i++) {
			RelatedBookDeatails *rltdBkDet = nil;
			if (i<[oneBookDet.RealatedBookArray count]) {
				rltdBkDet = (RelatedBookDeatails*)[oneBookDet.RealatedBookArray objectAtIndex:i]; 
			}
			
			if (rltdBkDet==nil) {
				relatedBook[i].image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"NotAvilable.png"]] ];
				relatedBook[i].hidden = TRUE;
				relatedButton[i].hidden = TRUE;
				[relatedBook[i] release];
				[relatedButton[i] release];
				
			}
			else if(rltdBkDet.ReleatedCoverPhoto!=nil||![rltdBkDet.ReleatedCoverPhoto isEqualToString:@""])
			{
			    NSString * str = [rltdBkDet.ReleatedIDValue stringByReplacingOccurrencesOfString:@"\t" withString:@""];
				str = [rltdBkDet.ReleatedIDValue stringByReplacingOccurrencesOfString:@"\n" withString:@""];
				
				relatedButton[i].tag = [str intValue];
				
				//Name was getting changed in server side to avoid that we are doing this
				NSString *imageName = [rltdBkDet.ReleatedCoverPhoto lastPathComponent];
				imageName = [NSString stringWithFormat:@"Rel%d%@",i,imageName];
				
				NSString *imagePath = [NSString stringWithFormat:@"/%@/RelatedBooks/%@",_selectedbookISBNnumber,imageName];
				totalRelatedBook++;
				if (![appDelegate checkFileExist:imagePath]) {
					relatedBook[i].image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"NotAvilable.png"]] ];
					//relatedButton[i].tag = [rltdBkDet.ReleatedIDValue intValue];
					[relatedBook[i] release];
					[relatedButton[i] release];
				}
				else
				{
					NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
					NSString *documentsDirectory = [paths objectAtIndex:0];
					NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:imagePath] retain];
					relatedBook[i].image = [UIImage imageWithContentsOfFile:dataFilePath];
					[relatedBook[i] release];
					//relatedButton[i].tag = [rltdBkDet.ReleatedIDValue intValue];
					[relatedButton[i] release];
				}
			}
		}
		
	}
	else {
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
	
	
	UIImageView *textBg = [[UIImageView alloc] initWithFrame:CGRectMake(285, 50, 296, 460)];
	//selBookImage.image = [UIImage imageNamed:bookdetailsObj.coverImage];
	textBg.image = [UIImage imageNamed:@"bg-text.png"];
	[selBookView addSubview:textBg];
	[textBg release];
	
	UILabel *bookTitle = [[UILabel alloc] initWithFrame:CGRectMake(295, 55, 280, 20)];
	//bookTitle.text = [arrayofSelectedComic objectAtIndex:0];// bookdetailsObj.bookTitle;
	bookTitle.font =[UIFont fontWithName:@"TrebuchetMS-Bold" size:20];// [UIFont boldSystemFontOfSize:18];
	bookTitle.textAlignment = UITextAlignmentLeft;
	bookTitle.backgroundColor = [UIColor clearColor];
	bookTitle.textColor = [UIColor whiteColor];
	bookTitle.lineBreakMode = UILineBreakModeWordWrap;
	bookTitle.numberOfLines = 0;
	/*to set UILabel height dynamically */
	NSString *titleStr =[arrayofSelectedComic objectAtIndex:0];// bookdetailsObj.description;
	CGSize maximumLabelSize1 = CGSizeMake(280,9999);
	CGSize expectedLabelSize1 = [titleStr sizeWithFont:bookTitle.font 
									 constrainedToSize:maximumLabelSize1 
										 lineBreakMode:bookTitle.lineBreakMode];
	CGRect newFrame1 = bookTitle.frame;
	newFrame1.size.height = expectedLabelSize1.height;
	bookTitle.frame = newFrame1;
	bookTitle.text = [arrayofSelectedComic objectAtIndex:0];//bookdetailsObj.description;
	[selBookView addSubview:bookTitle];
	[bookTitle release];
	
	
	UILabel *byAuthor = [[UILabel alloc] initWithFrame:CGRectMake(295,bookTitle.frame.origin.y+bookTitle.frame.size.height, 280, 40)];
	//byAuthor.text = [arrayofSelectedComic objectAtIndex:1];// bookdetailsObj.bookTitle;
	//NSString *authorStr = @"By ";
	//authorStr = [authorStr stringByAppendingString:@"Bill Hybels"];//bookdetailsObj.author];
	//byAuthor.text = authorStr;
	byAuthor.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];//[UIFont systemFontOfSize:16];
	//byAuthor.font = [UIFont boldSystemFontOfSize:14];
	byAuthor.textAlignment = UITextAlignmentLeft;
	byAuthor.backgroundColor = [UIColor clearColor];
	byAuthor.textColor = [UIColor whiteColor];
	byAuthor.numberOfLines=0;
	byAuthor.lineBreakMode = UILineBreakModeWordWrap;
	/*to set UILabel height dynamically */
	NSString *authorStr =[arrayofSelectedComic objectAtIndex:1];// bookdetailsObj.description;
	CGSize maximumLabelSize11 = CGSizeMake(280,9999);
	CGSize expectedLabelSize11 = [authorStr sizeWithFont:byAuthor.font 
									   constrainedToSize:maximumLabelSize11 
										   lineBreakMode:byAuthor.lineBreakMode];
	CGRect newFrame11 = byAuthor.frame;
	newFrame11.size.height = expectedLabelSize11.height;
	byAuthor.frame = newFrame11;
	byAuthor.text = [arrayofSelectedComic objectAtIndex:1];//bookdetailsObj.description;
	[selBookView addSubview:byAuthor];
	[byAuthor release];
	
	float descY = byAuthor.frame.origin.y+byAuthor.frame.size.height + 10.0;
	float descHeight = 500.0 - descY;
	
	UITextView *desc = [[UITextView alloc] initWithFrame:CGRectMake(290, descY, 280, descHeight)];
	desc.font = [UIFont fontWithName:@"ArialMT" size:13];
	desc.textAlignment = UITextAlignmentLeft;
	desc.backgroundColor = [UIColor clearColor];
	desc.textColor = [UIColor whiteColor];
	desc.editable=FALSE;
	desc.text = [arrayofSelectedComic objectAtIndex:2];
	[selBookView addSubview:desc];
	[desc release];
	
	
	//	UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(295, byAuthor.frame.origin.y+byAuthor.frame.size.height+10.0, 280, 40)];
	//	NSString *descStr =[arrayofSelectedComic objectAtIndex:2];// bookdetailsObj.description;
	//	desc.lineBreakMode = UILineBreakModeWordWrap;
	//	desc.numberOfLines = 0;
	//	desc.font = [UIFont fontWithName:@"Arial" size:13];//[UIFont systemFontOfSize:14];
	//	desc.textAlignment = UITextAlignmentLeft;
	//	desc.backgroundColor = [UIColor clearColor];
	//	desc.textColor = [UIColor whiteColor];
	//	
	//	/*to set UILabel height dynamically */
	//	CGSize maximumLabelSize = CGSizeMake(280,9999);
	//	CGSize expectedLabelSize = [descStr sizeWithFont:desc.font 
	//									    constrainedToSize:maximumLabelSize 
	//										lineBreakMode:desc.lineBreakMode];
	//	CGRect newFrame = desc.frame;
	//	newFrame.size.height = expectedLabelSize.height;
	//	desc.frame = newFrame;
	//	desc.text = [arrayofSelectedComic objectAtIndex:2];//bookdetailsObj.description;
	//	
	//	[selBookView addSubview:desc];
	//	[desc release];
	
	
	
	// preview, about author, print
	
	UIImageView *menuImg = [[UIImageView alloc] initWithFrame:CGRectMake(285, 515, 296, 169)];
	menuImg.image = [UIImage imageNamed:@"book_detail-abt-author-pg.png"];
	[selBookView addSubview:menuImg];
	[menuImg release];
	
	UIButton *previewBtn = [[UIButton alloc] initWithFrame:CGRectMake(300, 520, 270, 30)];
	previewBtn.backgroundColor = [UIColor clearColor];	
	previewBtn.clipsToBounds = YES;
	[previewBtn addTarget:self action:@selector(previewAction:) 
		 forControlEvents:UIControlEventTouchUpInside];
	[selBookView addSubview:previewBtn];
	[previewBtn release];
	
	UIButton *abtauthBtn = [[UIButton alloc] initWithFrame:CGRectMake(300, 558, 270, 30)];
	abtauthBtn.backgroundColor = [UIColor clearColor];	
	abtauthBtn.clipsToBounds = YES;
	[abtauthBtn addTarget:self action:@selector(aboutAuthorAction:) 
		 forControlEvents:UIControlEventTouchUpInside];
	[selBookView addSubview:abtauthBtn];
	[abtauthBtn release];
	
	UIButton *buyprntBtn = [[UIButton alloc] initWithFrame:CGRectMake(300, 595, 270, 30)];
	buyprntBtn.backgroundColor = [UIColor clearColor];	
	buyprntBtn.clipsToBounds = YES;
	[buyprntBtn addTarget:self action:@selector(buyinprintAction:) 
		 forControlEvents:UIControlEventTouchUpInside];
	[selBookView addSubview:buyprntBtn];
	[buyprntBtn release];	
	
	[arrayofSelectedComic release];
	
}
-(void)relatedBookButtonAct:(id)sender
{
	int indexx = [sender tag];
	if (indexx ==0) {
		return;
	}
	_selectedBookIndex = indexx;
	[self closepopupAction:nil];
	[_downloadingOverlayView setHidden:FALSE];
	
	
	//_selectedBookIndex=[sender index];
	printf("\nselBookAction... %d",indexx);
	
	for(UIView *subview in selBookView.subviews)
	{
		[subview removeFromSuperview];
	}
	//	UIImageView *topview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
	//	[topview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"122.png"]]];
	//	[myView addSubview: topview];
	//	[myView bringSubviewToFront:selBookView];
	[selBookView removeFromSuperview];
	[self.view addSubview:selBookView];
	selBookView.hidden = NO;
	
	NSString * descriptionUrl = [NSString stringWithFormat:@"%@/api/read?action=detailbook&authKey=%@&bookId=%d",serverIP,appDelegate.loginAuthKey,indexx];
	
	
	[self createDiscriptionView:descriptionUrl];
	
	
	
	
}

/********************* Download Book Description Xml and save that in ************************/
-(OneBookDetails *)loadBookDescription:(NSString *)descXmlUrl
{
	NSLog(@"loadBookDescription MyComicsViewController");
	NSURL *url = [[NSURL alloc] initWithString:descXmlUrl];
	NSData *xmlData = [[NSData alloc]initWithContentsOfURL:url];
	
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
    BookDetailParser *bookDetailParser = [[BookDetailParser alloc]initXMLParser];
	[xmlParser setDelegate:bookDetailParser];
	
	//Start parsing the XML file.
	BOOL success = [xmlParser parse];
	[xmlParser release];
	xmlParser=nil;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:@"description.xml"] retain];
	
	if(!success)
	{
		
		xmlData = [[NSData alloc]initWithContentsOfFile:dataFilePath];
		if (xmlData==nil) {
			xmlData = [[NSData alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"description" ofType:@"xml"]];
			
		}
		
		xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
		[bookDetailParser release];
		bookDetailParser = [[BookDetailParser alloc]initXMLParser];
		[xmlParser setDelegate:bookDetailParser];
		success = [xmlParser parse];
		[xmlParser release];
		xmlParser=nil;
	}
	if(success)
	{
		
		//[NSThread detachNewThreadSelector:@selector(DownloadThread:) toTarget:self withObject:self.bookListArray];
		[xmlData writeToFile:dataFilePath atomically:YES];
		if (appDelegate.booksDetailsArray ==nil) {
			return nil;
		}
		[appDelegate.booksDetailsArray retain];
		OneBookDetails* oneBookDetai = (OneBookDetails *)[appDelegate.booksDetailsArray objectAtIndex:0];
		[oneBookDetai retain];
		// [self performSelectorInBackground:@selector(DownloadThread:) withObject:bkDetailObj];
		
		[NSThread detachNewThreadSelector:@selector(DownloadCover:) toTarget:self withObject:oneBookDetai];	
		//Related Book Array May be nil 
		if (oneBookDetai.RealatedBookArray!=nil) {
			
			[NSThread detachNewThreadSelector:@selector(DownloadRelatedBooks:) toTarget:self withObject:oneBookDetai.RealatedBookArray ];
			
			
			
		}
		else {
			//Change the images to no book simillar to them 
		}
		[xmlData release];
		[url release];
		[xmlParser release];
		return oneBookDetai;
	}
	else
	{
		NSLog(@"Error Error Error!!!");
	}
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
	NSLog(@"DownloadCover MyComicsViewController");
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
	NSString *myurl = onebkDetail.CoverPhoto ;
	NSString *ISBNNumber = [NSString stringWithFormat:@"%@",onebkDetail.ISBNNumber];
	NSLog(@"MyURL %@",myurl);
	
	if (myurl!=nil) {
		NSString *imageName = @"BookLarge.jpg";
		NSString * fileName  = [NSString stringWithFormat:@"/%@/%@",ISBNNumber,imageName];
		if(![appDelegate checkFileExist:fileName])
		{
			NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:myurl]];
			UIImage *img = [[UIImage alloc] initWithData:imageData];
			
			if (img==nil) {
				NSLog(@"No Image");
				//////img = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"no_image1.png"]] ];
				//NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://i51.tinypic.com/219yzaf.jpg"]];
				//img = [[UIImage alloc] initWithData:imageData];
				
			}
			//[self saveImage :img withName:[NSString stringWithFormat:@"/%@/%@%@",ISBNNumber,ISBNNumber,imageName]];
			NSArray *paths = NSSearchPathForDirectoriesInDomains(
																 NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *docDirectory = [paths objectAtIndex:0];
			
			
			NSString *dataFilePath = [[docDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",ISBNNumber]] retain];
			[[ NSFileManager defaultManager] createDirectoryAtPath:dataFilePath attributes:nil];
			
			[appDelegate saveImage :img withName:[dataFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",imageName]]];
			
			UIImageView *largeImageView =[selBookView viewWithTag:_selectedBookIndex+1];
			largeImageView.image =img;
			[img release];
			[imageData release];
			
		}
		else {
			
			NSLog(@"FileExists");
		}
		
	}
	
	[pool release]; 
}


-(void)DownloadRelatedBooks:(NSMutableArray *)relatedBookArray
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
	NSLog(@"DownloadRelatedBooks MyComicsViewController");
	for (int h=0 ; h<[relatedBookArray count];h++) {
		RelatedBookDeatails *relatedDetailsObj = [relatedBookArray objectAtIndex:h];
		
		NSString *myurl = relatedDetailsObj.ReleatedCoverPhoto;
		NSString *ISBNNumber = [NSString stringWithFormat:@"%@",_selectedbookISBNnumber];
		NSLog(@"MyURL %@",myurl);
		//myurl = nil;
		
		if (myurl!=nil) {
			myurl = [myurl stringByReplacingOccurrencesOfString:@"\t" withString:@""];
			myurl = [myurl stringByReplacingOccurrencesOfString:@"\n" withString:@""];
			NSLog(@"MyURL %@",myurl);
			//Name was getting changed in server side to avoid that we are doing this
			NSString *imageName = [myurl lastPathComponent];
			imageName = [NSString stringWithFormat:@"Rel%d%@",h,imageName];
			NSString *fileName = [NSString stringWithFormat:@"/%@/RelatedBooks/%@",_selectedbookISBNnumber,[myurl lastPathComponent]];
			if(![appDelegate checkFileExist:fileName])
			{
				NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:myurl]];
				UIImage *img = [[UIImage alloc] initWithData:imageData];
				
				if (img==nil) {
					NSLog(@"No Image");
					
					//NSData *imageData =  [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"no_image" ofType:@"png"]];
					//img = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"no_image.png"]];
					//NSData *imageData = [[NSData alloc] initWithContentsOfFile:[NSURL URLWithString:@"http://i51.tinypic.com/219yzaf.jpg"]];
					//////img = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"no_image1.png"]] ];
					
					//img = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"no_image.png"]] ];
					// NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://i51.tinypic.com/219yzaf.jpg"]];
					// img = [[UIImage alloc] initWithData:imageData];
					
				}
				//[self saveImage :img withName:[NSString stringWithFormat:@"/%@/%@%@",ISBNNumber,ISBNNumber,imageName]];
				NSArray *paths = NSSearchPathForDirectoriesInDomains(
																	 NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *docDirectory = [paths objectAtIndex:0];
				
				
				NSString *dataFilePath = [[docDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/RelatedBooks",ISBNNumber]] retain];
				[[ NSFileManager defaultManager] createDirectoryAtPath:dataFilePath attributes:nil];
				
				[appDelegate saveImage :img withName:[dataFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",imageName]]];
				
				
				// added 20 + selectedIndex + 1 here since we have h starts from zero we need to add zero  
				UIImageView *largeImageView =[selBookView viewWithTag:_selectedBookIndex+20+(h+1)];
				largeImageView.image =img;
				
				//[img release];
				// [imageData release];
				
			}
			else {
				
				NSLog(@"FileExists");
			}
			
		}
	}
	[pool release];
}
-(void)startBookDownloading:(id)sender
{
	NSLog(@"startBookDownloading MyComicsViewController");
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	//BookDetails *bookdetailsObj = (BookDetails *)[_sortedArray objectAtIndex:_selectedBookIndex];
	//[bookdetailsObj retain];
	//int myindex = _selectedBookIndex;
	
	///// ********************* Downloading Part is not needed here *******************/////
	/*NSURL * bookURL = [[NSURL alloc]initWithString:bookdetailsObj.EpubFileUrl];
	 
	 NSString * filename = [NSString stringWithFormat:@"/%@/%@.epub",bookdetailsObj.ISBNNumber,bookdetailsObj.Name];
	 //Check File List 
	 NSData *epubBookData = [[NSData alloc]initWithContentsOfURL:bookURL];
	 
	 if (epubBookData!=nil) {
	 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	 NSString *documentsDirectory = [paths objectAtIndex:0];
	 NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:filename] retain];
	 [[ NSFileManager defaultManager] createDirectoryAtPath:dataFilePath attributes:nil];
	 [epubBookData writeToFile:dataFilePath atomically:YES];
	 
	 [[Shelf sharedShelf] createBookFromCatalogEntry: epubBookData Name:[NSString stringWithFormat:@"%@.epub",bookdetailsObj.Name]];
	 
	 }*/
	/********************* End Of Downloading Part  *******************/
	
	/********************* Hit server to send acknowledgement  *******************/
	
	
	NSString * setOrderInfoUrl = [NSString stringWithFormat:@"%@/api/read?action=setorderinfo&authKey=%@&bookId=%d",serverIP,appDelegate.loginAuthKey,_selectedBookIndex];
    NSURL *url = [[NSURL alloc] initWithString:setOrderInfoUrl];
	NSData *data = [[NSData alloc]initWithContentsOfURL:url];
	
	NSString * str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	if ([str rangeOfString:@"<IsSuccess>1"].location !=NSNotFound) {
		_downloading_Progress = FALSE;
	}
	else {
		// There may be problem in purchase  
	}
	
	_downloading_Progress = FALSE;
	//[bookdetailsObj release];
	[pool release]; 
}


#pragma mark -
#pragma mark Description Btn Act
-(void)closepopupAction:(id)sender
{
	printf("\nclosepopupAction...");
	selBookView.hidden = YES;
	[_downloadingOverlayView setHidden:TRUE];
	//[_downloadingOverlayView removeFromSuperview];
	//[_downloadingOverlayView release];
}

-(void)previewAction:(id)sender
{
	printf("\npreviewAction...");
	_isAbtAuth = NO;
	bioView.hidden = YES;
	selBookView.hidden = YES;
	[_downloadingOverlayView setHidden:FALSE];
	[self performSelector:@selector(loadPreviewBook) withObject:nil afterDelay:0.05];
	//[NSThread detachNewThreadSelector:@selector(showScreenOverLay) toTarget:self withObject:nil];	
	
}
-(void)loadPreviewBook
{
	[_downloadingOverlayView setHidden:FALSE];
	BookDetails *bookdetailsObj = nil;
	for (int i =0; i<[appDelegate.bookListArray count]; i++) {
		bookdetailsObj= (BookDetails *)[appDelegate.bookListArray objectAtIndex:i];
		[bookdetailsObj retain];
		if([bookdetailsObj.IDValue isEqualToString:[NSString stringWithFormat:@"%d",_selectedBookIndex]])
		{
			[_sortedArray addObject:[appDelegate.bookListArray objectAtIndex:i]];
			break;
		}
		else {
			[bookdetailsObj release];
			bookdetailsObj = nil;
		}
		
	}
	
	//int myindex = _selectedBookIndex;
	if (bookdetailsObj ==nil) {
		[_downloadingOverlayView setHidden:TRUE];
		return;
	}
	///// ********************* Downloading Part is not needed here *******************/////
	NSURL * bookURL = [[NSURL alloc]initWithString:bookdetailsObj.EpubSampleFileUrl];
	
	NSString * filename = [NSString stringWithFormat:@"/Preview%@.epub",bookdetailsObj.Name];
	//Check File List 
	if(![appDelegate checkFileExist:filename])
	{
		NSData *epubBookData = [[NSData alloc]initWithContentsOfURL:bookURL];
		
		if (epubBookData!=nil) {
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			//NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:filename] retain];
			//[[ NSFileManager defaultManager] createDirectoryAtPath:dataFilePath attributes:nil];
			
			//[epubBookData writeToFile:dataFilePath atomically:YES];
			[_downloadingOverlayView setHidden:TRUE];
			[[Shelf sharedShelf] createBookFromCatalogEntry: epubBookData Name:[NSString stringWithFormat:@"Preview%@.epub",bookdetailsObj.Name]];
		}
	}
	[_downloadingOverlayView setHidden:TRUE];
	Book* book = [[Book alloc]init];
	book.fileName = [NSString stringWithFormat:@"Preview%@",bookdetailsObj.Name];
	book.author = bookdetailsObj.Author;
	book.title = bookdetailsObj.Name;
	//_bookOpenToRead = TRUE;
	BookIndexViewController* bookIndexViewController = [[[BookIndexViewController alloc] initWithBook: book] autorelease];
	UINavigationController* navigationController = [[[UINavigationController alloc] initWithRootViewController: bookIndexViewController] autorelease];
	if (navigationController != nil) {
		[self presentModalViewController: navigationController animated: YES];
	}
	self.navigationController.navigationBarHidden = TRUE;
}
-(void)showScreenOverLay
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	printf("\n showScreenOverLay...");
	_isAbtAuth = NO;
	bioView.hidden = YES;
	selBookView.hidden = YES;
	//[_downloadingOverlayView setHidden:TRUE];
	//backButton.hidden = YES;
	[_downloadingOverlayView setHidden:FALSE];
	[pool release];
}


-(void)aboutAuthorAction:(id)sender
{
	printf("\naboutAuthorAction...");
	_isAbtAuth = YES;
	bioView.hidden = NO;
	selBookView.hidden = YES;
	
	//[_downloadingOverlayView sendSubviewToBack:myView];
	[myView bringSubviewToFront:bioView];
}

-(void)buyinprintAction:(id)sender
{
	printf("\nbuyinprintAction...");
	UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Buy In Print" message:@"Coming Soon..." 
													 delegate:nil cancelButtonTitle:@"OK" 
											otherButtonTitles:nil];
	[myAlert show];
	[myAlert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag==5)
	{
		//[[self.tabBarController.viewControllers objectAtIndex:1] popToRootViewControllerAnimated:NO];
		//[self.navigationController popToViewController:[[self.navigationController viewControllers]objectAtIndex:0] animated:YES ];
		//[[self.tabBarController.viewControllers objectAtIndex:1] popViewControllerAnimated:appDelegate.];
		[appDelegate GotoSignInPage];
		
	}
}

/*-(void)featuredAction:(id)sender
 {
 printf("\n featuredAction...");
 }
 
 -(void)newAction:(id)sender
 {
 printf("\n newAction...");
 }
 
 -(void)freeAction:(id)sender
 {
 printf("\n freeAction...");
 }*/

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
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc 
{
	
	[_downloadingOverlayView release];
	[myView release];
	[authorView release];
	//[toptextView release];
	[segLabel release];
	[segmentCntrl release];
	[topToolBar release];
	//[backButton release];
	[bioView release];
	[selBookView release];
	[_textfieldName release];
	[_textfieldPassword release];
    [super dealloc];
}



-(void)buyAction:(id)sender
{
	printf("\nbuyAction...");
	
	//[_downloadingOverlayView removeFromSuperview];
	//[_downloadingOverlayView release];
	if (appDelegate.loginAuthKey==nil||[appDelegate.loginAuthKey isEqualToString:@""]) {
		//[self _showAlert:@"Please Login" comment:@"Login in your account to buy book"];
		[self closeAction:sender];
		[self loginInPurchase];
		return;
		//appDelegate.loginAuthKey =@"9650ef957e71f654013e1319f3c72268";
	}
	[_downloadingOverlayView setHidden:TRUE];
	
	NSString *title = [(UIButton *)sender currentTitle];
	
	if ([title isEqualToString:@"Download Now"]) {
		
		//[self closeAction:sender];
		//		[_downloadingOverlayView setHidden:FALSE];
		//		kInAppPurchaseProUpgradeProductId = [NSString stringWithString:_selectedbookISBNnumber];
		//		[self requestProUpgradeProductData];
		//		
		//		if([self canMakePurchases]==YES)
		//			[self purchaseProUpgrade]; 
		//		return;
		if (_downloading_Progress==TRUE) {
			[self _showAlert:@"Please wait" comment:@"Another book downloading is in progress. "];
			[self closeAction:sender];
			return;
		}
		else {
			
			@try {
				
				
				appDelegate.bookPurchased =TRUE;
				[NSThread detachNewThreadSelector:@selector(startBookDownloading:) toTarget:self withObject:nil];	
				
			}
			@catch (NSException * e) {
				
			}
			
		}
		
		_downloading_Progress = TRUE;
		
		[self closeAction:sender];
		
	}
	else {
		//[self _showAlert:@"Book Purchase " comment:@"Comming soon .."];
		//return;
		[self closeAction:sender];
		[_downloadingOverlayView setHidden:FALSE];
		kInAppPurchaseProUpgradeProductId = [NSString stringWithString:_selectedbookISBNnumber];
		[self requestProUpgradeProductData];
		
		if([self canMakePurchases]==YES)
			[self purchaseProUpgrade]; 
	}
	
}

-(void)loginInPurchase
{
	
	[_downloadingOverlayView setHidden:FALSE];
	
	
	
	
	UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Please Login!" message:@"\n \n \n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	[alertview setTag:3];
	// Adds a username Field
	_textfieldName = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)]; _textfieldName.placeholder = @"Username";
	[_textfieldName setBackgroundColor:[UIColor whiteColor]]; [alertview addSubview:_textfieldName];
	_textfieldName.keyboardType = UIKeyboardTypeAlphabet;
	_textfieldName.keyboardAppearance = UIKeyboardAppearanceAlert;
	_textfieldName.autocorrectionType = UITextAutocorrectionTypeNo;
	
	// Adds a password Field
	_textfieldPassword = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 80.0, 260.0, 25.0)]; _textfieldPassword.placeholder = @"Password";
	[_textfieldPassword setSecureTextEntry:YES];
	[_textfieldPassword setBackgroundColor:[UIColor whiteColor]]; [alertview addSubview:_textfieldPassword];
	_textfieldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
	_textfieldPassword.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	_textfieldPassword.keyboardAppearance = UIKeyboardAppearanceAlert;
	_textfieldPassword.autocorrectionType = UITextAutocorrectionTypeNo;
	_textfieldPassword.secureTextEntry = YES;
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
//
//
//
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
//	[_downloadingOverlayView setHidden:TRUE];
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
//	[_downloadingOverlayView setHidden:TRUE];
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
////
//// call this before making a purchase
////
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
//		NSString * setOrderInfoUrl = [NSString stringWithFormat:@"%@/api/read?action=setorderinfo&authKey=%@&bookId=%d",serverIP,appDelegate.loginAuthKey,_selectedBookIndex];
//		NSURL *url = [[NSURL alloc] initWithString:setOrderInfoUrl];
//		NSData *data = [[NSData alloc]initWithContentsOfURL:url];
//		
//		NSString * str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//		if ([str rangeOfString:@"<IsSuccess>1"].location !=NSNotFound) {
//			_downloading_Progress = FALSE;
//		}
//		else {
//			// There may be problem in purchase  
//		}
//		
//		_downloading_Progress = FALSE;
//		
//		
//		
//		[_downloadingOverlayView setHidden:TRUE];
//	}
//}
//
//
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//	
//	if (alertView.tag = 3) {
//		if (buttonIndex != [alertView cancelButtonIndex])
//		{
//			NSLog(@"Name: %@", _textfieldName.text);
//			NSLog(@"Name: %@", _textfieldPassword.text);
//			
//			
//			NSString * fileUrl = [NSString stringWithFormat:@"%@/api/read?",serverIP];
//			fileUrl = [fileUrl stringByAppendingFormat:@"action=login&emailAddress=%@&password=%@",_textfieldName.text,_textfieldPassword.text ];
//			
//			
//			NSURL *url = [[NSURL alloc] initWithString:fileUrl];
//			NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
//			
//			//Initialize the delegate.
//			UserXMLParser *userDetailParser = [[UserXMLParser alloc]initXMLParser];
//			
//			//Set delegate
//			[xmlParser setDelegate:userDetailParser];
//			
//			//Start parsing the XML file.
//			BOOL success = [xmlParser parse];
//			//Set delegate
//			//Start parsing the XML file.
//			
//			if(success){
//				if(appDelegate.isValidLoginOrReg){
//					NSString *str = [NSString stringWithFormat:@"%@",appDelegate.userDetails] ;
//					NSLog(@"loginAuthKey %@",str);
//					appDelegate.loginAuthKey =[NSString stringWithFormat:@"%@",str] ;
//					appDelegate.isValidLoginOrReg = NO;
//					
//					[appDelegate LoadAllBooksData:FALSE];
//					UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Login Success" message:@"Now you can read your books" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
//					[errorAlert show];
//					[errorAlert release];
//					
//				}else {
//					NSString *str =[NSString stringWithFormat:@"%@", appDelegate.errorDetails] ;
//					NSLog(@"loginAuthKey %@",str);
//					UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"login Error" message:str  delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
//					[errorAlert show];
//					[errorAlert release];
//				}
//				
//			}
//			else{
//				UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"login Error" message:@"symbols like '.'', .. etc and blank spaces not allowed in form details'" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
//				[errorAlert show];
//				[errorAlert release];
//			}
//			[userDetailParser release];
//			[xmlParser release];
//			
//		}
//		else {
//			[_downloadingOverlayView setHidden:TRUE];
//		}
//		
//		
//	}
//	else 
//	{
//		
//		if(buttonIndex==1)
//		{
//			
//			Book* book = [[[Shelf sharedShelf] books] objectAtIndex: _selectedBookIndex+1];
//			
//			BookIndexViewController* bookIndexViewController = [[[BookIndexViewController alloc] initWithBook: book] autorelease];
//			
//			UINavigationController* navigationController = [[[UINavigationController alloc] initWithRootViewController: bookIndexViewController] autorelease];
//			if (navigationController != nil) {
//				[self presentModalViewController: navigationController animated: YES];
//			}
//		}
//		else {
//			NSLog(@"clickedButtonAtIndex ");
//			[_downloadingOverlayView setHidden:TRUE];
//		}
//		
//		
//		
//	}
//	
//	
//	
//	
//}
////
//// removes the transaction from the queue and posts a notification with the transaction result
////
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
//	[_downloadingOverlayView setHidden:TRUE];
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
//	[_downloadingOverlayView setHidden:TRUE];
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
//	[_downloadingOverlayView setHidden:TRUE];
//}
//
////
//// called when a transaction has failed
////
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
//	[_author_Name setHidden:TRUE];
//}
//
//#pragma mark -
//#pragma mark SKPaymentTransactionObserver methods
//
////
//// called when the transaction status is updated
////
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


@end