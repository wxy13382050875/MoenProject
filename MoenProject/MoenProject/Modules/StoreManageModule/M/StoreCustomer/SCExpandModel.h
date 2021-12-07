//
//  SCExpandModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/28.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCExpandModel : MoenBaseModel

/**来源渠道*/
@property (nonatomic, copy) NSString *sourceChannelEnum;

/**创建时间*/
@property (nonatomic, copy) NSString *registerDate;

/**客户账号*/
@property (nonatomic, copy) NSString *account;

/**操作用户*/
@property (nonatomic, copy) NSString *updateUserName;

/**操作用户业务角色*/
@property (nonatomic, copy) NSString *customerType;

/***/
@property (nonatomic, copy) NSString *custCode;

@end


@interface SCExpandCustomerModel : MoenBaseModel

/**来源渠道*/
@property (nonatomic, copy) NSString *channel;

/**创建时间*/
@property (nonatomic, copy) NSString *createDate;

/**客户账号*/
@property (nonatomic, copy) NSString *account;

/**操作用户*/
@property (nonatomic, copy) NSString *operatePersonal;

/**操作用户业务角色*/
@property (nonatomic, copy) NSString *customerType;

/***/
@property (nonatomic, copy) NSString *phone;

@end

@class SCExpandModel, SCExpandCustomerModel;
@interface SCExpandListModel : MoenBaseModel
/**数据信息*/
@property (nonatomic, strong) NSArray<SCExpandModel *> *monthCoustomerDetail;

/**数据信息*/
@property (nonatomic, strong) NSArray<SCExpandCustomerModel *> *customerList;
@end

NS_ASSUME_NONNULL_END
