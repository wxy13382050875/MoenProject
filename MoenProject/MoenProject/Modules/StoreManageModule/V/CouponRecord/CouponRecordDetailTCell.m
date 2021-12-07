//
//  CouponRecordDetailTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/7.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CouponRecordDetailTCell.h"
#import "AwardsDetailModel.h"

@interface CouponRecordDetailTCell()
@property (weak, nonatomic) IBOutlet UILabel *time_Lab;

@property (weak, nonatomic) IBOutlet UILabel *order_code_Lab;

@property (weak, nonatomic) IBOutlet UILabel *orderNumber_Lab;

@property (weak, nonatomic) IBOutlet UILabel *price_Title_Lab;

@property (weak, nonatomic) IBOutlet UILabel *awards_des_Lab;

@property (weak, nonatomic) IBOutlet UILabel *awards_No_Lab;



@property (weak, nonatomic) IBOutlet UILabel *price_Lab;



@end

@implementation CouponRecordDetailTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.time_Lab.font = FontBinB(14);
    self.order_code_Lab.font = FONTLanTingR(14);
    self.orderNumber_Lab.font = FontBinB(14);
    self.price_Title_Lab.font = FONTLanTingR(14);
    self.price_Lab.font = FontBinB(14);
    // Initialization code
}

- (void)showDataWithCouponRecordDetailModel:(CouponRecordDetailModel *)model
{
    self.time_Lab.text = model.date;
    self.orderNumber_Lab.text = model.orderCode;
    self.price_Lab.text = [NSString stringWithFormat:@"¥%@",model.money];
    self.price_Title_Lab.hidden = NO;
    self.awards_des_Lab.hidden = YES;
    self.awards_No_Lab.hidden = YES;
}


- (void)showDataWithAwardsDetailItemModel:(id)data
{
    AwardsDetailItemModel *model = (AwardsDetailItemModel *)data;
    
    self.time_Lab.text = model.rewardDate;
    self.orderNumber_Lab.text = [NSString stringWithFormat:@"%@",model.orderCode];
    self.price_Lab.text = [NSString stringWithFormat:@"¥%@",model.rewardAmount];
//    self.awards_des_Lab.text = model.rewardType;
   self.price_Title_Lab.text = model.productCode;
    
//    self.price_Title_Lab.hidden = YES;
//    self.awards_des_Lab.hidden = NO;
//    self.awards_No_Lab.hidden = NO;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
