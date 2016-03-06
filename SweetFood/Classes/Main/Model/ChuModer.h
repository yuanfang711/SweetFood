//
//  ChuModer.h
//  SweetFood
//
//  Created by scjy on 16/3/6.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChuModer : NSObject

@property (nonatomic, strong) NSString *iconView;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *cellUrl;

- (instancetype)initWithNSDictionary:(NSDictionary *)dic;

@end
