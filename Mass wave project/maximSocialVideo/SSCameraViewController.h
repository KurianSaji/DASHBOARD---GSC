//
//  SSCameraViewController.h
//  maximSocialVideo
//
//  Created by neo on 14/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "epubstore_svcAppDelegate.h"

@protocol mediapostDelegate <UIImagePickerControllerDelegate>

-(void)goToLibrary;

@end


@interface SSCameraViewController : UIImagePickerController<UIImagePickerControllerDelegate, mediapostDelegate>
{
    NSMutableSet *_activeRequests;
    
    UIView *vl_BottomTabView;
    
    UIButton *btnStartRecord, *btnStopRecord;

}
@property(assign)id<mediapostDelegate>_mdelegate;
 

@end
