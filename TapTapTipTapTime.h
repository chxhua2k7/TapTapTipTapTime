#import <UIKit/UIKit.h>
#import <objc/runtime.h>

//--Preferences Variables--//
BOOL enabled;

BOOL systemTime;
BOOL showAMPM;
BOOL twentyFourHourTime;

NSString *dateStyle;
NSString *customFormat;
NSString *separator;
BOOL showYear; // Legacy, used to migrate to customFormat
BOOL dayBeforeMonth; // Legacy, used to migrate to customFormat

BOOL autoResetEnabled;

//--Globally Accessible Variables--//
static BOOL dateShowing;
static NSString *preferencesDomain = @"com.yulkytulky.taptaptiptaptime";
static NSString *notificationName = @"com.yulkytulky.taptaptiptaptime/changedateshowing";
static NSTimer *timer;

//--Interface Declarations--//
@interface _UIStatusBarStringView: UILabel
@end

@interface _UIStatusBarTimeItem
@property (nonatomic, strong, readwrite) _UIStatusBarStringView *timeView;
@property (nonatomic, strong, readwrite) _UIStatusBarStringView *shortTimeView;
@property (nonatomic, strong, readwrite) _UIStatusBarStringView *pillTimeView;
@property (nonatomic, strong, readwrite) _UIStatusBarStringView *dateView;
@end

@interface DimitarStatusBarTimeStringView : _UIStatusBarStringView
@end
