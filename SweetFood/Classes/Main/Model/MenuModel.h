//
//  MenuModel.h
//  SweetFood
//
//  Created by scjy on 16/3/8.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuModel : NSObject

@property (nonatomic, strong) NSString *icin;
@property (nonatomic, strong) NSString *introl;


- (instancetype)initWithNSDicetionary:(NSDictionary *)dic;


@end
