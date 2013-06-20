//
//  MyCustomButton.m
//  epubStore
//
//  Created by partha neo on 8/31/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

@synthesize strThumUrl,connection,data,activityIndicator,ImageID;
@synthesize selectionView;
@dynamic isLoaded;

#pragma mark -
#pragma mark NetConnection

-(void)setColorAtRect:(CGRect)rectFrame color:(UIColor*)bgColor
{
       if (self.selectionView==nil) 
    {
        UIView *extraview=[[UIView alloc]initWithFrame:rectFrame];
        [extraview setBackgroundColor:bgColor];
        self.selectionView=extraview;
        [self addSubview:self.selectionView];
        [extraview release];
    //    [self.selectionView release];
    //    self.selectionView=nil;
    }
    else
    {
        self.selectionView.frame=rectFrame;
        [self.selectionView setBackgroundColor:bgColor];
    }
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData 
{
	if (data==nil) 
	{
		data = [[NSMutableData alloc] initWithCapacity:2048];
	}
	[data appendData:incrementalData];
}
-(void) loadLoader
{
	if (activityIndicator==nil)
	{
		activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((self.frame.size.width/2),(self.frame.size.height/2), 10,10)];
		[self addSubview:activityIndicator];
	}
	[activityIndicator startAnimating];
}

-(void)loadImage
{
	if (isLoaded==FALSE)
	{
		if (activityIndicator==nil)
		{
			activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((self.frame.size.width/2),(self.frame.size.height/2), 10,10)];
			[self addSubview:activityIndicator];
		}
		[activityIndicator startAnimating];
		NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:strThumUrl]
												 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0];
		
		connection = [NSURLConnection connectionWithRequest:request delegate:self];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection 
{
	UIImage *imgThumb;
	//downloadCount++;
	
	imgThumb = [UIImage imageWithData:data];
	[self setImage:imgThumb forState:UIControlStateNormal];
	
	[activityIndicator stopAnimating];
	isLoaded=TRUE;
	if (activityIndicator!=nil)
	{
		[activityIndicator stopAnimating];
		[activityIndicator removeFromSuperview];
		[activityIndicator release];
		activityIndicator=nil;
	}
	
	[data release];
	data = nil;	
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error {
	
	if (activityIndicator!=nil)
	{
		[activityIndicator startAnimating];
	}
	isLoaded=NO;
}

#pragma mark -

@end
