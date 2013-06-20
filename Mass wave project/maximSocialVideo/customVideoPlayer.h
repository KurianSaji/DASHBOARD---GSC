//
//  customVideoPlayer.h
//  maximSocialVideo
//
//  Created by neo on 19/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "photoButton.h"
#import "epubstore_svcAppDelegate.h"


@protocol mediadetails

-(void)onExitFullScreen;

-(void)setFullScreenValueTrue;

-(void)setFullScreenValueFalse;

@end

@interface customVideoPlayer : UIView    
{
    
    epubstore_svcAppDelegate *appDelegate;
    
    UIView *vl_VideoView, *vl_VideoControlView;
    
    MPMoviePlayerController *moviePlayerController;
    
    NSURL *videoUrl;
    BOOL fullscreen;
    
    
    
}

@property(assign)id<mediadetails>_delegate;

@property(nonatomic, retain) NSURL *videoUrl;

@property(nonatomic, retain) MPMoviePlayerController *moviePlayerController;

@property(nonatomic, getter=isFullscreen) BOOL fullscreen;

-(void)initCustomVideoPlayer;

-(void)stopAndRemoveVideo;

-(void)stopVideoPlaying;

-(void)playVideo;

-(void)setFullScreen:(BOOL)trueOrFalse;

-(BOOL)checkIsInFullScreen;

@end
