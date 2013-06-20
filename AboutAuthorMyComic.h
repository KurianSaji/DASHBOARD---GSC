//
//  AboutAuthorMyComic.h
//  Comic Store
//
//  Created by Zaah Technologies India PVT on 10/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthorXmlParser.h"

@interface AboutAuthorMyComic : UIViewController {
	
	IBOutlet UIScrollView *scrollview_comic;
	IBOutlet UIView *MainView;
	IBOutlet UILabel *AuthorNameLab;
	IBOutlet UILabel *AuthorDescriptionLab;
	IBOutlet UIImageView *AuthorImageView;
	
}

@property (nonatomic,retain) UIScrollView *scrollview_comic;
@property (nonatomic,retain) UIView *MainView;
@property (nonatomic,retain) UILabel *AuthorNameLab;
@property (nonatomic,retain) UILabel *AuthorDescriptionLab;
@property (nonatomic,retain) UIImageView *AuthorImageView;
-(void)LoadAuthorBookView;
-(void)Load:(AuthorXmlParser *)authorXmlParserObj;
-(IBAction)closeMe;

@end
