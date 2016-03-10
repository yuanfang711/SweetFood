//
//  MainModel.m
//  主页喜欢
//
//  Created by scjy on 16/3/8.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "MainModel.h"

@implementation MainModel
- (instancetype)initWithNSDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.title = dic[@"Title"];
        self.icon = dic[@"Img"];
    }
    return self;
}

@end
