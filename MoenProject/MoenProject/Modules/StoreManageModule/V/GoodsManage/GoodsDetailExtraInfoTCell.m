//
//  GoodsDetailExtraInfoTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/21.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "GoodsDetailExtraInfoTCell.h"
@interface GoodsDetailExtraInfoTCell()

@property (weak, nonatomic) IBOutlet UILabel *content_Lab;


@end

@implementation GoodsDetailExtraInfoTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showDataWithString:(NSString *)str
{
    self.content_Lab.text = str;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
