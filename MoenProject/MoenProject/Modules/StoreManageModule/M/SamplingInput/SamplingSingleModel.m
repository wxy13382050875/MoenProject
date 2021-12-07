//
//  SamplingSingleModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/28.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "SamplingSingleModel.h"

@implementation SamplingSingleModel

- (id)copyWithZone:(NSZone *)zone {
    SamplingSingleModel *model = [[self class] allocWithZone:zone];
    model.sampleId = _sampleId;
    model.sampleName = [_sampleName copy];
    model.sampleQuantity = _sampleQuantity;
    model.sampleType = [_sampleType copy];
    return model;
}



@end


@implementation SamplingListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"sampleSingleDataList" : [SamplingSingleModel class]};
}

@end
