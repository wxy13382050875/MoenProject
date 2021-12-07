//
//  UITextField+XWAdd.h
//  XW_Object
//
//  Created by Benc Mai on 2019/12/10.
//  Copyright © 2019 武新义. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum{
    VALIDATION_TYPE_NUM_VALIDATED = 0,//数字
    VALIDATION_TYPE_ID_CARD_VALIDATED = 1,//身份证
    VALIDATION_TYPE_MOBILE_PHONE_VALIDATED = 2,//手机号
    VALIDATION_TYPE_EMAIL_VALIDATED = 3,//email
} ValidationType;

@interface UITextField (XWAdd)
+ (UITextField*)textFieldWithtext:(NSString*)text
                    WithTextColor:(UIColor*)textColor
                         WithFont:(CGFloat)font
                WithTextAlignment:(NSTextAlignment)textAlignment
                  WithPlaceholder:(NSString*)placeholder
                      WithKeyWord:(UIKeyboardType)keyboardType
                     WithDelegate:(id)delegate;

-(void)setValidationType:(ValidationType)validationType;
 
-(NSString *)errorMessage;
 
- (void)limitTextLength:(int)length;
@end

NS_ASSUME_NONNULL_END
