//
//  Person.h
//  LWStudy
//
//  Created by liwanlu on 2020/9/30.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
@property(nonatomic,strong) NSString *pName;
@property(nonatomic,assign) int pAge;
@property(nonatomic,strong) NSString *pSex;
-(int)eat:(NSString *)footName andWhere:(NSString *)where;
-(void)go:(NSString *)where;
-(void)showRunTimeInfo;

@property(nonatomic,copy) void(^GParamBlock)(Person *);
@end

NS_ASSUME_NONNULL_END
