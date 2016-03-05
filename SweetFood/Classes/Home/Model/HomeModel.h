//
//  HomeModel.h
//  SweetFood
//
//  Created by scjy on 16/3/5.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *pricate;
@property (nonatomic, strong) NSString *imageSting;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *introduce;

- (instancetype)initWithNSDictionary:(NSDictionary *)dic;

@end
