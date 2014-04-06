// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Activity.m instead.

#import "_Activity.h"

const struct ActivityAttributes ActivityAttributes = {
	.crm_activitytype = @"crm_activitytype",
	.crm_assigned_user_id = @"crm_assigned_user_id",
	.crm_assigned_user_name = @"crm_assigned_user_name",
	.crm_contact_id = @"crm_contact_id",
	.crm_contact_name = @"crm_contact_name",
	.crm_date_start = @"crm_date_start",
	.crm_description = @"crm_description",
	.crm_due_date = @"crm_due_date",
	.crm_duration_hours = @"crm_duration_hours",
	.crm_duration_minutes = @"crm_duration_minutes",
	.crm_eventstatus = @"crm_eventstatus",
	.crm_id = @"crm_id",
	.crm_location = @"crm_location",
	.crm_notime = @"crm_notime",
	.crm_parent_id = @"crm_parent_id",
	.crm_parent_name = @"crm_parent_name",
	.crm_parent_type = @"crm_parent_type",
	.crm_priority = @"crm_priority",
	.crm_recurringtype = @"crm_recurringtype",
	.crm_sendnotification = @"crm_sendnotification",
	.crm_subject = @"crm_subject",
	.crm_time_created = @"crm_time_created",
	.crm_time_end = @"crm_time_end",
	.crm_time_modified = @"crm_time_modified",
	.crm_time_start = @"crm_time_start",
	.crm_visibility = @"crm_visibility",
	.my_custom_fields = @"my_custom_fields",
	.my_datetime_end = @"my_datetime_end",
	.my_datetime_start = @"my_datetime_start",
	.my_deleted = @"my_deleted",
};

const struct ActivityRelationships ActivityRelationships = {
	.service = @"service",
};

const struct ActivityFetchedProperties ActivityFetchedProperties = {
	.activity_relatedlead = @"activity_relatedlead",
};

@implementation ActivityID
@end

@implementation _Activity

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Activity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:moc_];
}

- (ActivityID*)objectID {
	return (ActivityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"crm_duration_hoursValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"crm_duration_hours"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"crm_duration_minutesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"crm_duration_minutes"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"my_deletedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"my_deleted"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic crm_activitytype;






@dynamic crm_assigned_user_id;






@dynamic crm_assigned_user_name;






@dynamic crm_contact_id;






@dynamic crm_contact_name;






@dynamic crm_date_start;






@dynamic crm_description;






@dynamic crm_due_date;






@dynamic crm_duration_hours;



- (int16_t)crm_duration_hoursValue {
	NSNumber *result = [self crm_duration_hours];
	return [result shortValue];
}

- (void)setCrm_duration_hoursValue:(int16_t)value_ {
	[self setCrm_duration_hours:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveCrm_duration_hoursValue {
	NSNumber *result = [self primitiveCrm_duration_hours];
	return [result shortValue];
}

- (void)setPrimitiveCrm_duration_hoursValue:(int16_t)value_ {
	[self setPrimitiveCrm_duration_hours:[NSNumber numberWithShort:value_]];
}





@dynamic crm_duration_minutes;



- (int16_t)crm_duration_minutesValue {
	NSNumber *result = [self crm_duration_minutes];
	return [result shortValue];
}

- (void)setCrm_duration_minutesValue:(int16_t)value_ {
	[self setCrm_duration_minutes:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveCrm_duration_minutesValue {
	NSNumber *result = [self primitiveCrm_duration_minutes];
	return [result shortValue];
}

- (void)setPrimitiveCrm_duration_minutesValue:(int16_t)value_ {
	[self setPrimitiveCrm_duration_minutes:[NSNumber numberWithShort:value_]];
}





@dynamic crm_eventstatus;






@dynamic crm_id;






@dynamic crm_location;






@dynamic crm_notime;






@dynamic crm_parent_id;






@dynamic crm_parent_name;






@dynamic crm_parent_type;






@dynamic crm_priority;






@dynamic crm_recurringtype;






@dynamic crm_sendnotification;






@dynamic crm_subject;






@dynamic crm_time_created;






@dynamic crm_time_end;






@dynamic crm_time_modified;






@dynamic crm_time_start;






@dynamic crm_visibility;






@dynamic my_custom_fields;






@dynamic my_datetime_end;






@dynamic my_datetime_start;






@dynamic my_deleted;



- (BOOL)my_deletedValue {
	NSNumber *result = [self my_deleted];
	return [result boolValue];
}

- (void)setMy_deletedValue:(BOOL)value_ {
	[self setMy_deleted:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveMy_deletedValue {
	NSNumber *result = [self primitiveMy_deleted];
	return [result boolValue];
}

- (void)setPrimitiveMy_deletedValue:(BOOL)value_ {
	[self setPrimitiveMy_deleted:[NSNumber numberWithBool:value_]];
}





@dynamic service;

	



@dynamic activity_relatedlead;




@end
