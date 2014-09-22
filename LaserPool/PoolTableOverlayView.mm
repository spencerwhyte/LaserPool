//
//  PoolTableOverlayView.m
//  LaserPool
//
//  Created by Spencer Whyte on 2014-07-25.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "PoolTableOverlayView.h"

@interface PoolTableOverlayView ()

@property CGFloat testAngle;

@end

@implementation PoolTableOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor grayColor];
        self.poolTable = [[PoolTable alloc] init];
        
        self.isBeingDrawnOnPoolTable = NO;
        
        [self spinningCueTest];
    }
    return self;
}

-(void)spinningCueTest{
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateSpinningCue) userInfo:nil repeats:YES];
    self.testAngle=0;
    
    self.poolTable.activeCue.x2 = (self.poolTable.x2 - self.poolTable.x1)/2;
    self.poolTable.activeCue.y2 = (self.poolTable.y2 - self.poolTable.y1)/2;
}

-(void)updateSpinningCue{
    self.testAngle += 0.001;
    
    self.poolTable.activeCue.x1 = (self.poolTable.x2 - self.poolTable.x1)/2 + 0.75*(self.poolTable.x2 - self.poolTable.x1)*sin(self.testAngle);
    self.poolTable.activeCue.y1 = (self.poolTable.y2 - self.poolTable.y1)/2 + 0.75*(self.poolTable.x2 - self.poolTable.x1)*cos(self.testAngle);
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat width = rect.size.width;
    
    CGFloat height = rect.size.height;
    
    CGFloat phoneAspectRatio = rect.size.width/rect.size.height;
    
    CGFloat poolTableWidth = self.poolTable.x2-self.poolTable.x1;
    CGFloat poolTableHeight = self.poolTable.y2-self.poolTable.y1;
    CGFloat poolTableAspectRatio = poolTableWidth/poolTableHeight;
    
    if(phoneAspectRatio>poolTableAspectRatio){// If the phone screen is too wide
        height = rect.size.height;
        width = poolTableAspectRatio * rect.size.height;
    }else{ // If the phone screen is too tall
        width = rect.size.width;
        height = rect.size.width / poolTableAspectRatio;
    }
    width/=poolTableWidth;
    height/=poolTableHeight;
    
    
    CGFloat radialMultiplier = width;
 
    
    CGFloat xOffset = 0;
    CGFloat yOffset = 0;

    

    if(!self.isBeingDrawnOnPoolTable){

        for(Ball * b in self.poolTable.balls){
            
            if(b.isOnTheTable){ // Only draw the ball if it has not been sunk yet
                
                UIColor * color = b.color;
                CGFloat red, green, blue, alpha;
                [color getRed:&red green:&green blue:&blue alpha:&alpha];
                
                CGFloat radius = b.radius * radialMultiplier;
                
                CGContextSetRGBStrokeColor(context, red, green, blue, 1);
                CGContextSetRGBFillColor(context, red, green, blue, 1);
                
                CGFloat x = width * b.x;
                CGFloat y = height * b.y;

                
                CGContextAddArc(context, xOffset + x, yOffset + y, radius, 0, 2 * 3.14159265358979, 1);
                
                CGContextFillPath(context);
            
                if(b.isStriped){
                
                    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
                    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
                    
                    // setup properties
                    CGContextSetLineWidth(context, 2);
                    
                    #define PI 3.14159265
                    
                    CGFloat x0 = radius * -1 * sin(PI/4);
                    CGFloat y0 = radius * -1 * sin(PI/4);
                    
                    CGFloat x1 = x0 + y0;
                    CGFloat y1 = 0;
                    
                    CGFloat x2 = radius * -1 * sin(PI/4);
                    CGFloat y2 = radius *sin(PI/4);
                    
                    CGContextMoveToPoint(context, xOffset + x+x0, yOffset + y + y0);
                    
                    CGContextAddArcToPoint(context, xOffset + x + x1, yOffset  + y + y1, xOffset + x + x2, yOffset + y + y2, radius);
                    
                    CGContextFillPath(context);
                    
                    CGContextMoveToPoint(context, xOffset + x + -1 * x0, yOffset + y + y0);
                    
                    CGContextAddArcToPoint(context, xOffset + x + -1 * x1, yOffset + y + y1, xOffset + x + -1 * x2, yOffset + y + y2, radius);
                    
                    CGContextFillPath(context);
                    
                }
                if(b.number > 0){
                    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
                    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
                    
                    CGContextAddArc(context, xOffset + x, yOffset + y, radius/2, 0, 2 * 3.14159265358979, 1);
                    
                    CGContextFillPath(context);
                    
                    CGFloat offset = 2.2;
                    if(b.number > 9){
                        offset += 3.2;
                    }
                    
                    [[NSString stringWithFormat:@"%d", b.number] drawAtPoint:CGPointMake(xOffset+ x - offset, yOffset + y - 6)
                               withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica"
                                                                                    size:10]
                                                }];
                }
            }
        }
        

        // show table edges
        CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
        CGContextSetRGBFillColor(context, 1, 1, 1, 1);
        CGContextSetLineWidth(context, 4);
        
        CGContextMoveToPoint   (context, self.poolTable.x1*width, self.poolTable.y1*height);
        CGContextAddLineToPoint(context, self.poolTable.x2*width, self.poolTable.y1*height);
        CGContextAddLineToPoint(context, self.poolTable.x2*width, self.poolTable.y2*height);
        CGContextAddLineToPoint(context, self.poolTable.x1*width, self.poolTable.y2*height);
        CGContextAddLineToPoint(context, self.poolTable.x1*width, self.poolTable.y1*height);
        CGContextStrokePath(context);
        
        
        // Draw the cue
        CGContextSetLineWidth(context, 8);
        CGContextMoveToPoint   (context, self.poolTable.activeCue.x1 * width, self.poolTable.activeCue.y1 * height);
        CGContextAddLineToPoint(context, self.poolTable.activeCue.x2 * width, self.poolTable.activeCue.y2 * height);
        CGContextStrokePath(context);
        
        CGContextSetRGBStrokeColor(context, 0.1, 0.1, 0.1, 1);
        // Draw the tip of the cue
        CGContextSetLineWidth(context, 8);
        
        double finalX = (self.poolTable.activeCue.x2 - (self.poolTable.activeCue.x2 - self.poolTable.activeCue.x1) * 0.05) * width;
        double finalY = (self.poolTable.activeCue.y2 - (self.poolTable.activeCue.y2 - self.poolTable.activeCue.y1) * 0.05) * height;
        
        CGContextMoveToPoint   (context, finalX, finalY);
        CGContextAddLineToPoint(context, self.poolTable.activeCue.x2 * width, self.poolTable.activeCue.y2 * height);
        CGContextStrokePath(context);
        
        CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
    }
    
    CGContextSetRGBStrokeColor(context, 0, 1, 0, 1);
    CGContextSetLineWidth(context, 2);
    // Draw the path of the cue
    NSArray * path = [self.poolTable computeCueBallPath];
    NSValue *tempVal = [path objectAtIndex:0];
    CGPoint tempP = [tempVal CGPointValue];
    CGContextMoveToPoint   (context, xOffset + width * tempP.x, yOffset + height * tempP.y);
    
    for(int i = 1 ; i < path.count; i++){
        NSValue *val = [path objectAtIndex:i];
        CGPoint p = [val CGPointValue];
        CGContextAddLineToPoint(context, xOffset + width * p.x, yOffset + height * p.y);
    }
    CGContextStrokePath(context);
 
 
}


@end
