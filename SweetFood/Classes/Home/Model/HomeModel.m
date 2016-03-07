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
        self.icon = dic[@"StoreLogoUrl"];
        self.title = dic[@"StoreTitle"];
        self.pricate = dic[@"DealPrice"];
        self.imageSting = dic[@"CoverUrl"];
        self.name = dic[@"Title"];
        self.introduce = dic[@"SubTitle"];
        self.storeId = dic[@"UserId"];
    }
    return self;
}

@end
