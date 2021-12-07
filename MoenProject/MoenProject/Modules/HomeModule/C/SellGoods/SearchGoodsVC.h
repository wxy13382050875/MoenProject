//
//  SearchGoodsVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/14.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockSearchGoodsVC.h"
@protocol SearchGoodsVCDelegate <NSObject>

@optional

- (void)SearchGoodsVCSelectedDelegate:(id)goodsModel;

@end
//typedef NS_ENUM(NSInteger, SearchGoodsVCType)
//{
//    /**搜索商品*/
//    SearchGoodsVCTypeSearchGoods = 0,
//    /**搜索套餐*/
//    SearchGoodsVCTypePackage,
//};



NS_ASSUME_NONNULL_BEGIN
/** 查找商品/套餐 */
@interface SearchGoodsVC : BaseViewController

@property (nonatomic, strong) id<SearchGoodsVCDelegate> delegate;

@property (nonatomic, assign) SearchGoodsVCType controllerType;

@property (nonatomic, copy) NSString *promoId;


//@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, copy) NSString *searchSKUCode;

//购物车中的数据
@property (nonatomic, strong) NSMutableArray *selectedDataArr;

@end

NS_ASSUME_NONNULL_END
