//
//  Vector.m
//  LaserPool
//
//  Created by Spencer Whyte on 2014-08-02.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "Vector2D.h"

@implementation Vector2D


-(id)initWithX:(double)x andY:(double)y andDX:(double)dx andDY:(double)dy{
    
    if(self = [super init]){
        
        self.x = x;
        self.y = y;
        
        self.dx = dx;
        self.dy = dy;
        
    }
    return self;
}

@end
