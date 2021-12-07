//
//  BaseModelFactory.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/27.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "BaseModelFactory.h"
#import "YYModel.h"
#import "WelcomeModel.h"
#import "LoginInfoModel.h"
#import "HomeDataModel.h"
#import "MembershipInfoModel.h"
#import "CommonGoodsModel.h"
#import "StoreActivityDetailModel.h"
#import "AddressInfoModel.h"
#import "ShopPersonalModel.h"
#import "CouponInfoModel.h"
#import "UnLabelUserInfoModel.h"
#import "GoodsDetailModel.h"
#import "PackageDetailModel.h"
#import "CommonTypeModel.h"
#import "SCStatisticsModel.h"
#import "SCExpandModel.h"
#import "MajorCustomerModel.h"
#import "ShopStaffModel.h"
#import "SamplingSingleModel.h"
#import "PatrolShopModel.h"
#import "PatrolShopDetailModel.h"
#import "CouponRecordModel.h"
#import "CouponRecordDetailModel.h"
#import "StoreSalesVolumeModel.h"
#import "StoreSalesPersonalModel.h"
#import "GoodsSalesVolumeModel.h"
#import "PackageRankModel.h"
#import "GoodsCategoryRankModel.h"
#import "StatisticsModel.h"
#import "SalesCounterDataModel.h"
#import "CommonCategoryModel.h"
#import "OrderInfoModel.h"
#import "AddressSelectedModel.h"
#import "OrderManageModel.h"
#import "OrderDetailModel.h"
#import "PatrolProblemModel.h"
#import "CustomerIntentModel.h"
#import "IntentionGoodsModel.h"
#import "ProductSampleResultModel.h"
#import "ReturnOrderInfoModel.h"
#import "ReturnOrderCounterModel.h"
#import "ReturnOrderDetailModel.h"
#import "StoreQRCodeModel.h"
#import "CommonAbountModel.h"


#import "AwardsOverviewModel.h"
#import "AwardsStatisticsModel.h"
#import "AwardsDetailModel.h"
#import "UserTagModel.h"



@implementation BaseModelFactory

+ (MoenBaseModel *)modelWithURL:(NSString *)url responseJson:(NSDictionary *)jsonDict {
    NSString *jsonStr = [NSTool transformTOjsonStringWithObject:jsonDict];
    NSLog(@"jsonStr%@",jsonStr);
    if ([url isEqualToString:Path_oauth_token]) {
        LoginInfoModel *model = [LoginInfoModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    
    if ([url isEqualToString:Path_getHomePage]) {
        HomeDataModel *model = [HomeDataModel yy_modelWithDictionary:jsonDict[@"datas"][@"homePageData"]];
        return model;
    }
    
    if ([url isEqualToString:Path_versionTerminal])
    {
        WelcomeModel *model = [WelcomeModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
        
    }
    if ([url isEqualToString:Path_getCustomer]) {
        MembershipInfoModel *model = [MembershipInfoModel yy_modelWithDictionary:jsonDict[@"datas"][@"customer"]];
        return model;
    }
    if ([url isEqualToString:Path_registerCustomer]) {
        MembershipInfoModel *model = [MembershipInfoModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    
    if ([url isEqualToString:Path_selectProduct] ||
        [url isEqualToString:Path_selectPromoCombo]) {
        CommonGoodsListModel *model = [CommonGoodsListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    
    if ([url isEqualToString:Path_getPromoList]) {
        StoreActivityListModel *model = [StoreActivityListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    
    if ([url isEqualToString:Path_customerAddress]) {
        AddressListModel *model = [AddressListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    if ([url isEqualToString:Path_getUserConfig]) {
        UserLoginInfoModelList *model = [UserLoginInfoModelList yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    if ([url isEqualToString:Path_shopPersonal]) {
        ShopPersonalListModel *model = [ShopPersonalListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    if ([url isEqualToString:Path_couponList]) {
        CouponListModel *model = [CouponListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    
    if ([url isEqualToString:Path_notLabel]) {
        UnLabelUserListModel *model = [UnLabelUserListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    
    if ([url isEqualToString:Path_getProductList]) {
        GoodsListModel *model = [GoodsListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    if ([url isEqualToString:Path_getComboList]) {
        PackageListModel *model = [PackageListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    if ([url isEqualToString:Path_getComboInfo]) {
        PackageDetailModel *model = [PackageDetailModel yy_modelWithDictionary:jsonDict[@"datas"][@"mealData"]];
        return model;
    }
    if ([url isEqualToString:Path_getComboTypes]) {
        CommonTypeListModel *model = [CommonTypeListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    if ([url isEqualToString:Path_getProductCategory]) {
        CommonTypeListModel *model = [CommonTypeListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    if ([url isEqualToString:Path_getProductDetail]) {
        GoodsDetailModel *model = [GoodsDetailModel yy_modelWithDictionary:jsonDict[@"datas"][@"productDdetail"]];
        return model;
    }
    if ([url isEqualToString:Path_coustomer]) {
        SCStatisticsListModel *model = [SCStatisticsListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    if ([url isEqualToString:Path_monthCoustomer] ||
        [url isEqualToString:Path_customer]) {
        SCExpandListModel *model = [SCExpandListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    if ([url isEqualToString:Path_specialtyCustomer]) {
        MajorCustomerListModel *model = [MajorCustomerListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    
    if ([url isEqualToString:Path_personal]) {
        ShopStaffListModel *model = [ShopStaffListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    
    if ([url isEqualToString:Path_getProductSample]) {
        SamplingListModel *model = [SamplingListModel yy_modelWithDictionary:jsonDict[@"datas"][@"sampleResData"]];
        return model;
    }
    
    if ([url isEqualToString:Path_patrolShopList]) {
        PatrolShopListModel *model = [PatrolShopListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    if ([url isEqualToString:Path_patrolShopDetail]) {
        PatrolShopDetailListModel *model = [PatrolShopDetailListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    if ([url isEqualToString:Path_couponUsageList]) {
        CouponRecordListModel *model = [CouponRecordListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    
    if ([url isEqualToString:Path_couponUsageRecord]) {
        CouponRecordDetailListModel *model = [CouponRecordDetailListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    
    if ([url isEqualToString:Path_shopSale]) {
        StoreSalesVolumeListModel *model = [StoreSalesVolumeListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    
    if ([url isEqualToString:Path_findOne]) {
        StoreSalesPersonalListModel *model = [StoreSalesPersonalListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    
    if ([url isEqualToString:Path_productSale] ||
        [url isEqualToString:Path_categoryProduct]) {
        GoodsSalesVolumeListModel *model = [GoodsSalesVolumeListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    if ([url isEqualToString:Path_setMealRanking]) {
        PackageRankListModel *model = [PackageRankListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    
    if ([url isEqualToString:Path_categoryRanking]) {
        GoodsCategoryRankListModel *model = [GoodsCategoryRankListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    
    if ([url isEqualToString:Path_firstPage]) {
        StatisticsModel *model = [StatisticsModel yy_modelWithDictionary:jsonDict[@"datas"][@"dayCountData"]];
        return model;
    }
    
    if ([url isEqualToString:Path_getPromoDetail]) {
        StoreActivityDetailModel *model = [StoreActivityDetailModel yy_modelWithDictionary:jsonDict[@"datas"][@"data"]];
        return model;
    }
    
    if ([url isEqualToString:Path_sale]) {
        SalesCounterDataModel *model = [SalesCounterDataModel yy_modelWithDictionary:jsonDict[@"datas"][@"saleData"]];
        return model;
    }
    
    if ([url isEqualToString:Path_load]) {
        CommonCategoryListModel *model = [CommonCategoryListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    
    if ([url isEqualToString:Path_saveOrder]) {
        OrderInfoModel *model = [OrderInfoModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    
    if ([url isEqualToString:Path_getProvince] ||
        [url isEqualToString:Path_getCity] ||
        [url isEqualToString:Path_getDistricts] ||
        [url isEqualToString:Path_getStreet]) {
        AddressSelectedListModel *model = [AddressSelectedListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    if ([url isEqualToString:Path_orderList]) {
        OrderManageListModel *model = [OrderManageListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    
    if ([url isEqualToString:Path_orderDetail]) {
        OrderDetailModel *model = [OrderDetailModel yy_modelWithDictionary:jsonDict[@"datas"][@"orderItemData"]];
        return model;
    }
    
    if ([url isEqualToString:Path_patrolShopProblemDetail]) {
        PatrolProblemModel *model = [PatrolProblemModel yy_modelWithDictionary:jsonDict[@"datas"][@"patrolShopProblemDetail"]];
        return model;
    }
    
    if ([url isEqualToString:Path_customerIntent]) {
        CustomerIntentListModel *model = [CustomerIntentListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    
    if ([url isEqualToString:Path_intentProductList]) {
        IntentionGoodsModel *model = [IntentionGoodsModel yy_modelWithDictionary:jsonDict[@"datas"][@"customerIntentData"]];
        return model;
    }
    if ([url isEqualToString:Path_shopCustomerIntent]) {
        IntentionListModel *model = [IntentionListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    
    if ([url isEqualToString:Path_returnOrderList]) {
        OrderManageListModel *model = [OrderManageListModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    if ([url isEqualToString:Path_publishProductSampleImage]) {
        ProductSampleResultModel *model = [ProductSampleResultModel yy_modelWithDictionary:jsonDict[@"datas"][@"productSampleResultData"]];
        return model;
    }
    if ([url isEqualToString:Path_productSampleHistory]) {
        ProductSampleResultModel *model = [ProductSampleResultModel yy_modelWithDictionary:jsonDict[@"datas"][@"sampleImgIssueData"]];
        return model;
    }
    
    if ([url isEqualToString:Path_productSampleHistory]) {
        ProductSampleResultModel *model = [ProductSampleResultModel yy_modelWithDictionary:jsonDict[@"datas"][@"sampleImgIssueData"]];
        return model;
    }
    
    if ([url isEqualToString:Path_selectReturnProduct]) {
        ReturnOrderInfoModel *model = [ReturnOrderInfoModel yy_modelWithDictionary:jsonDict[@"datas"][@"returnOrderInfo"]];
        return model;
    }
    
    if ([url isEqualToString:Path_ReturnProduct]) {
        ReturnOrderCounterModel *model = [ReturnOrderCounterModel yy_modelWithDictionary:jsonDict[@"datas"][@"returnOrderInfo"]];
        return model;
    }
    
    if ([url isEqualToString:Path_saveReturnOrder]) {
        OrderInfoModel *model = [OrderInfoModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    if ([url isEqualToString:Path_returnOrderDetail]) {
        ReturnOrderDetailModel *model = [ReturnOrderDetailModel yy_modelWithDictionary:jsonDict[@"datas"][@"returnItem"]];
        return model;
    }
    if ([url isEqualToString:Path_shopQRCode]) {
        StoreQRCodeModel *model = [StoreQRCodeModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    if ([url isEqualToString:Path_appInfo]) {
        CommonAbountModel *model = [CommonAbountModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    
    if ([url isEqualToString:Path_GetTotalReward]) {
        AwardsOverviewModel *model = [AwardsOverviewModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    
    if ([url isEqualToString:Path_GetRewardStatistics]) {
        AwardsStatisticsModel *model = [AwardsStatisticsModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    
    if ([url isEqualToString:Path_GetRewardList]) {
        AwardsDetailModel *model = [AwardsDetailModel yy_modelWithDictionary:jsonDict[@"datas"]];
        return model;
    }
    
    if ([url isEqualToString:Path_GetCustomerTag] ||
        [url isEqualToString:Path_SaveCustomerTag]) {
        UserTagModel *model = [UserTagModel yy_modelWithDictionary:jsonDict[@"datas"][@"customer"]];
        return model;
    }
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    MoenBaseModel *baseModel = [MoenBaseModel yy_modelWithDictionary:jsonDict];
    return baseModel;
}
@end
