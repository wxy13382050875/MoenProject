//
//  CommonSaleasTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCExpandModel.h"
#import "MajorCustomerModel.h"
#import "GoodsSalesVolumeModel.h"
#import "PackageRankModel.h"
#import "SCExpandModel.h"

typedef NS_ENUM(NSInteger, CommonSaleasTCellType)
{
    
    CommonSaleasTCellGoodsNumberInfo = 0, //商品销量信息 :
    CommonSaleasTCellCustomerInfo, //专业客户信息 :ProfessionalCustomerVC
    CommonSaleasTCellPackageRank, //套餐排名
};

NS_ASSUME_NONNULL_BEGIN

/**
 * 通用销量展示TCell
 *
 */
@interface CommonSaleasTCell : UITableViewCell

@property (nonatomic, assign) CommonSaleasTCellType cellType;

- (void)showDataWithSCExpandModel:(SCExpandModel *)model;

- (void)showDataWithSCExpandCustomerModel:(SCExpandCustomerModel *)model;

- (void)showDataWithMajorCustomerModel:(MajorCustomerModel *)model;


- (void)showDataWithGoodsSalesVolumeModel:(GoodsSalesVolumeModel *)model;


- (void)showDataWithPackageRankModel:(PackageRankModel *)model WithSelectedType:(NSInteger)selectedType;
@end

NS_ASSUME_NONNULL_END
