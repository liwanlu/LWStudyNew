//
//  AFNStudyController.m
//  LWStudy
//
//  Created by liwanlu on 2020/9/25.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import "AFNStudyController.h"
#import "AFNetworking.h"
#import <XMPPFramework/XMPPFramework.h>



/*
 1:上传文件方法
 2:系列化相关，manager的系列化代理
 */

@interface AFNStudyController ()

@end

@implementation AFNStudyController
{
    NSProgress *progress;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     1:AFHTTPRequestOperationManager进行get，post操作，它里面封装的是NSURLConnectionOperation，operation里面那响应头
     2:AFHTTPSessionManager，它里面封装的是NSURLSession；task里面拿响应头
     */
   
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    
    [manager GET:@"http://120.79.141.109:8082/inter/list2?curpage=1&pageSize=100000&auid=124678" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nullable responseObject) {
        NSLog(@"返回数据\n:%@",responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
    
     /*
    [manager POST:@"http://120.79.141.109:8082/newlogin" parameters:@{@"phone":@"1760000001",@"code":@"3776"} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nullable responseObject) {
        NSLog(@"登陆结果:%@",responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
         NSLog(@"登陆失败:%@",error);
    }];
    
    
    AFHTTPSessionManager *sessionManager=[AFHTTPSessionManager manager];
    [sessionManager GET:@"http://120.79.141.109:8082/inter/list2?curpage=1&pageSize=100000&auid=124678" parameters:@{} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"sessionGet:%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"sessionGetError:%@",error);
    }];
    
    
    [sessionManager POST:@"http://120.79.141.109:8082/newlogin" parameters:@{@"phone":@"1760000001",@"code":@"3776"} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"session登陆结果:%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"session登陆error:%@",error);
    }];
    */
    
    //下载
    /*
     AFHTTPSessionManager *downLoadsessionManager=[AFHTTPSessionManager manager];
    
    [downLoadsessionManager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        NSLog(@"%.2f%%",1.0*totalBytesWritten/totalBytesExpectedToWrite*100);
    }];
    

    
  NSURLSessionDownloadTask *downloadTak=[downLoadsessionManager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://img.maituichina.com/2019/12/20191251575719428679Vy06ZZ.mp4"]] progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:[@"/Users/liwanlu/Downloads" stringByAppendingPathComponent:response.suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"下载完成：%@-----error%@",filePath,error);
    }];
    [downloadTak resume];
    
//    /Users/liwanlu/Downloads/20191251575719428679Vy06ZZ.mp4

    
    
    
    //上传,这个方法监听进度比较麻烦
  NSURLSessionDataTask *dataTask=[downLoadsessionManager POST:@"http://api.maituichina.com/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *fileData=[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:@"/Users/liwanlu/Downloads/20191251575719428679Vy06ZZ.mp4"]];
        
//        [formData appendPartWithFormData:fileData name:@"file"];
         [formData appendPartWithFileData:fileData name:@"file" fileName:@"test.mp4" mimeType:@"image/*"];
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"上传成功%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"上传失败%@",error);
    }];
    
   progress=[downLoadsessionManager uploadProgressForTask:dataTask];
    
    [progress addObserver:self forKeyPath:@"completedUnitCount" options:kNilOptions context:nil];
    
    
   */
    
    
    
    //网络监听
    AFNetworkReachabilityManager *networkManager=[AFNetworkReachabilityManager sharedManager];
    
    [networkManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown          = -1,未知
          AFNetworkReachabilityStatusNotReachable     = 0,无网络
          AFNetworkReachabilityStatusReachableViaWWAN = 1,移动网络
          AFNetworkReachabilityStatusReachableViaWiFi = 2,wifi
         */
        
        NSLog(@"网络状态%d",status);
    }];
    [networkManager startMonitoring];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"上传进度%.2f%%",1.0*progress.completedUnitCount/progress.totalUnitCount*100);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"progress=%d",progress.completedUnitCount);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
