//
//  CommonTypeSelectedView.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/21.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CommonTypeSelectedView.h"

@interface CommonTypeSelectedView()

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) NSMutableArray *btnArr;

@property (nonatomic, strong) UIButton *selectedBtn;



@end

@implementation CommonTypeSelectedView


- (instancetype)initWithFrame:(CGRect)frame WithTitleArray:(NSArray *)titleArr
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = AppBgWhiteColor;
        self.titleArr = titleArr;
        [self configBaseUI];
    }
    return self;
}

- (void)setBtnTitle:(NSString *)title WithBtnIndex:(NSInteger)atIndex
{
    UIButton *btn = self.btnArr[atIndex];
    [btn setTitle:title forState:UIControlStateNormal];
    CGFloat contentWidth = [NSTool getWidthWithContent:btn.titleLabel.text font:FONT(14)] + 12;
    [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, contentWidth, 0, -contentWidth)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
}

- (void)configBaseUI
{
    NSInteger count = self.titleArr.count;
    for (int i = 0; i < count; i ++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * SCREEN_WIDTH/count, 0, SCREEN_WIDTH/count, self.bounds.size.height);
        [btn setTitleColor:AppNavTitleBlackColor forState:UIControlStateNormal];
        [btn setTitleColor:AppTitleBlueColor forState:UIControlStateSelected];
        btn.titleLabel.font = FONT(14);
        [btn setTitle:self.titleArr[i] forState:UIControlStateNormal];
//        CGFloat contentWidth = [NSTool getWidthWithContent:btn.titleLabel.text font:FONT(14)] + 12;
        [btn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchDown];
        [btn setTag:1000+i];
        [self addSubview:btn];
        [self.btnArr addObject:btn];
    }
}


- (void)selectBtnAction:(UIButton *)sender
{
    //同样的按钮点击两次 无效处理
    if (sender == self.selectedBtn) {
        return;
    }
    
    [sender setSelected:!sender.isSelected];
    self.selectedBtn = sender;
    if (self.selectBlock) {
        NSLog(@"点击返回");
        self.selectBlock(sender.tag - 1000);
    }
    
    for (UIButton *btn in self.btnArr) {
        if (btn != sender) {
            [btn setSelected:NO];
        }
    }
}

- (void)defaultAction
{
    self.selectedBtn = nil;
    for (UIButton *btn in self.btnArr) {
        [btn setSelected:NO];
    }
}


#pragma Mark- getters and setters
- (NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = [[NSArray alloc] init];
    }
    return _titleArr;
}

- (NSMutableArray *)btnArr
{
    if (!_btnArr) {
        _btnArr = [[NSMutableArray alloc] init];
    }
    return _btnArr;
}

- (UIButton *)selectedBtn
{
    if (!_selectedBtn) {
        _selectedBtn = [[UIButton alloc] init];
    }
    return _selectedBtn;
}


@end
