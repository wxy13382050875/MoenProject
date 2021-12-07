//
//  LoginInfoModel.m
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/25.
//

#import "LoginInfoModel.h"

@implementation LoginInfoModel

@end


@implementation UserLoginInfoModelList

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"userConfigDataList" : [UserLoginInfoModel class]};
}
@end


@implementation UserLoginInfoModel

@end



