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
    //init初始状态，饥饿状态为 PersonStatusUnkown ,名字为 @“还没有名字”。
    
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
    [self.baby addObserver:self forKeyPath:@"name" options:option context:@"监控baby名字"];//观察私有属性
    //仅仅给baby注册了观察者，没有给adult注册
    
    //模拟一下变饿了
    [NSThread detachNewThreadWithBlock:^{
        [NSThread sleepForTimeInterval:3];
        self.baby.PersonStatus = PersonStatusHungry;//baby饿了
        self.adult.PersonStatus = PersonStatusHungry;//adult饿了
        
        //self.baby->name 没有setter方法 此处直接修改name，无法触发KVO监听
        [self.baby firstTimeChangeName];//改名为“庞麦郎”;
    }];
    
    [NSThread detachNewThreadWithBlock:^{
        [NSThread sleepForTimeInterval:6];
        self.baby.PersonStatus = PersonStatusUnknown;
        self.adult.PersonStatus = PersonStatusUnknown;
        
        //self->baby->name 没有setter方法 此处手动调用KVO监听
        [self.baby willChangeValueForKey:@"name"];
        [self.baby secondTimeChangeName];//改名为"约瑟夫·庞麦郎"
        [self.baby didChangeValueForKey:@"name"];
    }];
    
    [NSThread detachNewThreadWithBlock:^{
        [NSThread sleepForTimeInterval:10];
        
        //使用kVC方式修改baby饥饿状态，可以触发KVO监听
        [self.baby setValue:@(PersonStatusFull) forKey:@"PersonStatus"];
        //第三次改名，使用KVC方式改名,即使没有setter方法、没有手动调用KVO，也能触发KVO监听
        [self.baby setValue:@"直播带货·庞麦郎" forKey:@"name"];
        
    }];
}
-(void)dealloc{
    //已经移除过的observer再次移除会crash，出现NSRangeException越界异常
    [self.baby removeObserver:self forKeyPath:@"PersonStatus" context:@"监控baby饥饿状态"];
    //如果忘记移除，则也可能出现crash。因此 注册和移除 必须成对出现。
    
    [self.baby removeObserver:self forKeyPath:@"name" context:@"监控baby名字"];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    //只有注册了观察者的baby才会触发这里，未注册观察者的adult不会触发这里
//    NSLog(@"监控到如下内容:\nkeyPath==%@\nobject==%@\nchange==%@\ncontext==%@",keyPath,object,change,context);
    
    
    if (object==self.baby && [keyPath isEqualToString:@"PersonStatus"]) {//若监控到的结果是 baby 的 PersonStatus
        //[dict valueForkey:]传出的是指针,类型位valueType，此处已经在方法头部被指定为id类型
//        NSInteger kind =  [[change valueForKey:@"kind"] integerValue];//TODO: kind == 1 到底代表什么呢？
//        NSInteger old = [[change valueForKey:@"old"] integerValue];
        NSInteger new = [[change valueForKey:@"new"] integerValue];
//        NSLog(@"读取change内:\nkind==%ld,old==%ld,new==%ld",kind,old,new);
        if (new == PersonStatusHungry) {
            NSLog(@"监控到baby饿了");
        }else if (new == PersonStatusFull){
            NSLog(@"监控到baby饱了");
        }
    }else if (object==self.baby && [keyPath isEqualToString:@"name"]){
        id oldname = [change valueForKey:@"old"];
        id newname = [change valueForKey:@"new"];
        NSLog(@"self->baby改名了：\n旧名字==%@\n新名字==%@",oldname,newname);
        //打印结果只检测到第二次改名，未检测到第一次改名
        //因为baby的name属性没有setter方法，所以只有第二次改名时主动调用了KVO才成功触发
    }else if (object == self.adult){//不可能事件
        NSLog(@"夭寿了");
        /*
         Q & A
         A ：iOS用什么方式实现对一个对象的KVO？(KVO的本质是什么？)
         利用RuntimeAPI动态生成一个子类，并且让instance对象的isa指向这个全新的子类
         当修改instance对象的属性时，会调用Foundation的_NSSetXXXValueAndNotify函数
         willChangeValueForKey:
         父类原来的setter
         didChangeValueForKey:
         内部会触发监听器（Oberser）的监听方法( observeValueForKeyPath:ofObject:change:context:）
         Q : 如何手动触发KVO?
         A ：被监听的属性的值被修改时，就会自动触发KVO。如果想要手动触发KVO，则需要我们自己调用willChangeValueForKey:和didChangeValueForKey:方法，即可在不改变属性值的情况下手动触发KVO，并且这两个方法缺一不可。
         */
    }
}


@end
