#import "TTTEditTextCell.h"

// PSEditableTableCell only commits its value when the text field ends
// editing, which never fires if the user leaves the pane with the
// keyboard still up. Commit on every keystroke instead.
@implementation TTTEditTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {

	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	[[self textField] addTarget:self action:@selector(tttTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

	return self;

}

- (void)tttTextFieldDidChange:(UITextField *)textField {

	[[self specifier] performSetterWithValue:[textField text] ?: @""];

}

@end
