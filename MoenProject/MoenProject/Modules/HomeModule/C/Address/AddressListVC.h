//
//  AddressListVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddressListVCDelegate <NSObject>

@optional

- (void)AddressListVCSelectedDelegate:(NSString *)addressID;

@end

NS_ASSUME_NONNULL_BEGIN

@interface AddressListVC : BaseViewController

@property (nonatomic, strong) id<AddressListVCDelegate> delegate;

/**用户ID*/
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, assign) BOOL isDefault;

@end

NS_ASSUME_NONNULL_END
