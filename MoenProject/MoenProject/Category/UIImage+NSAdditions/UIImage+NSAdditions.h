//
//  UIImage+NSAdditions.h
//  TestApp
//
//  Created by NOVA8OSSA on 15/7/1.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DDAdditions)

+ (UIImage *)screenShoot:(UIView *)view;

+ (UIImage *) imageWithFrame:(CGRect)frame alphe:(CGFloat)alphe;

- (UIImage *)scaleFitToSize:(CGSize)size;

- (UIImage *)scaleFillToSize:(CGSize)size;

+ (UIImage *)imageWithRenderColor:(UIColor *)color renderSize:(CGSize)size;
/**
 *  rgb 值创建图片
 */
+ (UIImage*) createImageWithColor: (UIColor*) color;

+ (UIImage*) createImageWithColor:(UIColor*) color frame:(CGRect)frame;

/**
改变图片size
 */
+ (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize;

+ (UIImage *)opaqueImageWithRenderColor:(UIColor *)color renderSize:(CGSize)size;

+ (UIImage *)imageWithCornerRadius:(float)radius fillColor:(UIColor *)fillColor StrokeColor:(UIColor *)strokeColor;

+ (UIImage *)imageWithSize:(CGSize)size lineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat)radius fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor;

/**
 *  根据图片名 拉伸图片
 *  imageName：图片名
 *  返回值：UIImage
 *  备注：根据水平中心线 竖直中心线 进行拉伸
 */
+ (UIImage *)stretchableImageWithImageName:(NSString *)imageName;

@end
