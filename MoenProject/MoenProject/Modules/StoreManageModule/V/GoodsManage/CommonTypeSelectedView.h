//
//  CommonTypeSelectedView.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/21.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^KWCommonTypeSelectedViewBlock)(NSInteger atIndex);
NS_ASSUME_NONNULL_BEGIN

@interface CommonTypeSelectedView : UIView

@property (nonatomic, copy) KWCommonTypeSelectedViewBlock selectBlock;

- (instancetype)initWithFrame:(CGRect)frame WithTitleArray:(NSArray *)titleArr;


- (void)setBtnTitle:(NSString *)title WithBtnIndex:(NSInteger)atIndex;


- (void)defaultAction;
@end

NS_ASSUME_NONNULL_END
