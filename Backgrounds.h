//
//  Backgrounds.h
//  DashBoard
//
//  Created by Zaah Technologies on 09/07/11.
//  Copyright 2011 Zaah. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDLoopDemoViewController;
@interface Backgrounds : UIViewController {
HDLoopDemoViewController *hdWall;
}
@property (nonatomic,retain) HDLoopDemoViewController *hdWall;
-(void) doRelease;
@end
