//
//  AddressAddVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddressAddVCDelegate <NSObject>

@optional

- (void)AddressAddVCSelectedDelegate:(NSString *)addressID;

@end

NS_ASSUME_NONNULL_BEGIN

@interface AddressAddVC : BaseViewController

@property (nonatomic, strong) id<AddressAddVCDelegate> delegate;

@property (nonatomic, copy) NSString *customerId;
@end

NS_ASSUME_NONNULL_END
