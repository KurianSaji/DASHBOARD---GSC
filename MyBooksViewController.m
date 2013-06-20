//
//  MyBooksViewController.m
//  epubStore
//
//  Created by partha neo on 8/30/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "MyBooksViewController.h"
#import "Book.h"
#import "Shelf.h"
#import "BookIndexViewController.h"
#import "Catalog.h"
#import "OneBookDetails.h"
#import "AnimatedGif.h"


@implementation MyBooksViewController

NSInteger nRowL = 3;
NSInteger nColL = 3;
NSInteger totCntL = 9;

UIAlertView *downloadPopup;
NSMutableArray * myBookSortedArray;
NSMutableArray *downloaderStackArray;
BOOL bookOpenToRead = FALSE;


@synthesize scrollView;

//UIActivityIndicatorView *progressView;

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

-(id)init
{
	if(self = [super init])
	{
		
			
		myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
//Memory leak issue		myView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"books-display-pg copy.png"]];
		myView.backgroundColor = [UIColor blackColor];
		[self.view addSubview:myView];
		
		headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 120)];
		headerView.backgroundColor = [UIColor clearColor];
		[myView addSubview:headerView];
		
		scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 111, 768, 840)];
		scrollView.backgroundColor = [UIColor clearColor];
		scrollView.scrollEnabled = TRUE;
		scrollView.alwaysBounceVertical = TRUE;
		scrollView.alwaysBounceHorizontal = FALSE;
		scrollView.directionalLockEnabled=YES;
		scrollView.delegate = self;
		[scrollView setContentSize:CGSizeMake(768, 1024)];
		[myView addSubview:scrollView];		
		bookOpenToRead = FALSE;
		
			
	}
	return self;
}


#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];
	

	

    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (appDelegate.loginAuthKey ==nil ||[appDelegate.loginAuthKey isEqualToString:@""]) {
		for(UIView *subview in scrollView.subviews)
		{
			[subview removeFromSuperview];
		}
		[self loadHeaderView];
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Sign In" message:@"Please Sign In to your account, to view your books." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
		
		return;
	}
	if (appDelegate.bookPurchased ==TRUE) {
		
		[appDelegate.bookListArray removeAllObjects];
		[appDelegate.booksDetailsArray removeAllObjects];
		[appDelegate.bookListArray release];
		[appDelegate.booksDetailsArray release];
		
		[appDelegate LoadAllBooksData:segmentCntrl.selectedSegmentIndex];
		bookOpenToRead = FALSE;
	}
	
	if (bookOpenToRead ==FALSE) {
		[self loadHeaderView];
		[self getPurchasedBookList]; 
		[self loadScrollView];
		if ([downloaderStackArray count]>0) {
			for (int k =0; k<[downloaderStackArray count]; k++) {
		        [NSThread detachNewThreadSelector:@selector(DownloadEpubBooks:) toTarget:self withObject:[downloaderStackArray objectAtIndex:k]];
				
			}
		}
	}
	else {
		bookOpenToRead = FALSE;
	}

	
}

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
	   
	    NSString * filename = [NSString stringWithFormat:@"/%@/%@",ISBN_number,bookName];  // no need to give .epub here 
		NSData *epubBookData = [[NSData alloc]initWithContentsOfURL:bookURL];
		if (epubBookData!=nil) {
		    /*********** save Book  **************/
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:filename] retain];
			[[ NSFileManager defaultManager] createDirectoryAtPath:dataFilePath attributes:nil];
			[epubBookData writeToFile:dataFilePath atomically:YES];
			
			
		//	[[Shelf sharedShelf] createBookFromCatalogEntry: epubBookData Name:[NSString stringWithFormat:@"%@.epub",bookName]];
		    
			
			
			/***********  Loader Bar Disable ***********/
			UIView *contentView1= [scrollView viewWithTag:index+1];
			UIImageView *loader = [contentView1 viewWithTag:25];
			[loader removeFromSuperview];
			contentView1.userInteractionEnabled = TRUE;
		}
	else
	{
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Download Book" message:@"You must be connected to Internet to download this book" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];		
		// Download Failed
	}
	   [pool release]; 
	
}

-(void)unzipBooks {
	
	NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
	NSArray *dirContents = [[NSFileManager defaultManager] directoryContentsAtPath:bundleRoot];
	
	
	
	for (NSString *s in dirContents){
		{
			if([s hasSuffix:@".epub"])
			{
				NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:s ofType:@""]];
				[[Shelf sharedShelf] createBookFromCatalogEntry: data Name:s];
			}
		}
	}
	NSString *documentsDirectory = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Epub Books"];
	NSFileManager *manager = [NSFileManager defaultManager];
	NSArray *fileList = [manager directoryContentsAtPath:documentsDirectory];
	for (NSString *s in fileList){
		NSLog(@"%@",s);
	}
	
	
	NSLog(@"alertview about to dismiss");
	
	//[downloadPopup dismissWithClickedButtonIndex:0 animated:YES];
	//[downloadPopup release];
	NSLog(@"alertview dismissed");
	
	
}

-(BOOL)IsBookInShelf
{
	NSString *url = [NSString stringWithFormat: @"%@/Books.archive", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0]]; 
	//NSLog(@"My - url %@",url);
	//BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:url];
	return [[NSFileManager defaultManager] fileExistsAtPath:url];
}

-(void)loadHeaderView
{
	UILabel *bkstrName = [[UILabel alloc] initWithFrame:CGRectMake(17, 0, 600, 40)];
	bkstrName.text = @"BILL HYBELS BOOK STORE";
	bkstrName.textAlignment = UITextAlignmentLeft;
	bkstrName.font = [UIFont fontWithName:@"Trebuchet MS" size:18];
	bkstrName.backgroundColor = [UIColor clearColor];
	bkstrName.textColor = [UIColor blackColor];
	[headerView addSubview:bkstrName];
	[bkstrName release];
		
	UILabel *tabTitle = [[UILabel alloc] initWithFrame:CGRectMake(17, 40, 200, 35)];
	tabTitle.text = @"MY BOOKS";
	tabTitle.font = [UIFont fontWithName:@"Trebuchet MS" size:16];
	tabTitle.textAlignment = UITextAlignmentLeft;
	tabTitle.backgroundColor = [UIColor clearColor];
	tabTitle.textColor = [UIColor whiteColor];
	[headerView addSubview:tabTitle];
	[tabTitle release];	
	
	NSArray *itemsSeg = [NSArray arrayWithObjects: @"Title", @"Release Date", nil];
	
	segmentCntrl = [[UISegmentedControl alloc] initWithItems:itemsSeg];
	//segmentCntrl.opaque = YES;
	segmentCntrl.tintColor = [UIColor colorWithRed:125.0/255.0 green:150.0/255.0 blue:180.0/255.0 alpha:1.0];
	segmentCntrl.segmentedControlStyle = UISegmentedControlStyleBar;
	[segmentCntrl setFrame:CGRectMake(550, 40, 200, 25)];
	[segmentCntrl setSelectedSegmentIndex:0];
	[segmentCntrl addTarget:self action:@selector(segmentAction:) 
		   forControlEvents:UIControlEventValueChanged];
	[headerView addSubview:segmentCntrl];

}

-(void)getPurchasedBookList
{
	myBookSortedArray = [[NSMutableArray alloc]init];
	downloaderStackArray = [[NSMutableArray alloc]init];
	for(int ind = 0; ind < [appDelegate.bookListArray count]; ind++)
	{
		BookDetails *mybookDetail = (BookDetails *)[appDelegate.bookListArray objectAtIndex:ind];
		if (![mybookDetail.Purchased isEqualToString:@"0"]) {
			
			[myBookSortedArray addObject:[appDelegate.bookListArray objectAtIndex:ind]];
	     }
		//[mybookDetail release];
	}
}
-(void)loadScrollView
{
	//int height = ([bookCoverView count] - totCntL)/(totCntL);
//	int height = ([myBookSortedArray count]+1 - totCntL)/(totCntL);
	
	int i = 0;
	int singleContentViewSize = 0;
	//[scrollView setContentSize:CGSizeMake(768, 1024+(height*(1024-50))+300)];	
	
	NSLog(@"%@",[scrollView subviews]);
	for(UIView *subview in scrollView.subviews)
	{
		[subview removeFromSuperview];
	}
	
	
	//for(int row = 0; row < (([myBookSortedArray count]/nRowL)+height); row++)  //for(int row = 0; row < (([bookCoverView count]/nRowL)+height); row++)
//	{
		
		for(int row = 0; row < ([myBookSortedArray count]+1)/2; row++)
	   {
		   
		for(int col = 0; col < nColL; col++)
		{
			if(i < [myBookSortedArray count]) //if(i < [bookCoverView count])
			{
				CGRect contentFrame = CGRectMake((250*col)+60, (300*row)+10, 154, 298);
				CGRect imageFrame = CGRectMake(0, 0, 154,231);
				
				UIView *contentView = [[UIView alloc] initWithFrame:contentFrame];
				contentView.backgroundColor = [UIColor clearColor];
				
				UIImageView *coverImage = [[UIImageView alloc] initWithFrame:imageFrame];
				//coverImage.image = [UIImage imageNamed:bookdetailsObj.coverImage];
				
				
				BookDetails *mybookDetail = (BookDetails *)[myBookSortedArray objectAtIndex:i];
				[mybookDetail retain];
				NSString *imagePath = [NSString stringWithFormat:@"/%@/%@",mybookDetail.ISBNNumber,[mybookDetail.CoverPhoto lastPathComponent]];
				
				
				if (![appDelegate checkFileExist:imagePath]) {
					coverImage.image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"images.jpg"]] ];
				}
				else
			    {
					NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
					NSString *documentsDirectory = [paths objectAtIndex:0];
					NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:imagePath] retain];
					coverImage.image = [UIImage imageWithContentsOfFile:dataFilePath];
				}
		
				coverImage.tag = 9999; 
				MyCustomButton *scrollButton = [[MyCustomButton alloc] initWithIndex:i];
				[scrollButton setFrame:imageFrame];
				[scrollButton addTarget:self action:@selector(readerAction:) 
					   forControlEvents:UIControlEventTouchUpInside];
				scrollButton.clipsToBounds = YES;
				scrollButton.contentMode = UIViewContentModeScaleToFill;
				
				UIImageView *shadowImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 231, 154, 67)];
				shadowImage.image =[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"big_book_shadow.png"] ];// [UIImage imageNamed:@"big_book_shadow.png"];
				
				[contentView setTag:i+1];
				[contentView addSubview:shadowImage];
				[shadowImage release];
				
				
				[scrollButton addSubview:coverImage];
				
								
				[contentView addSubview:scrollButton];
				[scrollButton release];
				[scrollView addSubview:contentView];
				/* add Loader */
				NSString * filename = [NSString stringWithFormat:@"/%@/%@.epub",mybookDetail.ISBNNumber,mybookDetail.Name];
				if (![appDelegate checkFileExist:filename]) {
					
					
					NSURL 			* firstUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"loader" ofType:@"gif"]];
					UIImageView 	* loader = 	[AnimatedGif getAnimationForGifAtUrl: firstUrl];
					[loader setFrame:CGRectMake(8, coverImage.frame.size.height+5,contentView.frame.size.width,30)];
					//loader.frame = contentView.frame;
					[contentView addSubview:loader];
					/* Tag is Given for disabling the loader view */
					[loader setTag:25];
					contentView.userInteractionEnabled = FALSE;
					//[loader release];
					
					/*     Added the url with the button index to disable the loader image */					
					[downloaderStackArray addObject:[NSString stringWithFormat:@"%@##$##%d",mybookDetail.MagazinePDFFilePath,i]];
					
					
				}
				[coverImage release];
				singleContentViewSize = contentView.frame.size.height;
				[contentView release];
				
				[mybookDetail release];
				mybookDetail = nil; 
				
				i++; 
				
			}
		}
	}
	if ([myBookSortedArray count]<=9) {
		[scrollView setContentSize:CGSizeMake(750,scrollView.frame.size.height)];	
	}
	else {
		[scrollView setContentSize:CGSizeMake(750,(([myBookSortedArray count]+1)/2*singleContentViewSize))];	
	}
	
}

-(void)readerAction:(MyCustomButton *)sender
{
	printf("\n readerAction:: %d", [sender index]);
	
	
	
	int selectedIndex = [sender index];
	//checkFileExist
	
	BookDetails *myBookDetail = [myBookSortedArray objectAtIndex:selectedIndex]; 
    //NSString * filename = [NSString stringWithFormat:@"/%@/%@.epub",myBookDetail.ISBNNumber,myBookDetail.Name];
	 NSString * filename = [NSString stringWithFormat:@"/%@.epub",myBookDetail.Name];
	if ([appDelegate checkFileExist:filename]) {
		
		
		
	}
	
	//Download Book Start
	else {
	
		   
			NSURL * bookURL = [[NSURL alloc]initWithString:myBookDetail.MagazinePDFFilePath];
			NSData *epubBookData = [[NSData alloc]initWithContentsOfURL:bookURL];
		    if (epubBookData!=nil) {
				
				NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *documentsDirectory = [paths objectAtIndex:0];
				NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:filename] retain];
				[[ NSFileManager defaultManager] createDirectoryAtPath:dataFilePath attributes:nil];
			    [epubBookData writeToFile:dataFilePath atomically:YES];
			    [[Shelf sharedShelf] createBookFromCatalogEntry: epubBookData Name:[NSString stringWithFormat:@"%@.epub",myBookDetail.Name]];
			
			 
				
			//Hit server to send acknowledgement 
			
			NSString * setOrderInfoUrl = [NSString stringWithFormat:@"%@/api/read?action=setorderinfo&authKey=%@&bookId=%@",serverIP,appDelegate.loginAuthKey,myBookDetail.IDValue];
			NSURL *url = [[NSURL alloc] initWithString:setOrderInfoUrl];
			NSData *data = [[NSData alloc]initWithContentsOfURL:url];
			
			NSString * str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
			if ([str rangeOfString:@"<IsSuccess>1"].location !=NSNotFound) {
				
			//change button String to read 
				
			}
			else {
				
			}
			
			@try {
				
				// Change the button text to read 
				
			}
			@catch (NSException * e) {
				
			}
		}
		
	}

	
	Book* book = [[Book alloc]init];
	book.fileName = myBookDetail.Name;
	book.author = myBookDetail.Author;
	book.title = myBookDetail.Name;
	bookOpenToRead = TRUE;
	BookIndexViewController* bookIndexViewController = [[[BookIndexViewController alloc] initWithBook: book] autorelease];
	UINavigationController* navigationController = [[[UINavigationController alloc] initWithRootViewController: bookIndexViewController] autorelease];
	if (navigationController != nil) {
		[self presentModalViewController: navigationController animated: YES];
	}
	self.navigationController.navigationBarHidden = TRUE;
	
	
}

-(void)segmentAction:(id)sender
{
	printf("\n segmentAction...");	
	
	if(segmentCntrl.selectedSegmentIndex == 0)
	{
		printf("\n ...");
		[appDelegate LoadAllBooksData:FALSE];
		
	}
	else if(segmentCntrl.selectedSegmentIndex == 1)
	{
		printf("\n New...");	
		[appDelegate LoadAllBooksData:TRUE];
		
	}
	[self getPurchasedBookList];
	[self loadScrollView];
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
            NSLog(@"didReceiveMemoryWarning mybooksviewController=========================");
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc
{
	[myBookSortedArray release];
	[myView release];
	[headerView release];
	[scrollView release];
    [super dealloc];
}


@end

