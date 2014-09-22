//
//  Cue.m
//  LaserPool
//
//  Created by Spencer Whyte on 2014-07-25.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "Cue.h"

@implementation Cue

-(id)init{
    if(self = [super init]){
        self.x1 = -400;
        self.y1 = -400;
        
        self.x2 = 200;
        self.y2 = 400;
    }
    return self;
}

// Updates the position of the cue by looking at the current scene
// We must know the position of the six pockets
-(void)updatePosition:(UIImage *)currentFrame onPoolTable:(PoolTable *)poolTable{
    
}




@end
