//
//  MianModel.m
//  SweetFood
//
//  Created by scjy on 16/3/4.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "MianModel.h"

@implementation MianModel
- (instancetype)initWithNSDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.title = dic[@"CateName"];
        self.icon = dic[@"Cover"];
        self.cateId = dic[@"CateId"];
    }
    return self;
}


@end
