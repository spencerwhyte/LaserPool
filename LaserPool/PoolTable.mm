//
//  PoolTable.m
//  LaserPool
//
//  Created by Spencer Whyte on 2014-07-25.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "PoolTable.h"



@implementation PoolTable

-(id)init{
    if(self = [super init]){
        
        self.x1 = 0.0f;
        self.y1= 0.0f;
        
        self.x2= 1109.0;
        self.y2= 1883.0f;
        
        Cue * theActiveCue = [[Cue alloc] init];
        self.activeCue = theActiveCue;
        
        self.balls = [[NSMutableArray alloc] init];
        
        CueBall * cueBall = [[CueBall alloc] init];
        self.cueBall = cueBall;
        [self.balls addObject:cueBall];
        
        NSArray * colors = @[
                             [UIColor colorWithRed:233/255.0 green:194/255.0 blue:46/255.0 alpha:1], // one - solids - yellow
                             [UIColor colorWithRed:20/255.0 green:34/255.0 blue:82/255.0 alpha:1], // two - solids - blue
                             [UIColor colorWithRed:218/255.0 green:0 blue:13/255.0 alpha:1], // three - solids - red
                             [UIColor colorWithRed:40/255.0 green:7/255.0 blue:59/255.0 alpha:1], // four - solids - purple
                             [UIColor colorWithRed:230/255.0 green:81/255.0 blue:29/255.0 alpha:1], // five - solids - orange
                             [UIColor colorWithRed:19/255.0 green:65/255.0 blue:56/255.0 alpha:1], // six - solids - green
                             [UIColor colorWithRed:124/255.0 green:20/255.0 blue:30/255.0 alpha:1], // seven - solids - maroon
                             [UIColor colorWithRed:0 green:0 blue:0 alpha:1], // eight - neutral/solid - black
                             [UIColor colorWithRed:233/255.0 green:194/255.0 blue:46/255.0 alpha:1], // nine - striped - yellow
                             [UIColor colorWithRed:20/255.0 green:34/255.0 blue:82/255.0 alpha:1], // ten - striped - blue
                             [UIColor colorWithRed:218/255.0 green:0 blue:13/255.0 alpha:1], // eleven - striped -red
                             [UIColor colorWithRed:40/255.0 green:7/255.0 blue:59/255.0 alpha:1], // twelve - striped - purple
                             [UIColor colorWithRed:230/255.0 green:81/255.0 blue:29/255.0 alpha:1], // thirteen - striped - orange
                             [UIColor colorWithRed:19/255.0 green:65/255.0 blue:56/255.0 alpha:1], // fourteen - striped - green
                             [UIColor colorWithRed:124/255.0 green:20/255.0 blue:30/255.0 alpha:1] // fifteen - striped - maroon
                             ];
        
        for(int i = 1 ; i <= 15; i++){
            Ball * b = [[Ball alloc] initWithColor:[colors objectAtIndex:i-1]];
            [self.balls addObject:b];
            if(i > 8){
                b.isStriped = YES;
            }
            b.number = i;
        }
        
        
    }
    return self;
}


-(void)updatePosition:(UIImage *)currentFrame {
    for(Ball * b in self.balls){
        [b updatePosition:currentFrame onPoolTable:self];
    }
    [self.activeCue updatePosition:currentFrame onPoolTable:self];
    
}

-(Collision*)computeNextCollisionFromVector:(Vector *)v{
    Collision * c = nil;
    
    // It either hits the cue ball, a regular ball, or the sides of the pool table
    Ball * hitBall = nil;
    
    // Look through the balls first
    CGFloat shortestDistanceToCollision = 2*(self.y2-self.y1);
    CGPoint bestPoint = CGPointMake(1, 1);
    CGPoint ballPoint= CGPointMake(1, 1);
    
    
    // Compute the slope of the cue path
    // Rise / Run
    CGFloat cueSlope = v.dy / v.dx;
    
    // Compute the Y-intercept of the cue path
    // y = mx + b
    // b = y - mx
    CGFloat cueB = v.y - cueSlope * v.x;
    
    
    for(Ball * b in self.balls){
        
        // The perpendicular line that runs through a ball and intersects the cue path will have slope equal to the negative reciprocol of the cue slope
        // -1/slope
        CGFloat intersectionSlope = -1 / cueSlope;
        // Compute the Y-intercept of the intersection line
        // y = mx + b
        // b = y - mx
        // The ball must lie on the intersection line
        CGFloat intersectionB = b.y - intersectionSlope * b.x;
        
        
        // Compute the intersection point between the two lines
        // m1 * x + b1 = m2 * x + b2
        // m1 * x - m2 * x =  b2 - b1
        // x =  (b2 - b1) / (m1 - m2)
        
        CGFloat intersectionX = (intersectionB - cueB)/(cueSlope - intersectionSlope);
        CGFloat intersectionY = intersectionSlope * intersectionX + intersectionB;
        
        // Compute the distance from the point to the ball
        CGFloat xDist = intersectionX-b.x;
        CGFloat yDist = intersectionY-b.y;
        CGFloat distance = sqrtf(xDist * xDist + yDist * yDist);
        
        if(distance < shortestDistanceToCollision){ // If this ball is closer to being hit than any of the other balls
            if(distance <= b.radius){ // If where we are going to strike on the ball is actually within the bounds of the ball
                
                if( ((v.dx < 0 && b.x <= v.x) || (v.dx > 0  && b.x >= v.x)) && ((v.dy < 0 && b.y <= v.y) || (v.dy > 0  && b.y >= v.y))){ // If the ball is actualy in front of the head of the cue
                    
                    if(!(v.x == b.x && v.y == b.y)){ // Make sure that we arent just colliding with ourselves!
                        hitBall = b; // Take note that we have actually been successful at hitting the ball
                        shortestDistanceToCollision = distance;
                        bestPoint = CGPointMake(intersectionX, intersectionY);
                        ballPoint = CGPointMake(b.x, b.y);
                        
                        // Compute the point on the ball where the cue path strikes
                    }
                }
                
            }
            
            
        }
        
    }
    
    if(hitBall){ // If we have actually hit a ball
        
        c = [[Collision alloc] init];
        
        NSLog(@"We hit a ball on the second round: %f %f", ballPoint.x, ballPoint.y);
        //[path addObject:[NSValue valueWithCGPoint:bestPoint]];
        
        c.object = hitBall;
        
        c.pointOfCollision = [[Point2D alloc] initWithX:ballPoint.x andY:ballPoint.y];
        
        NSLog(@"We hit a ball on the second round: %f %f", c.pointOfCollision.x, c.pointOfCollision.y);
        
        
        // If we have hit the cueball
        if(hitBall.number == 0){
            // This is terrible
           
          
            
            
        }
        
        
        
    }else{
        c = [[Collision alloc] init];
        
        //y = mx + b
        //y - b = mx
        //x = (y-b)/m
        //y = 0.0f
        //x=-b/m
        
        // Check for the intersection between the cue path and the left wall
        if(cueB >= self.y1 && cueB <= self.y2 && v.dx < 0){ // The cue will collide with the left edge at cueB, but is that within the bounds of the pool table
            //NSLog(@"%f %f %f %f %f", cueB, self.x1, self.x2, self.activeCue.x2, self.activeCue.x1);
            
            NSLog(@"CAse 1");
            
            c.pointOfCollision = [[Point2D alloc] initWithX:self.x1 andY:cueB];
            
        }else if(cueSlope * self.x1 + cueB >=self.y1 && cueSlope * self.x2 + cueB <= self.y2 && v.dx > 0){ // The cue will collide with the right edge at a point that is calculatable from the eqn of a line
                        NSLog(@"CAse 2");
            
            c.pointOfCollision = [[Point2D alloc]initWithX:self.x2  andY: cueSlope * self.x2 + cueB];
            
           
        }else if((self.y1- cueB) / cueSlope >= self.x1 && (self.y1 - cueB) / cueSlope <= self.x2 && v.dy < 0){ // The cue will collide with the top edge at a point that is calculatable from the eqn of a line
                        NSLog(@"CAse 3");
            
            c.pointOfCollision = [[Point2D alloc]initWithX:(self.y1 - cueB) / cueSlope andY: self.y1];
            
        }else if((self.y2 - cueB) / cueSlope >= self.x1 && (self.y2 - cueB) / cueSlope <= self.x2 && v.dy > 0){
            
                        NSLog(@"CAse 4");
            
            c.pointOfCollision = [[Point2D alloc]initWithX:(self.y2 - cueB) / cueSlope andY: self.y2];

        }else{
            // WTF IS GOING ON?????
        }
        
    }
    
    
    return c;
}

// Array of points describing the path of the cue + pool ball
-(NSArray*)computeCueBallPath{
    NSMutableArray * path =[NSMutableArray array];
    
    // Start at the tip of the cue
    [path addObject:[NSValue valueWithCGPoint:CGPointMake(self.activeCue.x2, self.activeCue.y2)]];
    
    // Determine what they are going to hit with their cue
    
    // It either hits the cue ball, a regular ball, or the sides of the pool table
    Ball * hitBall = nil;
    
    // Look through the balls first
    CGFloat shortestDistanceToCollision = 2*(self.y2-self.y1);
    CGPoint bestPoint = CGPointMake(1, 1);
    CGPoint ballPoint= CGPointMake(1, 1);
    
    
    // Compute the slope of the cue path
    // Rise / Run
    CGFloat cueSlope = (self.activeCue.y2 - self.activeCue.y1) / (self.activeCue.x2 - self.activeCue.x1);
    
    // Compute the Y-intercept of the cue path
    // y = mx + b
    // b = y - mx
    CGFloat cueB = self.activeCue.y2 - cueSlope * self.activeCue.x2;
    
    
    for(Ball * b in self.balls){
        
        // The perpendicular line that runs through a ball and intersects the cue path will have slope equal to the negative reciprocol of the cue slope
        // -1/slope
        CGFloat intersectionSlope = -1 / cueSlope;
        // Compute the Y-intercept of the intersection line
        // y = mx + b
        // b = y - mx
        // The ball must lie on the intersection line
        CGFloat intersectionB = b.y - intersectionSlope * b.x;
        
        
        // Compute the intersection point between the two lines
        // m1 * x + b1 = m2 * x + b2
        // m1 * x - m2 * x =  b2 - b1
        // x =  (b2 - b1) / (m1 - m2)
        
        CGFloat intersectionX = (intersectionB - cueB)/(cueSlope - intersectionSlope);
        CGFloat intersectionY = intersectionSlope * intersectionX + intersectionB;
        
        // Compute the distance from the point to the ball
        CGFloat xDist = intersectionX-b.x;
        CGFloat yDist = intersectionY-b.y;
        CGFloat distance = sqrtf(xDist * xDist + yDist * yDist);
        
        if(distance < shortestDistanceToCollision){ // If this ball is closer to being hit than any of the other balls
            if(distance <= b.radius){ // If where we are going to strike on the ball is actually within the bounds of the ball
                
                if( ((self.activeCue.x1 > self.activeCue.x2 && b.x <= self.activeCue.x2) || (self.activeCue.x2 > self.activeCue.x1  && b.x >= self.activeCue.x2)) && ((self.activeCue.y1 > self.activeCue.y2 && b.y <= self.activeCue.y2) || (self.activeCue.y2 > self.activeCue.y1  && b.y >= self.activeCue.y2))){ // If the ball is actualy in front of the head of the cue
                    
                    hitBall = b; // Take note that we have actually been successful at hitting the ball
                    shortestDistanceToCollision = distance;
                    bestPoint = CGPointMake(intersectionX, intersectionY);
                    ballPoint = CGPointMake(b.x, b.y);
                    
                    // Compute the point on the ball where the cue path strikes
                    
                    
                }
                
            }
            
            
        }
        
    }
    
    if(hitBall){ // If we have actually hit a ball
        
        
        NSLog(@"X: %f Y:%f D:%f", bestPoint.x, bestPoint.y, shortestDistanceToCollision);
        [path addObject:[NSValue valueWithCGPoint:bestPoint]];
        //[path addObject:[NSValue valueWithCGPoint:ballPoint]];
        
        // If we have hit the cueball
        //if(hitBall.number == 0){
        
        
        
            Vector * cueBallDirection = [[Vector alloc] initWithX:hitBall.x andY:hitBall.y andDX:(self.activeCue.x2 - self.activeCue.x1) andDY:(self.activeCue.y2 - self.activeCue.y1)];
            // Compute where the cue ball is going to go next
            Collision * c = [self computeNextCollisionFromVector:cueBallDirection];
            [path addObject: [NSValue valueWithCGPoint:CGPointMake(c.pointOfCollision.x, c.pointOfCollision.y)]];
            NSLog(@"CONFIRMING POINT OF COLLISION: %f %f", c.pointOfCollision.x,c.pointOfCollision.y);
        
        //}
        
        
        
    }else{
        //y = mx + b
        //y - b = mx
        //x = (y-b)/m
        //y = 0.0f
        //x=-b/m
        
        // Check for the intersection between the cue path and the left wall
        if(cueB >= self.y1 && cueB <= self.y2 && self.activeCue.x2 <= self.activeCue.x1){ // The cue will collide with the left edge at cueB, but is that within the bounds of the pool table
            NSLog(@"%f %f %f %f %f", cueB, self.x1, self.x2, self.activeCue.x2, self.activeCue.x1);
            [path addObject:[NSValue valueWithCGPoint:CGPointMake(self.x1, cueB)]];
        }else if(cueSlope * self.x1 + cueB >=self.y1 && cueSlope * self.x2 + cueB <= self.y2 && self.activeCue.x2 >= self.activeCue.x1){ // The cue will collide with the right edge at a point that is calculatable from the eqn of a line
            
            [path addObject:[NSValue valueWithCGPoint:CGPointMake(self.x2, cueSlope * self.x2 + cueB)]];
        }else if((self.y1- cueB) / cueSlope >= self.x1 && (self.y1 - cueB) / cueSlope <= self.x2 && self.activeCue.y2 <= self.activeCue.y1){ // The cue will collide with the top edge at a point that is calculatable from the eqn of a line
            
            [path addObject:[NSValue valueWithCGPoint:CGPointMake((self.y1 - cueB) / cueSlope, self.y1)]];
        }else if((self.y2 - cueB) / cueSlope >= self.x1 && (self.y2 - cueB) / cueSlope <= self.x2 && self.activeCue.y2 >= self.activeCue.y1){
            
            [path addObject:[NSValue valueWithCGPoint:CGPointMake((self.y2 - cueB) / cueSlope, self.y2)]];
        }else{
            // WTF IS GOING ON?????
        }
        
    }
    

    
    
    return path;
}




@end
