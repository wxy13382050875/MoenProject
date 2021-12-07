//
//  UIBarButtonItem+Category.m
//  ChatDemo-UI3.0
//
//  Created by Davis on 16/12/26.
//  Copyright © 2016年 Davis. All rights reserved.
//

#import "UIBarButtonItem+XWAdd.h"
#import <objc/runtime.h>
@interface UIBarButtonItem ()
@property (nonatomic) BarButtonItemBlock barButtonItemBlock;
@end

@implementation UIBarButtonItem (XWAdd)

+(instancetype)barButtonItemWithImage:(NSString *)image andBarButtonItemBlock:(BarButtonItemBlock)barButtonItemBlock
{
//    FCHotButton *btn = [FCHotButton buttonWithImageName:image];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];;
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    item.barButtonItemBlock = barButtonItemBlock;
    
    [btn addTarget:item action:@selector(clickItem) forControlEvents:UIControlEventTouchUpInside];
    return item;
}

+(instancetype)barButtonItemWithTitle:(NSString *)title andBarButtonItemBlock:(BarButtonItemBlock)barButtonItemBlock
{
    //默认是白色文字
    return [self barButtonItemWithTitle:title titleColor:[UIColor whiteColor] andBarButtonItemBlock:barButtonItemBlock];
}

+(instancetype)barButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor andBarButtonItemBlock:(BarButtonItemBlock)barButtonItemBlock
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
    [item setTarget:item];
    [item setAction:@selector(clickItem)];
    item.barButtonItemBlock = barButtonItemBlock;
    item.tintColor = titleColor;
    return item;
}
- (void)clickItem
{
    if (self.barButtonItemBlock) {
        self.barButtonItemBlock();
    }
}



static void *key = &key;
-(void)setBarButtonItemBlock:(BarButtonItemBlock)barButtonItemBlock
{
    objc_setAssociatedObject(self, & key, barButtonItemBlock, OBJC_ASSOCIATION_COPY);
}
-(BarButtonItemBlock)barButtonItemBlock
{
    return objc_getAssociatedObject(self, &key);
}
@end
