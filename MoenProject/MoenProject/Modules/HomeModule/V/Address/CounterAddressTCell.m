//
//  CounterAddressTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/20.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CounterAddressTCell.h"
@interface CounterAddressTCell()
@property (weak, nonatomic) IBOutlet UILabel *name_Lab;
@property (weak, nonatomic) IBOutlet UILabel *phone_Lab;
@property (weak, nonatomic) IBOutlet UILabel *address_Lab;
@property (weak, nonatomic) IBOutlet UILabel *add_address_Lab;
@property (weak, nonatomic) IBOutlet UIImageView *add_address_Img;
@property (weak, nonatomic) IBOutlet UIImageView *detail_right_Btn;

@end


@implementation CounterAddressTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.name_Lab.font = FONTLanTingR(14);
    self.address_Lab.font = FONTLanTingR(14);
    self.add_address_Lab.font = FONTLanTingR(15);
    self.phone_Lab.font = FontBinB(14);
    // Initialization code
}


- (void)showDataWithSalesCounterDataModel:(SalesCounterDataModel *)model
{
    if (model.addressId.length == 0) {
        self.add_address_Lab.text = @"选择收货地址";
        [self.add_address_Lab setHidden:NO];
        [self.name_Lab setHidden:YES];
        [self.phone_Lab setHidden:YES];
        [self.address_Lab setHidden:YES];
        [self.add_address_Img setHidden:NO];
    }
    else
    {
        [self.add_address_Lab setHidden:YES];
        [self.add_address_Img setHidden:YES];
        [self.name_Lab setHidden:NO];
        [self.phone_Lab setHidden:NO];
        [self.address_Lab setHidden:NO];
        self.name_Lab.text = model.shipPerson;
        self.phone_Lab.text = [NSTool handlePhoneNumberStarFormatWithNumberString:model.shipMobile];
        self.address_Lab.text = model.shipAddress;
    }
}


- (void)showDataWithOrderDetailModel:(OrderDetailModel *)model
{
    [self.add_address_Lab setHidden:YES];
    [self.add_address_Img setHidden:YES];
    [self.detail_right_Btn setHidden:YES];
    [self.name_Lab setHidden:NO];
    [self.phone_Lab setHidden:NO];
    [self.address_Lab setHidden:NO];
    self.name_Lab.text = model.shipPerson;
    self.phone_Lab.text = [NSTool handlePhoneNumberStarFormatWithNumberString:model.shipMobile];
    self.address_Lab.text = model.shipAddress;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
