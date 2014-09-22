//
//  Ball.h
//  LaserPool
//
//  Created by Spencer Whyte on 2014-07-25.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PoolTable;

@interface Ball : NSObject

@property UIColor * color;

@property int number;

@property double x;
@property double y;
@property double radius;
@property BOOL isStriped;
@property BOOL isOnTheTable;

@property double certainty; // Normalized certainty, how sure are we that the ball is at this position?


-(id)initWithColor:(UIColor*)ballColor;
-(void)updatePosition:(UIImage *)currentFrame onPoolTable:(PoolTable*)poolTable;

@end
