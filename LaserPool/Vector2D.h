//
//  Vector.h
//  LaserPool
//
//  Created by Spencer Whyte on 2014-08-02.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vector2D : NSObject

// Position of the center of the object
@property double x;
@property double y;
// The change in position, pixels per sec
@property double dx;
@property double dy;

-(id)initWithX:(double)x andY:(double)y andDX:(double)dx andDY:(double)dy;

@end
