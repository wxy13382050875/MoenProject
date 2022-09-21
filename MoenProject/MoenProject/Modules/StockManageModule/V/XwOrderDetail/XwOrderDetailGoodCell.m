//
//  XwOrderDetailGoodCell.m
//  MoenProject
//
//  Created by wuxinyi on 2021/12/11.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "XwOrderDetailGoodCell.h"
@interface XwOrderDetailGoodCell ()<UITextFieldDelegate>
@property(nonatomic,strong)UIImageView *goodsImg;
@property(nonatomic,strong)UILabel* goodsCode;
@property(nonatomic,strong)UILabel* goodsName;
@property(nonatomic,strong)UILabel* goodsCount;
@property(nonatomic,strong)UILabel* goodsStatus;
//发货数量
@property(nonatomic,strong)UITextField* deliverCount;

//套餐组合
@property(nonatomic,strong)UIView* packView;
@property(nonatomic,strong)UILabel* goodsPackageDes;
@property(nonatomic,strong)UIImageView* showDetailImage;


//换货商品
@property(nonatomic,strong)UIView* exchangeView;
@property(nonatomic,strong)UILabel* oldProLabel;
@property(nonatomic,strong)UILabel* otherLabel;

@property(nonatomic,assign)BOOL isShowDetail;
@end
@implementation XwOrderDetailGoodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self xw_setupUI];
        [self xw_updateConstraints];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)xw_setupUI{
    [self.contentView addSubview:self.goodsImg];
    [self.contentView addSubview:self.goodsCode];
    [self.contentView addSubview:self.goodsName];
    [self.contentView addSubview:self.goodsCount];
    [self.contentView addSubview:self.goodsStatus];
    
    [self.contentView addSubview:self.deliverCount];
    
    [self.contentView addSubview:self.packView];
    [self.packView addSubview:self.goodsPackageDes];
    [self.packView addSubview:self.showDetailImage];
    [self.packView setHidden:YES];
    
    [self.contentView addSubview:self.exchangeView];
    [self.exchangeView addSubview:self.oldProLabel];
    [self.exchangeView addSubview:self.otherLabel];
    
    [self.exchangeView setHidden:YES];
}
-(void)xw_updateConstraints{
    self.goodsImg.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(self.contentView, 15).widthIs(90).heightIs(90);
    
    self.goodsCode.sd_layout.leftSpaceToView(self.goodsImg, 15).topEqualToView(self.goodsImg).rightSpaceToView(self.contentView, 15).heightIs(30);
    self.goodsName.sd_layout.leftSpaceToView(self.goodsImg, 15).topSpaceToView(self.goodsCode, 0).rightSpaceToView(self.contentView, 15).heightIs(30);
    self.goodsStatus.sd_layout.topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 15).heightIs(30).widthIs(150);
    
    
    self.goodsCount.sd_layout.topSpaceToView(self.goodsName, 0).leftSpaceToView(self.goodsImg, 15).widthIs(100).heightIs(30);
    
    self.deliverCount.sd_layout.topSpaceToView(self.goodsName, 0).rightSpaceToView(self.contentView, 15).heightIs(30).widthIs(150);
    
    
    
    self.packView.sd_layout.leftSpaceToView(self.contentView, 15).rightSpaceToView(self.contentView, 15).bottomEqualToView(self.contentView).heightIs(40);
    
    
    
    self.showDetailImage.sd_layout.rightEqualToView(self.packView).centerYEqualToView(self.packView).widthIs(15).heightIs(10);
    
    self.goodsPackageDes.sd_layout.leftSpaceToView(self.packView, 15).topEqualToView(self.packView).bottomEqualToView(self.packView).rightSpaceToView(self.showDetailImage, 5);
    
    
    self.exchangeView.sd_layout.leftSpaceToView(self.contentView, 15).rightSpaceToView(self.contentView, 15).bottomEqualToView(self.contentView).heightIs(40);
    
    
    self.oldProLabel.sd_layout.leftSpaceToView(self.exchangeView, 0).topEqualToView(self.exchangeView).bottomEqualToView(self.exchangeView).widthIs((SCREEN_WIDTH -30)/2);
    
    self.otherLabel.sd_layout.rightSpaceToView(self.exchangeView, 0).topEqualToView(self.exchangeView).bottomEqualToView(self.exchangeView).widthIs((SCREEN_WIDTH -30)/2);
}
-(void)setModel:(Goodslist *)model{
    self.deliverCount.hidden = YES;
    _model = model;
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.goodsIMG] placeholderImage:ImageNamed(@"defaultImage")];
    self.goodsCode.text = model.goodsSKU;
    self.goodsName.text = model.goodsName;
    self.isShowDetail = model.isShowDetail;
    
//    if(model.orderStatus)
//
    if (model.controllerType == 3||
        model.controllerType == 5||
        model.controllerType == 6) {
        if([model.orderStatus isEqualToString: @"partDeliver"]||
           [model.orderStatus isEqualToString: @"allDeliver"]||
           [model.orderStatus isEqualToString: @"finish"]){
            if(model.sendNum != 0){
                self.goodsStatus.text = model.goodsStatus;
            }
            
        }
    }
    self.goodsCount.text = [NSString stringWithFormat:@"x%@",model.goodsCount];
    if (model.goodsPackage.goodsList.count > 0 ) {//客户换货详情
        
        [self.packView setHidden:NO];
        NSString* strPackageDes=@"";
        for (Goodslist* tmModel in model.goodsPackage.goodsList) {
            strPackageDes = [NSString stringWithFormat:@"%@+%@",strPackageDes,tmModel.goodsSKU];
        }
        self.goodsPackageDes.text = [strPackageDes substringFromIndex:1];
        if (model.isShowDetail) {
            [self.showDetailImage setImage:ImageNamed(@"s_up_pull_btn_icon")];
        }
        else
        {
            [self.showDetailImage setImage:ImageNamed(@"s_show_detail_icon")];
        }
    }
    else
    {
        [self.packView setHidden:YES];
    }

    if(
       model.controllerType == 22||//门店换货详情
       model.controllerType == 23){
           [self.exchangeView setHidden:NO];
           self.oldProLabel.text = [NSString stringWithFormat:@"原有商品:%@",model.oldProduct];
           [self.otherLabel setHidden:NO];
           model.returnCount = @"1";
           if([model.sendCount integerValue]> 0&& [model.returnCount integerValue]> 0){
               self.otherLabel.text = [NSString stringWithFormat:@"已发%@件 已退%@件",model.sendCount,model.returnCount];
           } else if([model.sendCount integerValue]> 0){
               self.otherLabel.text = [NSString stringWithFormat:@"已发%@件",model.sendCount];
           }  else if([model.returnCount integerValue]> 0){
               self.otherLabel.text = [NSString stringWithFormat:@"已退%@件",model.returnCount];
           } else {
               [self.otherLabel setHidden:YES];
           }
           
       } else {
           [self.exchangeView setHidden:YES];
       }
        
    
    
    
}
-(void)setDelModel:(Goodslist *)delModel{
    
    
    
    _delModel = delModel;
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:delModel.goodsIMG] placeholderImage:ImageNamed(@"defaultImage")];
    self.goodsCode.text = delModel.goodsSKU;
    self.goodsName.text = delModel.goodsName;
    self.isShowDetail = delModel.isShowDetail;
    
    
//    self.goodsStatus.text = delModel.goodsStatus;
    self.goodsCount.text = [NSString stringWithFormat:@"x%@",delModel.goodsCount];
    if (delModel.goodsPackage.goodsList.count > 0) {
        
        [self.packView setHidden:NO];
        self.deliverCount.hidden = YES;
        NSString* strPackageDes=@"";
        for (Goodslist* tmModel in delModel.goodsPackage.goodsList) {
            strPackageDes = [NSString stringWithFormat:@"%@ %@",strPackageDes,tmModel.goodsSKU];
        }
        self.goodsPackageDes.text = strPackageDes;
    }
    else
    {
//        self.goodsCount.text = [NSString stringWithFormat:@"x%ld",delModel.notSendNum];
        [self.packView setHidden:YES];
//        self.deliverCount.hidden = NO;
//        [self.deliverCount.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//            NSLog(@"4567 %@",x);
//            lastModel.reason =x;
//        }];
        
        if(delModel.sendNum == 0){
            self.deliverCount.hidden = NO;
        }  else {
            if(delModel.notSendNum == 0){
                self.deliverCount.hidden = YES;
            } else {
                self.deliverCount.hidden = NO;
            }
            [self.goodsStatus setHidden:NO];
            self.goodsStatus.text = delModel.goodsStatus;
        }
    }

    if (delModel.isShowDetail) {
        [self.showDetailImage setImage:ImageNamed(@"s_up_pull_btn_icon")];
    }
    else
    {
        [self.showDetailImage setImage:ImageNamed(@"s_show_detail_icon")];
    }
}
-(UIImageView*)goodsImg{
    if (!_goodsImg) {
        _goodsImg = [UIImageView new];
    }
    return _goodsImg;
}
-(UILabel*)goodsCode{
    if(!_goodsCode){
        _goodsCode = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentLeft WithFont:14];
        _goodsCode.font = [UIFont boldSystemFontOfSize:14];
    }
    return _goodsCode;
}

-(UILabel*)goodsName{
    if(!_goodsName){
        _goodsName = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentLeft WithFont:14];
    }
    return _goodsName;
}
-(UILabel*)goodsCount{
    if(!_goodsCount){
        _goodsCount = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentLeft WithFont:14];
    }
    return _goodsCount;
}
-(UILabel*)goodsStatus{
    if(!_goodsStatus){
        _goodsStatus = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentRight WithFont:14];
        _goodsStatus.font = [UIFont boldSystemFontOfSize:14];
    }
    return _goodsStatus;
}
-(UIView*)packView{
    if(!_packView){
        _packView = [UIView new];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        _packView.userInteractionEnabled = YES;
        [_packView addGestureRecognizer:tap];
    }
    return _packView;;
}
-(UILabel*)goodsPackageDes{
    if(!_goodsPackageDes){
        _goodsPackageDes = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentLeft WithFont:14];
    }
    return _goodsPackageDes;
}
-(UIImageView*)showDetailImage{
    if (!_showDetailImage) {
        _showDetailImage = [UIImageView new];
    }
    return _showDetailImage;
}
-(UIView*)exchangeView{
    if(!_exchangeView){
        _exchangeView = [UIView new];
    }
    return _packView;;
}
-(UILabel*)oldProLabel{
    if(!_oldProLabel){
        _oldProLabel = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentLeft WithFont:14];
    }
    return _oldProLabel;
}

-(UILabel*)otherLabel{
    if(!_otherLabel){
        _otherLabel = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentRight WithFont:14];
    }
    return _otherLabel;
}
-(UITextField*)deliverCount{
    if(!_deliverCount){
        _deliverCount = [UITextField new];
        UILabel* title = [UILabel labelWithText:@"发货数量" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:nil WithTextAlignment:NSTextAlignmentLeft WithFont:14];
        title.frame =CGRectMake(0, 0, 60, 30);
        _deliverCount.leftView = title;
        _deliverCount.leftViewMode = UITextFieldViewModeAlways;
        _deliverCount.textColor = COLOR(@"#646464");
        _deliverCount.font = FONT(14);
        _deliverCount.delegate = self;
        _deliverCount.textAlignment = NSTextAlignmentRight;
        _deliverCount.placeholder=@"请输入数量";
        _deliverCount.keyboardType = UIKeyboardTypeNumberPad;
        
    }
    return _deliverCount;
}
- (void)tapClick {
    if (self.goodsShowDetailBlock) {
        self.goodsShowDetailBlock(!self.isShowDetail);
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.deliverCount == textField) {
            
        if (textField.text.length == 0) {
            textField.text = @"0";
        }
        if ([textField.text integerValue] > self.delModel.notSendNum) {
            textField.text = [NSString stringWithFormat:@"%ld",(long)self.delModel.notSendNum];
            [[NSToastManager manager] showtoast:@"商品数量不能超过可发货商品数量"];
            
        }
        
        self.delModel.deliverCount = textField.text;
    
    }
}
@end
