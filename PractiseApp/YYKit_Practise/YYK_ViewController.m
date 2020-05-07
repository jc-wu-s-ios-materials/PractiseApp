//
//  YYK_ViewController.m
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/7.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "YYK_ViewController.h"
#import <YYKit.h>

@interface YYK_ViewController ()
@property (nonatomic, strong) YYAnimatedImageView *bigImgView;

@end

@implementation YYK_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_HERE);
    //清理缓存
    [self clearImageCache];//在本文件自定义的清理image缓存
    [NSThread sleepForTimeInterval:2];//主线程等一下清理，再进行下面的网络图片加载。正常不这样操作，这里只是为了看效果。
    
    
    //加载网络大图片
    self.bigImgView = [[YYAnimatedImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.bigImgView];
    NSURL *bigImgUrl = [NSURL URLWithString:@"http://pic1.win4000.com/wallpaper/7/57a9703a4377a.jpg"];
//    [self.bigImgView setImageWithURL:bigImgUrl options:YYWebImageOptionProgressive];//渐进式图片加载,边下载边显示
    [self.bigImgView setImageWithURL:bigImgUrl options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation];//模糊和渐变
//    [self.bigImgView setImageWithURL:bigImgUrl
//                         placeholder:nil
//                             options:YYWebImageOptionSetImageWithFadeAnimation
//                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
////                                    progress = (float)receivedSize / expectedSize;
//                                    }
//                           transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
//                                    image = [image imageByResizeToSize:CGSizeMake(100, 100) contentMode:UIViewContentModeCenter];
//                                    return [image imageByRoundCornerRadius:10];
//                                    }
//                          completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//                                    if (from == YYWebImageFromDiskCache) {
//                                        NSLog(@"load from disk cache");
//                                    }
//    }];
    
    
}

-(void)clearImageCache{
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    // 获取缓存大小
//    cache.memoryCache.totalCost;
//    cache.memoryCache.totalCount;
//    cache.diskCache.totalCost;
//    cache.diskCache.totalCount;
    NSLog(@"缓存如下:\n%ld\n%ld\n%ld\n%ld",cache.memoryCache.totalCost,cache.memoryCache.totalCount,cache.diskCache.totalCost,cache.diskCache.totalCount);
    // 清空缓存
    [cache.memoryCache removeAllObjects];
    [cache.diskCache removeAllObjects];
        
    // 清空磁盘缓存，带进度回调
    [cache.diskCache removeAllObjectsWithProgressBlock:^(int removedCount, int totalCount) {
       // progress
    } endBlock:^(BOOL error) {
       // end
        NSLog(@"清理结束");
    }];
}

@end
