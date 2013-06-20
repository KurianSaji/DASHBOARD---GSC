//
//  customButton.h
//  maximSocialVideo
//
//  Created by neo on 29/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface UIButton (CS_Extention)


-(void)setCusLable:(NSString*)text;

-(void)setCusImage:(UIImage*)image initWithFrame:(CGRect)frame;

-(void)setCusLable:(NSString *)text initWithFrame:(CGRect)frame bgColor:(UIColor*)bgColor;


@end
