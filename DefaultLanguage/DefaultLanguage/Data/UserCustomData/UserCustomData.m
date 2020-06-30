//
//  UserCustomData.m
//  DefaultLanguage
//
//  Created by hanwe on 16/02/2019.
//  Copyright © 2019 hanwe. All rights reserved.
//

#import "UserCustomData.h"

@implementation UserCustomData

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        [copy setLocalizedSourceName:self.localizedSourceName];
        [copy setAppName:self.appName];
        [copy setSourceID:self.sourceID];
    }
    
    return copy;
}
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_appName forKey:@"_appName"];
    [coder encodeObject:_localizedSourceName forKey:@"_localizedSourceName"];
    [coder encodeObject:_sourceID forKey:@"_sourceID"];
}

// Decode an object from an archive
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self!=NULL)
    {
        _appName = [coder decodeObjectForKey:@"_appName"];
        _localizedSourceName = [coder decodeObjectForKey:@"_localizedSourceName"];
        _sourceID = [coder decodeObjectForKey:@"_sourceID"];
    }
    return self;
}

@end
