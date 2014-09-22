//
//  CueBall.m
//  LaserPool
//
//  Created by Spencer Whyte on 2014-07-25.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "CueBall.h"

@implementation CueBall

-(id)init{
    if(self = [super initWithColor:[UIColor whiteColor]]){
        self.x = 500.0;
        self.y = 500.0;
    }
    return self;
}


@end
