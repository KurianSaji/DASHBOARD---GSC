//
//  photoButton.m
//  photoLocater
//
//  Created by neo on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "photoButton.h"
#import "epubstore_svcAppDelegate.h"
 

/*#import "GANTracker.h"
static const NSInteger kGANDispatchPeriodSec = 10;
*/
@implementation photoButton
@synthesize dataImage;

@synthesize activityIndicator;
@synthesize videoUserId;


- (id)initWithFrame:(CGRect)frame {
	
	
	/********************************GOOGLE ANALYTICS CODE**************************************************/	
//	[[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-25758329-1"
//										   dispatchPeriod:kGANDispatchPeriodSec
//												 delegate:nil];
//	NSError *error1;
//	
//	if (![[GANTracker sharedTracker] setCustomVariableAtIndex:1
//														 name:@"Photo Locator"
//														value:@"iv1"
//													withError:&error1]) {
//		NSLog(@"error in setCustomVariableAtIndex");
//	}
//	
//	
//	if (![[GANTracker sharedTracker] trackEvent:@"Photo Locator"
//										 action:@"Photo Locator Launch"
//										  label:@"Photo Locator Action"
//										  value:99
//									  withError:&error1]) {
//		NSLog(@"error in trackEvent");
//	}
//	
//	if (![[GANTracker sharedTracker] trackPageview:@"/PhotoLocator"
//										 withError:&error1]) {
//		NSLog(@"error in trackPageview");
//	}
	/******************************************************************************************************/
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        
		appDelegate=[[UIApplication sharedApplication]delegate];
    }
    
    
    
    
    
    
    return self;
    
}
-(void)loadImage:(NSString *)string isLast:(BOOL)last
{
    
    imageURL = string;
    
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
   	//activityIndicator.center=self.center;
    activityIndicator.frame = CGRectMake((self.frame.size.width-20)/2, (self.frame.size.height-20)/2, 20, 20);
    [self  addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
	isLast=last;
	NSURLConnection *connection=[NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]] delegate:self];
	if( connection )
	{
	/*	NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
		[NSURLCache setSharedURLCache:sharedCache];
		[sharedCache removeAllCachedResponses];
		[sharedCache release];*/
		
	}
	else
	{
		NSLog(@"theConnection is NULL");
	}
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	//if ([response expectedContentLength]>1) {
		dataImage = [[NSMutableData alloc] init];
	[dataImage setLength:0];
	//}
	//else {
		//dataImage =[NSMutableData dataWithCapacity:[response expectedContentLength]];
	//}

}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	
	[dataImage appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	
	[dataImage release];
	NSLog(@"Connection failed! Error - %@ %@",
		  
          [error localizedDescription],
		  
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
	
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
	[self setBackgroundImage:[UIImage imageWithData:dataImage] forState:UIControlStateNormal];
    NSString* lastComponent = [imageURL lastPathComponent];
    NSLog(@"lastComponent-- %@",lastComponent);
    NSArray *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSRange textRange=[[imageURL lowercaseString] rangeOfString:@"picture"];
    NSString *path;
    if(textRange.location != NSNotFound)
    {
        lastComponent = [NSString stringWithFormat:@"%@.jpg",self.videoUserId];
          path = [[searchPath objectAtIndex:0]  stringByAppendingString:[NSString stringWithFormat:@"/thumbData/%@",lastComponent]];
    }
    else
    {
          path = [[searchPath objectAtIndex:0]  stringByAppendingString:[NSString stringWithFormat:@"/thumbData/%@",lastComponent]];
    }
    
    if ([dataImage writeToFile:path atomically:YES] != FALSE) {
       // return TRUE;
    } else {
        //return FALSE; // Error
    }
    //self.tag
    
	self.userInteractionEnabled=YES;
	[dataImage release];
	
	dataImage=nil;
	
    [activityIndicator stopAnimating];
    
    
    
//    
//        UIImageView *imgOnBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        
//        UIImage *tempImg = [UIImage imageWithData:self.dataImage];
//        
//        NSLog(@"width,height = %f,%f",tempImg.size.width,tempImg.size.height);
//        UIImage *tempImg3;
//        //tempImg3 =[tempImg imageAtRect:CGRectMake((tempImg.size.width-210)/2.0, (tempImg.size.height-125)/2.0, 210  , 125)];
//        
//        
//        // UIImage *tempImg2 = [photoButton imageWithImage:tempImg3 scaledToSize:CGSizeMake(210, 125)];
//        
//        //tempImg3 = [photoButton scaleImage:tempImg toSize:CGSizeMake(210, 125)];
//        
//        
//        tempImg3 = [self imageByScalingAndCroppingForSize:tempImg toSize:CGSizeMake(210, 125)];
//        
//        imgOnBtn.image = tempImg3;
//        self.userInteractionEnabled=YES;
//        
//        [self addSubview:imgOnBtn];
//        
//        [imgOnBtn release];
//        
//        imgOnBtn=nil;
//
//  
    
      
	
}
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)targetSize {
    //If scaleFactor is not touched, no scaling will occur      
    CGFloat scaleFactor = 1.0;
    
    //Deciding which factor to use to scale the image (factor = targetSize / imageSize)
    if (image.size.width > targetSize.width || image.size.height > targetSize.height)
        if (!((scaleFactor = (targetSize.width / image.size.width)) > (targetSize.height / image.size.height))) //scale to fit width, or
            scaleFactor = targetSize.height / image.size.height; // scale to fit heigth.
    
    UIGraphicsBeginImageContext(targetSize); 
    
    //Creating the rect where the scaled image is drawn in
    CGRect rect = CGRectMake((targetSize.width - image.size.width * scaleFactor) / 2,
                             (targetSize.height -  image.size.height * scaleFactor) / 2,
                             image.size.width * scaleFactor, image.size.height * scaleFactor);
    
    //Draw the image into the rect
    [image drawInRect:rect];
    
    //Saving the image, ending image context
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage*)imageByScalingAndCroppingForSize:(UIImage*)image toSize:(CGSize)targetSize
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;        
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) 
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) 
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        }
        else 
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }       
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) 
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

/*-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	int x=[[self subviews] count];
	
	if (x>1) {
		[[self.subviews objectAtIndex:0] removeFromSuperview];
	}
	else {
		UIImageView *selectImage=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]] autorelease];
		selectImage.frame=self.frame;
		[self insertSubview:selectImage atIndex:0];
	}

	
}*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
	
}


@end
