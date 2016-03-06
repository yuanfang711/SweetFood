//
//  ChuModer.m
//  SweetFood
//
//  Created by scjy on 16/3/6.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "ChuModer.h"

@implementation ChuModer

- (instancetype)initWithNSDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.iconView = dic[@"Image"];
        self.title = dic[@"Title"];
        self.date = dic[@"Collection"];
        self.intro = dic[@"Content"];
        self.cellUrl = dic[@"Url"];
    }
    return self;
}


@end
