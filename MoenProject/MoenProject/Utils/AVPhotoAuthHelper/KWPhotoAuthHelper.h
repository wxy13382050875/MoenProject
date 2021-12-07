//
//  KWPhotoAuthHelper.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/6.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KWPhotoAuthHelper : NSObject

/**
 *  相册或相机是否已授权 type: 1、相机 2、相册
 */
+ (BOOL)isPhotoOrCameraAuthorizedWithType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
