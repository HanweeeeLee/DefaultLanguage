//
//  AboutWC.h
//  DefaultLanguage
//
//  Created by hanwe on 16/02/2019.
//  Copyright © 2019 hanwe. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface AboutWC : NSWindowController
{
    id _parentsObj;
    
    IBOutlet NSImageView *_imgView;
    IBOutlet NSTextField *_versionLabel;
    __weak IBOutlet NSTextField *_copyrightLabel;
    
}
-(id)initWithWindowNibName:(NSNibName)windowNibName withParentsObj:(id)parentsObj;

@end

NS_ASSUME_NONNULL_END
