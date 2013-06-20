//
//  socialView.m
//  DashBoard
//
//  Created by neo on 30/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "socialView.h"
#import "epubstore_svcAppDelegate.h"

@implementation socialView

@synthesize table;

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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	//NSDictionary *dictionary = [self.tableDataSource objectAtIndex:indexPath.row];
	cell.text = [arryData objectAtIndex:indexPath.row];
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger rowcount = [indexPath row];
	
	switch (rowcount) {
		case 0:
		{
			appdelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
			[appdelegate loginFB];
		}break;
		case 1:
		{
			appdelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
			[appdelegate loginTwitter];
		}break;
		case 2:
		{
			appdelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
			[appdelegate sendMail];
		}break;
		//case 3:
//		{
//			appdelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
//			[appdelegate loginFB];
//		}break;
			
		default:
			break;
	}
	
	
	
	
}


	
//-(IBAction)back
//{
//	[self.view removeFromSuperview];
//}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor darkGrayColor]];
	arryData = [[NSArray alloc] initWithObjects:@"Facebook",@"Twitter",@"Mail",nil];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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


@end
