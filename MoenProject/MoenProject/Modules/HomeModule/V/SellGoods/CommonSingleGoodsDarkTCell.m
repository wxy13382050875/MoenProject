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

@property (weak, nonatomic) IBOutlet UIView *editCountView;
@property (weak, nonatomic) IBOutlet UIButton *minus_Btn;
@property (weak, nonatomic) IBOutlet UIButton *add_Btn;
@property (weak, nonatomic) IBOutlet UITextField *count_Txt;
@property (weak, nonatomic) IBOutlet UILabel *returnCount_Lab;

@property (nonatomic, strong) ReturnOrderSingleGoodsModel *singleGoodsModel;


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
    
    
    // Initialization code
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
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"可退%ld件",(long)model.count]];
    [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(2, [NSString stringWithFormat:@"%ld",(long)model.count].length)];
    self.returnCount_Lab.attributedText = str;
    
    self.count_Txt.text = [NSString stringWithFormat:@"%ld",(long)model.returnCount];
    self.count_Txt.keyboardType = UIKeyboardTypeNumberPad;
    
    
}
- (void)showDataWithReturnOrderSingleGoodsModelForReturnAllGoodsCounter:(ReturnOrderSingleGoodsModel *)model
{
    [self.goods_Img sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:ImageNamed(@"defaultImage")];
    self.goods_Code.text = model.sku;
    self.goods_Name.text = model.name;
    [self.goods_Price setHidden:YES];
//    self.goods_Price.text = [NSString stringWithFormat:@"¥%@",model.refundAmount];
    self.goods_Count.text = [NSString stringWithFormat:@"x%ld", (long)model.count];
//    [self.goods_Count setHidden:YES];
}
-(void)setModel:(Goodslist *)model{
    [self.goods_Img sd_setImageWithURL:[NSURL URLWithString:model.goodsIMG] placeholderImage:ImageNamed(@"defaultImage")];
    self.goods_Code.text = model.goodsSKU;
    self.goods_Name.text = model.goodsName;
    [self.goods_Price setHidden:YES];
    [self.goods_Count setHidden:YES];
//    self.goods_Price.text = [NSString stringWithFormat:@"¥%@",model.refundAmount];
//    self.goods_Count.text = [NSString stringWithFormat:@"x%@", model.goodsCount];
}
-(void)setOrderModel:(OrderlistModel *)orderModel{
    [self.goods_Img sd_setImageWithURL:[NSURL URLWithString:orderModel.goodsIMG] placeholderImage:ImageNamed(@"defaultImage")];
    self.goods_Code.text = orderModel.goodsID;
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
    if (self.singleGoodsModel.returnCount == self.singleGoodsModel.count) {
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
            if ([textField.text integerValue] > self.singleGoodsModel.count) {
                textField.text = [NSString stringWithFormat:@"%ld",self.singleGoodsModel.count];
                self.singleGoodsModel.returnCount = self.singleGoodsModel.count;
                [[NSToastManager manager] showtoast:@"商品数量不能超过可退商品数量"];
            }
            else
            {
                self.singleGoodsModel.returnCount = [textField.text integerValue];
            }
    
    }
}
@end
