//
//  AddressListItemTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "AddressListItemTCell.h"
@interface AddressListItemTCell()
@property (weak, nonatomic) IBOutlet UILabel *name_Lab;
@property (weak, nonatomic) IBOutlet UILabel *phone_Lab;
@property (weak, nonatomic) IBOutlet UILabel *address_Lab;


@end

@implementation AddressListItemTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.name_Lab.font = FONTLanTingR(14);
    self.phone_Lab.font = FontBinB(14);
    self.address_Lab.font = FONTLanTingR(14);
    // Initialization code
}

- (void)showDataWithAddressInfoModel:(AddressInfoModel *)model
{
    self.name_Lab.text = model.shipPerson;
    
    self.phone_Lab.text = [NSTool handlePhoneNumberFormatWithNumberString:model.shipMobile];
    
    self.address_Lab.text = model.shipAddress;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
