// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Activity.h instead.

@import CoreData;
#import "CalendarItem.h"

extern const struct ActivityAttributes {
	__unsafe_unretained NSString *crm_activitytype;
	__unsafe_unretained NSString *crm_contact_id;
	__unsafe_unretained NSString *crm_contact_name;
	__unsafe_unretained NSString *crm_duration_hours;
	__unsafe_unretained NSString *crm_duration_minutes;
	__unsafe_unretained NSString *crm_eventstatus;
	__unsafe_unretained NSString *crm_location;
	__unsafe_unretained NSString *crm_notime;
	__unsafe_unretained NSString *crm_parent_id;
	__unsafe_unretained NSString *crm_parent_name;
	__unsafe_unretained NSString *crm_parent_type;
	__unsafe_unretained NSString *crm_priority;
	__unsafe_unretained NSString *crm_recurringtype;
	__unsafe_unretained NSString *crm_reminder_time;
	__unsafe_unretained NSString *crm_sendnotification;
	__unsafe_unretained NSString *crm_time_created;
	__unsafe_unretained NSString *crm_time_end;
	__unsafe_unretained NSString *crm_time_modified;
	__unsafe_unretained NSString *crm_time_start;
	__unsafe_unretained NSString *crm_visibility;
	__unsafe_unretained NSString *my_timezone;
} ActivityAttributes;

extern const struct ActivityFetchedProperties {
	__unsafe_unretained NSString *activity_relatedlead;
} ActivityFetchedProperties;

@interface ActivityID : CalendarItemID {}
@end

@interface _Activity : CalendarItem {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ActivityID* objectID;

@property (nonatomic, strong) NSString* crm_activitytype;

//- (BOOL)validateCrm_activitytype:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* crm_contact_id;

//- (BOOL)validateCrm_contact_id:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* crm_contact_name;

//- (BOOL)validateCrm_contact_name:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* crm_duration_hours;

@property (atomic) int16_t crm_duration_hoursValue;
- (int16_t)crm_duration_hoursValue;
- (void)setCrm_duration_hoursValue:(int16_t)value_;

//- (BOOL)validateCrm_duration_hours:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* crm_duration_minutes;

@property (atomic) int16_t crm_duration_minutesValue;
- (int16_t)crm_duration_minutesValue;
- (void)setCrm_duration_minutesValue:(int16_t)value_;

//- (BOOL)validateCrm_duration_minutes:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* crm_eventstatus;

//- (BOOL)validateCrm_eventstatus:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* crm_location;

//- (BOOL)validateCrm_location:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* crm_notime;

//- (BOOL)validateCrm_notime:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* crm_parent_id;

//- (BOOL)validateCrm_parent_id:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* crm_parent_name;

//- (BOOL)validateCrm_parent_name:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* crm_parent_type;

//- (BOOL)validateCrm_parent_type:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* crm_priority;

//- (BOOL)validateCrm_priority:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* crm_recurringtype;

//- (BOOL)validateCrm_recurringtype:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* crm_reminder_time;

@property (atomic) int16_t crm_reminder_timeValue;
- (int16_t)crm_reminder_timeValue;
- (void)setCrm_reminder_timeValue:(int16_t)value_;

//- (BOOL)validateCrm_reminder_time:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* crm_sendnotification;

//- (BOOL)validateCrm_sendnotification:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* crm_time_created;

//- (BOOL)validateCrm_time_created:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* crm_time_end;

//- (BOOL)validateCrm_time_end:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* crm_time_modified;

//- (BOOL)validateCrm_time_modified:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* crm_time_start;

//- (BOOL)validateCrm_time_start:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* crm_visibility;

//- (BOOL)validateCrm_visibility:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* my_timezone;

//- (BOOL)validateMy_timezone:(id*)value_ error:(NSError**)error_;

@property (nonatomic, readonly) NSArray *activity_relatedlead;

@end

@interface _Activity (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCrm_activitytype;
- (void)setPrimitiveCrm_activitytype:(NSString*)value;

- (NSString*)primitiveCrm_contact_id;
- (void)setPrimitiveCrm_contact_id:(NSString*)value;

- (NSString*)primitiveCrm_contact_name;
- (void)setPrimitiveCrm_contact_name:(NSString*)value;

- (NSNumber*)primitiveCrm_duration_hours;
- (void)setPrimitiveCrm_duration_hours:(NSNumber*)value;

- (int16_t)primitiveCrm_duration_hoursValue;
- (void)setPrimitiveCrm_duration_hoursValue:(int16_t)value_;

- (NSNumber*)primitiveCrm_duration_minutes;
- (void)setPrimitiveCrm_duration_minutes:(NSNumber*)value;

- (int16_t)primitiveCrm_duration_minutesValue;
- (void)setPrimitiveCrm_duration_minutesValue:(int16_t)value_;

- (NSString*)primitiveCrm_eventstatus;
- (void)setPrimitiveCrm_eventstatus:(NSString*)value;

- (NSString*)primitiveCrm_location;
- (void)setPrimitiveCrm_location:(NSString*)value;

- (NSString*)primitiveCrm_notime;
- (void)setPrimitiveCrm_notime:(NSString*)value;

- (NSString*)primitiveCrm_parent_id;
- (void)setPrimitiveCrm_parent_id:(NSString*)value;

- (NSString*)primitiveCrm_parent_name;
- (void)setPrimitiveCrm_parent_name:(NSString*)value;

- (NSString*)primitiveCrm_parent_type;
- (void)setPrimitiveCrm_parent_type:(NSString*)value;

- (NSString*)primitiveCrm_priority;
- (void)setPrimitiveCrm_priority:(NSString*)value;

- (NSString*)primitiveCrm_recurringtype;
- (void)setPrimitiveCrm_recurringtype:(NSString*)value;

- (NSNumber*)primitiveCrm_reminder_time;
- (void)setPrimitiveCrm_reminder_time:(NSNumber*)value;

- (int16_t)primitiveCrm_reminder_timeValue;
- (void)setPrimitiveCrm_reminder_timeValue:(int16_t)value_;

- (NSString*)primitiveCrm_sendnotification;
- (void)setPrimitiveCrm_sendnotification:(NSString*)value;

- (NSDate*)primitiveCrm_time_created;
- (void)setPrimitiveCrm_time_created:(NSDate*)value;

- (NSDate*)primitiveCrm_time_end;
- (void)setPrimitiveCrm_time_end:(NSDate*)value;

- (NSDate*)primitiveCrm_time_modified;
- (void)setPrimitiveCrm_time_modified:(NSDate*)value;

- (NSDate*)primitiveCrm_time_start;
- (void)setPrimitiveCrm_time_start:(NSDate*)value;

- (NSString*)primitiveCrm_visibility;
- (void)setPrimitiveCrm_visibility:(NSString*)value;

- (NSString*)primitiveMy_timezone;
- (void)setPrimitiveMy_timezone:(NSString*)value;

@end
