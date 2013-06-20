//
//  MyCustomButton.m
//  epubStore
//
//  Created by partha neo on 8/31/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "MyCustomButton.h"

@implementation MyCustomButton

@synthesize index;

-(id)initWithIndex:(NSInteger) aIndex
{
	if(self = [super init])
	{
		index = aIndex;
	}
	return self;
}

@end
