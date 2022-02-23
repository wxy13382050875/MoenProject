//
//  HomePageItemCCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/29.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "HomePageItemCCell.h"
@interface HomePageItemCCell()
@property (weak, nonatomic) IBOutlet UIImageView *type_Img;

@property (weak, nonatomic) IBOutlet UILabel *type_Lab;
@property (weak, nonatomic) IBOutlet UIImageView *news_Img;
@property (weak, nonatomic) IBOutlet UIImageView *bage_Img;
@end

@implementation HomePageItemCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (SCREEN_WIDTH==320) {
        self.type_Lab.font = FONTSYS(13);
    }else if (SCREEN_WIDTH==375){
        self.type_Lab.font = FONTSYS(14);
    }else if (SCREEN_WIDTH==540){
        self.type_Lab.font = FONTSYS(15);
    }
    else
    {
        self.type_Lab.font = FONTSYS(16);
    }
    self.bage_Img.hidden = YES;
}

- (void)showDataWithRoleProfileModel:(RoleProfileModel *)model
{
    self.type_Img.image = ImageNamed(model.icon);
    self.type_Lab.text = model.title;
    
    self.bage_Img.hidden = !model.isBage;
}

- (void)showDataWithRoleProfileModel:(RoleProfileModel *)model WithHomeDataModel:(HomeDataModel *)homeModel
{
    self.type_Lab.font = FONTLanTingR(14);
    self.type_Img.image = ImageNamed(model.icon);
    self.type_Lab.text = model.title;
    
    if (homeModel.newCombo && [model.title isEqualToString:@"套餐管理"]) {
        [self.news_Img setHidden:NO];
    }
    else if (homeModel.newPromotion && [model.title isEqualToString:@"门店促销"])
    {
        [self.news_Img setHidden:NO];
    }
    else
    {
        [self.news_Img setHidden:YES];
    }
}

@end
