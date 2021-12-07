//
//  NSAttributedString+Awesome.m
//  PlayFC
//
//  Created by 许成雄 on 2019/2/16.
//  Copyright © 2019 Davis. All rights reserved.
//

#import "NSAttributedString+XWAdd.h"
#define wfont 12
@implementation NSAttributedString (XWAdd)

+ (NSAttributedString *)getAttributeWith:(id)sender
                                  string:(NSString *)string
                               orginFont:(UIFont*)orginFont
                              orginColor:(UIColor *)orginColor
                           attributeFont:(UIFont*)attributeFont
                          attributeColor:(UIColor *)attributeColor
                           textAlignment:(NSTextAlignment)textAlignment
{
    __block  NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc] initWithString:string];
    [totalStr addAttribute:NSFontAttributeName value:orginFont range:NSMakeRange(0, string.length)];
    [totalStr addAttribute:NSForegroundColorAttributeName value:orginColor range:NSMakeRange(0, string.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.0f]; //设置行间距
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [paragraphStyle setAlignment:textAlignment];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    [totalStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalStr length])];
    
   
    
    if ([sender isKindOfClass:[NSArray class]]) {
        
        __block NSString *oringinStr = string;
        
        [sender enumerateObjectsUsingBlock:^(NSString *  _Nonnull str, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSRange range = [oringinStr rangeOfString:str];
            if (range.location != NSNotFound) {
                [totalStr addAttribute:NSFontAttributeName value:attributeFont range:range];
                [totalStr addAttribute:NSForegroundColorAttributeName value:attributeColor range:range];
                NSMutableString *string = [NSMutableString string];
                for (int i = 0; i < range.length ; i++) {
                    [string appendString:@" "];
                }
                oringinStr = [oringinStr stringByReplacingCharactersInRange:range withString:string];
            }
            
        }];
        
    }else if ([sender isKindOfClass:[NSString class]]) {
        
        NSRange range = [string rangeOfString:sender];
        
        [totalStr addAttribute:NSFontAttributeName value:attributeFont range:range];
        [totalStr addAttribute:NSForegroundColorAttributeName value:attributeColor range:range];
    }
    return totalStr;
}

+ (NSAttributedString*)protocolIsSelect:(BOOL)select {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@" 我同意本边互通的服务协议和政策隐私"];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"agreement://"
                             range:[[attributedString string] rangeOfString:@"服务协议"]];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"privacy://"
                             range:[[attributedString string] rangeOfString:@"政策隐私"]];


    UIImage *image = [UIImage imageNamed:select == YES ? @"icon_checked_true" : @"icon_checked_false"];
//    CGSize size = CGSizeMake(wfont + 5, wfont + 5);
//    UIGraphicsBeginImageContextWithOptions(size, false, 0);
//    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = image;
    textAttachment.bounds =  CGRectMake(0, -5, wfont + 5, wfont + 5); //设置图片大小、位置
    NSMutableAttributedString *imageString = [NSMutableAttributedString attributedStringWithAttachment:textAttachment];
    [imageString addAttribute:NSLinkAttributeName
                             value:@"checkbox://"
                             range:NSMakeRange(0, imageString.length)];
    [attributedString insertAttributedString:imageString atIndex:0];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:wfont] range:NSMakeRange(0, attributedString.length)];
    
    return attributedString;
    
}
@end
