//
//  AOP_ViewController+Stastic.m
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/8.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "AOP_ViewController+Stastic.h"
#import "Stastic.h"
#import <objc/runtime.h>
#import <objc/objc.h>


@implementation AOP_ViewController (Stastic)

+(void)load{
    swizzleMethod([self class], @selector(viewDidLoad), @selector(swizzle_viewDidLoad));
}
-(void)swizzle_viewDidLoad{
    //begain static event
    [Stastic stasticWithEventName:@"AOP做法:AOP_ViewController"];
    //call original implementation
    [self swizzle_viewDidLoad];
}

void swizzleMethod(Class class , SEL originalSelector , SEL swizzledSelector){
    //  the method might not exist in the class, but in its superclass
    //  不直接进行交换的理由是，不希望改变superclass中的实现，只希望为class添加实现或者替换实现
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    //  class_addMethod will fail if original method already exists
    //  YES if the method was added successfully, otherwise NO \
        (for example, the class already contains a method implementation with that name).
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    // the method doesn’t exist and we just added one
    if (didAddMethod) {
        /*
         *  This function behaves in two different ways:
         *  - If the method identified by \e name does not yet exist, it is added as if \c class_addMethod were called.
         *    The type encoding specified by \e types is used as given.
         *  - If the method identified by \e name does exist, its \c IMP is replaced as if \c method_setImplementation were called.
         *    The type encoding specified by \e types is ignored.
         */
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
@end
