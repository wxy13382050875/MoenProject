//
//  NSAttributedString+Awesome.h
//  PlayFC
//
//  Created by 许成雄 on 2019/2/16.
//  Copyright © 2019 Davis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (XWAdd)

//设置Attribute字体和颜色
+ (NSAttributedString *)getAttributeWith:(id)sender
        string:(NSString *)string
     orginFont:(UIFont*)orginFont
    orginColor:(UIColor *)orginColor
 attributeFont:(UIFont*)attributeFont
attributeColor:(UIColor *)attributeColor
 textAlignment:(NSTextAlignment)textAlignment;

//隐私条款复选框
+ (NSAttributedString*)protocolIsSelect:(BOOL)select;
@end
