//
//  bottomTabBarController.m
//  MaximDashBoard
//
//  Created by neo on 8/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "bottomTabBarController.h"
#import <MediaPlayer/MPMoviePlayerViewController.h>
#import "epubstore_svcAppDelegate.h"

@implementation bottomTabBarController
@synthesize customizedTabBarView,isVideoPlaying;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{

 ///
    epubstore_svcAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.isVideoPlaying) 
    {
        return YES;
    }
    
	return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) ;
	
//	if(self.selectedIndex==1)
//	return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || interfaceOrientation == UIInterfaceOrientationLandscapeRight||interfaceOrientation == UIInterfaceOrientationLandscapeLeft) ;
//	
//	else {
//		return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) ;
//
//	}
//return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) ;
}

@end
