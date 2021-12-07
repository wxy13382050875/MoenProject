//
//  AddressAddTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressInfoModel.h"

typedef NS_ENUM(NSInteger,AddressAddTCellActionType)
{
    AddressAddTCellActionTypeSave = 0,
    AddressAddTCellActionTypeProvince,
    AddressAddTCellActionTypeCity,
    AddressAddTCellActionTypeDistrict,
    AddressAddTCellActionTypeStreet,
};

typedef void(^AddressAddTCellSaveBlock)(AddressAddTCellActionType actionType);

NS_ASSUME_NONNULL_BEGIN

@interface AddressAddTCell : UITableViewCell

@property (nonatomic, copy) AddressAddTCellSaveBlock saveBlock;

- (void)showDataWithAddressInfoModel:(AddressInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
