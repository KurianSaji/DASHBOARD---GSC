//
//  RootViewController.m
//  epubstore_svc
//
//  Created by partha neo on 9/1/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"

#import "epubstore_svcAppDelegate.h"

@implementation RootViewController

epubstore_svcAppDelegate *appDelegate;
@synthesize detailViewController;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
	appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
	//[self.navigationController setNavigationBarHidden:FALSE];
	//self.view.frame = CGRectMake(0, 40, 300, 300);
	//self.navigationController.navigationBar.hidden = NO;	
	//self.tableView.frame = CGRectMake(100, 100, 300, 300);
	//self.wantsFullScreenLayout = NO;
	
	//epubstore_svcAppDelegate *appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
	//appDelegate.splitViewController.navigationController.navigationBarHidden = NO;
	
	/*UIViewController *rootVC = [appDelegate.splitViewController.viewControllers objectAtIndex:0];
	UIViewController *masterVC = [appDelegate.splitViewController.viewControllers objectAtIndex:1];
	
	rootVC.view.frame = CGRectMake(0, 60, 100, 400);

	*/	
	
	UIImageView *topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
	topImage.image = [UIImage imageNamed:@"top_white_bar.png"];//[UIImage imageNamed:@"popup_top_bar.png"];	
	//topImage.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:topImage];
	[topImage release];
	
	UILabel *setLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
	setLabel.text = @"Settings";
	setLabel.font = [UIFont boldSystemFontOfSize:20];
	setLabel.textAlignment = UITextAlignmentCenter;
	setLabel.backgroundColor = [UIColor clearColor];
	setLabel.textColor = [UIColor blackColor];
	[self.view addSubview:setLabel];
	[setLabel release];
	
	self.tableView.scrollEnabled = NO;
	self.tableView.separatorColor = [UIColor clearColor];
	//[self.tableView setBackgroundColor:[UIColor clearColor]]; //@"dn.asp.png"]]];
	[self.view setBackgroundColor:[UIColor grayColor]];//@"dn.asp.png"]]];//colorWithPatternImage:[UIImage imageNamed:@"dn.asp.copy.png"]
	//[self.view setBackgroundColor:[UIColor grayColor]];
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[self.tableView reloadData];
	
	detailViewController.detailItem =@"Row 1";
}

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

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark -
#pragma mark Size for popover
// The size the view should be when presented in a popover.
- (CGSize)contentSizeForViewInPopoverView {
    return CGSizeMake(320.0, 600.0);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

	return 40;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle=UITableViewCellSelectionStyleGray;
		
    }
    
    // Configure the cell.
    //cell.textLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
	cell.textLabel.textColor = [UIColor whiteColor];
	if(indexPath.section == 0)
	{
		if(indexPath.row == 0)
		{
			cell.textLabel.text = @"About This App";
		}
		else if(indexPath.row == 2)
		{
			cell.textLabel.text = @"About This App";
		}
		else if(indexPath.row == 1)
		{
			cell.textLabel.text = @"Preferences";
		}
	}
    return cell;
}


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

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//UITableViewCell *cell = (UITableViewCell *)[aTableView cellForRowAtIndexPath:indexPath];
	//cell.textLabel.textColor = [UIColor blackColor];
    /*
     When a row is selected, set the detail view controller's detail item to the item associated with the selected row.
     *///int row = indexPath.row;
		detailViewController.detailItem = [NSString stringWithFormat:@"Row %d", indexPath.row];
		//cell.textLabel.textColor = [UIColor blackColor];
			//cell.textLabel.text = @"Sign In / Register";
				

}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}


@end

