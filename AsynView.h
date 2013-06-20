//
//  AsynView.h
//  Syn_Demo
//
//  Created by neo on 12/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HDBackgroundDemoOneAppDelegate;
@interface AsynView : UIView {
	
	NSURLConnection* connection;
    NSMutableData* data;
	HDBackgroundDemoOneAppDelegate *appDelegate;
	NSURL *responseUrl;

}
@property(nonatomic,retain)NSURL *responseUrl;
-(void)imageSaveToDocumentPath:(UIImage *)image :(NSString*)psFileName;
-(BOOL) checkFileExist:(NSString*)filename;
@end
