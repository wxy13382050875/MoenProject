//
//  SamplingDetailVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/6.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductSampleResultModel.h"

typedef NS_ENUM(NSInteger, SamplingDetailVCType)
{
    /**出样详情*/
    SamplingDetailVCTypeDetail = 0,
    /**出样上传成功*/
    SamplingDetailVCTypeSuccess,
};

NS_ASSUME_NONNULL_BEGIN

@interface SamplingDetailVC : BaseViewController

@property (nonatomic, assign) SamplingDetailVCType controllerType;
@property (nonatomic, strong) ProductSampleResultModel *dataModel;

@end

NS_ASSUME_NONNULL_END
