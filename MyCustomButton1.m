//
//  MyCustomButton.m
//  epubStore
//
//  Created by partha neo on 8/31/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "MyCustomButton1.h"

@implementation MyCustomButton1

@synthesize strThumUrl,connection,data,activityIndicator,ImageID;
@dynamic isLoaded;

//#pragma mark -
//#pragma mark NetConnection
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
		[activityIndicator release];
	}
	[activityIndicator startAnimating];
}

-(void) stopLoader
{
	if (activityIndicator!=nil)
	{
		[activityIndicator stopAnimating];
	}
}
- (void)loadImageFromURL
{
	if (isLoaded==FALSE)
	{
		if (activityIndicator==nil)
		{
			activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((self.frame.size.width/2),(self.frame.size.height/2), 10,10)];
			[self addSubview:activityIndicator];
			[activityIndicator release];
		}
		[activityIndicator startAnimating];
		NSLog(@"strThumUrl===>%@",strThumUrl);
		NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:strThumUrl]
												 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0];
		
		connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection 
{
	UIImage *imgThumb;
	NSString *urlName;
	
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
	[connection release];
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error {
	NSLog(@"Image download data error");
	if (activityIndicator!=nil)
	{
		[activityIndicator startAnimating];
	}
	isLoaded=NO;
    [connection release];
}

//#pragma mark -

@end
