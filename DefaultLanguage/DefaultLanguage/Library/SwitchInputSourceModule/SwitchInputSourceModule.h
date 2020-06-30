//
//  SwitchInputSourceModule.h
//  testtest
//
//  Created by HanWe Lee on 15/02/2019.
//  Copyright © 2019 HanWe Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SwitchInputSourceModule : NSObject
{
    int _currentSelectedIndex;
    int _totalInputSourceCnt;
    NSArray *_allInputResourcesArr;
}

-(BOOL)switchNextInputSource;
-(BOOL)switchInputSource:(NSString *)sourceID;
-(NSMutableDictionary *)getAllInputSourcesList;

@end

NS_ASSUME_NONNULL_END
