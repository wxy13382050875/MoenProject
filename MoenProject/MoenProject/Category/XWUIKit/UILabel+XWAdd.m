//
//  UILabel+NXAdd.m
//  NCube
//
//  Created by kepuna on 2016/12/16.
//  Copyright © 2016年 junjie.liu. All rights reserved.
//

#import "UILabel+XWAdd.h"

@implementation UILabel (XWAdd)

//+ (instancetype)labelWithTextColor:(UIColor *)color fontSize:(CGFloat)fontSize alignment:(NSTextAlignment)alignment {
//     UILabel *label = [UILabel labelWithText:nil color:color fontSize:fontSize fontName:nil alignment:alignment];
//    return label;
//}
//
//+ (instancetype)labelWithText:(NSString *)text color :(UIColor *)color fontSize:(CGFloat)fontSize alignment:(NSTextAlignment)alignment {
//    UILabel *label = [UILabel labelWithText:text color:color fontSize:fontSize fontName:nil alignment:alignment];
//    return label;
//}
//
//+ (instancetype)labelWithText:(NSString *)text color :(UIColor *)color fontSize:(CGFloat)fontSize fontName:(NSString *)fontName alignment:(NSTextAlignment)alignment{
//
//    UILabel *label = [[UILabel alloc]init];
//    label.textColor = color;
//    label.textAlignment = alignment;
//    label.font = [UIFont fontWithName:fontName size:fontSize];
//    label.text = text;
//    return label;
//
//}
//
//+ (instancetype)labelWithFont:(CGFloat)font text:(NSString *)text textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment numberOfLines:(NSInteger)numberOfLines {
//    UILabel *label = [[UILabel alloc]init];
//    label.font = [UIFont systemFontOfSize:font];
//    label.textColor = textColor;
//    label.textAlignment = textAlignment;
//    label.numberOfLines = numberOfLines;
//    label.text = text;
//    return label;
//}

-(void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing {
    if (!text || lineSpacing < 0.01) {
        self.text = text;
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];        //设置行间距
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    self.attributedText = attributedString;
}
+ (UILabel*)labelWithText:(NSString*)text
            WithTextColor:(UIColor*)textColor
            WithNumOfLine:(NSInteger)numline
            WithBackColor:(UIColor*)backColor
        WithTextAlignment:(NSTextAlignment)TextAlignment
                 WithFont:(CGFloat)Font
{
    UILabel *XWLabel = [UILabel new];
    if (text) {
        XWLabel.text = text;
    }
    if (numline!=1) {
        XWLabel.numberOfLines = numline;
    }
    if (Font!=0) {
        XWLabel.font = [UIFont systemFontOfSize:Font];
    }
    if (textColor) {
        XWLabel.textColor = textColor;
    }
    if (backColor) {
        XWLabel.backgroundColor = backColor;
    }
    XWLabel.textAlignment = TextAlignment;
    return XWLabel;
}
+ (UILabel*)labelWithLine:(UIColor*)backColor{
    UILabel *XWLabel = [UILabel new];
    if (backColor) {
        XWLabel.backgroundColor = backColor;
    }
    return XWLabel;
}
- (void)alignTop {
    CGSize fontSize = [self.text sizeWithAttributes:@{NSFontAttributeName: self.font}];;
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text boundingRectWithSize:CGSizeMake(finalWidth, finalHeight) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.font} context:nil].size;//[self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [self.text stringByAppendingString:@"\n "];
}

- (void)alignBottom {
    
    CGSize fontSize = [self.text sizeWithAttributes:@{NSFontAttributeName: self.font}];;
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text boundingRectWithSize:CGSizeMake(finalWidth, finalHeight) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.font} context:nil].size;
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
}
@end
