//
//  SegmentTypeModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/8.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SegmentTypeModel : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *IDStr;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
