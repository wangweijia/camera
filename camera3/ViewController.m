//
//  ViewController.m
//  camera3
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 com.eku001. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewS.h"
//#import "GetCamera.h"
//#import "AImageView.h"

//设备屏幕宽度
#define DEVICE_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
//设备屏幕高度
#define DEVICE_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()

//@property (nonatomic, assign) NSInteger row;
//@property (nonatomic, assign) NSInteger list;
//
//@property (nonatomic, assign) NSInteger X;
//@property (nonatomic, assign) NSInteger Y;
//
//@property (nonatomic, assign) CGFloat AimageViewW;
//@property (nonatomic, assign) CGFloat AimageViewH;
//
//@property (nonatomic, strong) NSMutableArray *imageViewArray;
//
//@property (nonatomic, strong) GetCamera *camera;

@property (nonatomic, weak) ImageViewS *imageViewS;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initCamera];
    
    ImageViewS *imageViewS = [[ImageViewS alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT - 64)];
    [imageViewS setRow:4];
    [imageViewS setList:4];
    [imageViewS initAllImageView];
    [self.view addSubview:imageViewS];
    [self setImageViewS:imageViewS];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)shouldAutorotate{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhoto:(id)sender {
    [_imageViewS takePhoto];
}


@end
