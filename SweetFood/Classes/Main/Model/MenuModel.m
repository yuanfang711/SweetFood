//
//  MenuModel.m
//  菜单列表：
//
//  Created by scjy on 16/3/8.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "MenuModel.h"

@implementation MenuModel
-(instancetype)initWithNSDicetionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.title =dic[@"Title"];
        self.playNum = dic[@"PlayCount"];
        self.videoId = dic[@"VideoId"];
        self.ImageView = dic[@"Cover"];
        self.foodType = dic[@"Type"];
    }
    return self;
}

@end
