//
//  CalculatorViewController.m
//  Calculator
//
//  Created by peteshumway on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;


@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize brain = _brain;

@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;

- (CalculatorBrain *)brain {
	if (!_brain) _brain = [[CalculatorBrain alloc] init];
	return _brain;
}

- (IBAction)digitPressed:(UIButton*)sender
{
	NSString *digit = sender.currentTitle;
	// Check if a '.' is entered so that we can control if it's a valid floating point number.
	NSRange decimalRange = [self.display.text rangeOfString:@"."];
	
	
	if (self.userIsInTheMiddleOfEnteringANumber) {
		if ([sender.currentTitle isEqualToString:@"."]) {
			if (decimalRange.location == NSNotFound) {
				self.display.text = [self.display.text stringByAppendingString:digit];
			}
		} else {
			self.display.text = [self.display.text stringByAppendingString:digit];
		}
	} else {
		
		if ([sender.currentTitle isEqualToString:@"."]) {
			self.display.text = @"0.";
		} else {
			self.display.text = digit;
		}
		self.userIsInTheMiddleOfEnteringANumber = YES;
	}
}

- (IBAction)operationPressed:(UIButton *)sender 
{
	NSLog(@"operation cur title: %@", sender.currentTitle);
	if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
	double result = [self.brain performOperation:sender.currentTitle];
	NSString *resultString = [NSString stringWithFormat:@"%g", result];
	self.display.text = resultString;
	self.history.text = [self.history.text stringByAppendingFormat:@"%@ = ", sender
						 .currentTitle];
}

- (IBAction)enterPressed 
{
	
	[self.brain pushOperand:[self.display.text doubleValue]];
	self.history.text = [self.history.text stringByAppendingFormat:@"%@ ", self.display.text];
	self.userIsInTheMiddleOfEnteringANumber = NO;

}
- (IBAction)clearPressed {
	[self.brain clearStack];
	self.display.text = @"0";
	self.history.text = @"";
	self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)deletePressed {
	if ([self.display.text length] > 1) {
		self.display.text = [self.display.text substringToIndex:([self.display.text length] -1)];
	} else {
		self.display.text = @"0";
		self.userIsInTheMiddleOfEnteringANumber = NO;
	}
}

- (IBAction)plusMinusPressed:(UIButton *) sender {
	NSLog(@"sender current title: %g", sender.currentTitle);
	if (self.userIsInTheMiddleOfEnteringANumber) {
		double result = [self.display.text doubleValue] * -1;
		self.display.text = [NSString stringWithFormat:@"%g", result];
	} else {
		[self operationPressed:sender];
	}
}


- (void)viewDidUnload {
	[self setHistory:nil];
	[super viewDidUnload];
}
@end
