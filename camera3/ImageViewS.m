//
//  ImageViewS.m
//  camera3
//
//  Created by apple on 15/3/31.
//  Copyright (c) 2015年 com.eku001. All rights reserved.
//

#import "ImageViewS.h"
#import "GetCamera.h"


#define HEIGHT self.frame.size.height
#define WIDTH self.frame.size.width
@interface ImageViewS()

//焦点坐标
@property (nonatomic, assign) NSInteger X;
@property (nonatomic, assign) NSInteger Y;
//单个控件frame
@property (nonatomic, assign) CGFloat AimageViewW;
@property (nonatomic, assign) CGFloat AimageViewH;
//存储所有控件
@property (nonatomic, strong) NSMutableArray *imageViewArray;
//摄像头
@property (nonatomic, strong) GetCamera *camera;
//已拍摄照片数
@property (nonatomic, assign) NSInteger takeCount;

@end

@implementation ImageViewS

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setRow:4];
        [self setList:4];
        self.takeCount = 0;
        self.imageViewArray = [NSMutableArray array];
    }
    return self;
}

- (void)initAllImageView{
    [self setAimageViewH:HEIGHT / _row];
    [self setAimageViewW:WIDTH / _list];
    
    self.camera = [GetCamera GetCameraFrame:CGRectMake(0, 0, _AimageViewW, _AimageViewH)];
    
    //添加所有图片窗体
    for (NSInteger y = 0; y < _row; y++) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSInteger x = 0; x < _list; x++) {
            CGFloat xx = x * _AimageViewW;
            CGFloat yy = y * _AimageViewH;
            
            AImageView *imageView = [[AImageView alloc] initWithFrame:CGRectMake(xx, yy, _AimageViewW, _AimageViewH)];
            [imageView addTarget:self action:@selector(AImageViewClicked:) forControlEvents:UIControlEventTouchUpInside];
            [imageView setCamera:_camera];
            [imageView setX:x];
            [imageView setY:y];
            [self addSubview:imageView];
            [tempArray addObject:imageView];
        }
        [self.imageViewArray addObject:tempArray];
    }
    //设置默认窗体
    [self setY:0];[self setX:0];
    AImageView *aImageView = [self getAImageViewX:_X Y:_Y];
    [aImageView setAImageViewStats:AImageViewStatsFocus];
}

/**
 *  当某个控件被点击时
 *
 *  @param sender 被点击的控件
 */
- (void)AImageViewClicked:(AImageView *)sender{
    [self focuseAImageViewX:sender.x Y:sender.y];
}

/**
 *  设置某个控件 成为 焦点
 *
 *  @param x
 *  @param y
 */
- (void)focuseAImageViewX:(NSInteger)x Y:(NSInteger)y{
    //原始选中控件
    AImageView *aImageViewBefer = [self getAImageViewX:_X Y:_Y];
    [aImageViewBefer setAImageViewStats:AImageViewStatsNormal];
    //新选中控件
    [self setX:x];[self setY:y];
    if (x < 0 || y < 0) {
        return;
    }
    AImageView *aImageView = [self getAImageViewX:_X Y:_Y];
    [aImageView setAImageViewStats:AImageViewStatsFocus];
}

/**
 *  拍摄照片
 */
- (void)takePhoto{
    //是否有 控件准备拍照
    if (_X >=0 && _Y >= 0) {
        [_camera takePhoto:^(UIImage *image) {
            AImageView *aImageView = [self getAImageViewX:_X Y:_Y];
            if (aImageView.aImageViewPhotoStats == PhotoStatsNOPhoto) {
                self.takeCount ++;
                NSLog(@"takeCount:%@",@(_takeCount));
            }
            [aImageView setAImageViewPhotoStats:PhotoStatsPhotos];
            [aImageView setAImage:image];
            [self nextImageView];
        }];
    }
}

/**
 *  指向下一个view
 */
- (void)nextImageView{
    NSInteger tempX = (_X + 1) % _list;
    NSInteger tempY = _Y;
    if (tempX == 0) {
        tempY = (_Y + 1) % _row;
        if (tempY == 0) {
            tempX = -1;
            tempY = -1;
        }
    }
    [self focuseAImageViewX:tempX Y:tempY];
}

/**
 *  得到指定的控件 test
 *
 *  @param x x坐标
 *  @param y y坐标
 *
 *  @return 返回对应控件
 */
- (AImageView *)getAImageViewX:(NSInteger)x Y:(NSInteger)y{
    if (x >= 0 && y >= 0) {
        return ((NSArray *)_imageViewArray[y])[x];
    }else{
        return nil;
    }
    
}

@end
