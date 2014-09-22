//
//  Cue.h
//  LaserPool
//
//  Created by Spencer Whyte on 2014-07-25.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoolTable.h"

@class PoolTable;
@interface Cue : NSObject

// Normalized positions
@property double x1;
@property double y1;

@property double x2;
@property double y2;

-(void)updatePosition:(UIImage *)currentFrame onPoolTable:(PoolTable*)poolTable;

@end
