//
//  Utils.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;
#pragma 正则匹配邮箱地址
+ (BOOL)checkEmailNumber:(NSString *) emailNumber;
#pragma 正则匹配用户密码6-20位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password;
#pragma 正则匹配用户真实姓名
+ (BOOL)checkRealName:(NSString *) name;
#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName;
#pragma 正则匹配用户身份证号
+ (BOOL)checkUserIdCard: (NSString *) idCard;
#pragma 正则匹员工号,12位的数字
+ (BOOL)checkEmployeeNumber : (NSString *) number;
#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url;
#pragma 正则匹配中英文下划线
+ (BOOL)checkName:(NSString *) name;
#pragma 正则匹配中文
+ (BOOL)matchSupplyChainName:(NSString *) name;

+ (BOOL)checkSupplyChainName:(NSString *) name;

+ (BOOL)checkIPPort:(NSString *) name;

+ (BOOL)isValidatIP:(NSString *)ipAddress;

//验证验证码
+ (BOOL)checkIdCodeNumber:(NSString *)idCodeNumber;
//好下单添加
#pragma 收货人：20位中英文、数字、下划线
+ (BOOL)checkReceiverName:(NSString *)receiverName;

+ (BOOL)checkDetailsAddress:(NSString *)detailsAddress;

+ (BOOL)checkComment:(NSString *)comment;

//座机号码验证
+ (BOOL)validateTelphone:(NSString *)telphone;
//邮编验证
+ (BOOL)isValidPostalcode:(NSString *)zip;

+ (BOOL)validateTelphoneNumber:(NSString *)telphone;

+ (BOOL)validateContactNumber:(NSString *)telphone;

#pragma 正则匹配银行卡号
+ (BOOL) IsBankCard:(NSString *)cardNumber;

/*
 * 公司编号
 *13 或者 15 位字母数字组合
 */
+ (BOOL)checkCompanyNum:(NSString *)companyNum;

/**
 *  判断是否包含表情
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;

//表情符号的判断
+ (BOOL)stringContainsEmojiE:(NSString *)string;

@end
