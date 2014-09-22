//
//  PoolTableOverlayView.h
//  LaserPool
//
//  Created by Spencer Whyte on 2014-07-25.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoolTable.h"


@interface PoolTableOverlayView : UIView

@property PoolTable * poolTable;

@property BOOL isBeingDrawnOnPoolTable;


@end
