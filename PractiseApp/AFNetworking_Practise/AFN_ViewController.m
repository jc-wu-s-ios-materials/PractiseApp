//
//  AFN_ViewController.m
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/7.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "AFN_ViewController.h"
#import <AFNetworking.h>

@interface AFN_ViewController ()

@end

@implementation AFN_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_HERE);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //GET 请求
    __block NSDictionary * responseDict = nil;
    NSString *weatherGetStr = @"http://t.weather.sojson.com/api/weather/city/101030100";
    [manager GET:weatherGetStr parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"进度== %f",downloadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseDict = responseObject;
        NSLog(@"城市为:%@,感冒建议为:%@",[responseDict valueForKeyPath:@"cityInfo.city"],[responseDict valueForKeyPath:@"data.ganmao"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取失败,内容为%@",error);
    }];
    
    //POST 请求
    //暂时没有可用接口，先放着
    
    
    //文件下载
    NSURL *downloadImgURL = [NSURL URLWithString:@"https://is3-ssl.mzstatic.com/image/thumb/Purple123/v4/d8/db/d5/d8dbd5a9-a218-8d3e-bfc3-1d6befb4632d/AppIcon-0-1x_U007emarketing-0-5-0-0-85-220.png/246x0w.png"];
    NSURLRequest *downloadImgRequest = [NSURLRequest requestWithURL:downloadImgURL];
    NSURLSessionDownloadTask *downloadImgTask =[manager
            downloadTaskWithRequest:downloadImgRequest
                           progress:^(NSProgress * _Nonnull downloadProgress) {
                                    NSLog(@"进度== %f",downloadProgress.fractionCompleted);}
                        destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                    NSLog(@"targetPath==%@",targetPath);//targetPath是临时存储地址
                                    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                                    NSString* filePath = [docPath stringByAppendingPathComponent:response.suggestedFilename];
                                    NSURL* url = [NSURL fileURLWithPath:filePath];
                                    return url;}
                  completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                    NSLog(@"handler线程为:%@",[NSThread currentThread]);//此处completionHandler已经处于主线程了！
                                    [self showImgWithFilePath:filePath];//将图片展示出来
    }];
    [downloadImgTask resume];
    
    //文件上传
    //暂时没有可用接口，先放着
    
    
    //网络状态的检测
    AFNetworkReachabilityManager *reachManager = [manager reachabilityManager];
    [reachManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"网络状态未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"网络不可用");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"正在使用Wifi");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"正在使用流量");
                break;
            default:
                break;
        }
    }];
    [reachManager startMonitoring];
    
    //HTTPS发送请求
    //暂时没有可用接口，先放着
}

-(void)showImgWithFilePath:(NSURL *)filePath{
    UIImageView * imgView = [[UIImageView alloc]init];
    UIImage *img = [UIImage imageWithContentsOfFile:filePath.resourceSpecifier];
    [imgView setImage:img];
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
}

@end
