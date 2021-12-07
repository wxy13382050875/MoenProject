//
//  UIImageView+ALinGif.h
//  MiaowShow
//
//  Created by ALin on 16/6/16.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (XWAdd)
// 播放GIF
- (void)playGifAnim:(NSArray *)images;
// 停止动画
- (void)stopGifAnim;
@end
