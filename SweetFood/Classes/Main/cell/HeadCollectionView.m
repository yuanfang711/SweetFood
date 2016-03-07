//
//  HeadCollectionView.m
//  
//
//  Created by scjy on 16/3/7.
//
//

#import "HeadCollectionView.h"
#import <CoreBluetooth/CoreBluetooth.h>
@implementation HeadCollectionView
-(void)setDic:(NSDictionary *)dic{
    self.titleL.text = dic[@"CateName"];
}
@end
