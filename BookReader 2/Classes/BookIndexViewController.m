    //
//  BookIndexViewController.m
//  BookReader
//
//  Created by Zaah Technologies India PVT on 9/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BookIndexViewController.h"
#import "Shelf.h"
#import "BookContentViewController.h"


@implementation BookIndexViewController
@synthesize tableView;
@synthesize bookHeadingLabel;
@synthesize mybookButton;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.


- (id) initWithBook: (Book*) book
{
    if ((self = [super initWithNibName: @"BookIndexViewController" bundle: nil]) != nil) {
		book_ = [book retain];
		navigationDefinition_ = [[Shelf sharedShelf] parseNavigationDefinitionWithBook: book_];
		bookHeadingLabel.text = navigationDefinition_.bookName;
		
    }
    return self;
	
	
	
	//NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    
}
- (void)viewWillAppear:(BOOL)animated;
{
	self.navigationController.navigationBarHidden = TRUE;
}

- (void) dealloc
{
	[tableView release];
	[book_ release];
	[super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	//self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	//self.title = navigationDefinition_.bookName;
	//self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target: self action: @selector(close)] autorelease];
	
	//UIView *containerView =
//	[[[UIView alloc]
//	  initWithFrame:CGRectMake(0, 0, 768, 100)]
//	 autorelease];
//	UILabel *headerLabel =
//	[[[UILabel alloc]
//	  initWithFrame:CGRectMake(10, 20, 300, 40)]
//	 autorelease];
//	headerLabel.text = NSLocalizedString(@"Header for the table", @"");
//	headerLabel.textColor = [UIColor whiteColor];
//	headerLabel.shadowColor = [UIColor blackColor];
//	headerLabel.shadowOffset = CGSizeMake(0, 1);
//	headerLabel.font = [UIFont boldSystemFontOfSize:22];
//	headerLabel.backgroundColor = [UIColor clearColor];
//	[containerView addSubview:headerLabel];
//	[self.view addSubview:containerView];
//	
//	[self.tableView setFrame:CGRectMake(80, 150, 600,700 )];
	bookHeadingLabel.text = navigationDefinition_.bookName;
	tableView.rowHeight = 60;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	if (interfaceOrientation ==UIInterfaceOrientationPortrait) {
		
	}
	else {
	}

    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}





#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [navigationDefinition_.navigationPoints count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BookIndexViewControllerCell";
    
    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		// Set up the cell...
		cell.backgroundView =
		[[[UIImageView alloc] init] autorelease];
		cell.selectedBackgroundView =
		[[[UIImageView alloc] init] autorelease];
		
		NCXNavigationPoint* navigationPoint = [navigationDefinition_.navigationPoints objectAtIndex: indexPath.row];
		//cell.textLabel.text = navigationPoint.label;
		CGRect contentRect = CGRectMake(0, 0.0,550 , 60);
		UILabel *textView = [[UILabel alloc] initWithFrame:contentRect];
		
		textView.text = navigationPoint.label;
		//textView.numberOfLines = 2;
		textView.textColor = [UIColor blackColor];
		textView.backgroundColor =[UIColor clearColor];
		textView.font = [UIFont boldSystemFontOfSize:20];
		//textView.textAlignment = UITextAlignmentCenter;
		[cell.contentView addSubview:textView];
		[textView release];
		UIImage *selectedBG = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"list-select" ofType:@"png"]];
		
		((UIImageView *)cell.selectedBackgroundView).image = selectedBG;
		//[selectedBG release];
    }
    
    
	
    return cell;
}
- (IBAction) gotoMyBooks
{
	
	//[self.navigationController popToViewController:[[self.navigationController viewControllers]objectAtIndex:0] animated:YES ];
	//[self.navigationController popViewControllerAnimated:YES];
	[self dismissModalViewControllerAnimated:YES];
	
	
}

- (void)tableView: (UITableView*) tableView1 didSelectRowAtIndexPath: (NSIndexPath*) indexPath
{
	NCXNavigationPoint* navigationPoint = [navigationDefinition_.navigationPoints objectAtIndex: indexPath.row];
	
	BookContentViewController* bookContentViewController = [[BookContentViewController alloc] initWithBook: book_ navigationPoint: navigationPoint HtmlNameArray:navigationDefinition_.HTML_NamesArray];
	if (bookContentViewController != nil) {
		[self.navigationController pushViewController: bookContentViewController animated: YES];
		self.navigationController.navigationBarHidden = TRUE;
		
		//		[bookContentViewController release];
		//[self presentModalViewController:bookContentViewController animated:YES];
		bookContentViewController.headingLabel.text = navigationDefinition_.bookName;
		[bookContentViewController release];
		
	}
   [tableView1  deselectRowAtIndexPath:indexPath  animated:YES]; 

}




@end
