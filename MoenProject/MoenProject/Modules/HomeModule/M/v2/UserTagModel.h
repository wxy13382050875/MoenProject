//
//  UserTagModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/11/19.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserTagModel : MoenBaseModel
/**会员id*/
@property (nonatomic, copy) NSString *customerId;
/**：会员标签ID，对应枚举中ID*/
@property (nonatomic, copy) NSString *customerTagId;
@end

NS_ASSUME_NONNULL_END
