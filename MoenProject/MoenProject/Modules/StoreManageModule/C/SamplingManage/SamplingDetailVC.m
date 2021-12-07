//
//  SamplingDetailVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/6.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "SamplingDetailVC.h"
#import "SDPhotoBrowser.h"
#import "SamplingSubmitVC.h"

@interface SamplingDetailVC ()<SDPhotoBrowserDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *imageContainerArr;

@property (nonatomic, strong) UILabel *userLab;

@property (nonatomic, strong) UILabel *timeLab;

//UIImage 数组
@property (nonatomic,strong) NSMutableArray *photoArray;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, assign) CGFloat imgWidth;

@end

@implementation SamplingDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.controllerType == SamplingDetailVCTypeSuccess) {
        [self.tableview reloadData];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    if (marr.count > 1) {
        UIViewController *vc = [marr objectAtIndex:marr.count - 2];
        if ([vc isKindOfClass:[SamplingSubmitVC class]]) {
            [marr removeObject:vc];
        }
        self.navigationController.viewControllers = marr;
    }
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.view.backgroundColor = AppBgWhiteColor;
    self.title = @"出样详情";
    [self.view addSubview:self.tableview];
}

- (void)configBaseData
{
    self.imgWidth = (SCREEN_WIDTH - 70 - 10) / 3.0;
    if (self.controllerType == SamplingDetailVCTypeDetail) {
        [self httpPath_productSampleHistory];
    }
}

- (void)createImageContainerBtn:(UIView *)superView
{
    for (int i = 0; i < 9; i ++) {
        UIImageView *imageBtn = [[UIImageView alloc] init];
        imageBtn.frame = CGRectMake(0, 0, 100, 100);
        imageBtn.contentMode = UIViewContentModeScaleAspectFill;
        [imageBtn setImage:ImageNamed(@"s_add_image_icon")];
        imageBtn.userInteractionEnabled = YES;
        [imageBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickAction:)]];
        imageBtn.tag = 1000 + i;
        [imageBtn setHidden:YES];
        imageBtn.clipsToBounds = YES;
        imageBtn.layer.borderWidth = 1;
        imageBtn.layer.borderColor = AppLineGrayColor.CGColor;
        [superView addSubview:imageBtn];
        [self.imageContainerArr addObject:imageBtn];
    }
}

- (void)configSubViewFrame
{
    CGFloat leftPadding = 35;
    CGFloat itemMargin = 5;
    CGFloat startX = leftPadding;
    CGFloat startY = 50;
    
    int feedNumber = 3;
    int rowIndex = 0;
    
    for (int i = 0; i < self.imageContainerArr.count; i ++) {
        UIImageView *btn = self.imageContainerArr[i];
        int imageIndex = i - feedNumber * rowIndex;
        if (imageIndex > (feedNumber - 1)) {
            imageIndex = 0;
            rowIndex ++;
            startX = leftPadding;
            startY = startY + self.imgWidth + itemMargin;
        }
        else
        {
            startX = leftPadding + (self.imgWidth + itemMargin) * imageIndex;
        }
        [btn setFrame:CGRectMake(startX, startY, self.imgWidth, self.imgWidth)];
    }
    
    [self.userLab setFrame:CGRectMake(35, 10, 200, 25)];
//    [self.timeLab setFrame:CGRectMake(35, startY + self.imgWidth + itemMargin + 15, 200, 25)];
}

- (void)updateImageView
{
    NSInteger imageCount = self.photoArray.count;
    for (int i = 0; i < imageCount; i ++) {
        UIImageView *btn = self.imageContainerArr[i];
        [btn setHidden:NO];
        [btn setImage:self.photoArray[i]];
    }
    if (imageCount < 9) {
        UIImageView *btn = self.imageContainerArr[imageCount];
        [btn setHidden:NO];
        [btn setImage:ImageNamed(@"s_add_image_icon")];
    }
}

- (void)updataImageView
{
    if (self.controllerType == SamplingDetailVCTypeDetail) {
        NSInteger imageCount = self.dataModel.list.count;
        for (int i = 0; i < imageCount; i ++) {
            ProductSampleResultImageModel *imageModel = self.dataModel.list[i];
            UIImageView *imageView = self.imageContainerArr[i];
            [imageView setHidden:NO];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.smallUrl] placeholderImage:ImageNamed(@"defaultImage")];
        }
        if (imageCount == 0) {
            imageCount = 1;
        }
        UIImageView *lastImg = self.imageContainerArr[imageCount - 1];
        [self.timeLab setFrame:CGRectMake(35, lastImg.frame.origin.y + self.imgWidth + 5 + 15, 200, 25)];
    }
    else
    {
        NSInteger imageCount = self.dataModel.list.count;
        for (int i = 0; i < imageCount; i ++) {
            ProductSampleResultImageModel *imageModel = self.dataModel.list[i];
            UIImageView *imageView = self.imageContainerArr[i];
            [imageView setHidden:NO];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.smallUrl] placeholderImage:ImageNamed(@"defaultImage")];
        }
        if (imageCount == 0) {
            imageCount = 1;
        }
        UIImageView *lastImg = self.imageContainerArr[imageCount - 1];
        [self.timeLab setFrame:CGRectMake(35, lastImg.frame.origin.y + self.imgWidth + 5 + 15, 200, 25)];
    }
}

- (void)updataDescribeInfo
{
    if (self.controllerType == SamplingDetailVCTypeDetail) {
        self.userLab.text = self.dataModel.kOperator;
        self.timeLab.text = self.dataModel.operationTime;
    }
    else
    {
        self.userLab.text = self.dataModel.kOperator;
        self.timeLab.text = self.dataModel.operationTime;
    }
}

- (void)imageClickAction:(UIGestureRecognizer *)sender
{
    NSInteger atIndex = [sender view].tag - 1000;
    NSInteger imageCount = self.dataModel.list.count;
    SDPhotoBrowser * broser = [[SDPhotoBrowser alloc] init];
    broser.currentImageIndex = atIndex;
//    broser.sourceImagesContainerView = sender.view;
    broser.imageCount = imageCount;
    broser.delegate = self;
    [broser show];
}


- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    ProductSampleResultImageModel *imageModel = self.dataModel.list[index];
    return [NSURL URLWithString:imageModel.bigUrl];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SCREEN_HEIGHT - SCREEN_NavTop_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_NavTop_Height)];
    [headerView addSubview:self.userLab];
    [headerView addSubview:self.timeLab];
    [self.imageContainerArr removeAllObjects];
    for (int i = 0; i < 9; i ++) {
        UIImageView *imageBtn = [[UIImageView alloc] init];
        imageBtn.frame = CGRectMake(0, 0, 100, 100);
        imageBtn.contentMode = UIViewContentModeScaleAspectFill;
        [imageBtn setImage:ImageNamed(@"s_add_image_icon")];
        imageBtn.userInteractionEnabled = YES;
        [imageBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickAction:)]];
        imageBtn.tag = 1000 + i;
        [imageBtn setHidden:YES];
        imageBtn.clipsToBounds = YES;
        imageBtn.layer.borderWidth = 1;
        imageBtn.layer.borderColor = AppLineGrayColor.CGColor;
        [headerView addSubview:imageBtn];
        [self.imageContainerArr addObject:imageBtn];
    }
    
    [self configSubViewFrame];
    [self updataImageView];
    [self updataDescribeInfo];
    
    return headerView;
}




#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_productSampleHistory]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_productSampleHistory]) {
                
                ProductSampleResultModel *model = (ProductSampleResultModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    
                    self.dataModel = model;
                    [self.tableview reloadData];
                    if (model.list.count) {
                        self.isShowEmptyData = NO;
                    }else
                    {
                        self.isShowEmptyData = YES;
                    }
                }
                else
                {
                    [[NSToastManager manager] showtoast:model.message];
                }
                
            }
        }
    }
}

/**出样历史Api*/
- (void)httpPath_productSampleHistory
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
    self.requestURL = Path_productSampleHistory;
}



#pragma mark -- Getter&&Setter

- (NSMutableArray *)imageContainerArr
{
    if (!_imageContainerArr) {
        _imageContainerArr = [[NSMutableArray alloc] init];
    }
    return _imageContainerArr;
}

- (NSMutableArray *)photoArray
{
    if (!_photoArray) {
        _photoArray = [[NSMutableArray alloc] init];
    }
    return _photoArray;
}

- (UILabel *)userLab
{
    if (!_userLab) {
        _userLab = [[UILabel alloc] init];
        _userLab.font = FONTLanTingR(14);
        _userLab.textColor = AppTitleBlackColor;
//        _userLab.text = @"李学东";
    }
    return _userLab;
}

- (UILabel *)timeLab
{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = FontBinB(14);
        _timeLab.textColor = AppTitleBlackColor;
//        _timeLab.text = @"2016/01/19 09:19:04";
    }
    return _timeLab;
}

- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_NavTop_Height) style:UITableViewStyleGrouped];
        [_tableview setBackgroundColor:AppBgBlueGrayColor];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        self.comScrollerView = _tableview;
        self.noDataDes = @"暂无出样信息";
    }
    return _tableview;
}


@end
