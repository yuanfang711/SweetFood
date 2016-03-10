//
//  LoveModel.h
//  喜欢点击界面
//
//  Created by scjy on 16/3/9.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoveModel : NSObject

@property (nonatomic, strong) NSString *iconView;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *loveID;

- (instancetype)initWithNSDictionary:(NSDictionary *)dic;

@end
