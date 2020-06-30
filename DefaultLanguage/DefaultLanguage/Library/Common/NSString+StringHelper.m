//
//  NSString+StringHelper.m
//  original_wiget_exchange_hanwe
//
//  Created by hanwe on 2018. 12. 11..
//  Copyright © 2018년 hanwe. All rights reserved.
//

#import "NSString+StringHelper.h"

@implementation NSString (StringHelper)

-(NSString *)localizable
{
    return NSLocalizedString(self, nil);
}

@end
