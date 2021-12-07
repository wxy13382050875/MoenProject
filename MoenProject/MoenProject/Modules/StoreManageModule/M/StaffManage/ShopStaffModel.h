//
//  ShopStaffModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/28.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ShopStaffTypeModel;
@interface ShopStaffModel : MoenBaseModel

@property (nonatomic, assign) NSInteger shopId;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, strong) ShopStaffTypeModel *status;

@property (nonatomic, copy) NSString *shopName;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) ShopStaffTypeModel *businessRole;

@end



@class ShopStaffModel;
@interface ShopStaffListModel : MoenBaseModel

@property (nonatomic, copy) NSString *shopName;

@property (nonatomic, strong) NSArray<ShopStaffModel *> *shopPersonalList;

@end


@interface ShopStaffTypeModel : MoenBaseModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *des;

@end

NS_ASSUME_NONNULL_END
