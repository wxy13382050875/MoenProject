//
//  RoleProfileModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/29.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RoleProfileModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, assign) NSInteger skipid;

@property (nonatomic, assign) NSInteger isskip;

@property (nonatomic, assign) BOOL isBage;
@end

NS_ASSUME_NONNULL_END
