//
//  QZLUserConfig.h
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/25.
//


#import "PAPreferences.h"

@interface QZLUserConfig : PAPreferences


/**
 * 是否第一次登陆过了
 */
@property(nonatomic,assign) BOOL isFirstEnterIn;


/**
 * token
 */
@property(nonatomic,assign) NSString *token;

/**
 *  备注：店员角色：“SHOP_LEADER”店长，"SHOP_SELLER"导购
 */
@property(nonatomic,assign) NSString *userRole;

/**
 *  备注：手机号
 */
@property(nonatomic,assign) NSString *loginPhone;

/**
 *  备注：经销商ID
 */
@property(nonatomic,assign) NSString *dealerId;
/**
 *  备注：经销商名称
 */
@property(nonatomic,assign) NSString *dealerName;
/**
 *  备注：门店ID
 */
@property(nonatomic,assign) NSString *shopId;
/**
 *  备注：门店名称
 */
@property(nonatomic,assign) NSString *shopName;
/**
 *  备注：门店人员ID
 */
@property(nonatomic,assign) NSString *employeeId;


/**
 * 是否是测试账号登录
 */
@property(nonatomic,assign) BOOL isTestEnter;

/**
 * 是否是多门店用户
 */
@property(nonatomic,assign) BOOL isMultipleStores;









/**
 *  用户名userName
 */
@property(nonatomic,assign) NSString *userName;















/**
 *  是否认证isAuth
 */
@property(nonatomic,assign) BOOL isRealAuth;

/**
 *  是否设置交易密码
 */
@property(nonatomic,assign) BOOL isTradePassword;

/**
 *  邀请码
 */
@property(nonatomic,assign) NSString *invitaionCode;

/**
 *  手机号码
 */
@property(nonatomic,assign) NSString *userPhone;

/**
 *  会员ID
 */
@property(nonatomic,assign) NSInteger mId;


/**
 *  用户ID
 */
@property(nonatomic,assign) NSInteger uId;


/**
 *  是否登录
 */
@property(nonatomic,assign) BOOL isLoginIn;


/**
 *  是否开启了手势登录
 */
@property(nonatomic,assign) BOOL isGestureLoginIn;


/**
 *  是否正在登陆
 */
@property(nonatomic,assign) BOOL isLogining;


/**
 *  是否展示奖励总览
 */
@property(nonatomic,assign) BOOL isShowAwards;




@end
