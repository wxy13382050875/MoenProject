//
//  Utils.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "Utils.h"

@implementation Utils
#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber
{
    NSString *pattern = @"1[3|4|5|6|7|8|9|][0-9]{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

#pragma 正则匹配邮箱地址
+ (BOOL)checkEmailNumber:(NSString *)emailNumber
{
    NSString *pattern =  @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:emailNumber];
    return isMatch;
}


#pragma 正则匹配用户密码6-20位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password
{
//    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,16}";

    NSString *pattern = @"^[a-zA-Z0-9]{6,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}

+ (BOOL)checkRealName:(NSString *)name
{
    
    NSString *realNamePattern = @"^[\u4e00-\u9fa5]{0,}";
    
    NSPredicate *realNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",realNamePattern];
    if(![realNamePredicate evaluateWithObject:name]){
      NSLog(@"姓名格式不正确,请检查后重试!");
     }
    return YES;
}

#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName
{
    NSString *pattern = @"^[a-zA-Z一-龥]{1,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
    
}


#pragma 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard: (NSString *) idCard
{
    BOOL flag;
    if (idCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL isMatch = [identityCardPredicate evaluateWithObject:idCard];
    return isMatch;
}

#pragma 正则匹员工号,12位的数字
+ (BOOL)checkEmployeeNumber : (NSString *) number
{
    NSString *pattern = @"^[0-9]{12}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
    
}

#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url
{
    NSString *pattern = @"^[0-9A-Za-z]{1,50}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
    return isMatch;
    
}

+ (BOOL)checkName:(NSString *) name
{
    NSString *regex = @"^[a-zA-Z0-9_\u4e00-\u9fa5]{4,25}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    if (![pred evaluateWithObject:name])
    {
        return YES;
    }
    return NO;
}
+ (BOOL)checkChinaName:(NSString *) name
{
    NSString *regex = @"^[\u4e00-\u9fa5]{0,}+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (![pred evaluateWithObject:name])
    {
        return YES;
    }
    return NO;

}

+ (BOOL)matchSupplyChainName:(NSString *) name
{
    NSString *regex = @"^[a-zA-Z0-9_\u4e00-\u9fa5]{1,15}+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([pred evaluateWithObject:name])
    {
        return YES;
    }
    return NO;
    
}

+ (BOOL)checkIPPort:(NSString *) name
{
    NSString *regex = @"(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d)\\."
    "(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d)\\."
    "(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d)\\."
    "(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d):\\d{1,}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (![pred evaluateWithObject:name])
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isValidatIP:(NSString *)ipAddress{
    
    NSString  *urlRegEx =@"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5]):\\d{1,}$";
    
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:ipAddress];
    
}

//验证验证码
+ (BOOL)checkIdCodeNumber:(NSString *) idCodeNumber
{
    NSString *pattern = @"[0-9]{6}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCodeNumber];
    return isMatch;
}

#pragma 收货人：20位中英文、数字、下划线
+ (BOOL)checkReceiverName:(NSString *)receiverName{
    NSString  *urlRegEx =@"^[a-zA-Z0-9_\u4e00-\u9fa5]{1,20}";
    
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:receiverName];
}

+ (BOOL)checkDetailsAddress:(NSString *)detailsAddress
{
    NSString *regex = @"^[a-zA-Z0-9_\u4e00-\u9fa5 ]{5,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:detailsAddress];
}

+ (BOOL)checkComment:(NSString *)comment
{
    NSString *regex = @"^[a-zA-Z0-9_\u4e00-\u9fa5 ]{1,200}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:comment];
}

+ (BOOL)isValidPostalcode:(NSString *)zip {
    
    NSString *regex = @"[0-9]\\d{5}(?!\\d)";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:zip];
    
}

//座机号码验证
+ (BOOL)validateTelphone:(NSString *)telphone

{
    
    NSString *phoneRegex = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    return [phoneTest evaluateWithObject:telphone];
    
}

+ (BOOL)validateTelphoneNumber:(NSString *)telphone
{
    if (telphone.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^(0[0-9]{2})\\d{8}$|^(0[0-9]{3}(\\d{7,8}))$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if (([regextestmobile evaluateWithObject:telphone] == YES)
        || ([regextestcm evaluateWithObject:telphone] == YES)
        || ([regextestct evaluateWithObject:telphone] == YES)
        || ([regextestcu evaluateWithObject:telphone] == YES)
        || ([regextestphs evaluateWithObject:telphone] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)validateContactNumber:(NSString *)mobileNum{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,177,180,189
     22         */
    NSString * CT = @"^1((33|53|77|8[09])[0-9]|349)\\d{7}$";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if(([regextestmobile evaluateWithObject:mobileNum] == YES)
       || ([regextestcm evaluateWithObject:mobileNum] == YES)
       || ([regextestct evaluateWithObject:mobileNum] == YES)
       || ([regextestcu evaluateWithObject:mobileNum] == YES)
       || ([regextestPHS evaluateWithObject:mobileNum] == YES)){
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL) IsBankCard:(NSString *)cardNumber

{
    
    if(cardNumber.length==0)
        
    {
        
        return NO;
        
    }
    
    NSString *digitsOnly = @"";
    
    char c;
    
    for (int i = 0; i < cardNumber.length; i++)
        
    {
        
        c = [cardNumber characterAtIndex:i];
        
        if (isdigit(c))
            
        {
            
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
            
        }
        
    }
    
    int sum = 0;
    
    int digit = 0;
    
    int addend = 0;
    
    BOOL timesTwo = false;
    
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--)
        
    {
        
        digit = [digitsOnly characterAtIndex:i] - '0';
        
        if (timesTwo)
            
        {
            
            addend = digit * 2;
            
            if (addend > 9) {
                
                addend -= 9;
                
            }
            
        }
        
        else {
            
            addend = digit;
            
        }
        
        sum += addend;
        
        timesTwo = !timesTwo;
        
    }
    
    int modulus = sum % 10;
    
    return modulus == 0;
    
}

/*
 * 公司编号
 *13 或者 15 位字母数字组合
 */
+ (BOOL)checkCompanyNum:(NSString *)companyNum
{
    NSString  *urlRegEx =@"^([a-zA-Z0-9]{15}|[a-zA-Z0-9]{18})";
    
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:companyNum];
    
}

//是否含有表情
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    if ([string length]<2)
    {
        return NO;
    }
    
    static NSCharacterSet *_variationSelectors;
    _variationSelectors = [NSCharacterSet characterSetWithRange:NSMakeRange(0xFE00, 16)];
    
    if ([string rangeOfCharacterFromSet: _variationSelectors].location != NSNotFound)
    {
        return YES;
    }
    const unichar high = [string characterAtIndex:0];
    // Surrogate pair (U+1D000-1F9FF)
    if (0xD800 <= high && high <= 0xDBFF)
    {
        const unichar low = [string characterAtIndex: 1];
        const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
        return (0x1D000 <= codepoint && codepoint <= 0x1F9FF);
        // Not surrogate pair (U+2100-27BF)
    }
    else
    {
        return (0x2100 <= high && high <= 0x27BF);
    }
}


//表情符号的判断
+ (BOOL)stringContainsEmojiE:(NSString *)string {
    
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        if (0x278b <= hs && hs <= 0x2792) {
                                            //自带九宫格拼音键盘
                                            returnValue = NO;;
                                        }else if (0x263b == hs) {
                                            returnValue = NO;;
                                        }else {
                                            returnValue = YES;
                                        }
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}


@end
