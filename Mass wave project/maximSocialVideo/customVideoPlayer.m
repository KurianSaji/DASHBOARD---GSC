//
//  customVideoPlayer.m
//  maximSocialVideo
//
//  Created by neo on 19/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "customVideoPlayer.h"
#import "epubstore_svcAppDelegate.h"

@implementation customVideoPlayer

@synthesize videoUrl;
@synthesize _delegate;
@synthesize fullscreen;

epubstore_svcAppDelegate *appDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)initCustomVideoPlayer
{
    int curSW = [[UIScreen mainScreen] bounds].size.width;
    int curSH = [[UIScreen mainScreen] bounds].size.height;
    
    int  tabFontFize, tabheight, tabButtonW, tabButtonH, videoW, videoH, controlTabH;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        tabFontFize = 10;
        tabheight = 24;
        tabButtonW = 70;
        tabButtonH = 24; 
        videoW = 281;
        videoH = 162;
        
    }
    else
    {
        
        tabFontFize = 25;
        tabheight = 468;
        tabButtonW = 161;
        tabButtonH = 52; 
        videoW = 698;
        videoH = 388;
        controlTabH =82;
    }    
    
    
    
    videoW = (282.0/320)*curSW;
    //videoH = (166.0/480)*curSH;
    
    appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.boolVideoPlayer==1)
    {
        videoH = (150.0/480)*curSH;

    }
    else
    {
        videoH = (203.0/480)*curSH;

    }
    
    
    
    // vl_VideoView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width ,tabheight )];
    //vl_VideoView.backgroundColor = [UIColor blackColor];
    
    ///[self addSubview:vl_VideoView];
    
    
    
    
    
    
    //videoUrl = [NSURL URLWithString:@"http://www.newtoybox.com/maximsocialmedia/video/video_url1.mp4"];
    
    
    
   // NSURL *tempURL = self.videoUrl;
    
    /*MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:self.videoUrl];
    moviePlayer.view.frame = CGRectMake(0, 0, videoW, videoH);
    moviePlayer.movieSourceType = MPMovieSourceTypeUnknown;
    moviePlayer.scalingMode=MPMovieScalingModeNone;
    moviePlayer.shouldAutoplay = YES;
    moviePlayer.controlStyle=MPMovieControlStyleEmbedded;
    [self addSubview:moviePlayer.view];
    [moviePlayer play];
    */
    moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:self.videoUrl];
    [moviePlayerController prepareToPlay];
    moviePlayerController.controlStyle=MPMovieControlStyleFullscreen;
    moviePlayerController.view.frame = CGRectMake(0, 0, videoW, videoH);
    moviePlayerController.controlStyle = MPMovieControlStyleDefault;
    
    //moviePlayerController.scalingMode = MPMovieScalingModeAspectFill; 
    moviePlayerController.movieControlMode = MPMovieControlModeDefault;
    //moviePlayerController.allowsAirPlay = YES;
    
    
   // MPMovieSourceType movieSourceType = MPMovieSourceTypeUnknown;
//    /* If we have a streaming url then specify the movie source type. */
//    if ([[self.videoUrl pathExtension] compare:@"mp4a" options:NSCaseInsensitiveSearch] == NSOrderedSame) 
//    {
//        movieSourceType = MPMovieSourceTypeStreaming;
//    }
//    //moviePlayerController.useApplicationAudioSession = NO;
//    moviePlayerController.movieSourceType = movieSourceType;
    [self addSubview:moviePlayerController.view];
    
    
    
    
    
    
    // Register for the playback finished notification. 
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(myMovieFinishedCallback) 
												 name:MPMoviePlayerPlaybackDidFinishNotification 
											   object:moviePlayerController];
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(setFullScreenTrue) 
												 name:MPMoviePlayerWillEnterFullscreenNotification 
											   object:moviePlayerController];
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(setFullScreenFalse) 
												 name:MPMoviePlayerWillExitFullscreenNotification 
											   object:moviePlayerController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitFullscreen) name:MPMoviePlayerDidExitFullscreenNotification object:nil];

}


-(void)setFullScreenTrue
{

    [_delegate setFullScreenValueTrue];

}
-(void)setFullScreenFalse
{

    [_delegate setFullScreenValueFalse];

}


-(void)exitFullscreen
{

    [_delegate onExitFullScreen];
   

}


-(void)stopAndRemoveVideo
{
    
    [moviePlayerController stop];
    moviePlayerController.initialPlaybackTime = -1.0;
    [moviePlayerController release];
    
}   
-(void)stopVideoPlaying
{
    [moviePlayerController stop];
    moviePlayerController.initialPlaybackTime = -1.0;

}

-(void)playPause
{
    
    [MPMoviePlayerController play];
    
}

-(void)playVideo
{
    [moviePlayerController prepareToPlay];
    [moviePlayerController play];


}

-(BOOL)checkIsInFullScreen
{
    if (moviePlayerController) 
    {
        fullscreen  = [moviePlayerController isFullscreen];
        return fullscreen;
    }
    
    
}


-(void)setFullScreen:(BOOL)trueOrFalse
{


    [moviePlayerController setFullscreen:trueOrFalse];


}

-(void)myMovieFinishedCallback
{
    
    
}




 


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
