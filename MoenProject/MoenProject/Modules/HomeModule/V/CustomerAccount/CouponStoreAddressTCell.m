//
//  CouponStoreAddressTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/9.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "CouponStoreAddressTCell.h"

@interface CouponStoreAddressTCell ()
@property (weak, nonatomic) IBOutlet UILabel *store_Lab;

@end

@implementation CouponStoreAddressTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.store_Lab.font = FONTLanTingR(13);
    // Initialization code
}

- (void)showDataWithString:(NSString *)string
{
    self.store_Lab.text = string;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
