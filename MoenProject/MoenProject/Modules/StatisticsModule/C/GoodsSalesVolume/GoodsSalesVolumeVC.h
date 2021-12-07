//
//  GoodsSalesVolumeVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, GoodsSalesVolumeVCType)
{
    GoodsSalesVolumeVCTypeWithSearch = 0, //商品销售数量 有搜索
    GoodsSalesVolumeVCTypeItemList,  //子列表
    GoodsSalesVolumeVCTypeIsTheBest,  //当日销量最佳
    GoodsSalesVolumeVCTypeLeader,  //店长
    GoodsSalesVolumeVCTypeSeller,  //导购
};

@interface GoodsSalesVolumeVC :BaseViewController

@property (nonatomic, assign) GoodsSalesVolumeVCType controllerType;

@property (nonatomic, assign) NSInteger selectedType;

@property (nonatomic, copy) NSString *categoryId;

@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, copy) NSString *endTime;

@end

NS_ASSUME_NONNULL_END
