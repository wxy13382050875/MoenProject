//
//  StoreActivityListTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "StoreActivityListTCell.h"

@interface StoreActivityListTCell ()

@property (weak, nonatomic) IBOutlet UILabel *activity_Name_Lab;

@property (weak, nonatomic) IBOutlet UILabel *start_Time_Lab;

@property (weak, nonatomic) IBOutlet UILabel *end_Time_Lab;

@property (weak, nonatomic) IBOutlet UILabel *left_Time_Lab;

@property (weak, nonatomic) IBOutlet UILabel *detail_Lab;

@end

@implementation StoreActivityListTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.activity_Name_Lab.font = FONTLanTingR(16);
    self.start_Time_Lab.font = FONTLanTingR(14);
    self.end_Time_Lab.font = FONTLanTingR(14);
    self.left_Time_Lab.font = FONTLanTingR(14);
    self.detail_Lab.font = FONTLanTingR(14);
    // Initialization code
}


- (void)showDataWithStoreActivityDetailModel:(StoreActivityDetailModel *)model
{
    NSArray *timeArr = [model.promoTime componentsSeparatedByString:@"/"];
    if (timeArr.count == 1) {
        self.start_Time_Lab.text = [NSString stringWithFormat:@"开始时间: %@",timeArr[0]];
    }
    else if (timeArr.count == 2)
    {
        self.start_Time_Lab.text = [NSString stringWithFormat:@"开始时间: %@",timeArr[0]];
        self.end_Time_Lab.text = [NSString stringWithFormat:@"结束时间: %@",timeArr[1]];
    }
    self.activity_Name_Lab.text = model.promoName;
    
    
    NSRange startRange = [model.promoDes rangeOfString:@"还"];
    NSRange endRange = [model.promoDes rangeOfString:@"天"];
    if (startRange.location != NSNotFound &&
        endRange.location != NSNotFound) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:model.promoDes];
        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(startRange.location + 2, endRange.location - startRange.location - 2)];
        self.left_Time_Lab.attributedText = str;
    }
    else
    {
        self.left_Time_Lab.text = model.promoDes;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
