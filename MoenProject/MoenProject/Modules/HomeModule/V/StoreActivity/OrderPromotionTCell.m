//
//  OrderPromotionTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "OrderPromotionTCell.h"
@interface OrderPromotionTCell()
@property (weak, nonatomic) IBOutlet UILabel *left_Lab;

@property (weak, nonatomic) IBOutlet UILabel *right_Lab;


@end

@implementation OrderPromotionTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.left_Lab.font = FONTLanTingR(14);
    self.right_Lab.font = FontBinB(14);
    // Initialization code
}


- (void)showDataWithCommonGoodsModelForSearch:(CommonGoodsModel *)model
{
    self.left_Lab.text = model.activityName;
    [self.right_Lab setHidden:YES];
}

- (void)showDataWithPromotionInfoModel:(PromotionInfoModel *)model
{
    self.left_Lab.text = model.name;
    self.right_Lab.text = [NSString stringWithFormat:@"￥%@",model.price];
}


- (void)showDataWithOrderAcitvitiesString:(NSString *)activitiesStr WithOrderDerate:(nonnull NSString *)orderDerate
{
    self.left_Lab.text = activitiesStr;
    self.right_Lab.text = orderDerate;
//    [self.right_Lab setHidden:YES];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
