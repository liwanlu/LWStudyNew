//
//  NSURLSessionStudyController.m
//  LWStudy
//
//  Created by liwanlu on 2020/9/25.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import "NSURLSessionStudyController.h"

@interface NSURLSessionStudyController ()<NSURLSessionDataDelegate,NSURLSessionDownloadDelegate>
@property(nonatomic,strong)NSURLSessionDownloadTask *dowmloadTask;
@property(nonatomic,strong)NSData *resumeData;
@property(nonatomic,strong)NSURLSession *session;
@end

@implementation NSURLSessionStudyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self postTest];
//    [self delegateTest];
    
    
    //还需要记录https的使用
}
-(void)postTest
{
    NSURL *url=[NSURL URLWithString:@"http://120.79.141.109:8082/newlogin"];
       NSMutableURLRequest *request=  [[NSMutableURLRequest alloc] initWithURL:url];
      request.HTTPMethod=@"POST";
      //test=1&test=2 特别关注这里，一个参数多个值这样传是可行的
      request.HTTPBody=[@"phone=1760000001&code=3777&test=1&test=2" dataUsingEncoding:NSUTF8StringEncoding];
      
    NSURLSession *session=[NSURLSession sharedSession];
    
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *result=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:\n%@---%@",result,[NSThread currentThread]);
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
        
        NSLog(@"转换成dic结果:\n%@",dic);
        
    }];
    [task resume];
    
}

-(void)delegateTest
{
      NSURL *url=[NSURL URLWithString:@"http://120.79.141.109:8082/newlogin"];
      NSURLSession *session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    [[session dataTaskWithURL:url] resume];//可以这样简单创建task，默认get方法
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    //指示下一步操作
    /*

     NSURLSessionResponseCancel = 0,取消操作，不处理后续
       NSURLSessionResponseAllow = 1,继续
       NSURLSessionResponseBecomeDownload = 2,转成下载
       NSURLSessionResponseBecomeStream= 3,转成流
     */
    NSLog(@"开始响应");
    completionHandler(NSURLSessionResponseAllow);//传NSURLSessionResponseCancel的话，直接去didCompleteWithError方法了。
}
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSString *result=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
           NSLog(@"返回结果:\n%@---%@",result,[NSThread currentThread]);
}
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"didCompleteWithError:%@",error);
}

//---------------------download------------------
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
                              didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"下载完成：%@",location);
    NSFileManager *manage=[NSFileManager defaultManager];
                     
                     //把文件移动到目标位置
    [manage moveItemAtPath:[location path] toPath:[NSString stringWithFormat:@"Users/liwanlu/Downloads/%@",downloadTask.response.suggestedFilename] error:nil];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
                                           didWriteData:(int64_t)bytesWritten
                                      totalBytesWritten:(int64_t)totalBytesWritten
                              totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"bytesWritten=%lld,totalBytesWritten=%lld,totalBytesExpectedToWrite=%lld,进度%.2f%%",bytesWritten,totalBytesWritten,totalBytesExpectedToWrite,1.0*totalBytesWritten/totalBytesExpectedToWrite*100);
    
    _progressView.progress=1.0*totalBytesWritten/totalBytesExpectedToWrite;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
                                      didResumeAtOffset:(int64_t)fileOffset
                                     expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"didResumeAtOffset:%lld------expectedTotalBytes=%lld",fileOffset,expectedTotalBytes);
}

//-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler
//{
//    NSLog(@"willPerformHTTPRedirection");
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}/Users/liwanlu/Downloads/20191251575719428679Vy06ZZ.mp4
*/


-(void)blockDwonloadTest
{
    NSURL *url=[NSURL URLWithString:@"https://down.qq.com/qqweb/PCQQ/PCQQ_EXE/PCQQ2020.exe"];
       NSMutableURLRequest *request=  [[NSMutableURLRequest alloc] initWithURL:url];
       NSURLSession *session=[NSURLSession sharedSession];
    
    //内部实现了读一块写一块的操作，存到缓存目录，只需要拿到本地路径，做后续操作即可，但是没有进度，可以暂停，可以取消
    NSURLSessionDownloadTask *downTask=[session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        if(error==nil)
        {
            NSLog(@"内容长度：%lld B----文件名：suggestedFilename=%@",response.expectedContentLength,response.suggestedFilename);
                   NSLog(@"本地文件地址:%@",location);
                   
                   NSFileManager *manage=[NSFileManager defaultManager];
                   
                   //把文件移动到目标位置
                   [manage moveItemAtPath:[location path] toPath:[NSString stringWithFormat:@"Users/liwanlu/Downloads/%@",response.suggestedFilename] error:nil];
        }
        else
        {
            NSLog(@"出错了");
        }
       
        
    }];
    
    self.dowmloadTask=downTask;
    
    [downTask resume];
}

-(void)delegateDownloadTest
{
    NSURL *url=[NSURL URLWithString:@"https://pcs.baidu.com/rest/2.0/pcs/file?method=download&app_id=778750&filename=Extra_eclipse导入gradle项目.wmv,Extra_eclipse导入gradle项目.wmv&path=/我的视频/Extra_eclipse导入gradle项目.wmv"];
//            NSMutableURLRequest *requestHead=  [[NSMutableURLRequest alloc] initWithURL:url];
//    requestHead.HTTPMethod=@"HEAD";
    
    
    
    
//    NSURL *url=[NSURL URLWithString:@"https://sh-ctfs.ftn.qq.com/ftn_handler/eda43618a21db2dfcebab82720cda31e2195bbf7ada46c323d2eb92e773d8467df8d8eeacda6732e11eeddbcce3ad3040bd207c258ec247d59e6a62aa0007255/01-%E4%B8%BA%E4%BB%80%E4%B9%88%E8%A6%81%E5%AD%A6%E4%B9%A0%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84%E4%B8%8E%E7%AE%97%E6%B3%95.mp4"];
          NSMutableURLRequest *request=  [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setValue:@"BAIDUID=EDD39AC90C8D6407340CF8D0162CF881:SL=0:NR=10:FG=1; BIDUPSID=DB0EBF0D0AABC2EF5CC1EFF1BF7BA17C; PSTM=1514107454; H_WISE_SIDS=144368_144358_144701_142019_144428_140631_139050_141748_144419_144134_144471_144482_144490_131246_137746_138883_141942_127969_140066_144283_140595_144251_140350_144608_144726_143923_144485_131423_144289_144880_142205_126065_107313_143948_139909_144952_144601_143478_144966_142912_140312_144535_143131_144238_143858_110085; MCITY=-%3A; BDUSS=wyT0Z2dDdEOXR1a2VWb1hQS3N6Qzh0aktlY29GbHNBR2N0UHRRM3JEdk5uNHRmRVFBQUFBJCQAAAAAAAAAAAEAAAAGcTsF6r~V5gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAM0SZF~NEmRfWm; BDORZ=B490B5EBF6F3CD402E515D22BCDA1598; BA_HECTOR=21al850l0101aksna31fmr7ar0j; H_PS_PSSID=32617_1455_32741_7567_7542_31660_32706_7516_32115_32719; BDRCVFR[feWj1Vr5u3D]=I67x6TjHwwYf0; delPer=0; PSINO=6; pcsett=1601105964-3bc67fb58ffa6644ea941d58a9f43b06; STOKEN=efb064b6b85b01715d2199b0125f628d0ce312c7f7963362c495dde0221b4cd2" forHTTPHeaderField:@"Cookie"];
    
    
    self.session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    self.dowmloadTask=[self.session downloadTaskWithRequest:request];
    
//    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request];
//
//    [dataTask resume];
    [self.dowmloadTask resume];
}





- (IBAction)btnCancelClick:(id)sender {
//    [self.dowmloadTask cancel];
    
    
    [self.dowmloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.resumeData=resumeData;
    }];
}

- (IBAction)btnResumeClick:(id)sender {
    if(self.resumeData)
    {
      _dowmloadTask=[self.session downloadTaskWithResumeData:self.resumeData];
         [_dowmloadTask resume];
    }
    else
    {
         [_dowmloadTask resume];
    }
   
}

- (IBAction)btnSupendClick:(id)sender {
    [self.dowmloadTask suspend];
     self.resumeData=nil;
}

- (IBAction)btnSatrClick:(id)sender {
    [self delegateDownloadTest];
    self.resumeData=nil;
}
-(void)dealloc{
    //释放session
    [self.session invalidateAndCancel];
    
    //另一个释放的方法，释放后可做操作
    [self.session resetWithCompletionHandler:^{
        
    }];
}
@end
