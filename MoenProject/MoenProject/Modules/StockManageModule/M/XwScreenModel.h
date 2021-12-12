//
//  XwScreenModel.h
//  MoenProject
//
//  Created by wuxinyi on 2021/12/10.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class KWOSSVDataModel;
@interface XwScreenModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *className;

@property (nonatomic, assign) BOOL showFooter;//是否显示筛选框collectview foot 主要是用来显示时间段
@property (nonatomic, copy) NSArray *list;

@property (nonatomic, copy) NSArray *selectList;

@property (nonatomic, copy) NSString *dateStart;//开始时间
@property (nonatomic, copy) NSString *dateEnd;//开始时间
@end

@interface KWOSSVDataModel:NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *minValue;

@property (nonatomic, copy) NSString *maxValue;

@property (nonatomic, copy) NSString *itemId;

@property (nonatomic, assign) NSInteger statusValue;

@property (nonatomic, assign) BOOL isSelected;


@end

@interface XWSelectModel:NSObject

@property (nonatomic, copy) NSString *module;

@property (nonatomic, copy) NSString *selectID;


@end

NS_ASSUME_NONNULL_END
