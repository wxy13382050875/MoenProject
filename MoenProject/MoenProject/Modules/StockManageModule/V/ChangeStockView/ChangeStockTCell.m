//
//  CommonSingleGoodsDarkTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/18.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "ChangeStockTCell.h"
#import "GoodsDetailModel.h"


@interface ChangeStockTCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *differenceReasonLabel;
@property (weak, nonatomic) IBOutlet UITextField *ReasonTextField;
@property (weak, nonatomic) IBOutlet UITextField *changeCountTxt;
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsCount2Label;

@end

@implementation ChangeStockTCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
//    [[[NSBundle mainBundle] loadNibNamed:@"ChangeStockTCell" owner:self options:nil] firstObject];
    // Initialization code
}

- (void)showDataWithGoodsDetailModel:(GoodsDetailModel *)model
{
    self.skuLabel.text = model.skuId;
    self.goodsNameLabel.text = model.name;
    self.changeCountTxt.text = 0;
    self.goodsCountLabel.text = [NSString stringWithFormat:@"x%ld",(long)model.num];
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.imtUrl] placeholderImage:ImageNamed(@"defaultImage")];
    self.ReasonTextField.hidden = YES;
}

-(void)setModel:(Inventorylist *)model{
    self.skuLabel.text = model.goodsSKU;
    self.goodsNameLabel.text = model.goodsName;
//    self.changeCountTxt.text =  0;
    self.goodsCountLabel.text = [NSString stringWithFormat:@"x%@",model.inventoryCount];
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.goodsIMG] placeholderImage:ImageNamed(@"defaultImage")];
    self.differenceReasonLabel.hidden = YES;
    self.changeCountTxt.hidden = YES;
    self.ReasonTextField.hidden = YES;
}
-(void)setLastModel:(Lastgoodslist *)lastModel{
    _lastModel = lastModel;
    [self.changeCountTxt addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.skuLabel.text = _lastModel.goodsSKU;
    
    self.changeCountTxt.text = _lastModel.goodsCountAfter;
    self.goodsCountLabel.text =[NSString stringWithFormat:@"x%@",_lastModel.goodsCountBefor];
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_lastModel.goodsIMG] placeholderImage:ImageNamed(@"defaultImage")];
//    self.differenceReasonLabel.text = _lastModel.reason;
    self.differenceReasonLabel.hidden = YES;
    self.ReasonTextField.text = _lastModel.reason;
}

-(void)setGoodsModel:(Goodslist *)goodsModel{
    _goodsModel = goodsModel;
    [self.changeCountTxt addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.skuLabel.text = _goodsModel.goodsSKU;
    
    self.changeCountTxt.text = _goodsModel.goodsCount;
    self.goodsCountLabel.text =[NSString stringWithFormat:@"x%@",_goodsModel.goodsCountAfter];
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_goodsModel.goodsIMG] placeholderImage:ImageNamed(@"defaultImage")];
    self.differenceReasonLabel.text = _goodsModel.reason;
    self.ReasonTextField.hidden = YES;
}
-(void)textFieldTextChange:(UITextField *)textField{
    NSLog(@"textField1 - 输入框内容改变,当前内容为: %@",textField.text);
    if(textField == self.ReasonTextField){
        self.lastModel.reason = textField.text;
    } else {
        self.lastModel.goodsCountAfter =textField.text;
        self.goodsModel.goodsCount =textField.text;
    }
    
}
@end
