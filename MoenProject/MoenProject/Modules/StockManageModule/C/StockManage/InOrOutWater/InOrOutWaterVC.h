//
//  PurchaseOrderManageVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/24.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef NS_ENUM(NSInteger, PurchaseOrderManageVCType)
//{
//    /**ALL全部*/
//    PurchaseOrderManageVCTypeDefault = 0,
//    /**GROOM:推荐订单*/
//    PurchaseOrderManageVCTypeGROOM,
//    /**MAJOR:专业*/
//    PurchaseOrderManageVCTypeMAJOR,
//};
NS_ASSUME_NONNULL_BEGIN

@interface InOrOutWaterVC : BaseViewController

/**是否识别*/
@property (nonatomic, assign) BOOL isIdentifion;
/**用户ID*/
@property (nonatomic, copy) NSString *customerId;

//@property (nonatomic, assign) PurchaseOrderManageVCType controllerType;

@end

NS_ASSUME_NONNULL_END
