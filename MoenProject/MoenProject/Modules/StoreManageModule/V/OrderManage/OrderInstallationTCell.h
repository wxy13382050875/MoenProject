//
//  OrderInstallationTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/2/22.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XwOrderDetailModel.h"
static NSString *KOrderInstallationTCell = @"OrderInstallationTCell";
static CGFloat kOrderInstallationTCellH = 40;

NS_ASSUME_NONNULL_BEGIN

@interface OrderInstallationTCell : UITableViewCell
@property(nonatomic,strong)XwOrderDetailModel* model;

- (void)showDataWithDescription:(NSString *)installation;

- (void)showDataWithTitleAndDsc:(NSString *)leftText rightLab:(NSString *)rightText;
@end

NS_ASSUME_NONNULL_END
