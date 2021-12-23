//
//  XwExpressCell.h
//  MoenProject
//
//  Created by wuxinyi on 2021/12/22.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^InputInfoBlock)(NSString* text);
typedef void(^OpenCameraBlock)();
@interface XwExpressCell : UITableViewCell
@property (nonatomic, copy) InputInfoBlock inputBlock;
@property (nonatomic, copy) OpenCameraBlock openBlock;
@property (nonatomic, copy) NSString* expressIMG;
@end

NS_ASSUME_NONNULL_END
