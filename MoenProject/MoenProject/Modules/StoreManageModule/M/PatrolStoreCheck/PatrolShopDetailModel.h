//
//  PatrolShopDetailModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/29.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PSQuestionStatusModel;
@interface PatrolShopDetailModel : MoenBaseModel

@property (nonatomic, assign) NSInteger questionId;

@property (nonatomic, assign) NSInteger patrolShopId;

@property (nonatomic, copy) NSString *questionName;

@property (nonatomic, strong) PSQuestionStatusModel *questionStatus;

@property (nonatomic, copy) NSString *isProblem;

@property (nonatomic, assign) CGFloat itemCellHeight;

@end


@class PatrolShopDetailModel;
@interface PatrolShopDetailListModel : MoenBaseModel

@property (nonatomic, copy) NSString *remarks;

@property (nonatomic, strong) NSArray<PatrolShopDetailModel *> *patrolShopDetail;

@end


@interface PSQuestionStatusModel : MoenBaseModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *des;

@end

NS_ASSUME_NONNULL_END
