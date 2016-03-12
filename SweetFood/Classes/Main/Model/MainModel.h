//
//  MainModel.h
//  主页喜欢
//
//  Created by scjy on 16/3/8.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *url;
- (instancetype)initWithNSDictionary:(NSDictionary *)dic;

@end
