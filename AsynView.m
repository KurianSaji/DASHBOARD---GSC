//
//  AsynView.m
//  Syn_Demo
//
//  Created by neo on 12/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AsynView.h"


@implementation AsynView
@synthesize responseUrl;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		

        // Initialization code
    }
    return self;
}

- (void)loadImageFromURL:(NSURL*)url {
    if (connection!=nil) { [connection release]; }
    if (data!=nil) { [data release]; }
    NSURLRequest* request = [NSURLRequest requestWithURL:url
							cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
	
    connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	self.responseUrl=[response URL];
}

- (void)connection:(NSURLConnection *)theConnection
	didReceiveData:(NSData *)incrementalData {
    if (data==nil) {
		data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	
    [connection release];
    connection=nil;
	
   // NSString *strDescription = theConnection.description;
	NSString *last = [self.responseUrl lastPathComponent];
	NSString *thumbImg = [last stringByReplacingOccurrencesOfString:@">" withString:@""];	
	
	UIImage *catImage = [UIImage imageWithData:data];
    UIImageView* imageView = [[[UIImageView alloc] initWithImage:catImage] autorelease];
	[self addSubview:imageView];
	[self imageSaveToDocumentPath:catImage :thumbImg];

	[data release];
    data=nil;
}

- (UIImage*) image {
    UIImageView* iv = [[self subviews] objectAtIndex:0];
    return [iv image];
}


-(void)imageSaveToDocumentPath:(UIImage *)image :(NSString*)psFileName
{
	
	NSString *document_path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *string  = [NSString stringWithFormat:@"%@/%@",document_path,psFileName];
    BOOL exists = [self checkFileExist:psFileName];
    if(exists)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:string error:NULL];
    }
	
	[UIImagePNGRepresentation(image) writeToFile:string atomically:YES];
	
}

-(BOOL) checkFileExist:(NSString*)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:filename];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataFilePath];
    return fileExists;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
	[connection cancel];
    [connection release];
    [data release];
}


@end
