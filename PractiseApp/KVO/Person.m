//
//  Person.m
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/7.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "Person.h"


@implementation Person

-(instancetype)init{
    self = [super init];
    if (self) {
        self.PersonStatus = PersonStatusUnknown;
    }
    return self;
}
@end
