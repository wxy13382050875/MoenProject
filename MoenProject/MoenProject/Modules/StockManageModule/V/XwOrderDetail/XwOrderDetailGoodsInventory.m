//
//  XwOrderDetailGoodsInventory.m
//  MoenProject
//
//  Created by wuxinyi on 2021/12/9.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "XwOrderDetailGoodsInventory.h"
@interface XwOrderDetailGoodsInventory ()
@property (strong, nonatomic)  UIImageView *goodsImg;

@property (strong, nonatomic) UILabel *goodsCode;

@property (strong, nonatomic)  UILabel *goodsName;

@property (strong, nonatomic)  UILabel *goodsCountBefor;

@property (strong, nonatomic)  UILabel *goodsCountAfter;
@end
@implementation XwOrderDetailGoodsInventory

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
    [self.contentView addSubview:self.goodsCountBefor];
    [self.contentView addSubview:self.goodsCountAfter];
}
-(void)xw_updateConstraints{
    self.goodsImg.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(self.contentView, 15).widthIs(90).heightIs(90);
    
    self.goodsCode.sd_layout.leftSpaceToView(self.goodsImg, 15).topEqualToView(self.goodsImg).rightSpaceToView(self.contentView, 15).heightIs(30);
    self.goodsName.sd_layout.leftSpaceToView(self.goodsImg, 15).topSpaceToView(self.goodsCode, 0).rightSpaceToView(self.contentView, 15).heightIs(30);
    self.goodsCountBefor.sd_layout.topSpaceToView(self.goodsName, 0).leftSpaceToView(self.goodsImg, 15).rightSpaceToView(self.contentView, 15).heightIs(30);
    self.goodsCountAfter.sd_layout.topSpaceToView(self.goodsCountBefor, 0).leftSpaceToView(self.goodsImg, 15).rightSpaceToView(self.contentView, 15).heightIs(30);
    
    
}
-(void)setModel:(Goodslist *)model{
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.goodsIMG] placeholderImage:ImageNamed(@"defaultImage")];
    self.goodsCode.text = model.goodsSKU;
    self.goodsName.text = model.goodsName;
    self.goodsCountBefor.text = [NSString stringWithFormat:@"原库存数量:%@",model.goodsCountBefor];
    self.goodsCountAfter.text = [NSString stringWithFormat:@"盘库后数量:%@",model.goodsCountAfter];
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
-(UILabel*)goodsCountBefor{
    if(!_goodsCountBefor){
        _goodsCountBefor = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentRight WithFont:14];
    }
    return _goodsCountBefor;
}
-(UILabel*)goodsCountAfter{
    if(!_goodsCountAfter){
        _goodsCountAfter = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentRight WithFont:14];
    }
    return _goodsCountAfter;
}

@end
