//
//  AImageView.m
//  camera3
//
//  Created by apple on 15/3/29.
//  Copyright (c) 2015年 com.eku001. All rights reserved.
//

#import "AImageView.h"
#import "GetCamera.h"

#define IMAGEVIEWH self.photoView.frame.size.height
#define IMAGEVIEWW self.photoView.frame.size.width

@interface AImageView()

//照片view
@property (nonatomic, weak) UIImageView *photoView;
//存放所有图片
@property (nonatomic, strong) NSMutableArray *photoArray;
//删除按钮
@property (nonatomic, weak) UIButton *deleteBtn;

@end

@implementation AImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor redColor]];
        [self initPhotoView];
        [self initDeleteBtn];
        [self setPhotoArray:[NSMutableArray array]];
        [self setAImageViewPhotoStats:PhotoStatsNOPhoto];
        [self setAImageViewStats:AImageViewStatsNormal];
        [self.layer setBorderColor:[UIColor blueColor].CGColor];
    }
    return self;
}

/**
 *  初始化相框中 删除按钮
 */
- (void)initDeleteBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setImage:[UIImage imageNamed:@"shut_btn"] forState:UIControlStateNormal];
    [btn setHidden:YES];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    CGFloat with = 18;
    CGFloat height = with;
    CGFloat x = self.frame.size.width - with - 5;
    CGFloat y = 5;
    btn.frame = CGRectMake(x, y, with, height);
    [btn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [self setDeleteBtn:btn];
}

/**
 *  初始化相框控件
 */
- (void)initPhotoView{
    UIImageView *aImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    aImageView.backgroundColor = [UIColor whiteColor];
    [aImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self setPhotoView:aImageView];
    [self addSubview:aImageView];
}

/**
 *  设置 整体 状态
 *
 *  @param aImageViewStats 枚举类型
 */
- (void)setAImageViewStats:(AImageViewStats)aImageViewStats{
    _aImageViewStats = aImageViewStats;
    switch (aImageViewStats) {
        case AImageViewStatsNormal:{
            if (_camera.captureVideoPreviewLayer.superlayer) {
                [_camera.captureVideoPreviewLayer removeFromSuperlayer];
            }
            //取消蓝色边框
            self.layer.borderWidth = 0.0;
            [self.deleteBtn setHidden:YES];
        }
            break;
        case AImageViewStatsFocus:{
            if (_photoArray.count > 0) {
                //选中效果，蓝色边框
                self.layer.borderWidth = 3.0;
                [self.deleteBtn setHidden:NO];
            }else{
                //取消蓝色边框
                self.layer.borderWidth = 0.0;
                [self.deleteBtn setHidden:YES];
                [self.layer addSublayer:_camera.captureVideoPreviewLayer];
            }
        }
            break;
        default:
            break;
    }
    
}

/**
 *  设置 相框 状态
 *
 *  @param aImageViewPhotoStats 枚举
 */
- (void)setAImageViewPhotoStats:(AImageViewPhotoStats)aImageViewPhotoStats{
    _aImageViewPhotoStats = aImageViewPhotoStats;
    switch (aImageViewPhotoStats) {
        case PhotoStatsNOPhoto:{
            self.photoView.hidden = YES;
        }
            break;
        case PhotoStatsPhotos:{
            self.photoView.hidden = NO;
        }
            break;
        default:
            break;
    }
}

/**
 *  相框设置照片
 *
 *  @param aImage 照片
 */
-(void)setAImage:(UIImage *)aImage{
    UIImage *image = [self getSubImage:aImage];
    [self.photoView setImage:image];
    [self.photoArray addObject:image];
}

/**
 *  调整照片大小
 *
 *  @param image 待 调整照片
 *
 *  @return 调整后照片
 */
- (UIImage *)getSubImage:(UIImage *)image{
    
    CGFloat imgWidth = image.size.width;
    CGFloat imgHeight = image.size.height;
    CGFloat a = imgWidth / IMAGEVIEWW;
    CGFloat b = imgHeight / IMAGEVIEWH;
    
    /*如若centerBool为Yes则是由中心点取mCGRect范围的图片*/
    CGFloat multople = a > b ? b : a;
    CGRect rect;
    CGFloat y,x;
    if (imgHeight >= IMAGEVIEWH * multople) {
        y = (imgHeight - IMAGEVIEWH * multople) / 2;
    }
    if (imgWidth >= IMAGEVIEWW * multople) {
        x = (imgWidth - IMAGEVIEWW * multople) / 2;
    }
    //转换为cgimage 后图像逆时针旋转了90度
    rect = CGRectMake(y, x, IMAGEVIEWH * multople, IMAGEVIEWW * multople);
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    return [UIImage imageWithCGImage:subImageRef scale:1.0 orientation:UIImageOrientationRight];
}

- (void)deleteBtnClick:(UIButton *)sender{
    NSInteger index = [_photoArray count] - 1;
    if (index > 0) {
        [self.photoView setImage:_photoArray[index - 1]];
        [self.photoArray removeObjectAtIndex:index];
    }else{
        [self.photoArray removeObjectAtIndex:0];
        [self.photoView setImage:nil];
        [self setAImageViewPhotoStats:PhotoStatsNOPhoto];
        [self setAImageViewStats:AImageViewStatsFocus];
    }
}

@end
