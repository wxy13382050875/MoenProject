//
//  ChangeStoreTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/12/31.
//  Copyright © 2019 Kevin Jin. All rights reserved.
//

#import "ChangeStoreTCell.h"

@interface ChangeStoreTCell()

@property (weak, nonatomic) IBOutlet UILabel *title_Lab;

@property (weak, nonatomic) IBOutlet UIImageView *selected_Icon;

@property (weak, nonatomic) IBOutlet UIView *bg_View;
@end

@implementation ChangeStoreTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)showDataWithUserLoginInfoModel:(UserLoginInfoModel *)model
{
    self.title_Lab.text = model.shopName;
    if (model.isSelected) {
        self.selected_Icon.hidden = NO;
        self.bg_View.backgroundColor = AppBgShoppingCarColor;
    }
    else
    {
        self.selected_Icon.hidden = YES;
        self.bg_View.backgroundColor = UIColorFromRGB(0xF9F9F9);
    }
}
-(void)setWarehouseModel:(UserLoginInfoModel *)warehouseModel{
    self.title_Lab.text = warehouseModel.name;
    if (warehouseModel.isSelected) {
        self.selected_Icon.hidden = NO;
        self.bg_View.backgroundColor = AppBgShoppingCarColor;
    }
    else
    {
        self.selected_Icon.hidden = YES;
        self.bg_View.backgroundColor = UIColorFromRGB(0xF9F9F9);
    }
}
-(void)setModel:(UserLoginInfoModel *)model{
    
    self.title_Lab.text = model.storeName;
    if (model.isSelected) {
        self.selected_Icon.hidden = NO;
        self.bg_View.backgroundColor = AppBgShoppingCarColor;
    }
    else
    {
        self.selected_Icon.hidden = YES;
        self.bg_View.backgroundColor = UIColorFromRGB(0xF9F9F9);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
