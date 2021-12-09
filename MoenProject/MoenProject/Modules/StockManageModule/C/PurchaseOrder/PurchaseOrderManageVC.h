//
//  PurchaseOrderManageVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/24.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PurchaseOrderManageVCType)
{
    /**ALL全部*/
    PurchaseOrderManageVCTypeDefault = 0,
    /**GROOM:推荐订单*/
    PurchaseOrderManageVCTypeGROOM,
    /**MAJOR:专业*/
    PurchaseOrderManageVCTypeMAJOR,
    /**进货:*/
    PurchaseOrderManageVCTypeSTOCK,
    /**退仓:*/
    PurchaseOrderManageVCTypeReturn,
    /**调拨单*/
    PurchaseOrderManageVCTypeAllocteOrder,
    /**调拨任务*/
    PurchaseOrderManageVCTypeAllocteTask,
    
//    /**发货-进货申请*/类型  进货申请/order  调拨申请/apply 门店自提/shopSelf  总仓发货/stocker
    PurchaseOrderManageVCTypeDeliveryOrder,
    /**发货-调拨申请*/
    PurchaseOrderManageVCTypeDeliveryApply,
    /**发货-门店自提*/
    PurchaseOrderManageVCTypeDeliveryShopSelf,
    /**发货-总仓发货*/
    PurchaseOrderManageVCTypeDeliveryStocker,
    /**库存-总仓发货*/
    PurchaseOrderManageVCTypeInventoryStocker,
    
    /**商品库存*/
    PurchaseOrderManageVCTypeInventoryStockGoods ,
    /**样品库存*/
    PurchaseOrderManageVCTypeInventoryStockSample,
    
    /**盘库商品库存*/
    PurchaseOrderManageVCTypeStocktakingStockGoods ,
    
    /**盘库样品库存*/
    PurchaseOrderManageVCTypeStocktakingStockSample,
    
    /**样品库存调整*/
    PurchaseOrderManageVCTypeStockGoodsAdjustment,
    /**样品库存调整*/
    PurchaseOrderManageVCTypeStockSampleAdjustment,
    
    /**盘库单*/
    PurchaseOrderManageVCTypePlateStorage ,
    
    /**调库单*/
    PurchaseOrderManageVCTypeLibrary ,
};
NS_ASSUME_NONNULL_BEGIN

@interface PurchaseOrderManageVC : BaseViewController

/**是否识别*/
@property (nonatomic, assign) BOOL isIdentifion;
/**用户ID*/
@property (nonatomic, copy) NSString *customerId;

@property (nonatomic, assign) PurchaseOrderManageVCType controllerType;

@end

NS_ASSUME_NONNULL_END
