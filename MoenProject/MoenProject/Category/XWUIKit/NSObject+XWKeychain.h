//
//  NSObject+XWKeychain.h
//  XW_Object
//
//  Created by Benc Mai on 2020/8/25.
//  Copyright © 2020 武新义. All rights reserved.
//



#import <Foundation/Foundation.h>

 #import <Security/Security.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (XWKeychain)
+(void)addKeychainData:(id)data forKey:(NSString *)key;//保存
+(id)getKeychainDataForKey:(NSString *)key;//获取
+(void)deleteKeychainDataForKey:(NSString *)key;//删除
@end

NS_ASSUME_NONNULL_END
