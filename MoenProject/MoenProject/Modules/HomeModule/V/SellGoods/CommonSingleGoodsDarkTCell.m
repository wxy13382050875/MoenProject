//
//  CommonSingleGoodsDarkTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/18.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CommonSingleGoodsDarkTCell.h"

@interface CommonSingleGoodsDarkTCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *goods_Img;

@property (weak, nonatomic) IBOutlet UILabel *goods_Code;

@property (weak, nonatomic) IBOutlet UILabel *goods_Name;

@property (weak, nonatomic) IBOutlet UILabel *goods_Price;

@property (weak, nonatomic) IBOutlet UILabel *goods_Count;

@property (weak, nonatomic) IBOutlet UIView *line_View;

@property (weak, nonatomic) IBOutlet UILabel *sendInfo_lab;

@property (weak, nonatomic) IBOutlet UILabel *goods_state;

@property (weak, nonatomic) IBOutlet UIView *editCountView;
@property (weak, nonatomic) IBOutlet UIButton *minus_Btn;
@property (weak, nonatomic) IBOutlet UIButton *add_Btn;
@property (weak, nonatomic) IBOutlet UITextField *count_Txt;
@property (weak, nonatomic) IBOutlet UILabel *returnCount_Lab;

@property (weak, nonatomic) IBOutlet UILabel *goodsPackageDes;

@property (nonatomic, strong) ReturnOrderSingleGoodsModel *singleGoodsModel;

//发货数量
@property(nonatomic,strong)UITextField* deliverCount;
@end

@implementation CommonSingleGoodsDarkTCell

- (void)awakeFromNib {
    [super awakeFromNib];
     self.count_Txt.delegate = self;
    self.goods_Name.font = FONTLanTingR(14);
    self.returnCount_Lab.font = FONTLanTingR(13);
    
    self.goods_Code.font = FontBinB(17);
    self.goods_Price.font = FontBinB(14);
    self.goods_Count.font = FontBinB(14);
    self.count_Txt.font = FontBinB(14);
    self.goodsPackageDes.font = FontBinB(14);
    
    [self.contentView addSubview:self.deliverCount ];
    self.deliverCount.sd_layout.bottomSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 15).heightIs(30).widthIs(150);
    self.deliverCount.hidden = YES;
    // Initialization code
    self.goodsPackageDes.hidden = YES;
}


- (void)showDataWithCommonProdutcModelForSearch:(CommonProdutcModel *)model
{
    
    [self.editCountView setHidden:YES];
    [self.goods_Img sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:ImageNamed(@"defaultImage")];
    self.goods_Code.text = model.sku;
    self.goods_Name.text = model.name;
    self.goods_Price.text = [NSString stringWithFormat:@"¥%@",model.price];
    self.goods_Count.text = [NSString stringWithFormat:@"x%ld",(long)model.count];
    [self.goods_Count setHidden:NO];
    [self.returnCount_Lab setHidden:YES];
    
 
    if([model.waitDeliverCount integerValue] != 0 && model.waitDeliverCount != nil){
        [self.goodsPackageDes setHidden:NO];
        self.goodsPackageDes.textColor = [UIColor redColor];
        self.goodsPackageDes.text = [NSString stringWithFormat:@"总仓预约%@件",model.waitDeliverCount];
        if([model.deliverCount integerValue] != 0 && model.deliverCount != nil){

            self.goodsPackageDes.text = [NSString stringWithFormat:@"%@  已发%@件",self.goodsPackageDes.text,model.deliverCount];
        }
        
    } else {
        if([model.deliverCount integerValue] != 0 && model.deliverCount != nil){
            [self.goodsPackageDes setHidden:NO];
            self.goodsPackageDes.textColor = [UIColor redColor];
            self.goodsPackageDes.text = [NSString stringWithFormat:@"已发%@件",model.deliverCount];
        }
    }
}
- (void)showDataWithStockTransfersForCommonSearch:(CommonProdutcModel *)model
{
    [self.goods_Img sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:ImageNamed(@"defaultImage")];
    self.goods_Code.text = model.sku;
    self.goods_Name.text = model.name;
    self.goods_Price.text = [NSString stringWithFormat:@"x%ld",(long)model.count];
    [self.goods_Count setHidden:YES];
}
- (void)showDataWithCommonProdutcModelForCommonSearch:(CommonProdutcModel *)model
{
    [self.goods_Img sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:ImageNamed(@"defaultImage")];
    self.goods_Code.text = model.sku;
    self.goods_Name.text = model.name;
    self.goods_Price.text = [NSString stringWithFormat:@"¥%@",model.price];
    self.goods_Count.text = [NSString stringWithFormat:@"x%ld",(long)model.count];
    [self.goods_Count setHidden:NO];
}

- (void)showDataWithStoreActivityMealProductsModel:(StoreActivityMealProductsModel *)model
{
    [self.goods_Img sd_setImageWithURL:[NSURL URLWithString:model.productImageUrl] placeholderImage:ImageNamed(@"defaultImage")];
    self.goods_Code.text = model.productSku;
    self.goods_Name.text = model.productName;
    [self.goods_Price setHidden:YES];
    self.goods_Count.text = [NSString stringWithFormat:@"x%ld",(long)model.count];
    [self.goods_Count setHidden:NO];
}
- (void)showDataWithOrderManageModelForReturn:(OrderManageModel *)model
{
    OrderItemInfoModel *goodsModel = model.productList[0];
    [self.goods_Img sd_setImageWithURL:[NSURL URLWithString:goodsModel.photo] placeholderImage:ImageNamed(@"defaultImage")];
    self.goods_Code.text = goodsModel.sku;
    self.goods_Name.text = goodsModel.name;
    
    [self.goods_Price setHidden:YES];
    [self.goods_Count setHidden:YES];
}

- (void)showDataWithOrderManageModel:(OrderManageModel *)model
{
    
    OrderItemInfoModel *goodsModel = model.orderItemInfos[0];
    [self.goods_Img sd_setImageWithURL:[NSURL URLWithString:goodsModel.photo] placeholderImage:ImageNamed(@"defaultImage")];
    self.goods_Code.text = goodsModel.codeStr;
    self.goods_Name.text = goodsModel.name;
    
    [self.goods_Price setHidden:YES];
    [self.goods_Count setHidden:YES];
}

- (void)showDataWithIntentionProductModel:(IntentionProductModel *)model
{
    self.line_View.backgroundColor = AppBgBlueGrayColor;
    self.contentView.backgroundColor = AppBgWhiteColor;
    
    [self.goods_Img sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:ImageNamed(@"defaultImage")];
    self.goods_Code.text = model.sku;
    self.goods_Name.text = model.name;
    self.goods_Price.text = [NSString stringWithFormat:@"¥%@",model.price];
    [self.goods_Count setHidden:YES];
    
}

- (void)showDataWithReturnOrderSingleGoodsModel:(ReturnOrderSingleGoodsModel *)model
{
    [self.goods_Img sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:ImageNamed(@"defaultImage")];
    self.goods_Code.text = model.sku;
    self.goods_Name.text = model.name;
    self.goods_Price.text = [NSString stringWithFormat:@"¥%@",model.refundAmount];
    [self.goods_Count setHidden:YES];
}

- (void)showDataWithReturnOrderSingleGoodsModelForReturnSelected:(ReturnOrderSingleGoodsModel *)model
{
    self.goods_state.font = [UIFont boldSystemFontOfSize:14];
    self.singleGoodsModel = model;
    [self.goods_Img sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:ImageNamed(@"defaultImage")];
    self.goods_Code.text = model.sku;
    self.goods_Name.text = model.name;
    self.goods_Price.text = [NSString stringWithFormat:@"¥%@",model.refundAmount];
    [self.goods_Count setHidden:YES];
    
    if([QZLUserConfig sharedInstance].useInventory){
        self.sendInfo_lab.hidden = NO;
        self.sendInfo_lab.text = model.sendInfo;
    } else {
        self.sendInfo_lab.hidden = YES;
    }
    [self.editCountView setHidden:NO];
    [self.returnCount_Lab setHidden:NO];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"可退%ld件",(long)model.canReturnCount]];
    [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(2, [NSString stringWithFormat:@"%ld",(long)model.canReturnCount].length)];
    self.returnCount_Lab.attributedText = str;
    
    self.count_Txt.text = [NSString stringWithFormat:@"%ld",(long)model.returnCount];
    self.count_Txt.keyboardType = UIKeyboardTypeNumberPad;
    if([model.waitDeliverCount integerValue] != 0 && model.waitDeliverCount != nil){
        [self.goodsPackageDes setHidden:NO];
        self.goodsPackageDes.textColor = [UIColor redColor];
        self.goodsPackageDes.text = [NSString stringWithFormat:@"总仓预约%@件",model.waitDeliverCount];
        if([model.deliverCount integerValue] != 0 && model.deliverCount != nil){

            self.goodsPackageDes.text = [NSString stringWithFormat:@"%@  已发%@件",self.goodsPackageDes.text,model.deliverCount];
        }
        NSMutableAttributedString *tmStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%ld件,可退%ld件",(long)model.count,(long)model.canReturnCount]];
        [tmStr addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(2, [NSString stringWithFormat:@"%ld",(long)model.canReturnCount].length)];
        self.returnCount_Lab.attributedText = tmStr;
    } else {
        if([model.deliverCount integerValue] != 0 && model.deliverCount != nil){
            [self.goodsPackageDes setHidden:NO];
            self.goodsPackageDes.textColor = [UIColor redColor];
            self.goodsPackageDes.text = [NSString stringWithFormat:@"已发%@件",model.deliverCount];
        }
    }
    
    
}
- (void)showDataWithReturnOrderSingleGoodsModelForReturnAllGoodsCounter:(ReturnOrderSingleGoodsModel *)model
{
    [self.goodsPackageDes setHidden:YES];
    [self.goods_Img sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:ImageNamed(@"defaultImage")];
    self.goods_Code.text = model.sku;
    self.goods_Name.text = model.name;
    [self.goods_Price setHidden:YES];
//    self.goods_Price.text = [NSString stringWithFormat:@"¥%@",model.refundAmount];
    self.goods_Count.text = [NSString stringWithFormat:@"x%ld", (long)model.count];
//    [self.goods_Count setHidden:YES];
    [self.goods_state setHidden:YES];
    self.goods_state.font = [UIFont boldSystemFontOfSize:14];
    if([model.waitDeliverCount integerValue] != 0 && model.waitDeliverCount != nil){
            [self.goodsPackageDes setHidden:NO];
            self.goodsPackageDes.textColor = [UIColor redColor];
            self.goodsPackageDes.text = [NSString stringWithFormat:@"总仓预约%@件",model.waitDeliverCount];
            if([model.deliverCount integerValue] != 0 && model.deliverCount != nil){
                self.goodsPackageDes.text = [NSString stringWithFormat:@"%@ 已发%@件",self.goodsPackageDes.text,model.deliverCount];
            }
        } else {
            if([model.deliverCount integerValue] != 0 && model.deliverCount != nil){
                [self.goodsPackageDes setHidden:NO];
                self.goodsPackageDes.textColor = [UIColor redColor];
                self.goodsPackageDes.text = [NSString stringWithFormat:@"已发%@件",model.deliverCount];
            } 
        }
    
}
-(void)setModel:(Goodslist *)model{
    [self.goods_Img sd_setImageWithURL:[NSURL URLWithString:model.goodsIMG] placeholderImage:ImageNamed(@"defaultImage")];
    self.goods_Code.text = model.goodsSKU;
    self.goods_Name.text = model.goodsName;
//
    [self.goods_Count setHidden:YES];
    self.goods_Price.text = [NSString stringWithFormat:@"X%@",model.goodsCount];
    
//    self.goods_Count.text = [NSString stringWithFormat:@"x%@", model.goodsCount];
    if (model.controllerType == 3||
        model.controllerType == 5||
        model.controllerType == 6) {
        if([model.orderStatus isEqualToString: @"partDeliver"]||
           [model.orderStatus isEqualToString: @"allDeliver"]||
           [model.orderStatus isEqualToString: @"finish"]){
            if(model.sendNum != 0){
                [self.goods_state setHidden:NO];
                
                self.goods_state.font = [UIFont boldSystemFontOfSize:14];
                self.goods_state.text = model.goodsStatus;
            }
            
        }
    } else {
        [self.goods_Price setHidden:YES];
    }
    
}
-(void)setDelModel:(Goodslist *)delModel{
    
    _delModel = delModel;
    [self.goods_Img sd_setImageWithURL:[NSURL URLWithString:delModel.goodsIMG] placeholderImage:ImageNamed(@"defaultImage")];
    self.goods_Code.text = delModel.goodsSKU;
    self.goods_Name.text = delModel.goodsName;
//
    [self.goods_Count setHidden:YES];
    self.goods_Price.text = [NSString stringWithFormat:@"X%@",delModel.goodsCount];
    
    if(delModel.sendNum == 0){
        self.deliverCount.hidden = NO;
    }  else {
        if(delModel.notSendNum == 0){
            self.deliverCount.hidden = YES;
        } else {
            self.deliverCount.hidden = NO;
        }
        [self.goods_state setHidden:NO];
        self.goods_state.font = [UIFont boldSystemFontOfSize:14];
        self.goods_state.text = delModel.goodsStatus;
    }
//    self.goods_Count.text = [NSString stringWithFormat:@"x%@", model.goodsCount];
    if (delModel.controllerType == 3||
        delModel.controllerType == 5||
        delModel.controllerType == 6) {
//        if([delModel.orderStatus isEqualToString: @"partDeliver"]||[delModel.orderStatus isEqualToString: @"allDeliver"]){
//
//        }
    } else {
        [self.goods_Price setHidden:YES];
    }
//    if(delModel.goodsStatus != nil){
//        [self.goods_Count setHidden:NO];
//        self.goods_Count.font = [UIFont boldSystemFontOfSize:14];
//        self.goods_Count.text = delModel.goodsStatus;
//    } else {
//        [self.goods_Count setHidden:YES];
//    }
}
-(void)setOrderModel:(OrderlistModel *)orderModel{
    [self.goods_Img sd_setImageWithURL:[NSURL URLWithString:orderModel.goodsIMG] placeholderImage:ImageNamed(@"defaultImage")];
    self.goods_Code.text = orderModel.goodsName;
    self.goods_Name.text = orderModel.goodsSKU;
    [self.goods_Price setHidden:YES];
//    self.goods_Price.text = [NSString stringWithFormat:@"¥%@",model.refundAmount];
    self.goods_Count.text = [NSString stringWithFormat:@"x%@", orderModel.goodsCount];
}
-(void)setStockInfoModel:(XwStockInfoModel *)stockInfoModel{
    [self.goods_Img sd_setImageWithURL:[NSURL URLWithString:stockInfoModel.goodsImg] placeholderImage:ImageNamed(@"defaultImage")];
    self.goods_Code.text = stockInfoModel.goodsSKU;
    self.goods_Name.text = stockInfoModel.goodsName;
    self.goods_Count.hidden = YES;
    self.goods_Price.text = [NSString stringWithFormat:@"x%@", stockInfoModel.num];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)goodsMinusAction:(UIButton *)sender {
    if (self.singleGoodsModel.returnCount == 0) {
        return;
    }
    else
    {
        self.singleGoodsModel.returnCount -= 1;
        self.count_Txt.text = [NSString stringWithFormat:@"%ld",(long)self.singleGoodsModel.returnCount];
    }
}
- (IBAction)goodsAddAction:(UIButton *)sender {
    if (self.singleGoodsModel.returnCount == self.singleGoodsModel.canReturnCount) {
        return;
    }
    else
    {
        self.singleGoodsModel.returnCount += 1;
        self.count_Txt.text = [NSString stringWithFormat:@"%ld",(long)self.singleGoodsModel.returnCount];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.count_Txt == textField) {
            if (textField.text.length == 0) {
                textField.text = @"0";
            }
            if ([textField.text integerValue] > self.singleGoodsModel.canReturnCount) {
                textField.text = [NSString stringWithFormat:@"%ld",self.singleGoodsModel.canReturnCount];
                self.singleGoodsModel.returnCount = self.singleGoodsModel.canReturnCount;
                [[NSToastManager manager] showtoast:@"商品数量不能超过可退商品数量"];
            }
            else
            {
                self.singleGoodsModel.returnCount = [textField.text integerValue];
            }
    
    } else if (self.deliverCount == textField) {
        
        if (textField.text.length == 0) {
            textField.text = @"0";
        }
        if ([textField.text integerValue] > self.delModel.notSendNum) {
            textField.text = [NSString stringWithFormat:@"%ld",self.delModel.notSendNum];
            [[NSToastManager manager] showtoast:@"商品数量不能超过可发货商品数量"];
            
        }
        
        self.delModel.deliverCount = textField.text;
    
    }
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
@end
