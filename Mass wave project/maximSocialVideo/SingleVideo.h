//
//  SingleVideo.h
//  maximSocialVideo
//
//  Created by neo on 29/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "photoButton.h"
#import "photoButtonResize.h"
#import "epubstore_svcAppDelegate.h"

#import "avloader.h"

@protocol mediadetailDelegate

-(void)videoSelected;
-(void)userSelected;
-(void)enableLoader;
-(void)disableLoader;

@end


@interface SingleVideo : UIView
{

    avloader *_avloader;

    
    UIView *backgroundView;
    
    UIView *sv_mainView, *sv_detailView;

    UIActivityIndicatorView *activityIndicator;
    
    
   // mediadetails *_mediadetails;
    
   
    
    
}

@property(assign)id<mediadetailDelegate>_delegate;

@property(strong)NSString *videoThumbUrl, *userImageUrl, *createdDate, *videoDesc, *viewCount, *videoId, *videoUserId, *videoConversion, *commentsCount;

@property(strong)NSString *userType;

//@property(nonatomic, retain)mediadetails *_mediadetails;
 

-(NSMutableString *) getSubStringAfterH :  originalString:(NSString *)s0 ;

-(void)initSingleVideo;

-(void)setVideoThumb;

-(void)setVideoDetails;

@end
