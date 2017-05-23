//
//  QMSlideList.h
//  QMSlideList
//
//  Created by zyx on 17/5/22.
//  Copyright © 2017年 其妙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMSlideList : UIView<UIScrollViewDelegate>

/// 初始化
- (instancetype)initWithFrame:(CGRect)frame target:(UIViewController *)target vcs:(NSArray *)vcs titles:(NSArray *)titles;

- (instancetype)initWithFrame:(CGRect)frame target:(UIViewController *)target vcs:(NSArray *)vcs titles:(NSArray *)titles titleNormalColor:(UIColor *)normalColor titleSelectedColor:(UIColor *)selectedColor lineColor:(UIColor *)lineColor;

@end
