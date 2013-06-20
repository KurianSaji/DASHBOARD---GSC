//
//  HDLoopDemoViewController.m
//  HDLoopDemo
//
//  Created by partha neo on 11/11/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "HDLoopDemoViewController.h"
#import "WallPaperScreenVC.h"
#import <QuartzCore/QuartzCore.h>
#import "epubstore_svcAppDelegate.h"
#import "SA_OAuthTwitterEngine.h"
#import "MyCustomButton1.h"

#define kOAuthConsumerKey				@"gKKNHPCJR4ogFjWT9vjgg"		//REPLACE ME  Twitter
#define kOAuthConsumerSecret			@"1FOKxqZI4FCT1zjKMA6vdE16jZD5STGVB5wGzxrpKc"

int iCatIndexValue;
int imageWidth=106;
int imageHeight=160;
int row=320/106;
int col=480/160;
int imagesInView=9;


int wid=320;
int count=0;
int xpos=0;
//int imageCount=0;
int imgCount=0;
int tagInc=1;
BOOL backToGrid=FALSE;
BOOL downloadCompleted = TRUE;



int screenWidth2=320;
int screenHeight=480;

UITextView *twitterTextField ;
UIView * twitterView;
BOOL _TwitterOpened1= NO;
NSString *path1;
NSString *imageName1;
UIImage *img;


@implementation HDLoopDemoViewController

//@synthesize wallPaperVc;

@synthesize sCatName,selectedcategoryArray;
@synthesize iCatId;
@synthesize totalImages;
@synthesize iCatIndexValue,kInAppPurchaseProUpgradeProductId;
@synthesize totalImagesCount,responseUrl1,responseUrl;
UIImageView *imgView;
int 	iCatCount,imgCount;



//int i= 9;

//UIButton *btnThumb[27];

int downloadCount = 1;
int downloadCount2 = 2;
static NSString* kAppId = @"180294668651052";
int totalCategoryImages;

NSString *imageName;
BOOL conectionValue= FALSE;
NSURLConnection *dummyConnection;

UIView *downloadingOverlayView;

// =@"maximdashpackipadhd001";
SKProduct *proUpgradeProduct;
SKProductsRequest *productsRequest;
/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES];
}
-(void)removeFileFromPath:(NSString*)path{
    NSLog(@"remove path%@",path);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSError *error;
    if ([appDelegate checkFileExist:path]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:path] error:&error];
        if (!success) NSLog(@"Error: %@", [error localizedDescription]);
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
	NSString *strCatDetails1;
	//NSArray *arrCatDetails1;
	appDelegate =(epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSLog(@"arrCat details : %@",appDelegate.arrCatList);
	strCatDetails1 = [appDelegate.arrCatList objectAtIndex:0];
	//arrCatDetails1 = [[NSArray alloc]init];
	//arrCatDetails1 = [strCatDetails1 componentsSeparatedByString:appDelegate.strColDelimiter];
	
	//self.sCatName = [arrCatDetails1 objectAtIndex:appDelegate.iCatNameIndex];
	//self.iCatId = [[arrCatDetails1 objectAtIndex:appDelegate.iCatIDIndex]intValue] ;
	//self.iCatIndexValue = 1;
	//self.totalImages = [[arrCatDetails1 objectAtIndex:appDelegate.iCatNoOfImgsIndex]intValue ] ;
	[self.navigationController.navigationBar setHidden:NO];
    
    NSString *stringForCategory=[NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@imginfo.php?catId=%d",appDelegate.strURL,iCatId]] encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"string-->%@", stringForCategory);
    
    if (stringForCategory==nil) {
        self.selectedcategoryArray=[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d info",iCatId]];
    }
	else {
        NSMutableArray *previousArray=[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d info",iCatId]];
        
		NSArray *arr=[stringForCategory componentsSeparatedByString:@"$$|$|$"];
        
        NSLog(@"arr-->%@", arr);
        
		for (NSString *str in arr) {
           // int co=[[str componentsSeparatedByString:@"$$"] count];
            
            NSLog(@"count-->%d", [[str componentsSeparatedByString:@"$$"] count]);
            
            if ([[str componentsSeparatedByString:@"$$"] count]>=3) {
                
                NSDictionary *dict=[[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[[[str componentsSeparatedByString:@"$$"] objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],[[str componentsSeparatedByString:@"$$"] objectAtIndex:1],[[str componentsSeparatedByString:@"$$"] objectAtIndex:2],nil] forKeys:[NSArray arrayWithObjects:@"id",@"status",@"timeStamp",nil]];
                
                if (!self.selectedcategoryArray) {
                    self.selectedcategoryArray=[[NSMutableArray alloc]init];
                }
                
                if (previousArray) {
                    
                    if (![[[str componentsSeparatedByString:@"$$"] objectAtIndex:1] isEqualToString:@"1"]) {
                        if([appDelegate checkFileExist:[NSString stringWithFormat:@"%d_%@_%d.png",iCatId,appDelegate.str104by157Name,[[dict objectForKey:@"id"]intValue]]]){
                            [self removeFileFromPath:[NSString stringWithFormat:@"%d_%@_%d.png",iCatId,appDelegate.str104by157Name,[[dict objectForKey:@"id"]intValue]]];
                            [self removeFileFromPath:[NSString stringWithFormat:@"%d_%@_%d.png",iCatId,appDelegate.str320by480Name,[[dict objectForKey:@"id"]intValue]]];
                        }
                    }
                    else{
                        [self.selectedcategoryArray addObject:dict];
                        [dict release];
                    }
                    
                    
                    for (NSDictionary *pDict in previousArray) {
                        if ([[pDict objectForKey:@"id"] isEqualToString:[dict objectForKey:@"id"]]) {
                            if (![[pDict objectForKey:@"timeStamp"] isEqualToString:[dict objectForKey:@"timeStamp"]]) {
                                [self removeFileFromPath:[NSString stringWithFormat:@"%d_%@_%d.png",iCatId,appDelegate.str104by157Name,[[dict objectForKey:@"id"]intValue]]];
                                [self removeFileFromPath:[NSString stringWithFormat:@"%d_%@_%d.png",iCatId,appDelegate.str320by480Name,[[dict objectForKey:@"id"]intValue]]];
                                break;
                            }
                        }
                    }
                }
                else{
                    if ([[[str componentsSeparatedByString:@"$$"] objectAtIndex:1] isEqualToString:@"1"])
                        [self.selectedcategoryArray addObject:dict];
                    [dict release];
                }
               
            }
			
            
		}
        NSLog(@"current category%@",self.selectedcategoryArray);
        [[NSUserDefaults standardUserDefaults] setObject:self.selectedcategoryArray forKey:[NSString stringWithFormat:@"%d info",iCatId]];
	}
    totalImages=[self.selectedcategoryArray count];
    NSLog(@"totalimages-->%d", totalImages);
    
	if([UIScreen mainScreen].bounds.size.height==1024)
	{
	
	 screenWidth2=768;
	 screenHeight=1024;
	 imageWidth=255;
	 imageHeight=340;
	 row=768/255;
	 col=1024/340;
	 imagesInView=9;
	
	 wid=768;
	}
	
	
	self.title=sCatName;
	backToGrid = FALSE;
	//self.navigationItem.leftBarButtonItem = BARBUTTON(@"Back", @selector(action:));
	twitterTextField = nil;
	_TwitterOpened1 =NO;
	conectionValue= FALSE;
	
	
	count=totalImages/imagesInView;
	if(totalImages%imagesInView>0)
	count++;

	
	appDelegate = (epubstore_svcAppDelegate*)[[UIApplication sharedApplication]delegate];
		
	
	//return;
					
	aScrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth2, screenHeight)];
	[aScrollView setBackgroundColor:[UIColor clearColor]];
	aScrollView.delegate=self;
	aScrollView.contentSize=CGSizeMake(count*screenWidth2, 0);
	aScrollView.minimumZoomScale=1.0;
	aScrollView.maximumZoomScale=2.0;
	aScrollView.bounces=YES;	
	aScrollView.scrollEnabled=YES;
	[aScrollView setPagingEnabled:YES];
	[aScrollView setContentOffset:CGPointMake(0, 0)];
	aScrollView.showsHorizontalScrollIndicator=YES;
	aScrollView.showsVerticalScrollIndicator=YES;
	[self.view addSubview:aScrollView];
	
	[self.view setBackgroundColor:[UIColor blackColor]];
	
	imgCount=0;
	tagInc=1;
	
	UIImage *imag;
	if(screenHeight == 1024)
	{
		imag = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"trans_border" ofType:@"png"]];

	}
	else 
	{
		imag = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"trans_border2" ofType:@"png"]];

	}

		
	// to allocate view for more than nine images
	for ( int i=0; i<=count; i++)
	{
		
		aView = [[UIView alloc] initWithFrame:CGRectMake(i*screenWidth2, 0, screenWidth2, screenHeight-50)];
		aView.backgroundColor = [UIColor blackColor];	
		[self setImagesstartingFrom:i withView:aView];
		UIImageView *transImageView =[[UIImageView alloc]init];
		[transImageView setFrame:CGRectMake(0, 0, screenWidth2, screenHeight)];
		[transImageView setImage:imag];
		
		[aView addSubview:transImageView];		
		[aScrollView addSubview:aView];
		xpos += screenWidth2;
		[transImageView release];
		[aView release];
	}
    //[imag release];
	[aScrollView release];
		
//	//**********to get imagename from string which declared in appdelegate	
	
	NSString *urlName;
	//UIImage *imgBtn;
	NSString *strCatDetails = [appDelegate.arrCatList objectAtIndex:iCatIndexValue];//iCatIndexValue
	NSArray *arrCatDetails = [strCatDetails  componentsSeparatedByString:appDelegate.strColDelimiter];
	
	
	totalCategoryImages = [[arrCatDetails objectAtIndex:appDelegate.iCatNoOfImgsIndex] intValue];
	
	downloadCount=1;
	downloadCount2=2;
    
	if ([self.selectedcategoryArray count]>0) {
        currentImage=0;
        if(screenHeight==1024)
            imageName = [NSString stringWithFormat:@"upload/product/image/%d_%@_%d.png",iCatId,appDelegate.str104by157Name,[[[self.selectedcategoryArray objectAtIndex:0] objectForKey:@"id"] intValue]];
        else {
            imageName = [NSString stringWithFormat:@"upload/product/image/%d_%@_%d.png",iCatId,appDelegate.str104by157Name,[[[self.selectedcategoryArray objectAtIndex:0] objectForKey:@"id"] intValue]];
        }
        
        urlName = [appDelegate.strURL stringByAppendingString:imageName];
		[self loadImageFromURL:urlName];
    }
    
	
	
	
	
//	if(screenHeight==1024)
//		imageName = [NSString stringWithFormat:@"upload/product/image/%d_%@_%d.png",iCatId,appDelegate.str104by157Name,2];
//	else {
//		imageName = [NSString stringWithFormat:@"upload/product/image/%d_%@_%d.png",iCatId,appDelegate.str104by157Name,2];
//	}
	
	

		//urlName = [appDelegate.strURL stringByAppendingString:imageName];
		//[self loadImageFromURL2:urlName];
	
		
	
	//UINavigationBar* theBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 768, 48.0f)];
//	[theBar pushNavigationItem:[[UINavigationItem alloc] initWithTitle:sCatName]];
//	theBar.barStyle=UIBarStyleBlackTranslucent;
//	
//	[self.view addSubview: theBar];
	
	//UIButton *button=[[UIButton alloc] init];
//	button.frame=CGRectMake(15, 5, 54,32);
//	
//	[button addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
//	
//	[button setBackgroundColor:[UIColor clearColor]];
//	[self.view addSubview:button];
	
	//UIImageView *barImgVIew = [[UIImageView alloc]initWithFrame:CGRectMake(15, 2, 65,40)];
//	
//	UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"back11.png"] ofType:@""]];
//	barImgVIew.image = img;
//	[img release];
//	[self.view addSubview:barImgVIew];
	UIView *adBg=[[UIView alloc]init] ;//]WithImage:temp11];
	
	[adBg setFrame:CGRectMake(0,974,768,50)];
	//	[adBg setFrame:CGRectMake(0,1024,768,50)];	
	[self.view addSubview:adBg];
	
	
	[adBg release];
	
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
	[btn addTarget:self action:@selector(actionSheetAction) forControlEvents:UIControlEventTouchUpInside];
	if (downloadingOverlayView ==nil) {
		UIActivityIndicatorView *downloadingIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		downloadingIndicator1.frame = CGRectMake(369,497, 30.0, 30.0);
		downloadingIndicator1.center = self.view.center;
		[downloadingIndicator1 startAnimating];
		
		if(screenHeight==1024)
		{
			downloadingOverlayView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
		}
		else 
		{
			downloadingOverlayView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
		}
		
		[downloadingOverlayView setAlpha:0.85];
		[downloadingOverlayView setBackgroundColor:[UIColor grayColor]];
		[self.view  addSubview:downloadingOverlayView];
		[downloadingOverlayView addSubview:downloadingIndicator1];
		downloadingIndicator1.center = downloadingOverlayView.center;
		[downloadingIndicator1 release];
	}
	[self.view  addSubview:downloadingOverlayView];
	[downloadingOverlayView setHidden:TRUE];
	
}




-(void)actionSheetAction{
	
	UIActionSheet *aSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Tell a Friend",@"Tweet This",@"Facebook",@"Other Apps",nil];
													
	[aSheet showInView:self.view];
	[aSheet release];
	
	
}

-(void)backBtnAction
{
	//hdloop = [[HDLoopDemoViewController alloc]init];
    [downloadingOverlayView release];
	appDelegate.thumbView = TRUE;
	[self dismissModalViewControllerAnimated:YES];
	    //[[hdloop parentViewController] dismissModalViewControllerAnimated:YES]; 
	//[hdloop.view removeFromSuperview];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	if(buttonIndex ==0)
	{
		[self emailact];
	}
    else if(buttonIndex ==1)
	{
		[self openTwitterPage];
	}
	else if(buttonIndex ==2)
	{
		[self facebtnact];
    }
	else if(buttonIndex ==3)
	{
		[[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"http://itunes.apple.com/us/artist/alpha-media-group-inc./id393395810"]];
	}
	
}


-(void)action:(id)sender{
	if(_TwitterOpened1 ==YES)
	{
		_TwitterOpened1 =NO;
		self.title = sCatName;
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
		[btn addTarget:self action:@selector(actionSheetAction) forControlEvents:UIControlEventTouchUpInside];
		
		for(UIView *s in twitterView.subviews )
		{
			[s removeFromSuperview];
		}
		
		[twitterTextField release];
		twitterTextField = nil;
		[twitterView removeFromSuperview];
		[twitterView release];
		
		
		return;
	}
	//[self.navigationController dismissModalViewControllerAnimated:YES];

	[appDelegate.tabBarController dismissModalViewControllerAnimated:NO];

	//[self.navigationController popToViewController:[[self.navigationController viewControllers]objectAtIndex:0] animated:YES ];
	
}



-(void)setImagesstartingFrom:(NSInteger)number withView:(UIView*)v{
	
	int xAxis = 0;
	int yAxis = 0;
	//UIButton *myButton;
	
	int i=1;
	NSString *strCatDetails1 = [appDelegate.arrCatList objectAtIndex:iCatIndexValue];
	//NSArray *arrCatDetails1 = [strCatDetails1  componentsSeparatedByString:appDelegate.strColDelimiter];
	
	
	//totalImagesCount = [[arrCatDetails1 objectAtIndex:appDelegate.iCatNoOfImgsIndex ]intValue];
    totalImagesCount =[self.selectedcategoryArray count];
	
for(int y=0;y<col;y++)
{
	for(int x=0;x<row;x++)
	{
		//NSLog(@"imgCount :%d totalImages:%d",imgCount,totalImages);
		if (imgCount>=totalImages) {
			y=col;
			x= row;
			return;
		}
						
		

		xAxis=x*imageWidth;
		yAxis=y*imageHeight;
	
		MyCustomButton1 *btnThumb= [[MyCustomButton1 alloc]init];
		btnThumb.frame=CGRectMake(xAxis, yAxis, imageWidth, imageHeight);
		[btnThumb addTarget:self action:@selector(fnSelectedThumb:) forControlEvents:UIControlEventTouchUpInside];
		[btnThumb setTag:tagInc];
		//[btnThumb[i] setContentMode:UIViewContentModeScaleToFill];
		
		if(tagInc <=totalImagesCount)
			[btnThumb loadLoader];
		/*btnThumb[i] = [[UIButton alloc]init];			
		btnThumb[i].frame=CGRectMake(xAxis, yAxis, imageWidth, imageHeight);
		[btnThumb[i] addTarget:self action:@selector(fnSelectedThumb:) forControlEvents:UIControlEventTouchUpInside];
		[btnThumb[i] setTag:tagInc];*/
		//[btnThumb[i] setContentMode:UIViewContentModeScaleToFill];
		
				
		//NSString *strCatDetails = [appDelegate.arrCatList objectAtIndex:iCatIndexValue];
//		NSArray *arrCatDetails = [[NSArray alloc]init];
//		arrCatDetails = [strCatDetails  componentsSeparatedByString:appDelegate.strColDelimiter];
//		
//		totalCategoryImages = [[arrCatDetails objectAtIndex:appDelegate.iCatNoOfImgsIndex] intValue];
//		
//		imageName = [NSString stringWithFormat:@"%d_%@_%d.png",iCatId,appDelegate.str104by157Name,downloadCount];
//		NSString *urlName = [appDelegate.strURL stringByAppendingString:imageName];
//		[self loadImageFromURL:urlName];
		
		
		[v   addSubview:btnThumb];
		[btnThumb release];
		i++;
		tagInc++;
	
	}
	
}
   
	
}


-(IBAction)fnSelectedThumb:(id) sender
{
    NSString *strImgName = [appDelegate.arrCatList objectAtIndex:iCatIndexValue];
	NSArray *arrImgName = [strImgName  componentsSeparatedByString:appDelegate.strColDelimiter];
	
	
	//strCatDetails = [appDelegate.arrCatList objectAtIndex:iSelectedCatIndex];
	//	
	//	
	//	arrCatDetails = [[NSArray alloc]init];
	//	arrCatDetails = [strCatDetails  componentsSeparatedByString:appDelegate.strColDelimiter];
	//	
	NSString *strPurchasedValue = [NSString stringWithFormat:@"%@",[arrImgName objectAtIndex:appDelegate.checkPurchasedValue]];
	
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	//[defaults setObject: data forKey: @"authData"];
	//[defaults synchronize];
	
	//purchase in app
	
	if(screenHeight==1024)
		self.kInAppPurchaseProUpgradeProductId = [NSString stringWithFormat:@"maxdashwpipa%@",[ arrImgName objectAtIndex:appDelegate.iCatIDIndex]];
	else
		self.kInAppPurchaseProUpgradeProductId = [NSString stringWithFormat:@"maxdashwpiph%@",[ arrImgName objectAtIndex:appDelegate.iCatIDIndex]];
    
    
	NSString *currentProductID=[self.kInAppPurchaseProUpgradeProductId substringFromIndex:11];
	NSLog(@"check next productid %@",currentProductID);
	int purchseStatus=[defaults integerForKey:currentProductID];
	
	if([strPurchasedValue floatValue]!=0 && purchseStatus!=111)
	{
		NSLog(@"check already");
		[self requestProUpgradeProductData];
        [self.view bringSubviewToFront:downloadingOverlayView];
		downloadingOverlayView.hidden=FALSE;
		return;
	}
	
	
	
	
	
	
	

	backToGrid = TRUE;
	
	aButton =(UIButton*)sender;
			
	NSString *strCatDetails1 = [appDelegate.arrCatList objectAtIndex:iCatIndexValue];//iCatIndexValue
	NSArray *arrCatDetails1 = [strCatDetails1  componentsSeparatedByString:appDelegate.strColDelimiter];
	
	totalImagesCount = [self.selectedcategoryArray count];
	//totalImagesCount = [[arrCatDetails1 objectAtIndex:appDelegate.iCatNoOfImgsIndex ]intValue];
	
//	if (wallPaperVc==nil)
//	{
//		wallPaperVc = [[WallPaperScreenVC alloc]init ];//WithNibName:@"WallPaperScreenVC" bundle:nil];
//	}
	WallPaperScreenVC *wallPaperVc = [[WallPaperScreenVC alloc]init ];//WithNibName:@"WallPaperScreenVC" bundle:nil];
	//wallPaperVc.iTotalCatImages = [[arrCatDetails1 objectAtIndex:appDelegate.iCatNoOfImgsIndex] intValue ];
    wallPaperVc.iTotalCatImages=[self.selectedcategoryArray count];
    wallPaperVc.selectedArray=self.selectedcategoryArray;
	wallPaperVc.iSelectedCatIndex = iCatIndexValue;//iCatIndexValue
	wallPaperVc.iSelectedImgIndex = aButton.tag;
	NSLog(@"iSelectedImgIndex %d",wallPaperVc.iSelectedImgIndex);
	wallPaperVc.sCatTitle = [arrCatDetails1 objectAtIndex:appDelegate.iCatNameIndex];
	
	if(aButton.tag <=totalImagesCount)
		//[self.view addSubview:wallPaperVc];
		if (wallPaperVc!=nil)
		{
			[self presentModalViewController:wallPaperVc animated:YES];
		}
	//[self.navigationController pushViewController:wallPaperVc animated:YES];
	[wallPaperVc release];
}


	
- (void)loadImageFromURL:(NSString*)url 
{
//	NSString *strCatDetails = [appDelegate.arrCatList objectAtIndex:iCatIndexValue];
//	NSArray *arrCatDetails = [[NSArray alloc]init];
//	arrCatDetails = [strCatDetails  componentsSeparatedByString:appDelegate.strColDelimiter];
//	
//	if(screenHeight==1024)
//		imageName = [NSString stringWithFormat:@"upload/product/image/%d_%@_%d.jpg",iCatId,appDelegate.str104by157Name,1];
//	else {
//		imageName = [NSString stringWithFormat:@"upload/product/image/%d_%@_%d.jpg",iCatId,appDelegate.str104by157Name,1];
//	}
//	
	
	if([appDelegate checkFileExist:[url lastPathComponent]])
		{
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			UIImage *imgBtn= [UIImage imageWithData:[NSData dataWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:[url lastPathComponent]]]];
			
			
			//UIImage *imgBtn= [appDelegate getImageFromDocFolder:[url lastPathComponent]];
			//NSString *str = appDelegate.dataFilePath;
			//conectionValue= TRUE;
			//[self loadImageFromURL:appDelegate.dataFilePath];
			

//			NSString *tempStr;
//			NSString *imgStr;
//			NSString *strDescription;
//			
//			strDescription = url;
//			
//			
//			
//			NSString *last = [strDescription lastPathComponent]; //1_320by480_1.jpg
//			NSString *trim= [last stringByReplacingOccurrencesOfString:@">" withString:@""];
//			
//			
//			NSArray *arrGetSlashSeperatedValue;
//			
//			if(screenHeight==1024)
//				arrGetSlashSeperatedValue = [last componentsSeparatedByString:appDelegate.str104by157Name];
//			else {
//				arrGetSlashSeperatedValue = [last componentsSeparatedByString:appDelegate.str104by157Name];
//			}
//			
//			NSString *imageValue = [arrGetSlashSeperatedValue objectAtIndex:1]; //_1.jpg
//			
//			
//			tempStr =[imageValue substringFromIndex:1 ];//to remove underscore from _1 _2 etc  //1.jpg
//			
//				
//				if(downloadCount<=9){//////////////
//					imgStr =[tempStr substringToIndex:1 ]; //1
//					
//				}
//				else {
//					imgStr =[tempStr substringToIndex:2 ]; //10
//					
//				}
//
//			
//			
//			
//			NSLog(@"1111111111111imgStr %@",imgStr);
//			
//			int z = [imgStr intValue];
			
			
			//UIImage *imgThumb;
			NSString *urlName;
			

				//imgThumb = imgBtn;
			
			
			UIButton *currentBtn = (UIButton*)[self.view viewWithTag:currentImage+1];
			
			
			//[btnThumb[z] setBackgroundColor:[UIColor redColor]];
			//[btnThumb[z] setImage:imgThumb forState:UIControlStateNormal];
			[currentBtn setImage:imgBtn forState:UIControlStateNormal];
			[currentBtn stopLoader];
			//save loaded images to ducuments
			//[appDelegate imageSaveToDocumentPath  :imgThumb :trim];
			
			//if(connectionType==1)
			//{	  
				
				if ([self.selectedcategoryArray count] > currentImage+1)
				{
					
					//downloadCount+=2;
                    currentImage++;
					
					//if(downloadCount<=totalCategoryImages)
					//{
						
						if(screenHeight==1024)
							imageName = [NSString stringWithFormat:@"upload/product/image/%d_%@_%d.png",iCatId,appDelegate.str104by157Name,[[[self.selectedcategoryArray objectAtIndex:currentImage] objectForKey:@"id"] intValue]];
						else {
							imageName = [NSString stringWithFormat:@"upload/product/image/%d_%@_%d.png",iCatId,appDelegate.str104by157Name,[[[self.selectedcategoryArray objectAtIndex:currentImage] objectForKey:@"id"] intValue]];
						}
						

							urlName = [appDelegate.strURL stringByAppendingString:imageName];
						NSLog(@"%@",urlName);
							[self loadImageFromURL:urlName];
						
						
						
						
					//}
					
				}
//				else if(downloadCount == totalCategoryImages)
//				{
//					downloadCount = 1;
//				}
								
			//}
			
			
		}
	else
	{
        NSLog(@"check url%@",url);
		NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
												 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0];
		
		connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
	}

	
	
}

- (void)loadImageFromURL2:(NSString*)url 
{
	NSLog(@"all images main url %@",url);
	if([appDelegate checkFileExist:[url lastPathComponent]])
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		UIImage *imgBtn= [UIImage imageWithData:[NSData dataWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:[url lastPathComponent]]]];
		
		//UIImage *imgBtn= [appDelegate getImageFromDocFolder:[url lastPathComponent]];
		//NSString *str = appDelegate.dataFilePath;
		//conectionValue= TRUE;
		//[self loadImageFromURL:appDelegate.dataFilePath];
		
		
		NSString *tempStr;
		NSString *imgStr;
		NSString *strDescription;
		
		strDescription = url;
		
		
		
		NSString *last = [strDescription lastPathComponent]; //1_320by480_1.jpg
		//NSString *trim= [last stringByReplacingOccurrencesOfString:@">" withString:@""];
		
		
		NSArray *arrGetSlashSeperatedValue;
		
		if(screenHeight==1024)
			arrGetSlashSeperatedValue = [last componentsSeparatedByString:appDelegate.str104by157Name];
		else {
			arrGetSlashSeperatedValue = [last componentsSeparatedByString:appDelegate.str104by157Name];
		}
		
		NSString *imageValue = [arrGetSlashSeperatedValue objectAtIndex:1]; //_1.jpg
		
		
		tempStr =[imageValue substringFromIndex:1 ];//to remove underscore from _1 _2 etc  //1.jpg
		
		
		if(downloadCount2<=9){//////////////
			imgStr =[tempStr substringToIndex:1 ]; //1
			
		}
		else {
			imgStr =[tempStr substringToIndex:2 ]; //10
			
		}
		
		
		
		
		NSLog(@"222222222222imgStr %@",imgStr);
		
		int z = [imgStr intValue];
		
		
		UIImage *imgThumb;
		NSString *urlName;
		
		
		imgThumb = imgBtn;
		
		
		UIButton *currentBtn = (UIButton*)[self.view viewWithTag:z];
		
		
		//[btnThumb[z] setBackgroundColor:[UIColor redColor]];
		//[btnThumb[z] setImage:imgThumb forState:UIControlStateNormal];
		[currentBtn setImage:imgThumb forState:UIControlStateNormal];
		[currentBtn stopLoader];
		//save loaded images to ducuments
		//[appDelegate imageSaveToDocumentPath  :imgThumb :trim];
		
		//if(connectionType==1)
		{	  
			
			if (downloadCount2 < totalCategoryImages)
			{
				
				downloadCount2+=2;
				
				if(downloadCount2<=totalCategoryImages)
				{
					
					if(screenHeight==1024)
						imageName = [NSString stringWithFormat:@"upload/product/image/%d_%@_%d.png",iCatId,appDelegate.str104by157Name,downloadCount2];
					else {
						imageName = [NSString stringWithFormat:@"upload/product/image/%d_%@_%d.png",iCatId,appDelegate.str104by157Name,downloadCount2];
					}
					
					
					urlName = [appDelegate.strURL stringByAppendingString:imageName];
					[self loadImageFromURL2:urlName];
					
					
					
					
				}
				
			}
			else if(downloadCount2 == totalCategoryImages)
			{
				downloadCount2 = 2;
			}
			
		}
		
		
	}
	else
	{
        
        NSLog(@"all images url %@",url);
		NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
												 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0];
		
		connection2 = [[NSURLConnection alloc]initWithRequest:request delegate:self];
	}
	
}


- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData 
{
	
		
	//if(theConnection==connection)
	//{
	
	if (data==nil) 
	{
		data = [[NSMutableData alloc] initWithCapacity:2048];
    }
	
    [data appendData:incrementalData];
	//}
//	else if(theConnection==connection2){
//		if (data2==nil) 
//		{
//			data2 = [[NSMutableData alloc] initWithCapacity:2048];
//		}
//		
//		[data2 appendData:incrementalData];
//	}else if(theConnection == dummyConnection) {
//		data = [[NSData alloc]initWithContentsOfFile:appDelegate.dataFilePath];
//	}


		
								  
}
-(void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
{
//	if (theConnection==connection) {
//		self.responseUrl =[response URL];
//	}
//	else if (theConnection==connection2) {
//		self.responseUrl1 =[response URL];
//	}
	
}
										  
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection 
{
	NSLog(@"CDFL - LOOPVIEW");
	
	//int connectionType=0;
	
	//NSString *strCurrentFileName;
	
	
	
	
//	NSString *tempStr;
//	NSString *imgStr;
//	NSString *strDescription;
//	
//	//strDescription = [theConnection description];
//	//NSLog(@"str desc %@",strDescription);
//	NSString *last;
//	if (theConnection==connection) {
//		last = [self.responseUrl lastPathComponent];
//	}
//	else if (theConnection==connection2) {
//		last = [self.responseUrl1 lastPathComponent];
//	}
//	if(theConnection==connection)
//	{
//		
//		connectionType=1;
//		[connection release];
//		connection=nil;
//		
//	}
//	
//	if(theConnection==connection2)
//	{
//		connectionType=2;
//		
//		[connection2 release];
//		connection2=nil;
//		
//	}	
	

		
//	NSArray *arrGetSlashSeperatedValue;
//	
//	if(screenHeight==1024)
//	arrGetSlashSeperatedValue = [last componentsSeparatedByString:appDelegate.str104by157Name];
//	else {
//		arrGetSlashSeperatedValue = [last componentsSeparatedByString:appDelegate.str104by157Name];
//	}
//
//	NSString *imageValue = [arrGetSlashSeperatedValue objectAtIndex:1];
//	
//	
//	tempStr =[imageValue substringFromIndex:1 ];//to remove underscore from _1 _2 etc
//	
//	
//	imgStr = [tempStr stringByDeletingPathExtension];

	//if(connectionType==1)
//	   {
//	
//	if(downloadCount<=9){
//		imgStr =[tempStr substringToIndex:1 ];
//
//	}
//	else {
//		imgStr =[tempStr substringToIndex:2 ];
//
//	}
//	   }
//	   
//	   if(connectionType==2)
//		  {
//			  
//			  if(downloadCount2<=9){
//				  imgStr =[tempStr substringToIndex:1 ];
//				  
//			  }
//			  else {
//				  imgStr =[tempStr substringToIndex:2 ];
//				  
//			  }
//		  }
//	   

	
	//NSLog(@"imgStr %@",imgStr);
	
	//int z = [imgStr intValue];
			
		
	UIImage *imgThumb;
	NSString *urlName;
	
	//if(connectionType==1)
	imgThumb = [UIImage imageWithData:data];
	//else {
	//	imgThumb = [UIImage imageWithData:data2];
	//}

	
	UIButton *currentBtn = (UIButton*)[self.view viewWithTag:currentImage+1];
	
	
	//[btnThumb[z] setBackgroundColor:[UIColor redColor]];
	//[btnThumb[z] setImage:imgThumb forState:UIControlStateNormal];
	[currentBtn setImage:imgThumb forState:UIControlStateNormal];
	[currentBtn stopLoader];
	//save loaded images to ducuments
    if ([[[UIDevice currentDevice] systemVersion] intValue]>=5) {
        [appDelegate imageSaveToDocumentPath  :imgThumb :theConnection.originalRequest.URL.lastPathComponent];
    }
    else{
        [appDelegate imageSaveToDocumentPath  :imgThumb :theConnection.description.lastPathComponent];
    }
	

	//if(connectionType==1)
	//{	  
	
		//if (downloadCount < totalCategoryImages)
		//{
			
			//downloadCount+=2;
			
			if([self.selectedcategoryArray count]>currentImage+1)
			{
				currentImage++;
				if(screenHeight==1024)
					imageName = [NSString stringWithFormat:@"upload/product/image/%d_%@_%d.png",iCatId,appDelegate.str104by157Name,[[[self.selectedcategoryArray objectAtIndex:currentImage] objectForKey:@"id"] intValue]];
				else {
					imageName = [NSString stringWithFormat:@"upload/product/image/%d_%@_%d.png",iCatId,appDelegate.str104by157Name,[[[self.selectedcategoryArray objectAtIndex:currentImage] objectForKey:@"id"] intValue]];
				}
				
				
				//NSString *strBtnImgName = [imageName lastPathComponent];
				
				//if([appDelegate checkFileExist:strBtnImgName])
//				{
//					UIImage *imgBtn = [appDelegate getImageFromDocFolder:strBtnImgName];
//				}
//				else 
//				{
					urlName = [appDelegate.strURL stringByAppendingString:imageName];
					[self loadImageFromURL:urlName];
				//}
				

				
			}
			
		//}
//		else if(downloadCount == totalCategoryImages)
//		{
//			downloadCount = 1;
//		}
		
		[data release];
		data=nil;	
	   
	//}
	   
		  
		  //////////
		  
		  
		  
		  
//	if(connectionType==2)
//	{
//		if (downloadCount2 < totalCategoryImages)
//		{
//			
//			downloadCount2+=2;
//			
//			if(downloadCount2<=totalCategoryImages)
//			{
//				
//				if(screenHeight==1024)
//					imageName = [NSString stringWithFormat:@"upload/product/image/%d_%@_%d.png",iCatId,appDelegate.str104by157Name,downloadCount2];
//				else 
//				{
//					imageName = [NSString stringWithFormat:@"upload/product/image/%d_%@_%d.png",iCatId,appDelegate.str104by157Name,downloadCount2];
//				}
//				
//				
//				NSString *strBtnImgName = [imageName lastPathComponent];
//
//				//if([appDelegate checkFileExist:strBtnImgName])
////				{
////					UIImage *imgBtn = [appDelegate getImageFromDocFolder:strBtnImgName];
////				}
////				else 
////				{
//					urlName = [appDelegate.strURL stringByAppendingString:imageName];
//					[self loadImageFromURL2:urlName];
//				//}
//				
//				
//				//save loaded images to ducuments
//				[appDelegate imageSaveToDocumentPath:imgThumb :imageName];
//				
//			}
//			
//		}
//		else if(downloadCount2 == totalCategoryImages)
//		{
//			downloadCount2 = 2;
//		}
//		
//		[data2 release];
//		data2=nil;
//			  
//	}
	
}



//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scroll{
//	
//	//
////	downloadCount = scroll.contentOffset.x/320 *9 +1;
////	
////		
////	imageName = [NSString stringWithFormat:@"%d_%@_%d.png",iCatId,appDelegate.str104by157Name,downloadCount];
////	
////	NSString *urlName = [appDelegate.strURL stringByAppendingString:imageName];
////	[self loadImageFromURL:urlName];
////	
//}


//- (void)viewWillAppear:(BOOL)animated {
//	// hide status bar
//	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
//	
//	// hide navigation bar
//	//[navigationController setNavigationBarHidden:YES animated:YES];
//}
//



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
		//NSLog(@" didReceiveMemoryWarning in HDlooopdemoviewController ");
	// Release any cached data, images, etc that aren't in use.
	
//	UIAlertView *alert = [[UIAlertView alloc] 
//						  initWithTitle:@"Warning" 
//						  message:@"You are running out of memory" 
//						  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//	[alert show];
//	[alert release];
	
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	//[aScrollView release];
	
    [super dealloc];
}

- (NSString *)adWhirlApplicationKey {
    return kSampleAppKey;
}

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (NSURL *)adWhirlConfigURL {
    return [NSURL URLWithString:kSampleConfigURL];
}

- (NSURL *)adWhirlImpMetricURL {
    return [NSURL URLWithString:kSampleImpMetricURL];
}

- (NSURL *)adWhirlClickMetricURL {
    return [NSURL URLWithString:kSampleClickMetricURL];
}

- (NSURL *)adWhirlCustomAdURL {
    return [NSURL URLWithString:kSampleCustomAdURL];
}

//- (void)adWhirlDidReceiveAd:(AdWhirlView *)adWhirlView {
//    /*self.label.text = [NSString stringWithFormat:
//     @"Got ad from %@",
//     [adWhirlView mostRecentNetworkName]];*/
//}
//
//- (void)adWhirlDidFailToReceiveAd:(AdWhirlView *)adWhirlView usingBackup:(BOOL)yesOrNo {
//    /*self.label.text = [NSString stringWithFormat:
//     @"Failed to receive ad from %@, %@. Error: %@",
//     [adWhirlView mostRecentNetworkName],
//     yesOrNo? @"will use backup" : @"will NOT use backup",
//     adWhirlView.lastError == nil? @"no error" : [adWhirlView.lastError localizedDescription]];*/
//    //[adView requestFreshAd];
//}
//
//- (void)adWhirlReceivedRequestForDeveloperToFufill:(AdWhirlView *)adWhirlView {
//    UILabel *replacement = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, screenWidth, screenHeight)];
//    replacement.backgroundColor = [UIColor blackColor];
//    replacement.textColor = [UIColor whiteColor];
//    replacement.textAlignment = UITextAlignmentCenter;
//    replacement.text = @"Visit EliteGudz.com now !";
//    [adWhirlView replaceBannerViewWith:replacement];
//    [replacement release];
//    //self.label.text = @"Generic Notification";
//}
//
//- (void)adWhirlReceivedNotificationAdsAreOff:(AdWhirlView *)adWhirlView {
//    //self.label.text = @"Ads are off";
//	
//}
//
//- (void)adWhirlWillPresentFullScreenModal {
//    NSLog(@"SimpleView: will present full screen modal");
//}
//
//- (void)adWhirlDidDismissFullScreenModal {
//    NSLog(@"SimpleView: did dismiss full screen modal");
//}
//
//- (void)adWhirlDidReceiveConfig:(AdWhirlView *)adWhirlView {
//    //self.label.text = @"Received config. Requesting ad...";
//}
//
//- (CLLocation *)locationInfo {
//    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
//    CLLocation *location = [locationManager location];
//    [locationManager release];
//    return location;
//}

- (NSDate *)dateOfBirth {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:1979];
    [comps setMonth:11];
    [comps setDay:6];
    NSDate *date = [gregorian dateFromComponents:comps];
    [gregorian release];
    [comps release];
    return date;
}

- (NSUInteger)incomeLevel {
    return 99999;
}

- (NSString *)postalCode {
    return @"31337";
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
    CGPoint tempPoint=[touch locationInView:self.view];
    if(tempPoint.y>=430)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.com/apps/zaahtechnologiesinc"]];
}

#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return nil;//[[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	NSLog(@"Authenicated for %@", username);
	//NSLog(@"twitterText for %@", twitterText);
	[_engine sendUpdate: [NSString stringWithFormat:@"%@",twitterTextField.text]];
	[twitterTextField release];
	twitterTextField = nil;
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	//NSLog(@"Authentication Failed!");
	UIAlertView *status=[[UIAlertView alloc]initWithTitle:@"Twitter Authentication Failed!" 
												  message:nil 
												 delegate:self 
										cancelButtonTitle:@"OK" 
										otherButtonTitles:nil];
	[status show];
	[status release];
	[self dismissModalViewControllerAnimated:YES];
	
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	//NSLog(@"Authentication Canceled.");
	UIAlertView *status=[[UIAlertView alloc]initWithTitle:@"Twitter Authentication Canceled" 
												  message:nil 
												 delegate:self 
										cancelButtonTitle:@"OK" 
										otherButtonTitles:nil];
	[status show];
	[status release];
	[self dismissModalViewControllerAnimated:YES];
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	//NSLog(@"Request %@ succeeded", requestIdentifier);
	UIAlertView *status=[[UIAlertView alloc]initWithTitle:@"Tweet posted successfully" 
												  message:nil 
												 delegate:self 
										cancelButtonTitle:@"OK" 
										otherButtonTitles:nil];
	[status show];
	[status release];
	[self dismissModalViewControllerAnimated:YES];
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	//NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}



//=============================================================================================================================
#pragma mark ViewController Stuff

-(void)openTwitterPage
{
	//self.navigationController.navigationBarHidden = TRUE;
	_TwitterOpened1 = YES;
//	appDelegate.tabBarController.navigationItem.rightBarButtonItem = BARBUTTON(@"Post", @selector(twitteract));
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Post", @selector(twitteract));
//	self.navigationItem.leftBarButtonItem = BARBUTTON(@"Back", @selector(action:));
	self.title = @"Tweet This";
	
	twitterView = [[UIView alloc]initWithFrame:CGRectMake(0,0, screenWidth2, screenHeight)];
	UIImage  *img  = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Twitter" ofType:@"jpg"]];
	UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, screenWidth2, screenHeight)];
	imageView.image = img;
	
	
	twitterTextField = [[UITextView alloc] initWithFrame:CGRectMake(10,100, screenWidth2-20, 200)];
	
    twitterTextField.textColor = [UIColor blackColor];
	
    twitterTextField.font = [UIFont fontWithName:@"Arial" size:18];
	
    twitterTextField.delegate = self;
	
    twitterTextField.backgroundColor = [UIColor whiteColor];
	twitterTextField.text =@"I hooked up my phone with the GraffitiSprayCan Dash App. Check it.http://itunes.com/apps/zaahtechnologiesinc";
	//  twitterTextField.placeholder = @"Enter Text To Tweet";
	
	//   twitterTextField.returnKeyType = UIReturnKeyDefault;
	
	// twitterTextField.keyboardType = UIKeyboardTypeDefault; 
	
    twitterTextField.scrollEnabled = YES;
	
    twitterTextField.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	
	//twitterTextField = [[UITextField alloc] initWithFrame:CGRectMake(10,100, 300, 200)];
	//	twitterTextField.borderStyle = UITextBorderStyleRoundedRect;
	//	twitterTextField.textColor = [UIColor blackColor]; //text color
	//	twitterTextField.font = [UIFont systemFontOfSize:17.0];  //font size
	//	twitterTextField.placeholder = @"Enter Text To Tweet";  //place holder
	//	twitterTextField.backgroundColor = [UIColor clearColor]; //background color
	//	twitterTextField.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
	//	twitterTextField.
	//	twitterTextField.keyboardType = UIKeyboardTypeDefault;  // type of the keyboard
	//	twitterTextField.returnKeyType = UIReturnKeyDone;  // type of the return key
	//	
	//	twitterTextField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	//	twitterTextField.delegate = self;
	
	[twitterView addSubview:imageView];
	
	
	[twitterView addSubview:twitterTextField];
	
	[self.view addSubview:twitterView];
	//[img release];
	[imageView release];
	
	//[twitterTextField release];
	
	//[twitterView release];
	
	
}



-(IBAction)twitteract {
	if ([twitterTextField hasText]==FALSE) {
		UIAlertView *status=[[UIAlertView alloc]initWithTitle:@"Please enter text to tweet" 
													  message:nil 
													 delegate:self 
											cancelButtonTitle:@"OK" 
											otherButtonTitles:nil];
		[status show];
		[status release];
		return;
		
	}
	_TwitterOpened1 = NO;
	//self.title = aString;
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
	[btn addTarget:self action:@selector(actionSheetAction) forControlEvents:UIControlEventTouchUpInside];
	
	for(UIView *s in twitterView.subviews )
	{
		[s removeFromSuperview];
	}
	
	//[twitterTextField release];
	[twitterView removeFromSuperview];
	[twitterView release];
	
	if (_engine) [_engine release];
	_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
	_engine.consumerKey = kOAuthConsumerKey;
	_engine.consumerSecret = kOAuthConsumerSecret;
	
	UIViewController	*controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
	
	if (controller) 
		[self presentModalViewController: controller animated: YES];
	else {
		[_engine sendUpdate: [NSString stringWithFormat: @"Already Updated. %@", [NSDate date]]];
	}
	
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"]) {
		
		[textView resignFirstResponder];
		
	}
    return YES;
	
}



-(IBAction)facebtnact{
	_permissions =  [[NSArray arrayWithObjects: @"read_stream",@"user_photos",@"user_videos",@"publish_stream ",nil] retain];
	_facebook = [[Facebook alloc] init];
	[_facebook authorize:kAppId permissions:_permissions delegate:self];
}


-(void) fbDidLogin {
	NSLog(@"did  login");
	
	
	//UIImage  *img  = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Fol3Image2" ofType:@"jpg"]];
	//	NSData *dataObj = UIImageJPEGRepresentation(img, 1.0);
	//	
	//	NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:dataObj, @"picture",
	//									@"my pencil",@"caption",nil];
	//	
	//	
	//	[_facebook requestWithMethodName: @"facebook.photos.upload" 
	//						   andParams: params
	//					   andHttpMethod: @"POST" 
	//						 andDelegate: self]; 
	if(appDelegate.facebookLogin == TRUE)
	{
		appDelegate.facebookLogin = FALSE;
		[self publishStream];
		
	}
	
	
}

- (void) publishStream{
	
	SBJSON *jsonWriter = [[SBJSON new] autorelease];
	
	NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys: 
														   @"Always Running",@"text",@"http://itsti.me/",@"href", nil], nil];
    
    NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *strLink = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Itunes_Link"]];
	
	//NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
	NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
								@"I hooked up my phone with the GraffitiSprayCan Dash App. Check it. ", @"name",strLink,@"caption",nil];//@"http://itunes.com/elitegudz/",@"href", nil];
	NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   kAppId, @"api_key",
								   @"Share on Facebook",@"user_message_prompt",
								   
								   attachmentStr, @"attachment",
								   nil];	   
	
	
	[_facebook dialog: @"stream.publish"
			andParams: params
		  andDelegate:self];
	
}

- (void)fbDidNotLogin:(BOOL)cancelled {
	//NSLog(@"did not login");
	
	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Unable To Login" 
											  message:nil 
											 delegate:self 
									cancelButtonTitle:@"OK" 
									otherButtonTitles:nil];
	[fb show];
	[fb release];
}

/**
 * Callback for facebook logout
 */ 
-(void) fbDidLogout {
	
		[_facebook release];
	
	
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Callback when a request receives Response
 */ 
- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response{
	
	//NSLog(@"received response  %@",response );
	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Success" 
											  message:@"Your Image Posted" 
											 delegate:self 
									cancelButtonTitle:@"OK" 
									otherButtonTitles:nil];
	[fb show];
	[fb release];
	
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest*)request didFailWithError:(NSError*)error{
	//NSLog(@"%@",error);
	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Unable To Connect" 
											  message:nil 
											 delegate:self 
									cancelButtonTitle:@"OK" 
									otherButtonTitles:nil];
	[fb show];
	[fb release];
	
	[downloadingOverlayView setHidden:TRUE];
}

/**
 * Called when a request returns and its response has been parsed into an object.
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on thee format of the API response.
 */
- (void)request:(FBRequest*)request didLoad:(id)result {
	
	
	
	//NSLog(@"result is ---- %d",result );
	[_facebook logout:self];
	
	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Logged Out" 
											  message:nil 
											 delegate:self 
									cancelButtonTitle:@"OK" 
									otherButtonTitles:nil];
	[fb show];
	[fb release];
}





///////////////////////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/** 
 * Called when a UIServer Dialog successfully return
 */
- (void)dialogDidComplete:(FBDialog*)dialog withPost:(NSString *)currentPostID{
	//NSLog(@"feed to delete and %@ rrrr ", currentPostID);
	//[_facebook logout:self];
	
	UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Message posted successfully" 
											  message:nil 
											 delegate:self 
									cancelButtonTitle:@"OK" 
									otherButtonTitles:nil];
	[fb show];
	[fb release];
}


-(IBAction)emailact{
	
	MFMailComposeViewController *controller= [[MFMailComposeViewController alloc] init];
	
	
	controller.mailComposeDelegate = self;
	
	[controller setSubject:@"I hooked up my phone with the GraffitiSprayCan Dash App. Check it."];
	
	//	UIImage *roboPic = [self getphotofrompaint];//[UIImage imageWithContentsOfFile:dataFilePath];
	//	NSData *imageData = UIImagePNGRepresentation(roboPic);
	// 	[controller addAttachmentData:imageData mimeType:@"image/png" fileName:@"concreteImmortalz.png"];
	NSString *emailBody = @"http://itunes.apple.com/us/artist/alpha-media-group-inc./id393395810";
	[controller setMessageBody:emailBody isHTML:NO]; 
	//UIImage  *img  = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Fol3Image2" ofType:@"jpg"]];
	//NSData *dataObj = UIImageJPEGRepresentation(img, 1.0);
	
	
	//[controller addAttachmentData:dataObj mimeType:@"image/jpg" fileName:@"HDWallpaper"];
	
	if(controller!=nil){
	[self presentModalViewController:(UIViewController*)controller animated:YES];
	}
		//[img release];
	[controller release];
	
	
	
}
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
	[self.view setHidden:FALSE];
	if(result==MFMailComposeResultSent){
		UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Mail Sent" 
												  message:nil 
												 delegate:self 
										cancelButtonTitle:@"OK" 
										otherButtonTitles:nil];
		[fb show];
		[fb release];
	}
	else if(result==MFMailComposeResultCancelled){
		UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Mail Cancelled" 
												  message:nil 
												 delegate:self 
										cancelButtonTitle:@"OK" 
										otherButtonTitles:nil];
		[fb show];
		[fb release];
	}
	else if(result==MFMailComposeResultFailed){
		UIAlertView *fb=[[UIAlertView alloc]initWithTitle:@"Mail Failed" 
												  message:nil 
												 delegate:self 
										cancelButtonTitle:@"OK" 
										otherButtonTitles:nil];
		[fb show];
		[fb release];
	}
	
	
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
*/


//********************************inapppurchase
 
 - (void)requestProUpgradeProductData
 {
     [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
     NSLog(@"Requesting %@ Purchase",self.kInAppPurchaseProUpgradeProductId);
    NSSet *productIdentifiers = [NSSet setWithObject:self.kInAppPurchaseProUpgradeProductId ];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
 
 // we will release the request object in the delegate callback
 }
 
 #pragma mark -
 #pragma mark SKProductsRequestDelegate methods
 
 - (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
 {
     NSArray *products = response.products;
     proUpgradeProduct = [products count] == 1 ? [[products objectAtIndex:0] retain] : nil;
     
     if (proUpgradeProduct)
     {
     NSLog(@"Product title: %@" , proUpgradeProduct.localizedTitle);
     NSLog(@"Product description: %@" , proUpgradeProduct.localizedDescription);
     NSLog(@"Product price: %@" , proUpgradeProduct.price);
     NSLog(@"Product id: %@" , proUpgradeProduct.productIdentifier);
     
     //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"title:%@, desc:%@, price:%@, id:%@",proUpgradeProduct.localizedTitle,proUpgradeProduct.localizedDescription,proUpgradeProduct.price,proUpgradeProduct.productIdentifier] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
     //[alert show]; 
     //[alert release];
     
     if([self canMakePurchases]==YES)
         [self purchaseProUpgrade]; 
     
 
 
 }
 
 for (NSString *invalidProductId in response.invalidProductIdentifiers)
 {
    NSLog(@"Invalid product id: %@" , invalidProductId);

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Unable to purchase the wallpaper pack with id : %@",invalidProductId] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
    [alert show]; 
    [alert release];
    [downloadingOverlayView setHidden:TRUE];
 
 }
 
 // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
 [productsRequest release];
 
 //[[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
 }
 
 
//- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
// {
// 
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"ERROR : %@" , [error description] ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
//    [alert show]; 
//    [alert release];
//    [downloadingOverlayView setHidden:TRUE];
// }
// 

- (void)requestDidFinish:(SKRequest *)request
{
	
	
}



#pragma -
#pragma Public methods

//
// call this method once on startup
//
- (void)loadStore
{
	// restarts any purchases if they were interrupted last time the app was open
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	
	// get the product description (defined in early sections)
	[self requestProUpgradeProductData];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
	return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//
- (void)purchaseProUpgrade
{
	SKPayment *payment = [SKPayment paymentWithProductIdentifier:self.kInAppPurchaseProUpgradeProductId];
	[[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
	if ([transaction.payment.productIdentifier isEqualToString:self.kInAppPurchaseProUpgradeProductId])
	{
		// save the transaction receipt to disk
		[[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceipt" ];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Transaction success : %@",productId] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
	[alert setTag:500];
	[alert show]; 
	[alert release];
	
    if ([productId isEqualToString:self.kInAppPurchaseProUpgradeProductId])
    {
        // enable the pro features
       // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"StorageIsProUpgradePurchased" ];
        //[[NSUserDefaults standardUserDefaults] synchronize];
		//purchasedprd=productId;
		NSString *currentProductID=[productId substringFromIndex:11];
		NSLog(@"product id currentProductID %@",currentProductID);
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		[defaults setInteger: 111 forKey: currentProductID]; //getting the last 52 from "wallpaperpack1052"
		[defaults synchronize];
		//[self updatePurchasedProduct];
        [downloadingOverlayView setHidden:TRUE];
    } 
    
//    NSLog(@"product id content %@",productId);
//	//if ([productId isEqualToString:self.kInAppPurchaseProUpgradeProductId])
//	{
//		// enable the pro features
//		//appDelegate.shouldReloadTableView=TRUE;
//		
//		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isProUpgradePurchased" ];
//		[[NSUserDefaults standardUserDefaults] synchronize];
//		
//		//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Would you like to read the book you just purchased ?"] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil]; 
//		//[alert show]; 
//		//[alert release];
//		
//		
//		@try {
//			
//			
//			//appDelegate.bookPurchased =TRUE;
//			//[NSThread detachNewThreadSelector:@selector(startBookDownloading:) toTarget:self withObject:nil];	
//			
//		}
//		@catch (NSException * e) {
//			
//		}
//		
//		
//		
//		//downloading_Progress = TRUE;
//		
//		
//		
//		
//		
//		//						NSString * setOrderInfoUrl = [NSString stringWithFormat:@"%@/api/read?action=setorderinfo&authKey=%@&bookId=%d",serverIP,appDelegate.loginAuthKey,selectedBookIndex];
//		//						NSURL *url = [[NSURL alloc] initWithString:setOrderInfoUrl];
//		//						NSData *data = [[NSData alloc]initWithContentsOfURL:url];
//		//						
//		//						NSString * str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//		//						if ([str rangeOfString:@"<IsSuccess>1"].location !=NSNotFound) {
//		//							downloading_Progress = FALSE;
//		//						}
//		//						else {
//		//							// There may be problem in purchase  
//		//						}
//		//						
//		//						downloading_Progress = FALSE;
//		
//		
//		NSString *currentProductID=[productId substringFromIndex:11];
//		NSLog(@"product id currentProductID %@",currentProductID);
//		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//		
//		[defaults setInteger: 111 forKey: currentProductID]; //getting the last 52 from "wallpaperpack1052"
//		[defaults synchronize];
//		
//		[downloadingOverlayView setHidden:TRUE];
//		
//		
//	}
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
	// remove the transaction from the payment queue.
	[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
	
	//NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
	if (wasSuccessful)
	{
		// send out a notification that we’ve finished the transaction
		 //   [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
		
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"transaction success " ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
//		[alert show]; 
//		[alert release];
	}
	else
	{
		// send out a notification for the failed transaction
		//  [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Transaction failed : %@", transaction.payment.productIdentifier ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		//[alert show]; 
		[alert release];
		
	}
	[downloadingOverlayView setHidden:TRUE];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"complete transaction");
	[self recordTransaction:transaction];
	[self provideContent:transaction.payment.productIdentifier];
	[self finishTransaction:transaction wasSuccessful:YES];
	[downloadingOverlayView setHidden:TRUE];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"restore transaction");
	[self recordTransaction:transaction.originalTransaction];
	[self provideContent:transaction.originalTransaction.payment.productIdentifier];
	[self finishTransaction:transaction wasSuccessful:YES];
	[downloadingOverlayView setHidden:TRUE];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
	if (transaction.error.code != SKErrorPaymentCancelled)
	{
		// error!
		[self finishTransaction:transaction wasSuccessful:NO];
	}
	else
	{
		// this is fine, the user just cancelled, so don’t notify
		[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
	}
	[downloadingOverlayView setHidden:TRUE];
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSLog(@"trans   %@",transactions);
	for (SKPaymentTransaction *transaction in transactions)
	{
		
		//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"transaction state: %d",transaction.transactionState ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		//	[alert show]; 
		//	[alert release];
		
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
				[self completeTransaction:transaction];
				break;
			case SKPaymentTransactionStateFailed:
				[self failedTransaction:transaction];
				break;
			case SKPaymentTransactionStateRestored:
				[self restoreTransaction:transaction];
				break;
			default:
				break;
		}
	}
}

// Sent when transactions are removed from the queue (via finishTransaction:).
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    NSLog(@"removedTransactions");
	
}

// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
	NSLog(@"restoreCompletedTransactionsFailedWithError");
}

// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue 
{
	NSLog(@"paymentQueueRestoreCompletedTransactionsFinished");
}

@end


