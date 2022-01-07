//
//  SellGoodsScanVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/13.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SellGoodsScanVCType)
{
    /**卖货*/
    SellGoodsScanVCSell = 0,
    /**添加意向商品*/
    SellGoodsScanVCIntention,
};

NS_ASSUME_NONNULL_BEGIN

@interface SellGoodsScanVC : BaseViewController

/**用户ID*/
@property (nonatomic, copy) NSString *customerId;

@property (nonatomic, assign) SellGoodsScanVCType controllerType;

//@property (nonatomic, assign)  controllerType;

//购物车中的数据
@property (nonatomic, strong) NSMutableArray *selectedDataArr;
@end

NS_ASSUME_NONNULL_END
