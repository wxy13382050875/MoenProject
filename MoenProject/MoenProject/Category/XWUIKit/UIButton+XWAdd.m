//
//  UIButton+XWAdd.m
//  XW_Object
//
//  Created by Benc Mai on 2019/12/6.
//  Copyright © 2019 武新义. All rights reserved.
//

#import "UIButton+XWAdd.h"

@implementation UIButton (XWAdd)
- (void)layoutWithStatus:(XWLayoutStatus)status andMargin:(CGFloat)margin{
    CGFloat imgWidth = self.imageView.bounds.size.width;
    CGFloat imgHeight = self.imageView.bounds.size.height;
    CGFloat labWidth = self.titleLabel.bounds.size.width;
    CGFloat labHeight = self.titleLabel.bounds.size.height;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (labWidth < frameSize.width) {
        labWidth = frameSize.width;
    }
    CGFloat kMargin = margin/2.0;
    switch (status) {
        case XWLayoutStatusNormal://图左字右
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, -kMargin, 0, kMargin)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, kMargin, 0, -kMargin)];
            break;
        case XWLayoutStatusImageRight://图右字左
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, labWidth + kMargin, 0, -labWidth - kMargin)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgWidth - kMargin, 0, imgWidth + kMargin)];
            break;
        case XWLayoutStatusImageTop://图上字下
            [self setImageEdgeInsets:UIEdgeInsetsMake(0,0, labHeight + margin, -labWidth)];
            
            [self setTitleEdgeInsets:UIEdgeInsetsMake(imgHeight + margin, -imgWidth, 0, 0)];
            break;
        case XWLayoutStatusImageBottom://图下字上
            [self setImageEdgeInsets:UIEdgeInsetsMake(labHeight + margin,0, 0, -labWidth)];
            
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgWidth, imgHeight + margin, 0)];
            
            break;
        default:
            break;
    }
}
- (UIButton *)gradientButtonWithSize:(CGSize)btnSize colorArray:(NSArray *)clrs  gradientType:(XWGradientType)type {
    
    UIImage *backImage = [UIImage createImageWithSize:btnSize gradientColors:clrs  gradientType:type];
    
    [self setBackgroundImage:backImage forState:UIControlStateNormal];
    
    return self;
}
+ (UIButton*)buttonWithTitie:(NSString*)title
               WithtextColor:(UIColor*)color
               WithBackColor:(UIColor*)backColor
               WithBackImage:(UIImage*)backImage
                   WithImage:(UIImage*)Image
                    WithFont:(CGFloat)font
                  EventBlock:(void(^)(id params))eventBlock
{
    UIButton* XWBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title) {
        [XWBtn setTitle:title forState:UIControlStateNormal];
    }
    if (color) {
        [XWBtn setTitleColor:color forState:UIControlStateNormal];
    }
    if (Image) {
        [XWBtn setImage:Image forState:UIControlStateNormal];
    }
    if (backColor) {
        XWBtn.backgroundColor = backColor;
    }
    if (backImage) {
        [XWBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    }
    if (font!=0) {
        XWBtn.titleLabel.font=[UIFont systemFontOfSize:font];
    }
    
    [[XWBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (eventBlock) {
            eventBlock(x);
        }
    }];
    return XWBtn;
    
}
@end
