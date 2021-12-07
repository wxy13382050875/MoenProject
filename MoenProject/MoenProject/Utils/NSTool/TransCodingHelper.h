//
//  TransCodingHelper.h
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/25.
//

#import <Foundation/Foundation.h>

@interface TransCodingHelper : NSObject

#pragma Mark -- MD5转码
+ (NSString *)md5:(NSString *)str;


+ (NSString *)SHA256:(NSString *)str;

#pragma Mark -- 字符串转Dictionary
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


@end
