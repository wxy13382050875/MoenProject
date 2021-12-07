//
//  ReturnOrderDetailReasonTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/27.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "ReturnOrderDetailReasonTCell.h"

@interface ReturnOrderDetailReasonTCell()
@property (weak, nonatomic) IBOutlet UILabel *reason_Lab;
@property (weak, nonatomic) IBOutlet UILabel *reason_Title_Lab;

@end

@implementation ReturnOrderDetailReasonTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.reason_Lab.font = FONTLanTingR(14);
    self.reason_Title_Lab.font = FONTLanTingR(14);
    // Initialization code
}

- (void)showDataWithString:(NSString *)reaseon
{
    self.reason_Title_Lab.text = @"退货原因";
    self.reason_Lab.text = reaseon;
}

- (void)showPickupWithString:(NSString *)pickupMethod
{
    self.reason_Title_Lab.text = @"提货";
    self.reason_Lab.text = pickupMethod;
}

- (void)showRefundWithString:(NSString *)refundMethod
{
    self.reason_Title_Lab.text = @"退款方式";
    self.reason_Lab.text = refundMethod;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
