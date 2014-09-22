//
//  Collision.h
//  LaserPool
//
//  Created by Spencer Whyte on 2014-08-02.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector.h"
#import "Point2D.h"

@interface Collision : NSObject

@property Vector2D * computedNextPath;
@property Point2D * pointOfCollision;
@property NSObject * object;


@end
