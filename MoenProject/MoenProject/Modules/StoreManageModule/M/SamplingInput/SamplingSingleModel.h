//
//  SamplingSingleModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/28.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SamplingSingleModel : MoenBaseModel<NSCopying>

/**出样的id*/
@property (nonatomic, assign) NSInteger sampleId;

/**出样的名称*/
@property (nonatomic, copy) NSString *sampleName;

/**出样数量*/
@property (nonatomic, assign) NSInteger sampleQuantity;

/**出样类型*/
@property (nonatomic, copy) NSString *sampleType;

@end


@class SamplingSingleModel;
@interface SamplingListModel : MoenBaseModel

@property (nonatomic, assign) BOOL judge;
/**出样列表*/
@property (nonatomic, strong) NSArray<SamplingSingleModel *> *sampleSingleDataList;

@end

NS_ASSUME_NONNULL_END
