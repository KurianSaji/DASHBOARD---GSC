//
//  avloader.m
//  maximSocialVideo
//
//  Created by neo on 09/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "avloader.h"

@implementation avloader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}

-(void)initLoaderWithSize:(CGSize)loaderSize
{
    
    int curSW = [[UIScreen mainScreen] bounds].size.width;
    int curSH = [[UIScreen mainScreen] bounds].size.height;
    
    UIView *vl_MainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, loaderSize.width , loaderSize.height)];
    vl_MainView.backgroundColor = [UIColor blackColor];
    
    vl_MainView.layer.cornerRadius = 10.0;
    
    [self addSubview:vl_MainView];
    vl_MainView.center = self.center;
    
     
    
    UIActivityIndicatorView *avLoader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
   	avLoader.center=CGPointMake((loaderSize.width/2), (loaderSize.height/2));
    [vl_MainView  addSubview:avLoader];
    
    [avLoader startAnimating];
    
    
    UILabel *lblLoading = [[UILabel alloc] initWithFrame:CGRectMake((70/320)*curSW, 0, loaderSize.width, (20/480)*curSH)];
    
    lblLoading.font = [UIFont boldSystemFontOfSize:15];
    lblLoading.textColor=[UIColor whiteColor];
	lblLoading.backgroundColor=[UIColor clearColor];
	lblLoading.text=@"Loading...";
	[vl_MainView addSubview:lblLoading]; 
	
    lblLoading.layer.borderColor = [UIColor greenColor].CGColor;
    lblLoading.layer.borderWidth = 1.0;
    
    [lblLoading release];
    
    [vl_MainView release];
    
    [avLoader release];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
