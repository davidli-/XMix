//
//  Person.h
//  XMix
//
//  Created by davidli on 15/12/10.
//  Copyright © 2015年 X. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
{
    NSString *work;
}
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *hobby;

@property (nonatomic) NSInteger sex;
@property (nonatomic) NSInteger age;

@property (nonatomic) BOOL married;

@end
