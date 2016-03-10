//
//  GoodModel.h
//  SweetFood
//
//  Created by scjy on 16/3/9.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *ImageView;
@property (nonatomic, strong) NSString *nema;
@property (nonatomic, strong) NSString *introl;
@property (nonatomic, strong) NSString *foodID;
- (instancetype)initWithNSDictionary:(NSDictionary *)dic;


@end
