//
//  OrderHeaderTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/7.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "OrderHeaderTCell.h"
@interface OrderHeaderTCell()

@property (weak, nonatomic) IBOutlet UILabel *order_Time_Lab;
@property (weak, nonatomic) IBOutlet UILabel *order_code_Lab;
@property (weak, nonatomic) IBOutlet UILabel *order_maker_Lab;

@property (weak, nonatomic) IBOutlet UILabel *firstTitle_Lab;


@property (weak, nonatomic) IBOutlet UILabel *secondTitle_Lab;
@property (weak, nonatomic) IBOutlet UILabel *thirdTitle_Lab;
@property (weak, nonatomic) IBOutlet UILabel *forthTitle_Lab;
@property (weak, nonatomic) IBOutlet UILabel *phone_Lab;

@end


@implementation OrderHeaderTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.order_Time_Lab.font = FontBinB(14);
    self.order_code_Lab.font = FontBinB(14);
    self.order_maker_Lab.font = FONTLanTingR(14);
    self.firstTitle_Lab.font = FONTLanTingR(14);
    self.secondTitle_Lab.font = FONTLanTingR(14);
    self.thirdTitle_Lab.font = FONTLanTingR(14);
    self.forthTitle_Lab.font = FONTLanTingR(14);
    self.phone_Lab.font = FontBinB(14);
    
}

-(void)setModel:(XwOrderDetailModel *)model{
    self.secondTitle_Lab.text = @"进货单编号：";
    self.order_Time_Lab.text = model.orderTime;
    self.order_code_Lab.text = model.orderID;
    self.order_maker_Lab.text = model.orderRemarks;
    self.phone_Lab.hidden = YES;
    self.forthTitle_Lab.hidden = YES;
//    self.phone_Lab.text = [NSTool handlePhoneNumberFormatWithNumberString:model.account];
}

- (void)showDataWithOrderDetailModel:(OrderDetailModel *)model
{
    self.order_Time_Lab.text = model.createDate;
    self.order_code_Lab.text = model.codeStr;
    self.order_maker_Lab.text = model.createUser;
    self.phone_Lab.text = [NSTool handlePhoneNumberFormatWithNumberString:model.account];
   
}


- (void)showDataWithReturnOrderInfoModel:(ReturnOrderInfoModel *)model
{
    self.order_Time_Lab.text = model.createDate;
    self.order_code_Lab.text = model.orderCode;
    self.order_maker_Lab.text = model.createUser;
    self.phone_Lab.text = model.account;
}


- (void)showDataWithReturnOrderDetailModel:(ReturnOrderDetailModel *)model
{
    self.firstTitle_Lab.text = @"退货单编号：";
    self.secondTitle_Lab.text = @"原订单编号：";
    self.thirdTitle_Lab.text = @"制单人：";
    self.forthTitle_Lab.text = @"客户：";
    
    
    self.order_Time_Lab.text = model.returnCode;
    self.order_code_Lab.text = model.orderCode;
    self.order_maker_Lab.text = model.userName;
    self.phone_Lab.text = model.custCode;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
