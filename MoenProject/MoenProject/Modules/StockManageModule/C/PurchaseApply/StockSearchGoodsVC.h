//
//  SearchGoodsVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/14.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StockSearchGoodsVCDelegate <NSObject>

@optional

- (void)StockSearchGoodsVCSelectedDelegate:(id)goodsModel;

@end
typedef NS_ENUM(NSInteger, SearchGoodsVCType)
{
    /**搜索商品*/
    SearchGoodsVCTypeSearchGoods = 0,
    /**搜索套餐*/
    SearchGoodsVCTypePackage,
    /**进货申请*/
    SearchGoodsVCType_Stock,
    /**调拔申请*/
    SearchGoodsVCType_Transfers,
    /**商品库存*/
    SearchGoodsVCType_StockGoods ,
    /**样品库存*/
    SearchGoodsVCType_StockSample
};



NS_ASSUME_NONNULL_BEGIN
/** 查找商品/套餐 */
@interface StockSearchGoodsVC : BaseViewController

@property (nonatomic, strong) id<StockSearchGoodsVCDelegate> delegate;

@property (nonatomic, assign) SearchGoodsVCType controllerType;

@property (nonatomic, assign) NSString *goodsType;


@property (nonatomic, copy) NSString *promoId;

@property (nonatomic, copy) NSString *storeID;


//@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, copy) NSString *searchSKUCode;

//购物车中的数据
@property (nonatomic, strong) NSMutableArray *selectedDataArr;

@end

NS_ASSUME_NONNULL_END
