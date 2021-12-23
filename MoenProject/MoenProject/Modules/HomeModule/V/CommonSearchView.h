//
//  CommonSearchView.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/30.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CommonSearchViewType)
{
    /**客户识别*/
    CommonSearchViewTypeCustomer = 0,
    /**商品*/
    CommonSearchViewTypeGoods,
    /**套餐列表*/
    CommonSearchViewTypePackage,
    /**订单列表*/
    CommonSearchViewTypeOrder,
    /**意向管理*/
    CommonSearchViewTypeIntention,
    /**商品列表*/
    CommonSearchViewTypeGoodsList,
    /**退货单列表*/
    CommonSearchViewTypeOrderReturn,
    /**盘库单*/
    CommonSearchViewTypeCheckStockOrder,
    /**调库单*/
    CommonSearchViewTypeChangeStockOrder,
    /**调拨单*/
    CommonSearchViewTypeChangeDllot,
    
    /**进货单*/
    CommonSearchViewTypeChangeSTOCK,
    
    /**发货单*/
    CommonSearchViewTypeChangeDeliver,
    
    /**退仓单*/
    CommonSearchViewTypeChangeReturn,
    
    /**总仓发货*/
    CommonSearchViewTypeChangeWarehouse,
};


@protocol SearchViewCompleteDelete <NSObject>

@required

- (void)completeInputAction:(NSString *)keyStr;

- (void)selectedTimeAction;

@end


NS_ASSUME_NONNULL_BEGIN

@interface CommonSearchView : UIView

@property (nonatomic, strong) id<SearchViewCompleteDelete> delegate;

@property (nonatomic, assign) CommonSearchViewType viewType;

@property (nonatomic, copy) NSString *inputTxtStr;

- (void)clearContent;

@end

NS_ASSUME_NONNULL_END
