//
//  FDAlertView.h
//  FDAlertViewDemo
//
//  Created by fergusding on 15/5/26.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FDAlertViewDelegate;

typedef NS_ENUM(NSInteger, FDAltertViewType)
{
    /**提示*/
    FDAltertViewTypeTips = 0,
    /**输入 - 增项加价*/
    FDAltertViewTypeInputPrice,
    /**输入 - 修改增项加价*/
    FDAltertViewTypeEditInputPrice,
    
    /**输入 - PU单号*/
    FDAltertViewTypeInputCode,
    /**输入 - 修改PU单号*/
    FDAltertViewTypeEditInputCode,
    
    
    /**输入 - 增项加价*/
    FDAltertViewTypeInputPriceForGift,
    /**输入 - 修改增项加价*/
    FDAltertViewTypeEditInputPriceForGift,
    
    /**输入 - PU单号*/
    FDAltertViewTypeInputCodeForGift,
    /**输入 - 修改PU单号*/
    FDAltertViewTypeEditInputCodeForGift,
    
    
    /**输入 - 添加备注*/
    FDAltertViewTypeAddMark,
    
    /**查看 - 查看备注*/
    FDAltertViewTypeSeeMark,
    
    /**提交订单*/
    FDAltertViewTypeSubmitOrder,
};

@interface FDAlertView : UIView

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *message;
@property (nonatomic, assign) FDAltertViewType alterType;
@property (weak, nonatomic) id<FDAlertViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title alterType:(FDAltertViewType)alterType message:(NSString *)message delegate:(id<FDAlertViewDelegate>)delegate buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION;

// Show the alert view in current window
- (void)show;

// Hide the alert view
- (void)hide;

// Set the color and font size of title, if color is nil, default is black. if fontsize is 0, default is 14
- (void)setTitleColor:(UIColor *)color fontSize:(CGFloat)size;

// Set the color and font size of message, if color is nil, default is black. if fontsize is 0, default is 12
- (void)setMessageColor:(UIColor *)color fontSize:(CGFloat)size;

// Set the color and font size of button at the index, if color is nil, default is black. if fontsize is 0, default is 16
- (void)setButtonTitleColor:(UIColor *)color fontSize:(CGFloat)size atIndex:(NSInteger)index;

@end

@protocol FDAlertViewDelegate <NSObject>

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex WithInputStr:(NSString *)inputStr;

@end
