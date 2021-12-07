//
//  UITextField+XWAdd.m
//  XW_Object
//
//  Created by Benc Mai on 2019/12/10.
//  Copyright © 2019 武新义. All rights reserved.
//

#import "UITextField+XWAdd.h"
#import <objc/objc.h>
#import <objc/runtime.h>
static NSString *kLimitTextMaxLengthKey = @"kLimitTextMaxLengthKey";
static NSString *kLimitTextErrorMessageKey = @"kLimitTextErrorMessageKey";

@implementation UITextField (XWAdd)
+ (UITextField*)textFieldWithtext:(NSString*)text
                    WithTextColor:(UIColor*)textColor
                         WithFont:(CGFloat)font
                WithTextAlignment:(NSTextAlignment)textAlignment
                  WithPlaceholder:(NSString*)placeholder
                      WithKeyWord:(UIKeyboardType)keyboardType
                     WithDelegate:(id)delegate
{
    UITextField *WMZtextField = [UITextField new];
    if (delegate) {
        WMZtextField.delegate = delegate;
    }
    if (text) {
        WMZtextField.text = text;
    }
    if (textColor) {
        WMZtextField.textColor = textColor;
    }
    if (font!=0) {
        WMZtextField.font = [UIFont systemFontOfSize:font];
    }
    if (textAlignment!=NSTextAlignmentLeft) {
        WMZtextField.textAlignment = textAlignment;
    }
    if (placeholder) {
        WMZtextField.placeholder = placeholder;
    }
    if (keyboardType!=0) {
        WMZtextField.keyboardType = keyboardType;
    }
    return WMZtextField;
    
}

-(void)resetTextfieldValidation
{
    objc_setAssociatedObject(self, (__bridge  const void *)(kLimitTextErrorMessageKey), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void)setValidationType:(ValidationType)validationType
{
    [self addTarget:self action:@selector(resetTextfieldValidation) forControlEvents:UIControlEventEditingDidBegin];
    self.keyboardType = UIKeyboardTypeDefault;
     
    if (validationType == VALIDATION_TYPE_NUM_VALIDATED) {
        [self limitTextOnlyNumber];
        self.keyboardType = UIKeyboardTypeNumberPad;
    }else if(validationType == VALIDATION_TYPE_EMAIL_VALIDATED){
        [self limitTextOnlyEmail];
        self.keyboardType = UIKeyboardTypeEmailAddress;
    }else if(validationType == VALIDATION_TYPE_MOBILE_PHONE_VALIDATED){
        [self limitTextOnlyPhone];
        self.keyboardType = UIKeyboardTypePhonePad;
    }else if(validationType == VALIDATION_TYPE_ID_CARD_VALIDATED){
        [self limitTextOnlyIDCard];
    }
     
    [self limitTextNoSpace];
}
 
-(NSString *)errorMessage
{
    NSString *str= objc_getAssociatedObject(self, (__bridge  const void *)(kLimitTextErrorMessageKey));
    if (str) {
        return str;
    }
    return nil;
}
 
#pragma mark - Limit Text Length
- (void)limitTextLength:(int)length
{
    objc_setAssociatedObject(self, (__bridge  const void *)(kLimitTextMaxLengthKey), [NSNumber numberWithInt:length], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(textFieldTextLengthLimit:) forControlEvents:UIControlEventEditingChanged];
}
 
- (void)textFieldTextLengthLimit:(id)sender
{
    NSNumber *maxLengthNumber = objc_getAssociatedObject(self, (__bridge  const void *)(kLimitTextMaxLengthKey));
    int maxLength = [maxLengthNumber intValue];
    if(self.text.length > maxLength){
        self.text = [self.text substringToIndex:maxLength];
    }
}
 
#pragma mark - Limit Text Only Number
-(void)limitTextOnlyNumber
{
    [self addTarget:self action:@selector(textFieldTextNumberLimit:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldTextNumberLimit:(id)sender
{
    if (!self.text.length) {
        [self resetTextfieldValidation];
        return;
    }
    NSString * regexNum = @"^\\d*$";
    NSPredicate *regexNumPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexNum];
    if ([regexNumPredicate evaluateWithObject:self.text]==YES) {
    }else{
        self.text=[self.text substringFromIndex:self.text.length];
    }
}
 
#pragma mark - Limit Text Only Phone
-(void)limitTextOnlyPhone
{
    [self addTarget:self action:@selector(textFieldTextPhoneLimit:) forControlEvents:UIControlEventEditingDidEnd];
    [self limitTextLength:11];
    [self limitTextOnlyNumber];
}
 
- (void)textFieldTextPhoneLimit:(id)sender
{
    if (!self.text.length) {
        [self resetTextfieldValidation];
        return;
    }
    //    NSString * regex=@"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSString * regex=@"^1\\d{10}$";
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([regexPredicate evaluateWithObject:self.text]==YES) {
        self.text=[self.text substringToIndex:self.text.length];
        [self resetTextfieldValidation];
    }else{
        self.text=[self.text substringToIndex:self.text.length];
        objc_setAssociatedObject(self, (__bridge  const void *)(kLimitTextErrorMessageKey), @"请输入正确的手机号码", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
#pragma mark - Limit Text For Email
-(void)limitTextOnlyEmail
{
    [self addTarget:self action:@selector(textFieldTextForEmailLimit:) forControlEvents:UIControlEventEditingDidEnd];
}
 
- (void)textFieldTextForEmailLimit:(id)sender
{
    if (!self.text.length) {
        [self resetTextfieldValidation];
        return;
    }
    NSString *regex=@"^[a-zA-Z0-9][\\w\\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\\w\\.-]*[a-zA-Z0-9]\\.[a-zA-Z][a-zA-Z\\.]*[a-zA-Z]$";
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([regexPredicate evaluateWithObject:self.text]==YES) {
        [self resetTextfieldValidation];
    }else{
        objc_setAssociatedObject(self, (__bridge  const void *)(kLimitTextErrorMessageKey), @"邮箱格式错误", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
#pragma mark - Limit Text For IDCard
-(void)limitTextOnlyIDCard
{
    [self addTarget:self action:@selector(textFieldTextForIDCardLimit:) forControlEvents:UIControlEventEditingDidEnd];
    [self limitTextLength:18];
}
 
- (void)textFieldTextForIDCardLimit:(id)sender
{
    if (!self.text.length) {
        [self resetTextfieldValidation];
        return;
    }
    //NSString *regex=@"^(4\\d{12}(?:\\d{3})?)$";
    NSString *regex=@"^([1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3})|([1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X))$";
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([regexPredicate evaluateWithObject:self.text]==YES) {
        [self resetTextfieldValidation];
    }else{
        objc_setAssociatedObject(self, (__bridge  const void *)(kLimitTextErrorMessageKey), @"身份证格式错误", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
 
#pragma mark - Limit Text NoSpace
- (void)limitTextNoSpace
{
    [self addTarget:self action:@selector(textFieldTextNoSpaceLimit:) forControlEvents:UIControlEventEditingDidEnd];
}
 
- (void)textFieldTextNoSpaceLimit:(id)sender
{
    self.text = [self noSpaceString:self.text];
}
- (NSString *)noSpaceString:(NSString *)str
{
    if (str.length) {
        return  [str stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    }
     
    return str;
}
@end
