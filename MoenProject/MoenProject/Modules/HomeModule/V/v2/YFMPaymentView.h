//
//  YFMPaymentView.h
//  YFMBottomPayView
//
//  Created by YFM on 2018/8/7.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import <STPopup/STPopup.h>
#import "STPopup.h"

typedef void(^DateChangeActionBlock)(void);
typedef void(^DateConfirmActionBlock)(void);

@interface YFMPaymentView : UIViewController
- (instancetype)initDataSource:(NSMutableArray *)dataSource FloorArr:(NSMutableArray *)floorArr;

//是否显示价格 显示数量输入框
- (instancetype)initDataSource:(NSMutableArray *)dataSource FloorArr:(NSMutableArray *)floorArr isShowPrice:(BOOL)isShow IsEditNumberType:(BOOL)isEditNumber;
//支付方式
@property (nonatomic, copy) void(^payType)(NSString *type ,NSString *balance);


@property (nonatomic, copy) DateChangeActionBlock dateChangeActionBlock;

@property (nonatomic, copy) DateConfirmActionBlock dateConfirmActionBlock;


@end
