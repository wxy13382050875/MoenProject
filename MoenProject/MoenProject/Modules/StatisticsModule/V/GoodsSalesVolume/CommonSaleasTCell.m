//
//  CommonSaleasTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CommonSaleasTCell.h"
@interface CommonSaleasTCell()

@property (weak, nonatomic) IBOutlet UILabel *leftTop_Lab;
@property (weak, nonatomic) IBOutlet UILabel *leftBottom_Lab;

@property (weak, nonatomic) IBOutlet UILabel *rightTop_Lab;
@property (weak, nonatomic) IBOutlet UILabel *rightBottom_Lab;

@property (weak, nonatomic) IBOutlet UILabel *rightMiddle_Lab;



@end

@implementation CommonSaleasTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.leftTop_Lab.font = FONTLanTingR(14);
    self.leftBottom_Lab.font = FONTLanTingR(14);
    self.rightTop_Lab.font = FONTLanTingR(14);
    self.rightBottom_Lab.font = FONTLanTingR(14);
    self.rightMiddle_Lab.font = FONTLanTingR(14);
    // Initialization code
}


- (void)showDataWithSCExpandModel:(SCExpandModel *)model
{
    self.leftTop_Lab.text = model.registerDate;
    self.leftBottom_Lab.text = [NSTool handlePhoneNumberFormatWithNumberString:model.account];
    
    self.rightTop_Lab.text = model.sourceChannelEnum;
    if (model.customerType.length > 0 &&
        model.updateUserName.length > 0) {
        self.rightBottom_Lab.text = [NSString stringWithFormat:@"%@:%@",model.customerType,model.updateUserName];
    }
    else
    {
        self.rightBottom_Lab.text = @"";
    }
}


- (void)showDataWithSCExpandCustomerModel:(SCExpandCustomerModel *)model
{
    self.leftTop_Lab.text = [NSTool handleTimeFormatWithTimeString:model.createDate];
    self.leftBottom_Lab.text = [NSTool handlePhoneNumberFormatWithNumberString:model.phone];
    self.rightTop_Lab.text = model.channel;
    self.rightBottom_Lab.text = model.operatePersonal;
}

- (void)showDataWithMajorCustomerModel:(MajorCustomerModel *)model
{
//    self.leftTop_Lab.text = [NSTool handleTimeFormatWithTimeString:model.registerDate];
    self.leftTop_Lab.text = model.registerDate;
    self.leftBottom_Lab.text = model.account;
    self.rightTop_Lab.text = model.specialtyType;
    self.rightBottom_Lab.text = model.custName;
}


- (void)showDataWithGoodsSalesVolumeModel:(GoodsSalesVolumeModel *)model
{
    self.leftTop_Lab.text = model.sku;
    self.leftTop_Lab.font = FontBinB(14);
    self.leftBottom_Lab.text = model.name;
    self.rightMiddle_Lab.font = FontBinB(14);
    self.rightMiddle_Lab.text = model.count;
}

- (void)showDataWithPackageRankModel:(PackageRankModel *)model WithSelectedType:(NSInteger)selectedType
{
    self.leftTop_Lab.text = model.comboCode;
    self.leftBottom_Lab.text = model.comboDescribe;
    [self.rightMiddle_Lab setHidden:NO];
    self.rightMiddle_Lab.text = model.numOrPrice;
    self.leftBottom_Lab.font = FontBinB(14);
    self.leftBottom_Lab.textColor = UIColorFromRGB(0x7B7B7B);
    self.leftTop_Lab.font = FontBinB(14);
    self.rightMiddle_Lab.font = FontBinB(14);
}


- (void)updateCellStyleWithCellType
{
    if (self.cellType == CommonSaleasTCellCustomerInfo) {
        self.leftTop_Lab.font = FontBinB(14);
        self.leftBottom_Lab.font = FontBinB(14);
        
        [self.rightTop_Lab setHidden:NO];
        [self.rightBottom_Lab setHidden:NO];
        
        
        //exaplem
//        self.leftTop_Lab.text = @"2018/10/21 15:38:39";
//        self.leftBottom_Lab.text = @"133 7456 9870";
//        self.rightTop_Lab.text = @"设计师";
//        self.rightBottom_Lab.text = @"刘诗诗";
    }
    else if (self.cellType == CommonSaleasTCellGoodsNumberInfo)
    {
        [self.rightTop_Lab setHidden:YES];
        [self.rightBottom_Lab setHidden:YES];
        [self.rightMiddle_Lab setHidden:NO];
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellType:(CommonSaleasTCellType)cellType
{
    _cellType = cellType;
    [self updateCellStyleWithCellType];
}

@end
