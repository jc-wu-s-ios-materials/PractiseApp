//
//  Guy.m
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/8.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "Guy.h"

@implementation Guy

- (instancetype)initWithName:(NSString *)name{
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}
-(void)isAskedQuestionsHeDontKnow{
    NSLog(@"%@说:我不知道",self.name);
}
@end
