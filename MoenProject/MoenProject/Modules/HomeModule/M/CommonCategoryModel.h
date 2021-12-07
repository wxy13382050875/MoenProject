//
//  CommonCategoryModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/2.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CommonCategoryDataModel;
@interface CommonCategoryModel : MoenBaseModel

@property (nonatomic, copy) NSString *className;

@property (nonatomic, strong) NSArray <CommonCategoryDataModel *> *datas;

@end

@interface CommonCategoryDataModel : MoenBaseModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *des;

@end


@class CommonCategoryModel;
@interface CommonCategoryListModel : MoenBaseModel

@property (nonatomic, strong) NSArray <CommonCategoryModel *> *enums;

@end

NS_ASSUME_NONNULL_END
