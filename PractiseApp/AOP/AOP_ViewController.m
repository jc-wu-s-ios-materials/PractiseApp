//
//  AOP_ViewController.m
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/8.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "AOP_ViewController.h"
#import "Stastic.h"
#import "Guy.h"

@interface AOP_ViewController ()

@end

@implementation AOP_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_HERE);
    
    //一般的做法(非AOP)
    [Stastic stasticWithEventName:@"普通做法:AOP_ViewController"];
    
    //AOP做法
    //创建了 AOP_ViewController+Stastic .h.m 文件
    //交换了 -viewDidLoad 和 -swizzle_viewDidLoad 方法
    //在 新的-viewDidLoad 方法中先加上了一句[Stastic stasticWithEventName:@"AOP做法----> AOP_ViewController"];\
        然后调用原来的 -viewDidLoad方法
    
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"下面使用Aspect框架练习一下AOP");
    
    Guy * lyx = [[Guy alloc]initWithName:@"lyx"];
    Guy * zzb = [[Guy alloc]initWithName:@"zzb"];
    Guy * xq = [[Guy alloc]initWithName:@"xq"];
    
    NSLog(@"第一次问三人陌生问题");
    [zzb aspect_hookSelector:@selector(isAskedQuestionsHeDontKnow) withOptions:AspectPositionInstead usingBlock:^{
        NSLog(@"%@说:我知道！这是x*&^%%$#@(一顿胡说八道)...",zzb.name);
    } error:nil];
    [lyx isAskedQuestionsHeDontKnow];
    [xq isAskedQuestionsHeDontKnow];
    [zzb isAskedQuestionsHeDontKnow];
    //意料之中，zzb的方法被替换了。
    
    [NSThread sleepForTimeInterval:3];
    NSLog(@"3秒后又问了这个问题");
    
    [Guy aspect_hookSelector:@selector(isAskedQuestionsHeDontKnow) withOptions:AspectPositionAfter usingBlock:^{
        NSLog(@"又说:真的别问了");
    } error:nil];
    [lyx isAskedQuestionsHeDontKnow];
    [xq isAskedQuestionsHeDontKnow];
    [zzb isAskedQuestionsHeDontKnow];
    //验证到此处，zzb的方法竟然也加了这个block TODO:  这是为什么呢？那么需要研究源代码了
    
    
}


@end
