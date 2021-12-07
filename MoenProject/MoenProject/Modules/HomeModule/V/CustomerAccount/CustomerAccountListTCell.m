//
//  CustomerAccountListTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CustomerAccountListTCell.h"

@interface CustomerAccountListTCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bg_Img;

@property (weak, nonatomic) IBOutlet UILabel *amount_Lab;

@property (weak, nonatomic) IBOutlet UILabel *amount_des_Lab;

@property (weak, nonatomic) IBOutlet UILabel *explain_Lab;

@property (weak, nonatomic) IBOutlet UILabel *time_Lab;

@property (weak, nonatomic) IBOutlet UILabel *detail_Info_Lab;
@property (weak, nonatomic) IBOutlet UIButton *selected_Btn;

@property (weak, nonatomic) IBOutlet UIButton *detail_Btn;

@property (weak, nonatomic) IBOutlet UIView *reference_View;

@property (weak, nonatomic) IBOutlet UILabel *reference_Title;
@property (weak, nonatomic) IBOutlet UILabel *reference_Lab;




@property (nonatomic, assign) NSInteger atIndex;

@property (nonatomic, assign) BOOL isShowDetail;

@end

@implementation CustomerAccountListTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.amount_Lab.font = FontBinB(32);
    self.time_Lab.font = FontBinB(13);
    
    
    self.amount_des_Lab.font = FONTLanTingR(13);
    self.explain_Lab.font = FONTLanTingR(13);
    self.detail_Info_Lab.font = FONTLanTingR(13);
    
    self.reference_Lab.font = FONTLanTingR(13);
    self.reference_Title.font = FONTLanTingR(13);
    
    self.contentView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedAction)];
    tap.delegate = self;
    [self.contentView addGestureRecognizer:tap];
    

}


- (void)showDataWithCouponInfoModel:(CouponInfoModel *)model WithIsEdit:(BOOL)isEdit AtIndex:(NSInteger)atIndex IsShowRef:(BOOL)isShowRef
{
    self.atIndex = atIndex;
    self.isShowDetail = model.isShowDetail;
    self.amount_Lab.text = model.payValue;
    self.amount_des_Lab.text = [NSString stringWithFormat:@"满%@元可用",model.useCondition];
    self.explain_Lab.text = model.couponType;
    self.time_Lab.text = [NSString stringWithFormat:@"%@-%@",[NSTool handleTimeFormatWithTimeStringTailoring:model.startDate],[NSTool handleTimeFormatWithTimeStringTailoring:model.endDate]];
    [self.selected_Btn setHidden:!isEdit];
    [self.selected_Btn setSelected:model.isSelected];
    
    if ([model.couponType isEqualToString:@"订单优惠"]) {
        [self.bg_Img setImage:ImageNamed(@"c_coupon_yellow_icon")];
    }
    else
    {
        [self.bg_Img setImage:ImageNamed(@"c_coupon_blue_icon")];
    }
    
    if (model.isShowDetail) {
        [self.detail_Btn setImage:ImageNamed(@"c_coupon_detail_up_icon") forState:UIControlStateNormal];
    }
    else
    {
        [self.detail_Btn setImage:ImageNamed(@"c_coupon_detail_down_icon") forState:UIControlStateNormal];
    }
    [self.reference_View setHidden:!isShowRef];
    if (isShowRef) {
        self.reference_Lab.text = model.info;
    }
}

- (void)showDataWithStoreActivityCouponInfoModel:(StoreActivityCouponInfoModel *)model WithIsEdit:(BOOL)isEdit AtIndex:(NSInteger)atIndex
{
    self.atIndex = atIndex;
    self.isShowDetail = model.isShowDetail;
    self.amount_Lab.text = [NSString stringWithFormat:@"%ld",model.couponMoney];
    self.amount_des_Lab.text = model.couponCondition;
    self.explain_Lab.text = model.couponType;
    [self.time_Lab setHidden:YES];
//    self.time_Lab.text = [NSString stringWithFormat:@"%@-%@",[NSTool handleTimeFormatWithTimeStringTailoring:model.startTime],[NSTool handleTimeFormatWithTimeStringTailoring:model.endTime]];
    [self.selected_Btn setHidden:!isEdit];
    [self.selected_Btn setSelected:model.isSelected];
    
    if ([model.couponType isEqualToString:@"订单优惠"]) {
        [self.bg_Img setImage:ImageNamed(@"c_coupon_yellow_icon")];
    }
    else
    {
        [self.bg_Img setImage:ImageNamed(@"c_coupon_blue_icon")];
    }
    
    if (model.isShowDetail) {
        [self.detail_Btn setImage:ImageNamed(@"c_coupon_detail_up_icon") forState:UIControlStateNormal];
    }
    else
    {
        [self.detail_Btn setImage:ImageNamed(@"c_coupon_detail_down_icon") forState:UIControlStateNormal];
    }
}



- (IBAction)selectedAction:(UIButton *)sender {
    if (self.selectedActionBlock) {
        self.selectedActionBlock(0, self.atIndex, !self.isShowDetail);
    }
}

- (void)selectedAction
{
    if (!self.selected_Btn.isHidden) {
        if (self.selectedActionBlock) {
            self.selectedActionBlock(0, self.atIndex, !self.isShowDetail);
        }
    }
}

- (IBAction)detailAction:(UIButton *)sender {
    if (self.selectedActionBlock) {
        self.selectedActionBlock(1, self.atIndex,!self.isShowDetail);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
