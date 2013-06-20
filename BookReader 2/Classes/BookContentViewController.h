// BookContentViewController.h

#import <UIKit/UIKit.h>
#import "Book.h"
#import "NCXNavigationPoint.h"
@class epubstore_svcAppDelegate;
@interface BookContentViewController : UIViewController<UIWebViewDelegate> {
@private
	Book* book_;
	NCXNavigationPoint* navigationPoint_;
    epubstore_svcAppDelegate *appDelegate;
	NSArray * HtmlNameArray_ ;          //All Html Names Array  
	int curChpIndex;                   //Current Chapter Index 
	UIPopoverController *popoverController;
	IBOutlet UIButton *settingButton;
	IBOutlet UIButton *playButton;
	IBOutlet UILabel *headingLabel;
	IBOutlet UIButton *nextButton;
	IBOutlet UIButton *previousButton;
	CGPoint gestureStartPoint;
	CGFloat kMaximumVariance ;
	CGFloat kMinimumGestureLength ;
@private
    UIWebView* webView_;
}

@property (nonatomic,assign) IBOutlet UIWebView* webView;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic,retain)IBOutlet UIButton *settingButton;
@property (nonatomic,assign) IBOutlet UIButton *playButton;
@property (nonatomic,assign)IBOutlet UILabel *headingLabel;
@property (nonatomic, retain) IBOutlet UIButton *previousButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;

-(void)ReloadWebview:(epubstore_svcAppDelegate *)MyappDelegate;
-(IBAction)openSettings;
-(IBAction)scrollStartStop;
-(IBAction)nextPage;
-(IBAction)previousPage;
-(void)loadMyView:(NSString *)myHtmlName; 
-(IBAction)gotoTOCPage;
-(IBAction)TOMYBOOK;
-(void)previousPageAnimation:(UIWebView *)dummyview;
-(void)nextPageAnimation:(UIWebView *)dummyview;
//- (id) initWithBook: (Book*) book navigationPoint: (NCXNavigationPoint*) navigationPoint;
- (id) initWithBook: (Book*) book navigationPoint: (NCXNavigationPoint*) navigationPoint HtmlNameArray:(NSArray *)htmlNameArr;

@end
