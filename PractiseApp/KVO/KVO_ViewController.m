//
//  KVO_ViewController.m
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/7.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "KVO_ViewController.h"
#import "Person.h"

@interface KVO_ViewController ()
@property (nonatomic, strong) Person *baby;//baby需要监控
@property (nonatomic, strong) Person *adult;//成人不管他


@end

@implementation KVO_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_HERE);
    
    self.baby = [[Person alloc]init];//创建一个Person对象 baby ，将被监控饥饿状态
    self.adult = [[Person alloc]init];//创建一个Person对象 adult ， 不被监控饥饿状态
    
    //注册KVO观察者
    NSKeyValueObservingOptions option = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;//按位 或 ，对change字典进行配置
    /*
     options：KVO的一些属性配置。
     NSKeyValueObservingOptionNew：change字典包括改变后的值
     NSKeyValueObservingOptionOld:change字典包括改变前的值
     NSKeyValueObservingOptionInitial:注册后立刻触发KVO通知
     NSKeyValueObservingOptionPrior:值改变前是否也要通知（这个key决定了是否在改变前改变后通知两次
     */
    //此处官方文档建议撤销observer时调用-removeObserver:fromObjectsAtIndexes:forKeyPath:context:
    
    //KVO注册观察者，既可以观察公有属性，也可以观察私有属性
    [self.baby addObserver:self forKeyPath:@"PersonStatus" options:option context:@"监控baby饥饿状态"];//context类型是 void*
    //仅仅给baby注册了观察者，没有给adult注册
    
    //模拟一下变饿了
    [NSThread detachNewThreadWithBlock:^{
        [NSThread sleepForTimeInterval:3];
        self.baby.PersonStatus = PersonStatusHungry;//baby饿了
        self.adult.PersonStatus = PersonStatusHungry;//adult饿了
    }];
    
    [NSThread detachNewThreadWithBlock:^{
        [NSThread sleepForTimeInterval:5];
        self.baby.PersonStatus = PersonStatusUnknown;
        self.adult.PersonStatus = PersonStatusUnknown;
    }];
}
-(void)dealloc{
    //已经移除过的observer再次移除会crash，出现NSRangeException越界异常
    [self.baby removeObserver:self forKeyPath:@"PersonStatus" context:@"监控baby饥饿状态"];
    //如果忘记移除，则也可能出现crash。因此 注册和移除 必须成对出现。
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    //只有注册了观察者的baby才会触发这里，未注册观察者的adult不会触发这里
    NSLog(@"监控到如下内容:\nkeyPath==%@\nobject==%@\nchange==%@\ncontext==%@",keyPath,object,change,context);
    
    
    if (object==self.baby && [keyPath isEqualToString:@"PersonStatus"]) {//若监控到的结果是 baby 的 PersonStatus
        //[dict valueForkey:]传出的是指针,类型位valueType，此处已经在方法头部被指定为id类型
//        NSInteger kind =  [[change valueForKey:@"kind"] integerValue];//TODO: kind == 1 到底代表什么呢？
//        NSInteger old = [[change valueForKey:@"old"] integerValue];
        NSInteger new = [[change valueForKey:@"new"] integerValue];
//        NSLog(@"读取change内:\nkind==%ld,old==%ld,new==%ld",kind,old,new);
        if (new == PersonStatusHungry) {
            NSLog(@"监控到baby饿了");
        }
    }else if (object == self.adult){//不可能事件
        NSLog(@"夭寿了");
        /*
         Q & A
         Q ：iOS用什么方式实现对一个对象的KVO？（KVO的本质是什么？）
         A ：当一个对象使用了KVO监听，iOS系统会修改这个对象的isa指针，改为指向一个全新的通过Runtime动态创建的子类 NSKVONotifying_对象 的类，子类拥有自己的set方法实现，set方法实现内部会顺序调用
         willChangeValueForKey：方法
         原来的setter方法实现
         didChangeValueForKey：方法
         而didChangeValueForKey：方法内部又会调用监听器的observeValueForKeyPath:ofObject:change:context:监听方法。
         Q : 如何手动触发KVO?
         A ：被监听的属性的值被修改时，就会自动触发KVO。如果想要手动触发KVO，则需要我们自己调用willChangeValueForKey:和didChangeValueForKey:方法，即可在不改变属性值的情况下手动触发KVO，并且这两个方法缺一不可。
         */
    }
}


@end
