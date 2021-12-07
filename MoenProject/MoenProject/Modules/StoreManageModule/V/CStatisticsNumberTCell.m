//
//  CStatisticsNumberTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/6.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CStatisticsNumberTCell.h"
@interface CStatisticsNumberTCell()

@property (weak, nonatomic) IBOutlet UILabel *title_Lab;

@property (weak, nonatomic) IBOutlet UILabel *count_Lab;



@end



@implementation CStatisticsNumberTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title_Lab.font = FONTLanTingR(14);
    self.count_Lab.font = FontBinB(33);
    // Initialization code
}

- (void)showDataWithSCStatisticsModel:(SCStatisticsListModel *)model
{
    self.title_Lab.text = @"门店拓展客户（人数）";
    self.count_Lab.text = [NSString stringWithFormat:@"%ld",(long)model.totalAmount];
}

- (void)showDataWithCountStr:(NSString *)count
{
    self.title_Lab.text = @"专业客户（人数）";
    if (count.length) {
        self.count_Lab.text = [NSString stringWithFormat:@"%@",count];
    }
    else
    {
        self.count_Lab.text = @"";
    }
}

- (void)showDataWithCouponRecordCountStr:(NSString *)count
{
    self.title_Lab.text = @"门店优惠券使用金额（元）";
    if (count.length) {
        self.count_Lab.text = [NSString stringWithFormat:@"%@",count];
    }
    else
    {
        self.count_Lab.text = @"";
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
