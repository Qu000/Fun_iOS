//
//  JHTabBarController.m
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/2.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHTabBarController.h"
#import "JHNavigationController.h"


#import "JHHomeViewController.h"
#import "JHSeeViewController.h"
#import "JHProfileViewController.h"

@interface JHTabBarController ()

@end

@implementation JHTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置tabBar的背景颜色，直接.backgroundcolor不对
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    backView.backgroundColor = JHRGB(255, 126, 5);
    [self.tabBar insertSubview:backView atIndex:0];
    self.tabBar.opaque = YES;
    
    [self setupUI];
}

- (void)setupUI{
    JHHomeViewController *homeVc = [[JHHomeViewController alloc]init];
    [self addChildVc:homeVc withTabTitle:@"首页" title:@"段子" image:@"home" selectedImage:@"home_h"];
    
    JHSeeViewController *seeVc = [[JHSeeViewController alloc]init];
    [self addChildVc:seeVc withTabTitle:@"Fun看" title:@"精选" image:@"see" selectedImage:@"see_h"];
    
    JHProfileViewController *profileVc = [[JHProfileViewController alloc]init];
    [self addChildVc:profileVc withTabTitle:@"乐我" title:@"Profile" image:@"profile" selectedImage:@"profile_h"];
}
- (void)addChildVc:(UIViewController *)childVc withTabTitle:(NSString *)tabTitle title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    
    childVc.navigationItem.title = title;
    childVc.tabBarItem.title = tabTitle;
//    childVc.title
    childVc.tabBarItem.image = [UIImage imageNamed:image];

    //声明：这张图片按照原来的样子显示出来，不要自动渲染成其他颜色（比如蓝色）
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //设置文字样式
    NSMutableDictionary *textAtts = [NSMutableDictionary dictionary];
    textAtts[NSForegroundColorAttributeName] = [UIColor whiteColor];//JHRGB(123, 123, 123)
    
    NSMutableDictionary *selectTextAtts = [NSMutableDictionary dictionary];
    selectTextAtts[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    
    
    [childVc.tabBarItem setTitleTextAttributes:textAtts forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAtts forState:UIControlStateSelected];
    
    //先给外面传进来的小控制器，包装一个导航控制器
    JHNavigationController * nav = [[JHNavigationController alloc]initWithRootViewController:childVc];
    
    //添加子控制器
    [self addChildViewController:nav];
  
    
}

@end
