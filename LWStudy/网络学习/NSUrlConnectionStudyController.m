//
//  NSUrlConnectionStudyController.m
//  LWStudy
//
//  Created by liwanlu on 2020/9/23.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import "NSUrlConnectionStudyController.h"
#import <Foundation/Foundation.h>

@interface NSUrlConnectionStudyController ()<NSURLConnectionDataDelegate>
@property(nonatomic,strong) NSMutableData *fileData;
@property(nonatomic,strong) NSFileHandle *fileHand;
@end

@implementation NSUrlConnectionStudyController
{
    NSInteger totalLength;
    NSString *currentName;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
     1:http概念： 超文本传送协议，请求，响应的通信方式
     请求头：包含请求环境信息，比如userAgent，编码，请求方式（get，post），url，请求体
     响应头的概念：包含数据类型，编码，长度等
     请求体：post请求才需要，上传的参数用xxx=xxx&xxx=xxx这个形式放在请求体里面。formBody
     2:NSUrlConnection的使用
     */
    
    [self delegateTest];
}
//直接请求
-(void)syncTest
{
    NSURL *url=[NSURL URLWithString:@"http://120.79.141.109:8082/mall/product/keyword"];
  NSURLRequest *request=  [[NSURLRequest alloc] initWithURL:url];
    
    
    
  NSData *responData=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *responStr=[[NSString alloc] initWithData:responData encoding:NSUTF8StringEncoding];
    
  NSLog(@"sync=%@",responStr);
    
  
    
    
    //参数queue表示回掉block执行的queue，而不是网络访问的queue
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        
        NSString *responStr2=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          
          NSLog(@"async=%@",responStr2);
          
    }];
}

-(void)PostTest
{
    NSURL *url=[NSURL URLWithString:@"http://120.79.141.109:8082/newlogin"];
     NSMutableURLRequest *request=  [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod=@"POST";
    //test=1&test=2 特别关注这里，一个参数多个值这样传是可行的
    request.HTTPBody=[@"phone=1760000001&code=3777&test=1&test=2" dataUsingEncoding:NSUTF8StringEncoding];
    
//    [request setValue:@"ios 10.0 xxx" forKey:@"userAgrent"];//这样设置其他头属性
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        NSString *responStr2=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//                NSLog(@"post=%@",responStr2);
        
        //options传NSJSONReadingMutableContainers直接解析成可变字典或数组
      NSMutableDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        [dic setValue:@"bbb" forKey:@"aaa"];
        NSLog(@"dic=-------%@",dic);
        
    }];
}

-(void)delegateTest
{
    NSURL *url=[NSURL URLWithString:@"http://img.maituichina.com/2019/12/20191251575719428679Vy06ZZ.mp4"];
    NSMutableURLRequest *request=  [[NSMutableURLRequest alloc] initWithURL:url];
    
    request.HTTPMethod=@"HEAD";//直接请求头，不执行数据返回，代理只回掉didReceiveResponse和finish方法，可以用来做下载前获取成都名称等
    //直接请求的方法，没有返回值
//    [NSURLConnection connectionWithRequest:request delegate:self];
    
    
    
    //可以拿到对象的初始化方式
// NSURLConnection *con=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    //可以拿到对象且能指定是否马上开始执行的方式。NO的话，后面可以用star开始
  NSURLConnection *con2=[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
//      [con2 setDelegateQueue:[[NSOperationQueue alloc] init] ];//设置代理在那个queue执行，默认mainQueue
    [con2 start];
    
  
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"开始响应,内容长度：%lld B----文件名：suggestedFilename=%@",response.expectedContentLength,response.suggestedFilename);
    
    _fileData=[NSMutableData data];
    totalLength=response.expectedContentLength;
    currentName=response.suggestedFilename;
    
    NSFileManager *manager=[NSFileManager defaultManager];
    [manager createFileAtPath:[@"/Users/liwanlu/Downloads" stringByAppendingPathComponent:response.suggestedFilename] contents:nil attributes:nil];
    
    _fileHand=[NSFileHandle fileHandleForWritingAtPath:[@"/Users/liwanlu/Downloads" stringByAppendingPathComponent:response.suggestedFilename]];
    [_fileHand seekToEndOfFile];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
 
//    [_fileData appendData:data];
    
//    [_fileHand seekToFileOffset:_fileHand.availableData.length];
    [_fileHand writeData:data];
    NSLog(@"收到数据%lu----进度%.2f%%",(unsigned long)data.length,1.0*_fileData.length/totalLength*100);
    
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"请求出错%@",error);
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"下载完成---%lu",_fileData.length);
//    /Users/liwanlu/Downloads/test.jpg
//    [_fileData writeToFile:[@"/Users/liwanlu/Downloads" stringByAppendingPathComponent:currentName] atomically:YES];
//    _fileData=nil;
    
    [_fileHand closeFile];
    _fileHand=nil;
}
-(void)dealloc
{
    _fileData=nil;
    NSLog(@"dealloc");
}
@end
