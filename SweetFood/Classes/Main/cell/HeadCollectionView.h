//
//  HeadCollectionView.h
//  
//
//  Created by scjy on 16/3/7.
//
//

#import <UIKit/UIKit.h>

@interface HeadCollectionView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (nonatomic, strong) NSDictionary *dic;

@end
