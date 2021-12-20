//
//  UITextView+XWAdd.h
//  XW_Object
//
//  Created by Benc Mai on 2021/2/1.
//  Copyright © 2021 武新义. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^changeBlock)(NSString* text);

@interface UITextView (XWAdd)<UITextViewDelegate>

/**
 *  点击完成按钮的回调
 */
@property (nonatomic,copy) changeBlock block;

/**  可限制输入的字符个数 依赖于：JKLimitInput
 
 [UITextField的对象 setValue:@10 forKey:@"limit"];
 
 */

@property (nonatomic, strong) UITextView *xw_placeHolderTextView;

- (void)xw_addPlaceHolder:(NSString *)placeHolder;



@end

NS_ASSUME_NONNULL_END
