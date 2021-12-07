//
//  GoodsDetailBannerTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/21.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "GoodsDetailBannerTCell.h"
#import "SDCycleScrollView.h"

@interface GoodsDetailBannerTCell()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bannerContainerView;

@property (nonatomic,strong) SDCycleScrollView *advCycleView;
@end

@implementation GoodsDetailBannerTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self configBaseUI];
}

/**
 *  配置 SDCycleScrollView
 */
- (void)configBaseUI
{
    [self.contentView addSubview:self.advCycleView];
    
//    NSArray *imageArr = @[@"h_banner_icon",@"h_banner_icon",@"h_banner_icon"];
//    self.advCycleView.localizationImageNamesGroup = imageArr;
}

- (void)showDataWithArray:(NSArray *)imgArr
{
    [self.advCycleView setImageURLStringsGroup:imgArr];
}

#pragma mark -- lazy

- (SDCycleScrollView *)advCycleView{
    
    if (!_advCycleView) {
        _advCycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH) delegate:self placeholderImage:ImageNamed(@"defaultImage")];
        _advCycleView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        _advCycleView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _advCycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _advCycleView.pageControlDotSize = CGSizeMake(15, 5);
        _advCycleView.currentPageDotImage = ImageNamed(@"bannerSel");
        _advCycleView.pageDotImage  = ImageNamed(@"bannerNor");
        _advCycleView.autoScrollTimeInterval = 3.;// 自动滚
        _advCycleView.userInteractionEnabled = NO;
//        _advCycleView.placeholderImage = ImageNamed(@"defaultImage");
    }
    return _advCycleView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
