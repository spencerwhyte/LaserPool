//
//  Ball.m
//  LaserPool
//
//  Created by Spencer Whyte on 2014-07-25.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "Ball.h"

#import "PoolTable.h"

@implementation Ball

-(id)initWithColor:(UIColor*)ballColor{
    if(self == [super init]){
        self.color = ballColor;
        self.x = (rand()/(double)RAND_MAX)*1109.0;
        self.y = (rand()/(double)RAND_MAX)*1883.0;
        self.radius = 50;
        self.isOnTheTable = YES;
        NSLog(@"%f %f", self.x, self.y);
    }
    return self;
}


-(void)updatePosition:(UIImage *)currentFrame onPoolTable:(PoolTable*)poolTable{
    
}


@end
