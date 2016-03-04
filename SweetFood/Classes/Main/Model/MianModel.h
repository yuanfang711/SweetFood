//
//  MianModel.h
//  SweetFood
//
//  Created by scjy on 16/3/4.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MianModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *icon;

- (instancetype)initWithNSDictionary:(NSDictionary *)dic;


@end
