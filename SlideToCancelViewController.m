//
//  SlideToCancelViewController.m
//  SlideToCancel
//
//  Created by David Lasker on 9/14/09.
//  Copyright (c) 2009. Altos Design, Inc.  
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, 
//  are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, 
//    this list of conditions and the following disclaimer.
//
//  * Neither the name of Altos Design, Inc. nor the names of its contributors may be used 
//    to endorse or promote products derived from this software without specific prior 
//    written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
//  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
//  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
//  OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
//  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR 
//  TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
//  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

// Credits:
//
// The code using the iPhone UISlider class was adapted from this post:
// http://www.iphonedevsdk.com/forum/iphone-sdk-development/11470-there-way-i-can-use-slide-unlock-slider.html
//
// The code that filters out duplicate UIControlEventTouchUpInside events received from
// the UISlider class was adapted from this post:
// http://stackoverflow.com/questions/1063158/uislider-returns-two-touch-up-inside-events-why-does-that-happen
//
// The rendering code for animating the "slide to cancel" text was adapted from
// this post:
// http://stackoverflow.com/questions/438046/iphone-slide-to-unlock-animation
//
// The slider track and thumb images were made from a screen shot of the iPhone's home
// screen. Apple may object to use of these images in an app. I have not yet had an app 
// approved (or rejected either) using these images. Use at your own risk.

// Please note that THIS CODE ONLY DISPLAYS TEXT IN ROMAN ALPHABETS. For use with
// non-Roman (i.e. Asian) alphabets, the code in method
// - (void)drawLayer:(CALayer *)theLayer inContext:(CGContextRef)theContext
// must be re-written to use glyphs. See Apple's "Quartz 2D Programming Guide" 
// chapter "Drawing Text" for more info.

#import <QuartzCore/QuartzCore.h>

#import "SlideToCancelViewController.h"

#import "epubstore_svcAppDelegate.h"

@interface SlideToCancelViewController()

- (void) setGradientLocations:(CGFloat)leftEdge;
- (void) startTimer;
- (void) stopTimer;

@end

static const CGFloat gradientWidth = 0.2;
static const CGFloat gradientDimAlpha = 0.5;
static const int animationFramesPerSec = 8;

@implementation SlideToCancelViewController 

@synthesize delegate;
UIImage *trackImage;

// Implement the "enabled" property
- (BOOL) enabled {
	return slider.enabled;
}
- (void)viewWillAppear:(BOOL)animated  {
	
	
	UIApplication *thisApp = [UIApplication sharedApplication];
	thisApp.idleTimerDisabled = NO;
	thisApp.idleTimerDisabled = YES;
}
- (void) setEnabled:(BOOL)enabled{
	slider.enabled = enabled;
	label.enabled = enabled;
	if (enabled) {
		slider.value = 0.0;
		label.alpha = 1.0;
		touchIsDown = NO;
		[self startTimer];
	} else {
		[self stopTimer];
	}
}

- (UILabel *)label {
	// Access the view, which will force loadView to be called 
	// if it hasn't already been, which will create the label
	(void)[self view];
	
	return label;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)viewDidLoad{
	// Load the track background
	if([[UIScreen mainScreen] bounds].size.height == 1024)
		trackImage = [UIImage imageNamed:@"sliderTrack.png"];
	else
		trackImage = [UIImage imageNamed:@"sliderTrackiphone.png"];
	sliderBackground = [[UIImageView alloc] initWithImage:trackImage];
	
	// Create the superview same size as track backround, and add the background image to it
	UIView *view = [[UIView alloc] initWithFrame:sliderBackground.frame];
	[view addSubview:sliderBackground];
	
	// Add the slider with correct geometry centered over the track
	slider = [[UISlider alloc] initWithFrame:sliderBackground.frame];
	CGRect sliderFrame = slider.frame;
	if([[UIScreen mainScreen] bounds].size.height == 1024)
		sliderFrame.size.width = 728;
	else
		sliderFrame.size.width = 279;
	//sliderFrame.size.width -= 38; //each "edge" of the track is 23 pixels wide
	slider.frame = sliderFrame;
	slider.center = sliderBackground.center;	
	slider.backgroundColor = [UIColor clearColor];
	UIImage *thumbImage = [UIImage imageNamed:@"sliderThumb.png"];
	[slider setThumbImage:thumbImage forState:UIControlStateNormal];
	slider.minimumValue = 0.0;
	slider.maximumValue = 1.0;
	
	UIImage *stetchLeftTrack = [[UIImage imageNamed:@"redSlider.png"]
								stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
	UIImage *stetchRightTrack = [[UIImage imageNamed:@"redSlider.png"]
								 stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
	//[customSlider setThumbImage: [UIImage imageNamed:@"slider_ball.png"] forState:UIControlStateNormal];
	[slider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
	[slider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];

	
	slider.continuous = YES;
	slider.value = 0.0;
	[view addSubview:slider];
	
	// Set the slider action methods
	[slider addTarget:self 
			   action:@selector(sliderUp:) 
	 forControlEvents:UIControlEventTouchUpInside];
	[slider addTarget:self 
			   action:@selector(sliderDown:) 
	 forControlEvents:UIControlEventTouchDown];
	[slider addTarget:self 
			   action:@selector(sliderChanged:) 
	 forControlEvents:UIControlEventValueChanged];

	// Create the label with the actual size required by the text
	// If you change the text, font, or font size by using the "label" property,
	// you may need to recalculate the label's frame.
	NSString *labelText = NSLocalizedString(@"slide to snooze", @"SlideToCancel label");
	UIFont *labelFont = [UIFont systemFontOfSize:24];
	CGSize labelSize = [labelText sizeWithFont:labelFont];
	label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, labelSize.width, labelSize.height)];
	
	// Center the label over the slidable portion of the track
	CGFloat labelHorizontalCenter = slider.center.x + (thumbImage.size.width / 2);
	label.center = CGPointMake(labelHorizontalCenter, slider.center.y);
	
	// Set other label attributes and add it to the view
	label.textColor = [UIColor whiteColor];
	label.textAlignment = UITextAlignmentCenter;
	label.backgroundColor = [UIColor clearColor];
	label.font = labelFont;
	label.text = labelText;
	[view addSubview:label];

	// This property is set to NO (disabled) on creation.
	// The caller must set it to YES to animate the slider.
	// It should be set to NO (disabled) when the view is not visible, in order
	// to turn off the timer and conserve CPU resources.
	self.enabled = NO;
	
	// Render the label text animation using our custom drawing code in
	// the label's layer.
	label.layer.delegate = self;
	
	// Set the view controller's view property to all of the above
	self.view = view;
	
	// The view is retained by the superclass, so release our copy
	[view release];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
	
//	UIAlertView *alert = [[UIAlertView alloc] 
//						  initWithTitle:@"Warning" 
//						  message:@"You are running out of memory" 
//						  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//	[alert show];
//	[alert release];
	
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	[self stopTimer];
	[sliderBackground release], sliderBackground = nil;
	[slider release], slider = nil;
	[label release], label = nil;
}

// UISlider actions
- (void) sliderUp: (UISlider *) sender
{
	//filter out duplicate sliderUp events
	if (touchIsDown) {
		touchIsDown = NO;
		
		if (slider.value != 1.0)  //if the value is not the max, slide this bad boy back to zero
		{
			[slider setValue: 0 animated: YES];
			[self startTimer];
		}
		else 
		{
			
			UILocalNotification *localNotif = [[UILocalNotification alloc] init];
			if (localNotif == nil)
				return;
			//NSMutableArray *notificationArray =(NSMutableArray *) [[UIApplication sharedApplication] scheduledLocalNotifications];
			
			NSDate *now = [NSDate date];
			NSDate *scheduled = [now dateByAddingTimeInterval:120] ; //get x minute after
			//NSCalendar *calendar = [NSCalendar currentCalendar];
			
			localNotif.timeZone = [NSTimeZone defaultTimeZone];
			
			// Notification details
			localNotif.fireDate = scheduled;
			localNotif.alertBody = @"Snooze  for  2 minutes";
			// Set the action button
			localNotif.alertAction = @" Snooze";
			NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"Download", nil];
			localNotif.userInfo = infoDict;
			//localNotif.soundName = UILocalNotificationDefaultSoundName;
			localNotif.soundName = @"apple_alarm.mp3";
			
			localNotif.applicationIconBadgeNumber = 0;
			
			
			[[UIApplication sharedApplication] scheduleLocalNotification:localNotif];	
			//tell the delagate we are slid all the way to the right
			[delegate cancelled];
		}
	}
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) ;
}

- (void) sliderDown: (UISlider *) sender
{
	touchIsDown = YES;
}

- (void) sliderChanged: (UISlider *) sender
{
	// Fade the text as the slider moves to the right. This code makes the
	// text totally dissapear when the slider is 35% of the way to the right.
	
	label.alpha = MAX(0.0, 1.0 - (slider.value * 3.5));

	if (slider.value == 1) {
		
		//UILocalNotification *localNotif = [[UILocalNotification alloc] init];
//		if (localNotif == nil)
//			return;
//		//NSMutableArray *notificationArray =(NSMutableArray *) [[UIApplication sharedApplication] scheduledLocalNotifications];
//		
//		NSDate *now = [NSDate date];
//		NSDate *scheduled = [now dateByAddingTimeInterval:20] ; //get x minute after
//		NSCalendar *calendar = [NSCalendar currentCalendar];
//		
//		localNotif.timeZone = [NSTimeZone defaultTimeZone];
//		
//		// Notification details
//		localNotif.fireDate = scheduled;
//		localNotif.alertBody = @" new snooze ";
//		// Set the action button
//		localNotif.alertAction = @"Snooze";
//		
//		//localNotif.soundName = UILocalNotificationDefaultSoundName;
//		localNotif.soundName = @"Alarrr.wav";
//		
//		localNotif.applicationIconBadgeNumber = 0;
//		
//		
//		[[UIApplication sharedApplication] scheduleLocalNotification:localNotif];	
	}
	
	
	// Stop the animation if the slider moved off the zero point
	if (slider.value != 0) {
		[self stopTimer];
		[label.layer setNeedsDisplay];
	}
}

// animationTimer methods
- (void)animationTimerFired:(NSTimer*)theTimer {
	// Let the timer run for 2 * FPS rate before resetting.
	// This gives one second of sliding the highlight off to the right, plus one
	// additional second of uniform dimness
	if (++animationTimerCount == (2 * animationFramesPerSec)) {
		animationTimerCount = 0;
	}
	
	// Update the gradient for the next frame
	epubstore_svcAppDelegate *appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.window bringSubviewToFront:appDelegate.cancenView];
	[appDelegate.window bringSubviewToFront:appDelegate.slideToCancel.view];

	[self setGradientLocations:((CGFloat)animationTimerCount/(CGFloat)animationFramesPerSec)];
}

- (void) startTimer {
	if (!animationTimer) {
		animationTimerCount = 0;
		[self setGradientLocations:0];
		animationTimer = [[NSTimer 
						   scheduledTimerWithTimeInterval:1.0/animationFramesPerSec 
						   target:self 
						   selector:@selector(animationTimerFired:) 
						   userInfo:nil 
						   repeats:YES] retain];
	}
}

- (void) stopTimer {
	if (animationTimer) {
		[animationTimer invalidate];
		[animationTimer release], animationTimer = nil;
	}
}

// label's layer delegate method
- (void)drawLayer:(CALayer *)theLayer
        inContext:(CGContextRef)theContext
{
	// Set the font
	const char *labelFontName = [label.font.fontName UTF8String];
	
	// Note: due to use of kCGEncodingMacRoman, this code only works with Roman alphabets! 
	// In order to support non-Roman alphabets, you need to add code generate glyphs,
	// and use CGContextShowGlyphsAtPoint
	CGContextSelectFont(theContext, labelFontName, label.font.pointSize, kCGEncodingMacRoman);

	// Set Text Matrix
	CGAffineTransform xform = CGAffineTransformMake(1.0,  0.0,
													0.0, -1.0,
													0.0,  0.0);
	CGContextSetTextMatrix(theContext, xform);
	
	// Set Drawing Mode to clipping path, to clip the gradient created below
	CGContextSetTextDrawingMode (theContext, kCGTextClip);
	
	// Draw the label's text
	const char *text = [label.text cStringUsingEncoding:NSMacOSRomanStringEncoding];
	CGContextShowTextAtPoint(
		theContext, 
		0, 
		(size_t)label.font.ascender,
		text, 
		strlen(text));

	// Calculate text width
	CGPoint textEnd = CGContextGetTextPosition(theContext);
	
	// Get the foreground text color from the UILabel.
	// Note: UIColor color space may be either monochrome or RGB.
	// If monochrome, there are 2 components, including alpha.
	// If RGB, there are 4 components, including alpha.
	CGColorRef textColor = label.textColor.CGColor;
	const CGFloat *components = CGColorGetComponents(textColor);
	size_t numberOfComponents = CGColorGetNumberOfComponents(textColor);
	BOOL isRGB = (numberOfComponents == 4);
	CGFloat red = components[0];
	CGFloat green = isRGB ? components[1] : components[0];
	CGFloat blue = isRGB ? components[2] : components[0];
	CGFloat alpha = isRGB ? components[3] : components[1];

	// The gradient has 4 sections, whose relative positions are defined by
	// the "gradientLocations" array:
	// 1) from 0.0 to gradientLocations[0] (dim)
	// 2) from gradientLocations[0] to gradientLocations[1] (increasing brightness)
	// 3) from gradientLocations[1] to gradientLocations[2] (decreasing brightness)
	// 4) from gradientLocations[3] to 1.0 (dim)
	size_t num_locations = 3;
	
	// The gradientComponents array is a 4 x 3 matrix. Each row of the matrix
	// defines the R, G, B, and alpha values to be used by the corresponding
	// element of the gradientLocations array
	CGFloat gradientComponents[12];
	for (int row = 0; row < num_locations; row++) {
		int index = 4 * row;
		gradientComponents[index++] = red;
		gradientComponents[index++] = green;
		gradientComponents[index++] = blue;
		gradientComponents[index] = alpha * gradientDimAlpha;
	}

	// If animating, set the center of the gradient to be bright (maximum alpha)
	// Otherwise it stays dim (as set above) leaving the text at uniform
	// dim brightness
	if (animationTimer) {
		gradientComponents[7] = alpha;
	}

	// Load RGB Colorspace
	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
	
	// Create Gradient
	CGGradientRef gradient = CGGradientCreateWithColorComponents (colorspace, gradientComponents,
																  gradientLocations, num_locations);
	// Draw the gradient (using label text as the clipping path)
	CGContextDrawLinearGradient (theContext, gradient, label.bounds.origin, textEnd, 0);
	
	// Cleanup
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorspace);
}

- (void) setGradientLocations:(CGFloat) leftEdge {
	// Subtract the gradient width to start the animation with the brightest 
	// part (center) of the gradient at left edge of the label text
	leftEdge -= gradientWidth;
	
	//position the bright segment of the gradient, keeping all segments within the range 0..1
	gradientLocations[0] = leftEdge < 0.0 ? 0.0 : (leftEdge > 1.0 ? 1.0 : leftEdge);
	gradientLocations[1] = MIN(leftEdge + gradientWidth, 1.0);
	gradientLocations[2] = MIN(gradientLocations[1] + gradientWidth, 1.0);
	
	// Re-render the label text
	[label.layer setNeedsDisplay];
}

- (void)dealloc {
	[self stopTimer];
	[self viewDidUnload];
    [super dealloc];
}


@end
