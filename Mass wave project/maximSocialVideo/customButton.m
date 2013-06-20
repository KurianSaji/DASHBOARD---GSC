//
//  customButton.m
//  maximSocialVideo
//
//  Created by neo on 29/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "customButton.h"

@implementation UIButton (CS_Extention)


-(void)setCusLable:(NSString*)text
{
    
    ///
    /*
     UILabel *cusLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width ,self.frame.size.height)];
     
     cusLable.text = text;
     cusLable.textAlignment = UITextAlignmentCenter;
     cusLable.backgroundColor = [UIColor clearColor];
     
     
     [self addSubview:cusLable];
     
     */
    
    
    
    
}


-(void)setCusImage:(UIImage*)image initWithFrame:(CGRect)frame
{
    
    ///
    /*
     UILabel *cusLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width ,self.frame.size.height)];
     
     cusLable.text = text;
     cusLable.textAlignment = UITextAlignmentCenter;
     cusLable.backgroundColor = [UIColor clearColor];
     
     
     [self addSubview:cusLable];
     
     */
    
    
    UIImageView *cusImageView = [[UIImageView alloc]initWithFrame:frame];
    cusImageView.image  = image ; 
    [self addSubview:cusImageView];
    
    
    
}


-(void)setCusLable:(NSString *)text initWithFrame:(CGRect)frame bgColor:(UIColor*)bgColor
{


    UILabel *customLabel = [[UILabel alloc] initWithFrame:frame];
    customLabel.backgroundColor = bgColor;
    [self addSubview:customLabel];


}


@end
