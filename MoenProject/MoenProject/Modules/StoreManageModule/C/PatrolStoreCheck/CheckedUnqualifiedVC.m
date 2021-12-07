//
//  CheckedUnqualifiedVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/7.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CheckedUnqualifiedVC.h"
#import "PatrolStoreCheckResultTcell.h"
#import "PatrolProblemModel.h"
#import "SDPhotoBrowser.h"

@interface CheckedUnqualifiedVC ()<UITableViewDelegate, UITableViewDataSource, SDPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *imageContainerArr;
//UIImage 数组
@property (nonatomic,strong) NSMutableArray *photoArray;

@property (nonatomic, assign) CGFloat imgWidth;

@property (nonatomic, strong) PatrolProblemModel *dataModel;

@end

@implementation CheckedUnqualifiedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = @"不合格原因";
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = AppBgWhiteColor;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"PatrolStoreCheckResultTcell" bundle:nil] forCellReuseIdentifier:@"PatrolStoreCheckResultTcell"];
}

- (void)configBaseData
{
    self.imgWidth = (SCREEN_WIDTH - 70 - 10) / 3.0;
    [self httpPath_patrolShopProblemDetail];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 500;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatrolStoreCheckResultTcell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatrolStoreCheckResultTcell" forIndexPath:indexPath];
    [cell showDataWithPatrolProblemModel:self.dataModel];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 500);
    footerView.backgroundColor = AppBgWhiteColor;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    lineView.backgroundColor = AppBgBlueGrayColor;
    [footerView addSubview:lineView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 27, SCREEN_WIDTH - 70, 20)];
    titleLab.font = FONTSYS(14);
    titleLab.textColor = AppTitleBlueColor;
    titleLab.text = @"问题描述";
    [footerView addSubview:titleLab];
    
    UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 57, SCREEN_WIDTH - 70, 20)];
    contentLab.font = FONTSYS(14);
    contentLab.textColor = AppTitleBlackColor;
    contentLab.text = self.dataModel.questionDes;
    contentLab.numberOfLines = 2;
    [footerView addSubview:contentLab];
    
    [self createImageContainerBtnWithSuperView:footerView];
    [self configFooterViewSubViewFrame];
    return footerView;
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

- (void)createImageContainerBtnWithSuperView:(UIView *)superView
{
    [self.imageContainerArr removeAllObjects];
    for (int i = 0; i < self.dataModel.questionImages.count; i ++) {
        PatrolProblemImageModel *imageModel = self.dataModel.questionImages[i];
        UIImageView *imageBtn = [[UIImageView alloc] init];
        imageBtn.contentMode = UIViewContentModeScaleAspectFill;
        [imageBtn sd_setImageWithURL:[NSURL URLWithString:imageModel.imageImgUrl] placeholderImage:ImageNamed(@"defaultImage")];
        imageBtn.userInteractionEnabled = YES;
        [imageBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickAction:)]];
        imageBtn.tag = 1000 + i;
        imageBtn.clipsToBounds = YES;
        imageBtn.layer.borderWidth = 1;
        imageBtn.layer.borderColor = AppLineGrayColor.CGColor;
        [superView addSubview:imageBtn];
        [self.imageContainerArr addObject:imageBtn];
    }
}

- (void)configFooterViewSubViewFrame
{
    CGFloat leftPadding = 35;
    CGFloat itemMargin = 5;
    CGFloat startX = leftPadding;
    CGFloat startY = 100;
    
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
}

#pragma mark -- Touch Event
- (void)imageClickAction:(UIGestureRecognizer *)sender
{
    NSInteger atIndex = [sender view].tag - 1000;
    NSInteger imageCount = self.dataModel.questionImages.count;
    SDPhotoBrowser * broser = [[SDPhotoBrowser alloc] init];
    broser.currentImageIndex = atIndex;
    //    broser.sourceImagesContainerView = sender.view;
    broser.imageCount = imageCount;
    broser.delegate = self;
    [broser show];
    
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    PatrolProblemImageModel *imageModel = self.dataModel.questionImages[index];
    return [NSURL URLWithString:imageModel.imageImgUrl];
}



#pragma mark -- HTTP
#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_patrolShopProblemDetail]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_patrolShopProblemDetail]) {
                PatrolProblemModel *dataModel = (PatrolProblemModel *)parserObject;
                self.dataModel = dataModel;
                [self.tableview reloadData];
            }
        }
    }
}

/**巡店问题详情Api*/
- (void)httpPath_patrolShopProblemDetail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(self.questionId) forKey:@"questionId"];
    [parameters setValue:@(self.patrolShopId) forKey:@"patrolShopId"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
    self.requestURL = Path_patrolShopProblemDetail;
}


#pragma mark -- Getter&Setter

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
- (PatrolProblemModel *)dataModel
{
    if (!_dataModel) {
        _dataModel = [[PatrolProblemModel alloc] init];
    }
    return _dataModel;
}
@end
