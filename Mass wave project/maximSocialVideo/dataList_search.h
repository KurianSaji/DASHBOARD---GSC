//
//  dataList_search.h
//  maximSocialVideo
//
//  Created by neo on 10/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h> 
#import "epubstore_svcAppDelegate.h"

#import "photoButton.h"

#import "XMLReader.h"


typedef struct cellDatas
{

    UIImage *cellImage;
    NSString *cellTitle;
    NSString *cellSubTitle;
    int isSelected;
    UIImage *cellBackground;
}cellDatas;




@interface dataList_search : UIView <UITableViewDelegate,UITableViewDataSource>
{
     
    UIImageView *backgroundImageView;

    
}

@property(nonatomic,retain)NSDictionary *friendsList;

@property (nonatomic, retain)UIButton *btnSelectImage;

@property (nonatomic, retain)UIButton *btnUnSelectImage;

@property (nonatomic, retain)UITableView *aTableView; 

@property (nonatomic, retain)UILabel *nameLabel;

@property (assign)BOOL isSingleSelection;

@property (assign)BOOL searching; 



-(void)fetchFriendsList;

@end



