//
//  MovieModel.h
//  SweetFood
//
//  Created by scjy on 16/3/7.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieModel : NSObject
@property (nonatomic,strong) NSString *imgView;
@property (nonatomic, strong) NSString *title;
- (instancetype)initWithNSDictionary:(NSDictionary *)dic;


@end