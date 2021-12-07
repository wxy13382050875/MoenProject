//
//  CommonTimeSelectView.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/24.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CommonTimeSelectViewDelegate <NSObject>

@optional

- (void)SearchClickDelegate:(NSString *)startTime WithEndTime:(NSString *)endTime;

@end

@interface CommonTimeSelectView : UIView

@property (nonatomic, strong) id<CommonTimeSelectViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame WithTitleArray:(NSArray *)titleArr;



@end

NS_ASSUME_NONNULL_END
