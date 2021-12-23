//
//  CommonSingleGoodsTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/14.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonGoodsModel.h"
#import "GoodsDetailModel.h"
#import "PackageDetailModel.h"
#import "StoreActivityDetailModel.h"
#import "CommonGoodsModel.h"
#import "IntentionGoodsModel.h"
#import "ReturnOrderInfoModel.h"
#import "ReturnOrderCounterModel.h"
#import "ReturnOrderDetailModel.h"
#import "XwOrderDetailModel.h"
static NSString *KCommonSingleGoodsTCell = @"CommonSingleGoodsTCell";
static NSString *KCommonSingleGoodsTCellForGift = @"CommonSingleGoodsTCellForGift";
static CGFloat KCommonSingleGoodsTCellSingleH = 115;
static CGFloat KCommonSingleGoodsTCellPackageH = 140;

typedef NS_ENUM(NSInteger, CommonSingleGoodsTCellType)
{
    /**卖货扫描*/
    CommonSingleGoodsTCellTypeSellGoods = 0,
    /**卖货柜台*/
    CommonSingleGoodsTCellTypeSellCounter,
    
    /**商品列表 默认*/
    CommonSingleGoodsTCellTypeGoodsList,
    /**套餐列表 默认*/
    CommonSingleGoodsTCellTypePackageList,
    /**套餐详情 默认*/
    CommonSingleGoodsTCellTypePackageDetail,
    /**意向管理 */
    CommonSingleGoodsTCellTypeIntention,
    
    /**退货 选择商品 */
    CommonSingleGoodsTCellTypeReturnSelected,
    
};


typedef void(^SelectedGoodsActionBlock)(CommonGoodsModel* model);

typedef void(^GoodsShowDetailActionBlock)(BOOL isShow, NSInteger atIndex);

/**商品删除回调*/
typedef void(^GoodsDeleteActionBlock)(NSInteger atIndex);

/**商品数量变化回调*/
typedef void(^GoodsNumberChangeActionBlock)(void);


NS_ASSUME_NONNULL_BEGIN

//Type  单品：115 套餐：140
@interface CommonSingleGoodsTCell : BaseTableViewCell

@property (nonatomic, copy) SelectedGoodsActionBlock goodsSelectedBlock;

@property (nonatomic, copy) GoodsDeleteActionBlock goodsDeleteBlock;

@property (nonatomic, copy) GoodsShowDetailActionBlock goodsShowDetailBlock;

@property (nonatomic, copy) GoodsNumberChangeActionBlock goodsNumberChangeBlock;

@property (nonatomic, copy) Goodslist* model;

/**查找商品/套餐*/
- (void)showDataWithCommonGoodsModel:(CommonGoodsModel *)model AtIndex:(NSInteger)atIndex WihtControllerType:(NSInteger)controllerType;

/**卖货*/
- (void)showDataWithCommonGoodsModelForSell:(CommonGoodsModel *)model AtIndex:(NSInteger)atIndex WithIsEditNumberType:(BOOL)isEditNumber;


/**卖货柜台*/
- (void)showDataWithCommonGoodsModelForSalesCounter:(CommonGoodsModel *)model AtIndex:(NSInteger)atIndex;

/**赠品显示 编辑或者不编辑状态*/
- (void)showDataWithCommonGoodsModelForGift:(CommonGoodsModel *)model AtIndex:(NSInteger)atIndex;

/**商品管理界面 数据展示*/
- (void)showDataWithGoodsDetailModel:(GoodsDetailModel *)model WithCellType:(CommonSingleGoodsTCellType)cellTyper;


/**套餐管理界面 数据展示*/
- (void)showDataWithPackageDetailModel:(PackageDetailModel *)model WithCellType:(CommonSingleGoodsTCellType)cellTyper;


- (void)showDataWithStoreActivityMealModel:(StoreActivityMealModel *)model AtIndex:(NSInteger)atIndex;


/**商品详情 显示商品*/
- (void)showDataWithCommonMealProdutcModel:(CommonMealProdutcModel *)goodsModel AtIndex:(NSInteger)atIndex;

/**订单详情 显示商品 用于赠品*/
- (void)showDataWithCommonMealProdutcModelForGift:(CommonMealProdutcModel *)goodsModel AtIndex:(NSInteger)atIndex;

/**意向商品 信息展示*/
- (void)showDataWithIntentionProductModel:(IntentionProductModel *)model;


- (void)showDataWithReturnOrderMealGoodsModel:(ReturnOrderMealGoodsModel *)goodsModel AtIndex:(NSInteger)atIndex;

/**整单退货 退货柜台*/
- (void)showDataWithReturnOrderMealGoodsModelForReturnAllGoodsCounter:(ReturnOrderMealGoodsModel *)goodsModel AtIndex:(NSInteger)atIndex;

/**退货柜台 数据展示*/
- (void)showDataWithReturnOrderCounterGoodsModel:(ReturnOrderCounterGoodsModel *)model;


- (void)showDataWitReturnOrderDetailGoodsModel:(ReturnOrderDetailGoodsModel *)model;

//进货调拨
- (void)showDataWithStockTransfersForSell:(CommonGoodsModel *)model AtIndex:(NSInteger)atIndex ;
@end

NS_ASSUME_NONNULL_END
