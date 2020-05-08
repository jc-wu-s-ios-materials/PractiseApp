//
//  ViewController.m
//  PractiseApp
//
//  Created by 吴京城 on 2020/4/27.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "HomePageViewController.h"
#import "ThreadViewController.h"
#import "GCDViewController.h"
#import "NSOperationViewController.h"
#import "SellTicketsViewController.h"
#import "WelcomeToSandBoxViewController.h"
#import "AllMyLockVC.h"
#import "KVO_ViewController.h"
#import "KVC_ViewController.h"
#import "AFN_ViewController.h"
#import "YYK_ViewController.h"
#import "AOP_ViewController.h"
@interface HomePageViewController ()
@property (nonatomic, strong) UILabel *LabelForShowResults;
//btn1 - btn3 练习 NotificationCenter DefaultCenter
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
//前往其他UIViewController 多线程
@property (nonatomic, strong) UIButton *goNextBtn1;//NSThread多线程练习
@property (nonatomic, strong) UIButton *goNextBtn2;//GCD多线程练习
@property (nonatomic, strong) UIButton *goNextBtn3;//NSOperation练习
@property (nonatomic, strong) UIButton *goNextBtn4;//售票解决方案
@property (nonatomic, strong) UIButton *goNextBtn5;//前往沙盒欢迎页
//前往锁VC们，各种锁
@property (nonatomic, strong) UIButton *lockBtn1;//NSLock锁展示
@property (nonatomic, strong) UIButton *lockBtn2;//Synchronized锁
@property (nonatomic, strong) UIButton *lockBtn3;//Semaphore信号量
@property (nonatomic, strong) UIButton *lockBtn4;//NSCondition条件锁

@property (nonatomic, strong) UIButton *lockBtn6;//NSRecursiveLockVC递归锁






@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.closeBtn.hidden = YES;
    //********注册通知********⬇️
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNotificationWithNil)
                                                name:@"btn1点击" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNotificationWithNonnullObj:)
                                                name:@"btn2点击" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNotificationWithNonnullUserInfo:)
                                                name:@"btn3点击" object:nil];
    //********注册通知********⬆️
    
    //创建首页的各种btn
    [self createLabels];
    [self createNSThreadBtns];
    [self createGotoNextBtns];
    [self createLockBtns];
    
    UIView *mask = [[UIView alloc]initWithFrame:self.view.frame];
    mask.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.8];
    [self.view addSubview:mask];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [NSThread sleepForTimeInterval:1];
    
//    [self gotoNextVCViaBtn:self.goNextBtn1];//自动进入NSThread练习
//    [self gotoNextVCViaBtn:self.goNextBtn2];//自动进入GCD练习
//    [self gotoNextVCViaBtn:self.goNextBtn3];//自动进入NSOperation练习
//    [self gotoNextVCViaBtn:self.goNextBtn4];//自动进去“售票问题解决”练习
//    [self gotoNextVCViaBtn:self.goNextBtn5];//自动前往沙盒欢迎页
//    [self gotoNextVCViaBtn:self.lockBtn1];//自动前往NSLock页
//    [self gotoNextVCViaBtn:self.lockBtn2];//自动前往synchronize页
//    [self gotoNextVCViaBtn:self.lockBtn3];//自动前往semaphore页
//    [self gotoNextVCViaBtn:self.lockBtn4];//自动前往NSCondition页
    
//    [self gotoNextVCViaBtn:self.lockBtn6];//自动前往NSRecursiveLock页
    
//    [self gotoKVO];//自动前往KVO练习
//    [self gotoKVC];//自动前往KVC练习
//    [self gotoAFN];//自动前往AFNetworking练习
//    [self gotoYY];//自动前往YYKit练习
    [self gotoAOP];//自动前往AOP练习
}


/*
 *NSNotification定义
 @interface NSNotification : NSObject <NSCopying, NSCoding>
 @property (readonly, copy) NSNotificationName name;
 @property (nullable, readonly, retain) id object;
 @property (nullable, readonly, copy) NSDictionary *userInfo;
 - (instancetype)initWithName:(NSNotificationName)name object:(nullable id)object userInfo:(nullable NSDictionary *)userInfo API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)) NS_DESIGNATED_INITIALIZER;
 - (nullable instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;
 @end
 */
-(void)getNotificationWithNil{
    [self.LabelForShowResults setText:@"收到了btn1的点击通知"];
}
-(void)getNotificationWithNonnullObj:(NSNotification*)notification{
    id obj = notification.object;//id-动态类型，NSObject-静态类型-需要强制转换否则在使用具体类型方法时编译不通过
    NSString* msg = [NSString stringWithFormat:@"%@",obj];
    [self.LabelForShowResults setText:msg];
}
-(void)getNotificationWithNonnullUserInfo:(NSNotification*)notification{
    NSDictionary *dic = notification.userInfo;
    [self.LabelForShowResults setText:[dic valueForKey:@"key1"]];
}
-(void)dealloc{
    //NSNotificationCenter 结束时需要注销观察者
    [[NSNotificationCenter defaultCenter]removeObserver:self];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"btn3点击" object:nil];//精确地移除某观察者
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"btn2点击" object:self.btn1];//更精确地移除某观察者
    /*
     通知中心对响应者observer是使用unsafe_unretained修饰，当响应者释放会出现野指针，向野指针发送消息造成崩溃；
     在iOS n(更新的系统版本有待考证)之后，苹果对其做了优化，会在响应者调用dealloc方法的时候执行removeObserver:方法？
     */
}
-(void)showSender:(id)sender{
    NSLog(@"首页ViewController展示sender==%@",sender);
}
-(void)btnClick:(id)sender{
    if (sender == self.btn1) {
        //发送一个无对象通知，只有注册了name==@"btn1点击"&&object==nil的观察者可以收到此通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"btn1点击" object:nil];
    }else if (sender == self.btn2){
        //发送一个有对象通知,只有注册了name==@"btn2点击"&&object==_btn1的观察者可以收到此通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"btn2点击" object:self.btn1];
    }else if (sender == self.btn3){
//        NSDictionary *dic1 = [NSDictionary dictionaryWithObject:@"userInfo消息dic1" forKey:@"key1"];//创建只有一对键值对的字典
//        NSDictionary *dic2 = @{@"key1":@"value1",@"key2":@"value2",@"key3":@"value3"};//快速创建字典，后面重复的不会加入
        NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];//可加入值的NSMutableDictionary
        [dic3 setValue:@"dic2:value1" forKey:@"key1"];
        [dic3 setValue:@"dic2:value2" forKey:@"key2"];
        //发送一个有userInfo但是没有object的通知，只有注册了name==@"btn3点击"&&obje==nil的观察者可以收到此通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"btn3点击" object:nil userInfo:dic3];
    }
}
-(void)gotoNextVCViaBtn:(id)sender{
    if (sender == self.goNextBtn1) {//前往NSThread多线程
        ThreadViewController *vc = [[ThreadViewController alloc]init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }else if (sender == self.goNextBtn2){//前往GCD多线程
        GCDViewController *vc = [[GCDViewController alloc]init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }else if (sender == self.goNextBtn3){//前往NSOperation多线程
        NSOperationViewController *vc= [[NSOperationViewController alloc]init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }else if (sender == self.goNextBtn4){//前往售票问题解决
        SellTicketsViewController *vc= [[SellTicketsViewController alloc]init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }else if (sender == self.goNextBtn5){//前往沙盒欢迎页
        WelcomeToSandBoxViewController *vc = [[WelcomeToSandBoxViewController alloc]init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }else if (sender == self.lockBtn1){//前往NSLock锁
        NSLockVC *vc = [[NSLockVC alloc]init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }else if (sender == self.lockBtn2){//前往synchroni锁
        SynchronizedVC *vc = [[SynchronizedVC alloc]init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }else if (sender == self.lockBtn3){//前往semaphore信号量
        SemaphoreVC *vc = [[SemaphoreVC alloc]init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }else if (sender == self.lockBtn4){//前往NSCondition条件锁
        NSConditionVC *vc = [[NSConditionVC alloc]init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }else if (sender == self.lockBtn6){//前往NSRecursiveLock递归锁，可重入锁
        NSRecursiveLockVC *vc = [[NSRecursiveLockVC alloc]init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }
}
-(void)createLabels{
    //页面标题
    UILabel *label = [[UILabel alloc]init];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view.mas_centerY).mas_offset(-150);
    }];
    label.font = [UIFont systemFontOfSize:40.f];
    [label setText:@"NotificationCenter DefaultCenter简单使用"];
    //展示label
    self.LabelForShowResults = [[UILabel alloc]init];
    [self.view addSubview:self.LabelForShowResults];
    [self.LabelForShowResults mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view.mas_centerY).mas_offset(-100);
    }];
    [self.LabelForShowResults setText:@"暂时无内容"];
}
-(void)createNSThreadBtns{
    //btn1 无参数传递消息btn
    self.btn1 = [[UIButton alloc]init];
    self.btn1.backgroundColor = [[UIColor blueColor]colorWithAlphaComponent:.7];
    [self.btn1 setTitle:@"发送一个无参数的通知" forState:UIControlStateNormal];
    [self.btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn1];
    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-100);
        make.leading.mas_equalTo(self.view.mas_leading).mas_offset(20);
    }];
    //btn2 有参数传递消息btn 使用参数为 Notification.object
    self.btn2 = [[UIButton alloc]init];
    self.btn2.backgroundColor = [[UIColor blueColor]colorWithAlphaComponent:.7];
    [self.btn2 setTitle:@"发送一个有Notification.object参数的Notification" forState:UIControlStateNormal];
    [self.btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn2];
    [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.btn1);
        make.leading.mas_equalTo(self.btn1.mas_trailing).mas_offset(10);
    }];
    //btn3 有参数传递消息btn 使用参数为 Notification.userInfo
    self.btn3 = [[UIButton alloc]init];
    self.btn3.backgroundColor = [[UIColor blueColor]colorWithAlphaComponent:.7];
    [self.btn3 setTitle:@"发送一个有Notification.userInfo参数的Notification" forState:UIControlStateNormal];
    [self.btn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn3];
    [self.btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.btn1);
        make.leading.mas_equalTo(self.btn2.mas_trailing).mas_offset(10);
    }];
}
-(void)createGotoNextBtns{
    //goNextBtn1去另一个ViewController
    self.goNextBtn1 = [[UIButton alloc]init];
    self.goNextBtn1.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:.7];
    [self.goNextBtn1 setTitle:@"前往 NSThread" forState:UIControlStateNormal];
    [self.goNextBtn1 addTarget:self action:@selector(gotoNextVCViaBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.goNextBtn1];
    [self.goNextBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.btn1.mas_bottom).mas_offset(10);
        make.leading.mas_equalTo(self.btn1.mas_leading);
    }];
    //goNextBtn2去另一个ViewController
    self.goNextBtn2 = [[UIButton alloc]init];
    self.goNextBtn2.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:.7];
    [self.goNextBtn2 setTitle:@"前往 GCD" forState:UIControlStateNormal];
    [self.goNextBtn2 addTarget:self action:@selector(gotoNextVCViaBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.goNextBtn2];
    [self.goNextBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goNextBtn1);
        make.leading.mas_equalTo(self.goNextBtn1.mas_trailing).mas_offset(2);
    }];
    //goNextBtn3去另一个ViewController
    self.goNextBtn3 = [[UIButton alloc]init];
    self.goNextBtn3.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:.7];
    [self.goNextBtn3 setTitle:@"前往 NSOperation" forState:UIControlStateNormal];
    [self.goNextBtn3 addTarget:self action:@selector(gotoNextVCViaBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.goNextBtn3];
    [self.goNextBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goNextBtn1);
        make.leading.mas_equalTo(self.goNextBtn2.mas_trailing).mas_offset(2);
    }];
    //goNextBtn4去另一个ViewController
    self.goNextBtn4 = [[UIButton alloc]init];
    self.goNextBtn4.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:.7];
    [self.goNextBtn4 setTitle:@"前往 NSOperation" forState:UIControlStateNormal];
    [self.goNextBtn4 addTarget:self action:@selector(gotoNextVCViaBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.goNextBtn4];
    [self.goNextBtn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goNextBtn1);
        make.leading.mas_equalTo(self.goNextBtn3.mas_trailing).mas_offset(2);
    }];
    //goNextBtn5去另一个ViewController
    self.goNextBtn5 = [[UIButton alloc]init];
    self.goNextBtn5.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:.7];
    [self.goNextBtn5 setTitle:@"前往 NSOperation" forState:UIControlStateNormal];
    [self.goNextBtn5 addTarget:self action:@selector(gotoNextVCViaBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.goNextBtn5];
    [self.goNextBtn5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goNextBtn1);
        make.leading.mas_equalTo(self.goNextBtn4.mas_trailing).mas_offset(2);
    }];
}
-(void)createLockBtns{
    //NSLock锁
    self.lockBtn1 = [[UIButton alloc]init];
    self.lockBtn1.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:.7];
    [self.lockBtn1 setTitle:@"前往 NSLock" forState:UIControlStateNormal];
    [self.lockBtn1 addTarget:self action:@selector(gotoNextVCViaBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lockBtn1];
    [self.lockBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.btn1.mas_top).mas_offset(-20);
        make.leading.mas_equalTo(self.btn1.mas_leading);
    }];
    
    //synchronize锁
    self.lockBtn2 = [[UIButton alloc]init];
    self.lockBtn2.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:.7];
    [self.lockBtn2 setTitle:@"前往 syschroniz" forState:UIControlStateNormal];
    [self.lockBtn2 addTarget:self action:@selector(gotoNextVCViaBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lockBtn2];
    [self.lockBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lockBtn1);
        make.leading.mas_equalTo(self.lockBtn1.mas_trailing).offset(2);
    }];
    
    //Semaphore信号量
    self.lockBtn3 = [[UIButton alloc]init];
    self.lockBtn3.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:.7];
    [self.lockBtn3 setTitle:@"前往 Semaphore" forState:UIControlStateNormal];
    [self.lockBtn3 addTarget:self action:@selector(gotoNextVCViaBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lockBtn3];
    [self.lockBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lockBtn1);
        make.leading.mas_equalTo(self.lockBtn2.mas_trailing).offset(2);
    }];
    
    //NSCondition条件锁
    self.lockBtn4 = [[UIButton alloc]init];
    self.lockBtn4.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:.7];
    [self.lockBtn4 setTitle:@"前往 NSCondition" forState:UIControlStateNormal];
    [self.lockBtn4 addTarget:self action:@selector(gotoNextVCViaBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lockBtn4];
    [self.lockBtn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lockBtn1);
        make.leading.mas_equalTo(self.lockBtn3.mas_trailing).offset(2);
    }];
    
    //NSRecursiveLockVC 递归锁/可重入锁
    self.lockBtn6 = [[UIButton alloc]init];
    self.lockBtn6.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:.7];
    [self.lockBtn6 setTitle:@"前往 递归锁" forState:UIControlStateNormal];
    [self.lockBtn6 addTarget:self action:@selector(gotoNextVCViaBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lockBtn6];
    [self.lockBtn6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lockBtn1);
        make.leading.mas_equalTo(self.lockBtn4.mas_trailing).offset(2);//TODO: 此处暂时接着4
    }];
}
-(void)gotoKVO{
    KVO_ViewController *vc = [[KVO_ViewController alloc]init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)gotoKVC{
    KVC_ViewController *vc = [[KVC_ViewController alloc]init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)gotoAFN{
    AFN_ViewController *vc = [[AFN_ViewController alloc]init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)gotoYY{
    YYK_ViewController *vc = [[YYK_ViewController alloc]init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)gotoAOP{
    AOP_ViewController *vc = [[AOP_ViewController alloc]init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}
@end
