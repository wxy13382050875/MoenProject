//
//  UITextView+XWAdd.m
//  XW_Object
//
//  Created by Benc Mai on 2021/2/1.
//  Copyright © 2021 武新义. All rights reserved.
//

#import "UITextView+XWAdd.h"

#define MAX_LENGTH 100

static const char *xw_phTextView = "xw_placeHolderTextView";

static const void *UtilityKey = &UtilityKey;
@implementation UITextView (XWAdd)

@dynamic block;

- (changeBlock)block {
    return objc_getAssociatedObject(self, UtilityKey);
}

- (void)setBlock:(changeBlock)block{
    objc_setAssociatedObject(self, UtilityKey, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UITextView *)xw_placeHolderTextView{
    
    return objc_getAssociatedObject(self, xw_phTextView);
}

- (void)setXw_placeHolderTextView:(UITextView *)jk_placeHolderTextView{
    
    objc_setAssociatedObject(self, xw_phTextView, jk_placeHolderTextView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)xw_addPlaceHolder:(NSString *)placeHolder {
    if (![self xw_placeHolderTextView]) {
        self.delegate = self;
        UITextView *textView = [[UITextView alloc] initWithFrame:self.bounds];
        textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        textView.font = self.font;
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor = [UIColor grayColor];
        textView.userInteractionEnabled = NO;
        textView.text = placeHolder;
        [self addSubview:textView];
        [self setXw_placeHolderTextView:textView];
    }
}

# pragma mark - UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView{
    
    if([textView.text length] > 0)
    {
        self.xw_placeHolderTextView.hidden = YES;
    }else{
        self.xw_placeHolderTextView.hidden = NO;
    }
    
    if(self.block){
        self.block(textView.text);
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@""] && range.length > 0) {
        // 删除字符肯定是安全的
        return YES;
    }
    
    if (textView.text.length - range.length + text.length > MAX_LENGTH) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"超出最大长度" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}
@end
