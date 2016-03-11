//
//  MenuModel.h
//  视频标签点击
//
//  Created by scjy on 16/3/8.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuModel : NSObject


@property (nonatomic, strong) NSString *ImageView;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *foodType;
@property (nonatomic, strong) NSString *videoId;
@property (nonatomic, strong) NSString *playNum;
- (instancetype)initWithNSDicetionary:(NSDictionary *)dic;


@end
