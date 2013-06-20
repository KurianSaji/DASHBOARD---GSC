//
//  ClassicalScrollViewController.h
//  ClassicalScroll
//
//  Created by partha neo on 7/17/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HomeViewController.h"
#import "BookDetails.h"
#import <AVFoundation/AVFoundation.h>

CGAffineTransform aspectFit(CGRect innerRect, CGRect outerRect);
@class	 epubstore_svcAppDelegate;



@interface ClassicalScrollViewController : UIViewController<UIScrollViewDelegate,UIPopoverControllerDelegate,UIWebViewDelegate> 
{
	
	
	epubstore_svcAppDelegate *appDelegate;
	
@public NSString *string_bookId;
@public NSString *string_bookCount;
	
	//HomeViewController *myComicsView;
	
	UIScrollView *containerScrollView;
	UIScrollView *leftScrollView;
	UIScrollView *rightScrollView;
	UIScrollView * scrollView ;
	UISlider *pageSlider ;
	UILabel *pageNoLabel ;
	
	UIImageView *leftImageView;
	UIImageView *rightImageView;
	UIImageView *middleImageView;
	
	NSString *pdfPath;
	NSString *pdfBookID;
	NSString *StrFilename;
	
	
	UIButton *btn_Toc;
	NSMutableArray *Arr_PageNos;
	UIPopoverController *POVC_TableOC;
	id page_Book;
	id detailItem;
	NSMutableArray *arr_Toc;
	BookDetails *ABook;
	
	
	
	
	
	
	///***************
	
	int previousRightScroll;
	int screenwidth ;
	int screenheight ;

	int count ;
	int currentpage;
	int pagecount;
	BOOL isCreated;
	
	BOOL isTopBarVisible;
	
	AVAudioPlayer *bgAudioPlayer;
	int audioBeingPlayed;
	
	

	
	BOOL holdAudio;
	
	
	
	UIImageView *imgview_topBar;
	
	UIButton *btn_close;
	BOOL IsEnabledLinks;
	UIButton *btn_Lincks;
	
	int i,loadIdx;
	int pageCount;
	int bookID;
	
	
	NSTimer *PdfTimer;
	NSTimer *ThumTimer;
	UILabel *lbl;
	
	UIScrollView *ScrlView;
	UIView *descloserView;
	
	
	NSMutableArray *rectArrays;
	NSMutableArray *storeURLS;
	int RemoveBtns;
	UIImageView *imgV_PrevBtn;
	
	
	//Added by Karpagarajan
	UIScrollView *sv_thumbnail;
	NSObject *prevObj;
	//End of addition
	
	UIWebView *WebView; 
	
	
	int int_CenterThumb;
	int int_prevthumb;
}



@property (nonatomic, retain) BookDetails *ABook;
@property (nonatomic, retain) id detailItem;
@property(nonatomic, retain)id page_Book;



@property(nonatomic, retain) NSString *StrFilename;
@property(nonatomic,retain)UIScrollView *containerScrollView;
@property(nonatomic,retain)UIScrollView *leftScrollView;
@property(nonatomic,retain)UIScrollView *rightScrollView;
@property(nonatomic,retain)UIScrollView * scrollView ;
@property(nonatomic,retain)UISlider *pageSlider ;
@property(nonatomic,retain)UILabel *pageNoLabel ;

@property(nonatomic,retain)UIImageView *leftImageView;
@property(nonatomic,retain)UIImageView *rightImageView;
@property(nonatomic,retain)UIImageView *middleImageView;

@property(nonatomic,retain) NSString *string_bookId;
@property(nonatomic,retain) NSString *string_bookCount;

- (void)createScrollView:(CGRect)scrollFrame contentOffset:(CGPoint)contentOffset contentFrame:(CGRect)contentFrame
           scalingFactor:(float)scalingFactor;
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center ;
-(void)movedleftWhilePlaying;
-(void)movedRightWhilePlaying;
-(void)closeComicEngine;
-(void) Create2Images:(NSString *) imgPath:(int) dcurrentpage;
-(void) CreateThumbImages:(NSString *) imgPath:(int) dcurrentpage;

-(void)timerTrigger;
-(void)startProcessing;
-(void)makeUrlClickble:(CGPDFPageRef)pdfPage;
-(void)MovetoPageAtIndex:(NSInteger)Index;
-(UIImage *)getScaledImage:(UIImage *)actualImage toSize:(CGRect)requiredSize;
@property(nonatomic,retain)	NSString *pdfPath;
@property(nonatomic,retain)	NSString *pdfBookID;

@end

