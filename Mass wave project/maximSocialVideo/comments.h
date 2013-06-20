//
//  comments.h
//  maximSocialVideo
//
//  Created by neo on 20/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h> 
#import "photoButton.h"

@protocol mediadetailDel

-(void)goToUserVideos:(NSString*)commentUserId;

@end


@interface comments : UIView
{

    int commentCount;
    
    NSArray *commentArray;
    
    UITableView *aTableView;
    
    
    BOOL tableLoaded;
    
    NSMutableArray *searchPath;
    

}

@property(assign)id<mediadetailDel>_delegate;

@property(nonatomic, retain)UITableView *aTableView;

@property(nonatomic, retain)NSArray *commentArray;

@property(assign)int commentCount;

@property(nonatomic, retain)NSMutableArray *searchPath;


-(void)initcommentsView;

-(void)reloadTableView;

@end
