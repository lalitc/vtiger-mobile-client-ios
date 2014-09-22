#import "ProjectTask.h"
#import "Project.h"
#import "CoreData+MagicalRecord.h"
#import "CRMFieldConstants.h"
#import "CRMConstants.h"
#import "GWPreferencesHelper.h"
#import "NSDate+GWUtilities.h"

@interface ProjectTask ()

// Private interface goes here.

@end

@implementation ProjectTask

+ (ProjectTask *)modelObjectWithDictionary:(NSDictionary *)dict
{
	//Extract custom fields
	NSMutableDictionary *cfields = [[NSMutableDictionary alloc] init];
	[dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		if ([key hasPrefix:@"cf_"]) {
			//it's a custom field
			[cfields setObject:@{key : obj} forKey:key];
		}
	}];
	return [ProjectTask modelObjectWithDictionary:dict customFields:cfields];
}

+ (ProjectTask *)modelObjectWithDictionary:(NSDictionary *)dict customFields:(NSDictionary*)cfields
{
	NSString *record_id = [dict objectForKey:kProjecttaskId];
	ProjectTask *instance;
	
	//I first try to count the entities (should take less time) and load the entity only if strictly necessary (if count > 0). The Count operation should be less intensive than the Fetch, so I use it for checking the existence
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"crm_id = %@", record_id];
	NSUInteger count = [ProjectTask MR_countOfEntitiesWithPredicate:predicate];
	
	if (count > 0) {
		instance = [ProjectTask MR_findFirstByAttribute:@"crm_id" withValue:record_id];
		NSDateFormatter *dateTimeFormat = [[NSDateFormatter alloc] init];
		[dateTimeFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
		NSDate *time_modified = [dateTimeFormat dateFromString:[dict objectForKey:kFieldModifiedTime]];
		if ([time_modified compare:instance.crm_time_created] == NSOrderedSame) {
#if DEBUG
			NSLog(@"%@ %@ skipping %@ as modified_time is the same", NSStringFromClass([self class]), NSStringFromSelector(_cmd), record_id);
#endif
			//It's the same instance
			return instance;
		}
	}
	else{
		instance = [ProjectTask MR_createEntity];
	}
	
	if (![instance updateModelObjectWithDictionary:dict customFields:cfields]) {
		return nil;
	}
	return instance;
}

- (BOOL)updateModelObjectWithDictionary:(NSDictionary*)dict customFields:(NSDictionary*)cfields
{
	// This check serves to make sure that a non-NSDictionary object
	// passed into the model class doesn't break the parsing.
	if([dict isKindOfClass:[NSDictionary class]]) {
		@try {
			//Setup the number formatter
			NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
			[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
			
			//Setup the date formatters
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
			[dateFormat setDateFormat:@"yyyy-MM-dd"];
			NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
			[timeFormat setDateFormat:@"HH:mm:ss"];
			
			//DateTime Created and Modified
			NSDateFormatter *dateTimeFormat = [[NSDateFormatter alloc] init];
			[dateTimeFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
			NSDate *time_modified = [dateTimeFormat dateFromString:[dict objectForKey:kFieldModifiedTime]];
			NSDate *time_created = [dateTimeFormat dateFromString:[dict objectForKey:kFieldCreatedTime]];
			self.crm_time_modified = time_modified;
			self.crm_time_created = time_created;
			
			//Format some variables
			NSDate *start_date = [dateFormat dateFromString:[dict objectForKey:kProjecttaskStartdate]];
			NSDate *end_date = [dateFormat dateFromString:[dict objectForKey:kProjecttaskEnddate]];
			
			//Properties defined by CRM
			
			self.crm_date_end = end_date;
			self.crm_date_start = start_date;
			self.crm_description = [dict objectForKey:kFieldDescription];
			self.crm_hours = [dict objectForKey:kProjecttaskHours];
			self.crm_id = [dict objectForKey:kProjecttaskId];
			self.crm_name = [dict objectForKey:kProjecttaskName];
			self.crm_priority = [dict objectForKey:kProjecttaskPriority];
			self.crm_progress = [dict objectForKey:kProjecttaskProgress];
			self.crm_status = [dict objectForKey:kProjecttaskStatus];
			self.crm_task_no = [dict objectForKey:kProjecttaskNo];
			self.crm_task_number = [dict objectForKey:kProjecttaskNumber];
			self.crm_type = [dict objectForKey:kProjecttaskType];
			
			
			//Properties defined by me
			NSCalendar *cal = [NSCalendar currentCalendar];
			NSDateComponents *comps = [[NSDateComponents alloc] init];
			NSDateComponents *start_date_comp = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.crm_date_start];
			NSDateComponents *end_date_comp = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.crm_date_end];
			NSDateComponents *start_time_comp;

			start_time_comp = [NSDateComponents alloc];
			[start_time_comp setHour:0];
			[start_time_comp setMinute:0];
			[start_time_comp setSecond:0];
			[comps setYear:[start_date_comp year]];
			[comps setMonth:[start_date_comp month]];
			[comps setDay:[start_date_comp day]];
			[comps setHour:[start_time_comp hour]];
			[comps setMinute:[start_time_comp minute]];
			
			self.my_datetime_start = [[cal dateFromComponents:comps] gw_convertToTimeZone:[Service getActive].crm_timezone_server];
			self.my_datetime_end = [cal dateFromComponents:end_date_comp];
			self.my_timezone = [Service getActive].crm_timezone_server;


			//Now that we have end date, we check if we should actually sync it
			NSDate *syncBackTo = [GWPreferencesHelper getDateToSyncBackTo];
			if ([self.crm_date_end compare:syncBackTo] == NSOrderedAscending) {
				//Means we should not sync this item
#if DEBUG
				NSLog(@"%@ Skipping item %@ as it happens earlier than the date to sync back to: %@", NSStringFromSelector(_cmd), self.crm_id, syncBackTo);
#endif
				return NO;
			}

			//Related records
			NSDictionary *assigned_user = [dict objectForKey:kProjecttaskAssigned_user_id];
			if ([[assigned_user objectForKey:@"value"] length] > 0) {
				self.crm_assigned_user_id = [assigned_user objectForKey:@"value"];
				self.crm_assigned_user_name = [assigned_user objectForKey:@"label"];
			}
			NSDictionary *modified_by = [dict objectForKey:kProjecttaskModifiedby];
			if ([[modified_by objectForKey:@"value"] length] > 0) {
				self.crm_modified_by_id = [modified_by objectForKey:@"value"];
				self.crm_modified_by_name = [modified_by objectForKey:@"label"];
			}
			NSDictionary *related_proj = [dict objectForKey:kProjecttaskProjectid];
			if ([[related_proj objectForKey:@"value"] length] > 0) {
				self.crm_related_project_id = [related_proj objectForKey:@"value"];
				self.crm_related_project_name = [related_proj objectForKey:@"label"];
			}
			
			//Custom fields
			NSError *cfieldsError;
			self.my_custom_fields = [NSJSONSerialization dataWithJSONObject:cfields options:NSJSONWritingPrettyPrinted error:&cfieldsError];
			if (cfieldsError != nil) {
				NSLog(@"Entity: %@ Error in custom fields: %@", self.crm_id, [cfieldsError description]);
			}
			
			
			//Look for existing related project
			Project *project = [Project MR_findFirstByAttribute:@"crm_id" withValue:self.crm_related_project_id];
			if (project) {
				self.project = project;
			}
			
			//Add the relationship with the current service
			self.service = [Service getActive];
		}
		@catch (NSException *exception) {
			//clean this object from the context
			[[NSManagedObjectContext MR_defaultContext] deleteObject:self];
			//log the exception
			NSLog(@"%@ %@ Exception: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [exception description]);
		}
	}
	
	return YES;
}

- (NSDictionary *)crmRepresentation
{
	
	//TODO
	
	
	
//	BOOL isNewRecord = NO;
//	if ([self.crm_id rangeOfString:@"-"].location != NSNotFound) {
//		//if the record id is in the structure 1x4345-5445-54554-445 it's been created with CFUUID
//		isNewRecord = YES;
//	}
//	//Should be like this:
//	//{"date_start":"2014-01-18", "due_date": "2014-01-18", "start_time":"14:44","activitytype":"Call","location":"Overhoeksplein 2, Amsterdam","subject":"Call Smith", "assigned_user_id" : "19x1","taskstatus":"Planned","visibility":"Private"}
//	//Setup the number formatter
//	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
//	
//	//Setup the date formatters
//	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//	[dateFormat setDateFormat:@"yyyy-MM-dd"];
//	NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
//	[timeFormat setDateFormat:@"HH:mm:ss"];
//	NSDateFormatter *dateTimeFormat = [[NSDateFormatter alloc] init];
//	[dateTimeFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
//	
//	
//	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//	[dict setObject:self.crm_activitytype forKey:kCalendarFieldactivitytype];
//	if (self.crm_contact_id != nil) {
//		//There's a related Contact
//		[dict setObject:self.crm_contact_id forKey:kCalendarFieldcontact_id];
//		//        [dict setObject:@{ @"value" : self.crm_contact_id, @"label" : self.crm_contact_name} forKey:kCalendarFieldcontact_id];
//	}
//	[dict setValue:self.crm_description forKey:kCalendarFielddescription];
//	[dict setValue:[numberFormatter stringFromNumber:self.crm_duration_hours] forKey:kCalendarFieldduration_hours];
//	[dict setValue:[numberFormatter stringFromNumber:self.crm_duration_minutes] forKey:kCalendarFieldduration_minutes];
//	if ([self.crm_activitytype isEqualToString:kCRMActivityTypeTask]) {
//		[dict setValue:self.crm_eventstatus forKey:kCalendarFieldtaskstatus];
//	}
//	else{
//		[dict setValue:self.crm_eventstatus forKey:kCalendarFieldeventstatus];
//	}
//	[dict setValue:self.crm_location forKey:kCalendarFieldlocation];
//	//    [dict setObject:self.crm_notime forKey:kCalendarFieldnotime]; //skip for the moment
//	if (self.crm_parent_id != nil) {
//		//There is a related record (not a Contact, for Contacts there is "contact_id")
//		[dict setObject:self.crm_parent_id forKey:kCalendarFieldparent_id];
//		//        [dict setObject:@{ @"value" : self.crm_parent_id, @"label" : self.crm_parent_name } forKey:kCalendarFieldparent_id];
//	}
//	[dict setValue:self.crm_recurringtype forKey:kCalendarFieldrecurringtype];
//	//    [dict setObject:self.crm_remindertime forKey:kCalendarFieldreminder_time]; //skip for the moment
//	//    [dict setObject:self.crm_sendnotification forKey:kCalendarFieldsendnotification]; //skip for the moment
//	[dict setValue:self.crm_subject forKey:kCalendarFieldsubject];
//	//    [dict setObject:[dateTimeFormat stringFromDate:self.crm_time_created] forKey:kFieldCreatedTime]; //skip for the moment
//	//    [dict setObject:[dateTimeFormat stringFromDate:self.crm_time_created] forKey:kFieldCreatedTime]; //skip for the moment
//	//    [dict setObject:self.crm_priority forKey:kCalendarFieldtaskpriority];
//	
//	
//	[dateFormat setTimeZone:[NSTimeZone timeZoneWithName:[Service getActive].crm_timezone_server]];
//	[timeFormat setTimeZone:[NSTimeZone timeZoneWithName:[Service getActive].crm_timezone_server]];
//	[dict setValue:[dateFormat stringFromDate:self.my_datetime_start] forKey:kCalendarFielddate_start];
//	[dict setValue:[dateFormat stringFromDate:self.crm_due_date] forKey:kCalendarFielddue_date];
//	[dict setValue:[timeFormat stringFromDate:self.my_datetime_end] forKey:kCalendarFieldtime_end];
//	[dict setValue:[timeFormat stringFromDate:self.my_datetime_start] forKey:kCalendarFieldtime_start];
//	
//	
//	//    //Time Zone Conversion
//	//    NSTimeZone *activityTimeZone = [NSTimeZone timeZoneWithName:self.my_timezone];
//	//    NSTimeZone *serverTimeZone = [NSTimeZone timeZoneWithName:[Service getActive].crm_timezone_server];
//	//    if([activityTimeZone secondsFromGMT] != [serverTimeZone secondsFromGMT]){
//	//
//	//        NSInteger offset1 = [activityTimeZone secondsFromGMTForDate: self.my_datetime_start];
//	//        NSInteger offset2 = [serverTimeZone secondsFromGMTForDate: self.my_datetime_end];
//	//
//	//        NSDate *adjusted_dateTimeStart = [self.my_datetime_start dateByAddingTimeInterval:(offset1 - offset2)];
//	//        NSDate *adjusted_dateTimeEnd = [self.my_datetime_end dateByAddingTimeInterval:(offset1 - offset2)];
//	//        NSDate *adjusted_due_date = [self.crm_due_date dateByAddingTimeInterval:(offset1 - offset2)];
//	//
//	//        NSDate *adjusted_date_start = [adjusted_dateTimeStart gw_DatePart];
//	//        NSDate *adjusted_time_start = [adjusted_dateTimeStart gw_TimePart];
//	//        adjusted_due_date = [adjusted_due_date gw_DatePart];
//	//        NSDate *adjusted_time_end = [adjusted_dateTimeEnd gw_TimePart];
//	//
//	//        [dict setValue:[dateFormat stringFromDate:adjusted_date_start] forKey:kCalendarFielddate_start];
//	//        [dict setValue:[dateFormat stringFromDate:adjusted_due_date] forKey:kCalendarFielddue_date];
//	//        [dict setValue:[timeFormat stringFromDate:adjusted_time_end] forKey:kCalendarFieldtime_end];
//	//        [dict setValue:[timeFormat stringFromDate:adjusted_time_start] forKey:kCalendarFieldtime_start];
//	//
//	//// Previously
//	////        [dict setValue:[dateFormat stringFromDate:self.crm_date_start] forKey:kCalendarFielddate_start];
//	////        [dict setValue:[dateFormat stringFromDate:self.crm_due_date] forKey:kCalendarFielddue_date];
//	////        [dict setValue:[timeFormat stringFromDate:self.crm_time_end] forKey:kCalendarFieldtime_end];
//	////        [dict setValue:[timeFormat stringFromDate:self.crm_time_start] forKey:kCalendarFieldtime_start];
//	//
//	//    }
//	
//	[dict setValue:self.crm_visibility forKey:kCalendarFieldvisibility];
//	[dict setValue:self.crm_reminder_time forKey:kCalendarFieldreminder_time];
//	
//	if (isNewRecord == NO) {
//		[dict setObject:self.crm_id forKey:kCalendarFieldid];
//	}
//	if ([self.crm_assigned_user_id length] > 0) {
//		[dict setObject:self.crm_assigned_user_id forKey:kCalendarFieldassigned_user_id];
//		//        [dict setObject:@{ @"value" : self.crm_assigned_user_id, @"label" : self.crm_assigned_user_name } forKey:kCalendarFieldassigned_user_id];
//	}
//	
//	
//	return [dict copy]; //We return the immutable copy because dict is mutable.
	return @{};
}

- (NSDictionary *)proxyForJson
{
	return [self crmRepresentation];
}

@end
