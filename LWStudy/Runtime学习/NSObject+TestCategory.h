//
//  NSObject+TestCategory.h
//  LWStudy
//
//  Created by liwanlu on 2020/9/29.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (TestCategory)
@property(nonatomic,strong) NSString *testName;//事实证明。可以声明属性，但是系统不会去实现get，set方法，也不会自动生成_testName属性，所以声明是无效的。外部访问的话会报错：没有对应的方法。如果内部去实现get，set方法，有因为没有_testName属性无法实现。当然，非要实现也有办法，实现get，set方法，用runtime添加关联。
@end

NS_ASSUME_NONNULL_END
