//
//  KWConditionSelectTCell.m
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/31.
//

#import "KWConditionSelectTCell.h"

@interface KWConditionSelectTCell()
@property (weak, nonatomic) IBOutlet UILabel *title_Lab;
@property (weak, nonatomic) IBOutlet UIImageView *select_Icon;




@end

@implementation KWConditionSelectTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showDataWithKWCSVDataModel:(KWCSVDataModel *)dataModel
{
    self.title_Lab.text = dataModel.title;
    if (dataModel.isSelected) {
        self.title_Lab.textColor = UIColorFromRGB(0x5B7F95);
    }
    else
    {
        self.title_Lab.textColor = AppTitleBlackColor;
    }
    [self.select_Icon setHidden:!dataModel.isSelected];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
