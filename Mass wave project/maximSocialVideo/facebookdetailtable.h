//
//  facebookdetailtable.h
//  maximSocialVideo
//
//  Created by neo on 10/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

 

#import <UIKit/UIKit.h>
#import "facebookdetailtable.h"
#import "epubstore_svcAppDelegate.h"
//#import "OverlayViewController.h"
#import "avloader.h"
#import "dataList_search.h"



@protocol searchViewDelegate

//

@end


@interface facebookdetailtable : UIViewController <searchViewDelegate>
{
    
    dataList_search *_dataList_search; 
    avloader *_avloader;
}

@property(assign)id<searchViewDelegate>_delegate;

@end
