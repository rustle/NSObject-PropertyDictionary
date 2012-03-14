//
//  ESDeclaredPropertyAttributes.m
//
//  Created by Doug Russell
//  Copyright (c) 2011 Doug Russell. All rights reserved.
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//  http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  

#import "ESDeclaredPropertyAttributes.h"

// References
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html3

@implementation ESDeclaredPropertyAttributes
@synthesize classString;
@synthesize name;
@synthesize storageType;
@synthesize getter;
@synthesize setter;
@synthesize storageMethod;
@synthesize readOnly;
@synthesize nonatomic;
@synthesize dynamic;

- (id)init
{
	self = [super init];
	if (self)
	{
		self.storageType = IDType;
		self.storageMethod = AssignStorage;
		self.setter = NULL;
		self.getter = NULL;
		self.readOnly = NO;
	}
	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"\n<%@ : %p> {\n\tClass: %@\n\tName: %@\n\tStorageType: %d\n\tStorageMethod: %d\n\tGetter: %@\n\tSetter: %@\n\tReadOnly: %@\n\tNonatomic: %@\n\tDynamic: %@\n}", 
			NSStringFromClass([self class]), 
			self, 
			self.classString, 
			self.name,
			self.storageType,
			self.storageMethod,
			NSStringFromSelector(self.getter),
			NSStringFromSelector(self.setter),
			self.readOnly ? @"YES" : @"NO",
			self.nonatomic ? @"YES" : @"NO",
			self.dynamic ? @"YES" : @"NO"];
}

@end
