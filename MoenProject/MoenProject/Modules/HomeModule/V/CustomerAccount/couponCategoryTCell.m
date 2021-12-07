//
//  couponCategoryTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/9.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "couponCategoryTCell.h"

@interface couponCategoryTCell ()

@property (weak, nonatomic) IBOutlet UILabel *content_Lab;

@end

@implementation couponCategoryTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.content_Lab.font = FONTLanTingR(13);
    // Initialization code
}
- (void)showDataWithString:(NSString *)string
{
    self.content_Lab.text = [NSString stringWithFormat:@"参与活动的品类:%@",string];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
