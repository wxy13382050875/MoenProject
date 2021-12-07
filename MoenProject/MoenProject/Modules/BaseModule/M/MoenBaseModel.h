//
//  MoenBaseModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/27.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoenBaseModel : NSObject

@property (nonatomic, assign) BOOL success;

/** 状态code respCode*/
@property (nonatomic, copy) NSString *code;

/** 状态 respMsg*/
@property (nonatomic,copy) NSString *message;

@property (nonatomic,copy) NSString *jsonStr;

@property (nonatomic,strong) NSDictionary *datas;




#pragma mark -- TableviewCell
//@property (nonatomic, assign) NSInteger KRowsInSection;
//
//@property (nonatomic, copy) NSString *kCellIdentity;
//
//@property (nonatomic, assign) CGFloat kCellHeight;

@end

NS_ASSUME_NONNULL_END
