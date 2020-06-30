//
//  UserCustomData.h
//  DefaultLanguage
//
//  Created by hanwe on 16/02/2019.
//  Copyright © 2019 hanwe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserCustomData : NSObject  <NSCoding>

@property (nonatomic) NSString *appName;
@property (nonatomic) NSString *localizedSourceName;
@property (nonatomic) NSString *sourceID;

@end

NS_ASSUME_NONNULL_END
