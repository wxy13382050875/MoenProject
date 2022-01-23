//
//  LoginInfoModel.h
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/25.
//

#import <Foundation/Foundation.h>

@interface LoginInfoModel : MoenBaseModel

/***/
@property (nonatomic, copy) NSString *scope;

/**有效期*/
@property (nonatomic, copy) NSString *expires_in;

/**refresh_token*/
@property (nonatomic, copy) NSString *refresh_token;

/**类型*/
@property (nonatomic, copy) NSString *token_type;

/**token*/
@property (nonatomic, copy) NSString *access_token;



@end



@class UserLoginInfoModel;
@interface UserLoginInfoModelList : MoenBaseModel

@property (nonatomic, strong) NSArray<UserLoginInfoModel *>  *userConfigDataList;

@end




@interface UserLoginInfoModel : MoenBaseModel

/** 备注：店员角色：“SHOP_LEADER”店长，"SHOP_SELLER"导购 */
@property (nonatomic, copy) NSString *userRole;

/** 备注：经销商ID*/
@property (nonatomic, copy) NSString *dealerId;

/** 备注：经销商名称*/
@property (nonatomic, copy) NSString *dealerName;

/** 备注：门店ID*/
@property (nonatomic, copy) NSString *shopId;

/** 备注：门店名称*/
@property (nonatomic, copy) NSString *shopName;

/** 备注：门店ID*/
@property (nonatomic, copy) NSString *employeeId;


@property (nonatomic, assign) BOOL isSelected;

/** 备注：门店ID*/
@property (nonatomic, copy) NSString *storeID;


/** 备注：门店ID*/
@property (nonatomic, copy) NSString *storeName;

/** 备注：仓库ID*/
@property (nonatomic, copy) NSString *id;

/** 备注：仓库名*/
@property (nonatomic, copy) NSString *name;

/** 备注：用户名*/
@property (nonatomic, copy) NSString *userName;
@end



