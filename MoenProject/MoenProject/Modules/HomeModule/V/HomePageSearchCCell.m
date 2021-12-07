//
//  HomePageSearchCCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/29.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "HomePageSearchCCell.h"
#import "CommonSearchView.h"
@interface HomePageSearchCCell()<SearchViewCompleteDelete>

@property (nonatomic, strong) CommonSearchView *searchView;

@end

@implementation HomePageSearchCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.contentView addSubview:self.searchView];
}

- (void)setIsClearContent:(BOOL)isClearContent
{
    _isClearContent = isClearContent;
    if (isClearContent) {
        [self.searchView clearContent];
    }
}



- (void)completeInputAction:(NSString *)keyStr
{
    if (self.searchBlock) {
        self.searchBlock(keyStr);
    }
}

#pragma mark -- Getter&Setter
- (CommonSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [[[NSBundle mainBundle] loadNibNamed:@"CommonSearchView" owner:self options:nil] lastObject];
        _searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        _searchView.delegate = self;
        _searchView.viewType = CommonSearchViewTypeCustomer;
    }
    return _searchView;
}

@end
