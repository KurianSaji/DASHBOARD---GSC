//
//  facebookdetailtable.m
//  MyGrades
//
//  Created by Iphone on 12/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
/*
#import "facebookdetailtable.h"


@implementation facebookdetailtable

 // mmsvAppDelegate*appDelegate;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
/*- (void)viewDidLoad {
    [super viewDidLoad];
    
    
  /* _dataList_search =[[dataList_search alloc]initWithFrame:CGRectMake(0,30, self.view.frame.size.width ,self.view.frame.size.height)];
    
    [_dataList_search setDelegate:self];
    
    [self.view addSubview:_dataList_search];
  */  
	
	/*
	aTableView =[[UITableView alloc]initWithFrame:CGRectMake(0,30, 320,480)];
	//[aTableView setContentInset:UIEdgeInsetsMake(50,0,0,0)];
	[aTableView setBackgroundColor:[UIColor clearColor]];
	[aTableView setShowsVerticalScrollIndicator:NO];
	aTableView.separatorColor = [UIColor clearColor];
	[aTableView setDelegate:self];
	[aTableView setDataSource:self];
	[self.view addSubview:aTableView];	
	
	
	
	aSearchfbtab=[[NSMutableArray alloc]init];
	str=[[NSMutableArray alloc]init];
	
	searchBar = [[UISearchBar alloc] init];
	searchBar.frame = CGRectMake(0, 1, 320, 30);
	searchBar.delegate = self;
	[self.view addSubview:searchBar];
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	
	searching = NO;
	letUserSelectRow = YES;
     
     */
	
	
	
//}

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	
	if (searching)
		return [aSearchfbtab count];
	else {
		return [appDelegate.myarray count];
	}
	
	
	
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
    }
	
	if(searching)
	{
		str=[aSearchfbtab objectAtIndex:indexPath.row];
		
	}
	else
	{
	   str=[appDelegate.myarray objectAtIndex:indexPath.row];
	}
	NSLog(@"srray;;;%@",[str description]);
	
//	NSURL *url = [NSURL URLWithString:[[[appDelegate.myarray objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"pic"]];
	
	NSURL *url = [NSURL URLWithString:[[str objectAtIndex:0] objectForKey:@"pic"]];
NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *profilePic = [[[UIImage alloc] initWithData:data] autorelease];
	
	
	//cell.imageView.autoresizingMask = ( UIViewAutoresizingNone );
	//cell.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//
//	cell.imageView.autoresizesSubviews = NO;
//	//cell.imageView.contentMode = UIViewContentModeCenter;
//	cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
//
//	
//	cell.imageView.image =[UIImage imageWithData:data];
//	cell.imageView.bounds = CGRectMake(7, 2, 54, 46);
//	cell.imageView.frame = CGRectMake(7, 2, 54, 46);
	
	
	//cell.imageView.image=[profilePic drawInRect:CGRectMake(7, 2, 54, 46)];
	//cell.imageView.frame=CGRectMake(7, 2, 54, 46);
	UIImageView *bgImgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(7, 2, 54, 46) ];
	[bgImgView1 setImage:profilePic];
	[cell.contentView addSubview:bgImgView1];
	//[profilePic release];
	
	nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(80-10,0,320,20)];
	nameLabel.font = [UIFont boldSystemFontOfSize:15];
	nameLabel.textColor=[UIColor grayColor];
	nameLabel.backgroundColor=[UIColor clearColor];
	nameLabel.text=[[str objectAtIndex:0] objectForKey:@"name"];
	[cell addSubview:nameLabel];
	[nameLabel release];
	
	idLabel=[[UILabel alloc]initWithFrame:CGRectMake(80-10,15,320,20)];
	idLabel.font = [UIFont boldSystemFontOfSize:15];
	idLabel.backgroundColor=[UIColor clearColor];
	idLabel.text=[[str objectAtIndex:0] objectForKey:@"uid"];
	[cell addSubview:idLabel];
	[idLabel release];
	
	
	//UIImageView *img=[[UIImageView alloc]initWithImage:profilePic];
	
	// Set up the cell...
	//id cellValue = [appDelegate.myarray objectAtIndex:indexPath.row];
	//cell.text = [[[appDelegate.myarray objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"name"];
	//cell.detailTextLabel.text=[[[appDelegate.myarray objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"uid"];
	
	appDelegate.tabIndex=[indexPath row];
	
	NSLog(@"my index:%d",appDelegate.tabIndex);
	return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tv cellForRowAtIndexPath:indexPath];
	
	if(searching)
		str = [aSearchfbtab objectAtIndex:indexPath.row];
	else
		str = [appDelegate.myarray objectAtIndex:indexPath.row];
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	CGFloat height = 52;	
	return height;
}
- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
	//This method is called again when the user clicks back from teh detail view.
	//So the overlay is displayed on the results, which is something we do not want to happen.
	if(searching)
		return;
	
	//Add the overlay view.
	if(ovController == nil)
		ovController = [[OverlayViewController alloc] initWithNibName:@"OverlayView" bundle:[NSBundle mainBundle]];
	
	CGFloat yaxis = 0; //self.navigationController.navigationBar.frame.size.height;
	CGFloat width = self.view.frame.size.width;
	CGFloat height = self.view.frame.size.height;
	
	CGRect frame = CGRectMake(0, yaxis, width, height);
	ovController.view.frame = frame;	
	ovController.view.backgroundColor = [UIColor grayColor];
	ovController.view.alpha = 0.5;
	
	ovController.fbbooktableController = self;
	
	[aTableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
	
	//searching = YES;
	//letUserSelectRow = NO;
	//aTableView.scrollEnabled = NO;
	
	//Add the done button.
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
											  initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
											  target:self action:@selector(doneSearching_Clicked:)] autorelease];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	
	//Remove all objects first.
	[aSearchfbtab removeAllObjects];
	
	if([searchText length] > 0) {
		
		[ovController.view removeFromSuperview];
		searching = YES;
		letUserSelectRow = YES;
		aTableView.scrollEnabled = YES;
		//[searchBar resignFirstResponder];
		[self searchTableView];
	}
	else {
		
		[aTableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
		
		searching = NO;
		letUserSelectRow = NO;
		aTableView.scrollEnabled = NO;
		[self searchTableView];
	}
	
	[aTableView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	[searchBar resignFirstResponder];
}



- (void) searchTableView {
	
	
	
	NSString *searchText = searchBar.text;
	
	for (str in appDelegate.myarray)
	{
		NSString *sTemp =[[str objectAtIndex:0] objectForKey:@"name"];
		
		
		NSLog(@"my str....%@",str);
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch range:NSMakeRange(0, [searchText length])];
		//NSRange titleResultsRange ;
//		titleResultsRange.length=[searchText length];
//		titleResultsRange.location=0;
		//[sTemp rangeOfString:<#(NSString *)aString#> options:<#(NSStringCompareOptions)mask#> range:<#(NSRange)searchRange#>
		NSLog(@"Range-->%d", titleResultsRange.length);
		
		if (titleResultsRange.length > 0)
		{
			[aSearchfbtab addObject:str];
			
			//NSLog(@"string:%@",str1);
			NSLog(@"mytemp:%@",sTemp);
			NSLog(@"my search array:%@",[aSearchfbtab description]);
		}
		
		
	}NSLog(@"serach...%@",[aSearchfbtab description]);
	
}

- (void) doneSearching_Clicked:(id)sender {
	
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	self.navigationItem.leftBarButtonItem = nil;
	aTableView.scrollEnabled = YES;
	
	[ovController.view removeFromSuperview];
	[ovController release];
	ovController = nil;
	
	[aTableView reloadData];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	self.navigationItem.leftBarButtonItem = nil;
	aTableView.scrollEnabled = YES;
	
	[ovController.view removeFromSuperview];
	[ovController release];
	ovController = nil;
	
	//[aTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}
*/

//@end
