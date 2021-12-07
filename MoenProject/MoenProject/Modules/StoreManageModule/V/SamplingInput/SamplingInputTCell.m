//
//  SamplingInputTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/6.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "SamplingInputTCell.h"

#import "ShopStaffModel.h"
#import "AwardsStatisticsModel.h"
@interface SamplingInputTCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *leftContent_Lab;

@property (weak, nonatomic) IBOutlet UITextField *rightContent_Txt;

@property (weak, nonatomic) IBOutlet UILabel *rightContent_Lab;

@property (weak, nonatomic) IBOutlet UIImageView *rightDetail_Img;

@property (nonatomic, strong) SamplingSingleModel *dataModel;




@end


@implementation SamplingInputTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.rightContent_Txt.delegate = self;
    
    self.leftContent_Lab.font = FONTLanTingR(14);
    self.rightContent_Txt.font = FONTLanTingR(14);
    self.rightContent_Lab.font = FontBinB(14);
    // Initialization code
}


- (void)showDataWithShopPersonalModel:(ShopPersonalModel *)model
{
    self.leftContent_Lab.text = [NSString stringWithFormat:@"%@(%@)",model.name,model.businessRole];
}


- (void)showDataWithSCStatisticsModel:(SCStatisticsModel *)model
{
    self.leftContent_Lab.text = [NSString stringWithFormat:@"%@",model.month];
    self.rightContent_Lab.text = [NSString stringWithFormat:@"%@",model.num];
}


- (void)showDataWithSamplingSingleModel:(SamplingSingleModel *)model WithEditStatus:(BOOL)isEdit
{
    self.dataModel = model;
    self.leftContent_Lab.text = model.sampleName;
    [self.rightContent_Txt setHidden:NO];
    self.rightContent_Txt.text = [NSString stringWithFormat:@"%ld",(long)model.sampleQuantity];
    [self.rightContent_Txt setEnabled:isEdit];
}


- (void)showDataWithPatrolShopModel:(PatrolShopModel *)model
{
    self.leftContent_Lab.text = model.time;
    self.rightContent_Lab.text = model.result;
    
}

- (void)showDataWithCouponRecordModel:(CouponRecordModel *)model
{
    self.leftContent_Lab.text = model.month;
    self.rightContent_Lab.text = model.numPrice;
}

- (void)showDataWithAwardsMonthDataModel:(id)data
{
    AwardsMonthDataModel *model = (AwardsMonthDataModel *)data;
    self.leftContent_Lab.text = model.month;
    self.rightContent_Lab.text = model.rewardAmount;
}

- (void)showDataShopStaffModel:(id)data
{
    ShopStaffModel *model = (ShopStaffModel *)data;
    self.leftContent_Lab.text = [NSString stringWithFormat:@"%@(%@)",model.name,model.businessRole.des];
}


- (void)updateCellStyleWithCellType
{
    if (self.cellType == SamplingInputTCellForInput) {
        
    }
    else if (self.cellType == SamplingInputTCellForUsedRecord)
    {
        self.leftContent_Lab.font = FontBinB(14);
        self.rightContent_Lab.font = FontBinB(14);
        [self.rightContent_Lab setHidden:NO];
        [self.rightDetail_Img setHidden:NO];
        
        
    }
    else if (self.cellType == SamplingInputTCellForPatrolShop)
    {
        [self.rightContent_Lab setHidden:NO];
        self.rightContent_Lab.textColor = AppTitleBlackColor;
        [self.rightDetail_Img setHidden:NO];
    }
    else
    {
        [self.rightDetail_Img setHidden:NO];
    }
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text integerValue] > 999) {
        textField.text = @"999";
    }
    if (textField == self.rightContent_Txt) {
        self.dataModel.sampleQuantity = [textField.text integerValue];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //限制首位0，后面只能输入.
    if ([textField.text isEqualToString:@""]) {
        if ([string isEqualToString:@"0"]) {
            return NO;
        }
    }
    if (textField.text.length >= 3 && ![string isEqualToString:@""]) {
        return NO;
    }
    //限制只能输入：1234567890.
    NSCharacterSet * characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
    NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- Getter&Setter
- (void)setCellType:(SamplingInputTCellType)cellType
{
    _cellType = cellType;
    [self updateCellStyleWithCellType];
}

@end
