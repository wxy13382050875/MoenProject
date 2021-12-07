//
//  UIColor+FCGradient.h
//  PlayFC
//
//  Created by 许成雄 on 2019/3/16.
//  Copyright © 2019 Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]

typedef NS_ENUM(NSInteger, XWChangeDirection) {
    XWChangeDirectionHorizontal,
    XWChangeDirectionVertical,
    XWChangeDirectionUpwardDiagonalLine,
    XWChangeDirectionDownDiagonalLine,
};

@interface UIColor (XWAdd)

+ (UIColor *)colorGradientChangeWithSize:(CGSize)size
                                  direction:(XWChangeDirection)direction
                                 startColor:(UIColor *)startcolor
                                   endColor:(UIColor *)endColor;



+ (UIColor *)colorWithHexString:(NSString *)color;

// 从十六进制字符串获取颜色
// color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
@end

NS_ASSUME_NONNULL_END
