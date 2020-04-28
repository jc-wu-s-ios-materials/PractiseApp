//
//  GCDViewController.m
//  PractiseApp
//
//  Created by 吴京城 on 2020/4/28.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.7];
    self.closeBtn = [[UIButton alloc]init];
    [self.closeBtn setTitle:@"返回主页面" forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(20);
        make.trailing.mas_equalTo(self.view.mas_trailing).offset(-20);
    }];
    
    /* GCD 使用的步骤: 1.定制任务 2.将任务添加到队列中，指定运行方式。
     * GCD会自动将队列中的任务取出，放到对应的线程中执行。任务的取出遵循队列的FIFO原则，先进先出。
     * 不需要管理线程的生命周期；线程能够复用
     */
    
    //创建任务
    dispatch_block_t task1 = ^{
        NSLog(@"task %@",[NSThread currentThread]);
        NSLog(@"-- %@",[NSThread mainThread]);
    };
    //获取队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //任务加入队列
    dispatch_async(queue, task1);//与下面被注释的两行等效
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"task %@",[NSThread currentThread]);
//    });
    //不需要管理线程生命周期,线程能够复用
    for(NSInteger i = 0;i<2;i++){
        dispatch_async(queue, task1);
    }
    
}


-(void)closeSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
