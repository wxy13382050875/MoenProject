//
//  UIViewController+HeightAdjustKeyBorad.m
//  HaoXiaDan_iOS
//
//  Created by 鞠鹏 on 2017/1/19.
//  Copyright © 2017年 JuPeng. All rights reserved.
//

#import "UIViewController+HeightAdjustKeyBorad.h"
#import <objc/runtime.h>

@implementation UIViewController (HeightAdjustKeyBorad)
static char *FirstResponerFieldKey = "firstResponerField";

- (UITextField *)firstResponerField{
    return objc_getAssociatedObject(self, &FirstResponerFieldKey);
    
}

- (void)setFirstResponerField:(UITextField *)firstResponerField{
    objc_setAssociatedObject(self, &FirstResponerFieldKey, firstResponerField, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)viewPositionAdjustKeyboard{
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    
}

- (void)removeKeyboardNotification{
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:HXDLoginNotification object:nil];

    }
    @catch (NSException *exception) {
        NSLog(@"观察者不存在");
    }

    
}

- (void)keyboardWillShow:(NSNotification *)aNotification{
    
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        
        self.firstResponerField = (UITextField *)firstResponder;
    }
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    CGFloat keyboardBarHeiht = self.firstResponerField.inputAccessoryView.frame.size.height;
    
    
    CGRect fieldSuperFrame = [self.firstResponerField.superview convertRect:self.firstResponerField.frame toView:self.view];
    
    CGFloat oriTextfieldMaxY = CGRectGetMaxY(fieldSuperFrame);
    
    CGFloat keyboardOriginY = SCREEN_HEIGHT - keyboardHeight -keyboardBarHeiht ;
    
    CGFloat offset= keyboardOriginY - oriTextfieldMaxY;
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    float width = SCREEN_WIDTH;
    float height = self.view.frame.size.height;
    
    CGRect rect;
    //120 是为了方便显示下一个
    if (offset < 40) {
        if (offset < 0) {
            rect  = CGRectMake(0.0f, -40+offset, width, height);
            
        }else{
            rect  = CGRectMake(self.view.frame.origin.x, -offset, width, height);
        }
    }else{
        rect = CGRectMake(0.0f, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    }
    self.view.frame = rect;

    [UIView commitAnimations];
}



- (void)keyboardWillHide:(NSNotification *)info{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        self.firstResponerField = (UITextField *)firstResponder;
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        CGFloat oriY = 64;
        if ([self isKindOfClass:NSClassFromString(@"LoginVC")]) {
            oriY = 0.0f;
        }
        CGRect rect = CGRectMake(0.0f, oriY, self.view.frame.size.width, self.view.frame.size.height);
        self.view.frame = rect;
        [UIView commitAnimations];
    }
}

@end
