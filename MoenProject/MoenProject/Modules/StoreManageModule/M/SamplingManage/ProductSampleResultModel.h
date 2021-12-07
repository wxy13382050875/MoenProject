//
//  ProductSampleResultModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/15.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ProductSampleResultImageModel;
@interface ProductSampleResultModel : MoenBaseModel

@property (nonatomic, copy) NSString *kOperator;

@property (nonatomic, copy) NSString *operationTime;

@property (nonatomic, strong) NSArray<ProductSampleResultImageModel *> *imageUrls;

@property (nonatomic, strong) NSArray<ProductSampleResultImageModel *> *list;

@end

@interface ProductSampleResultImageModel : MoenBaseModel

@property (nonatomic, copy) NSString *bigUrl;

@property (nonatomic, copy) NSString *smallUrl;

@end

NS_ASSUME_NONNULL_END
