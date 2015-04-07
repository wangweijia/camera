//
//  ImageViewS.h
//  camera3
//
//  Created by apple on 15/3/31.
//  Copyright (c) 2015年 com.eku001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AImageView.h"

@interface ImageViewS : UIView

//行列数 row：行
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger list;
//初始化所有控件
- (void)initAllImageView;
//得到某个组件
- (AImageView *)getAImageViewX:(NSInteger)x Y:(NSInteger)y;
//拍照
- (void)takePhoto;

@end
