//
//  ShopPersonalModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/24.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShopPersonalModel : MoenBaseModel

/**用户ID*/
@property (nonatomic, copy) NSString *ID;

/**用户名称*/
@property (nonatomic, copy) NSString *name;

/**用户角色*/
@property (nonatomic, copy) NSString *businessRole;
@end



@class ShopPersonalModel;
@interface ShopPersonalListModel : MoenBaseModel

@property (nonatomic, strong) NSArray<ShopPersonalModel *> *shopPersonalList;
@end

NS_ASSUME_NONNULL_END
