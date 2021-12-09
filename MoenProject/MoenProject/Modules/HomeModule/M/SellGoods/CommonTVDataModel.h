//
//  CommonTVDataModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/19.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonTVDataModel : MoenBaseModel

@property (nonatomic, copy) NSString *cellIdentify;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) CGFloat cellHeaderHeight;

@property (nonatomic, assign) CGFloat cellFooterHeight;

/**数据展示索引*/
@property (nonatomic, assign) NSInteger dataIndex;

/**数据展示索引*/
@property (nonatomic, strong) id Data;

/**是否展示*/
@property (nonatomic, assign) BOOL isShow;

@end

NS_ASSUME_NONNULL_END
