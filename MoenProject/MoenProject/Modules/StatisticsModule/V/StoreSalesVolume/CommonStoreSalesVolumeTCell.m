//
//  CommonStoreSalesVolumeTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CommonStoreSalesVolumeTCell.h"
@interface CommonStoreSalesVolumeTCell()

@property (weak, nonatomic) IBOutlet UILabel *name_Lab;

@property (weak, nonatomic) IBOutlet UILabel *order_count_Lab;

@property (weak, nonatomic) IBOutlet UILabel *order_price_Lab;

@property (weak, nonatomic) IBOutlet UILabel *single_price_Lab;



@end



@implementation CommonStoreSalesVolumeTCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.name_Lab.font = FONTLanTingR(14);
    self.order_count_Lab.font = FontBinB(14);
    self.order_price_Lab.font = FontBinB(14);
    self.single_price_Lab.font = FontBinB(14);
    // Initialization code
}


- (void)showDataWithStoreSalesVolumeModel:(StoreSalesVolumeModel *)model WithIsToday:(BOOL)isTodayBest
{
    
    if (isTodayBest) {
        self.name_Lab.text = model.shopPersonalName;
        self.name_Lab.textColor = AppTitleBlackColor;
    }
    else
    {
        // 下划线
        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:model.shopPersonalName attributes:attribtDic];
        self.name_Lab.attributedText = attribtStr;
    }
    
    
    self.order_count_Lab.text = model.order;
    self.order_price_Lab.text = model.orderAmount;
    self.single_price_Lab.text = model.customerTransaction;
}


- (void)showDataWithStoreSalesPersonalModel:(StoreSalesPersonalModel *)model
{
    self.name_Lab.font = FontBinB(14);
    self.name_Lab.textColor = AppTitleBlackColor;
    self.name_Lab.text = model.date;
    self.order_count_Lab.text = model.order;
    self.order_price_Lab.text = model.orderAmount;
    self.single_price_Lab.text = model.customerTransaction;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
