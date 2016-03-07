//
//  MovieModel.m
//  SweetFood
//
//  Created by scjy on 16/3/7.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "MovieModel.h"



@implementation MovieModel

- (instancetype)initWithNSDictionary:(NSDictionary *)dic{
    if (self) {
        self.imgView = dic[@"Cover"];
        self.title = dic[@"Title"];
    }
    return self;
}

@end
