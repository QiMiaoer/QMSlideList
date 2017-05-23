//
//  QMSlideList.m
//  QMSlideList
//
//  Created by zyx on 17/5/22.
//  Copyright © 2017年 其妙. All rights reserved.
//

#import "QMSlideList.h"

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define Title_Font 13
#define Item_Margin 15
#define Line_View_Height 3
#define Tag_Add 100

@implementation QMSlideList {
    UIColor *_titleNormalColor, *_titleSelectedColor, *_lineColor;
    UIViewController *_target;
    NSArray *_vcs, *_titles;
    UIButton *_selectedBtn;
    UIView *_lineView;
    UIScrollView *_topScrollView, *_bottomScrollView;
}

- (instancetype)initWithFrame:(CGRect)frame target:(UIViewController *)target  vcs:(NSArray *)vcs titles:(NSArray *)titles {
    if (self == [super initWithFrame:frame]) {
        _target = target;
        _vcs = vcs;
        _titles = titles;
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame target:(UIViewController *)target vcs:(NSArray *)vcs titles:(NSArray *)titles titleNormalColor:(UIColor *)normalColor titleSelectedColor:(UIColor *)selectedColor lineColor:(UIColor *)lineColor {
    if (self == [super initWithFrame:frame]) {
        _titleNormalColor = normalColor;
        _titleSelectedColor = selectedColor;
        _lineColor = lineColor;
        _target = target;
        _vcs = vcs;
        _titles = titles;
        [self setupUI];
    }
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat index = scrollView.contentOffset.x / Screen_Width;
    UIButton *btn = [self viewWithTag:(NSInteger)index + Tag_Add];
    _selectedBtn.selected = NO;
    _selectedBtn = btn;
    _selectedBtn.selected = YES;
    
    [self animate];
}

- (void)setupUI {
    UIScrollView *topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.frame.size.height)];
    topScrollView.showsVerticalScrollIndicator = NO;
    topScrollView.showsHorizontalScrollIndicator = NO;
    topScrollView.bounces = NO;
    topScrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topScrollView];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = _lineColor ? _lineColor : [UIColor cyanColor];
    [topScrollView addSubview:lineView];
    _lineView = lineView;
    
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), Screen_Width, Screen_Height - CGRectGetMaxY(self.frame))];
    bottomScrollView.contentSize = CGSizeMake(Screen_Width * _titles.count, bottomScrollView.bounds.size.height);
    bottomScrollView.showsVerticalScrollIndicator = NO;
    bottomScrollView.showsHorizontalScrollIndicator = NO;
    bottomScrollView.bounces = NO;
    bottomScrollView.pagingEnabled = YES;
    bottomScrollView.delegate = self;
    bottomScrollView.backgroundColor = [UIColor whiteColor];
    [_target.view addSubview:bottomScrollView];
    _bottomScrollView = bottomScrollView;
    
    CGFloat offset = 0.0;
    for (int i = 0; i < _titles.count; i++) {
        UIButton *btn = [UIButton new];
        [btn setTitle:_titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:_titleNormalColor ? _titleNormalColor : [UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:_titleSelectedColor ? _titleSelectedColor : [UIColor cyanColor] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:Title_Font];
        
        CGFloat titleWidth = [self widthWithString:_titles[i]];
        CGFloat btnX = i ? offset + Item_Margin * 2 : Item_Margin;
        btn.frame = CGRectMake(btnX, 0, titleWidth, self.frame.size.height - Line_View_Height);
        offset = CGRectGetMaxX(btn.frame);
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = Tag_Add + i;
        [topScrollView addSubview:btn];
        
        if (i == 0) {
            _selectedBtn = btn;
            btn.selected = YES;
            _lineView.frame = CGRectMake(0, self.frame.size.height - Line_View_Height, btn.frame.size.width + Item_Margin * 2, Line_View_Height);
        }
        
        if (_vcs) {
            UIView *view = ((UIViewController *)_vcs[i]).view;
            view.frame = CGRectMake(Screen_Width * i, 0, Screen_Width, bottomScrollView.bounds.size.height);
            [bottomScrollView addSubview:view];
        }
    }
    
    topScrollView.contentSize = CGSizeMake(offset + Item_Margin, self.frame.size.height);
    _topScrollView = topScrollView;
}

- (void)btnAction:(UIButton *)sender {
    _selectedBtn.selected = NO;
    _selectedBtn = sender;
    _selectedBtn.selected = YES;
    CGFloat index = sender.tag - Tag_Add;
    _bottomScrollView.contentOffset = CGPointMake(Screen_Width * index, 0);
    
    [self animate];
}

- (void)animate {
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat offset = CGRectGetMaxX(_selectedBtn.frame);
        if (offset < Screen_Width / 2) {
            _topScrollView.contentOffset = CGPointZero;
        } else if (offset >= Screen_Width / 2 && offset <= _topScrollView.contentSize.width - Screen_Width / 2) {
            _topScrollView.contentOffset = CGPointMake(offset - Item_Margin - Screen_Width / 2, 0);
        } else {
            _topScrollView.contentOffset = CGPointMake(_topScrollView.contentSize.width - Screen_Width, 0);
        }
        _lineView.frame = CGRectMake(0, _lineView.frame.origin.y, _selectedBtn.frame.size.width + Item_Margin * 2, Line_View_Height);
        CGFloat lineViewCenterY = _lineView.center.y;
        _lineView.center = CGPointMake(_selectedBtn.center.x, lineViewCenterY);
    }];
}

- (CGFloat)widthWithString:(NSString *)str {
    return [str boundingRectWithSize:CGSizeMake(Screen_Width, Screen_Width) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:Title_Font]} context:nil].size.width;
}

@end
