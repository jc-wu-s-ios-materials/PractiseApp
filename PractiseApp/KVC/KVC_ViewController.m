//
//  KVC_ViewController.m
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/7.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "KVC_ViewController.h"
#import "Man.h"
@interface KVC_ViewController ()

@end

@implementation KVC_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_HERE);
    
    
    //初始化wjc
    Man *wjc = [[Man alloc]init];
    
    //查看属性
    [self showMan:wjc];
    
    //修改属性
    [self changeMan:wjc];
    
    //再次查看属性
    [self showMan:wjc];
    
    //此处不做练习的一个知识点是：KVC可以触发KVO ，因为已经在KVO_ViewController中练习了
}

-(void)showMan:(Man*)someone{
    NSLog(@"someone的外套颜色是:%@",someone.colorOfCoat);//Man类中 唯一可以使用“.”语法获取的变量
    NSLog(@"someone的头发颜色是:%@",someone->colorOfHair);//虽然是public但是没有实现getter和setter无法使用“.”语法
    NSLog(@"someone的袜子颜色是:%@",[someone valueForKey:@"colorOfSock"]);//袜子颜色为private，没有实现getter和setter，可使用KVC读取private属性
    //favoriteStar是拓展属性，提示'Man' does not have a member named 'favoriteStar'
//    NSLog(@"someone的喜欢明星是%@",someone->favoriteStar);
    //favoriteStar是拓展属性，尽管有getter和setter，但是外部不可见，编译器提示Property 'favoriteStar' not found on object of type 'Man *'
//    NSLog(@"someone的喜爱明星是%@",someone.favoriteStar);
    NSLog(@"someone的喜爱明星是:%@",[someone valueForKey:@"favoriteStar"]);//可使用KVC读取拓展属性 forKey
    
    //下面使用KVC读取拓展属性favoriteStar的内部属性，如果favoriteStar为空也没有导致异常或者崩溃
    //可使用KVC读取拓展属性的属性 forKeyPath 此处name是favoriteStar的private属性
    NSLog(@"someone的喜爱明星名字是:%@",[someone valueForKeyPath:@"favoriteStar.name"]);
    //可使用KVC读取扩展属性的扩展属性 forKeyPath 此处sex是favoriteStar的拓展属性
    NSLog(@"someone的喜爱明星性别是:%@",[someone valueForKeyPath:@"favoriteStar.sex"]);
    //可使用KVC读取拓展属性的扩展private属性 forKeyPath 此处colorOfSock是favoriteStar的扩展private属性
    NSLog(@"someone的喜爱明星袜子颜色是:%@",[someone valueForKeyPath:@"favoriteStar.colorOfSock"]);

    /*
     valueForKey:的取值原理：
     按照getKey:、key、isKey、_key的顺序查找方法；
     如果找到方法，则直接调用方法；
     如果没找到方法，则查看accessInstanceVariablesDirectly方法的返回值；
     如果返回值为NO，则会调用valueForUndefinedKey:方法，并抛出异常，NSUnknownKeyException。
     如果返回值为YES，则按照_key -> _isKey -> key -> isKey 的顺序查找成员变量；
     如果查找到了上述4个中的一个，直接取值；
     如果都没找到，则会调用valueForUndefinedKey:方法，并抛出异常，NSUnknownKeyException。
     */
}
-(void)changeMan:(Man*)someone{
    someone.colorOfCoat = @"黑色";//Man类中 唯一可以使用"."语法修改的变量
    someone->colorOfHair = @"黑色";//public属性，可以直接修改
//    someone->colorOfSock = @"改不了";//Instance variable 'colorOfSock' is private
    [someone setValue:@"白色" forKey:@"colorOfSock"];//KVC直接修改类private属性
//    [someone setValue:nil forKey:@"favoriteStar"];//KVC直接修改拓展属性 forKey 可行
    [someone setValue:@"佟丽娅" forKeyPath:@"favoriteStar.name"];//KVC直接修改拓展属性favoriteStar的类private属性 forKeyPath
    [someone setValue:@"女" forKeyPath:@"favoriteStar.sex"];//KVC直接修改拓展属性favoriteStar的拓展sex属性 forKeyPath
    [someone setValue:@"不知道呀" forKeyPath:@"favoriteStar.colorOfSock"];//KVC直接修改拓展属性favoriteStar的拓展private属性 forKeyPath
    //Tips:由于我的拼写错误将forKeyPath拼写为forKey,导致结果==“修改成功”+弹出NSUnknownKeyException异常导致崩溃，原因在此方法结束注释说明
    
    
    /*
     setValue:forKey:的赋值原理：
     按照setKey:、_setKey的顺序查找方法；
     如果找到方法，则传递参数，调用方法；
     如果没找到方法，则查看accessInstanceVariablesDirectly方法的返回值；
     如果返回值为NO，则会调用setValue:forUndefinedKey:方法，并抛出异常，NSUnknownKeyException。
     如果返回值为YES，则按照_key -> _isKey -> key -> isKey 的顺序查找成员变量；
     如果查找到了上述4个中的一个，直接赋值；
     如果都没找到，则会调用setValue:forUndefinedKey:方法，并抛出异常，NSUnknownKeyException。
     注意：accessInstanceVariablesDirectly这个方法的默认返回值为YES
     */
}

@end
