//
//  CommonCouponPopView.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/3.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CommonCouponPopViewDelegate <NSObject>

@optional

- (void)selectedCouponDelegate:(NSString *)assetID;

@end


NS_ASSUME_NONNULL_BEGIN

@interface CommonCouponPopView : UIView

/**可使用数据列表*/
@property (nonatomic, strong) NSMutableArray *usableArr;
/**不可使用数据列表*/
@property (nonatomic, strong) NSMutableArray *unavailableArr;

/**当前选择的ID*/
@property (nonatomic, copy) NSString *currentSelectId;



@property (nonatomic, strong) id<CommonCouponPopViewDelegate> delegate;

/**
 分享视图弹窗
 
 @param shareModel 分享的数据
 @param shareContentType 分享类型
 */
-(void)showShareViewWithDXShareModel;





@end

NS_ASSUME_NONNULL_END
