//
//  ZFMaskView.h
//  ScanBarCode
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZFMaskViewStartDelete <NSObject>

@optional

- (void)ZFMaskViewStartScan;


@end


@interface ZFMaskView : UIView

#pragma mark - public method

@property (nonatomic, strong) id<ZFMaskViewStartDelete> delegate;

/**
 *  移除动画
 */
- (void)removeAnimation;

- (void)stopToScanAction;

@end
