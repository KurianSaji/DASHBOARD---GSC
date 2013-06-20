//
//  CustomViewController.m
//  Graffitti Dashboard
//
//  Created by neo on 04/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomViewController.h"
#import "mmsvViewController.h"

@implementation CustomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    mmsvViewController *mmsView = [[mmsvViewController alloc] initWithNibName:@"mmsvViewController_iPhone" bundle:nil];
    [self.navigationController pushViewController:mmsView animated:NO];
    //[self.view addSubview:mmsView.view];
    
//    UINavigationController *navCont = [[UINavigationController alloc] initWithRootViewController:mmsView];
//    navCont.navigationBarHidden = YES;
//    [self.navigationController presentModalViewController:navCont animated:NO];
//    [navCont release]; 
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
