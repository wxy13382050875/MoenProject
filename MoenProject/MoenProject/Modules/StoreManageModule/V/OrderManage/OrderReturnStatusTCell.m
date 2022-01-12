//
//  OrderReturnStatusTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/2/11.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "OrderReturnStatusTCell.h"
@interface OrderReturnStatusTCell()

@property (weak, nonatomic) IBOutlet UILabel *leftTop_Lab;

@property (weak, nonatomic) IBOutlet UILabel *leftBottom_Lab;

@property (weak, nonatomic) IBOutlet UILabel *rightTop_Lab;

@property (weak, nonatomic) IBOutlet UILabel *rightBottmo_Lab;

@end


@implementation OrderReturnStatusTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftTop_Lab.font = FONTLanTingR(14);
    self.leftBottom_Lab.font = FONTLanTingR(14);
    self.rightTop_Lab.font = FONTLanTingR(14);
    // Initialization code
}

- (void)showDataWithCommonMealProdutcModel:(CommonMealProdutcModel *)goodsModel
{
    self.contentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    if (goodsModel.isSpecial) {
        if (goodsModel.addPrice.length > 0) {
            [self.leftTop_Lab setHidden:NO];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"增项加价：¥%.2f",[goodsModel.addPrice floatValue]]];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:14] range:NSMakeRange(4, str.length - 4)];
            self.leftTop_Lab.attributedText = str;
            
            [self.leftBottom_Lab setHidden:YES];
            if (goodsModel.codePu.length > 0) {
                [self.leftBottom_Lab setHidden:NO];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"PO单号：%@",goodsModel.codePu]];
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:14] range:NSMakeRange(0, 2)];
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:14] range:NSMakeRange(4, str.length - 4)];
                self.leftBottom_Lab.attributedText = str;
            }
        }
        else
        {
            if (goodsModel.codePu.length > 0) {
                [self.leftTop_Lab setHidden:NO];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"PO单号：%@",goodsModel.codePu]];
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:14] range:NSMakeRange(0, 2)];
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:14] range:NSMakeRange(4, str.length - 4)];
                self.leftTop_Lab.attributedText = str;
            }
            [self.leftBottom_Lab setHidden:YES];
        }
        
        if (goodsModel.returnCount > 0) {
            [self.rightTop_Lab setHidden:NO];
            self.rightTop_Lab.text = [NSString stringWithFormat:@"已退%ld件",(long)goodsModel.returnCount];
        }
        else
        {
            [self.rightTop_Lab setHidden:YES];
        }
        
        if ([goodsModel.deliverCount integerValue] > 0) {
            [self.rightBottmo_Lab setHidden:NO];
            self.rightBottmo_Lab.text = [NSString stringWithFormat:@"已发%@件",goodsModel.deliverCount];
        }
        else
        {
            [self.rightTop_Lab setHidden:YES];
        }
    }
    else
    {
        [self.leftTop_Lab setHidden:YES];
        [self.leftBottom_Lab setHidden:YES];
        if (goodsModel.returnCount > 0||[goodsModel.deliverCount integerValue] > 0) {
            [self.rightTop_Lab setHidden:NO];
            if([goodsModel.deliverCount integerValue] > 0){
                self.rightTop_Lab.text = [NSString stringWithFormat:@"已发%@件",goodsModel.deliverCount];
                if(goodsModel.returnCount > 0){
                    self.rightTop_Lab.text = [NSString stringWithFormat:@"%@ 已退%ld件",self.rightTop_Lab.text,(long)goodsModel.returnCount];
                }
            } else {
                self.rightTop_Lab.text = [NSString stringWithFormat:@" 已退%ld件",(long)goodsModel.returnCount];
            }
            
        }
        else
        {
            [self.rightTop_Lab setHidden:YES];
        }
    }
}

- (void)showDataWithCommonProdutcModel:(CommonProdutcModel *)model
{
    self.contentView.backgroundColor = UIColorFromRGB(0xFBFAFA);
    [self.rightTop_Lab setHidden:NO];
    self.rightTop_Lab.text = [NSString stringWithFormat:@"已退%ld件",(long)model.returnCount];
    [self.leftTop_Lab setHidden:YES];
    [self.leftBottom_Lab setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
