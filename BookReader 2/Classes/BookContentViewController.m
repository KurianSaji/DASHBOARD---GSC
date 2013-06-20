//  BookContentViewController.m

#import "BookContentViewController.h"
#import "epubstore_svcAppDelegate.h"
#import "Settings.h"
#import "MyContentView.h"
@implementation BookContentViewController
NSString *f_name ;
CGFloat fontSize_percentage=100.0;
CGFloat scrollSpeed;
Settings *settingsView;
BOOL scrollToLast =FALSE;
CGFloat speedValue = 0.0;
UISlider *fontSizeSlider;
UISlider *scrollSpeedSlider;
NSTimer *scrollTimer;
BOOL autoScroll;
MyContentView * myContentView;

int onePageHeight;
//int chptCurPageNo=1;
//int totalNoOfPages;
@synthesize webView = webView_;
@synthesize popoverController;
@synthesize settingButton;
@synthesize playButton;
@synthesize headingLabel;
@synthesize nextButton;
@synthesize previousButton;




- (id) initWithBook: (Book*) book navigationPoint: (NCXNavigationPoint*) navigationPoint HtmlNameArray:(NSArray *)htmlNameArr
{
	appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
	 kMaximumVariance = 250;
	 kMinimumGestureLength = 20.0;
	scrollSpeed = appDelegate.speed;
	fontSize_percentage = appDelegate.fontSize;
	autoScroll = FALSE;
	
	if ((self = [super initWithNibName: @"BookContentViewController" bundle: nil]) != nil) {
		book_ = [book retain];
		navigationPoint_ = [navigationPoint retain];
		HtmlNameArray_ =htmlNameArr;
	}
	return self;
}
- (void)viewWillAppear:(BOOL)animated
{
	// Your code here
	[super viewWillAppear:NO];
	
	[webView_ reload];
	
	
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	if (interfaceOrientation ==UIInterfaceOrientationPortrait) {
		
	}
	else {
	}
	
	for(UIView *v in self.view.subviews){
		v.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	}
	
    return YES;
}

- (void) viewDidLoad
{
	// Load the content into the view
	
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ToNext:) 
                              //                   name:@"ToNext" object:nil];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ToPrevious:) 
                                           //      name:@"ToPrevious" object:nil];
	
	myContentView = [[MyContentView alloc] initWithFrame:CGRectMake(0, 0, webView_.frame.size.width, webView_.frame.size.height)];
    [myContentView setAlpha:0.0];
	[webView_ addSubview:myContentView];
	f_name = appDelegate.fontName;
	fontSize_percentage = appDelegate.fontSize;
	scrollSpeed = appDelegate.speed;
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	autoScroll = FALSE;
	NSString * htmlName = navigationPoint_.content;
	NSRange match = [htmlName rangeOfString: @".html"];
	if (match.location != NSNotFound)
	{
		htmlName = [htmlName substringWithRange: NSMakeRange (0,match.location+5)];
		
	}
	else {
		match = [htmlName rangeOfString: @".htm"];
		if (match.location != NSNotFound)
		{
			htmlName = [htmlName substringWithRange: NSMakeRange (0,match.location+4)];
			
		}
	}
    
	
	
	for(int k =0;k<[HtmlNameArray_ count];k++)
	{
		NSString *myHtmlName = [HtmlNameArray_ objectAtIndex:k];
		if ([myHtmlName isEqualToString:htmlName]==TRUE) {
			curChpIndex = k;
		}
	}
					
	onePageHeight = webView_.frame.size.height;			
	[webView_ setBackgroundColor:[UIColor whiteColor]];
	[self loadMyView:htmlName];
	for(UIView *v in self.view.subviews){
		v.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	}
	 
}


-(IBAction)gotoTOCPage
{
	//[self.navigationController popToViewController:[[self.navigationController viewControllers]objectAtIndex:1] animated:YES ];
	[self.navigationController popToViewController:[[self.navigationController viewControllers]objectAtIndex:0] animated:YES ];
	
	

}

-(IBAction)TOMYBOOK
{
	
	//[self.navigationController popToViewController:[super self] animated:YES ];
	//[self.navigationController popViewControllerAnimated:YES];
	//UIViewController *sample = [[[self.navigationController viewControllers]objectAtIndex:0] parentViewController];
	//[[self.navigationController popToViewController:[self.view.superview [[self.navigationController viewControllers]objectAtIndex:0]] animated:YES];
	[self dismissModalViewControllerAnimated:YES];
}

- (void) dealloc
{
	[book_ release];
	[navigationPoint_ release];
	[super dealloc];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	NSString *thisHtmlName = [webView stringByEvaluatingJavaScriptFromString:@"window.location.pathname;"];
	//NSString *myPresentHtml =thisHtmlName;
    thisHtmlName = [thisHtmlName lastPathComponent];

    
	for(int k =0;k<[HtmlNameArray_ count];k++)
	{
		NSString *myHtmlName = [HtmlNameArray_ objectAtIndex:k];
		if ([myHtmlName isEqualToString:thisHtmlName]==TRUE) {
			curChpIndex = k;
		}
	}
	if([f_name isEqualToString:@"none"] ==FALSE)
	{
		NSString * fontSizeString =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.WebkitTextSizeAdjust= '%f%%'",fontSize_percentage];
		NSString * fontNameString =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.fontFamily='%@'",f_name];
		//
		//[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.marginTop='100em'"];
		//[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.PageOrientation= '100%'"];
		
		
		//[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.fontFamily='Arial'"];
		[webView stringByEvaluatingJavaScriptFromString:fontSizeString];
		[webView stringByEvaluatingJavaScriptFromString:fontNameString];
	}
	else {
		
		[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.fontFamily='Georgia'"];
		NSString * fontSizeString =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.WebkitTextSizeAdjust= '%f%%'",fontSize_percentage];
		[webView stringByEvaluatingJavaScriptFromString:fontSizeString];
	//	[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.marginTop='100px'"];
//		[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.bottomCenter='200px'"];
		//		[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.pageBreakBefore='always'"];
		//		[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.pageBreakAfter='always'"];
	}
	
	//[self setTitle:bodyHeight];
	int bodyHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.defaultView.getComputedStyle(document.documentElement,null).getPropertyValue('height')"]intValue];
	onePageHeight=webView.frame.size.height;
	
	
	
	
	
	
	
	if (scrollToLast) {
		
		
		int scrollPosition  = bodyHeight -onePageHeight;
		[webView_ stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"window.scrollTo(0, %d);",scrollPosition]];
		scrollToLast =FALSE;
	}
	
	
	
	
	//[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('page-break-before',')[0].style.webkitTextSecurity: shape;= '200%'"];
	
	
	UIImage *playImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Playscroll" ofType:@"png"]];
	[playButton setImage:playImage forState:UIControlStateNormal];	
	[self performSelector:@selector(showWebView) withObject:nil afterDelay:0.03];
	
						  
}
-(void)showWebView
{
	webView_.hidden = FALSE;
}
-(void)ReloadWebview:(epubstore_svcAppDelegate *)MyappDelegate
{
	appDelegate = MyappDelegate;
	f_name = appDelegate.fontName;
	fontSize_percentage = appDelegate.fontSize;
}
-(void)loadMyView:(NSString *)myHtmlName
{
	BOOL exists;
    BOOL isDirectory;
	
	NSString* FoderPath = [NSString stringWithFormat: @"%@/%@/OPS", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], book_.fileName];
	NSString* path = [NSString stringWithFormat: @"%@/%@/OPS/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], book_.fileName, myHtmlName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	exists = [fileManager fileExistsAtPath:FoderPath isDirectory:&isDirectory];
	if(!exists)
	{
		FoderPath = [NSString stringWithFormat: @"%@/%@/OEBPS", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], book_.fileName];
		path = [NSString stringWithFormat: @"%@/%@/OEBPS/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], book_.fileName, myHtmlName];	
		exists = [fileManager fileExistsAtPath:FoderPath isDirectory:&isDirectory];
		if(!exists)
		{
			path = [NSString stringWithFormat: @"%@/%@/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], book_.fileName, myHtmlName];
		}
		
	}
	// Removing # links from file name >>>
	
	NSString* content = [NSString stringWithContentsOfFile:path
												  encoding:NSUTF8StringEncoding
													 error:NULL];
	
	if([content rangeOfString:@"</svg>"].location!=NSNotFound)
	{
		NSRange end = [content rangeOfString: @"</svg>"];
		NSRange match1 = [content rangeOfString: @"xlink:href=\""];
		NSRange start = [content rangeOfString: @"<svg"];
		
		int i =  end.location+6-match1.location;
		NSString *mat1 = [content substringWithRange: NSMakeRange (match1.location+match1.length,i)];
		NSRange match2 = [mat1 rangeOfString: @"\""];
		NSString * link = [mat1 substringWithRange: NSMakeRange (0,match2.location)]; 
		NSString *imageTag = [NSString stringWithFormat:@"<img align=\"center\" width=\"100%%\" height=\"100%%\" src=\"%@\"/>",link];
		int betweenLength =  end.location+end.length-start.location;
		
		content = [content stringByReplacingCharactersInRange: NSMakeRange(start.location, betweenLength) withString:imageTag];
		NSData* databuffer=[content dataUsingEncoding:NSUTF8StringEncoding];
		NSFileManager *filemgr;
		
		filemgr = [NSFileManager defaultManager];
		
		[filemgr createFileAtPath:path contents: databuffer attributes: nil];
		
		
		
	}
	
		[webView_ loadRequest: [NSURLRequest requestWithURL: [NSURL fileURLWithPath: path]]];
	

	
	webView_.delegate = self;
	
	
	//UIScrollView *scrollView = [[webView_ subviews] lastObject];
//	scrollView.scrollEnabled = FALSE;

	
}
-(IBAction)openSettings
{
	
	//if(settingsView==nil) 
//		settingsView= [[Settings alloc] initWithNibName:@"Settings" bundle:nil];
//	//[self.navigationController pushViewController:list animated:YES];	
//	[self presentModalViewController:settingsView animated:YES];
	
	if (autoScroll) {
		return;
	}
	int startX = 20;
	int startY = 20;
	

	UIViewController* popoverContent = [[UIViewController alloc]
										init];
	UIView* popoverView = [[UIView alloc]
						   initWithFrame:CGRectMake(0, 0, 200, 300)];
	popoverView.backgroundColor = [UIColor colorWithRed:276.0 green:234.0 blue:218.0 alpha:1.0];
	popoverContent.view = popoverView;
	
	
	
	UILabel *fontSizelabel = [[UILabel alloc]initWithFrame:CGRectMake(startX, startY, 250, 20)];
    [fontSizelabel setText:@"Text Size"];
	fontSizelabel.textAlignment = UITextAlignmentCenter;
	
	UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(2,40 , 20, 20)];
    [firstLabel setText:@"A"];
	firstLabel.font = [UIFont boldSystemFontOfSize:10.0];
	firstLabel.textAlignment = UITextAlignmentCenter;
	
	UILabel *LastLabel = [[UILabel alloc]initWithFrame:CGRectMake(270, 40, 20, 20)];
    [LastLabel setText:@"A"];
	LastLabel.font = [UIFont boldSystemFontOfSize:16.0];
	LastLabel.textAlignment = UITextAlignmentCenter;
	
	fontSizeSlider = [[UISlider alloc]initWithFrame:CGRectMake(30, 40, 220, 40)];
	[fontSizeSlider setMaximumValue:100.0];
	[fontSizeSlider setMinimumValue:0.0];
	[fontSizeSlider setValue:appDelegate.fontSize -100.0];
	
	
	UILabel *scrollSizelabel = [[UILabel alloc]initWithFrame:CGRectMake(startX, 80, 250, 40)];
    [scrollSizelabel setText:@"Autoscroll(pixels/second)"];
	scrollSizelabel.textAlignment = UITextAlignmentCenter;
	
	
	//[fontSizeSlider ]
	scrollSpeedSlider = [[UISlider alloc]initWithFrame:CGRectMake(30, 120, 220, 40)];
	[scrollSpeedSlider setMaximumValue:0.8];
	[scrollSpeedSlider setMinimumValue:0.5];
	[scrollSpeedSlider setValue:appDelegate.speed];
	
	[fontSizeSlider addTarget:self action:@selector(incFontSize) forControlEvents:UIControlEventTouchUpInside];
	[scrollSpeedSlider addTarget:self action:@selector(setScrollerSpeed) forControlEvents:UIControlEventTouchUpInside];
	
	[popoverView addSubview:fontSizeSlider];
	[popoverView addSubview:scrollSpeedSlider];
	[popoverView addSubview:firstLabel];
	[popoverView addSubview:LastLabel];
    
    [popoverView addSubview:fontSizelabel];
	[popoverView addSubview:scrollSizelabel];
	
	//resize the popover view shown
	//in the current view to the view's size
	popoverContent.contentSizeForViewInPopover =
	CGSizeMake(300, 200);
	
	//create a popover controller
	self.popoverController = [[UIPopoverController alloc]
							  initWithContentViewController:popoverContent];
	
	//present the popover view non-modal with a
	//refrence to the button pressed within the current view
	[self.popoverController presentPopoverFromRect:settingButton.frame
											inView:self.view
						  permittedArrowDirections:UIPopoverArrowDirectionAny
										  animated:YES];
	
	//release the popover content
	[popoverView release];
	[popoverContent release];
	
	
}
-(IBAction)scrollStartStop
{
        if (autoScroll ==TRUE) {
			UIImage *playImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Playscroll" ofType:@"png"]];
			[playButton setImage:playImage forState:UIControlStateNormal];
			autoScroll = FALSE;
			settingButton.hidden = FALSE;
			if(scrollTimer!=nil)
			{
				[scrollTimer invalidate];
				scrollTimer = nil;
			}
		}
		else
		{
			if (scrollSpeed <=0.5) {
				return;
			}
			CGFloat speed = 0.8 - scrollSpeed;
			
			if (speed<0.03) {
				speed = 0.03;
			}
			UIImage *playImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Pause" ofType:@"png"]];
			[playButton setImage:playImage forState:UIControlStateNormal];
			autoScroll = TRUE;
			if (scrollTimer==nil) {
				
				scrollTimer = [NSTimer scheduledTimerWithTimeInterval:speed target:self selector:@selector(scrollwebview) userInfo:nil repeats:YES];
				settingButton.hidden = TRUE;
			}
			
			
		}
									
}
-(void)setScrollerSpeed
{
	scrollSpeed = [scrollSpeedSlider value];
	appDelegate.speed = scrollSpeed;
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setFloat:scrollSpeed forKey:@"ScrollSpeed"];
	
	
}

-(void)scrollwebview
{
	int scrollPosition = [[webView_ stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"]intValue]+1;
	int bodyHeight = [[webView_ stringByEvaluatingJavaScriptFromString:@"document.defaultView.getComputedStyle(document.documentElement,null).getPropertyValue('height')"]intValue];
	if (scrollPosition+onePageHeight >bodyHeight) {
		[self scrollStartStop];
	}
	[webView_ stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"window.scrollTo(0, %d);",scrollPosition]];
}

-(void)incFontSize
{
	int value = [fontSizeSlider value];
	appDelegate.fontSize = value+100;
	//[webView_ reload];
	fontSize_percentage = appDelegate.fontSize;
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setFloat:fontSize_percentage forKey:@"FontSize"];
	
	
	NSString * fontSizeString =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.WebkitTextSizeAdjust= '%f%%'",fontSize_percentage];
	[webView_ stringByEvaluatingJavaScriptFromString:fontSizeString];
}

-(IBAction)nextPage
{
	//int scrollPosition = [[webView_ stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] intValue]+900;
//	int bodyHeight = [[webView_ stringByEvaluatingJavaScriptFromString:@"document.height"]intValue];
//	if(scrollPosition>bodyHeight)
//	{
		//Load Next Page 
	if (autoScroll) {
		[self scrollStartStop];
	}
		curChpIndex ++;
	
		if(curChpIndex >=[HtmlNameArray_ count])
		{
			curChpIndex --;
			return;
		}
		UIWebView * dummyWebview = webView_;
		[self nextPageAnimation:dummyWebview];
		NSString *htmlToLoad = [HtmlNameArray_ objectAtIndex:curChpIndex];
		[self loadMyView:htmlToLoad];
	    webView_.hidden = TRUE;
	//}
//	else
//	[webView_ stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"window.scrollTo(0, %d);",scrollPosition]];
	return ;
}

-(IBAction)previousPage
{
	//int scrollPosition = [[webView_ stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] intValue]-900;
//	if(scrollPosition<=0)
//	{
		//Load previous Page 
	if (autoScroll) {
		[self scrollStartStop];
	}
		curChpIndex --;
		if(curChpIndex <0)
		{
			curChpIndex =0;
			return;
		}
	
		NSString *htmlToLoad = [HtmlNameArray_ objectAtIndex:curChpIndex];
		scrollToLast = FALSE;
	     webView_.hidden = TRUE;
		[self loadMyView:htmlToLoad];
	UIWebView * dummyWebview = webView_;
	[self previousPageAnimation:dummyWebview];
		
		
	//}
//	else {
//	[webView_ stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"window.scrollTo(0, %d);",scrollPosition]];
//	}

	
	
	return ;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
	//[self.nextResponder touchesBegan:touches withEvent:event];
	UITouch *touch = [touches anyObject];
	gestureStartPoint = [touch locationInView:self.view];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesMoved:touches withEvent:event];
	//[self.nextResponder touchesEnded:touches withEvent:event];
	UITouch *touch = [touches anyObject];
	CGPoint currentPosition = [touch locationInView:self.view];
	
	CGFloat deltaX = fabsf(gestureStartPoint.x - currentPosition.x);
	CGFloat deltaY = fabsf(gestureStartPoint.y - currentPosition.y);
	
	// left gesture
	if (gestureStartPoint.x > currentPosition.x && deltaY <= kMaximumVariance && deltaX >= kMinimumGestureLength) {
		
		int scrollPosition = [[webView_ stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] intValue]+onePageHeight;
		int bodyHeight = [[webView_ stringByEvaluatingJavaScriptFromString:@"document.defaultView.getComputedStyle(document.documentElement,null).getPropertyValue('height')"]intValue];
		if (scrollPosition <bodyHeight) 
		{
			
			
			UIWebView * dummyWebview = webView_;
			[self nextPageAnimation:dummyWebview];
			[webView_ stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"window.scrollTo(0, %d);",scrollPosition]];
			
		}
		else {
			//chptCurPageNo = 1;
			[self nextPage];
		}
		
		
	}
	// right gesture
	else if (gestureStartPoint.x < currentPosition.x && deltaY <= kMaximumVariance && deltaX >= kMinimumGestureLength) {
		
		int scrollPosition = [[webView_ stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] intValue]-onePageHeight;
		if (scrollPosition+onePageHeight >0) 
		{			
			UIWebView * dummyWebview = webView_;
			[self previousPageAnimation:dummyWebview];
			[webView_ stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"window.scrollTo(0, %d);",scrollPosition]];
			
		}
		else {
			
			[self previousPage];
			scrollToLast = TRUE;
		}
		
	}
	//[self setAlpha:0.0];
	// up gesture
	//else if (gestureStartPoint.y > currentPosition.y && deltaX <= kMaximumVariance && deltaY >= kMinimumGestureLength) {
	//		[self moveUp];
	//	}
	//	// down gesture
	//	else if (gestureStartPoint.y < currentPosition.y && deltaX <= kMaximumVariance && deltaY >= kMinimumGestureLength) {
	//		[self moveDown];
	//	}
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesMoved:touches withEvent:event];
	//	[self.nextResponder touchesMoved:touches withEvent:event];	
}

-(void)nextPageAnimation:(UIWebView *)dummyview
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:dummyview cache:YES];
	[UIView commitAnimations];
}
-(void)previousPageAnimation:(UIWebView *)dummyview
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:dummyview cache:YES];
	[UIView commitAnimations];
}
@end
