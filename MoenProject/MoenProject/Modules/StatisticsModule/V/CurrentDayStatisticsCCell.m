//
//  CurrentDayStatisticsCCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/10.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CurrentDayStatisticsCCell.h"

@interface CurrentDayStatisticsCCell ()
@property (weak, nonatomic) IBOutlet UIImageView *logo_Img;
@property (weak, nonatomic) IBOutlet UILabel *title_Lab;

@property (weak, nonatomic) IBOutlet UILabel *content_Lab;

@property (weak, nonatomic) IBOutlet UILabel *value_Lab;



@end

@implementation CurrentDayStatisticsCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)showDataWithStatisticsTVModel:(StatisticsTVModel *)model
{
    [self.logo_Img setImage:ImageNamed(model.image)];
    self.title_Lab.text = model.title;
    self.content_Lab.text = model.content;
    
    if (model.contentColor) {
        self.content_Lab.textColor = model.contentColor;
    }
    self.value_Lab.text = model.value;
}
@end
