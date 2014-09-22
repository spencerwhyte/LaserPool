//
//  VisionMaster3000.m
//  LaserPool
//
//  Created by Spencer Whyte on 2014-08-26.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "VisionMaster3000.h"

@interface VisionMaster3000 ()

@end

@implementation VisionMaster3000


-(id)init{
    if(self = [super init]){
        self.imageView = [[UIImageView alloc] init];
        self.view = self.imageView;
        
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"View did load");
    
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imageView];
    self.videoCamera.delegate = self;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;
    //self.videoCamera.grayscale = NO;
    
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"Started");
    [self.videoCamera start];
}

#ifdef __cplusplus
- (void)processImage:(Mat&)image;
{
    
    
    //NSLog(@"Process");
    Mat hsv;
    
    //cvtColor(image, hsv, COLOR_BGR2HSV);
    Mat output;
    inRange(hsv, Scalar(25, 130, 130), Scalar(29, 255, 255), output);
    
   
    
}

#endif




@end
