//
//  GoodsCategoryRankModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/1.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsCategoryRankModel : MoenBaseModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *count;

@end


@class GoodsCategoryRankModel;
@interface GoodsCategoryRankListModel : MoenBaseModel

@property (nonatomic, strong) NSArray<GoodsCategoryRankModel *> *categoryList;

@end
NS_ASSUME_NONNULL_END
