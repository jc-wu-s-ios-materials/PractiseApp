//
//  SellTicketsViewController.m
//  售票解决方案
//  PractiseApp
//
//  Created by 吴京城 on 2020/4/29.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "SellTicketsViewController.h"

//票数池
@interface TicketsPool : NSObject
@property (nonatomic) NSInteger ticketsCount;
@property (nonatomic) NSLock *lock;
-(instancetype)init NS_UNAVAILABLE;
+(instancetype)sharedInstance;
@end
@implementation TicketsPool
+(instancetype)sharedInstance{//单例
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        self.ticketsCount = 100;
        self.lock = [[NSLock alloc]init];
    }
    return self;
}

@end


//售票窗口NSOperation
@interface SellTickesOperation : NSOperation
@property (nonatomic, copy) NSString *city;
-(instancetype)initWithCityName:(NSString*)city;
@end
@implementation SellTickesOperation
-(void)main{
    while (1) {
        @synchronized ([TicketsPool sharedInstance]) {//这个锁等效于下面被注释的锁
//        [[TicketsPool sharedInstance].lock lock]; 注释掉的方法1
            
            NSInteger number =[TicketsPool sharedInstance].ticketsCount;
            if (number>0) {
                NSLog(@"%@窗口：出售倒数第%ld张票", self.city, number);
                [TicketsPool sharedInstance].ticketsCount --;
            }else{
                break;
            }
//        [[TicketsPool sharedInstance].lock unlock]; 注释掉的方法1
        }
        [NSThread sleepForTimeInterval:.01];
        
    }
    NSLog(@"%@窗口：售票完毕!",self.city);
}
-(instancetype)initWithCityName:(NSString*)city{
    self = [super init];
    if (self) {
        self.city = city;
    }
    return self;
}
@end

//售票问题控制器
@interface SellTicketsViewController ()

@end

@implementation SellTicketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SellTickesOperation *op1 = [[SellTickesOperation alloc]initWithCityName:@"成都"];
    SellTickesOperation *op2 = [[SellTickesOperation alloc]initWithCityName:@"北京"];
    SellTickesOperation *op3 = [[SellTickesOperation alloc]initWithCityName:@"青岛"];
    //这种写法只能先卖完成都票，然后另外两个窗口没法卖
//    [op1 start];
//    [op2 start];
//    [op3 start];
    NSOperationQueue *sellQueue = [[NSOperationQueue alloc]init];
    //添加下面这一行，最大并发数为1，变成串行队列了则不会出现三个窗口卖同一张票的情况。但是又会出现只有成都卖票，另外两个窗口没法卖的情况。
//    sellQueue.maxConcurrentOperationCount = 1;
    //只写这3行，会出现不同城市窗口出售同一张票的现象
    [sellQueue addOperation:op1];
    [sellQueue addOperation:op2];
    [sellQueue addOperation:op3];
    //当我在SellTickesOperation的main方法中添加了一个@synchronize(){}锁之后，问题解决
    //也可以为TicketPool增加一个NSlock属性，然后在SellTickOperation的main方法手动加锁解锁，问题解决

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
