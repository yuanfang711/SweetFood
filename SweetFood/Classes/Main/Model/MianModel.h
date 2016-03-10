//
//  MianModel.h
//  主页活动
//
//  Created by scjy on 16/3/4.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MianModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *cateId;

- (instancetype)initWithNSDictionary:(NSDictionary *)dic;


@end
