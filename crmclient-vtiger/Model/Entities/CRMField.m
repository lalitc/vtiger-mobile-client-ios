#import "CRMField.h"
#import "CRMFieldConstants.h"
#import "CRMFieldPicklistValue.h"
#import "CoreData+MagicalRecord.h"

@interface CRMField ()

// Private interface goes here.

@end


@implementation CRMField

+ (CRMField *)modelObjectWithDictionary:(NSDictionary*)dict module:(Module*)module
{
    NSString *fieldName = [dict objectForKey:@"name"];
#if DEBUG
    NSLog(@"%@ %@ field: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), fieldName);
#endif
    NSPredicate *p = [NSPredicate predicateWithFormat:@"crm_name = %@ AND module = %@",fieldName, module];
    
    CRMField *instance = [CRMField MR_findFirstWithPredicate:p];
    if (instance == nil) {
        instance = [CRMField MR_createEntity];
    }
    
    instance.crm_name = [dict objectForKey:kCRMFieldName];
    instance.crm_label = [dict objectForKey:kCRMFieldlabel];
    instance.crm_mandatory = [NSNumber numberWithBool:[[dict objectForKey:kCRMFieldmandatory] boolValue]];
	//Intercept when <null> and when nil in this if/else
    if ([[dict objectForKey:kCRMFielduitype] isKindOfClass:[NSNull class]]) {
        instance.crm_uitype = nil;
    }else{
		instance.crm_uitype =  [dict objectForKey:kCRMFielduitype] == nil? nil : [NSString stringWithFormat:@"%@",[dict objectForKey:kCRMFielduitype]];
    }
	NSString *fieldTypeName = [[dict objectForKey:kCRMFieldtype] objectForKey:@"name" ];
    if ([fieldTypeName isEqualToString:@"picklist"] || [fieldTypeName isEqualToString:@"multipicklist"]) {
        NSError *jsonError;
		instance.crm_type = fieldTypeName;
        instance.crm_options = [NSJSONSerialization dataWithJSONObject:[[dict objectForKey:@"type"] objectForKey:@"picklistValues"] options:0 error:&jsonError];
        if (jsonError!=nil) {
#if DEBUG
            NSLog(@"%@ %@ error parsing picklist values for field %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), fieldName);
#endif
        }
        else{
            NSArray *picklistValues = [[dict objectForKey:kCRMFieldtype] objectForKey:@"picklistValues"];
            for (NSDictionary *picklistValue in picklistValues) {
                CRMFieldPicklistValue *pv = [CRMFieldPicklistValue MR_createEntity];
                pv.crm_label = [picklistValue objectForKey:@"label"];
                pv.crm_value = [picklistValue objectForKey:@"value"];
                pv.field = instance;
            }

        }
    }
    else{
        instance.crm_type = [[dict objectForKey:kCRMFieldtype] objectForKey:@"name"];
    }
    return instance;
}

- (BOOL)isCustomField
{
	return [self.crm_name hasPrefix:@"cf_"];
}

@end
