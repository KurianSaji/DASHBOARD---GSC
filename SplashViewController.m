//
//  SplashViewController.m
//  HDBackgroundDemoOne
//
//  Created by partha neo on 11/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SplashViewController.h"


@implementation SplashViewController

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
	self.navigationController.navigationBarHidden=YES;
	UIImage *splashImg =[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Default" ofType:@"png"]];
	aSplashImageView =[[UIImageView alloc]initWithImage:splashImg];
	[aSplashImageView setFrame:CGRectMake(0, 0, 320, 480)];
	[self.view addSubview:aSplashImageView];
	[aSplashImageView release];
	[splashImg release];
	
	[self performSelector:@selector(ApplicationStarts) withObject:nil afterDelay:5];
	
}
-(void)ApplicationStarts
{
	self.navigationController.navigationBarHidden=NO;
	[self.navigationController popViewControllerAnimated:NO];
}



//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//	// Return YES for supported orientations
//	return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
//	
//}

/*
-(void)fadeScreen{
		
	
	   // UIView beginAnimations:nil context:nil]; // begins animation block
		[UIView setAnimationDuration:0.75];        // sets animation duration
		[UIView setAnimationDelegate:self];        // sets delegate for this block
		[UIView setAnimationDidStopSelector:@selector(finishedFading)];   // calls the finishedFading method when the animation is done (or done fading out)	
		self.view.alpha = 0.0;       // Fades the alpha channel of this view to "0.0" over the animationDuration of "0.75" seconds
		[UIView commitAnimations];   // commits the animation block.  This Block is done.
	//[self.view removeFromSuperview];
}

- (void) finishedFading
{
	
	[UIView beginAnimations:nil context:nil]; // begins animation block
	[UIView setAnimationDuration:0.75];        // sets animation duration
	self.view.alpha = 1.0;   // fades the view to 1.0 alpha over 0.75 seconds
	//aSimpleViewController.view.alpha = 1.0;
	[UIView commitAnimations];   // commits the animation block.  This Block is done.
	[aSplashImageView removeFromSuperview];
}*/
/*
- (void)loadView {
	// Init the view
	CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
	UIView *view = [[UIView alloc] initWithFrame:appFrame];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	self.view = view;
	[view release];
	UIImage *image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"splash" ofType:@"jpg"]]; 
	splashImageView.image = image;
	splashImageView.frame = CGRectMake(0, 0, 320, 480);
	[self.view addSubview:splashImageView];
	[image release];
	[splashImageView release];
	
	
	//aSimpleViewController = [[SimpleTableViewController alloc] initWithNibName:@"SimpleTableViewController" bundle:[NSBundle mainBundle]];
	//aSimpleViewController.view.alpha = 0.0;
	//[self.view addSubview:aSimpleViewController.view];
	
	timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(fadeScreen) userInfo:nil repeats:NO];
}

-(void) onTimer{
	NSLog(@"LOAD");
}

- (void)fadeScreen
{
	[UIView beginAnimations:nil context:nil]; // begins animation block
	[UIView setAnimationDuration:0.75];        // sets animation duration
	[UIView setAnimationDelegate:self];        // sets delegate for this block
	//[UIView setAnimationDidStopSelector:@selector(finishedFading)];   // calls the finishedFading method when the animation is done (or done fading out)	
	self.view.alpha = 0.0;       // Fades the alpha channel of this view to "0.0" over the animationDuration of "0.75" seconds
	[UIView commitAnimations];   // commits the animation block.  This Block is done.
}


//- (void) finishedFading
//{
//	
//	[UIView beginAnimations:nil context:nil]; // begins animation block
//	[UIView setAnimationDuration:0.75];        // sets animation duration
//	self.view.alpha = 1.0;   // fades the view to 1.0 alpha over 0.75 seconds
//	//aSimpleViewController.view.alpha = 1.0;
//	[UIView commitAnimations];   // commits the animation block.  This Block is done.
//	[splashImageView removeFromSuperview];
//}



*/

 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
 
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


- (void)dealloc {
    [super dealloc];
}


@end
