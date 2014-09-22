//
//  PoolTable.h
//  LaserPool
//
//  Created by Spencer Whyte on 2014-07-25.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CueBall.h"
#import "Cue.h"
#import "Ball.h"
#import "Collision.h"


@class Cue;


@interface PoolTable : NSObject

@property Cue * activeCue;
@property CueBall * cueBall;

@property NSMutableArray * balls;

// Normalized positions

// Top left corner
@property double x1;
@property double y1;

// Bottom right corner
@property double x2;
@property double y2;

-(NSArray*)computeCueBallPath;

@end
