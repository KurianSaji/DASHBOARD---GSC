//
//  MyContentView.h
//  epubstore_svc
//
//  Created by Zaah Technologies India PVT on 10/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyContentView : UIView {
	CGFloat kMaximumVariance,kMinimumGestureLength;
	CGPoint gestureStartPoint;
}

@end
