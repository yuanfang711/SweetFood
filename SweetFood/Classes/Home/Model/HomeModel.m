//
//  HomeModel.m
//  SweetFood
//
//  Created by scjy on 16/3/5.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "HomeModel.h"

@interface HomeModel ()

@end

@implementation HomeModel

- (instancetype)initWithNSDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.Image = dic[@"Cover"];
        self.name = dic[@"Title"];
        self.time = dic[@"CreateTime_"];
        self.playCount = [dic[@"PlayCount"] integerValue];
        self.movieId = dic[@"VideoId"];
    }
    return self;
}

@end
