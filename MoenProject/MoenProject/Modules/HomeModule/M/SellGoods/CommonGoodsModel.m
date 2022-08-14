//
//  CommonGoodsModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/18.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CommonGoodsModel.h"

@implementation CommonGoodsListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"selectProducts" : [CommonGoodsModel class]};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"selectProducts" : @"CommonGoodsModel"
             };
}

@end

@implementation CommonGoodsModel
- (id)copyWithZone:(NSZone *)zone {
    CommonGoodsModel *p = [[CommonGoodsModel allocWithZone:zone] init];
    //属性也要拷贝赋值
    p.id = [self.id mutableCopy];
    p.name = [self.name mutableCopy];
    p.gcode = [self.gcode mutableCopy];
    p.price = [self.price mutableCopy];
    p.photo = [self.photo mutableCopy];
    p.code = [self.code mutableCopy];
    p.activityName = [self.activityName mutableCopy];
    p.comboDescribe = [self.comboDescribe mutableCopy];
    p.isSetMeal = self.isSetMeal;
    p.isSpecial = self.isSpecial;
    p.productList = [self.productList mutableCopy];
    p.sectionCellList = [self.sectionCellList mutableCopy];
    p.isOpenShow = self.isOpenShow;
    p.isShowDetail = self.isShowDetail;
    p.kGoodsCount = self.kGoodsCount;
    p.kGoodsArea = self.kGoodsArea;
    p.kAddPrice = self.kAddPrice;
    p.kGoodsCode = [self.kGoodsCode mutableCopy];
    p.minNum = [self.minNum mutableCopy];
    
    return p;
}
//
//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    return @{@"productList" : [CommonProdutcModel class]};
//}
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"productList" : @"CommonProdutcModel"
             };
}
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id",@"gcode":@"code"};
}


- (void)setID:(NSString *)ID
{
    _ID = ID;
    [self handleSectionCellData];
}


- (void)setIsOpenShow:(BOOL)isOpenShow
{
    _isOpenShow = isOpenShow;
    [self handleSectionCellData];
}

- (void)handleSectionCellData
{
    [self.sectionCellList removeAllObjects];
    CommonTVDataModel *model = [[CommonTVDataModel alloc] init];
    if (self.isSetMeal) {
        model.cellHeight = 140;
        model.cellIdentify = @"CommonSingleGoodsTCell";
    }
    else
    {
        model.cellHeight = 115;
        if (self.isSpecial) {
            model.cellIdentify = @"CommonSingleGoodsTCell";
        }
        else
        {
            model.cellIdentify = @"CommonSingleGoodsTCell";
        }
    }
    [self.sectionCellList addObject:model];
    if (self.isOpenShow) {
        if (self.productList.count) {
            for (CommonGoodsModel *goodsModel in self.productList) {
                CommonTVDataModel *model = [[CommonTVDataModel alloc] init];
                model.cellHeight = 118;
                model.cellIdentify = @"CommonSingleGoodsDarkTCell";
                [self.sectionCellList addObject:model];
            }
        }
    }
}





- (NSMutableArray *)sectionCellList
{
    if (!_sectionCellList) {
        _sectionCellList = [[NSMutableArray alloc] init];
    }
    return _sectionCellList;
}
@end


@implementation CommonProdutcModel
@dynamic code;
- (id)copyWithZone:(NSZone *)zone {
    CommonProdutcModel *p = [[CommonProdutcModel allocWithZone:zone] init];
    //属性也要拷贝赋值
    p.sku = [self.sku mutableCopy];
    p.name = [self.name mutableCopy];
    p.photo = [self.photo mutableCopy];
    p.price = [self.price mutableCopy];
    p.count = self.count;
    p.codePu = [self.codePu mutableCopy];
    p.addPrice = [self.addPrice mutableCopy];
    p.square = [self.square mutableCopy];
    p.returnCount = self.returnCount;
    p.isSpecial = self.isSpecial;
    
    return p;
}

@end

@implementation CommonMealProdutcModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"productList" : [CommonProdutcModel class]};
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"codeStr":@"code"};
}

@end




