//
//  Person.h
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/7.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,PersonStatus) {
    PersonStatusHungry = 1,
    PersonStatusFull = 2,
    PersonStatusUnknown = 3
};
@interface Person : NSObject
@property (nonatomic,assign) NSInteger PersonStatus;
@end

NS_ASSUME_NONNULL_END
