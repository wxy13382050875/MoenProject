//
//  StockQueryVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/21.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSInteger, StockQueryVCType)
//{
//    /**库存查询*/
//    StockQueryVCType_NONE = 0,
//    /**库存查询SKU*/
//    StockQueryVCType_SKU
//
//
//};

NS_ASSUME_NONNULL_BEGIN
/**商品管理*/

typedef void(^RefreshBlock)(NSString* goodsID);
@interface StockQueryVC : BaseViewController
//@property (nonatomic, assign) StockQueryVCType queryVcType;
@property (nonatomic, strong) NSString* goodsID;


@end

NS_ASSUME_NONNULL_END
