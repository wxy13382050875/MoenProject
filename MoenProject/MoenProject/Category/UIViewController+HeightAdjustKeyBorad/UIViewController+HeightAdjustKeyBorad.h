//
//  UIViewController+HeightAdjustKeyBorad.h
//  HaoXiaDan_iOS
//
//  Created by 鞠鹏 on 2017/1/19.
//  Copyright © 2017年 JuPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HeightAdjustKeyBorad)

/*
 * 使用注意rmeove observer
 */
- (void)viewPositionAdjustKeyboard;

/*
 * 使用移除键盘观察者
 */
- (void)removeKeyboardNotification;

@property (nonatomic, strong) UITextField *firstResponerField;
@property (nonatomic,assign) BOOL autoAdaptKeyboard;






@end
