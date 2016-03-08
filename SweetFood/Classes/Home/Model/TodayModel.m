//
//  TodayModel.m
//  SweetFood
//
//  Created by scjy on 16/3/7.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "TodayModel.h"

@implementation TodayModel
//
-(instancetype)initWithNSDicetionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.img = dic[@"CoverUrl"];
        self.title = dic[@"Title"];
        self.agoP = dic[@"Price"];
        self.price = dic[@"DealPrice"];
        self.haveM = dic[@"Stock"];
    }
    return self;
}

@end
