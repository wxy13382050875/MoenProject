//
//  SelectExchangeGoodsCell.m
//  MoenProject
//
//  Created by 武新义 on 2022/8/19.
//  Copyright © 2022 Kevin Jin. All rights reserved.
//

#import "SelectExchangeGoodsCell.h"
@interface SelectExchangeGoodsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@end

@implementation SelectExchangeGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(GoodslistModel *)model{
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.goodsIMG] placeholderImage:ImageNamed(@"defaultImage")];
    self.skuLabel.text = model.goodsSKU;
    self.goodsNameLabel.text = model.goodsName;
}
@end
