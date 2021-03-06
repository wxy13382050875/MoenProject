//
//  WMZDialog+Calander.m
//  WMZDialog
//
//  Created by wmz on 2019/11/7.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZDialog+Calander.h"
#define NumberMounthes 12
#define allCount 42
static NSString *currentYearKey = @"currentYearKey";
static NSString *currenMonthKey = @"currenMonthKey";
static NSString *currenDayKey = @"currenDayKey";
static NSString *currenModelKey = @"currentModelKey";
static NSString *currentIndexKey = @"currentIndexKey";
static NSString *todayKey = @"todayKey";
@interface WMZDialog()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,assign)NSInteger currentYear;
@property(nonatomic,assign)NSInteger currentMonth;
@property(nonatomic,assign)NSInteger currentDay;
@property(nonatomic,strong)NSString *today;
@property(nonatomic,strong)CalanderModel *selecctCalanderModel;
@property(nonatomic,assign)NSInteger currentIndex;
@end
@implementation WMZDialog (Calander)

- (UIView*)calanderAction{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *currentDate = [[NSDate alloc]init];
    self.currentYear = [NSDate year:currentDate];
    self.currentMonth = [NSDate month:currentDate];
    self.currentDay = [NSDate day:currentDate];
    self.today = [NSString stringWithFormat:@"%ld-%ld-%ld",self.currentYear,self.currentMonth,self.currentDay];
    
    //默认带圆点的日期
    if (self.wDateShowCircle) {
        NSMutableArray *arr = [NSMutableArray new];
        for (id data in self.wDateShowCircle) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:data];
                if ([dic[@"date"] isKindOfClass:[NSDate class]]) {
                    NSDate *date = dic[@"date"];
                    NSString *strDate = [dateFormatter stringFromDate:date];
                    [dic setObject:strDate forKey:@"date"];
                    [self.tempArr addObject:strDate];
                }
                [arr addObject:dic];
            }else if ([data isKindOfClass:[NSDate class]]){
                 NSString *strDate = [dateFormatter stringFromDate:data];
                [arr addObject:@{@"date":strDate}];
                [self.tempArr addObject:strDate];
            }
        }
        self.wDateShowCircle = [NSArray arrayWithArray:arr];
    }
    
    self.diaLogHeadView = [self addTopView];
    [self.OKBtn addTarget:self action:@selector(calanderOKAction) forControlEvents:UIControlEventTouchUpInside];

    UIView *headView = [UIView new];
    
    UIView *titleView = [UIView new];
    [titleView addSubview:self.textLabel];
    self.textLabel.frame = CGRectMake((self.wWidth-100)/2 , 0, 100, 40);
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    titleView.frame = CGRectMake(0, 0, self.wWidth, self.wMessage.length?self.textLabel.frame.size.height:40);
    
    NSString *left = [self.dialogBundle pathForResource:@"dia_right" ofType:@"png"];
    NSString *right = [self.dialogBundle pathForResource:@"dia_left" ofType:@"png"];
    NSString *today = [self.dialogBundle pathForResource:@"dia_today" ofType:@"png"];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(CGRectGetMinX(self.textLabel.frame)-self.wMainOffsetX*2 - 40, 0, 40, titleView.frame.size.height);
    [leftBtn setImage:[UIImage imageWithContentsOfFile:left] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(lastValue) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(nextValue) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageWithContentsOfFile:right] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame)+self.wMainOffsetX*2, 0, 40, titleView.frame.size.height);
    
    UIButton *todayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [todayBtn addTarget:self action:@selector(scrollToToday) forControlEvents:UIControlEventTouchUpInside];
    [todayBtn setImage:[UIImage imageWithContentsOfFile:today] forState:UIControlStateNormal];
    todayBtn.frame = CGRectMake(titleView.frame.size.width-40-self.wMainOffsetX, 0, 40, titleView.frame.size.height);
    
    [titleView addSubview:leftBtn];
    [titleView addSubview:rightBtn];
    [titleView addSubview:todayBtn];
    [headView addSubview:titleView];
    leftBtn.hidden = self.wHideCalanderBtn;
    todayBtn.hidden = self.wHideCalanderBtn;
    rightBtn.hidden = self.wHideCalanderBtn;
    
    NSArray *weekTitleArray = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    for (int i = 0; i < weekTitleArray.count; i++) {
        UILabel *weekTitleLable = [[UILabel alloc]initWithFrame:CGRectMake(i * ((self.wWidth/(weekTitleArray.count))), CGRectGetMaxY(titleView.frame), self.wWidth/(weekTitleArray.count ), 40)];
        if (i == 0 || i == 6) {
            weekTitleLable.textColor = self.wOKColor;
        }else{
            weekTitleLable.textColor = DialogColor(0x333333);
        }
        weekTitleLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        weekTitleLable.text = [weekTitleArray objectAtIndex:i];
        weekTitleLable.textAlignment = NSTextAlignmentCenter;
        [headView addSubview:weekTitleLable];
    }
    headView.frame = CGRectMake(0, CGRectGetMaxY(self.diaLogHeadView.frame), self.wWidth, 40+titleView.frame.size.height);
    [self.mainView addSubview:headView];
    
    self.layout = [[UICollectionViewFlowLayout alloc]init];
    self.layout.minimumLineSpacing = 0;
    self.layout.minimumInteritemSpacing = 0;
    self.layout.scrollDirection = self.wDirectionVertical?UICollectionViewScrollDirectionVertical:UICollectionViewScrollDirectionHorizontal;
    self.layout.itemSize = CGSizeMake(self.wWidth/weekTitleArray.count, 50);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(headView.frame)+self.wMainOffsetY, self.wWidth, self.layout.itemSize.height*6) collectionViewLayout:self.layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[WMZDialogCollectionCell class] forCellWithReuseIdentifier:@"WMZDialogCollectionCell"];
    [self.collectionView registerClass:[WMZDialogCalanderCell class] forCellWithReuseIdentifier:@"WMZDialogCalanderCell"];
    if (self.wReginerCollectionCell) {
        [self.collectionView registerClass:[NSClassFromString(self.wReginerCollectionCell) class] forCellWithReuseIdentifier:self.wReginerCollectionCell];
    }
    self.collectionView.delegate = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.scrollEnabled = self.wCalanderCanScroll;
    [self.mainView addSubview:self.collectionView];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = NO;
    }
    
    for (int i = 0; i <NumberMounthes ; i++ ) {
        NSMutableArray *array = [NSMutableArray new];
        [self.dataArr addObject:array];
        [self updateDateYear:self.currentYear Month:self.currentMonth-i-1 index:i];
    }
    [self.dataArr  sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return NSOrderedDescending;
    }];
    
    NSMutableArray *array = [NSMutableArray new];
    [self.dataArr addObject:array];
    [self updateDateYear:self.currentYear Month:self.currentMonth index:NumberMounthes];
    
    for (int i = 0; i <NumberMounthes ; i++ ) {
        NSMutableArray *array = [NSMutableArray new];
        [self.dataArr addObject:array];
        [self updateDateYear:self.currentYear Month:self.currentMonth+i+1 index:i+NumberMounthes+1];
    }
    [self scrollIndexPath:NumberMounthes shouldReloadData:YES animal:NO first:YES];
    self.currentIndex = NumberMounthes;
    
    [self reSetMainViewFrame:CGRectMake(0,0,self.wWidth, CGRectGetMaxY(self.collectionView.frame))];
    [WMZDialogTool setView:self.mainView Radii:CGSizeMake(self.wMainRadius,self.wMainRadius) RoundingCorners:UIRectCornerTopLeft |UIRectCornerTopRight];
    return self.mainView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [(NSArray*)[self.dataArr objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArr.count;
}
//这里是自定义cell,非常简单的自定义
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CalanderModel *model = self.dataArr[indexPath.section][indexPath.row];
    if (self.wCalanderCell) {
        return self.wCalanderCell(indexPath,collectionView,model);
    }
    
    WMZDialogCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.wOpenChineseDate?@"WMZDialogCollectionCell":@"WMZDialogCalanderCell"  forIndexPath:indexPath];
    cell.dateLable.text = [NSString stringWithFormat:@"%ld",model.wDay];
    cell.chineseLable.text = model.wChineseDate;
    //不可选中的部分
    if (model.wLastMonth||model.wNextMonth) {
        cell.circleLabel.text = @"";
        cell.dateLable.textColor = DialogColor(0xD9D9D9);
        cell.chineseLable.textColor = model.wHadHolday?DialogColor(0xFFCCCC):DialogColor(0xD3D3D3);
        cell.contentView.backgroundColor = DialogColor(0xffffff);
    }else{
        if (model.wShowCircle) {
            cell.circleLabel.text = @"●";
        }else{
            cell.circleLabel.text = @"";
        }
        cell.circleLabel.textColor = model.wCircleColor?:[UIColor orangeColor];
        //被选中
        if (model.wSelected) {
            cell.dateLable.textColor = DialogColor(0xFFFFFF);
            cell.chineseLable.textColor = DialogColor(0xFFFFFF);
            cell.contentView.backgroundColor = self.wOKColor;
        }else{
            //今天
            if ([[NSString stringWithFormat:@"%ld-%ld-%ld",model.wYear,model.wMonth,model.wDay] isEqualToString:self.today]) {
                cell.dateLable.textColor = self.wOKColor;
                cell.chineseLable.textColor = self.wOKColor;
            }else{
                //正常
                cell.dateLable.textColor = DialogColor(0x333333);
                cell.chineseLable.textColor = model.wHadHolday?[UIColor redColor]:DialogColor(0x666666);
            }
            cell.contentView.backgroundColor = DialogColor(0xffffff);
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CalanderModel *model = self.dataArr[indexPath.section][indexPath.row];
    if (self.wCalanderCellClick) {
        self.wCalanderCellClick(indexPath,collectionView,model);
    }
    if (model.wLastMonth||model.wNextMonth) return;
    if (!self.wMultipleSelection) {
        if (self.selecctCalanderModel!=model) {
            self.selecctCalanderModel.wSelected = NO;
        }
    }
    
    model.wSelected = !model.wSelected;
    
    if (self.wMultipleSelection) {
        if (model.wSelected) {
            [self.selectArr addObject:model];
        }else{
            if ([self.selectArr indexOfObject:model]!= NSNotFound) {
                [self.selectArr removeObject:model];
            }
        }
    }
    self.selecctCalanderModel = model;
    [UIView performWithoutAnimation:^{
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:indexPath.section];
        [self.collectionView reloadSections:reloadSet];
    }];
    NSLog(@"%ld %ld %ld %@",model.wYear,model.wMonth,model.wDay,model.wDetailChineseDate);
}

//手动拖动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self loadDataScrollView:scrollView];
}

//点击上下月
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self loadDataScrollView:scrollView];
}

//预加载
- (void)loadDataScrollView:(UIScrollView*)scrollView{
    if (scrollView != self.collectionView) return;
    int index = self.wDirectionVertical?(scrollView.contentOffset.y/scrollView.frame.size.height):(scrollView.contentOffset.x/scrollView.frame.size.width);
    if (index<0||index>self.dataArr.count-1) return;
    NSMutableArray *arr = self.dataArr[index];
    self.currentIndex = index;
    for (CalanderModel *model in arr) {
        if (!model.wLastMonth&&!model.wNextMonth){
            self.currentYear = model.wYear;
            self.currentMonth = model.wMonth;
            self.currentDay = model.wDay;
            break;
        }
    }
    //首个或者最后一个 预加载上个和下个
    if (self.currentIndex  == 0 || self.currentIndex  == self.dataArr.count - 1 ) {
        NSMutableArray *arr = [NSMutableArray new];
        if (self.currentIndex  == 0) {
            [self.dataArr insertObject:arr atIndex:0];
        }else{
            [self.dataArr addObject:arr];
        }
        [self updateDateYear:self.currentYear Month:self.currentIndex  == 0?(self.currentMonth-1):(self.currentMonth+1) index:self.currentIndex  == 0?0:self.dataArr.count-1];
             
        if (self.currentIndex == 0) {
            [self scrollIndexPath:1 shouldReloadData:NO animal:NO first:NO];
        }
        [self.collectionView reloadData];
    }
}

//确定
- (void)calanderOKAction{
    [self closeView];
    if (self.wMultipleSelection) {
        NSLog(@"%@",self.selectArr);
    }
    if (self.wEventOKFinish) {
        if (self.wMultipleSelection) {
            if (self.selectArr.count) {
                self.wEventOKFinish(@"选中的日期", self.selectArr);
            }else{
                self.wEventOKFinish(@"暂无选中", nil);
            }
        }else{
            if (self.selecctCalanderModel) {
                self.wEventOKFinish([NSString stringWithFormat:@"%ld-%ld-%ld",self.selecctCalanderModel.wYear,self.selecctCalanderModel.wMonth,self.selecctCalanderModel.wDay], self.selecctCalanderModel);
            }else{
                self.wEventOKFinish(@"暂无选中", nil);
            }
        }
    }
}

//lastValue
- (void)lastValue{
    self.currentIndex-=1;
    if (self.currentIndex < 0) {
        self.currentIndex = 0;
    }
    [self scrollIndexPath:self.currentIndex shouldReloadData:NO animal:YES first:NO];
    
}

//nextValue
- (void)nextValue{
    self.currentIndex+=1;
    if (self.currentIndex >= self.dataArr.count) {
        self.currentIndex = self.dataArr.count-1;
    }
    [self scrollIndexPath:self.currentIndex shouldReloadData:NO animal:YES first:NO];

}

//回到今天
- (void)scrollToToday{
    [self scrollIndexPath:NumberMounthes shouldReloadData:NO animal:YES first:NO];
}


//更新数据
- (void)updateDateYear:(NSInteger)year Month:(NSInteger)month index:(NSInteger)index{
    if (self.dataArr.count <= index) return;
    [[self.dataArr objectAtIndex:index] removeAllObjects];
    if (month > 12) {
        int num = (month/12.0);
        month = month - (num+1)*12 ;
        year += (num+1);
    }
    if (month < 1) {
        int num = (month/-12);
        month = month + (num+1)*12 ;
        year -= (num+1);
    }
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSDateComponents *components = [[NSDateComponents alloc]init];
    components.month = month;
    components.year = year;
    components.day = 1;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *nowDate = [calendar dateFromComponents:components];
    
    nowDate = [nowDate dateByAddingTimeInterval: [zone secondsFromGMTForDate: nowDate]];
    if (components.month <= 1) {
        components.month = 12;
        components.year -= 1;
    }else{
        components.month -= 1;
    }
    NSDate *nextDate = [calendar dateFromComponents:components];
    nextDate = [nextDate dateByAddingTimeInterval: [zone secondsFromGMTForDate: nextDate]];
    NSInteger DaysInNextMonth = [NSDate totaldaysInMonth:nextDate];
    
    NSInteger firstDayInThisMounth = [NSDate firstWeekdayInThisMonth:nowDate];
    NSInteger daysInThisMounth = [NSDate totaldaysInMonth:nowDate];
    NSInteger tmpDay = 0;
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    
    for (int j = 0; j < allCount ; j++) {
        NSInteger tmpYear = year;
        NSInteger tmpMonth = month;
        CalanderModel *model = [CalanderModel new];
        if (j < firstDayInThisMounth) {
            if (tmpMonth <= 1) {
                tmpMonth = 12;
                tmpYear -= 1;
            }else{
                tmpMonth -= 1;
            }
            tmpDay = DaysInNextMonth - firstDayInThisMounth + j + 1;
            model.wLastMonthSet(YES);
        }else if(j > daysInThisMounth + firstDayInThisMounth - 1){
            if (tmpMonth >= 12) {
                tmpMonth = 1;
                tmpYear += 1;
            }else{
                tmpMonth+= 1;
            }
            tmpDay = j - (daysInThisMounth + firstDayInThisMounth - 1);
            model.wNextMonthSet(YES);
        }else{
            tmpDay = j - firstDayInThisMounth + 1;
        }
        NSString *detaMonth = tmpMonth<10?[NSString stringWithFormat:@"0%ld",tmpMonth]:[NSString stringWithFormat:@"%ld",tmpMonth];
        NSString *detaDay = tmpDay<10?[NSString stringWithFormat:@"0%ld",tmpDay]:[NSString stringWithFormat:@"%ld",tmpDay];
        NSString *dateStr = [NSString stringWithFormat:@"%ld-%@-%@",tmpYear,detaMonth,detaDay];
        
        NSDate *myDate = [dateFormatter dateFromString:dateStr];
        NSDictionary *dic = [NSDate getChineseCalendarWithDate:myDate Year:tmpYear Month:tmpMonth Day:tmpDay];
        
        //判断是否显示圆点
        if (self.wDateShowCircle&&!model.wLastMonth&&!model.wLastMonth) {
            NSUInteger index = [self.tempArr indexOfObject:dateStr];
            if (index!=NSNotFound) {
                model.wShowCircleSet(YES);
                NSDictionary *dic = self.wDateShowCircle[index];
                UIColor *color = dic[@"color"];
                if (color) {
                    model.wCircleColorSet(color);
                }
            }
        }
        
        model.wYearSet(tmpYear)
        .wMonthSet(tmpMonth)
        .wDaySet(tmpDay)
        .wDateSet(myDate)
        .wDetailChineseDateSet(dic[@"detail"])
        .wHadHoldaySet([dic[@"holday"] boolValue])
        //获取实际下标
        .wIndexSet(self.wDirectionVertical?j:(j%7*6+j/7))
        .wChineseDateSet(dic[@"name"]);
        [[self.dataArr objectAtIndex:index] insertObject:model atIndex:j];
    }
    
    if (!self.wDirectionVertical) {
        NSMutableArray *arr = [self.dataArr objectAtIndex:index];
        [arr sortUsingComparator:^NSComparisonResult(CalanderModel * _Nonnull obj1,  CalanderModel * obj2) {
            return obj1.wIndex>obj2.wIndex;
        }];
    }

}

//刷新后滚动
- (void)scrollIndexPath:(NSInteger)section shouldReloadData:(BOOL)reloadData animal:(BOOL)animal first:(BOOL)first{
    if (reloadData) {
        [UIView animateWithDuration:0.01 animations:^{
            [self.collectionView reloadData];
        } completion:^(BOOL finished) {
            if (first) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (finished) {
                        if (self.wDirectionVertical) {
                            [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.frame.size.height*section) animated:animal];
                        }else{
                            [self.collectionView setContentOffset:CGPointMake(self.collectionView.frame.size.width*section, 0) animated:animal];
                        }
                    }
                });
            }else{
                if (finished) {
                    if (self.wDirectionVertical) {
                        [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.frame.size.height*section) animated:animal];
                    }else{
                        [self.collectionView setContentOffset:CGPointMake(self.collectionView.frame.size.width*section, 0) animated:animal];
                    }
                }
            }
        }];
    }else{
        if (first) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.wDirectionVertical) {
                    [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.frame.size.height*section) animated:animal];
                }else{
                    [self.collectionView setContentOffset:CGPointMake(self.collectionView.frame.size.width*section, 0) animated:animal];
                }
            });
        }else{
            if (self.wDirectionVertical) {
                [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.frame.size.height*section) animated:animal];
            }else{
                [self.collectionView setContentOffset:CGPointMake(self.collectionView.frame.size.width*section, 0) animated:animal];
            }
        }
    }
}


- (NSInteger)currentYear{
    return  [objc_getAssociatedObject(self, &currentYearKey) integerValue];
}

- (void)setCurrentYear:(NSInteger)currentYear{
    objc_setAssociatedObject(self, &currentYearKey, @(currentYear), OBJC_ASSOCIATION_ASSIGN);
    self.textLabel.text = [NSString stringWithFormat:@"%ld年%ld月",currentYear,self.currentMonth];
    
}

- (NSInteger)currentMonth{
    return  [objc_getAssociatedObject(self, &currenMonthKey) integerValue];
}

- (void)setCurrentMonth:(NSInteger)currentMonth{
    objc_setAssociatedObject(self, &currenMonthKey, @(currentMonth), OBJC_ASSOCIATION_ASSIGN);
    self.textLabel.text = [NSString stringWithFormat:@"%ld年%ld月",self.currentYear,currentMonth];
    
}

- (NSInteger)currentDay{
    return  [objc_getAssociatedObject(self, &currenDayKey) integerValue];
}

- (void)setCurrentDay:(NSInteger)currentDay{
    objc_setAssociatedObject(self, &currenDayKey, @(currentDay), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)currentIndex{
     return  [objc_getAssociatedObject(self, &currentIndexKey) integerValue];
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
     objc_setAssociatedObject(self, &currentIndexKey, @(currentIndex), OBJC_ASSOCIATION_ASSIGN);
}

- (CalanderModel *)selecctCalanderModel{
    return objc_getAssociatedObject(self, &currenModelKey);
}

- (void)setSelecctCalanderModel:(CalanderModel *)selecctCalanderModel{
    objc_setAssociatedObject(self, &currenModelKey, selecctCalanderModel, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)today{
    return objc_getAssociatedObject(self, &todayKey);
}

- (void)setToday:(NSString *)today{
    objc_setAssociatedObject(self, &todayKey, today, OBJC_ASSOCIATION_RETAIN);
}

@end

@implementation WMZDialogCollectionCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self UI];
    }
    return self;
}

- (void)UI{
    CGRect frame =  self.frame;
    
    [self addSubview:self.dateLable];
    self.dateLable.frame = CGRectMake(0, 0, frame.size.width, frame.size.height*0.5);
    
    [self addSubview:self.chineseLable];
    self.chineseLable.frame = CGRectMake(0, CGRectGetMaxY(self.dateLable.frame), frame.size.width, frame.size.height*0.3);
    
    [self addSubview:self.circleLabel];
    self.circleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.chineseLable.frame), frame.size.width, 10);
    
}

- (UILabel *)dateLable{
    if (!_dateLable) {
        _dateLable = [UILabel new];
        [_dateLable setTextAlignment:NSTextAlignmentCenter];
        [_dateLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19.0]];
        _dateLable.textColor = DialogColor(0x333333);
    }
    return _dateLable;
}

- (UILabel *)chineseLable{
    if (!_chineseLable) {
        _chineseLable = [UILabel new];
        [_chineseLable setTextAlignment:NSTextAlignmentCenter];
        [_chineseLable setFont:[UIFont systemFontOfSize:12.0f]];
        _chineseLable.textColor = DialogColor(0x666666);
    }
    return _chineseLable;
}

- (UILabel *)circleLabel{
    if (!_circleLabel) {
        _circleLabel = [UILabel new];
        [_circleLabel setTextAlignment:NSTextAlignmentCenter];
        [_circleLabel setFont:[UIFont systemFontOfSize:7.0f]];
        _circleLabel.textColor = [UIColor orangeColor];
    }
    return _circleLabel;
}
@end

@implementation WMZDialogCalanderCell
- (void)UI{
    CGRect frame =  self.frame;
    
    [self addSubview:self.dateLable];
    self.dateLable.frame = CGRectMake(0, 0, frame.size.width, frame.size.height*0.6);
    
    [self addSubview:self.circleLabel];
    self.circleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.dateLable.frame), frame.size.width, 10);
    
}
@end

