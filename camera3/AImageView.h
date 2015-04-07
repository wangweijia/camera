//
//  AImageView.h
//  camera3
//
//  Created by apple on 15/3/29.
//  Copyright (c) 2015年 com.eku001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetCamera;

//相框情况
typedef NS_ENUM(NSInteger, AImageViewStats){
    AImageViewStatsNormal = 1,
    AImageViewStatsFocus,
};
//照片情况
typedef NS_ENUM(NSInteger, AImageViewPhotoStats){
    PhotoStatsNOPhoto = 1,
    PhotoStatsPhotos
};

@interface AImageView : UIButton

//坐标
@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;

//输入的照片
@property (nonatomic, strong) UIImage *aImage;
//摄像类
@property (nonatomic, weak) GetCamera *camera;

//相框情况
@property (nonatomic, assign) AImageViewStats aImageViewStats;
@property (nonatomic, assign) AImageViewPhotoStats aImageViewPhotoStats;

@end
