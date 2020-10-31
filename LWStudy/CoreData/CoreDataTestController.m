//
//  CoreDataTestController.m
//  LWStudy
//
//  Created by liwanlu on 2020/10/30.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import "CoreDataTestController.h"
//#import "CDTestModel+CoreDataModel.h"
#import "CDPerson+CoreDataClass.h"

@interface CoreDataTestController ()
@property(nonatomic,strong) NSManagedObjectContext *context;
@end

@implementation CoreDataTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createSqlite];
    
    // 1.根据Entity名称和NSManagedObjectContext获取一个新的继承于NSManagedObject的子类Student
      CDPerson * student = [NSEntityDescription  insertNewObjectForEntityForName:@"CDPerson"  inManagedObjectContext:_context];

      //2.根据表Student中的键值，给NSManagedObject对象赋值
    student.name =@"卢帅哥";
    student.age =30;
    student.sex=@"男";

      //   3.保存插入的数据
      NSError *error = nil;
      if ([_context save:&error]) {
          NSLog(@"插入成功");
      }else{
           NSLog(@"插入失败");
      }


    [self updateData];
    
    [self readData];

}
//创建数据库
- (void)createSqlite{

    //1、创建模型对象
    //获取模型路径
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CDTestModel" withExtension:@"momd"];
    //根据模型文件创建模型对象
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    //2、创建持久化存储助理：数据库
    //利用模型对象创建助理对象
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    

    

    //数据库的名称和路径
    NSString *docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlPath = [docStr stringByAppendingPathComponent:@"coreData.sqlite"];
    NSLog(@"数据库 path = %@", sqlPath);
    NSURL *sqlUrl = [NSURL fileURLWithPath:sqlPath];

    NSError *error = nil;
    //设置数据库相关信息 添加一个持久化存储库并设置类型和路径，NSSQLiteStoreType：SQLite作为存储库
    
    //如果更新了表结构，需要传options，会自动更新，否则报错。
//    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlUrl options:nil error:&error];
    
    
    //请求自动轻量级迁移，即数据库升级
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             nil];
    
    
     //设置数据库相关信息 添加一个持久化存储库并设置存储类型和路径，NSSQLiteStoreType：SQLite作为存储库
     [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlUrl options:options error:&error];
    
    
    

    if (error) {
        NSLog(@"添加数据库失败:%@",error);
    } else {
        NSLog(@"添加数据库成功");
    }

    //3、创建上下文 保存信息 对数据库进行操作
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];

    //关联持久化助理
    context.persistentStoreCoordinator = store;
    _context = context;

}

- (void)deleteData{
   
    //创建删除请求
    NSFetchRequest *deleRequest = [NSFetchRequest fetchRequestWithEntityName:@"CDPerson"];
    
    //删除条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"age < %d", 50];
    deleRequest.predicate = pre;
   
    //返回需要删除的对象数组
    NSArray *deleArray = [_context executeFetchRequest:deleRequest error:nil];
    
    //从数据库中删除
    for (CDPerson *stu in deleArray) {
        [_context deleteObject:stu];
    }
   
    NSError *error = nil;
    //保存--记住保存
    if ([_context save:&error]) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}

//更新，修改
- (void)updateData{
    
    //创建查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CDPerson"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name = %@", @"卢大哥"];
    request.predicate = pre;
    
    //发送请求
    NSArray *resArray = [_context executeFetchRequest:request error:nil];
    
    //修改
    for (CDPerson *stu in resArray) {
        stu.name = @"且行且珍惜_iOS";
    }
  
    //保存
    NSError *error = nil;
    if ([_context save:&error]) {
        NSLog(@"修改成功");
    }else{
          NSLog(@"修改失败");
    }
}


//读取查询
- (void)readData{
    
    /* 谓词的条件指令
     1.比较运算符 > 、< 、== 、>= 、<= 、!=
     例：@"number >= 99"
     
     2.范围运算符：IN 、BETWEEN
     例：@"number BETWEEN {1,5}"
     @"address IN {'shanghai','nanjing'}"
     
     3.字符串本身:SELF
     例：@"SELF == 'APPLE'"
     
     4.字符串相关：BEGINSWITH、ENDSWITH、CONTAINS
     例：  @"name CONTAIN[cd] 'ang'"  //包含某个字符串
     @"name BEGINSWITH[c] 'sh'"    //以某个字符串开头
     @"name ENDSWITH[d] 'ang'"    //以某个字符串结束
     
     5.通配符：LIKE
     例：@"name LIKE[cd] '*er*'"   //*代表通配符,Like也接受[cd].
     @"name LIKE[cd] '???er*'"
     
     *注*: 星号 "*" : 代表0个或多个字符
     问号 "?" : 代表一个字符
     
     6.正则表达式：MATCHES
     例：NSString *regex = @"^A.+e$"; //以A开头，e结尾
     @"name MATCHES %@",regex
     
     注:[c]*不区分大小写 , [d]不区分发音符号即没有重音符号, [cd]既不区分大小写，也不区分发音符号。
     
     7. 合计操作
     ANY，SOME：指定下列表达式中的任意元素。比如，ANY children.age < 18。
     ALL：指定下列表达式中的所有元素。比如，ALL children.age < 18。
     NONE：指定下列表达式中没有的元素。比如，NONE children.age < 18。它在逻辑上等于NOT (ANY ...)。
     IN：等于SQL的IN操作，左边的表达必须出现在右边指定的集合中。比如，name IN { 'Ben', 'Melissa', 'Nick' }。
     
     提示:
     1. 谓词中的匹配指令关键字通常使用大写字母
     2. 谓词中可以使用格式字符串
     3. 如果通过对象的key
     path指定匹配条件，需要使用%K
     
     */
    
    //创建查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CDPerson"];
    //查询条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"age > %d", 10];
    request.predicate = pre;
 
    // 从第几页开始显示
    // 通过这个属性实现分页
    //request.fetchOffset = 0;
    // 每页显示多少条数据
    //request.fetchLimit = 6;

    //发送查询请求
    NSArray *resArray = [_context executeFetchRequest:request error:nil];
    
    NSLog(@"所有的数据：%@",resArray);
}

//排序
- (void)sort{
    //创建排序请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CDPerson"];
    //实例化排序对象
    NSSortDescriptor *ageSort = [NSSortDescriptor sortDescriptorWithKey:@"age"ascending:YES];
    NSSortDescriptor *numberSort = [NSSortDescriptor sortDescriptorWithKey:@"number"ascending:YES];
    request.sortDescriptors = @[ageSort,numberSort];
    //发送请求
    NSError *error = nil;
    NSArray *resArray = [_context executeFetchRequest:request error:&error];
    if (error == nil) {
        NSLog(@"排序后的:%@",resArray);
    }else{
        NSLog(@"排序失败, %@", error);
    }
}



@end
