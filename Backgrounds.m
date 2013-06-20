    //
//  Backgrounds.m
//  DashBoard
//
//  Created by Zaah Technologies on 09/07/11.
//  Copyright 2011 Zaah. All rights reserved.
//

#import "Backgrounds.h"
#import "HDLoopDemoViewController.h"

@implementation Backgrounds

@synthesize hdWall;
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
- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor clearColor]];
}

-(void)viewWillAppear:(BOOL)animated
{
	hdWall=[[HDLoopDemoViewController alloc] init];	
	[self.view addSubview:hdWall.view];
}

- (void)viewWillDisappear:(BOOL)animated
{

}

-(void) doRelease
{
	[hdWall.view removeFromSuperview];
	[hdWall release];
	hdWall=nil;	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return ((interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) || (interfaceOrientation == UIInterfaceOrientationPortrait));
	//return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) ;

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


@end
