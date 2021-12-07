//
//  ReturnGoodsCounterStatisticsTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/17.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "ReturnGoodsCounterStatisticsTCell.h"
@interface ReturnGoodsCounterStatisticsTCell()
@property (weak, nonatomic) IBOutlet UILabel *count_Lab;


@property (weak, nonatomic) IBOutlet UILabel *refunded_Ttitle_Lab;

@property (weak, nonatomic) IBOutlet UILabel *refunded_Lab;


@property (weak, nonatomic) IBOutlet UILabel *actual_Title_Lab;

@property (weak, nonatomic) IBOutlet UILabel *actual_Lab;



@end


@implementation ReturnGoodsCounterStatisticsTCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.count_Lab.font = FONTLanTingR(14);
    self.refunded_Ttitle_Lab.font = FONTLanTingR(14);
    self.refunded_Lab.font = FontBinB(14);
    self.actual_Title_Lab.font = FONTLanTingR(14);
    self.actual_Lab.font = FontBinB(14);
    
}

- (void)showDataWithReturnOrderCounterModel:(ReturnOrderCounterModel *)model
{
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%ld件商品",(long)model.returnCount]];
//    [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(1, [NSString stringWithFormat:@"%ld",(long)model.returnCount].length)];
//    self.count_Lab.attributedText = str;
    
    NSString *giftGoodsCountStr = [NSString stringWithFormat:@"%ld",(long)model.giftNum];
    if (model.giftNum > 0) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%ld件商品, %@件赠品",(long)model.returnCount,giftGoodsCountStr]];
        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(1, [NSString stringWithFormat:@"%ld",(long)model.returnCount].length)];
        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(str.length - giftGoodsCountStr.length - 3, giftGoodsCountStr.length)];
        self.count_Lab.attributedText = str;
    }
    else
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%ld件商品",(long)model.returnCount]];
        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(1, [NSString stringWithFormat:@"%ld",(long)model.returnCount].length)];
        self.count_Lab.attributedText = str;
    }
    
    
    
    self.refunded_Lab.text = [NSString stringWithFormat:@"¥%@",model.refundAmount];
    self.actual_Lab.text = [NSString stringWithFormat:@"¥%ld",(long)model.actualRefundAmount];
}

- (void)showDataWithReturnOrderDetailModel:(ReturnOrderDetailModel *)model
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%ld件商品",(long)model.productCount]];
    [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(1, [NSString stringWithFormat:@"%ld",(long)model.productCount].length)];
    self.count_Lab.attributedText = str;
    if (model.refundAmount.length > 0) {
        self.refunded_Lab.text = [NSString stringWithFormat:@"¥%@",model.refundAmount];
    }
    else
    {
        self.refunded_Lab.text = @"";
    }
    if (model.actualRefundAmount.length) {
        self.actual_Lab.text = [NSString stringWithFormat:@"¥%@",model.actualRefundAmount];
    }
    else
    {
        self.actual_Lab.text = @"";
    }
    
}

- (void)showDataWithReturnOrderInfoModel:(ReturnOrderInfoModel *)model
{
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@件商品",model.returnCount]];
//    [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(1, model.returnCount.length)];
//
//    self.count_Lab.attributedText = str;
    
    NSString *giftGoodsCountStr = [NSString stringWithFormat:@"%ld",(long)model.giftNum];
    if (model.giftNum > 0) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@件商品, %@件赠品",model.returnCount,giftGoodsCountStr]];
        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(1, [NSString stringWithFormat:@"%@",model.returnCount].length)];
        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(str.length - giftGoodsCountStr.length - 3, giftGoodsCountStr.length)];
        self.count_Lab.attributedText = str;
    }
    else
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@件商品",model.returnCount]];
        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(1, [NSString stringWithFormat:@"%@",model.returnCount].length)];
        self.count_Lab.attributedText = str;
    }
    
    self.refunded_Lab.text = [NSString stringWithFormat:@"¥%@",model.refundAmount];
    self.actual_Lab.text = [NSString stringWithFormat:@"¥%ld",(long)model.actualRefundAmount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
