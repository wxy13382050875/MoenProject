//
//  CommonSingleGoodsTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/14.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CommonSingleGoodsTCell.h"
#import "CommonGoodsModel.h"
#import "UIButton+ClickDamping.h"


@interface CommonSingleGoodsTCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;

@property (weak, nonatomic) IBOutlet UILabel *goodsCode;

@property (weak, nonatomic) IBOutlet UILabel *goodsSquare;


@property (weak, nonatomic) IBOutlet UILabel *goodsName;

@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;

@property (weak, nonatomic) IBOutlet UILabel *goodsCount;

@property (weak, nonatomic) IBOutlet UILabel *goodsPackageDes;

@property (weak, nonatomic) IBOutlet UIButton *goodsPackageDetailBtn;

@property (weak, nonatomic) IBOutlet UIButton *goodsSelectBtn;


@property (weak, nonatomic) IBOutlet UIView *editCountView;
@property (weak, nonatomic) IBOutlet UIButton *minus_Btn;
@property (weak, nonatomic) IBOutlet UIButton *add_Btn;

@property (weak, nonatomic) IBOutlet UITextField *count_Txt;

@property (weak, nonatomic) IBOutlet UILabel *returnCount_Lab;

@property (weak, nonatomic) IBOutlet UIView *bottom_Line_View;


@property (nonatomic, strong) CommonGoodsModel *dataModel;

@property (nonatomic, assign) BOOL isShowDetail;

@property (nonatomic, assign) NSInteger atIndex;

@property (nonatomic, assign) CommonSingleGoodsTCellType cellType;


@property (nonatomic, strong) ReturnOrderMealGoodsModel *mealGoodsModel;


@end

@implementation CommonSingleGoodsTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.count_Txt.delegate = self;
    
    
    
    self.goodsCode.font = FontBinB(17);
    self.goodsPrice.font = FontBinB(14);
    self.goodsCount.font = FontBinB(14);
    self.goodsSquare.font = FontBinB(14);
    self.goodsPackageDes.font = FontBinB(14);
    self.count_Txt.font = FontBinB(13);
    
    self.returnCount_Lab.font = FONTLanTingR(13);
    self.goodsName.font = FONTLanTingR(14);
    
    self.add_Btn.eventTimeInterval = 0.1;
    self.minus_Btn.eventTimeInterval = 0.1;
    
}

- (void)showDataWithModel:(id)dataModel withAtIndex:(NSInteger)atIndex
{
    self.dataModel = (CommonGoodsModel *)dataModel;
    self.isShowDetail = self.dataModel.isShowDetail;
    
    
    [self handleCellLayoutWithModel:self.dataModel];
    self.goodsCode.text = self.dataModel .code;
    self.goodsName.text = self.dataModel .name;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@",self.dataModel .price];
}
-(void)setModel:(Goodslist *)model{
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.goodsIMG] placeholderImage:ImageNamed(@"defaultImage")];
    self.goodsCode.text = model.goodsID;
    self.goodsName.text = model.goodsName;
//    [self.goodsPrice setHidden:YES];
    self.goodsPrice.text = model.goodsCount;
    self.atIndex = model.indexPath.section;
    self.isShowDetail = model.isShowDetail;
    self.goodsCount.text = model.goodsStatus;
//    self.editCountView.hidden = YES;
    if (model.goodsPackage.goodsList.count > 0) {
        [self.goodsPackageDes setHidden:NO];
        [self.goodsPackageDetailBtn setHidden:NO];
        NSString* strPackageDes=@"";
        for (Goodslist* tmModel in model.goodsPackage.goodsList) {
            strPackageDes = [NSString stringWithFormat:@"%@ %@",strPackageDes,tmModel.goodsID];
        }
        self.goodsPackageDes.text = strPackageDes;
    }
    else
    {
        [self.goodsPackageDes setHidden:YES];
        [self.goodsPackageDetailBtn setHidden:YES];
    }
    
    if (model.isShowDetail) {
        [self.goodsPackageDetailBtn setImage:ImageNamed(@"s_up_pull_btn_icon") forState:UIControlStateNormal];
    }
    else
    {
        [self.goodsPackageDetailBtn setImage:ImageNamed(@"s_show_detail_icon") forState:UIControlStateNormal];
    }
    
}
-(void)setInventoryModel:(Inventorylist *)inventoryModel{
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:inventoryModel.goodsIMG] placeholderImage:ImageNamed(@"defaultImage")];
    self.goodsCode.text = inventoryModel.goodsSKU;
    self.goodsName.text = inventoryModel.goodsName;
    [self.goodsPrice setHidden:YES];
    self.goodsCount.text = inventoryModel.inventoryCount;
    [self.goodsCount setHidden:NO];
    self.goodsCount.textColor = [UIColor redColor];

}
- (void)handleCellLayoutWithModel:(CommonGoodsModel *)model
{
    if (model.isSetMeal) {
        [self.goodsPackageDes setHidden:NO];
        [self.goodsPackageDetailBtn setHidden:NO];
        if (model.isShowDetail) {
            [self.goodsPackageDetailBtn setImage:ImageNamed(@"s_up_pull_btn_icon") forState:UIControlStateNormal];
        }
        else
        {
            [self.goodsPackageDetailBtn setImage:ImageNamed(@"s_show_detail_icon") forState:UIControlStateNormal];
        }
    }
    else
    {
        [self.goodsPackageDes setHidden:YES];
        [self.goodsPackageDetailBtn setHidden:YES];
    }
}

- (void)showDataWithCommonGoodsModel:(CommonGoodsModel *)model AtIndex:(NSInteger)atIndex WihtControllerType:(NSInteger)controllerType
{
    self.dataModel = model;
    self.isShowDetail = model.isShowDetail;
    self.atIndex = atIndex;
    [self handleCellLayoutWithModel:self.dataModel];

    
    
    self.goodsCode.text = self.dataModel.code;
    self.goodsName.text = self.dataModel.name;
//    self.goodsPrice.text = [NSString stringWithFormat:@"X%ld",self.dataModel.kGoodsCount];;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@",self.dataModel.price];
//    self.goodsPackageDes.text = self.dataModel.comboDescribe;
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:self.dataModel.photo] placeholderImage:ImageNamed(@"defaultImage")];
    
    if (self.dataModel.productList.count > 0) {
        [self.goodsPackageDes setHidden:NO];
        [self.goodsPackageDetailBtn setHidden:NO];
        NSString* strPackageDes=@"";
        for (CommonProdutcModel* tmModel in self.dataModel.productList) {
            strPackageDes = [NSString stringWithFormat:@"%@+%@",strPackageDes,tmModel.sku];
        }
        self.goodsPackageDes.text = [strPackageDes substringFromIndex:1];
    }
    
    
    if (controllerType == 1) {
        [self.goodsSelectBtn setHidden:YES];
//        [self.goodsPrice setHidden:YES];
        self.goodsPrice.text =[NSString stringWithFormat:@"X%ld",self.dataModel.kGoodsCount];;
    }
    else if (controllerType == 2) {
        [self.goodsPrice setHidden:YES];
        [self.goodsSelectBtn setHidden:NO];
    }
    else
    {
        if(controllerType == 3){
            [self.goodsPrice setHidden:YES];
        }
        [self.goodsSelectBtn setHidden:NO];
    }
    
    if (self.dataModel.isShowDetail) {
        [self.goodsPackageDetailBtn setImage:ImageNamed(@"s_up_pull_btn_icon") forState:UIControlStateNormal];
    }
    else
    {
        [self.goodsPackageDetailBtn setImage:ImageNamed(@"s_show_detail_icon") forState:UIControlStateNormal];
    }
}
//无商品价格
- (void)showDataWithStockTransfersForSell:(CommonGoodsModel *)model AtIndex:(NSInteger)atIndex {
    self.dataModel = model;
    self.isShowDetail = model.isShowDetail;
    self.atIndex = atIndex;
    //设置是否是套餐商品的特殊显示元素
    [self handleCellLayoutWithModel:self.dataModel];
    self.goodsCode.text = self.dataModel.code;
    self.goodsName.text = self.dataModel.name;
    self.goodsPrice.hidden = YES;
//    if(self.dataModel.price == nil){
//        self.goodsPrice.hidden = YES;
//    }
//    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@",self.dataModel.price];
    self.goodsPackageDes.text = self.dataModel.comboDescribe;
    [self.editCountView setHidden:NO];
    if (self.dataModel.isSpecial) {
        self.count_Txt.keyboardType = UIKeyboardTypeDecimalPad;
        self.count_Txt.text = [NSString stringWithFormat:@"%.3f",self.dataModel.kGoodsArea];
    }
    else
    {
        self.count_Txt.keyboardType = UIKeyboardTypeNumberPad;
        self.count_Txt.text = [NSString stringWithFormat:@"%ld",(long)self.dataModel.kGoodsCount];
    }
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:ImageNamed(@"defaultImage")];
}
//调库单
- (void)showDataWithStockLibraryForSell:(CommonGoodsModel *)model AtIndex:(NSInteger)atIndex {
    self.dataModel = model;
    self.isShowDetail = model.isShowDetail;
    self.atIndex = atIndex;
    //设置是否是套餐商品的特殊显示元素
    [self handleCellLayoutWithModel:self.dataModel];
    self.goodsCode.text = self.dataModel.code;
    self.goodsName.text = self.dataModel.name;
    self.goodsPrice.hidden = YES;
//    if(self.dataModel.price == nil){
//        self.goodsPrice.hidden = YES;
//    }
//    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@",self.dataModel.price];
    self.goodsPackageDes.text = self.dataModel.comboDescribe;
    [self.editCountView setHidden:YES];
    if (self.dataModel.isSpecial) {
        self.count_Txt.keyboardType = UIKeyboardTypeDecimalPad;
        self.count_Txt.text = [NSString stringWithFormat:@"%.3f",self.dataModel.kGoodsArea];
    }
    else
    {
        self.count_Txt.keyboardType = UIKeyboardTypeNumberPad;
        self.count_Txt.text = [NSString stringWithFormat:@"%ld",(long)self.dataModel.kGoodsCount];
    }
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:ImageNamed(@"defaultImage")];
}
- (void)showDataWithCommonGoodsModelForSell:(CommonGoodsModel *)model AtIndex:(NSInteger)atIndex WithIsEditNumberType:(BOOL)isEditNumber
{
    self.dataModel = model;
    self.isShowDetail = model.isShowDetail;
    self.atIndex = atIndex;
    //设置是否是套餐商品的特殊显示元素
    [self handleCellLayoutWithModel:self.dataModel];
    self.goodsCode.text = self.dataModel.code;
    self.goodsName.text = self.dataModel.name;
    if(self.dataModel.price == nil){
        self.goodsPrice.hidden = YES;
    }
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@",self.dataModel.price];
    self.goodsPackageDes.text = self.dataModel.comboDescribe;
    [self.editCountView setHidden:!isEditNumber];
    if (self.dataModel.isSpecial) {
        self.count_Txt.keyboardType = UIKeyboardTypeDecimalPad;
        self.count_Txt.text = [NSString stringWithFormat:@"%.3f",self.dataModel.kGoodsArea];
    }
    else
    {
        self.count_Txt.keyboardType = UIKeyboardTypeNumberPad;
        self.count_Txt.text = [NSString stringWithFormat:@"%ld",(long)self.dataModel.kGoodsCount];
    }
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:ImageNamed(@"defaultImage")];
}

//
- (void)showDataWithCommonGoodsModelForGift:(CommonGoodsModel *)model AtIndex:(NSInteger)atIndex
{
    self.cellType = CommonSingleGoodsTCellTypeSellCounter;
    self.dataModel = model;
    self.isShowDetail = model.isShowDetail;
    self.atIndex = atIndex;
    
    //设置是否是套餐商品的特殊显示元素
    [self handleCellLayoutWithModel:self.dataModel];
    self.goodsCode.text = self.dataModel.gcode;
    self.goodsName.text = self.dataModel.name;
    if (model.isSpecial) {
        [self.goodsSquare setHidden:NO];
        self.goodsSquare.text = [NSString stringWithFormat:@"%.3f平方",model.kGoodsArea];
        [self.editCountView setHidden:NO];
        self.count_Txt.keyboardType = UIKeyboardTypeNumberPad;
        self.count_Txt.text = [NSString stringWithFormat:@"%ld",self.dataModel.kGoodsCount];
        [self.goodsCount setHidden:YES];
    }
    else
    {
        [self.goodsSquare setHidden:YES];
        [self.editCountView setHidden:YES];
        [self.goodsCount setHidden:NO];
    }
    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥0  ￥%@",self.dataModel .price]];
    [str addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(4, self.dataModel .price.length + 1)];
    self.goodsPrice.attributedText = str;
//    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@",self.dataModel .price];
    
    
    
    
    self.goodsPackageDes.text = self.dataModel.comboDescribe;
    [self.goodsCount setHidden:NO];
    self.goodsCount.text = [NSString stringWithFormat:@"x%ld",(long)self.dataModel.kGoodsCount];
     [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:ImageNamed(@"defaultImage")];
}

- (void)showDataWithCommonGoodsModelForSalesCounter:(CommonGoodsModel *)model AtIndex:(NSInteger)atIndex
{
    self.cellType = CommonSingleGoodsTCellTypeSellCounter;
    self.dataModel = model;
    self.isShowDetail = model.isShowDetail;
    self.atIndex = atIndex;
    
    //设置是否是套餐商品的特殊显示元素
    [self handleCellLayoutWithModel:self.dataModel];
    self.goodsCode.text = self.dataModel.gcode;
    self.goodsName.text = self.dataModel.name;
    if (model.isSpecial) {
        [self.goodsSquare setHidden:NO];
        self.goodsSquare.text = [NSString stringWithFormat:@"%.3f平方",model.kGoodsArea];
        [self.editCountView setHidden:NO];
        self.count_Txt.keyboardType = UIKeyboardTypeNumberPad;
        self.count_Txt.text = [NSString stringWithFormat:@"%ld",self.dataModel.kGoodsCount];
        [self.goodsCount setHidden:YES];
    }
    else
    {
        [self.goodsSquare setHidden:YES];
        [self.editCountView setHidden:YES];
        [self.goodsCount setHidden:NO];
    }
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@",self.dataModel .price];
    self.goodsPackageDes.text = self.dataModel.comboDescribe;
    [self.goodsCount setHidden:NO];
    self.goodsCount.text = [NSString stringWithFormat:@"x%ld",(long)self.dataModel.kGoodsCount];
     [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:ImageNamed(@"defaultImage")];
}


- (void)showDataWithGoodsDetailModel:(GoodsDetailModel *)model WithCellType:(CommonSingleGoodsTCellType)cellType
{
    
    self.goodsCode.text = model.skuId;
    self.goodsName.text = model.name;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@",model.price];
    if (cellType == CommonSingleGoodsTCellTypePackageDetail) {
        [self.goodsCount setHidden:NO];
        self.goodsCount.text = [NSString stringWithFormat:@"x%ld",(long)model.num];
    }
    if (model.imtUrl.length) {
        [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.imtUrl] placeholderImage:ImageNamed(@"defaultImage")];
    }
    else
    {
        [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.smallImageUrlC] placeholderImage:ImageNamed(@"defaultImage")];
    }

   
    [self.bottom_Line_View setHidden:NO];
}

- (void)showDataWithPackageDetailModel:(PackageDetailModel *)model WithCellType:(CommonSingleGoodsTCellType)cellType
{
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:ImageNamed(@"defaultImage")];
    self.goodsCode.text = model.comboCode;
    self.goodsName.text = model.comboName;
    [self.goodsPrice setHidden:YES];
    [self.goodsPackageDes setHidden:NO];
    self.goodsPackageDes.text = model.comboDescribe;
}


- (void)showDataWithStoreActivityMealModel:(StoreActivityMealModel *)model AtIndex:(NSInteger)atIndex
{
    self.isShowDetail = model.isShowDetail;
    self.atIndex = atIndex;
    [self.goodsPackageDes setHidden:NO];
    [self.goodsPackageDetailBtn setHidden:NO];
    
    self.goodsCode.text = model.comboCode;
    self.goodsName.text = model.comboName;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%ld",(long)model.comboPrice];
    self.goodsPackageDes.text = model.comboDes;
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.comboImageUrl] placeholderImage:ImageNamed(@"defaultImage")];
    
    if (model.isShowDetail) {
        [self.goodsPackageDetailBtn setImage:ImageNamed(@"s_up_pull_btn_icon") forState:UIControlStateNormal];
    }
    else
    {
        [self.goodsPackageDetailBtn setImage:ImageNamed(@"s_show_detail_icon") forState:UIControlStateNormal];
    }
}

- (void)showDataWithCommonMealProdutcModelForGift:(CommonMealProdutcModel *)goodsModel AtIndex:(NSInteger)atIndex
{
    
    [self.goodsSquare setHidden:YES];
    [self.editCountView setHidden:YES];
    [self.returnCount_Lab setHidden:YES];
    self.isShowDetail = goodsModel.isShowDetail;
    self.atIndex = atIndex;
    [self.goodsCount setHidden:NO];
    self.goodsCode.text = goodsModel.code;
    self.goodsName.text = goodsModel.comboName;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥0  ￥%@",goodsModel .price]];
    [str addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(4, goodsModel .price.length + 1)];
    self.goodsPrice.attributedText = str;
//    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@",goodsModel.price];
    [self.goodsPrice setHidden:NO];
    self.goodsCount.text = [NSString stringWithFormat:@"x%ld",(long)goodsModel.count];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:goodsModel.photo] placeholderImage:ImageNamed(@"defaultImage")];
    
    if (goodsModel.isSetMeal) {
        self.goodsPackageDes.text = goodsModel.comboDescribe;
        [self.goodsPackageDes setHidden:NO];
        self.goodsPackageDes.textColor = AppTitleBlackColor;
        [self.goodsPackageDetailBtn setHidden:NO];
        
        if (goodsModel.isShowDetail) {
            [self.goodsPackageDetailBtn setImage:ImageNamed(@"s_up_pull_btn_icon") forState:UIControlStateNormal];
        }
        else
        {
            [self.goodsPackageDetailBtn setImage:ImageNamed(@"s_show_detail_icon") forState:UIControlStateNormal];
        }
    }
    else
    {
        if (goodsModel.isSpecial) {
            [self.goodsSquare setHidden:NO];
            self.goodsSquare.text = [NSString stringWithFormat:@"%@平方",goodsModel.square.length>0? goodsModel.square:@"0"];
        }
        else
        {
            [self.goodsSquare setHidden:YES];
        }
        [self.goodsPackageDes setHidden:YES];
        [self.goodsPackageDetailBtn setHidden:YES];
        
        if([goodsModel.waitDeliverCount integerValue] != 0 && goodsModel.waitDeliverCount != nil){
            [self.goodsPackageDes setHidden:NO];
            self.goodsPackageDes.textColor = [UIColor redColor];
            self.goodsPackageDes.text = [NSString stringWithFormat:@"总仓预约%@件",goodsModel.waitDeliverCount];
            
            if([goodsModel.deliverCount integerValue] != 0 && goodsModel.deliverCount != nil){

                self.goodsPackageDes.text = [NSString stringWithFormat:@"%@ 已发%@件",self.goodsPackageDes.text,goodsModel.deliverCount];
            }
            
            NSMutableAttributedString *tmStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%ld件,可退%ld件",(long)goodsModel.count,goodsModel.canReturnCount]];
//            [tmStr addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(2, [NSString stringWithFormat:@"%ld",(long)goodsModel.canReturnCount].length)];
            self.returnCount_Lab.attributedText = tmStr;
        } else {
            if([goodsModel.deliverCount integerValue] != 0 && goodsModel.deliverCount != nil){
                [self.goodsPackageDes setHidden:NO];
                self.goodsPackageDes.textColor = [UIColor redColor];
                self.goodsPackageDes.text = [NSString stringWithFormat:@"已发%@件",goodsModel.deliverCount];
            }
        }
    }
}
- (void)showDataWithOrderDetailForGift:(CommonMealProdutcModel *)goodsModel AtIndex:(NSInteger)atIndex
{
    
    [self.goodsSquare setHidden:YES];
    [self.editCountView setHidden:YES];
    [self.returnCount_Lab setHidden:YES];
    self.isShowDetail = goodsModel.isShowDetail;
    self.atIndex = atIndex;
    [self.goodsCount setHidden:NO];
    self.goodsCode.text = goodsModel.code;
    self.goodsName.text = goodsModel.comboName;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥0  ￥%@",goodsModel .price]];
    [str addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(4, goodsModel .price.length + 1)];
    self.goodsPrice.attributedText = str;
//    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@",goodsModel.price];
    [self.goodsPrice setHidden:NO];
    self.goodsCount.text = [NSString stringWithFormat:@"x%ld",(long)goodsModel.count];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:goodsModel.photo] placeholderImage:ImageNamed(@"defaultImage")];
    
    if (goodsModel.isSetMeal) {
        self.goodsPackageDes.text = goodsModel.comboDescribe;
        [self.goodsPackageDes setHidden:NO];
        self.goodsPackageDes.textColor = AppTitleBlackColor;
        [self.goodsPackageDetailBtn setHidden:NO];
        
        if (goodsModel.isShowDetail) {
            [self.goodsPackageDetailBtn setImage:ImageNamed(@"s_up_pull_btn_icon") forState:UIControlStateNormal];
        }
        else
        {
            [self.goodsPackageDetailBtn setImage:ImageNamed(@"s_show_detail_icon") forState:UIControlStateNormal];
        }
    }
    else
    {
        if (goodsModel.isSpecial) {
            [self.goodsSquare setHidden:NO];
            self.goodsSquare.text = [NSString stringWithFormat:@"%@平方",goodsModel.square.length>0? goodsModel.square:@"0"];
        }
        else
        {
            [self.goodsSquare setHidden:YES];
        }
        [self.goodsPackageDes setHidden:YES];
        [self.goodsPackageDetailBtn setHidden:YES];
        
//        if([goodsModel.waitDeliverCount integerValue] != 0 && goodsModel.waitDeliverCount != nil){
//            [self.goodsPackageDes setHidden:NO];
//            self.goodsPackageDes.textColor = [UIColor redColor];
//            self.goodsPackageDes.text = [NSString stringWithFormat:@"总仓预约%@件",goodsModel.waitDeliverCount];
//
//            if([goodsModel.deliverCount integerValue] != 0 && goodsModel.deliverCount != nil){
//
//                self.goodsPackageDes.text = [NSString stringWithFormat:@"%@ 已发%@件",self.goodsPackageDes.text,goodsModel.deliverCount];
//            }
//
//            NSMutableAttributedString *tmStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%ld件,可退%ld件",(long)goodsModel.count,goodsModel.canReturnCount]];
//            [tmStr addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(2, [NSString stringWithFormat:@"%ld",(long)goodsModel.canReturnCount].length)];
//            self.returnCount_Lab.attributedText = tmStr;
//        } else {
//            if([goodsModel.deliverCount integerValue] != 0 && goodsModel.deliverCount != nil){
//                [self.goodsPackageDes setHidden:NO];
//                self.goodsPackageDes.textColor = [UIColor redColor];
//                self.goodsPackageDes.text = [NSString stringWithFormat:@"已发%@件",goodsModel.deliverCount];
//            }
//        }
    }
}

- (void)showDataWithCommonMealProdutcModel:(CommonMealProdutcModel *)goodsModel AtIndex:(NSInteger)atIndex
{
//    self.cellType = CommonSingleGoodsTCellTypeSellGoods;
    [self.editCountView setHidden:YES];
    [self.returnCount_Lab setHidden:YES];
    self.isShowDetail = goodsModel.isShowDetail;
    self.atIndex = atIndex;
    [self.goodsCount setHidden:NO];
    self.goodsCode.text = goodsModel.code;
    self.goodsName.text = goodsModel.comboName;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@",goodsModel.price];
    [self.goodsPrice setHidden:NO];
    self.goodsCount.text = [NSString stringWithFormat:@"x%ld",(long)goodsModel.count];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:goodsModel.photo] placeholderImage:ImageNamed(@"defaultImage")];
    self.goodsPackageDes.textColor = AppTitleBlackColor;
    if (goodsModel.isSetMeal) {
        self.goodsPackageDes.text = goodsModel.comboDescribe;
        [self.goodsPackageDes setHidden:NO];
        
        [self.goodsPackageDetailBtn setHidden:NO];
        
        if (goodsModel.isShowDetail) {
            [self.goodsPackageDetailBtn setImage:ImageNamed(@"s_up_pull_btn_icon") forState:UIControlStateNormal];
        }
        else
        {
            [self.goodsPackageDetailBtn setImage:ImageNamed(@"s_show_detail_icon") forState:UIControlStateNormal];
        }
    }
    else
    {
        if (goodsModel.isSpecial) {
            [self.goodsSquare setHidden:NO];
            self.goodsSquare.text = [NSString stringWithFormat:@"%@平方",goodsModel.square.length>0? goodsModel.square:@"0"];
        }
        else
        {
            [self.goodsSquare setHidden:YES];
        }
        [self.goodsPackageDes setHidden:YES];
        [self.goodsPackageDetailBtn setHidden:YES];
    }
    
    
}


- (void)showDataWithIntentionProductModel:(IntentionProductModel *)model
{
    self.goodsCode.text = model.sku;
    self.goodsName.text = model.name;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@",model.price];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:ImageNamed(@"defaultImage")];
}


- (void)showDataWithReturnOrderMealGoodsModel:(ReturnOrderMealGoodsModel *)goodsModel AtIndex:(NSInteger)atIndex
{
    
    self.cellType = CommonSingleGoodsTCellTypeReturnSelected;
    self.mealGoodsModel = goodsModel;
    
    self.isShowDetail = goodsModel.isShowDetail;
    self.atIndex = atIndex;
    
    if (goodsModel.mealCode.length != 0) {
        self.goodsCode.text = goodsModel.mealCode;
    }
    else
    {
        self.goodsCode.text = goodsModel.sku;
    }
    
    self.goodsName.text = goodsModel.comboName;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@",goodsModel.refundAmount];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:goodsModel.photo] placeholderImage:ImageNamed(@"defaultImage")];
    
    
    [self.editCountView setHidden:YES];
    [self.returnCount_Lab setHidden:YES];
    if (goodsModel.isSetMeal) {
        self.goodsPackageDes.text = goodsModel.comboDescribe;
        [self.goodsPackageDes setHidden:NO];
        self.goodsPackageDes.textColor = AppTitleBlackColor;
        [self.goodsPackageDetailBtn setHidden:NO];
        if (goodsModel.isShowDetail) {
            [self.goodsPackageDetailBtn setImage:ImageNamed(@"s_up_pull_btn_icon") forState:UIControlStateNormal];
        }
        else
        {
            [self.goodsPackageDetailBtn setImage:ImageNamed(@"s_show_detail_icon") forState:UIControlStateNormal];
        }
    }
    else
    {
        if (goodsModel.isSpecial) {
            [self.goodsSquare setHidden:NO];
            self.goodsSquare.text = [NSString stringWithFormat:@"%@平方",goodsModel.square.length>0? goodsModel.square:@"0"];
        }
        else
        {
            [self.goodsSquare setHidden:YES];
        }
        
        [self.editCountView setHidden:NO];
        [self.returnCount_Lab setHidden:NO];
        
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"可退%ld件",(long)goodsModel.canReturnCount]];
//        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(2, [NSString stringWithFormat:@"%ld",(long)goodsModel.canReturnCount].length)];
        self.returnCount_Lab.attributedText = str;
        
//        self.returnCount_Lab.text = [NSString stringWithFormat:@"可退%ld件",(long)goodsModel.count];
        self.count_Txt.text = [NSString stringWithFormat:@"%ld",(long)goodsModel.returnCount];
        self.count_Txt.keyboardType = UIKeyboardTypeNumberPad;
        
        [self.goodsPackageDes setHidden:YES];
        [self.goodsPackageDetailBtn setHidden:YES];
        
        
        
        if([goodsModel.waitDeliverCount integerValue] != 0 && goodsModel.waitDeliverCount != nil){
            [self.goodsPackageDes setHidden:NO];
            self.goodsPackageDes.textColor = [UIColor redColor];
            self.goodsPackageDes.text = [NSString stringWithFormat:@"总仓预约%@件",goodsModel.waitDeliverCount];
            
            if([goodsModel.deliverCount integerValue] != 0 && goodsModel.deliverCount != nil){

                self.goodsPackageDes.text = [NSString stringWithFormat:@"%@ 已发%@件",self.goodsPackageDes.text,goodsModel.deliverCount];
            }
            
            NSMutableAttributedString *tmStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%ld件,可退%ld件",(long)goodsModel.count,goodsModel.canReturnCount]];
//            [tmStr addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(2, [NSString stringWithFormat:@"%ld",(long)goodsModel.count].length)];
            self.returnCount_Lab.attributedText = tmStr;
        } else {
            if([goodsModel.deliverCount integerValue] != 0 && goodsModel.deliverCount != nil){
                [self.goodsPackageDes setHidden:NO];
                self.goodsPackageDes.textColor = [UIColor redColor];
                self.goodsPackageDes.text = [NSString stringWithFormat:@"已发%@件",goodsModel.deliverCount];
            }
        }
    }
    
    
    
    
}


- (void)showDataWithReturnOrderMealGoodsModelForReturnAllGoodsCounter:(ReturnOrderMealGoodsModel *)goodsModel AtIndex:(NSInteger)atIndex
{
    self.isShowDetail = goodsModel.isShowDetail;
    self.atIndex = atIndex;
    
    self.goodsCode.text = goodsModel.mealCode;
    self.goodsName.text = goodsModel.comboName;
    [self.goodsPrice setHidden:YES];
//    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@",goodsModel.refundAmount];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:goodsModel.photo] placeholderImage:ImageNamed(@"defaultImage")];
    
    
    [self.goodsCount setHidden:YES];
    if (goodsModel.isSetMeal) {
        self.goodsPackageDes.text = goodsModel.comboDescribe;
        [self.goodsPackageDes setHidden:NO];
        self.goodsPackageDes.textColor = AppTitleBlackColor;
        [self.goodsPackageDetailBtn setHidden:NO];
        if (goodsModel.isShowDetail) {
            [self.goodsPackageDetailBtn setImage:ImageNamed(@"s_up_pull_btn_icon") forState:UIControlStateNormal];
        }
        else
        {
            [self.goodsPackageDetailBtn setImage:ImageNamed(@"s_show_detail_icon") forState:UIControlStateNormal];
        }
    }
    else
    {
        [self.goodsCount setHidden:NO];
        self.goodsCount.text = [NSString stringWithFormat:@"x%ld",(long)goodsModel.count];
        [self.goodsPackageDes setHidden:YES];
        [self.goodsPackageDetailBtn setHidden:YES];
        
        if (goodsModel.isSpecial) {
            [self.goodsSquare setHidden:NO];
            self.goodsSquare.text =self.goodsSquare.text = [NSString stringWithFormat:@"%@平方",goodsModel.square.length>0? goodsModel.square:@"0"];
        }
        else
        {
            [self.goodsSquare setHidden:YES];
        }
        
        if([goodsModel.waitDeliverCount integerValue] != 0 && goodsModel.waitDeliverCount != nil){
            [self.goodsPackageDes setHidden:NO];
            self.goodsPackageDes.textColor = [UIColor redColor];
            self.goodsPackageDes.text = [NSString stringWithFormat:@"总仓预约%@件",goodsModel.waitDeliverCount];
            
            if([goodsModel.deliverCount integerValue] != 0 && goodsModel.deliverCount != nil){
                self.goodsPackageDes.text = [NSString stringWithFormat:@"%@ 已发%@件",self.goodsPackageDes.text,goodsModel.deliverCount];
            }
        } else {
            if([goodsModel.deliverCount integerValue] != 0 && goodsModel.deliverCount != nil){
                [self.goodsPackageDes setHidden:NO];
                self.goodsPackageDes.textColor = [UIColor redColor];
                self.goodsPackageDes.text = [NSString stringWithFormat:@"已发%@件",goodsModel.deliverCount];
            }
        }
    }
    
    
//    self.goodsSquare.text = @"";
    
    
    
}




- (void)showDataWithReturnOrderCounterGoodsModel:(ReturnOrderCounterGoodsModel *)model
{
    self.goodsCode.text = model.sku;
    self.goodsName.text = model.name;
    [self.goodsPrice setHidden:YES];
//    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@",model.refundAmount];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:ImageNamed(@"defaultImage")];
    self.goodsCount.text = [NSString stringWithFormat:@"x%ld",(long)model.count];
    [self.goodsCount setHidden:NO];
    
    if (model.isSpecial) {
        [self.goodsSquare setHidden:NO];
        self.goodsSquare.text = [NSString stringWithFormat:@"%@平方",model.square.length>0? model.square:@"0"];
    }
    else
    {
        [self.goodsSquare setHidden:YES];
    }
    
    [self.goodsPackageDes setHidden:YES];
    [self.goodsPackageDetailBtn setHidden:YES];
}

- (void)showDataWitReturnOrderDetailGoodsModel:(ReturnOrderDetailGoodsModel *)model
{
    self.goodsCode.text = model.sku;
    self.goodsName.text = model.name;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@",model.price];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:ImageNamed(@"defaultImage")];
    self.goodsCount.text = [NSString stringWithFormat:@"x%ld",(long)model.count];
    [self.goodsCount setHidden:NO];

}



#pragma  mark -- UITextFieldDelegate
// 可用下个方法替换


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.count_Txt == textField) {
        if (self.cellType == CommonSingleGoodsTCellTypeReturnSelected) {
            if (textField.text.length == 0) {
                textField.text = @"0";
            }
            if ([textField.text integerValue] > self.mealGoodsModel.canReturnCount) {
                textField.text = [NSString stringWithFormat:@"%ld",(long)self.mealGoodsModel.canReturnCount];
                self.mealGoodsModel.returnCount = self.mealGoodsModel.canReturnCount;
                [[NSToastManager manager] showtoast:@"商品数量不能超过可退商品数量"];
            }
            else
            {
                self.mealGoodsModel.returnCount = [textField.text integerValue];
            }
        }
        
        else if (self.cellType == CommonSingleGoodsTCellTypeSellCounter)
        {
            if (self.dataModel.isSpecial) {
                if ([textField.text integerValue] > 999) {
                    textField.text = @"999";
                }
                if (textField.text.length == 0) {
                    textField.text = @"1";
                }
                self.dataModel.kGoodsCount = [textField.text integerValue];
                if (self.goodsNumberChangeBlock) {
                    self.goodsNumberChangeBlock();
                }
            }
        }
        
        //卖货扫面界面
        else if (self.cellType == CommonSingleGoodsTCellTypeSellGoods)
        {
            if (self.dataModel.isSpecial) {
                if ([textField.text floatValue] > 999.999) {
                    textField.text = @"999.999";
                }
                if ([textField.text floatValue] == 0 ||
                    [textField.text floatValue] <= [self.dataModel.minNum floatValue]) {
                    if (self.dataModel.minNum.length) {
                        [[NSToastManager manager] showtoast:[NSString stringWithFormat:@"最小值不能小于%.3f",[self.dataModel.minNum floatValue]]];
                        textField.text = [NSString stringWithFormat:@"%.3f",[self.dataModel.minNum floatValue]];
                    }
                    else
                    {
                        textField.text = @"0.001";
                    }
                    
                    
                }
                if (textField.text.length == 0) {
                    if (self.dataModel.minNum.length) {
                        textField.text = [NSString stringWithFormat:@"%.3f",[self.dataModel.minNum floatValue]];
                    }
                    else
                    {
                        textField.text = @"0.001";
                    }
                }
                self.dataModel.kGoodsArea = [textField.text floatValue];
            }
            else
            {
                if ([textField.text integerValue] > 999) {
                    textField.text = @"999";
                }
                if (textField.text.length == 0) {
                    textField.text = @"1";
                }
                self.dataModel.kGoodsCount = [textField.text integerValue];
            }
            if (self.goodsNumberChangeBlock) {
                self.goodsNumberChangeBlock();
            }
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.count_Txt == textField) {
        if (self.cellType == CommonSingleGoodsTCellTypeSellCounter)
        {
            if (self.dataModel.isSpecial) {
                {
                    //限制首位0，后面只能输入.
                    if ([textField.text isEqualToString:@""]) {
                        if ([string isEqualToString:@"0"]) {
                            return NO;
                        }
                    }
                    if (textField.text.length >= 4 && ![string isEqualToString:@""]) {
                        return NO;
                    }
                    //限制只能输入：1234567890.
                    NSCharacterSet * characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
                    NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
                    return [string isEqualToString:filtered];
                }
            }
        }
        else if (self.cellType == CommonSingleGoodsTCellTypeSellGoods)
        {
            if (self.dataModel.isSpecial) {
                NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string] ;
                
                //限制第一个不能输入.
                if (textField.text.length == 0 &&
                    [string isEqualToString:@"."]) {
                    return NO;
                }
                if ([textField.text rangeOfString:@"."].location == NSNotFound) {
                    if (textField.text.length >= 3 && ![string isEqualToString:@""]&& ![string isEqualToString:@"."]) {
                        return NO;
                    }
                }
                //限制.后面最多有两位，且不能再输入.
                if ([textField.text rangeOfString:@"."].location != NSNotFound) {
                    //有.了 且.后面输入了3位  停止输入
                    if (toBeString.length > [toBeString rangeOfString:@"."].location+4) {
                        return NO;
                    }
                    //有.了，不允许再输入.
                    if ([string isEqualToString:@"."]) {
                        return NO;
                    }
                }
                //限制首位0，后面只能输入.
                if ([textField.text isEqualToString:@"0"]) {
                    if ([string isEqualToString:@""]) {
                        return YES;
                    }
                    if (![string isEqualToString:@"."]) {
                        return NO;
                    }
                }
                //限制只能输入：1234567890.
                NSCharacterSet * characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890."] invertedSet];
                NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
                return [string isEqualToString:filtered];
            }
            else
            {
                //限制首位0，后面只能输入.
                if ([textField.text isEqualToString:@""]) {
                    if ([string isEqualToString:@"0"]) {
                        return NO;
                    }
                }
                if (textField.text.length >= 3 && ![string isEqualToString:@""]) {
                    return NO;
                }
                //限制只能输入：1234567890.
                NSCharacterSet * characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
                NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
                return [string isEqualToString:filtered];
            }
        }
        
    }
    return YES;
}



- (IBAction)selectedAction:(UIButton *)sender {
    if (self.goodsSelectedBlock) {
        self.goodsSelectedBlock(self.dataModel);
    }
}

- (IBAction)detailAction:(UIButton *)sender {
    if (self.goodsShowDetailBlock) {
        self.goodsShowDetailBlock(!self.isShowDetail, self.atIndex);
    }
}

#pragma mark -- 数量减操作
- (IBAction)goodsMinusAction:(UIButton *)sender {
    if (self.cellType == CommonSingleGoodsTCellTypeReturnSelected) {
        if (self.mealGoodsModel.returnCount == 0) {
            return;
        }
        else
        {
            self.mealGoodsModel.returnCount -= 1;
            self.count_Txt.text = [NSString stringWithFormat:@"%ld",(long)self.mealGoodsModel.returnCount];
        }
    }
    //卖货扫描
    else if (self.cellType == CommonSingleGoodsTCellTypeSellGoods)
    {
        if (self.dataModel.isSpecial) {
            if (self.dataModel.minNum.length) {
                if ([[NSString stringWithFormat:@"%.3f",self.dataModel.kGoodsArea] isEqualToString:self.dataModel.minNum]) {
                    if (self.goodsDeleteBlock) {
                        self.goodsDeleteBlock(self.atIndex);
                    }
                    return;
                }
            }
            else
            {
                if ([[NSString stringWithFormat:@"%.3f",self.dataModel.kGoodsArea] isEqualToString:@"0.001"]) {
                    if (self.goodsDeleteBlock) {
                        self.goodsDeleteBlock(self.atIndex);
                    }
                    return;
                }
            }
            self.dataModel.kGoodsArea -= 0.001;
            self.count_Txt.text = [NSString stringWithFormat:@"%.3f",self.dataModel.kGoodsArea];
        }
        else
        {
            if (self.dataModel.kGoodsCount == 1) {
                if (self.goodsDeleteBlock) {
                    self.goodsDeleteBlock(self.atIndex);
                }
                return;
            }
            self.dataModel.kGoodsCount -= 1;
            self.count_Txt.text = [NSString stringWithFormat:@"%ld",(long)self.dataModel.kGoodsCount];
        }
        if (self.goodsNumberChangeBlock) {
            self.goodsNumberChangeBlock();
        }
    }
    else if (self.cellType == CommonSingleGoodsTCellTypeSellCounter)
    {
        if (self.dataModel.isSpecial) {
            if (self.dataModel.kGoodsCount == 1) {
                if (self.goodsDeleteBlock) {
                    self.goodsDeleteBlock(self.atIndex);
                }
                return;
            }
            self.dataModel.kGoodsCount -= 1;
            self.count_Txt.text = [NSString stringWithFormat:@"%ld",(long)self.dataModel.kGoodsCount];
            if (self.goodsNumberChangeBlock) {
                self.goodsNumberChangeBlock();
            }
        }
    }
    
    
}

#pragma mark -- 数量加操作
- (IBAction)goodsAddAction:(UIButton *)sender {
    if (self.cellType == CommonSingleGoodsTCellTypeReturnSelected) {
        
        if (self.mealGoodsModel.returnCount == self.mealGoodsModel.canReturnCount) {
            return;
        }
        else
        {
            self.mealGoodsModel.returnCount += 1;
            self.count_Txt.text = [NSString stringWithFormat:@"%ld",(long)self.mealGoodsModel.returnCount];
        }
    }
    else if (self.cellType == CommonSingleGoodsTCellTypeSellGoods)
    {
        if (self.dataModel.isSpecial) {
            if (self.dataModel.kGoodsArea >= 999.999) {
                return;
            }
            self.dataModel.kGoodsArea += 0.001;
            self.count_Txt.text = [NSString stringWithFormat:@"%.3f",self.dataModel.kGoodsArea];
        }
        else
        {
            if (self.dataModel.kGoodsCount >= 999) {
                self.dataModel.kGoodsCount = 999;
                return;
            }
            self.dataModel.kGoodsCount += 1;
            self.count_Txt.text = [NSString stringWithFormat:@"%ld",(long)self.dataModel.kGoodsCount];
        }
        if (self.goodsNumberChangeBlock) {
            self.goodsNumberChangeBlock();
        }
    }
    else if (self.cellType == CommonSingleGoodsTCellTypeSellCounter)
    {
        if (self.dataModel.isSpecial) {
            if (self.dataModel.kGoodsCount >= 999) {
                self.dataModel.kGoodsCount = 999;
                return;
            }
            self.dataModel.kGoodsCount += 1;
            self.count_Txt.text = [NSString stringWithFormat:@"%ld",(long)self.dataModel.kGoodsCount];
            if (self.goodsNumberChangeBlock) {
                self.goodsNumberChangeBlock();
            }
        }
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
