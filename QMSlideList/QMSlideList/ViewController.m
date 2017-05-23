//
//  ViewController.m
//  QMSlideList
//
//  Created by zyx on 17/5/22.
//  Copyright © 2017年 其妙. All rights reserved.
//

#import "ViewController.h"
#import "QMSlideList.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSMutableArray *vcs = [NSMutableArray array];
    NSArray *titles = @[@"加", @"阿萨德刚", @"健身卡电话", @"女警萨阿里", @"福偶尔", @"案件代理商放假了", @"法律手段就敢", @"爱的", @"到", @"色度", @"阿萨德刚", @"发送到", @"阿斯蒂芬", @"艾斯比"];
    for (int i = 0; i < titles.count; i++) {
        UIViewController *vc = [UIViewController new];
        vc.view.backgroundColor = [UIColor colorWithRed:(random()%255)/255.0 green:(random()%255)/255.0 blue:(random()%255)/255.0 alpha:1];
        [vcs addObject:vc];
    }
    
    QMSlideList *view = [[QMSlideList alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 44) target:self vcs:vcs titles:titles];
//    QMSlideList *view = [[QMSlideList alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 44) target:self vcs:vcs titles:titles titleNormalColor:[UIColor darkGrayColor] titleSelectedColor:[UIColor redColor] lineColor:[UIColor redColor]];
    [self.view addSubview:view];

}

@end
