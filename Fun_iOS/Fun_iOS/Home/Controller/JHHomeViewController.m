//
//  JHHomeViewController.m
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/2.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHHomeViewController.h"
#import "JHHomeTopView.h"

@interface JHHomeViewController ()<UIScrollViewDelegate>
/** ScrollView */
@property(nonatomic, strong) UIScrollView *scrollView;

/** 子控制器 - 源*/
@property (nonatomic, strong) NSArray *dataList;

/** topView*/
@property (nonatomic, strong) JHHomeTopView * topView;
@end

@implementation JHHomeViewController

-(NSArray *)dataList{
    if (!_dataList) {
        _dataList = @[@"最新段子",@"搞笑视频",@"趣味图片"];
    }
    return _dataList;
}

-(JHHomeTopView *)topView{
    if (!_topView) {
        _topView = [[JHHomeTopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50) titleNames:self.dataList];//200
        
        __weak typeof (self) weakSelf = self;
        _topView.block = ^(NSInteger tag) {
//            __strong typeof (weakSelf) strongSelf = self;
            CGPoint point = CGPointMake(tag * SCREEN_WIDTH, weakSelf.scrollView.contentOffset.y);
            [weakSelf.scrollView setContentOffset:point animated:YES];
        };
        
    }
    return _topView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupOthers];
    [self setupUI];
}

- (void)setupOthers{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = self.topView;
    
    self.navigationController.navigationBar.barTintColor = JHRGB(249, 227, 228);//0,205,220
    
}
- (void)setupUI{
    
    [self setupScrollView];
}
- (void)setupScrollView{
    
    NSArray *vcName = @[@"JHNewsViewController",@"JHVideoViewController",@"JHPicViewController"];
    for (NSInteger i=0; i<vcName.count; i++) {
        NSString *vcNameStr = vcName[i];
        UIViewController *vc = [[NSClassFromString(vcNameStr)alloc]init];
        vc.title = self.dataList[i];
        [self addChildViewController:vc];
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.dataList.count, 0);
    scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height);
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    //默认先展示第一个界面
//    scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    [self scrollViewDidEndScrollingAnimation:scrollView];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}
#pragma mark --- UIScrollViewDelegate
//减速结束时调用。加载子控制器view
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = SCREEN_HEIGHT;
    CGFloat offset = scrollView.contentOffset.x;
    
    //获取第几个  的索引值
    NSInteger idx = offset / width;
    
    //根据索引值，返回vc的引用
    UIViewController * vc = self.childViewControllers[idx];
    
    //传递联动索引值给topView
    [self.topView scrolling:idx];
    
    //判读当前vc是否执行过viewDidLoad
    if ([vc isViewLoaded]) return;
    
    //设置子控制器view的大小
    vc.view.frame = CGRectMake(offset, 0, width, height);
    
    //将子控制器view加入到scrollView上
    [scrollView addSubview:vc.view];
}
//动画结束时调用(点击topView的button时，走的代理;因为topView中button的改变，不会走scrollViewDidEndDecelerating)
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    [self scrollViewDidEndDecelerating:scrollView];
}


@end
