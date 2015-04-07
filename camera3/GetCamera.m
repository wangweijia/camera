//
//  GetCamera.m
//  camera3
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 com.eku001. All rights reserved.
//

#import "GetCamera.h"
#import <UIKit/UIKit.h>

@interface GetCamera()

@property (nonatomic, weak) AVCaptureSession *session;
@property (nonatomic, weak) AVCaptureDevice *device;
@property (nonatomic, weak) AVCaptureDeviceInput *input;
@property (nonatomic, weak) AVCaptureStillImageOutput *output;

@end

@implementation GetCamera

+ (id)GetCamera{
    static GetCamera *camera = nil;
    if (!camera) {
        camera = [[GetCamera alloc] init];
    }
    return camera;
}

+ (id)GetCameraFrame:(CGRect)frame{
    GetCamera *camera = [self GetCamera];
    camera.captureVideoPreviewLayer.frame = frame;
    return camera;
}

- (instancetype)init{
    if (self = [super init]) {
        [self initCamera];
    }
    return self;
}

- (void)initCamera{
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    [self setSession:session];
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    //填充方式
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self setCaptureVideoPreviewLayer:captureVideoPreviewLayer];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [self setDevice:device];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if ([session canAddInput:input]) {
        [self.session addInput:input];
    }
    [self setInput:input];
    
    AVCaptureStillImageOutput *output = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [output setOutputSettings:outputSettings];
    [self setOutput:output];
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    [self setOutput:output];
    
    if (!_session.isRunning) {
        [self.session startRunning];
    }
}

- (void)takePhoto:(void (^)(UIImage *image))block{
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.output.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    [self.output captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         if (imageSampleBuffer == nil) {
//             [SVProgressHUD showErrorWithStatus:@"拍照失败，请重拍！"];
             [_session startRunning];
             return;
         }
//         CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
//         if (exifAttachments) {
//             // Do something with the attachments.
//         }
         if (imageSampleBuffer == nil) {
//             [SVProgressHUD showErrorWithStatus:@"拍照失败，请重拍！"];
             [_session startRunning];
             return;
         }
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *aImage = [[UIImage alloc] initWithData:imageData];
         block(aImage);
//         self.cameraView.image = [_finishImage imageByScalingProportionallyToSize:CGSizeMake(self.view.bounds.size.width * [[UIScreen mainScreen] scale], self.view.bounds.size.height * [[UIScreen mainScreen] scale])];
         
     }];
}

@end
