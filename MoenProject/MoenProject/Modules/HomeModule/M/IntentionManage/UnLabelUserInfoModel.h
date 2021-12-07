//
//  UnLabelUserInfoModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/26.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UnLabelUserInfoModel : MoenBaseModel

/**会员id*/
@property (nonatomic, copy) NSString *customerId;

/**渠道来源*/
@property (nonatomic, copy) NSString *channel;

/**会员电话*/
@property (nonatomic, copy) NSString *custCode;

/**加入时间*/
@property (nonatomic, copy) NSString *createDate;


@end

@class UnLabelUserInfoModel;
@interface UnLabelUserListModel : MoenBaseModel


/**未标记用户列表*/
@property (nonatomic, strong) NSArray<UnLabelUserInfoModel *> *notLabelList;


@end



NS_ASSUME_NONNULL_END
