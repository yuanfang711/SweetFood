//
//  MenuModel.h
//  SweetFood
//
//  Created by scjy on 16/3/8.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuModel : NSObject

@property (nonatomic, strong) NSString *Cover;
@property (nonatomic, strong) NSString *introl;
@property (nonatomic, strong) NSString *ImageView;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;

- (instancetype)initWithNSDicetionary:(NSDictionary *)dic;


@end
