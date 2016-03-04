//
//  MianModel.m
//  SweetFood
//
//  Created by scjy on 16/3/4.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "MianModel.h"

@implementation MianModel

//
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
//
//
//
//}
- (instancetype)initWithNSDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.title = dic[@"Title"];
        self.intro = dic[@"Intro"];
        self.icon = dic[@"Img"];
    }
    return self;
}


@end
