// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ProjectTask.m instead.

#import "_ProjectTask.h"

const struct ProjectTaskAttributes ProjectTaskAttributes = {
	.crm_assigned_user_id = @"crm_assigned_user_id",
	.crm_assigned_user_name = @"crm_assigned_user_name",
	.crm_date_end = @"crm_date_end",
	.crm_date_start = @"crm_date_start",
	.crm_description = @"crm_description",
	.crm_hours = @"crm_hours",
	.crm_id = @"crm_id",
	.crm_modified_by_id = @"crm_modified_by_id",
	.crm_modified_by_name = @"crm_modified_by_name",
	.crm_name = @"crm_name",
	.crm_priority = @"crm_priority",
	.crm_progress = @"crm_progress",
	.crm_related_project_id = @"crm_related_project_id",
	.crm_related_project_name = @"crm_related_project_name",
	.crm_status = @"crm_status",
	.crm_task_no = @"crm_task_no",
	.crm_task_number = @"crm_task_number",
	.crm_time_created = @"crm_time_created",
	.crm_time_modified = @"crm_time_modified",
	.crm_type = @"crm_type",
	.my_custom_fields = @"my_custom_fields",
	.my_timezone = @"my_timezone",
};

const struct ProjectTaskRelationships ProjectTaskRelationships = {
	.project = @"project",
};

@implementation ProjectTaskID
@end

@implementation _ProjectTask

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ProjectTask" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ProjectTask";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ProjectTask" inManagedObjectContext:moc_];
}

- (ProjectTaskID*)objectID {
	return (ProjectTaskID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic crm_assigned_user_id;

@dynamic crm_assigned_user_name;

@dynamic crm_date_end;

@dynamic crm_date_start;

@dynamic crm_description;

@dynamic crm_hours;

@dynamic crm_id;

@dynamic crm_modified_by_id;

@dynamic crm_modified_by_name;

@dynamic crm_name;

@dynamic crm_priority;

@dynamic crm_progress;

@dynamic crm_related_project_id;

@dynamic crm_related_project_name;

@dynamic crm_status;

@dynamic crm_task_no;

@dynamic crm_task_number;

@dynamic crm_time_created;

@dynamic crm_time_modified;

@dynamic crm_type;

@dynamic my_custom_fields;

@dynamic my_timezone;

@dynamic project;

@end

