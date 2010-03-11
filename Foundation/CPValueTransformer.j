/*
 * CPKeyValueBinding.j
 * Foundation
 *
 * Created by Ross Boucher 2/15/09
 * Copyright 280 North, Inc.
 *
 * Adapted from GNUStep
 * Released under the LGPL.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

@import <Foundation/CPObject.j>
@import <Foundation/CPDictionary.j>


var transformerMap;


@implementation CPValueTransformer : CPObject
{

}

+ (void)initialize
{
    transformerMap = [CPDictionary dictionaryWithJSObject:{
        CPNegateBooleanTransformerName: [CPNegateBooleanTransformer new],
        CPIsNilTransformerName: [CPIsNilTransformer new],
        CPIsNotNilTransformerName: [CPIsNotNilTransformer new],
        CPUnarchiveFromDataTransformerName: [CPUnarchiveFromDataTransformer new],
    }];
}

+ (void)setValueTransformer:(CPValueTransformer)transformer forName:(CPString)name
{
    [transformerMap setObject:transformer forKey:name];
}

+ (CPValueTransformer)valueTransformerForName:(CPString)name
{
    return [transformerMap objectForKey:name];
}

+ (CPArray)valueTransformerNames
{
    return [transformerMap allKeys];
}

+ (BOOL)allowsReverseTransformation
{
  return NO;
}

+ (Class)transformedValueClass
{
    return [CPObject class];
}

- (id)reverseTransformedValue:(id)value
{
    if ([[self class] allowsReverseTransformation])
    {
        [CPException raise:CPInvalidArgumentException reason:(self+" is not reversible.")];
    }

    return [self transformedValue:value];
}

- (id)transformedValue:(id)value
{
    return nil;
}

@end

// builtin transformers

@implementation CPNegateBooleanTransformer : CPObject

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

+ (Class)transformedValueClass
{
    return [CPNumber class];
}

- (id)reverseTransformedValue:(id)value
{
    return ![value boolValue];
}

- (id)transformedValue:(id)value
{
    return ![value boolValue];
}

@end

@implementation CPIsNilTransformer : CPObject

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

+ (Class)transformedValueClass
{
    return [CPNumber class];
}

- (id)transformedValue:(id)value
{
    return value === nil || value === undefined;
}

@end

@implementation CPIsNotNilTransformer : CPObject

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

+ (Class)transformedValueClass
{
    return [CPNumber class];
}

- (id)transformedValue:(id)value
{
    return value !== nil && value !== undefined;
}

@end

@implementation CPUnarchiveFromDataTransformer : CPObject

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

+ (Class)transformedValueClass
{
    return [CPData class];
}

- (id)reverseTransformedValue:(id)value
{
    return [CPKeyedArchiver archivedDataWithRootObject:value];
}

- (id)transformedValue:(id)value
{
    return [CPKeyedUnarchiver unarchiveObjectWithData:value];
}

@end

CPNegateBooleanTransformerName  = @"CPNegateBooleanTransformerName";
CPIsNilTransformerName          = @"CPIsNilTransformerName";
CPIsNotNilTransformerName       = @"CPIsNotNilTransformerName";
CPUnarchiveFromDataTransformerName = @"CPUnarchiveFromDataTransformerName";
