#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <rootless.h>

@interface NSTask : NSObject
@property (copy) NSString *launchPath;
@property (copy) NSArray<NSString *> *arguments;
- (void)launch;
@end

@interface TTTRootListController: PSListController
@property (nonatomic, retain) UIBarButtonItem *respringApplyButton;
@property (nonatomic, retain) UIBarButtonItem *respringConfirmButton;
@end