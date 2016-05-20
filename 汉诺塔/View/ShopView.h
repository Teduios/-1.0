//
//  shopView.h
//  汉诺塔
//
//  Created by tarena311🐟 on 16/3/21.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopView : UIView
@property (nonatomic) CGPoint normalPoint;
@property (nonatomic) CGPoint targetPoint;
@property (nonatomic) NSInteger moreScore;
@property (weak, nonatomic) IBOutlet UILabel *scoreNameLabel;
- (void)reflashView;
@end
