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
- (float) heightForString:(NSString *)value andWidth:(float)width{
//获取当前文本的属性
   NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:value];
   self.attributedText = attrStr;
   NSRange range = NSMakeRange(0, attrStr.length);
   // 获取该段attributedString的属性字典
   NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
   // 计算文本的大小
   CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width - 16.0, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:dic        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
   return sizeToFit.height + 16.0;
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
