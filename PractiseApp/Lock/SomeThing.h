//
//  SomeThing.h
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/6.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SomeThing : NSObject
@property (nonatomic) NSInteger number;
@property (nonatomic, strong) NSLock *lock;
@end

NS_ASSUME_NONNULL_END
