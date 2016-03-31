//
//  HomeModel.h
//  SweetFood
//
//  Created by scjy on 16/3/5.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject

@property (nonatomic, strong) NSString *Image;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) NSInteger playCount;
@property (nonatomic, strong) NSString *movieId;

- (instancetype)initWithNSDictionary:(NSDictionary *)dic;

@end
