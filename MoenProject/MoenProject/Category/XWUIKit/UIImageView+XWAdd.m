//
//  UIImageView+ALinGif.m
//  MiaowShow
//
//  Created by ALin on 16/6/16.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import "UIImageView+XWAdd.h"

@implementation UIImageView (XWAdd)
// 播放GIF
- (void)playGifAnim:(NSArray *)images
{
    if (!images.count) {
        return;
    }
    //动画图片数组
    self.animationImages = images;
    //执行一次完整动画所需的时长
    self.animationDuration = 2.0;
    //动画重复次数, 设置成0 就是无限循环
    self.animationRepeatCount = 0;
    [self startAnimating];
}
// 停止动画
- (void)stopGifAnim
{
    if (self.isAnimating) {
        [self stopAnimating];
    }
    [self removeFromSuperview];
}
@end
