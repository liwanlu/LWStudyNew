//
//  NSOperationStudyController.m
//  LWStudy
//
//  Created by liwanlu on 2020/9/22.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import "NSOperationStudyController.h"
#import "LWOperation.h"

@interface NSOperationStudyController ()
@property(nonatomic,strong) NSOperationQueue *mQueue;

@end

@implementation NSOperationStudyController
{
      UIImageView *imgview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imgview=[[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 300)];
       [self.view addSubview:imgview];
    
//    self.view.backgroundColor=[UIColor whiteColor];
   /*
    1:NSInvocationOperation,NSBlockOperation单独使用的话，是在主线程执行的。但NSBlockOperation如果封装的操作超过1个(通过addExecutionBlock方法)，超过部分会新开线程执行
    2:继承NSOperation，需要实现main方法，在里面做操作即可。其他使用方法和1里面两个一样
    3:NSOperationQueue用于封装NSOperation对象，加到queue里面的对象会自动等待开始，不需要掉star方法了。
    [NSOperationQueue mainQueue]获取主队列，在主线程执行，new出来的都是非主队列，在新线程执行
    4:queue的maxConcurrentOperationCount字段表示最大并行数量，大于1的话属于并行队列，等于1属于串行队列，等于0不会执行里面的对象
    5:queue的suspended字段，表示暂停和继续执行。设为YES，线程会暂停，NO继续执行。但是值暂停未开始的操作，进行中的即使暂停了，还是会继续执行。
    6:queue的cancelAllOperations方法取消所有操作。同样的，只有未开始的操作才会被取消
    7:queue可以通过addOperationWithBlock方法快捷加入操作。
    8:NSOperation的isCancelled字段表示这个操作是否被取消了。由于6里面的原因，进行中的不能被取消，所以可以在操作进行时判断这个字段，如果被取消了，直接不在执行后面的代码。一般在自定义NSOperation里用
    9:op的依赖，即执行顺序：【op addDependency：op2】方法，意思是op1依赖以op2，必须等op2完成后才执行。和gcd里面的group作用类似
    10:setCompletionBlock,执行完毕操作。
    11:线程通讯： [[NSOperationQueue mainQueue] addOperationWithBlock:^{
           这里访问需要传递的数据
       }];
    12:queue也有栅栏【queue addBarrierBlock】，添加后，后面的代码只能等栅栏代码执行完成，才会执行
    */
    
    //1:普通用法
//    [self commendStarTest];
    
    //2和队列一起用
//    [self queueTest];
    
    
    //3暂停恢复操作
//    [self suspenedTest];
    
    //依赖和栅栏操作
//    [self denpendencyTest];
    
    //下载操作
    [self downLoadTest];
    
    
}
-(void)commendStarTest
{
    //自定义op
    LWOperation *lwop=[LWOperation new];
    [lwop start];//在主线程执行
    
    //方法调用的op
    NSInvocationOperation *invoOp=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    [invoOp start];//在主线程执行
    
    
    
    //block调用的op
    NSBlockOperation *blockOP=[NSBlockOperation blockOperationWithBlock:^{
         NSLog(@"blockOP0---%@",[NSThread currentThread]);//第一个block在主线程执行
    }];
    [blockOP addExecutionBlock:^{
        NSLog(@"blockOP1---%@",[NSThread currentThread]);//其他block在新线程执行
    }];
    [blockOP addExecutionBlock:^{
        NSLog(@"blockOP2---%@",[NSThread currentThread]);//其他block在新线程执行
    }];
    [blockOP start];
}


-(void)queueTest
{
    NSOperationQueue *mainQueue=[NSOperationQueue mainQueue];
   
    //mainQueue里面的操作一定是在主线程完成
    [mainQueue addOperationWithBlock:^{
        NSLog(@"mainQUeue---%@",[NSThread currentThread]);
    }];
    
    
    //init出来的queue操作在新线程
    NSOperationQueue *queue=[[NSOperationQueue alloc] init];
    LWOperation *lwOP=[LWOperation new];
    queue.maxConcurrentOperationCount=1;//设置为1的话为串行队列，一个一个执行
    
    
    NSBlockOperation *blockOP=[NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"blockOP0---%@",[NSThread currentThread]);//第一个block在主线程执行
       }];
    
    NSInvocationOperation *invoOp=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    
    [queue addOperation:lwOP];
     [queue addOperation:blockOP];
    [queue addOperation:invoOp];
    [queue addOperationWithBlock:^{
        NSLog(@"addOperationWithBlock---%@",[NSThread currentThread]);
    }];
    
    
}

-(void)suspenedTest
{
    _mQueue=[[NSOperationQueue alloc] init];
    
    //测试结果发现，如果不设置最大值，暂停不了，可能执行开始后就把所有操作当成之中了,但是可以cancelAllOperations
//    _mQueue.maxConcurrentOperationCount=10;
    for (int i=0; i<10000; i++) {
        NSBlockOperation *blockOP=[NSBlockOperation blockOperationWithBlock:^{
            [NSThread sleepForTimeInterval:0.5];
                   NSLog(@"blockOP%d---%@",i,[NSThread currentThread]);//第一个block在主线程执行
        }];
        [_mQueue addOperation:blockOP];
    }
}

-(void)denpendencyTest
{
  __block  int a=0;
  __block  int b=0;
    
    NSBlockOperation *op1=[NSBlockOperation blockOperationWithBlock:^{
        a=100;
         NSLog(@"op1完成");
    }];
    
    NSBlockOperation *op2=[NSBlockOperation blockOperationWithBlock:^{
//        [NSThread sleepForTimeInterval:2];
          b=200;
        NSLog(@"op2完成");
      }];
    
    NSBlockOperation *op3=[NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"a+b=%d",a+b);
    }];
    
//    [op3 addDependency:op1];
//     [op3 addDependency:op2];
    //op3依赖1和2，所以必须等待1和2都完成
    
    NSOperationQueue *queue=[NSOperationQueue new];
    [queue addOperation:op1];
    [queue addOperation:op2];
    
    [queue addBarrierBlock:^{
         [NSThread sleepForTimeInterval:2];
    }];
     [queue addOperation:op3];
   
}

-(void)downLoadTest
{
    
    NSOperationQueue *queue=[NSOperationQueue new];
    
    NSBlockOperation *downOP=[NSBlockOperation blockOperationWithBlock:^{
         NSData *imgData=[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1600769534145&di=fd0c3cde90d0fe478edbd32e10093b8a&imgtype=0&src=http%3A%2F%2Fimage.namedq.com%2Fuploads%2F20191103%2F19%2F1572779306-CbwlrmPnJD.jpg"]];
                             //主要是学习下面两句代码
                             if(imgData!=nil)
                             {
                                 NSLog(@"imgData=%.2f MB",imgData.length/1024.0/1024.0);
                                 UIImage *img=[UIImage imageWithData:imgData];
                                 if(img!=nil)
                                 {
                                     //这也是线程间传值的手段
                   //                [imgview performSelectorOnMainThread:@selector(setImage:) withObject:img waitUntilDone:YES];
                                     
                                     //gcd里靠这个方法回到主线程并传值
        //                             dispatch_async(dispatch_get_main_queue(), ^{
        //                                 imgview.image=img;
        //                             });
                                     
                                     
                                     
                                     [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                          imgview.image=img;
                                     }];
                                 }
                                 else
                                 {
                                      NSLog(@"转换失败");
                                 }
                             }
                             else
                             {
                                 NSLog(@"下载数据失败");
                             }
                
    }];
    
    [downOP setCompletionBlock:^{
        NSLog(@"下载线程完成了---%@",[NSThread currentThread]);
    }];
    
    [queue addOperation:downOP];
    
      
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    _mQueue.suspended=!_mQueue.suspended;
    
//    [_mQueue cancelAllOperations];
    
    
}
-(void)run
{
    NSLog(@"run---%@",[NSThread currentThread]);
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
