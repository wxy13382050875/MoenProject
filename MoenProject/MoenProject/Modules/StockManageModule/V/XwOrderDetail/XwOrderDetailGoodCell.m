//
//  XwOrderDetailGoodCell.m
//  MoenProject
//
//  Created by wuxinyi on 2021/12/11.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "XwOrderDetailGoodCell.h"
@interface XwOrderDetailGoodCell ()
@property(nonatomic,strong)UIImageView *goodsImg;
@property(nonatomic,strong)UILabel* goodsCode;
@property(nonatomic,strong)UILabel* goodsName;
@property(nonatomic,strong)UILabel* goodsCount;
@property(nonatomic,strong)UILabel* goodsStatus;
@property(nonatomic,strong)UIView* packView;
@property(nonatomic,strong)UILabel* goodsPackageDes;
@property(nonatomic,strong)UIImageView* showDetailImage;

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
    [self.contentView addSubview:self.packView];
    [self.packView addSubview:self.goodsPackageDes];
    [self.packView addSubview:self.showDetailImage];
    
    
}
-(void)xw_updateConstraints{
    self.goodsImg.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(self.contentView, 15).widthIs(90).heightIs(90);
    
    self.goodsCode.sd_layout.leftSpaceToView(self.goodsImg, 15).topEqualToView(self.goodsImg).rightSpaceToView(self.contentView, 15).heightIs(30);
    self.goodsName.sd_layout.leftSpaceToView(self.goodsImg, 15).topSpaceToView(self.goodsCode, 0).rightSpaceToView(self.contentView, 15).heightIs(30);
    self.goodsStatus.sd_layout.topSpaceToView(self.goodsName, 0).rightSpaceToView(self.contentView, 15).heightIs(30).widthIs(150);
    
    self.goodsCount.sd_layout.topSpaceToView(self.goodsName, 0).leftSpaceToView(self.goodsImg, 15).rightSpaceToView(self.goodsStatus, 15).heightIs(30);
    
    self.packView.sd_layout.leftSpaceToView(self.contentView, 15).rightSpaceToView(self.contentView, 15).bottomEqualToView(self.contentView).heightIs(40);
    
    self.goodsPackageDes.sd_layout.leftSpaceToView(self.packView, 15).topEqualToView(self.packView).bottomEqualToView(self.packView).widthIs((SCREEN_WIDTH -30)/2);
    
    self.showDetailImage.sd_layout.rightEqualToView(self.packView).centerYEqualToView(self.packView).widthIs(25).heightIs(15);
}
-(void)setModel:(Goodslist *)model{
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.goodsIMG] placeholderImage:ImageNamed(@"defaultImage")];
    self.goodsCode.text = model.goodsSKU;
    self.goodsName.text = model.goodsName;
    self.isShowDetail = model.isShowDetail;
    self.goodsCount.text = [NSString stringWithFormat:@"x%@",model.goodsCount];
    self.goodsStatus.text = model.goodsStatus;
    if (model.goodsPackage.goodsList.count > 0) {
        [self.packView setHidden:NO];
        NSString* strPackageDes=@"";
        for (Goodslist* tmModel in model.goodsPackage.goodsList) {
            strPackageDes = [NSString stringWithFormat:@"%@ %@",strPackageDes,tmModel.goodsSKU];
        }
        self.goodsPackageDes.text = strPackageDes;
    }
    else
    {
        [self.packView setHidden:YES];
    }

    if (model.isShowDetail) {
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
        _goodsStatus = [UILabel labelWithText:@"" WithTextColor:[UIColor blueColor] WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentRight WithFont:14];
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
- (void)tapClick {
    if (self.goodsShowDetailBlock) {
        self.goodsShowDetailBlock(!self.isShowDetail);
    }
}
@end
