//
//  PatrolProblemModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/8.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PatrolProblemImageModel;
@interface PatrolProblemModel : MoenBaseModel

@property (nonatomic, assign) NSInteger questionId;

@property (nonatomic, copy) NSString *questionName;

@property (nonatomic, copy) NSString *questionDes;

/**banner图url*/
@property (nonatomic, strong) NSArray<PatrolProblemImageModel *> *questionImages;

@end

@interface PatrolProblemImageModel : MoenBaseModel
@property (nonatomic, copy) NSString *imageImgUrl;
@end



NS_ASSUME_NONNULL_END
