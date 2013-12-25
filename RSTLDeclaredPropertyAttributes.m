//
//  RSTLDeclaredPropertyAttributes.m
//
//  Created by Doug Russell
//  Copyright (c) 2011, 2013 Doug Russell. All rights reserved.
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

#import "RSTLDeclaredPropertyAttributes.h"

// References
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html3

#define RSTLEnumValueCase(enum) case enum: value = @#enum; break;

NSString *RSTLStringForPropertyStorageMethod(RSTLPropertyStorageMethod method)
{
	NSString *value = nil;
	switch (method) 
	{
		RSTLEnumValueCase(RSTLPropertyAssignStorage);
		RSTLEnumValueCase(RSTLPropertyStrongStorage);
		RSTLEnumValueCase(RSTLPropertyCopyStorage);
		RSTLEnumValueCase(RSTLPropertyReadOnlyStorage);
	}
	return value;
}

NSString *RSTLStringForPropertyStorageType(RSTLPropertyStorageType type)
{
	NSString *value = nil;
	switch (type) 
	{
		RSTLEnumValueCase(RSTLPropertyIDType);
		RSTLEnumValueCase(RSTLPropertyObjectType);
		RSTLEnumValueCase(RSTLPropertyDoubleType);
		RSTLEnumValueCase(RSTLPropertyFloatType);
		RSTLEnumValueCase(RSTLPropertyLongType);
		RSTLEnumValueCase(RSTLPropertyUnsignedLongType);
		RSTLEnumValueCase(RSTLPRopertySelectorType);
		RSTLEnumValueCase(RSTLPropertyUnsupportedType);
#if __RSTL64iOS__
		RSTLEnumValueCase(RSTLPropertyCharType);
		case RSTLPropertyBoolType:
			value = @"RSTLPropertyBoolType/RSTLPropertyObjCBoolType";
			break;
#else
		RSTLEnumValueCase(RSTLPropertyBoolType);
		case RSTLPropertyCharType:
			value = @"RSTLPropertyCharType/RSTLPropertyObjCBoolType";
			break;
#endif
#if __RSTL64__
		RSTLEnumValueCase(RSTLPropertyIntType);
		RSTLEnumValueCase(RSTLPropertyUnsignedIntType);
		case RSTLPropertyLongLongType:
			value = @"RSTLPropertyLongLongType/RSTLPropertyNSIntegerType";
			break;
		case RSTLPropertyUnsignedLongLongType:
			value = @"RSTLPropertyUnsignedLongLongType/RSTLPropertyNSUIntegerType";
			break;
#else
		RSTLEnumValueCase(RSTLPropertyLongLongType);
		RSTLEnumValueCase(RSTLPropertyUnsignedLongLongType);
		case RSTLPropertyIntType:
			value = @"RSTLPropertyIntType/RSTLPropertyNSIntegerType";
			break;
		case RSTLPropertyUnsignedIntType:
			value = @"RSTLPropertyUnsignedIntType/RSTLPropertyNSUIntegerType";
			break;
#endif
	}
	return value;
}

@implementation RSTLDeclaredPropertyAttributes

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		_storageType = RSTLPropertyIDType;
		_storageMethod = RSTLPropertyAssignStorage;
	}
	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@ : %p> {\n\tClass: %@\n\tName: %@\n\tStorageType: %@\n\tStorageMethod: %@\n\tGetter: %@\n\tSetter: %@\n\tReadOnly: %@\n\tNonatomic: %@\n\tDynamic: %@\n}", 
			NSStringFromClass([self class]), 
			self, 
			self.className, 
			self.name,
			RSTLStringForPropertyStorageType(self.storageType),
			RSTLStringForPropertyStorageMethod(self.storageMethod),
			NSStringFromSelector(self.getter),
			NSStringFromSelector(self.setter),
			self.readOnly ? @"YES" : @"NO",
			self.nonatomic ? @"YES" : @"NO",
			self.dynamic ? @"YES" : @"NO"];
}

@end
