//
//  ThreadViewController.m
//  PractiseApp
//
//  Created by 吴京城 on 2020/4/28.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "ThreadViewController.h"

@interface ThreadViewController ()
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation ThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.8];
    self.closeBtn = [[UIButton alloc]init];
    [self.closeBtn setTitle:@"返回主页面" forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(20);
        make.trailing.mas_equalTo(self.view.mas_trailing).offset(-20);
    }];
    
    
    __block NSInteger number = 10;
    //*****常用开启NSThread线程方法*****⬇️
    
    //直接派遣新线程，不能对新线程进行更详细的设置
    [NSThread detachNewThreadWithBlock:^{
        for (NSInteger i = 0; i<10; i++) {
            NSLog(@"匿名线程-出售第%ld张票",number);
            number--;
//            [NSThread exit];//退出当前线程,类方法
            //调用之后会立即终止线程，即使任务还没有执行完成也会中断.不推荐使用此方式退出子线程,可能会造成内存泄漏
        }
    }];
    [NSThread detachNewThreadSelector:@selector(showSender:) toTarget:self withObject:self.closeBtn];
    //创建新线程，再执行start方法，可以进行多种设置
    __block NSThread *thread1 = [[NSThread alloc]initWithBlock:^{
        for (NSInteger i = 0; i <10; i++) {
            NSLog(@"thread1线程-出售第= %ld张票",number);
            number--;
            [thread1 cancel];//只是一个标记方法，不会终止线程，只是改变cancel。
            //cancel值被改变，我们可以监控cancel值，对其作出反应
            //在此block内原本不能实现thread1 cancel，此处能执行是因为我在thrad1创建时增加了__block关键字
            NSLog(@"\nthread1.isCanceled == %@",(thread1.isCancelled==NO ? @"NO" :@"YES"));
        }
    }];
    thread1.name = @"我的对线程";
    thread1.threadPriority = 1;//  设置线程优先级，由0-1之间的浮点数决定，1为最高优先级
    //线程优先级取值范围0.0-1.0，默认为0.5，值越大优先级越高。
    //设置优先级并不意味着优先级高的线程要比优先级低的线程先运行（运行反映的结果就是，打印结果里面显示的第一条是哪个thread）
    //,只是更可能被CPU执行到。先执行哪个线程是由cpu调度决定的。
    [thread1 start];//使线程处于 Runnable状态，进入 可调度线程池内。
    //这里并不是直接使线程直接进入 Running 状态，如果要进入Running状态还需要等待线程被调度。
    NSLog(@"插入一句话");
//    [NSThread sleepForTimeInterval:1];
//    [thread1 cancel];//cancel只是一个标记位置
    //如果我在此处写thread1 cancel，并且前面没有线程等待 ，则thread1不会执行。
    //但是如果我在此处写thread1 cancel，并且在前面再加入一段线程等待（阻塞了主线程），则thrad1被执行了！
    
    
    //*****常用开启NSThread线程方法*****⬆️
    
    //*****NSThread线程另一些常用方法*****⬇️
    
    __weak typeof(NSThread*) currentThread = [NSThread currentThread];//获取当前线程
    NSLog(@"\n当前线程为:%@,%@主线程",currentThread,(currentThread.isMainThread ? @"是" : @"不是"));
    
    __weak typeof(NSThread*) mainThread = [NSThread mainThread];//获取主线程
    NSLog(@"\n主线程为：%@,优先级为%lf",mainThread,mainThread.threadPriority);//获取线程优先级
    
    NSString* name = thread1.name;//获取线程名字
    NSString* isFinished = thread1.isFinished == YES ? @"已经结束" : @"没有结束";
    NSString* isCancel = thread1.isCancelled == YES ? @"已经取消" : @"没有取消";//此处有显示取消是因为第49行代码
    NSString* isExcuting = thread1.isExecuting == YES ? @"正在执行" :@"没有正在执行";
    NSString* isMultiThread = ([NSThread isMultiThreaded] == YES )? @"是多线程" :@"不是多线程";
    NSLog(@"thread1:\n%@\n%@\n%@\n%@",name,isFinished,isCancel,isExcuting);
    NSLog(@"\n当前是否有多线程:%@",isMultiThread);

    //*****NSThread线程另一些常用方法*****⬆️
    
}

-(void)closeSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)showSender:(id)sender{
    NSLog(@"ThreadViewController展示sender==%@",sender);
}
@end
