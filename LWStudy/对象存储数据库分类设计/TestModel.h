//
//  TestModel.h
//  LWStudy
//
//  Created by liwanlu on 2020/10/13.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestModel : NSObject
@property(nonatomic,assign) NSInteger age;
@property(nonatomic,strong) NSString *personName;
@property(nonatomic,strong) NSString *schoolName;
@property(nonatomic,assign) BOOL isWorking;
@end

NS_ASSUME_NONNULL_END
