//
//  HomePageBannerCCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/29.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "HomePageBannerCCell.h"
#import "SDCycleScrollView.h"

@interface HomePageBannerCCell()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bannerContainerView;

@property (nonatomic,strong) SDCycleScrollView *advCycleView;


@end

@implementation HomePageBannerCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self configBaseUI];
}

- (void)showDataWithHomeDataModel:(HomeDataModel *)model
{
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    for (HomeBannerModel *itemModel in model.bannerImageData) {
        [imgArr addObject:itemModel.bannerImageUrl];
    }
    self.advCycleView.imageURLStringsGroup = [imgArr copy];
}

/**
 *  配置 SDCycleScrollView
 */
- (void)configBaseUI
{
    [self.contentView addSubview:self.advCycleView];
    
    NSArray *imageArr = @[@"h_banner_icon",@"h_banner_icon",@"h_banner_icon"];
    self.advCycleView.localizationImageNamesGroup = imageArr;
}

#pragma mark -- lazy

- (SDCycleScrollView *)advCycleView{
    
    if (!_advCycleView) {
        _advCycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*170/375) delegate:self placeholderImage:ImageNamed(@"defaultImage")];
        _advCycleView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        _advCycleView.showPageControl = YES;
        _advCycleView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _advCycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _advCycleView.pageControlDotSize = CGSizeMake(10, 10);
        _advCycleView.currentPageDotImage = ImageNamed(@"c_banner_page_selected_icon");
        _advCycleView.pageDotImage  = ImageNamed(@"c_banner_page_icon");
        _advCycleView.autoScrollTimeInterval = 3.;// 自动滚
        
    }
    return _advCycleView;
}


@end
