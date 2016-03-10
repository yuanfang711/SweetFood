//
//  MovieModel.m
//  视频点击
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
        self.videoID = dic[@"VideoId"];
    }
    return self;
}

@end
