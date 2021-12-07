//
//  IntentionManageTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/9.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "IntentionManageTCell.h"

@interface IntentionManageTCell()
@property (weak, nonatomic) IBOutlet UILabel *time_Lab;

@property (weak, nonatomic) IBOutlet UIImageView *goods_Img;

@property (weak, nonatomic) IBOutlet UILabel *name_Lab;

@property (weak, nonatomic) IBOutlet UIButton *delete_Btn;


@property (weak, nonatomic) IBOutlet UILabel *code_Lab;




@property (nonatomic, strong) CustomerIntentGoodsModel *dataModel;
@end

@implementation IntentionManageTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.time_Lab.font = FontBinB(14);
    self.name_Lab.font = FONTLanTingR(14);
    self.code_Lab.font = FontBinB(17);
    
    
    
}

- (void)showDataWithCustomerIntentGoodsModel:(CustomerIntentGoodsModel *)model
{
    self.dataModel = model;
    self.time_Lab.text = model.createDate;
    self.code_Lab.text = model.sku;
    self.name_Lab.text = model.name;
    [self.goods_Img sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:ImageNamed(@"defaultImage")];
}

//删除意向商品触发事件
- (IBAction)deleteAction:(UIButton *)sender {
    if (self.deletGoodsBlock) {
        self.deletGoodsBlock(self.dataModel.ID);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
