//
//  MembershipInfoModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/17.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MembershipInfoModel : MoenBaseModel

/**客户手机号*/
@property (nonatomic, copy) NSString *phone;

/**会员id*/
@property (nonatomic, copy) NSString *customerId;

/**会员账户*/
@property (nonatomic, copy) NSString *account;

/**推荐人*/
@property (nonatomic, copy) NSString *referee;

/**身份*/
@property (nonatomic, copy) NSString *identity;

@end

NS_ASSUME_NONNULL_END
