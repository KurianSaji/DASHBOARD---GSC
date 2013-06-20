//
//  AlarmSettings.h
//  Alarm
//
//  Created by Zaah Technologies India PVT on 12/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AlarmSettings : NSObject {

	int ID;
	BOOL repeat;
	NSDate *alarmFireDate;
}
@property(nonatomic,assign)int ID;
@property(nonatomic,assign)BOOL repeat;
@property(nonatomic,retain)NSDate *alarmFireDate;
@end
