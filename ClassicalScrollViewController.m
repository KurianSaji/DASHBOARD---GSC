
//
//  ClassicalScrollViewController.m
//  ClassicalScroll
//
//  Created by partha neo on 7/1Ï7/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "ClassicalScrollViewController.h"
#import "MyContentView1.h"
#import <AVFoundation/AVFoundation.h>
#import "TocXmlParser.h"
#import "TocOfBook_Class.h"
#import "epubstore_svcAppDelegate.h"
#import "test2.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@implementation ClassicalScrollViewController

@synthesize page_Book,detailItem,ABook;

@synthesize string_bookId,string_bookCount;
@synthesize containerScrollView;
@synthesize leftScrollView;
@synthesize rightScrollView;
@synthesize scrollView ;
@synthesize pageSlider ;
@synthesize pageNoLabel ;

@synthesize leftImageView;
@synthesize rightImageView;
@synthesize middleImageView;

@synthesize pdfPath;
@synthesize pdfBookID;
@synthesize StrFilename;


//UIScrollView *containerScrollView;
//UIScrollView *leftScrollView;
//UIScrollView *rightScrollView;
//UIScrollView * scrollView =nil;
//UISlider *pageSlider ;
//UILabel *pageNoLabel ;
//
//UIImageView *leftImageView;
//UIImageView *rightImageView;
//UIImageView *middleImageView;

//Debug & module variables
BOOL addThumbnail=FALSE;

static const float kMinWidth=768;
static const float kMaxWidth = 768*3;
int 	audioForPage[] = {0, 1, 1, 2, 3, 3, 4, 4, 5, 5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,16,16,17,17,18,18,0,0,0,0 };

UIView *_downloadingOverlayView;

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */



- (void)setDetailItem:(id)newPageBook
{
    if (detailItem != newPageBook) 
	{
        [detailItem release];
        detailItem = [newPageBook retain];
        
        // Update the view.
		
	}
	currentpage = [detailItem intValue];//-1
	[self MovetoPageAtIndex:currentpage];
	[pageSlider setValue:[detailItem floatValue]];
	
	//[self movedRightWhilePlaying];
	//Commented by karpagarajan	if(appDelegate.IsEnabledLinks)
	[self makeUrlClickble:currentpage];
	
    if (POVC_TableOC != nil) 
	{
        //[popoverController dismissPopoverAnimated:YES];
    }        
}





/*************
 -(void)nextButton
 {
 if(count < appDelegate.limit -1 )
 {
 count ++;
 Image *aimageLocal = [appDelegate.imageArray objectAtIndex:count];
 
 fileName1 =[NSString stringWithFormat:@"%@.png",aimageLocal.image];
 UIImage *image =[UIImage imageNamed:fileName1];
 [watchImgView setImage:image];
 int scrllX = myImageView.frame.origin.x-80;
 
 [UIView beginAnimations:nil context:nil];
 [UIView setAnimationDuration:0.75];
 [UIView setAnimationDelegate:self];
 [myImageView setFrame:CGRectMake(scrllX, 20, 60*appDelegate.limit , 60)];
 
 [UIView commitAnimations];
 }
 
 }
 
 
 -(void)PreviousButton{
 
 if(count > 0 )
 {
 count --;
 Image *aimageLocal = [appDelegate.imageArray objectAtIndex:count];
 NSString *fileName =[NSString stringWithFormat:@"%@.png",aimageLocal.image];
 UIImage *image =[UIImage imageNamed:fileName];
 [watchImgView setImage:image];
 int scrllX = myImageView.frame.origin.x+80;
 
 [UIView beginAnimations:nil context:nil];
 [UIView setAnimationDuration:0.75];
 [UIView setAnimationDelegate:self];
 [myImageView setFrame:CGRectMake(scrllX, 20, 60*appDelegate.limit , 60)];
 
 [UIView commitAnimations];
 }
 
 }
 
 ***************/




-(void)startProcessing
{
	//PdfTimer=[[NSTimer alloc]init];
	//[PdfTimer 
	i=0;
	PdfTimer= [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(timerTrigger) userInfo:nil repeats:YES];
	
}


-(void)timerTrigger 
{
	//[self performSelectorInBackground:@selector(saveImages3) withObject:nil];
/*	i++;
	if(i<=pageCount)
	{
		[self saveImages3];
		//[self saveImages31];
	}
	else 
	{
		pagecount=pageCount;
		[lbl setHidden:TRUE];
		[PdfTimer invalidate];
		[self showBook];
		imgview_topBar.frame = CGRectMake(0, 0, 768, 44);
		btn_close.frame=CGRectMake(730, 8, 27, 26);
		btn_Toc.frame =CGRectMake(680, 8, 27, 26);
	}*/
//Changed by Karpaga

	pagecount=pageCount;
	[lbl setHidden:TRUE];
	[PdfTimer invalidate];
	[self showBook];
	imgview_topBar.frame = CGRectMake(0, 0, 768, 44);
	btn_close.frame=CGRectMake(730, 8, 27, 26);
	btn_Toc.frame =CGRectMake(680, 8, 27, 26);
	
}



-(void) Create2Images:(NSString *) imgPath:(int) dcurrentpage
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imgPath];
	if (fileExists==FALSE)
	{
		
		CFURLRef pdfURL =   (CFURLRef)[[NSURL alloc] initFileURLWithPath:self.pdfPath]; 
		
		CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
		CFRelease(pdfURL);
		[[ NSFileManager defaultManager] createDirectoryAtPath:[DOCUMENTS_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",ABook.IDValue]] attributes:nil];
		
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, 
													 768, 
													 1024, 
													 8,			/* bits per component*/
													 768 * 4, 	/* bytes per row */
													 colorSpace, 
													 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
		CGColorSpaceRelease(colorSpace);
		
		CGContextClipToRect(context, CGRectMake(0, 0, 768, 1024));
		
		CGPDFPageRef page = CGPDFDocumentGetPage(pdf, dcurrentpage );
		
		
		
		
		CGAffineTransform transform = aspectFit(CGPDFPageGetBoxRect(page, kCGPDFMediaBox),
												CGContextGetClipBoundingBox(context));
		CGContextConcatCTM(context, transform);
		CGContextDrawPDFPage(context, page);
		
		CGImageRef image = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		
		UIImage *pageImage=[UIImage imageWithCGImage:image];
		CGImageRelease(image);
		NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(pageImage,.6)];
		[imageData writeToFile:imgPath atomically:YES];
		
		CGPDFDocumentRelease(pdf);
	}
	[pool drain];
	
}


-(void) CreateThumbImages:(NSString *) imgPath:(int) dcurrentpage
{
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imgPath];
	if (fileExists==FALSE)
	{
		
		CFURLRef pdfURL =   (CFURLRef)[[NSURL alloc] initFileURLWithPath:self.pdfPath]; 
		
		CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
		CFRelease(pdfURL);
		[[ NSFileManager defaultManager] createDirectoryAtPath:[DOCUMENTS_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",ABook.IDValue]] attributes:nil];
		
		
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, 
													 768, 
													 1024, 
													 8,			/* bits per component*/
													 768 * 4, 	/* bytes per row */
													 colorSpace, 
													 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
		CGColorSpaceRelease(colorSpace);
		
		CGContextClipToRect(context, CGRectMake(0, 0, 768, 1024));
		
		CGPDFPageRef page = CGPDFDocumentGetPage(pdf, dcurrentpage );
		
		
		
		
		CGAffineTransform transform = aspectFit(CGPDFPageGetBoxRect(page, kCGPDFMediaBox),
												CGContextGetClipBoundingBox(context));
		CGContextConcatCTM(context, transform);
		CGContextDrawPDFPage(context, page);
		
		CGImageRef image = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		
		UIImage *pageImage=[UIImage imageWithCGImage:image];
		CGImageRelease(image);
		////////////////////////
		UIImage *imgThumb = [[UIImage alloc]init];
		imgThumb= [self getScaledImage:pageImage  toSize:CGRectMake(0, 0, 100, 150)];
//		[pageImage release];
		NSData *imageData2 = [NSData dataWithData:UIImageJPEGRepresentation(imgThumb,.6)];
		[imageData2 writeToFile:imgPath atomically:YES];
//		[imgThumb release];
//		[imageData2 release];
		
//		NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(pageImage,.6)];
//		[imageData writeToFile:imgPath atomically:YES];
		
		CGPDFDocumentRelease(pdf);
	}
//	[pool drain];
	
}



-(void)saveImages3
{
	
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	CFURLRef pdfURL =   (CFURLRef)[[NSURL alloc] initFileURLWithPath:self.pdfPath]; 
	
	CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
	CFRelease(pdfURL);
	[[ NSFileManager defaultManager] createDirectoryAtPath:[DOCUMENTS_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",self.pdfBookID]] attributes:nil];
	
	{
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, 
													 768, 
													 1024, 
													 8,			/* bits per component*/
													 768 * 4, 	/* bytes per row */
													 colorSpace, 
													 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
		CGColorSpaceRelease(colorSpace);
		
		CGContextClipToRect(context, CGRectMake(0, 0, 768, 1024));
		
		CGPDFPageRef page = CGPDFDocumentGetPage(pdf, i );
		
		
		
		
		CGAffineTransform transform = aspectFit(CGPDFPageGetBoxRect(page, kCGPDFMediaBox),
												CGContextGetClipBoundingBox(context));
		CGContextConcatCTM(context, transform);
		CGContextDrawPDFPage(context, page);
		
		CGImageRef image = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		
		//UIImage *pageImage=[UIImage imageWithCGImage:image];
		UIImage *pageImage=[[UIImage alloc] initWithCGImage:image];
		CGImageRelease(image);
		NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(pageImage,.6)];
		NSString *STr_PdfImagesPath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@(%d).jpg",ABook.IDValue,ABook.IDValue,i]];
		[imageData writeToFile:STr_PdfImagesPath atomically:YES];

		
		
		////////////////////////
		UIImage *imgThumb = [[UIImage alloc]init];
		imgThumb= [self getScaledImage:pageImage  toSize:CGRectMake(0, 0, 100, 150)];
		[pageImage release];
		NSData *imageData2 = [NSData dataWithData:UIImageJPEGRepresentation(imgThumb,.6)];
		NSString *STr_PdfImagesPath2 = [DOCUMENTS_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/1%@(%d).jpg",ABook.IDValue,ABook.IDValue,i]];
		[imageData2 writeToFile:STr_PdfImagesPath2 atomically:YES];
		[imgThumb release];

		
		
		
		
		
		//[pageImage release];
		//[imageData release];
		
		
	}
	
	
	
	//i++;
	
	CGPDFDocumentRelease(pdf);
	
	//[self performSelectorInBackground:@selector(saveImages3) withObject:nil];
	
//	[pool drain];
	
	
	
}
-(void)saveImages31
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	CFURLRef pdfURL =   (CFURLRef)[[NSURL alloc] initFileURLWithPath:self.pdfPath]; 
	
	CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
	CFRelease(pdfURL);
	
	//int pageCount=CGPDFDocumentGetNumberOfPages(pdf);
	
	
	
	[[ NSFileManager defaultManager] createDirectoryAtPath:[DOCUMENTS_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",self.pdfBookID]] attributes:nil];
	
	{
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, 
													 101, 
													 134, 
													 8,			/* bits per component*/
													 101 * 4, 	/* bytes per row */
													 colorSpace, 
													 kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big);
		CGColorSpaceRelease(colorSpace);
		
		CGContextClipToRect(context, CGRectMake(0, 0, 101, 134));
		
		CGPDFPageRef page = CGPDFDocumentGetPage(pdf, i );
		CGAffineTransform transform = aspectFit(CGPDFPageGetBoxRect(page, kCGPDFMediaBox),
												CGContextGetClipBoundingBox(context));
		CGContextConcatCTM(context, transform);
		CGContextDrawPDFPage(context, page);
		
		CGImageRef image = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		
		UIImage *pageImage=[[UIImage alloc] initWithCGImage:image];
		CGImageRelease(image);
		NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(pageImage,.6)];
		NSString *STr_PdfImagesPath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@(%d)1.jpg",ABook.IDValue,ABook.IDValue,i]];
		[imageData writeToFile:STr_PdfImagesPath atomically:YES];
		
		
		////////////////////////
		
		UIImage *imgThumb = [self getScaledImage:pageImage  toSize:CGRectMake(0, 0, 101, 134)];
		[pageImage release];
		NSData *imageData2 = [NSData dataWithData:UIImageJPEGRepresentation(imgThumb,.6)];
		NSString *STr_PdfImagesPath2 = [DOCUMENTS_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@(%d)11.jpg",ABook.IDValue,ABook.IDValue,i]];
		[imageData2 writeToFile:STr_PdfImagesPath2 atomically:YES];
//		[imgThumb release];
		
		
		
		
		
		//[pageImage release];
		//[imageData release];
		
		
	}
	
	//i++;
	
	CGPDFDocumentRelease(pdf);
	
	//[self performSelectorInBackground:@selector(saveImages3) withObject:nil];
	
	[pool drain];
	
	
	
}




CGAffineTransform aspectFit(CGRect innerRect, CGRect outerRect) 
{
	CGFloat scaleFactor = MIN(outerRect.size.width/innerRect.size.width, outerRect.size.height/innerRect.size.height);
	CGAffineTransform scale = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
	CGRect scaledInnerRect = CGRectApplyAffineTransform(innerRect, scale);
	CGAffineTransform translation = 
	CGAffineTransformMakeTranslation((outerRect.size.width - scaledInnerRect.size.width) / 2 - scaledInnerRect.origin.x, 
									 (outerRect.size.height - scaledInnerRect.size.height) / 2 - scaledInnerRect.origin.y);
	return CGAffineTransformConcat(scale, translation);
}



-(UIImage *)getScaledImage:(UIImage *)actualImage toSize:(CGRect)requiredSize
{
	[actualImage retain];
	float actualHeight = actualImage.size.height;
	float actualWidth = actualImage.size.width;
	float imgRatio = actualWidth/actualHeight;
	
	float targetWidth = requiredSize.size.width;
	float targetHeight=requiredSize.size.height;
	
	float maxRatio = targetWidth/targetHeight;
	
	if(imgRatio!=maxRatio)
	{
		
		if(imgRatio < maxRatio){
			imgRatio = targetHeight / actualHeight;
			actualWidth = imgRatio * actualWidth;
			actualHeight = targetHeight;
		}
		else{
			
			imgRatio =targetWidth / actualWidth;
			actualHeight = imgRatio * actualHeight;
			actualWidth = targetWidth;
		}
	}
	else {
		actualWidth=requiredSize.size.width;
		actualHeight=requiredSize.size.height;
	}
	
	CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
	UIGraphicsBeginImageContext(rect.size);
	[actualImage drawInRect:rect];
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return img;	
}


//Added by Karpagarajan
-(void) loadThumbnail
{
	[sv_thumbnail bringSubviewToFront:self.view];
	for (int j=0; j<=pageCount;j++)
	{
		UIButton *pageButton = [[UIButton alloc] initWithFrame:CGRectMake((101*j)+10*j, 0, 101, 134)];
//		if (j<7) 
//		{
//			NSString *nstempStr = [DOCUMENTS_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/1%@(%d).jpg",ABook.IDValue,ABook.IDValue,j+1]];
//			[self CreateThumbImages:nstempStr :j+1];
//			[pageButton setBackgroundImage:[UIImage imageWithContentsOfFile:nstempStr] forState:UIControlStateNormal];
//		}
//		else
//			[pageButton setBackgroundColor:[UIColor whiteColor]];
//		[pageButton setBackgroundImage:[UIImage imageWithContentsOfFile:nstempStr] forState:UIControlStateNormal];
		if(j!=3)
			pageButton.alpha = 0.5;
		[pageButton addTarget:self action:@selector(ThumbNail_Clicked:) forControlEvents:UIControlEventTouchUpInside];
		pageButton.tag=j+1;
		[sv_thumbnail addSubview:pageButton];
		[pageButton release];
	}
	loadIdx=1;
	ThumTimer= [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(loadThumbnailImages) userInfo:nil repeats:NO];	
	
	sv_thumbnail.clipsToBounds = YES;
	sv_thumbnail.bounces = NO;
	sv_thumbnail.scrollEnabled = YES; 
	sv_thumbnail.contentSize = CGSizeMake(101*pageCount+10*pageCount, 134);
}



/****************     ThumbNail_Clicked */
 -(void)ThumbNail_Clicked:(id)sender
 {
	int tag = [sender tag];
	if(tag<=pageCount)
	{	
		currentpage = tag;
		[pageSlider setValue:(float)tag];
		[self MovetoPageAtIndex:currentpage];
		//Commented by karpaga		if(appDelegate.IsEnabledLinks)
		[self makeUrlClickble:nil];
		if(tag<int_CenterThumb)
		{
			//left direction.....
			if(tag-3>0)
			{
				[sv_thumbnail setContentOffset:CGPointMake(101*tag+10*tag, 0) animated:YES];
			}
			else if(tag-2>0)
			{
				[sv_thumbnail setContentOffset:CGPointMake(101*(-tag+3)+10*(-tag+3), 0) animated:YES];
			}
			else if(tag-1>0)
			{
				[sv_thumbnail setContentOffset:CGPointMake(101*(-tag+2)+10*(-tag+2), 0) animated:YES];
			}
 
		}
		else if (tag>=int_CenterThumb) 
		{
			//Right Direction.....
			if(tag+3<=pageCount)
			{
				[sv_thumbnail setContentOffset:CGPointMake(101*(tag-4)+10*(tag-4), 0) animated:YES];
			 }
			 else if(tag+2<=pageCount)
			 {
				 [sv_thumbnail setContentOffset:CGPointMake(101*(tag-5)+10*(tag-5), 0) animated:YES];
			 }
			 else if(tag+1<=pageCount && tag-5>0)
			 {
				 [sv_thumbnail setContentOffset:CGPointMake(101*(tag-6)+10*(tag-6), 0) animated:YES];
			 }
		}
 
		 UIButton *pre_thumb = (UIButton *)[sv_thumbnail viewWithTag:int_prevthumb];
		 if(pre_thumb!=nil)
		 pre_thumb.alpha = 0.5;
		 
		 UIButton *btn_thumb = (UIButton *)sender;
		 if(btn_thumb!=nil)
		 btn_thumb.alpha = 1.0;
		 int_prevthumb= [sender tag];
		
		/*
		int dStartIdx=tag-3;
		int dEndIdx=tag+3;
		if (dStartIdx<0)
		{
			dStartIdx=0;
			dEndIdx=6;
		}
		if (tag==pageCount)
		{
			dStartIdx=tag-7;
			dEndIdx=tag;
		}
		for (int j=dStartIdx-1; j<=dEndIdx-1;j++)
		{
			UIButton *pageButton = (UIButton *)[sv_thumbnail viewWithTag:j+1];
			UIImage *img1=[pageButton imageForState:UIControlStateNormal];
			if (img1 == nil) {
				NSString *nstempStr = [DOCUMENTS_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/1%@(%d).jpg",ABook.IDValue,ABook.IDValue,j+1]];
				[self CreateThumbImages:nstempStr :j+1];
				[pageButton setBackgroundImage:[UIImage imageWithContentsOfFile:nstempStr] forState:UIControlStateNormal];
			}
		}*/		
	}
 
 }
 




-(void)MovetoPageAtIndex:(NSInteger)Index
{

	//Over Lay View 
	if (_downloadingOverlayView ==nil) {
		if (isCreated==TRUE)
		{
			UIActivityIndicatorView *downloadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
			downloadingIndicator.frame = CGRectMake(369,497, 30.0, 30.0);
			[downloadingIndicator startAnimating];	  
			_downloadingOverlayView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
			[_downloadingOverlayView setAlpha:0.5];
			[_downloadingOverlayView setBackgroundColor:[UIColor grayColor]];
			[self.view  addSubview:_downloadingOverlayView];
			[_downloadingOverlayView addSubview:downloadingIndicator];
			[downloadingIndicator release];
		}
		else
		{
			UIImageView *uiloadimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
			uiloadimage.image = [UIImage imageNamed:@"loading_b2.png"];
			uiloadimage.backgroundColor = [UIColor clearColor];
			_downloadingOverlayView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
			[_downloadingOverlayView setAlpha:0.85];
			[_downloadingOverlayView setBackgroundColor:[UIColor grayColor]];
			[self.view  addSubview:_downloadingOverlayView];
			[_downloadingOverlayView addSubview:uiloadimage];
			[uiloadimage release];
		}
	}
	[_downloadingOverlayView setHidden:FALSE];
	
	
	currentpage = Index;
	
    CGRect zoomRect = [self zoomRectForScale:1 withCenter:CGPointMake(0, 0)];
	[leftScrollView zoomToRect:zoomRect animated:NO];
	[rightScrollView zoomToRect:zoomRect animated:NO];
	[scrollView zoomToRect:zoomRect animated:NO];
	
	//[pageNoLabel setText[NSString stringWithFormat:@"Page No : %d",currentpage]];
	[self playAudioforCurrentPage];
	//Commented by karpaga	if(appD Felegate.IsEnabledLinks)
	[self makeUrlClickble:nil];
	PdfTimer= [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(LoadPages) userInfo:nil repeats:NO];
}

-(void) loadThumbnailImages
{
	if (loadIdx<=pagecount)
	{
		UIButton *pageButton = (UIButton *)[sv_thumbnail viewWithTag:loadIdx];
		NSString *nstempStr = [DOCUMENTS_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/1%@(%d).jpg",ABook.IDValue,ABook.IDValue,loadIdx]];
		[self CreateThumbImages:nstempStr :loadIdx];
		[pageButton setBackgroundImage:[UIImage imageWithContentsOfFile:nstempStr] forState:UIControlStateNormal];
		loadIdx=loadIdx+1;
		ThumTimer= [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(loadThumbnailImages) userInfo:nil repeats:NO];	
	}
}

-(void)LoadPages
{
	if(currentpage==1)
	{
		//NSString *ImgPath = [[NSString alloc] initWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.Name,ABook.IDValue,currentpage];
		[self Create2Images:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage] :currentpage];
		[self Create2Images:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage+2] :currentpage+2];
		[self Create2Images:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage+1] :currentpage+1];
		[leftImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage]]];
		[rightImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage+2]]];
		[middleImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage+1]]];
		[containerScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
	}
	else if(currentpage == pagecount)
	{
		[self Create2Images:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage] :currentpage];
		[self Create2Images:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage-2] :currentpage-2];
		[self Create2Images:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage-1] :currentpage-1];
		[leftImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage-2]]];
		[rightImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage]]];
		[middleImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage-1]]];
		[containerScrollView setContentOffset:CGPointMake(2*screenwidth, 0) animated:NO];
	}
	else 
	{
		[self Create2Images:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage] :currentpage];
		[self Create2Images:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage+1] :currentpage+1];
		[self Create2Images:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage-1] :currentpage-1];
		[leftImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage-1]]];
		[rightImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage+1]]];
		[middleImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage]]];
		[containerScrollView setContentOffset:CGPointMake(screenwidth, 0) animated:NO];
	}
	[_downloadingOverlayView setHidden:TRUE];
	if (isCreated==FALSE) 
	{
		[_downloadingOverlayView setHidden:TRUE];
		isCreated=TRUE;
		[_downloadingOverlayView release];
		_downloadingOverlayView=nil;
	}


	[self makeUrlClickble:currentpage];
}

-(void) disableLoading
{
	[_downloadingOverlayView setHidden:FALSE];
	isCreated=TRUE;
	[_downloadingOverlayView release];
	_downloadingOverlayView=nil;
}

-(void)gotoPageIndex:(id)sender
{
	//Over Lay View 
	if (_downloadingOverlayView ==nil) {
		UIActivityIndicatorView *downloadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		
		
		downloadingIndicator.frame = CGRectMake(369,497, 30.0, 30.0);
		
		[downloadingIndicator startAnimating];	  
		_downloadingOverlayView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
		[_downloadingOverlayView setAlpha:0.85];
		[_downloadingOverlayView setBackgroundColor:[UIColor grayColor]];
		[self.view  addSubview:_downloadingOverlayView];
		[_downloadingOverlayView addSubview:downloadingIndicator];
		[downloadingIndicator release];/*
		UIImageView *uiloadimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
		uiloadimage.image = [UIImage imageNamed:@"loading_b2.jpg"];
		uiloadimage.backgroundColor = [UIColor clearColor];
		_downloadingOverlayView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
		[_downloadingOverlayView setAlpha:0.85];
		[_downloadingOverlayView setBackgroundColor:[UIColor grayColor]];
		[self.view  addSubview:_downloadingOverlayView];
		[_downloadingOverlayView addSubview:uiloadimage];
		[uiloadimage release];*/
	}
	[_downloadingOverlayView setHidden:TRUE];
	[self.view bringSubviewToFront:_downloadingOverlayView];
	
	NSInteger tagIdx=[sender tag];
	[sender setAlpha:1];
	[prevObj setAlpha:0.5];
	prevObj=sender;
	
	
	[pageSlider setValue:(float)tagIdx];
	holdAudio=TRUE;
	
	currentpage = (int)tagIdx;
	
    CGRect zoomRect = [self zoomRectForScale:1 withCenter:CGPointMake(0, 0)];
	[leftScrollView zoomToRect:zoomRect animated:NO];
	[rightScrollView zoomToRect:zoomRect animated:NO];
	[scrollView zoomToRect:zoomRect animated:NO];
	
	//[pageNoLabel setText[NSString stringWithFormat:@"Page No : %d",currentpage]];
	[self playAudioforCurrentPage];
	//Commented by karpaga	if(appDelegate.IsEnabledLinks)
	[self makeUrlClickble:nil];
	PdfTimer= [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(LoadPages) userInfo:nil repeats:NO];	
}
//End of Addition



-(void)playAudioforCurrentPage
{
	if(holdAudio==TRUE)
	{
		return;
	}
	
	@try {
		if([self.string_bookId compare:@"0310543459"]==0)
		{
			if(audioForPage[currentpage]!=audioBeingPlayed)
			{
				NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d", audioForPage[currentpage]] ofType:@"mp3"];  
				if(path!=nil)
				{
					audioBeingPlayed=audioForPage[currentpage];
					[bgAudioPlayer stop];
					AVAudioPlayer * newAudio=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];  
					bgAudioPlayer = newAudio; // automatically retain audio and dealloc old file if new file is loaded
					
					//[newAudio release]; // release the audio safely
					
					[bgAudioPlayer prepareToPlay];
					[bgAudioPlayer setNumberOfLoops:-1];
					[bgAudioPlayer play];
				}
			}
		}
	}
	@catch (NSException * e) {
		
	}
	@finally {
		
	}
	
	
	
}

-(void)sliderMoveComplete
{
	holdAudio=FALSE;
	[self playAudioforCurrentPage];
	int tag=currentpage;
	if(tag<=pageCount)
	{
		if(tag<int_CenterThumb)
		{
			//left direction.....
			if(tag-3>0)
			{
				[sv_thumbnail setContentOffset:CGPointMake(101*tag+10*tag, 0) animated:YES];
			}
			else if(tag-2>0)
			{
				[sv_thumbnail setContentOffset:CGPointMake(101*(-tag+3)+10*(-tag+3), 0) animated:YES];
			}
			else if(tag-1>0)
			{
				[sv_thumbnail setContentOffset:CGPointMake(101*(-tag+2)+10*(-tag+2), 0) animated:YES];
			}
			
		}
		else if (tag>=int_CenterThumb) 
		{
			//Right Direction.....
			if(tag+3<=pageCount)
			{
				[sv_thumbnail setContentOffset:CGPointMake(101*(tag-4)+10*(tag-4), 0) animated:YES];
			}
			else if(tag+2<=pageCount)
			{
				[sv_thumbnail setContentOffset:CGPointMake(101*(tag-5)+10*(tag-5), 0) animated:YES];
			}
			else if(tag+1<=pageCount && tag-5>0)
			{
				[sv_thumbnail setContentOffset:CGPointMake(101*(tag-6)+10*(tag-6), 0) animated:YES];
			}
		}
		UIButton *pre_thumb = (UIButton *)[sv_thumbnail viewWithTag:int_prevthumb];
		if(pre_thumb!=nil)
			pre_thumb.alpha = 0.5;
		
		UIButton *btn_thumb = (UIButton *)[sv_thumbnail viewWithTag:tag];
		if(btn_thumb!=nil)
			btn_thumb.alpha = 1.0;
		int_prevthumb= tag;
	}
	[self MovetoPageAtIndex:currentpage];	
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor blackColor];
	appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	rectArrays = [[NSMutableArray alloc] init];
	storeURLS = [[NSMutableArray alloc] init];
	//return;
	previousRightScroll =0;
	screenwidth = 768;
	screenheight = 1024;
	
	count = 1;
	currentpage =1;
	pagecount =0;
	isTopBarVisible=FALSE;
	holdAudio=FALSE;
	i=0;
	bookID=42;
	IsEnabledLinks = YES;
	RemoveBtns = 0;
	
	
	
	
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    contentView.backgroundColor = [UIColor blackColor];
    self.view = contentView;
    [contentView release];
	
	
	
	
	
	
	
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@__%@/%@",ABook.Name,ABook.IDValue,self.StrFilename]] retain];
	
	
	self.pdfPath = [NSString stringWithFormat:@"%@.pdf",dataFilePath];
	[dataFilePath release];
	dataFilePath = [[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/",ABook.IDValue]] retain];
	
	//Caliculate the Nof Pages Available Here........
	pagecount = 0;
	NSString *STr_PdfImagesPath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/",ABook.IDValue]];
	NSArray *NofImages = [[NSFileManager defaultManager] directoryContentsAtPath:STr_PdfImagesPath];
	for(NSString *imgPath in NofImages)
	{
		if ([imgPath hasPrefix:ABook.IDValue]) 
		{
			pagecount++;
		}
		else if([imgPath hasSuffix:@".pdf"]&&self.pdfPath==nil)
		{
			self.pdfPath=[NSString stringWithFormat:@"%@/%@",STr_PdfImagesPath,imgPath];
		}
		
	}
	
	pageCount = 0;
	if(pageCount==0)
	{
		CFURLRef pdfURL =   (CFURLRef)[[NSURL alloc] initFileURLWithPath:self.pdfPath];  
		CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
		CFRelease(pdfURL);
		pageCount=CGPDFDocumentGetNumberOfPages(pdf);
		CGPDFDocumentRelease(pdf);
		[prefs setInteger:pageCount forKey:[NSString stringWithFormat:@"PageCount%@",self.string_bookId]];
	}
	if(pagecount<pageCount)
	{
		[self.view setBackgroundColor:[UIColor blackColor]];
//		lbl=[[UILabel alloc]initWithFrame:CGRectMake(0,0,  768, 50)];
//		lbl.center=self.view.center;
//		lbl.backgroundColor=[UIColor blackColor];
//		lbl.textColor=[UIColor grayColor];
//		lbl.text=@"Initializing book.... please wait...";
//		lbl.textAlignment=UITextAlignmentCenter;
//		[self.view addSubview:lbl];
//		
//		//Create A Directory with file name.......
//		[[ NSFileManager defaultManager] createDirectoryAtPath:dataFilePath attributes:nil];
		
		
		[self startProcessing];
	}
	else 
	{
		[self showBook];
	}
	[dataFilePath release];
	//Put the Scroll View............
	
	if(pageCount>3)
	{
		int_CenterThumb = 4;
		int_prevthumb = 4;
	}
	else 
	{
		int_CenterThumb = 0;
	}
	
	[self GetTheTocOfThisbook:nil];
	descloserView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
	
	
	
	
}

-(void)GetTheTocOfThisbook:(id)sender
{
	//Get the Toc Content
	//write a code for download the toc file 
	NSString * filename = [[NSString alloc] initWithFormat:@"Toc_%@.xml", ABook.IDValue,ABook.IDValue];
	NSString *TocPath= [[NSString alloc] initWithFormat:@"%@/api/read?action=pagecontent&authKey=&bookId=%@",serverIP, ABook.IDValue];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:filename] retain];
	
	BOOL fileExists = NO;//[[NSFileManager defaultManager] fileExistsAtPath:dataFilePath];
	if(fileExists)
	{
		
		
		//	http://122.183.249.154/wizardworld/api/read?action=pagecontent&authKey=ull2&bookId=5
		//Do Nothing if Exist
		NSURL *url = [NSURL fileURLWithPath:dataFilePath];
		NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
		TocXmlParser *tocB_XmlParser = [[TocXmlParser alloc]initXMLParser];
		[xmlParser setDelegate:tocB_XmlParser];
		BOOL success = [xmlParser parse];
		[xmlParser release];
		xmlParser=nil;
		if(success)
		{
			//write a code when succed
			arr_Toc = [[NSArray alloc] initWithArray:tocB_XmlParser.Arr_Toc]; 
		}
		else 
		{
			//parsing failed
		}
		[xmlParser release];
		[tocB_XmlParser release];
		
	}
	else 
	{
		//NSString *allBooksUrl = [NSString stringWithFormat:@"%@/api/read?action=pagecontent&authKey=%28null%29&bookId=%@",serverIP, ABook.IDValue];
		NSURL *url = [[NSURL alloc] initWithString:TocPath];
		NSData *data = [[NSData alloc] initWithContentsOfURL:url];
		if(data!=nil)
		{
			//Save Corrresponding folder  
			[data writeToFile:[DOCUMENTS_FOLDER stringByAppendingPathComponent:filename] atomically:YES];
			[data release];
		}
		
		NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
		TocXmlParser *tocB_XmlParser = [[TocXmlParser alloc]initXMLParser];
		[xmlParser setDelegate:tocB_XmlParser];
		BOOL success = [xmlParser parse];
		[xmlParser release];
		xmlParser=nil;
		if(success)
		{
			//write a code when succed
			arr_Toc = [[NSArray alloc] initWithArray:tocB_XmlParser.Arr_Toc]; 
		}
		else 
		{
			//parsing failed
		}
		[url release];
		[xmlParser release];
		[tocB_XmlParser release];
	}
	[filename release];
	[TocPath release];
	[dataFilePath release];
	
	
}

-(void)showBook
{
	//[self.view setFrame:CGRectMake(0, 0, 768, 1024)];
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
	
	imgview_topBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_bar.png"]];
	imgview_topBar.alpha = 0.5;
	imgview_topBar.frame = CGRectMake(0, 0, 768, 44);
	//[self.view addSubview:imgview_topBar];
	
	btn_close = [[UIButton alloc] initWithFrame:CGRectMake(730, 8, 27, 26)];
	[btn_close setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
	[btn_close addTarget:nil action:@selector(closeComicEngine) forControlEvents:UIControlEventTouchUpInside];
	//[self.view addSubview:btn_close];
	
	btn_Toc = [[UIButton alloc] initWithFrame:CGRectMake(680, 8, 27, 26)];
	[btn_Toc setBackgroundImage:[UIImage imageNamed:@"toc-butt.png"]forState:UIControlStateNormal];
	[btn_Toc addTarget:self action:@selector(btn_tocClicked:) forControlEvents:UIControlEventTouchUpInside];
	//[self.view addSubview:btn_Toc];
	
	btn_Lincks = [[UIButton alloc] initWithFrame:CGRectMake(600, 8, 100, 26)];
	[btn_Lincks setBackgroundImage:[UIImage imageNamed:@"highlight-links-tab.png"]forState:UIControlStateNormal];
	[btn_Lincks addTarget:self action:@selector(btn_LinksClicked:) forControlEvents:UIControlEventTouchUpInside];
	btn_Lincks.tag = 121;
	
	
	if (addThumbnail)
	{
		//Added by Karpagarajan
		sv_thumbnail=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 889, 766, 135)];
		[sv_thumbnail setBackgroundColor:[UIColor grayColor]];
		sv_thumbnail.delegate = self;
		
		sv_thumbnail.alpha = 0.8;
		//End of addition
		pageSlider = [[UISlider alloc] initWithFrame:CGRectMake(300,screenheight-170, 200,20)]; //50
	}
	else {
		pageSlider = [[UISlider alloc] initWithFrame:CGRectMake(300,screenheight-50, 200,20)]; //50
	}

	
	pageNoLabel = [[UILabel alloc]initWithFrame:CGRectMake(350, screenheight-80, 200, 30)];
	//[pageNoLabel setText[NSString stringWithFormat:@"Page No : %d",currentpage]];
	[self playAudioforCurrentPage];
	pageNoLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(singleTapZoom:) name:@"SingleTapZoom" object:nil];
	pageNoLabel.backgroundColor = [UIColor clearColor];
	[pageNoLabel setTextColor:[UIColor blackColor]];
	float pCount = pagecount+0.0;
	[pageSlider setMaximumValue:pCount];
	[pageSlider setMinimumValue:1.0];
	[pageSlider addTarget:self action:@selector(gotoPage:) forControlEvents:UIControlEventValueChanged];
	[pageSlider addTarget:self action:@selector(sliderMoveComplete) forControlEvents:UIControlEventTouchUpInside];
    [pageSlider setHidden:TRUE];
	
	CGRect scrollFrame = [self.view frame];  
	containerScrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
	currentpage = 1;
    
	scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(screenwidth, 0, screenwidth, screenheight)];
	leftScrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenwidth, screenheight)];
	rightScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(screenwidth*2, 0, screenwidth, screenheight)];
	
	CGRect contentFrame = CGRectMake(0, 0, scrollFrame.size.width*count, scrollFrame.size.height*count);
    CGPoint contentOffset = CGPointMake((contentFrame.size.width-scrollFrame.size.width)/2,
                                        (contentFrame.size.height-scrollFrame.size.height)/2);
	
    // create scroll view and content view
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doubleTapZoom:) 
                                                 name:@"DoubleTapZoom" object:nil];
    [self createScrollView:scrollFrame contentOffset:contentOffset contentFrame:contentFrame scalingFactor:0.0];
	
	//Added by Karpagarajan
	if (addThumbnail)
	{
		[self loadThumbnail];
	}
	//End of Addition
	
	
}

-(void)btn_tocClicked:(id)sender
{
	test2 *t1 = [[test2 alloc] initWithStyle:UITableViewStyleGrouped];
	t1.cls = self;
	t1.Arr_NofPages = [[NSArray alloc] initWithArray:arr_Toc];
	
	//Add this to the PopoviewController
	POVC_TableOC = [[UIPopoverController alloc] initWithContentViewController:t1];
	POVC_TableOC.delegate = self;
	[POVC_TableOC presentPopoverFromRect:CGRectMake(495, -360, 400, 400) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	[POVC_TableOC setPopoverContentSize:CGSizeMake(300, 450) animated:NO];
	
	//[t1 release];
	
}

-(void)btn_LinksClicked:(id)sender
{
	if([sender tag] == 121)
	{
		btn_Lincks.tag = 131;
		appDelegate.IsEnabledLinks = NO;
		[self makeUrlClickble:nil];
	}
	else if([sender tag]==131)
	{
		btn_Lincks.tag	= 121;
		appDelegate.IsEnabledLinks = YES;
		if(currentpage==1)
		{
			for(UIView *View in leftImageView.subviews)
			{
				if(View!=nil)
				{
					[View removeFromSuperview];
				}
			}
		}
		else if(currentpage%2==0)
		{
			for(UIView *View in middleImageView.subviews)
			{
				if(View!=nil)
				{
					[View removeFromSuperview];
				}
			}
		}
		else if(currentpage%3 == 0)
		{
			for(UIView *View in rightImageView.subviews)
			{
				if(View!=nil)
				{
					[View removeFromSuperview];
				}
			}
		}
	}
	
}


- (void)createScrollView:(CGRect)scrollFrame contentOffset:(CGPoint)contentOffset contentFrame:(CGRect)contentFrame
           scalingFactor:(float)scalingFactor
{
//	NSString *imgPath=[NSString stringWithFormat:@"%@/%@/%@(1).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue];
//	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imgPath];
	isCreated=FALSE;
	//[DOCUMENTS_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@(%d).jpg",ABook.Name,ABook.IDValue,i]];
	//NSString *path = [NSString stringWithFormat:@"%@/%@(1).jpg",ABook.IDValue,ABook.IDValue ];//  @"%@/%@/%@(1).jpg",DOCUMENTS_FOLDER,ABook.Name,ABook.IDValue];
	MyContentView1 * leftcontent = [[MyContentView1 alloc] initWithFrame:CGRectMake(0, 0, screenwidth, screenheight)];
	leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenwidth, screenheight)];
	leftImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(1).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue]];
	[leftcontent addSubview:leftImageView];
	[leftcontent setBackgroundColor:[UIColor blackColor]];
	
	// Add image to scrollview 
    MyContentView1 * content = [[MyContentView1 alloc] initWithFrame:CGRectMake(0, 0, screenwidth, screenheight)];
	middleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenwidth, screenheight)];
	middleImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(2).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue]];
	[content addSubview:middleImageView];
	
	
	[content setBackgroundColor:[UIColor blackColor]];
	MyContentView1 * rightContent = [[MyContentView1 alloc] initWithFrame:CGRectMake(0, 0, screenwidth, screenheight)];
	rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenwidth, screenheight)];
	rightImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(3).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue]];
	[rightContent addSubview:rightImageView];
    [rightContent setBackgroundColor:[UIColor blackColor]];
	
    if( scalingFactor!=0 )
        [content setTransform:CGAffineTransformMakeScale(scalingFactor, scalingFactor)];
    
    // create a new scroll view and add to window
    [containerScrollView addSubview:leftScrollView];
    [containerScrollView addSubview:scrollView];
	[containerScrollView addSubview:rightScrollView];
	
    [self.view addSubview:containerScrollView];
	[self.view addSubview:pageNoLabel];
	[self.view addSubview:pageSlider];
    // reset min and max scaling
	
    [scrollView setMinimumZoomScale:kMinWidth/contentFrame.size.width];
    [scrollView setMaximumZoomScale:kMaxWidth/contentFrame.size.width];
    [scrollView addSubview:content];
    [scrollView setContentSize:contentFrame.size];
    [scrollView setContentOffset:contentOffset];
    [scrollView setDelegate:self];
	scrollView.showsHorizontalScrollIndicator=NO;
	scrollView .showsVerticalScrollIndicator=NO;
	
	[leftScrollView setMinimumZoomScale:kMinWidth/contentFrame.size.width];
    [leftScrollView setMaximumZoomScale:kMaxWidth/contentFrame.size.width];
    [leftScrollView addSubview:leftcontent];
    [leftScrollView setContentSize:contentFrame.size];
    [leftScrollView setContentOffset:contentOffset];
    [leftScrollView setDelegate:self];
	leftScrollView.showsHorizontalScrollIndicator=NO;
	leftScrollView .showsVerticalScrollIndicator=NO;
	
	[rightScrollView setMinimumZoomScale:kMinWidth/contentFrame.size.width];
    [rightScrollView setMaximumZoomScale:kMaxWidth/contentFrame.size.width];
    [rightScrollView addSubview:rightContent];
    [rightScrollView setContentSize:contentFrame.size];
    [rightScrollView setContentOffset:contentOffset];
    [rightScrollView setDelegate:self];
	rightScrollView.showsHorizontalScrollIndicator=NO;
	rightScrollView .showsVerticalScrollIndicator=NO;
	
	[leftcontent release];
	[rightContent release];
	[content release];
	
	[containerScrollView setContentSize:CGSizeMake(contentFrame.size.width*3, screenheight)];
	[containerScrollView setDelegate:self];
	containerScrollView.showsHorizontalScrollIndicator=NO;
	containerScrollView.showsVerticalScrollIndicator=NO;
    [containerScrollView setBackgroundColor:[UIColor blackColor]];
	[containerScrollView setPagingEnabled:TRUE];
	
	//Commented by karpaga	if(appDelegate.IsEnabledLinks)
	
	imgV_PrevBtn = leftImageView;
	[self makeUrlClickble:nil];
	[self MovetoPageAtIndex:1];
	
	
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView1
{
    // return the first subview of the scroll view
    return [scrollView1.subviews objectAtIndex:0];
}

-(void)closeComicEngine 
{
	
	[bgAudioPlayer stop];
	[imgview_topBar release];
	[btn_close release];
	[string_bookId release];
	[string_bookCount release];
	[btn_Lincks release];
	//Added by Karpagarajan
	//if(sv_thumbnail!=nil);
	//[sv_thumbnail release];
	//End of addition
	self.containerScrollView = nil;
	self.leftScrollView = nil;
	self.rightScrollView = nil;
	self.scrollView = nil;
	self.pageSlider = nil;
	self.pageNoLabel = nil;
	self.leftImageView = nil;
	self.rightImageView = nil;
	self.middleImageView = nil;
	[self dismissModalViewControllerAnimated:YES];
	
}

-(void)gotoPage:(id)sender
{
	holdAudio=TRUE;
	currentpage = (int)pageSlider.value;
	
/*    CGRect zoomRect = [self zoomRectForScale:1 withCenter:CGPointMake(0, 0)];
	[leftScrollView zoomToRect:zoomRect animated:NO];
	[rightScrollView zoomToRect:zoomRect animated:NO];
	[scrollView zoomToRect:zoomRect animated:NO];
	
	//[pageNoLabel setText[NSString stringWithFormat:@"Page No : %d",currentpage]];
	//[self playAudioforCurrentPage];
	//Commented by karpaga	if(appDelegate.IsEnabledLinks)
	[self makeUrlClickble:nil];
	if(currentpage==1)
	{
		NSString *ImgPath = [NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.Name,ABook.IDValue,currentpage];
		[leftImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage]]];
		[rightImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage+2]]];
		[middleImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage+1]]];
		[containerScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
	}
	else if(currentpage == pagecount)
	{
		[leftImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage-2]]];
		[rightImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage]]];
		[middleImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage-1]]];
		[containerScrollView setContentOffset:CGPointMake(2*screenwidth, 0) animated:NO];
	}
	else 
	{
		[leftImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage-1]]];
		[rightImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage+1]]];
		[middleImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage]]];
		[containerScrollView setContentOffset:CGPointMake(screenwidth, 0) animated:NO];
	}
	*/
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scroll
{
	if (scroll ==containerScrollView)
	{
		//removing buttons from the view
		int count1 = [rectArrays count];
		
		for(int j=0;j< count1; j++)
		{
			int tag = j+650;
			UIButton *btn = (UIButton *)[self.view viewWithTag:tag];
			if(btn!=nil)
				[btn removeFromSuperview];
		}
		
		
		CGRect zoomRect = [self zoomRectForScale:1 withCenter:CGPointMake(0, 0)];
	    [leftScrollView zoomToRect:zoomRect animated:NO];
		[rightScrollView zoomToRect:zoomRect animated:NO];
		[scrollView zoomToRect:zoomRect animated:NO];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scroll
{
	int contentOffset= scroll.contentOffset.x;
	
	if (scroll ==leftScrollView) 
	{
		
	}
	else if (scroll ==rightScrollView)
	{
		
	}
	else if (scroll==scrollView) 
	{
		
	}
	else if (scroll ==containerScrollView) 
	{
		
		
		if(contentOffset ==0)//means user scrolled backward
		{
			[self movedleftWhilePlaying];
		}
		else
		{
			if(contentOffset<previousRightScroll&&currentpage==pagecount)
			{
				[self movedleftWhilePlaying];
			}
			if(contentOffset==768)
			{
				if(currentpage==1)
				{
					currentpage++;
					
					[pageSlider setValue:currentpage+0.0];
					//[pageNoLabel setText[NSString stringWithFormat:@"Page No : %d",currentpage]];
					[self playAudioforCurrentPage];
				}
				//Commented by karpaga				if(appDelegate.IsEnabledLinks)
				[self makeUrlClickble:nil];
				return;
			}
			else 
			{
				previousRightScroll =contentOffset;
				[self movedRightWhilePlaying];
			}
		}
		//Write a code for access the pdf annotation links
		//Commented by karpaga				if(appDelegate.IsEnabledLinks)
		[self makeUrlClickble:nil];		
	}
}


-(void)makeUrlClickble:(CGPDFPageRef)pdfPage
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	
	//removing buttons from the view
	
	if(rectArrays==nil)
		rectArrays = [[NSMutableArray alloc] init];
	if(storeURLS == nil)
		storeURLS = [[NSMutableArray alloc] init];
	
	for(UIButton *btn in imgV_PrevBtn.subviews)
	{
		if(btn!=nil)
		{
			[btn removeFromSuperview];
		}
	}
	

	CFURLRef pdfURL =   (CFURLRef)[[NSURL alloc] initFileURLWithPath:self.pdfPath]; 
	CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
	
	CGPDFPageRef thisPage =  CGPDFDocumentGetPage(pdf, currentpage);
	CGPDFDictionaryRef pageDictionary = CGPDFPageGetDictionary(thisPage);
	
	//Getting the pdfpages
/* Commented for memory leak	
	int totalPages=CGPDFDocumentGetNumberOfPages(pdf);
	NSMutableArray *dpages=[[NSMutableArray alloc] init];
	CGPDFPageRef dpage;
	CGPDFDictionaryRef d1;
	for (int kk=1; kk<=totalPages; kk++) {
		dpage = CGPDFDocumentGetPage (pdf, kk);// 2
		d1 = CGPDFPageGetDictionary(dpage);
		if (d1!=nil)
		{
			[dpages addObject:d1];
		}
	}
	*/
	
	//End of pages
	CGPDFArrayRef outputArray;
	if(CGPDFDictionaryGetArray(pageDictionary, "Annots", &outputArray))
	{
		
		// 3. get page contents stream
		CGPDFStreamRef cont;
		if( !CGPDFDictionaryGetStream( pageDictionary, "Contents", &cont ) ) {
			
		}
		
		int arrayCount = 0;
		arrayCount = CGPDFArrayGetCount(outputArray );
		
		
		[rectArrays removeAllObjects];
		[storeURLS removeAllObjects];
		
		if(arrayCount>0&&arrayCount<1000)
		{
			for( int j = 0; j < arrayCount; ++j )
			{
				CGPDFObjectRef aDictObj;
				if(!CGPDFArrayGetObject(outputArray, j, &aDictObj))
				{
					return;
				}
				
				CGPDFDictionaryRef annotDict;
				if(!CGPDFObjectGetValue(aDictObj, kCGPDFObjectTypeDictionary, &annotDict))
				{
					return;
				}
				
				CGPDFArrayRef rectArray;
				if(!CGPDFDictionaryGetArray(annotDict, "Rect", &rectArray))
				{
					return;
				}
				
				int arrayCount = CGPDFArrayGetCount( rectArray );
				
				CGPDFReal coords[4];
				for( int k = 0; k < arrayCount; ++k )
				{
					CGPDFObjectRef rectObj;
					if(!CGPDFArrayGetObject(rectArray, k, &rectObj))
					{
						
						
						continue;
					}
					
					CGPDFReal coord;
					if(!CGPDFObjectGetValue(rectObj, kCGPDFObjectTypeReal, &coord))
					{
						continue;
					}
					
					coords[k] = coord;
				}  
				CGRect rect = CGRectMake(coords[0],coords[1],coords[2],coords[3]);
					
				CGPDFInteger pageRotate = 0;
				CGPDFDictionaryGetInteger( pageDictionary, "Rotate", &pageRotate ); 
				CGRect pageRect = CGRectIntegral( CGPDFPageGetBoxRect( thisPage, kCGPDFMediaBox ));
				if( pageRotate == 90 || pageRotate == 270 )
				{
					CGFloat temp = pageRect.size.width;
					pageRect.size.width = pageRect.size.height;
					pageRect.size.height = temp;
				}
				
				rect.size.width -= rect.origin.x;
				rect.size.height -= rect.origin.y;
				rect.origin.x = rect.origin.x;
				rect.origin.y = rect.origin.y;
				
				CGAffineTransform trans = CGAffineTransformIdentity;
				trans = CGAffineTransformTranslate(trans, 0, pageRect.size.height);
				trans = CGAffineTransformScale(trans, 1.0, -1.0);
				
				rect = CGRectApplyAffineTransform(rect, trans);
				
				
				
				//adding a button for every url......
				UIButton *button = [[UIButton alloc] initWithFrame:rect];
				[button setBackgroundColor:[UIColor yellowColor]];
				if (appDelegate.IsEnabledLinks==YES)
				{
					[button setAlpha:0.2];
				}
				else {
					[button setAlpha:0.03];
				}
				
				button.tag = j+650;
				[button setTitle:@"" forState:UIControlStateNormal];
				[button addTarget:self action:@selector(BtnUrlClicked:) forControlEvents:UIControlEventTouchUpInside];
				if(containerScrollView.contentOffset.x==0)
				{
					leftImageView.userInteractionEnabled = YES;
					[leftImageView addSubview:button];  
					imgV_PrevBtn = leftImageView;
					
				}
				else if(containerScrollView.contentOffset.x==768)
				{
					middleImageView.userInteractionEnabled = YES;
					[middleImageView addSubview:button];  
					imgV_PrevBtn  = middleImageView;
				}
				else if(containerScrollView.contentOffset.x==768*2)
				{
					rightImageView.userInteractionEnabled = YES;
					[rightImageView addSubview:button];
					imgV_PrevBtn = rightImageView;
				}
				[button release];
				
				
				
				
				// Getting the url from the pdf ref object.......
				CGPDFDictionaryRef aDict;
				if(!CGPDFDictionaryGetDictionary(annotDict, "A", &aDict))//page 1 returns here
				{
					continue;
				}
				
				
				CGPDFStringRef uriStringRef;
				if(!CGPDFDictionaryGetString(aDict, "URI", &uriStringRef))
				{
					//Karpaga
/* Commented for memory leak					*/
					const char* pchS;
					if (CGPDFDictionaryGetName(aDict, "S", &pchS)) 
					{
						CGPDFArrayRef destArray;
						if (strcmp(pchS,"GoTo")==0)
						{
							if (CGPDFDictionaryGetArray(aDict, "D", &destArray)) {
								//int count = CGPDFArrayGetCount(destArray);
								// dest page
								CGPDFDictionaryRef destPageDic;
								if (CGPDFArrayGetDictionary(destArray, 0, &destPageDic)) 
								{
									//CGPDFInteger countm;
									int pageNumberi;// = [dpages indexOfObjectIdenticalTo:destPageDic];
									
									int totalPages=CGPDFDocumentGetNumberOfPages(pdf);
									CGPDFPageRef dpage;
									CGPDFDictionaryRef d1;
									for (int kk=1; kk<=totalPages; kk++) {
										dpage = CGPDFDocumentGetPage (pdf, kk);// 2
										d1 = CGPDFPageGetDictionary(dpage);
										if (d1==destPageDic)
										{
											pageNumberi=kk-1;
											[rectArrays addObject:[NSValue valueWithCGRect:rect]];
											NSString *str1=[NSString stringWithFormat:@"%d",pageNumberi];
											[storeURLS addObject:str1];
											break;
											
										}
									}									
								}
							}
					} 

				}/* */
					//End of Code
					continue;
				}
				
				char *uriString = (char *)CGPDFStringGetBytePtr(uriStringRef);
				NSString *uri = [NSString stringWithCString:uriString encoding:NSUTF8StringEncoding];
				
				NSURL *url = [NSURL URLWithString:uri];
				[rectArrays addObject:[NSValue valueWithCGRect:rect]];
				[storeURLS addObject:url];
				
				
			}
		}
		RemoveBtns = currentpage; 
	}
	CGPDFDocumentRelease(pdf);
	
	
	[pool release];
}






-(void)BtnUrlClicked:(id)sender
{
	int tag = [sender tag]-650;
	if(tag<[storeURLS count])
	{
		NSString *str_Url = [[NSString alloc] initWithFormat:@"%@", [storeURLS objectAtIndex:tag]];
		if ([str_Url length]>3)
		{
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:1.0];
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
			[UIView commitAnimations];
			WebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
			WebView.clearsContextBeforeDrawing = YES;
			WebView.tag = 150;
			WebView.delegate = self;
			[WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str_Url]]];
			[WebView setScalesPageToFit:YES];
			WebView.opaque = NO;
			WebView.backgroundColor = [UIColor blackColor];
			[self.view  addSubview:WebView];
			
			//Create a Close btn To close the web View.......
			UIButton *btn_closeWebView = [[UIButton alloc] initWithFrame:CGRectMake(720,25, 27, 26)];
			[btn_closeWebView setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
			[WebView addSubview:btn_closeWebView];
			[btn_closeWebView addTarget:self action:@selector(CloseBntClicked_WebView:) forControlEvents:UIControlEventTouchUpInside];
			[btn_closeWebView release];
			//[WebView release];
			[str_Url release];
		}
		else {
			int pagenumber=[str_Url intValue]+1;
			[self MovetoPageAtIndex:pagenumber];
			[pageSlider setValue:currentpage+0.0];						
		}

	}
}

//Showing laoder on webview while loading
- (void)webViewDidStartLoad:(UIWebView *)webView
{
	@try 
	{
		//Catch the web view 
		UIWebView *webView = (UIWebView *)[self.view viewWithTag:150];
		if(webView!=nil)
		{
			//Showing The Activity indicator.......
			UIActivityIndicatorView *actInd_webView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(350, 500, 35, 35)];
			actInd_webView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
			[actInd_webView startAnimating];
			[webView addSubview:actInd_webView];
			actInd_webView.tag = 151;
			[actInd_webView release];
		}
	}
	@catch (NSException * e) 
	{
		//Handle the execption	.......
	}
	@finally 
	{
		//
	}
	
}

//Removing loader on web view after loading
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	@try 
	{
		//Catch the web view 
		UIWebView *webView = (UIWebView *)[self.view viewWithTag:150];
		if(webView!=nil)
		{
			UIActivityIndicatorView *actInd_webView = (UIActivityIndicatorView *)[webView viewWithTag:151];
			if(actInd_webView!=nil)
			{
				[actInd_webView stopAnimating];
				[actInd_webView removeFromSuperview];
			}
		}
	}
	@catch (NSException * e) 
	{
		//Handle the execption	.......
	}
	@finally 
	{
		//
	}
	
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	
	@try 
	{
		//Catch the web view 
		UIWebView *webView = (UIWebView *)[self.view viewWithTag:150];
		if(webView!=nil)
		{
			UIActivityIndicatorView *actInd_webView = (UIActivityIndicatorView *)[webView viewWithTag:151];
			if(actInd_webView!=nil)
			{
				[actInd_webView stopAnimating];
				[actInd_webView removeFromSuperview];
			}
		}
	}
	@catch (NSException * e) 
	{
		//Handle the execption	.......
	}
	@finally 
	{
		//
	}
	//Failed to download......."Internet Unavailable" - "You Must be connected to Internet to view this link" .
	UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Internet Unavailable" message:@"You Must be connected to Internet to view this link" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
	[UIView commitAnimations];
	[WebView removeFromSuperview];	
	
}



-(void)CloseBntClicked_WebView:(id)sender
{
	//downloadingOverlayView.hidden = YES;
	@try 
	{
		//Catch the web view 
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
		[UIView commitAnimations];
		
		
		
		[WebView removeFromSuperview];
		
		
	}
	@catch (NSException * e) 
	{
		//Handle the execption	.......
	}
	@finally 
	{
		//
	}
	
}







-(void)DothisAction:(id)sender
{
	
}



//Single Tap
- (void)singleTapZoom:(NSNotification *)notification 
{
	if(isTopBarVisible==FALSE)
	{
		isTopBarVisible=TRUE;
		if(imgview_topBar!=nil)
		{	
			if(self.view!=nil)
				[self.view addSubview:imgview_topBar];
		}
		if(btn_close!=nil)
			[self.view addSubview:btn_close];
		if(btn_Toc!=nil)
			[self.view addSubview:btn_Toc];
		if(ScrlView!=nil)
			[self.view addSubview:ScrlView];
		//[self.view addSubview:btn_Lincks];
		descloserView.hidden = NO;
		
		//Added by Karpagarajan
		[self.view addSubview:sv_thumbnail];
		[pageSlider setHidden:FALSE];
		
		//End of addition
		
	}
	else 
	{
		isTopBarVisible=FALSE;
		[imgview_topBar removeFromSuperview];
		[btn_close removeFromSuperview];
		[btn_Toc removeFromSuperview];
		[ScrlView removeFromSuperview];
		[pageSlider setHidden:TRUE];
		//[btn_Lincks removeFromSuperview];
		
		//Added by Karpagarajan
		[sv_thumbnail removeFromSuperview];
		//End of addition
	}
	//single tap write code regarding the page context...........
	
	
	
	
}


// Double Tap Zoom
- (void)doubleTapZoom:(NSNotification *)notification
{
    // scroll view passed as object, get content subview
    UIScrollView * scrollView = [notification object];
    UIView * content = [[scrollView subviews] objectAtIndex:0];
    // get dictionary holding event, and event
    NSDictionary * dict = [notification userInfo];
    UIEvent * event = [dict objectForKey:@"event"];
    // get touch from set of touches for view
    UITouch * touch = [[event touchesForView:content] anyObject];
	CGPoint center = [touch locationInView:content];
    
	//CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
	float ZOOM_STEP =1.5;
	float newScale = [scrollView zoomScale] * ZOOM_STEP;
	
	if(newScale<4)
	{
		//New 
		CGRect zoomRect = [self zoomRectForScale:newScale withCenter:center];
		[scrollView zoomToRect:zoomRect animated:YES];
	}
	else 
	{
		CGRect zoomRect = [self zoomRectForScale:1 withCenter:center];
		[scrollView zoomToRect:zoomRect animated:YES];
	}
}


-(void)movedleftWhilePlaying
{
	
	
	currentpage--;
	[pageSlider setValue:currentpage+0.0];
	//[pageNoLabel setText[NSString stringWithFormat:@"Page No : %d",currentpage]];
	[self playAudioforCurrentPage];
	if(currentpage<=1)
	{
		
		currentpage=1;
		[pageSlider setValue:currentpage+0.0];
		//[pageNoLabel setText[NSString stringWithFormat:@"Page No : %d",currentpage]];
		[self playAudioforCurrentPage];
		return;
	}
	//Over Lay View 
	if (_downloadingOverlayView ==nil) {
		UIActivityIndicatorView *downloadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		
		
		downloadingIndicator.frame = CGRectMake(369,497, 30.0, 30.0);
		
		[downloadingIndicator startAnimating];	  
		_downloadingOverlayView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
		[_downloadingOverlayView setAlpha:0.85];
		[_downloadingOverlayView setBackgroundColor:[UIColor grayColor]];
		[self.view  addSubview:_downloadingOverlayView];
		[_downloadingOverlayView addSubview:downloadingIndicator];
		[downloadingIndicator release];
/*		UIImageView *uiloadimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
		uiloadimage.image = [UIImage imageNamed:@"loading_b2.jpg"];
		uiloadimage.backgroundColor = [UIColor clearColor];
		_downloadingOverlayView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
		[_downloadingOverlayView setAlpha:0.85];
		[_downloadingOverlayView setBackgroundColor:[UIColor grayColor]];
		[self.view  addSubview:_downloadingOverlayView];
		[_downloadingOverlayView addSubview:uiloadimage];
		[uiloadimage release];*/
		
	}
	[_downloadingOverlayView setHidden:TRUE];
	
/*	[self Create2Images:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage] :currentpage];
	[self Create2Images:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage+1] :currentpage+1];
	[self Create2Images:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage-1] :currentpage-1];
	[leftImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage-1]]];
	[rightImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage+1]]];
	[middleImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage]]];
	
	[containerScrollView setContentOffset:CGPointMake(screenwidth, 0) animated:NO]; */
	PdfTimer= [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(LoadPages) userInfo:nil repeats:NO];	
}



-(void)movedRightWhilePlaying
{
	
	currentpage++;
	[pageSlider setValue:currentpage+0.0];
	//[pageNoLabel setText[NSString stringWithFormat:@"Page No : %d",currentpage]];
	[self playAudioforCurrentPage];
	if(currentpage>pagecount)
	{
		currentpage=pagecount;
	}
	
	if([detailItem intValue]==pagecount)
	{	
		
	}
	else if(currentpage==pagecount)//||currentpage==2)
	{
		[pageSlider setValue:currentpage+0.0];
		//[pageNoLabel setText[NSString stringWithFormat:@"Page No : %d",currentpage]];
		[self playAudioforCurrentPage];
		return;
	}
	//Loading Over Lay View 
	if (_downloadingOverlayView ==nil) {
		UIActivityIndicatorView *downloadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		
		
		downloadingIndicator.frame = CGRectMake(369,497, 30.0, 30.0);
		
		[downloadingIndicator startAnimating];	  
		_downloadingOverlayView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
		[_downloadingOverlayView setAlpha:0.5];
		[_downloadingOverlayView setBackgroundColor:[UIColor grayColor]];
		[self.view  addSubview:_downloadingOverlayView];
		[_downloadingOverlayView addSubview:downloadingIndicator];
		[downloadingIndicator release];
	}
	[_downloadingOverlayView setHidden:TRUE];
	
	/*
	[self Create2Images:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage] :currentpage];
	[self Create2Images:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage+1] :currentpage+1];
	[self Create2Images:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage-1] :currentpage-1];	
	[leftImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage-1]]];
	[rightImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage+1]]];
	[middleImageView setImage: [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@(%d).jpg",DOCUMENTS_FOLDER,ABook.IDValue,ABook.IDValue,currentpage]]];
	[containerScrollView setContentOffset:CGPointMake(screenwidth, 0) animated:NO];*/
//	PdfTimer= [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(LoadPages) userInfo:nil repeats:NO];	
	PdfTimer= [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(LoadPages) userInfo:nil repeats:NO];	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Overriden to allow any orientation.
	return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
    
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
	
	//[self setView:nil];
	
}


- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [scrollView frame].size.height / scale;
    zoomRect.size.width  = [scrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.containerScrollView = nil;
	self.leftScrollView = nil;
	self.rightScrollView = nil;
	self.scrollView = nil;
	self.pageSlider = nil;
	self.pageNoLabel = nil;
	self.leftImageView = nil;
	self.rightImageView = nil;
	self.middleImageView = nil;
	
}


- (void)dealloc 
{	
	isCreated=FALSE;
	if(WebView!=nil)
		[WebView release];
	
	
	[ABook release];
	[detailItem release];
	[page_Book release];
	[containerScrollView release];
	[leftScrollView release];
	[rightScrollView release];
	[scrollView release];
	[pageSlider release] ;
	[pageNoLabel release] ;
	[leftImageView release];
	[rightImageView release];
	[middleImageView release];
	
	[string_bookId release];
	[string_bookCount release];
	[StrFilename release];
    [super dealloc];
}

@end
