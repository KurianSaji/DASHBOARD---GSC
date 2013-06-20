//
//  photoButton.h
//  photoLocater
//
//  Created by neo on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "uiimageExt.h"

@class epubstore_svcAppDelegate;
@interface photoButton : UIButton{
	NSMutableData *dataImage;
	BOOL isLast;
	epubstore_svcAppDelegate *appDelegate;
    
    
    UIActivityIndicatorView *activityIndicator;
     NSString *imageURL;
    
}

@property(nonatomic, retain)NSString *videoUserId;
@property(strong)UIActivityIndicatorView *activityIndicator;


@property(nonatomic,retain)NSMutableData *dataImage;
-(void)loadImage:(NSString *)string isLast:(BOOL)last;
@end
