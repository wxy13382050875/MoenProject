//
//  GoodsSalesVolumeModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/31.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsSalesVolumeModel : MoenBaseModel

@property (nonatomic, copy) NSString *sku;

@property (nonatomic, copy) NSString *count;

@property (nonatomic, copy) NSString *name;


@end

@class GoodsSalesVolumeModel;
@interface GoodsSalesVolumeListModel : MoenBaseModel

@property (nonatomic, strong) NSArray<GoodsSalesVolumeModel *> *productList;



@end

NS_ASSUME_NONNULL_END
