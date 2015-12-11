//
//  Student.h
//  XMix
//
//  Created by davidli on 15/12/10.
//  Copyright © 2015年 X. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface Student : Person<NSCoding,NSCopying>
{
    NSInteger _studentNumber;
}
@property (nonatomic, copy) NSString *_className;
@property (nonatomic) NSInteger classNumber;
@property (nonatomic) BOOL niceClass;

@end
