//
//  CalculatorBrain.m
//  Calculator
//
//  Created by peteshumway on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack {
	if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
		
	return _programStack;
}


-(void)pushOperand:(double)operand 
{
	[self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

-(void)pushVariable:(NSString *)variable {
	
}

-(double)performOperation:(NSString *)operation 
{	
	[self.programStack addObject:operation];
	return [CalculatorBrain runProgram:self.program];	
}

- (id)program 
{
	return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program {
	return @"Implement this in Assignement 2";
}

+ (double)popOperandOffStack:(NSMutableArray *)stack {
	double result = 0;
	
	id topOfStack = [stack lastObject];
	if (topOfStack) [stack removeLastObject];
	
	if ([topOfStack isKindOfClass:[NSNumber class]]) {
		result = [topOfStack doubleValue];
	} 
	else if ([topOfStack isKindOfClass:[NSString class]]) {
		
		NSString *operation = topOfStack;
		
		if ([@"+" isEqualToString:operation]) {
			result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
		} else if ([@"-" isEqualToString:operation]) {
			result = - [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
		} else if ([@"*" isEqualToString:operation]) {
			result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
		} else if ([@"/" isEqualToString:operation]) {
			double divisor = [self popOperandOffStack:stack];
			if (divisor != 0) {
				result = [self popOperandOffStack:stack] / divisor;
			} else {
				result = 0;
			}
		} else if ([@"sin" isEqualToString:operation]) {
			result = sin([self popOperandOffStack:stack]);
		} else if ([@"cos" isEqualToString:operation]) {
			result = cos([self popOperandOffStack:stack]);
		} else if ([@"sqrt" isEqualToString:operation]) {
			result = sqrt([self popOperandOffStack:stack]);
		} else if ([@"π" isEqualToString:operation]) {
			result = M_PI;
		} else if ([@"+/-" isEqualToString:operation]) {
			result = -[self popOperandOffStack:stack];
		} else if ([@"log" isEqualToString:operation]) {
			result = log([self popOperandOffStack:stack]);
		} else if ([@"e" isEqualToString:operation]) {
			result = M_E;
		} else {
			// Anything else should be considered a variable, I guess.
			
		}
	}
	return result;
}

+ (double)runProgram:(id)program {
	NSMutableArray *stack;
	if ([program isKindOfClass:[NSArray class]]) {
		stack = [program mutableCopy];
	}
	
	return [self popOperandOffStack:stack];
}

-(void)clearStack {
	self.programStack = Nil;
}

@end







