//
//  UTVCSkipHelper.h
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/9.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, UTSkipViewControllerType)
{
    /**理财产品详情*/
    UTFinancingProductDetailVCType = 0,
};



@interface UTVCSkipHelper : NSObject

//按照类型跳转
+ (void)pushWithUrlType:(UTSkipViewControllerType)controllerType withParameters:(NSDictionary *)parameters;

+ (void)presentLoginVCWithLoginWays:(BOOL)isChangeLoginWay;

+ (void)presentGestureLoginVC;

+ (BOOL)isLoginStatus;
@end
