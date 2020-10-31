//
//  CDPerson+CoreDataProperties.h
//  LWStudy
//
//  Created by liwanlu on 2020/10/30.
//  Copyright © 2020 liwanlu. All rights reserved.
//
//

#import "CDPerson+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDPerson (CoreDataProperties)

+ (NSFetchRequest<CDPerson *> *)fetchRequest;

@property (nonatomic) int16_t age;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *sex;

@end

NS_ASSUME_NONNULL_END
