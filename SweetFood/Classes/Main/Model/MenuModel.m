//
//  MenuModel.m
//  SweetFood
//
//  Created by scjy on 16/3/8.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "MenuModel.h"

@implementation MenuModel

-(instancetype)initWithNSDicetionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.icin = dic[@""];
        self.introl = dic[@""];
    }
    return self;
}

@end
