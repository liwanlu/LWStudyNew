//
//  BlockStudyController.m
//  LWStudy
//
//  Created by liwanlu on 2020/10/30.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import "BlockStudyController.h"
#import "Person.h"
#import "AddTools.h"




/*
 总结：
 1.不管写在@interface里还是@implementation里的变量，vc结束前都会回收掉。
 2.block里面用了self的话，如果self没有拥有block，还是可以正常回收的，如果self拥有block，就循环引用无法回收
 3.block里面用了@implementation里定义的变量（即self所拥有的东西）的话，等于用了self，结果和2一样。所以最好定义在interface里用weakself访问
 4.self所拥有的对象所拥有的block如果用了self，也会导致无法回收
 */

typedef int(^twoNumBlock)(int,int);

@interface BlockStudyController ()
@property(nonatomic,copy) void(^GtestBlock)(void);

@property(nonatomic,copy) void(^GParamBlock)(Person *);

@property(nonatomic,assign) int testNum;
@property(nonatomic,strong) Person *GPerson;

@property(nonatomic,strong) NSMutableArray *arry_blocks;

@end

@implementation BlockStudyController
{
    Person *MPerson;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   __block Person *person=[Person new];
//     Person *person=[Person new];
    person.pName=@"abc";
    person.pAge=10;
    
    
   __block int a=100;
    
    
    _testNum=1000;
    
    void(^testBlock)(void)=^{
        //这里的person只是定义block时的快照，是常量，只读,即person.pName=@"abc"这个对象。常量意思是：可以修改name，age等，但不能给person赋新值
        //后面代码里person重新new了一个，不影响这个
        //所以这个person本来是局部变量，block里引用后，生命周期就跟随block了。
        //_testNum属于全局变量，所以block外部修改它会影响里面的，因为block可以直接访问全局变量，静态变量。
        //使用__block修饰变量后，block里就能访问该变量，而不是快照，至于block持不持有该对象，需要看block数据局部（栈）block还是全局block，局部block不持有对象。但全局block持有对象。
      NSLog(@"block--%@--%d,a=%d----testNum=%d",person.pName,person.pAge,a,_testNum);
        
    };
    
    _GtestBlock=testBlock;
    
    NSLog(@"%@--%d",person.pName,person.pAge);
    
//    person.pName=@"bbbbb";
//    person.pAge=20;
    
    a=200;
    
    _testNum=2000;
    person=[Person new];
    person.pAge=100;
    person.pName=@"测试测试";
    testBlock();
    
    //这句之前，block里的person不会dealloc，因为_GtestBlock没释放并且拥有该person
    _GtestBlock=nil;//释放掉，里面的person也释放了
    
    person=nil;
    
    
  int(^sum)(int,int)= ^int(int a,int b){
        return a+b;
    };
    
    int sumResult=sum(1,1);
    NSLog(@"%d",sumResult);
    
    
    twoNumBlock sumBlock=^int(int a,int b){
        return a+b;
    };
    
   sumResult= sumBlock(3,4);
     NSLog(@"%d",sumResult);
    
    
    //链式方法编程
    AddTools *addTools=[AddTools new];
    
    sumResult=addTools.add(1).add(2).add(3).result;
     NSLog(@"%d",sumResult);
    
    
    
    
    //测试block传参数
    //结果：传参数不影响被传参数的生命周期。
    Person *pp=[Person new];
    pp.pName=@"param1";
    
    __weak typeof(self) weakSelf = self;
    
    
    __block  typeof(self) blockSelf = self;
    
    void(^ParamBlock)(Person *)=^(Person *p){
//        pp.pName=@"params3";
        NSLog(@"pp=%@,p=%@",pp.pName,p.pName);
        
//         self.GPerson.pName=@"selfPerson";//加上这句，就会导致vc无法回收
        
        weakSelf.GPerson.pName=@"selfPerson";//这样就可以
        
        
//          blockSelf.GPerson.pName=@"selfPerson";//arc下，这句也会导致循环引用，听说飞arc下不会
        
        
//        MPerson.pName=@"blockMPerson";
       
    };
    
    //即时变成了全局block，pp还是会回收，因为传值不影响生命周期。
    _GParamBlock=ParamBlock;
    
    pp=[Person new];
    pp.pName=@"param2";
    
    ParamBlock(pp);
    
     pp=nil;
    
    
    _GPerson=[Person new];
    _GPerson.pName=@"gperson";
    
    MPerson=[Person new];
    MPerson.pName=@"mperson";
    
    
    pp=[Person new];
      pp.pName=@"param3";
    
    [_GPerson setGParamBlock:^(Person *p) {
         pp.pName=@"444";
        NSLog(@"person里的block---%@",pp.pName);
    }];
    
    _GPerson.GParamBlock(pp);
    
    
    _arry_blocks=[[NSMutableArray alloc] initWithCapacity:0];
//    [_arry_blocks addObject:sumBlock];
//    [_arry_blocks addObject:testBlock];
    [_arry_blocks addObject:^{}];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@",_arry_blocks);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)dealloc
{
    NSLog(@"vcdealloc");
}
@end
