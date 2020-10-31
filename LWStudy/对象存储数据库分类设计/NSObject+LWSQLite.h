//
//  NSObject+LWSQLite.h
//  LWStudy
//
//  Created by liwanlu on 2020/10/13.
//  Copyright © 2020 liwanlu. All rights reserved.
//


/*
 1:save操作时才创建表(更新表)，为了避免所有类都创建一个表
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LWSQLite)
/**
 获取所有变量名
 */
+(void)lw_getAllProperty;
@end

NS_ASSUME_NONNULL_END
