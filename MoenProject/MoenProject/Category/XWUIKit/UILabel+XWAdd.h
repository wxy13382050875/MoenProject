//
//  UILabel+NXAdd.h
//  NCube
//
//  Created by kepuna on 2016/12/16.
//  Copyright © 2016年 junjie.liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (XWAdd)

//+ (instancetype)labelWithTextColor:(UIColor *)color
//                          fontSize:(CGFloat)fontSize
//                         alignment:(NSTextAlignment)alignment;
//
//+ (instancetype)labelWithText:(NSString *)text
//                       color :(UIColor *)color
//                     fontSize:(CGFloat)fontSize
//                    alignment:(NSTextAlignment)alignment;
//+ (instancetype)labelWithText:(NSString *)text
//                        color:(UIColor *)color
//                     fontSize:(CGFloat)fontSize
//                     fontName:(NSString *)fontName
//                    alignment:(NSTextAlignment)alignment;

//+ (instancetype)labelWithFont:(CGFloat )font text:(NSString *)text textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment numberOfLines:(NSInteger)numberOfLines;

/**
 设置文本,并指定行间距
 
 @param text 文本内容
 @param lineSpacing 行间距
 */
-(void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;

#pragma -mark UILabel常用全部属性
+ (UILabel*)labelWithText:(NSString*)text
            WithTextColor:(UIColor*)textColor
            WithNumOfLine:(NSInteger)numline
            WithBackColor:(UIColor*)backColor
        WithTextAlignment:(NSTextAlignment)TextAlignment
                 WithFont:(CGFloat)Font;
#pragma -mark 线
+ (UILabel*)labelWithLine:(UIColor*)backColor;

- (void)alignTop;
- (void)alignBottom;
@end
