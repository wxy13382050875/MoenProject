//
//  CommonSingleGoodsDarkTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/18.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonGoodsModel.h"
#import "StoreActivityDetailModel.h"
#import "OrderManageModel.h"
#import "IntentionGoodsModel.h"
#import "ReturnOrderInfoModel.h"
#import "xWStockOrderModel.h"
#import "XwInOrOutWaterModel.h"
#import "XwStockInfoModel.h"
#import "ExchangeGoodsModel.h"
#import "ExchangProductInfoModel.h"

typedef NS_ENUM(NSInteger, CommonSingleGoodsDarkTCellType)
{
    /**商品套餐*/
    CommonSingleGoodsDarkTCellTypeGoods = 0,
    /**赠品套餐*/
    CommonSingleGoodsDarkTCellTypeGoodsGift,
    
    
    
};

static NSString *KCommonSingleGoodsDarkTCell = @"CommonSingleGoodsDarkTCell";
static NSString *KCommonSingleGiftGoodsDarkTCell = @"CommonSingleGiftGoodsDarkTCell";
static CGFloat KCommonSingleGoodsDarkTCellH = 118;
static CGFloat KCommonSingleGoodsDarkSelectedTCellH = 143;


typedef void(^ExchangeGoodsBlock)(ProductlistModel* model);
NS_ASSUME_NONNULL_BEGIN

@interface CommonSingleGoodsDarkTCell : BaseTableViewCell
@property(nonatomic,strong)Goodslist* model;
@property (nonatomic, copy) Goodslist* delModel;
@property(nonatomic,strong)OrderlistModel* orderModel;
@property(nonatomic,strong)XwStockInfoModel* stockInfoModel;
@property(nonatomic,strong)ExchangeGoodsModel* exchangeModel;
@property(nonatomic,strong)ProductlistModel* exchangeCounterModel;
@property (nonatomic, copy) ExchangeGoodsBlock exchangeBlock;


@property (nonatomic, assign) CommonSingleGoodsDarkTCellType cellType;

- (void)showDataWithCommonProdutcModelForSearch:(CommonProdutcModel *)model;

- (void)showDataWithCommonProdutcModelForCommonSearch:(CommonProdutcModel *)model;


/**门店活动详情 展示套餐数据*/
- (void)showDataWithStoreActivityMealProductsModel:(StoreActivityMealProductsModel *)model;

- (void)showDataWithOrderManageModel:(OrderManageModel *)model;


- (void)showDataWithOrderManageModelForReturn:(OrderManageModel *)model;

/**会员意向管理展示*/
- (void)showDataWithIntentionProductModel:(IntentionProductModel *)model;


- (void)showDataWithReturnOrderSingleGoodsModel:(ReturnOrderSingleGoodsModel *)model;

- (void)showDataWithReturnOrderSingleGoodsModelForReturnSelected:(ReturnOrderSingleGoodsModel *)model;

- (void)showDataWithReturnOrderSingleGoodsModelForReturnAllGoodsCounter:(ReturnOrderSingleGoodsModel *)model;
//进货单 调拨单套餐
- (void)showDataWithStockTransfersForCommonSearch:(CommonProdutcModel *)model;
//部分退货赠品套餐
- (void)showDataWithReturnGiftModelForReturnSelected:(CommonProdutcModel *)model;
@end

NS_ASSUME_NONNULL_END
