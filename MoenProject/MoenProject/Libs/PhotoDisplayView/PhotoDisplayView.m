//
//  PhotoDisplayView.m
//  NewHaoXiaDan
//
//  Created by 鞠鹏 on 2017/9/16.
//  Copyright © 2017年 YouZheng. All rights reserved.
//

#import "PhotoDisplayView.h"
#import "SDCycleScrollView.h"
@interface PhotoDisplayView ()<SDCycleScrollViewDelegate>

@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,strong) NSArray *showTitleArray;

@property (nonatomic,strong) NSArray *showphotoArray;

@end

@implementation PhotoDisplayView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI{
//    self.alpha = 0.38;
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self placeholderImage:ImageNamed(@"defaultImage")];
    self.cycleScrollView.backgroundColor = [UIColor blackColor];
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.autoScroll = NO;
    self.cycleScrollView.infiniteLoop = NO;
    self.cycleScrollView.showPageControl = NO;
    self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    
    
    [self addSubview:self.cycleScrollView];

    [self addSubview:self.titleLabel];
    
}


#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    self.titleLabel.text = self.showTitleArray[index];

}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
 
    if (self.superview) {
        [self removeFromSuperview];
    }
}


#pragma mark - setter 

- (void)setPhtotoArray:(NSArray *)phtotoArray{
    _phtotoArray = phtotoArray;
    self.cycleScrollView.imageURLStringsGroup = phtotoArray;
    self.showphotoArray = [NSArray arrayWithArray:phtotoArray];
    
    
    NSMutableArray *titleArray = [NSMutableArray array];
    for (NSInteger i = 0; i < phtotoArray.count; i ++) {
        NSString *title = [NSString stringWithFormat:@"%ld/%ld",(i + 1),phtotoArray.count];
        [titleArray addObject:title];
    }
    self.titleArray = [NSArray arrayWithArray:titleArray];
    self.showTitleArray = [NSArray arrayWithArray:titleArray];
    
    self.titleLabel.text = self.showTitleArray.firstObject;

}




- (void)setSelectIndex:(NSInteger )selectIndex{
    _selectIndex = selectIndex;

    self.cycleScrollView.myNowIndex = selectIndex;
//    NSMutableArray *showTitleArray = [NSMutableArray arrayWithArray:self.titleArray];
//    NSMutableArray *showPhotoArray = [NSMutableArray arrayWithArray:self.phtotoArray];
//    
//   NSArray *frontTitleArr = [showTitleArray subarrayWithRange:NSMakeRange(0, selectIndex)];
//    [showTitleArray removeObjectsInArray:frontTitleArr];
//    [showTitleArray addObjectsFromArray:frontTitleArr];
//    
//    NSArray *frontPhotoArr = [showPhotoArray subarrayWithRange:NSMakeRange(0, selectIndex)];
//    [showPhotoArray removeObjectsInArray:frontPhotoArr];
//    [showPhotoArray addObjectsFromArray:frontPhotoArr];
//
//    self.showTitleArray = [NSMutableArray arrayWithArray:showTitleArray];
//    self.showphotoArray = [NSMutableArray arrayWithArray:showPhotoArray];
//    
//    self.cycleScrollView.imageURLStringsGroup = showPhotoArray;
//    self.titleLabel.text = self.showTitleArray.firstObject;
}

#pragma mark - getter

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        CGFloat titleorinY = SCREEN_HEIGHT * 560/667;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,titleorinY, SCREEN_WIDTH, 16.0)];
        _titleLabel.font = FONT(14.0f);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

@end
