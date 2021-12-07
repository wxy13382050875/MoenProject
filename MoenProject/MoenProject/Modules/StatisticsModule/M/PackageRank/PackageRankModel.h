//
//  PackageRankModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/31.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PackageRankModel : MoenBaseModel

@property (nonatomic, copy) NSString *comboCode;

@property (nonatomic, copy) NSString *comboDescribe;

@property (nonatomic, copy) NSString *numOrPrice;

@end

@class PackageRankModel;
@interface PackageRankListModel : MoenBaseModel

@property (nonatomic, strong) NSArray<PackageRankModel *> *setMealList;


@end

NS_ASSUME_NONNULL_END
