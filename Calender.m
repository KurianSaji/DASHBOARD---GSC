//
//  Calender.m
//  Alarm
//
//  Created by Zaah Technologies India PVT on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Calender.h"


@implementation Calender
UIButton *btnToClock;
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
- (void)viewDidLoad {
    [super viewDidLoad];
	btnToClock = [[UIButton alloc]initWithFrame:CGRectMake(6, 35, 40, 40)];
	btnToClock.backgroundColor = [UIColor greenColor];
	[btnToClock addTarget:self action:@selector(btnToClockAction) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btnToClock];
}

-(void)btnToClockAction
{
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
