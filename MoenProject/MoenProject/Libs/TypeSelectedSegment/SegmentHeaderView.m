//
//  SegmentHeaderView.m
//  PersonalCenter
//
//  Created by Arch on 2018/8/20.
//  Copyright © 2018年 mint_bin. All rights reserved.
//

#import "SegmentHeaderView.h"
#import "SegmentTypeModel.h"

#define kWidth self.frame.size.width
#define NORMAL_FONT [UIFont systemFontOfSize:15]

@interface SegmentHeaderViewCollectionViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;


@end;

@implementation SegmentHeaderViewCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = NORMAL_FONT;
        _titleLabel.textColor = AppTitleBlackColor;
    }
    return _titleLabel;
}

@end

@interface SegmentHeaderView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, assign) BOOL selectedCellExist;
@property (nonatomic, strong) UIButton *detailBtn;
@end

CGFloat const SegmentHeaderViewHeight = 45;
static NSString * const SegmentHeaderViewCollectionViewCellIdentifier = @"SegmentHeaderViewCollectionViewCell";
static CGFloat const CellSpacing = 15;
static CGFloat const CollectionViewHeight = SegmentHeaderViewHeight;

@implementation SegmentHeaderView

#pragma mark - Life
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
        self.titleArray = titleArray;
        self.selectedIndex = 0;
    }
    return self;
}

#pragma mark - Public Method
- (void)changeItemWithTargetIndex:(NSUInteger)targetIndex {
    if (_selectedIndex == targetIndex) {
        return;
    }
    
    SegmentHeaderViewCollectionViewCell *selectedCell = [self getCell:_selectedIndex];
    SegmentTypeModel *modelSelected = self.titleArray[_selectedIndex];
    modelSelected.isSelected = NO;
    
    if (selectedCell) {
        selectedCell.titleLabel.textColor = AppTitleBlackColor;
    }
    SegmentHeaderViewCollectionViewCell *targetCell = [self getCell:targetIndex];
    SegmentTypeModel *modelTarget = self.titleArray[targetIndex];
    modelTarget.isSelected = YES;
    if (targetCell) {
        targetCell.titleLabel.textColor = AppTitleBlueColor;
    }
    
    _selectedIndex = targetIndex;
    
    [self layoutAndScrollToSelectedItem];
}

#pragma mark - Private Method
- (void)setupSubViews {
    self.backgroundColor = AppBgWhiteColor;
    UIButton *detailBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 0, 40, CollectionViewHeight)];
    [detailBtn setImage:ImageNamed(@"c_detail_down_icon") forState:UIControlStateNormal];
    detailBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [detailBtn addTarget:self action:@selector(detailAction) forControlEvents:UIControlEventTouchDown];
    self.detailBtn = detailBtn;
    [self addSubview:detailBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CollectionViewHeight - 1, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = AppLineBlueGrayColor;
    [self addSubview:lineView];
    
    [self addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(CollectionViewHeight-1);
    }];
}

- (void)detailAction
{
    if ([self.delegate respondsToSelector:@selector(SegmentHeaderViewSelectedBlock:)]) {
        [self.delegate SegmentHeaderViewSelectedBlock:-2];
        [self.detailBtn setImage:ImageNamed(@"s_up_pull_btn_icon") forState:UIControlStateNormal];
    }
}

- (SegmentHeaderViewCollectionViewCell *)getCell:(NSUInteger)Index {
    return (SegmentHeaderViewCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:Index inSection:0]];
}

- (void)layoutAndScrollToSelectedItem {
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView setNeedsLayout];
    [self.collectionView layoutIfNeeded];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

    SegmentTypeModel *modelSelected = self.titleArray[_selectedIndex];
    
    if ([self.delegate respondsToSelector:@selector(SegmentHeaderViewSelectedBlock:)]) {
        [self.delegate SegmentHeaderViewSelectedBlock:modelSelected.ID];
    }
//    if (self.selectedItemHelper) {
//        self.selectedItemHelper(modelSelected.ID);
//    }
    
    SegmentHeaderViewCollectionViewCell *selectedCell = [self getCell:_selectedIndex];
    if (selectedCell) {
        self.selectedCellExist = YES;
        [self updateMoveLineLocation];
    } else {
        self.selectedCellExist = NO;
        //这种情况下updateMoveLineLocation将在self.collectionView滚动结束后执行（代理方法scrollViewDidEndScrollingAnimation）
    }
}

- (void)setupMoveLineDefaultLocation {
   
}

- (void)setDefaultStatus
{
    [self.detailBtn setImage:ImageNamed(@"c_detail_down_icon") forState:UIControlStateNormal];
}

- (void)updateMoveLineLocation {
    SegmentHeaderViewCollectionViewCell *cell = [self getCell:_selectedIndex];
    [UIView animateWithDuration:0.25 animations:^{
        [self.collectionView setNeedsLayout];
        [self.collectionView layoutIfNeeded];
    }];
}

- (CGFloat)getWidthWithContent:(NSString *)content {
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, CollectionViewHeight)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:NORMAL_FONT}
                                        context:nil
                   ];
    return ceilf(rect.size.width);;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    SegmentTypeModel *model = self.titleArray[indexPath.row];
    CGFloat itemWidth = [self getWidthWithContent:model.name];
    return CGSizeMake(itemWidth + 5, SegmentHeaderViewHeight - 2);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SegmentTypeModel *model = self.titleArray[indexPath.row];
    SegmentHeaderViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SegmentHeaderViewCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = model.name;
    if (model.isSelected) {
         cell.titleLabel.textColor = AppTitleBlueColor;
    }
    else
    {
         cell.titleLabel.textColor = AppTitleBlackColor;
    }
   
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self changeItemWithTargetIndex:indexPath.row];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.selectedCellExist) {
        [self updateMoveLineLocation];
    }
}

#pragma mark - Setter
- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray.copy;
    [self.collectionView reloadData];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (self.titleArray == nil && self.titleArray.count == 0) {
        return;
    }
    
    if (selectedIndex >= self.titleArray.count) {
        _selectedIndex = self.titleArray.count - 1;
    } else {
        _selectedIndex = selectedIndex;
    }
    
    //设置初始选中位置
    if (_selectedIndex == 0) {
        [self setupMoveLineDefaultLocation];
    } else {
        [self layoutAndScrollToSelectedItem];
    }
}

#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = CellSpacing;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, CellSpacing, 0, CellSpacing);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth, CollectionViewHeight) collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[SegmentHeaderViewCollectionViewCell class] forCellWithReuseIdentifier:SegmentHeaderViewCollectionViewCellIdentifier];
    }
    return _collectionView;
}

@end
