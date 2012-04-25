//
//  ESDeclaredPropertyFunctions.m
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

#import "ESDeclaredPropertyFunctions.h"
#import <objc/runtime.h>
#import "ESMutableDictionary.h"

// References
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html3
// http://stackoverflow.com/questions/754824/get-an-object-attributes-list-in-objective-c

ESDeclaredPropertyAttributes * CreatePropertyAttributes(objc_property_t property);
NSString * CreateStringFromCharSubString(char * string, NSRange range);

// Cache the properties dictionaries that have already been resolved
// TODO: test the cost of locking to protect this cache vs just recalculating the properties every time
static ESMutableDictionary *_propertyDictionaryCache;

NSDictionary * GetPropertyDictionary(Class objectClass, BOOL includeSuperclassProperties)
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_propertyDictionaryCache = [ESMutableDictionary new];
	});
	if (objectClass == nil)
		return nil;
	NSMutableDictionary *propertyDictionary = [_propertyDictionaryCache objectForKey:objectClass];
	if (propertyDictionary != nil)
		return propertyDictionary;
	propertyDictionary = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(objectClass, &outCount);
    for (i = 0; i < outCount; i++) 
	{
        objc_property_t property = properties[i];
        ESDeclaredPropertyAttributes *attributes = CreatePropertyAttributes(property);
		if (attributes && attributes.name) // redundant check
			[propertyDictionary setObject:attributes forKey:attributes.name];
    }
    free(properties);
	if (includeSuperclassProperties)
	{
		Class superclass = objectClass;
		while ((superclass = class_getSuperclass(superclass)))
		{
			NSDictionary *superPropertyDictionary = GetPropertyDictionary(superclass, NO);
			if (superPropertyDictionary)
			{
				[propertyDictionary addEntriesFromDictionary:superPropertyDictionary];
			}
		}
	}
	[_propertyDictionaryCache setObject:propertyDictionary forKey:objectClass];
	return propertyDictionary;
}

ESDeclaredPropertyAttributes * CreatePropertyAttributes(objc_property_t property) 
{
	// 
	ESDeclaredPropertyAttributes *propertyAttributes = [ESDeclaredPropertyAttributes new];
	// 
	const char *propName = property_getName(property);
	if (!propName)
		return nil;
	propertyAttributes.name = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
	// 
	const char *attributes = property_getAttributes(property);
	char buffer[1 + strlen(attributes)];
	strcpy(buffer, attributes);
	char *state = buffer, *attribute;
	while ((attribute = strsep(&state, ",")) != NULL) 
	{
		switch (attribute[0]) {
			case 'T': // Type
			{
				PropertyStorageType storageType;
				// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
				switch (attribute[1]) {
					case '@':
					{
						size_t len = strlen(attribute);
						if (len > 4) // Make sure we actually have type information (an id will be T@, any NSObject or subclass will be T@"CLASSNAME"
						{
							storageType = ObjectType;
							propertyAttributes.classString = CreateStringFromCharSubString(attribute, NSMakeRange(3, strlen(attribute) - 4));
						}
						else
							storageType = IDType;
						break;
					}
					case 'c':
						storageType = BoolType;
						break;
					case 'd':
						storageType = DoubleType;
						break;
					case 'f':
						storageType = FloatType;
						break;
					case 'i':
						storageType = IntType;
						break;
					default:
						storageType = UnsupportedType;
						break;
				}
				propertyAttributes.storageType = storageType;
				break;
			}
			case 'R':
				propertyAttributes.readOnly = YES;
				propertyAttributes.storageMethod = ReadOnlyStorage;
				break;
			case 'C':
				propertyAttributes.storageMethod = CopyStorage;
				break;
			case '&':
				propertyAttributes.storageMethod = StrongStorage;
				break;
			case 'N':
				propertyAttributes.nonatomic = YES;
				break;
			case 'G': // custom getter
				propertyAttributes.getter = NSSelectorFromString(CreateStringFromCharSubString(attribute, NSMakeRange(1, strlen(attribute) - 1)));
				break;
			case 'S': // custom setter
				propertyAttributes.setter = NSSelectorFromString(CreateStringFromCharSubString(attribute, NSMakeRange(1, strlen(attribute) - 1)));
				break;
			case 'D':
				propertyAttributes.dynamic = YES;
				break;
			default:
				break;
		}
	}
	if (propertyAttributes.getter == NULL)
	{
		propertyAttributes.getter = NSSelectorFromString(propertyAttributes.name);
	}
	if (propertyAttributes.setter == NULL && propertyAttributes.readOnly == NO) // might be faster to do this by manipulating propName
	{
		NSString *firstLetter = [[propertyAttributes.name substringToIndex:1] uppercaseString];
		NSString *restOfName = [propertyAttributes.name substringFromIndex:1];
		NSString *setterString = [NSString stringWithFormat:@"set%@%@:", firstLetter, restOfName];
		propertyAttributes.setter = NSSelectorFromString(setterString);
	}
	return propertyAttributes;
}

NSString * CreateStringFromCharSubString(char * string, NSRange range) // Quick and dirty char to nsstring
{
	char *substring = (char *)malloc(range.length+1);
	strncpy(substring, string + range.location, range.length); // http://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/man3/strncpy.3.html
	substring[range.length] = '\0'; // We're passing in chopped up bits of strings so they won't be null terminated
	if (substring != NULL)
	{
		NSString *newString = [[NSString alloc] initWithCString:substring encoding:NSUTF8StringEncoding];
		free(substring);
		return newString;
	}
	else
		return nil;
}