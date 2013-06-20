//
//  Settings.m
//  BookReader
//
//  Created by pradeep on 8/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"

#import "epubstore_svcAppDelegate.h"
#import "BookContentViewController.h"
@implementation Settings

CGFloat fontSize =15;
BookContentViewController *bookContentViewControllerObj;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	appDelegate_ = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if([appDelegate_.fontName isEqualToString:@"none"]==TRUE)
	{
		appDelegate_.fontName = @"Georgia";
	}
	arrayColors = [[NSMutableArray alloc] init];
	NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont  familyNames]];
	NSArray *fontNames;
	for (NSInteger i=0; i < [familyNames count]; i++) {
		fontNames = [[NSArray alloc] initWithArray:
					 [UIFont fontNamesForFamilyName:
					  [familyNames objectAtIndex:i]]];
		for (NSInteger j=0; j < [fontNames count]; j++)
		{
			NSLog(@"%@", [fontNames objectAtIndex:j]);
			[arrayColors addObject:[fontNames objectAtIndex:j]];
		}
		[fontNames release];
	}
	[familyNames release];
	fontPickerview.delegate = self;
}
-(IBAction)increaseFontSize
{
	
	fontSize +=2;
	appDelegate_.fontSize+=10.0;
	if(appDelegate_.fontSize>180)
	{
		appDelegate_.fontSize=180.0;
		fontSize =35.0;
	}
	myTextLabel.font = [UIFont fontWithName:appDelegate_.fontName size:fontSize];
}
-(IBAction)decreaseFontSize
{
	fontSize -=2;
	appDelegate_.fontSize-=10.0;
	if(appDelegate_.fontSize<100)
	{
		appDelegate_.fontSize=100.0;
		fontSize =15.0;
	}
	myTextLabel.font = [UIFont fontWithName:appDelegate_.fontName size:fontSize];
}
-(IBAction)goBack
{
	if(bookContentViewControllerObj ==nil)
	{
		bookContentViewControllerObj =[[BookContentViewController alloc]init];
	}
	
	[bookContentViewControllerObj ReloadWebview:appDelegate_];
	[self dismissModalViewControllerAnimated:YES];
}
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	
	return [arrayColors count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	return [arrayColors objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	NSString *fontName =[arrayColors objectAtIndex:row];
	appDelegate_.fontName =fontName;
	myTextLabel.font = [UIFont fontWithName:fontName size:fontSize];
	
	
	NSLog(@"Selected Color: %@. Index of selected color: %i", [arrayColors objectAtIndex:row], row);
	
}

@end
