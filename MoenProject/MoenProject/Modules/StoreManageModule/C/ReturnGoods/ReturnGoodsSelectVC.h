//
//  ReturnGoodsSelectVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/16.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ReturnGoodsSelectVCType)
{
    /**部分退货*/
    ReturnGoodsSelectVCTypePart = 0,
    /**整单退货*/
    ReturnGoodsSelectVCTypeAll,
};

NS_ASSUME_NONNULL_BEGIN

@interface ReturnGoodsSelectVC : BaseViewController

/**订单ID*/
@property (nonatomic, copy) NSString *orderID;

@property (nonatomic,assign) ReturnGoodsSelectVCType controllerType;

@end

NS_ASSUME_NONNULL_END
