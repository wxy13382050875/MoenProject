//
//  PatrolProblemModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/8.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "PatrolProblemModel.h"

@implementation PatrolProblemModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"questionImages" : [PatrolProblemImageModel class]};
}

@end

@implementation PatrolProblemImageModel

@end
