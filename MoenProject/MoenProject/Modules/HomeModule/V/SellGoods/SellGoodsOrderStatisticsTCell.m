//
//  SellGoodsOrderStatisticsTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/21.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "SellGoodsOrderStatisticsTCell.h"

@interface SellGoodsOrderStatisticsTCell ()

@property (weak, nonatomic) IBOutlet UILabel *count_Lab;


@property (weak, nonatomic) IBOutlet UILabel *receivable_Title_Lab;
@property (weak, nonatomic) IBOutlet UILabel *receivable_Lab;

@property (weak, nonatomic) IBOutlet UILabel *coupon_Title_Lab;
@property (weak, nonatomic) IBOutlet UILabel *coupon_Lab;

@property (weak, nonatomic) IBOutlet UILabel *discount_Title_Lab;
@property (weak, nonatomic) IBOutlet UILabel *store_discount_Lab;

@property (weak, nonatomic) IBOutlet UILabel *promotion_Title_Lab;
@property (weak, nonatomic) IBOutlet UILabel *promotion_Lab;

@property (weak, nonatomic) IBOutlet UILabel *actual_Title_Lab;
@property (weak, nonatomic) IBOutlet UILabel *actual_Lab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coupon_View_Constraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promotion_View_constraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *store_View_constraints;


@end

@implementation SellGoodsOrderStatisticsTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.count_Lab.font = FONTLanTingR(14);
    
    self.receivable_Title_Lab.font = FONTLanTingR(14);
    self.receivable_Lab.font = FontBinB(14);
    
    self.coupon_Title_Lab.font = FONTLanTingR(14);
    self.coupon_Lab.font = FontBinB(14);
    
    self.discount_Title_Lab.font = FONTLanTingR(14);
    self.store_discount_Lab.font = FontBinB(14);
    
    self.promotion_Title_Lab.font = FONTLanTingR(14);
    self.promotion_Lab.font = FontBinB(14);
    
    self.actual_Title_Lab.font = FONTLanTingR(14);
    self.actual_Lab.font = FontBinB(14);
    
}

- (void)showDataWithSalesCounterDataModel:(SalesCounterDataModel *)model WithGoodsCount:(NSInteger )goodsCount WithGiftGoodsCount:(NSInteger)giftGoodsCount
{
    NSString *giftGoodsCountStr = [NSString stringWithFormat:@"%ld",(long)giftGoodsCount];
    if (giftGoodsCount > 0) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%ld件商品, %@件赠品",(long)goodsCount,giftGoodsCountStr]];
        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(1, [NSString stringWithFormat:@"%ld",(long)goodsCount].length)];
        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(str.length - giftGoodsCountStr.length - 3, giftGoodsCountStr.length)];
        self.count_Lab.attributedText = str;
    }
    else
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%ld件商品",(long)goodsCount]];
        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(1, [NSString stringWithFormat:@"%ld",(long)goodsCount].length)];
        self.count_Lab.attributedText = str;
    }
    
    
    self.receivable_Lab.text = [NSString stringWithFormat:@"¥%@",model.amountPayable];
    self.coupon_Lab.text = [NSString stringWithFormat:@"-¥%@",model.couponDerate];
    self.promotion_Lab.text = [NSString stringWithFormat:@"-¥%@",model.orderDerate];
    self.store_discount_Lab.text = [NSString stringWithFormat:@"-¥%@",model.shopDerate];
    self.actual_Lab.text = [NSString stringWithFormat:@"¥%@",model.payAmount];
    if ([model.couponDerate isEqualToString:@"0"]) {
        self.coupon_View_Constraints.constant = 0.01;
    }
    else
    {
        self.coupon_View_Constraints.constant = 26;
    }
    if ([model.orderDerate isEqualToString:@"0"]) {
        self.promotion_View_constraints.constant = 0.01;
    }
    else
    {
        self.promotion_View_constraints.constant = 26;
    }
    if ([model.shopDerate isEqualToString:@"0"]) {
        self.store_View_constraints.constant = 0.01;
    }
    else
    {
        self.store_View_constraints.constant = 26;
    }
    
}

- (void)showDataWithOrderDetailModel:(OrderDetailModel *)model
{
    NSString *giftGoodsCountStr = [NSString stringWithFormat:@"%ld",(long)model.giftNum];
    if (model.giftNum > 0) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%ld件商品, %@件赠品",(long)model.productCount,giftGoodsCountStr]];
        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(1, [NSString stringWithFormat:@"%ld",(long)model.productCount].length)];
        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(str.length - giftGoodsCountStr.length - 3, giftGoodsCountStr.length)];
        self.count_Lab.attributedText = str;
    }
    else
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%ld件商品",(long)model.productCount]];
        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(1, [NSString stringWithFormat:@"%ld",(long)model.productCount].length)];
        self.count_Lab.attributedText = str;
    }
    
    
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%ld件商品",(long)model.productCount]];
//    [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(1, [NSString stringWithFormat:@"%ld",(long)model.productCount].length)];
//    
//    self.count_Lab.attributedText = str;
    self.receivable_Lab.text = [NSString stringWithFormat:@"¥%@",model.amountPayable];
    self.coupon_Lab.text = [NSString stringWithFormat:@"-¥%@",model.couponDerate];
    self.promotion_Lab.text = [NSString stringWithFormat:@"-¥%@",model.orderDerate];
    self.store_discount_Lab.text = [NSString stringWithFormat:@"-¥%@",model.shopDerate];
    self.actual_Lab.text = [NSString stringWithFormat:@"¥%@",model.payAmount];
    
    if ([model.couponDerate isEqualToString:@"0"]) {
        self.coupon_View_Constraints.constant = 0.01;
    }
    else
    {
        self.coupon_View_Constraints.constant = 26;
    }
    if ([model.orderDerate isEqualToString:@"0"]) {
        self.promotion_View_constraints.constant = 0.01;
    }
    else
    {
        self.promotion_View_constraints.constant = 26;
    }
    if ([model.shopDerate isEqualToString:@"0"]) {
        self.store_View_constraints.constant = 0.01;
    }
    else
    {
        self.store_View_constraints.constant = 26;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
