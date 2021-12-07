//
//  GoodsCategoryRankTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "GoodsCategoryRankTCell.h"

@interface GoodsCategoryRankTCell()

@property (weak, nonatomic) IBOutlet UILabel *name_Lab;
@property (weak, nonatomic) IBOutlet UILabel *number_Lab;



@end




@implementation GoodsCategoryRankTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showDataWithGoodsCategoryRankModel:(GoodsCategoryRankModel *)model
{
    
    // 下划线
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:model.categoryName attributes:attribtDic];
    self.name_Lab.attributedText = attribtStr;
    self.number_Lab.text = model.count;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
