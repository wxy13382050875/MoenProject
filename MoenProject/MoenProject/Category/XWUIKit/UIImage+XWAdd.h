//
//  UIImage+Gradient.h
//  testLayer
//
//  Created by tb on 17/3/17.
//  Copyright © 2017年 com.tb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GIFimageBlock)(UIImage *GIFImage);

typedef NS_ENUM(NSInteger, XWGradientType) {
    XWGradientFromTopToBottom = 1,            //从上到下
    XWGradientFromLeftToRight,                //从做到右
    XWGradientFromLeftTopToRightBottom,       //从上到下
    XWGradientFromLeftBottomToRightTop        //从上到下
};

@interface UIImage (XWAdd)


/**
 *  根据给定的颜色，生成渐变色的图片
 *  @param imageSize        要生成的图片的大小
 *  @param colorArr         渐变颜色的数组
 *  @param gradientType     渐变色的类型
 */
+ (UIImage *)createImageWithSize:(CGSize)imageSize gradientColors:(NSArray *)colorArr  gradientType:(XWGradientType)gradientType;

/**
*  颜色转图片
*  @param color        要生成的图片的颜色
*/
+ (UIImage *)imageWithColor:(UIColor *)color;
/**
*  设置图片不变系统色
*  @param name 设置图片名称
*/
+ (UIImage *)originImageWithName:(NSString*) name;
/*
 *  压缩图片方法(先压缩质量再压缩尺寸)
 */
-(NSData *)compressWithLengthLimit:(NSUInteger)maxLength;
/*
 *  压缩图片方法(压缩质量)
 */
-(NSData *)compressQualityWithLengthLimit:(NSInteger)maxLength;
/*
 *  压缩图片方法(压缩质量二分法)
 */
-(NSData *)compressMidQualityWithLengthLimit:(NSInteger)maxLength;
/*
 *  压缩图片方法(压缩尺寸)
 */
-(NSData *)compressBySizeWithLengthLimit:(NSUInteger)maxLength;
/*
*  获取图片第一帧
*/
- (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size;

//pragma mark 截取当前屏幕，并生成image对象
+ (UIImage *)getScreenImage:(UIView *)view;

/** 根据本地GIF图片名 获得GIF image对象 */
+ (UIImage *)imageWithGIFNamed:(NSString *)name;

/** 根据一个GIF图片的data数据 获得GIF image对象 */
+ (UIImage *)imageWithGIFData:(NSData *)data;

/** 根据一个GIF图片的URL 获得GIF image对象 */
+ (void)imageWithGIFUrl:(NSString *)url and:(GIFimageBlock)gifImageBlock;

/*将UIView 转换为图片**/
+ (UIImage *)getImageFromView:(UIView *)view;
@end
