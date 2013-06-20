//
//  MyContentView.m
//  ClassicalScroll
//
//  Created by pradeep on 7/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyContentView1.h"


@implementation MyContentView1


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        [self setBackgroundColor:[UIColor blackColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code - This will be called with different bounds at the end of each
    // tap/pinch zoom operation.
    // For illustration, I'm scaling so that a '1' glyph fills the area.
	
    // context
   // CGContextRef context = UIGraphicsGetCurrentContext();
	
    // Fill view with a 20-point '1'
  //  UIFont * f = [UIFont systemFontOfSize:20];
    [[UIColor blackColor] set];
    
    // get bounds
   // CGRect b = [self bounds];
    
/**********    // draw a string
    NSString * text = @"Yogi";
    CGSize sz = [text sizeWithFont:f];
	
    // scale to bounds / text size
    CGContextScaleCTM(context, b.size.width/sz.width, b.size.height/sz.height);
    *************/
    // draw
	
    //[text drawAtPoint:CGPointMake(0,0) withFont:f];
	
	
}

// look for double taps
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // get any touch
    UITouch * t = [touches anyObject];
    if( [t tapCount]>1 )
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObject:event forKey:@"event"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DoubleTapZoom" 
                                                            object:[self superview]
                                                          userInfo:dict];
    }
	if( [t tapCount]==1 )
    {
        NSDictionary *dict1 = [NSDictionary dictionaryWithObject:event forKey:@"event"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SingleTapZoom" 
                                                            object:[self superview]
                                                          userInfo:dict1];
    }
}

- (void)dealloc {
    [super dealloc];
}



@end
