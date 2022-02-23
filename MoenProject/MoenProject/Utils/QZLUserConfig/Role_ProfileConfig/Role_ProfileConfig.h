//
//  User_ProfileConfig.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/29.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Role_ProfileConfig : NSObject


#pragma mark 门店店长—首页
extern NSString* const ME_Store_Owner_HomePage;


#pragma mark 门店导购—首页
extern NSString* const ME_Store_Guide_HomePage;





#pragma mark 门店店长—门店管理
extern NSString* const ME_Store_Owner_StoreManage;


#pragma mark 门店导购—门店管理
extern NSString* const ME_Store_Guide_StoreManage;



#pragma mark 门店店长—统计
extern NSString* const ME_Store_Owner_Statistics;


#pragma mark 门店导购—统计
extern NSString* const ME_Store_Guide_Statistics;









#pragma mark 门店店长—识别
extern NSString* const ME_Store_Owner_Identity;


#pragma mark 门店导购—识别
extern NSString* const ME_Store_Guide_Identity;


#pragma mark 会员注册—注册
extern NSString* const ME_Store_User_Register;

#pragma mark 库存管理-店长
extern NSString* const ME_Store_Owner_StockManage;

#pragma mark 库存管理-导购
extern NSString* const ME_Store_Guide_StockManage;

#pragma mark 库存管理二级菜单-店长
extern NSString* const ME_Store_Owner_StockManageChild;

#pragma mark 库存管理二级菜单-导购
extern NSString* const ME_Store_Guide_StockManageChild;
@end

NS_ASSUME_NONNULL_END
