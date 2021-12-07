//
//  KWTypeConditionCCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/8.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "KWTypeConditionCCell.h"
@interface KWTypeConditionCCell()
@property (weak, nonatomic) IBOutlet UIView *bg_View;

@property (weak, nonatomic) IBOutlet UILabel *title_Lab;


@end


@implementation KWTypeConditionCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bg_View.clipsToBounds = YES;
    self.bg_View.layer.borderWidth = 1;
    self.bg_View.layer.cornerRadius = 15;
    // Initialization code
}


- (void)showDataWithSegmentTypeModel:(SegmentTypeModel *)model
{
    self.title_Lab.text = model.name;
    if (model.isSelected) {
        self.bg_View.layer.borderColor = UIColorFromRGB(0xB7C9D3).CGColor;
        self.bg_View.backgroundColor = UIColorFromRGB(0xB7C9D3);
    }
    else
    {
        self.bg_View.layer.borderColor = AppTitleBlueColor.CGColor;
        self.bg_View.backgroundColor = AppBgWhiteColor;
    }
}

- (void)showDataWithKWOSSVDataModel:(KWOSSVDataModel *)model
{
    self.title_Lab.text = model.title;
    if (model.isSelected) {
        self.bg_View.layer.borderColor = AppTitleBlueColor.CGColor;
        self.bg_View.backgroundColor = UIColorFromRGB(0xB7C9D3);
        self.title_Lab.textColor = AppTitleBlueColor;
    }
    else
    {
        self.bg_View.layer.borderColor = UIColorFromRGB(0xF6F6F6).CGColor;
        self.bg_View.backgroundColor = UIColorFromRGB(0xF6F6F6);
        self.title_Lab.textColor = AppTitleBlackColor;
    }
}


- (void)showDataWithSegmentTypeModelForSelectedTag:(SegmentTypeModel *)model
{
    self.bg_View.layer.cornerRadius = 5;
    self.title_Lab.text = model.name;
    if (SCREEN_WIDTH <= 320.0f) {
        self.title_Lab.font = FONTSYS(12);
    }
    else
    {
        self.title_Lab.font = FONTSYS(14);
    }
    if (model.isSelected) {
        self.bg_View.layer.borderColor = AppTitleBlueColor.CGColor;
        self.bg_View.backgroundColor = UIColorFromRGB(0xB7C9D3);
        self.title_Lab.textColor = AppTitleBlueColor;
    }
    else
    {
        self.bg_View.layer.borderColor = UIColor.whiteColor.CGColor;
        self.bg_View.backgroundColor = UIColorFromRGB(0xF6F6F6);
        self.title_Lab.textColor = UIColorFromRGB(0x4E4E4E);
    }
}

@end
