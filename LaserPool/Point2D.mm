//
//  Point2D.m
//  LaserPool
//
//  Created by Spencer Whyte on 2014-08-02.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "Point2D.h"

@implementation Point2D

-(id)initWithX:(double)x andY:(double)y{
    if(self = [super init]){
        
        self.x = x;
        self.y = y;
        
    }
    return self;
}


@end
