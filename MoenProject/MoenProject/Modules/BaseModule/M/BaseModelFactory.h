//
//  BaseModelFactory.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/27.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoenBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseModelFactory : NSObject

+ (MoenBaseModel *)modelWithURL:(NSString *)url responseJson:(NSDictionary *)jsonDict;

@end

NS_ASSUME_NONNULL_END
