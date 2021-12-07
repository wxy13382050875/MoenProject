//
//  GoodsDetailInfoTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/21.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "GoodsDetailInfoTCell.h"
@interface GoodsDetailInfoTCell()

@property (weak, nonatomic) IBOutlet UILabel *goodCode_Lab;

@property (weak, nonatomic) IBOutlet UILabel *goodName_Lab;

@property (weak, nonatomic) IBOutlet UILabel *goodsPrice_lab;


@end
@implementation GoodsDetailInfoTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showDataWithGoodsDetailModel:(GoodsDetailModel *)model
{
    self.goodCode_Lab.text = model.skuId;
    self.goodName_Lab.text = model.name;
    self.goodsPrice_lab.text = [NSString stringWithFormat:@"¥%@",model.price];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
