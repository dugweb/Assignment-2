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


-(void) pushOperand:(double)operand 
{
	[self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

-(void) pushVariable:(NSString *)variable {
	[self.programStack addObject:variable];
}

-(double) performOperation:(NSString *)operation 
{	
	[self.programStack addObject:operation];
	
	return [CalculatorBrain runProgram:self.program
				   usingVariableValues:Nil];	
}
-(void) pushOperation:(NSString *) operation {
	[self.programStack addObject:operation];
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

+ (BOOL)isOperation:(NSString *)operation {
	// Set of operations, NSSet is an unordered set of objects. This is quicker than using an NSArray (apparently).
	NSSet * operationSet = [NSSet setWithObjects: @"+", @"-", @"*", @"/", @"sin",	@"cos", @"sqrt", @"?", @"±", nil];
	
	return [operationSet containsObject:operation];
}

+ (NSSet *) variablesUsedInProgram:(id)program {
	
	// Make sure the argument (program) is an array
	if (![program isKindOfClass:[NSArray class]]) {
		return nil;
	}
	
	NSMutableSet *variables = [NSMutableSet set];
	
	
	for (id obj in program) {
		// if it's a variable add it to the 'variables' set
		
		if ([obj isKindOfClass:[NSString class]] && ![self isOperation:obj]) {
			[variables addObject:obj];
		}
	}	
	
	if ([variables count] == 0) return nil; else return [variables copy];
	
}

+ (double)runProgram:(id)program
 usingVariableValues:(NSDictionary *)variableValues {
		
	// Make sure it's an NSArray
	if (![program isKindOfClass:[NSArray class]]) {
		return 0;
	}
	
	NSMutableArray *stack = [program mutableCopy];
	
	for (int i = 0; i < [stack count]; i++) {
		id obj = [stack objectAtIndex:i];
		
		// Check if it's a string and variable
		if ([obj isKindOfClass:[NSString class]] && ![self isOperation:obj]) {
			
			id value = [variableValues objectForKey:obj];
			
			// If it's not a number type, then set it to 0
			if (![value isKindOfClass:[NSNumber class]]) {
				value = [NSNumber numberWithInt:0];
			}
			
			// Replace the variable with the number
			[stack replaceObjectAtIndex:i withObject:value];
		}
	}
	return [self popOperandOffStack:stack];
}

-(void)clearStack {
	self.programStack = Nil;
}

@end