//
//  TodayModel.h
//  SweetFood
//
//  Created by scjy on 16/3/7.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodayModel : NSObject
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *agoP;
@property (nonatomic, strong)
NSString *price;
@property (nonatomic,strong) NSString *haveM;
@property (nonatomic, strong) NSString *fooId;

- (instancetype)initWithNSDicetionary:(NSDictionary *)dic;


@end
