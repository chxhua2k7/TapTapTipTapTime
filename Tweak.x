#import "TapTapTipTapTime.h"

static NSDateFormatterStyle dateFormatterStyle() {

	if ([dateStyle isEqualToString:@"numeric"]) return NSDateFormatterShortStyle;
	if ([dateStyle isEqualToString:@"abbreviated"]) return NSDateFormatterMediumStyle;
	if ([dateStyle isEqualToString:@"long"]) return NSDateFormatterLongStyle;
	if ([dateStyle isEqualToString:@"complete"]) return NSDateFormatterFullStyle;
	return NSDateFormatterShortStyle;

}

static NSString *dateStringFactory() {

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	if (dateShowing) {
		if ([dateStyle isEqualToString:@"custom"]) {
			NSMutableString *format = [NSMutableString stringWithString:[customFormat length] > 0 ? customFormat : @"M/d/y"];
			// D (day of year) and Y (week year) are almost never what the user means
			[format replaceOccurrencesOfString:@"D" withString:@"d" options:NSLiteralSearch range:NSMakeRange(0, [format length])];
			[format replaceOccurrencesOfString:@"Y" withString:@"y" options:NSLiteralSearch range:NSMakeRange(0, [format length])];
			[formatter setDateFormat:format];
		} else {
			[formatter setDateStyle:dateFormatterStyle()];
			[formatter setTimeStyle:NSDateFormatterNoStyle];
		}
	} else {
		if (systemTime) {
			[formatter setDateStyle:NSDateFormatterNoStyle];
			[formatter setTimeStyle:NSDateFormatterShortStyle];
		} else {
			NSMutableString *format = [NSMutableString stringWithString:@""];
			twentyFourHourTime ? [format appendString:@"H:mm"] : [format appendString:@"h:mm"];
			if (showAMPM) [format appendString:@" a"];
			[formatter setDateFormat:format];
		}
	}
	return [formatter stringFromDate:[NSDate date]];

}

@implementation DimitarStatusBarTimeStringView

- (void)didMoveToWindow {

	[super didMoveToWindow];

	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTapTipTapTimeGestureRecognizerDidFire)];
	[self setUserInteractionEnabled:YES];
	[self addGestureRecognizer:tapGestureRecognizer];

}

- (void)setText:(NSString *)text {

	[super setText:dateStringFactory()];

}

- (void)tapTapTipTapTimeGestureRecognizerDidFire {

	dateShowing = !dateShowing; // Toggle
	NSUserDefaults *preferences = [[NSUserDefaults alloc] initWithSuiteName:preferencesDomain];
	[preferences setObject:[NSNumber numberWithBool:dateShowing] forKey:@"_dateShowing"];

	NSDictionary *userInfo = @{ @"dateShowing": [NSNumber numberWithBool:dateShowing] };
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:userInfo];

	if (autoResetEnabled) {
		
		NSInteger backToTimeDelay = 10;

		if (dateShowing) {
			timer = [NSTimer scheduledTimerWithTimeInterval:backToTimeDelay target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
		} else {
			[timer invalidate];
		}
	}
}

- (void)timerFired:(NSTimer *)arg1 {

	dateShowing = NO;
	NSUserDefaults *preferences = [[NSUserDefaults alloc] initWithSuiteName:preferencesDomain];
	[preferences setObject:@(dateShowing) forKey:@"_dateShowing"];

	NSDictionary *userInfo = @{ @"dateShowing": @(dateShowing) };
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:userInfo];
}

@end

%hook _UIStatusBarTimeItem

- (void)_create_timeView {

	%orig;

	_UIStatusBarStringView *view = [self timeView];
	object_setClass(view, [DimitarStatusBarTimeStringView class]);
	[view setText:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleChangeDateShowing:) name:notificationName object:nil];

}

- (void)_create_shortTimeView {

	%orig;

	_UIStatusBarStringView *view = [self shortTimeView];
	object_setClass(view, [DimitarStatusBarTimeStringView class]);
	[view setText:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleChangeDateShowing:) name:notificationName object:nil];

}

%new
- (void)handleChangeDateShowing:(NSNotification *)notification {

	dateShowing = [[[notification userInfo] valueForKey:@"dateShowing"] boolValue];
	[[self timeView] setText:nil];
	[[self shortTimeView] setText:nil];

}

%end

static void loadPrefs() {

	NSUserDefaults *preferences = [[NSUserDefaults alloc] initWithSuiteName:preferencesDomain];

	enabled = [preferences objectForKey:@"enabled"] ? [[preferences objectForKey:@"enabled"] boolValue] : YES; // Default: Enabled

	systemTime = [preferences objectForKey:@"systemTime"] ? [[preferences objectForKey:@"systemTime"] boolValue] : YES; // Default: Follow system time format
	showAMPM = [preferences objectForKey:@"showAMPM"] ? [[preferences objectForKey:@"showAMPM"] boolValue] : YES;
	twentyFourHourTime = [preferences objectForKey:@"twentyFourHourTime"] ? [[preferences objectForKey:@"twentyFourHourTime"] boolValue] : NO;

	dateStyle = [preferences objectForKey:@"dateStyle"] ? [preferences objectForKey:@"dateStyle"] : @"custom";
	separator = [preferences objectForKey:@"separator"] ? [preferences objectForKey:@"separator"] : @"/";
	showYear = [preferences objectForKey:@"showYear"] ? [[preferences objectForKey:@"showYear"] boolValue] : YES;
	dayBeforeMonth = [preferences objectForKey:@"dayBeforeMonth"] ? [[preferences objectForKey:@"dayBeforeMonth"] boolValue] : NO;

	if ([preferences objectForKey:@"customFormat"]) {
		customFormat = [preferences objectForKey:@"customFormat"];
	} else {
		// Migrate from the legacy showYear/dayBeforeMonth/separator options
		NSMutableString *format = [NSMutableString stringWithString:dayBeforeMonth ? @"d M" : @"M d"];
		if (showYear) [format appendString:@" y"];
		[format replaceOccurrencesOfString:@" " withString:separator options:NSLiteralSearch range:NSMakeRange(0, [format length])];
		customFormat = format;
	}

	autoResetEnabled = [preferences objectForKey:@"autoResetEnabled"] ? [[preferences objectForKey:@"autoResetEnabled"] boolValue] : NO;

	NSDictionary *userInfo = @{ @"dateShowing": [NSNumber numberWithBool:dateShowing] };
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:userInfo];

}

%ctor {

	loadPrefs(); // Load preferences into variables
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.yulkytulky.taptaptiptaptime/saved"), NULL, CFNotificationSuspensionBehaviorCoalesce); // Listen for preference changes

	NSUserDefaults *preferences = [[NSUserDefaults alloc] initWithSuiteName:preferencesDomain];
	dateShowing = [preferences objectForKey:@"_dateShowing"] ? [[preferences objectForKey:@"_dateShowing"] boolValue] : NO;

	if (enabled) {
		%init;
	}

}
