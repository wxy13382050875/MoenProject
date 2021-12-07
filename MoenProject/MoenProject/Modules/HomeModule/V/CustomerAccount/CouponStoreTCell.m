//
//  CouponStoreTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/9.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "CouponStoreTCell.h"
@interface CouponStoreTCell()
@property (weak, nonatomic) IBOutlet UILabel *stroe_Lab;

@end

@implementation CouponStoreTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.stroe_Lab.font = FONTLanTingR(13);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
