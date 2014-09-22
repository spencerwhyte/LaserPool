//
//  VisionMaster3000.h
//  LaserPool
//
//  Created by Spencer Whyte on 2014-08-26.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//


#import <UIKit/UIKit.h>

#import <opencv2/highgui/cap_ios.h>
using namespace cv;


@interface VisionMaster3000 : UIViewController<CvVideoCameraDelegate> 

@property (nonatomic, retain) CvVideoCamera* videoCamera;
@property UIImageView* imageView;



@end
