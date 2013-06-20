//
//  AboutAuthorMyComic.m
//  iPadApp
//
//  Created by partha neo on 7/24/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "AboutAuthorMyComic.h"
#import "AuthorBookDetails.h"
#import "AuthorXmlParser.h"
#import "epubstore_svcAppDelegate.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]


@implementation AboutAuthorMyComic


NSInteger comicID =0;

epubstore_svcAppDelegate *appDelegate;
AuthorXmlParser *authorXmlObj;

@synthesize scrollview_comic;
@synthesize AuthorNameLab;
@synthesize AuthorDescriptionLab;
@synthesize AuthorImageView;
@synthesize MainView;



-(id)init
{
	if(self = [super init])
	{
		
	}
    return self;
}
-(void)Load:(AuthorXmlParser *)authorXmlParserObj{
	//[self initWithFrame:CGRectMake(0,0,768,1024)];
	appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
	//ISBNNumber =[NSString stringWithFormat:@"%@",Isbn];
	authorXmlObj= authorXmlParserObj;
	[authorXmlObj retain];
	[self LoadAuthorBookView];
}
	

-(void)LoadAuthorBookView
{
	AuthorNameLab.text = authorXmlObj.Name;
	AuthorDescriptionLab.text =  authorXmlObj.Description;
	NSString *myurl = authorXmlObj.Photo ;
	
	if (myurl!=nil) {
		NSString *imageName = [myurl lastPathComponent];
		NSString * fileName  = [NSString stringWithFormat:@"/Author%@",imageName];
		UIImage *img ;
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *docDirectory = [paths objectAtIndex:0];
		if(![appDelegate checkFileExist:fileName])
		{
			NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:myurl]];
			img = [[UIImage alloc] initWithData:imageData];
			if (img==nil) {
				NSData *imageData =  [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"no_image" ofType:@"png"]];
				img = [[UIImage alloc] initWithData:imageData];
				imageName=@"NoImage";
			}
		}
		else {
			NSData *imageData = [[NSData alloc] initWithContentsOfFile:myurl];
			img = [[UIImage alloc] initWithData:imageData];
		}
		NSString *dataFilePath = [[docDirectory stringByAppendingPathComponent:fileName]retain];
		
		[appDelegate saveImage :img withName:dataFilePath];
		AuthorImageView.image = img;
	}
	else {
		AuthorImageView.image = [UIImage imageNamed:[[NSBundle mainBundle]pathForResource:@"no_image" ofType:@"png"]];
	}
	
	
	
	//Load Books Written By this Author .
	if ([authorXmlObj.authorBookDetArray count]>0) {
		for (int k=0; k<[authorXmlObj.authorBookDetArray count]; k++) {
			AuthorBookDetails *autherBkDet = [authorXmlObj.authorBookDetArray objectAtIndex:k];
			int j=k+1;
			[autherBkDet retain];
			
			UILabel *BookNameLab = [[UILabel alloc]initWithFrame:CGRectMake(j*84, j*5, 174, 23)];
			BookNameLab.text = autherBkDet.Name;
			[BookNameLab setBackgroundColor:[UIColor clearColor]];
			[BookNameLab setTextColor:[UIColor redColor]];
			[scrollview_comic addSubview:BookNameLab];
			[BookNameLab release];
			
			UILabel * BookDescriptionLab = [[UILabel alloc]initWithFrame:CGRectMake(j*90, j*36, 162,106)];
			BookDescriptionLab.text = autherBkDet.Description;
			[BookDescriptionLab setBackgroundColor:[UIColor clearColor]];
		    [scrollview_comic addSubview:BookDescriptionLab];
			[BookDescriptionLab release];
			
			UIImageView *BookImageView = [[UIImageView alloc]initWithFrame:CGRectMake(j*7, j*33, 75,115)];
			
			BookImageView.image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"NotAvilable.png"]] ];
			BookImageView.tag = k+1;
		    [scrollview_comic addSubview:BookImageView];
			//[BookImageView release];
			
			UILabel * BorderLab = [[UILabel alloc]initWithFrame:CGRectMake(0, j*150, 273,1)];
			BorderLab.text = @"";
			[BorderLab setBackgroundColor:[UIColor blackColor]];
		    [scrollview_comic addSubview:BorderLab];
			[BorderLab release];
			
			NSString *imageName = [autherBkDet.CoverPhoto lastPathComponent];
			NSString * fileName  = [NSString stringWithFormat:@"/%@/AuthorRela_%@",autherBkDet.ISBNNumber,imageName];
			
			if(![appDelegate checkFileExist:fileName])
			{
				//Start Thread >>>>
				NSString * str = [NSString stringWithFormat:@"%d",k];
				[NSThread detachNewThreadSelector:@selector(DownloadBookImages:) toTarget:self withObject:str];
				
			}
			else {
				NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *documentsDirectory = [paths objectAtIndex:0];
				NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:fileName] retain];
				BookImageView.image = [UIImage imageWithContentsOfFile:dataFilePath];
			}
			[BookImageView release]; 				   
		}
		
	}
	
}

-(void)DownloadBookImages:(NSString *)indx
{
	int index = [indx intValue];
	AuthorBookDetails *autherBkDet = [authorXmlObj.authorBookDetArray objectAtIndex:index];
	NSString *myurl =autherBkDet.CoverPhoto;
	int myTag=index+1;
	[autherBkDet retain];
	NSString *imageName = [myurl lastPathComponent];
	
	NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:myurl]];
	UIImage *img = [[UIImage alloc] initWithData:imageData];
	
	if (img==nil) {
		
		NSData *imageData =  [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"no_image" ofType:@"png"]];
		img = [[UIImage alloc] initWithData:imageData];
	    imageName = @"NoImage";
	}
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString * fileName  = [NSString stringWithFormat:@"/%@/AuthorRela_%@",autherBkDet.ISBNNumber,imageName];
	
	[appDelegate saveImage :img withName:[documentsDirectory stringByAppendingPathComponent:fileName]];
	UIImageView *BookImageView =(UIImageView *)[scrollview_comic viewWithTag:myTag];
	BookImageView.image = img;
	
}


- (void)dealloc {
	[scrollview_comic release];
	
    [super dealloc];
}
-(IBAction)closeMe
{
	[self.view setHidden:TRUE];
}


@end

