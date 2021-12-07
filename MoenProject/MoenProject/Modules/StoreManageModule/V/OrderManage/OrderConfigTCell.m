//
//  OrderConfigTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/7.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "OrderConfigTCell.h"
@interface OrderConfigTCell()

@property (weak, nonatomic) IBOutlet UILabel *isActivity_Lab;
@property (weak, nonatomic) IBOutlet UILabel *isGift_Lab;

@property (weak, nonatomic) IBOutlet UILabel *pickup_Title_Lab;
@property (weak, nonatomic) IBOutlet UILabel *pickup_Lab;

@property (weak, nonatomic) IBOutlet UILabel *shop_Title_Lab;
@property (weak, nonatomic) IBOutlet UILabel *shopping_Lab;

@property (weak, nonatomic) IBOutlet UILabel *pay_Title_Lab;

@property (weak, nonatomic) IBOutlet UILabel *payment_Lab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *delivery_View_constraints;

@end


@implementation OrderConfigTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.isActivity_Lab.font = FONTLanTingR(14);
    self.isGift_Lab.font = FONTLanTingR(14);
    self.pickup_Title_Lab.font = FONTLanTingR(14);
    self.pickup_Lab.font = FONTLanTingR(14);
    self.shop_Title_Lab.font = FONTLanTingR(14);
    self.shopping_Lab.font = FONTLanTingR(14);
    self.pay_Title_Lab.font = FONTLanTingR(14);
    self.payment_Lab.font = FONTLanTingR(14);
    // Initialization code
}

- (void)showDataWithOrderDetailModel:(OrderDetailModel *)model
{
    if (model.isMoen) {
        self.isActivity_Lab.text = @"属于摩恩全国活动";
    }
    else
    {
        self.isActivity_Lab.text = @"不属于摩恩全国活动";
    }
    
    if (model.isFreeGift) {
        self.isGift_Lab.text = @"已赠送礼品";
    }
    else
    {
        self.isGift_Lab.text = @"未赠送礼品";
    }
    
    self.pickup_Lab.text = model.pickUpStatus;
    if (![model.pickUpStatus isEqualToString:@"全部已提"]) {
        self.delivery_View_constraints.constant = 41;
    }
    else
    {
        self.delivery_View_constraints.constant = 0.01;
    }
    self.shopping_Lab.text = model.shoppingMethod;
    self.payment_Lab.text = model.paymentMethod;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
