//
//  MajorCustomerModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/28.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MajorCustomerModel : MoenBaseModel

/**入会日期*/
@property (nonatomic, copy) NSString *registerDate;

/**客户名称*/
@property (nonatomic, copy) NSString *custName;

/**手机号*/
@property (nonatomic, copy) NSString *custCode;

/**专业客户*/
@property (nonatomic, copy) NSString *career;

/**客户账号*/
@property (nonatomic, copy) NSString *account;

/**专业客户类型*/
@property (nonatomic, copy) NSString *specialtyType;



@end


@class MajorCustomerModel;
@interface MajorCustomerListModel : MoenBaseModel

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSArray<MajorCustomerModel *> *specialtyCustomerList;


@end

NS_ASSUME_NONNULL_END
