//
//  MyContentView.m
//  epubstore_svc
//
//  Created by Zaah Technologies India PVT on 10/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyContentView.h"

@implementation MyContentView



- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		kMaximumVariance = 250;
		kMinimumGestureLength = 0.5;
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code - This will be called with different bounds at the end of each
    // tap/pinch zoom operation.
    // For illustration, I'm scaling so that a '1' glyph fills the area.
	
   // // context
//    CGContextRef context = UIGraphicsGetCurrentContext();
//	
//    // Fill view with a 20-point '1'
//    UIFont * f = [UIFont systemFontOfSize:20];
//    [[UIColor darkGrayColor] set];
//    
//    // get bounds
//    CGRect b = [self bounds];
//    
//    // draw a string
//    NSString * text = @"1";
//    CGSize sz = [text sizeWithFont:f];
//	
//    // scale to bounds / text size
//    CGContextScaleCTM(context, b.size.width/sz.width, b.size.height/sz.height);
    
    // draw
   // [text drawAtPoint:CGPointMake(0,0) withFont:f];
}

// look for double taps




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	gestureStartPoint = [touch locationInView:self];
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint currentPosition = [touch locationInView:self];
	
	CGFloat deltaX = fabsf(gestureStartPoint.x - currentPosition.x);
	CGFloat deltaY = fabsf(gestureStartPoint.y - currentPosition.y);
	
	// left gesture
	if (gestureStartPoint.x > currentPosition.x && deltaY <= kMaximumVariance && deltaX >= kMinimumGestureLength) {
		NSDictionary *dict = [NSDictionary dictionaryWithObject:event forKey:@"event"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"ToPrevious" 
															object:[self superview]
														  userInfo:dict];
	}
	// right gesture
	else if (gestureStartPoint.x < currentPosition.x && deltaY <= kMaximumVariance && deltaX >= kMinimumGestureLength) {
		NSDictionary *dict = [NSDictionary dictionaryWithObject:event forKey:@"event"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"ToNext" 
															object:[self superview]
														  userInfo:dict];
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


- (void)dealloc {
    [super dealloc];
}

@end

