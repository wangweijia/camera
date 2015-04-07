//
//  GetCamera.h
//  camera3
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 com.eku001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

//int (^setImage)(UIImage *image);

@interface GetCamera : NSObject


@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;

+ (id)GetCamera;

+ (id)GetCameraFrame:(CGRect)frame;
//拍照
- (void)takePhoto:(void (^)(UIImage *image))block;

@end
