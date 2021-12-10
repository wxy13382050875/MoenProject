//
//  XwOrderDetailHeadCell.m
//  MoenProject
//
//  Created by wuxinyi on 2021/12/9.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "XwOrderDetailStockCell.h"

@interface XwOrderDetailStockCell ()
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *stateLabel;
@property (strong, nonatomic) UILabel *numberLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@end
@implementation XwOrderDetailStockCell
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
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.stateLabel];
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.nameLabel];
}
-(void)xw_updateConstraints{
    self.dateLabel.sd_layout.leftSpaceToView(self.contentView, 15).topEqualToView(self.contentView).widthIs(250).heightIs(30);
    self.stateLabel.sd_layout.topEqualToView(self.contentView).rightSpaceToView(self.contentView, 15).leftSpaceToView(self.dateLabel, 5).heightIs(30);
    self.numberLabel.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(self.dateLabel, 5).rightSpaceToView(self.contentView, 15).heightIs(30);
    self.nameLabel.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(self.numberLabel, 5).rightSpaceToView(self.contentView, 15).heightIs(30);
    
    
}
-(void)setModel:(XwOrderDetailModel *)model{
    self.dateLabel.text = model.orderTime;
    self.stateLabel.text = [NSString stringWithFormat:@"%@申请",model.orderType];;
    self.numberLabel.text =[NSString stringWithFormat:@"进货单编号:%@",model.orderID];
    self.nameLabel.text =[NSString stringWithFormat:@"制单人:%@",model.orderCreater];
    
}
-(UILabel*)dateLabel{
    if(!_dateLabel){
        _dateLabel = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentLeft WithFont:14];
        _dateLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _dateLabel;
}
-(UILabel*)stateLabel{
    if(!_stateLabel){
        _stateLabel = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentRight WithFont:14];
        _stateLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _stateLabel;
}
-(UILabel*)numberLabel{
    if(!_numberLabel){
        _numberLabel = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentLeft WithFont:14];
        _numberLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _numberLabel;
}
-(UILabel*)nameLabel{
    if(!_nameLabel){
        _nameLabel = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentLeft WithFont:14];
        _nameLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _nameLabel;
}
@end
