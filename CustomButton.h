//
//  MyCustomButton.h
//  epubStore
//
//  Created by partha neo on 8/31/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomButton : UIButton
{
	NSString *strThumUrl;
	NSString *ImageID;
	NSURLConnection *connection;
	NSMutableData *data;
	UIActivityIndicatorView *activityIndicator;
	BOOL isLoaded;
}
@property (nonatomic,retain) NSString *strThumUrl;
@property (nonatomic,retain) NSString *ImageID;
@property (nonatomic,retain) NSURLConnection *connection;
@property (nonatomic,retain) NSMutableData *data;
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicator;
@property (readonly, nonatomic, assign) BOOL isLoaded;
-(void)loadImage;
@property(retain)UIView *selectionView;

@end
