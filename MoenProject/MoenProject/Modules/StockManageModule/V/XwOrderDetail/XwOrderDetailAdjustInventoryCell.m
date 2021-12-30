//
//  XwOrderDetailAdjustInventoryCell.m
//  MoenProject
//
//  Created by wuxinyi on 2021/12/9.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "XwOrderDetailAdjustInventoryCell.h"
@interface XwOrderDetailAdjustInventoryCell ()
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *numberLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *statusLabel;
@end
@implementation XwOrderDetailAdjustInventoryCell

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
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.statusLabel];
}
-(void)xw_updateConstraints{
    self.dateLabel.sd_layout.leftSpaceToView(self.contentView, 15).topEqualToView(self.contentView).rightSpaceToView(self.contentView, 15).heightIs(30);
    
    self.numberLabel.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(self.dateLabel, 5).rightSpaceToView(self.contentView, 15).heightIs(30);
    self.nameLabel.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(self.numberLabel, 5).widthIs((SCREEN_WIDTH-30)/2).heightIs(30);
    self.statusLabel.sd_layout.topSpaceToView(self.numberLabel, 5).rightSpaceToView(self.contentView, 15).widthIs((SCREEN_WIDTH-30)/2).heightIs(30);
    
    
}
-(void)setModel:(XwOrderDetailModel *)model{
    self.dateLabel.text = [NSString stringWithFormat:@"%@ - %@",model.orderTimeStart,model.orderTimeEnd];
    self.numberLabel.text =[NSString stringWithFormat:@"%@编号:%@",model.progressName,model.orderID];
    self.nameLabel.text =[NSString stringWithFormat:@"操作人:%@",model.operator];
    self.statusLabel.text = model.orderStatusText;
}
-(UILabel*)dateLabel{
    if(!_dateLabel){
        _dateLabel = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentLeft WithFont:14];
        _dateLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _dateLabel;
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
-(UILabel*)statusLabel{
    if(!_statusLabel){
        _statusLabel = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentRight WithFont:14];
        _statusLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _statusLabel;
}

@end
