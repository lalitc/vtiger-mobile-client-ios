#import "Potential.h"
#import "CRMFieldConstants.h"
#import "ModulesHelper.h"
#import "CRMClient.h"
#import "CoreData+MagicalRecord.h"
#import "Service.h"

@interface Potential ()

// Private interface goes here.

@end


@implementation Potential

+ (Potential *)modelObjectWithDictionary:(NSDictionary *)dict
{
    NSString *record_id = [dict objectForKey:kPotentialsFieldId];
    Potential *instance;
    
    
    //I first try to count the entities (should take less time) and load the entity only if strictly necessary (if count > 0). The Count operation should be less intensive than the Fetch, so I use it for checking the existence
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"crm_id = %@", record_id];
    NSUInteger count = [Potential MR_countOfEntitiesWithPredicate:predicate];
    
    if (count > 0) {
        instance = [Potential MR_findFirstByAttribute:@"crm_id" withValue:record_id];
        
    }
    else{
        instance = [Potential MR_createEntity];
    }
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if([dict isKindOfClass:[NSDictionary class]]) {
        
        //Setup the number formatter
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        
        //Setup the date formatters
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"HH:mm:ss"];
        
        NSDateFormatter *dateTimeFormat = [[NSDateFormatter alloc] init];
        [dateTimeFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *time_modified = [dateTimeFormat dateFromString:[dict objectForKey:kFieldModifiedTime]];
        NSDate *time_created = [dateTimeFormat dateFromString:[dict objectForKey:kFieldCreatedTime]];
        instance.crm_time_modified = time_modified;
        instance.crm_time_created = time_created;
        
        instance.crm_amount = [NSDecimalNumber decimalNumberWithString:[dict objectForKey:kPotentialsFieldAmount]];
        instance.crm_assigned_user_id = [[dict objectForKey:kPotentialsFieldAssignedUserId] objectForKey:@"value"];
        instance.crm_assigned_user_name = [[dict objectForKey:kPotentialsFieldAssignedUserId] objectForKey:@"label"];
        instance.crm_campaign_id = [[dict objectForKey:kPotentialsFieldCampaignId] objectForKey:@"value"];
        instance.crm_campaign_name = [[dict objectForKey:kPotentialsFieldCampaignId] objectForKey:@"label"];
        instance.crm_closingdate = [dateFormat dateFromString:[dict objectForKey:kPotentialsFieldClosingDate]];
        instance.crm_id = [dict objectForKey:kPotentialsFieldId];
        instance.crm_leadsource = [dict objectForKey:kPotentialsFieldLeadSource];
        instance.crm_nextstep = [dict objectForKey:kPotentialsFieldNextStep];
        instance.crm_opportunity_type = [dict objectForKey:kPotentialsFieldOpportunityType];
        instance.crm_potentialname = [dict objectForKey:kPotentialsFieldPotentialName];
        instance.crm_potential_no = [dict objectForKey:kPotentialsFieldPotentialNo];
        instance.crm_probability = [numberFormatter numberFromString:[dict objectForKey:kPotentialsFieldProbability]];
        instance.crm_description = [dict objectForKey:kPotentialsFieldDescription];
        
        NSDictionary *related_record = [dict objectForKey:kPotentialsFieldRelatedTo];
        if ([[related_record objectForKey:@"value"] length] > 0) {
            instance.crm_related_to_id = [related_record objectForKey:@"value"];
            instance.crm_related_to_name = [related_record objectForKey:@"label"];
            instance.crm_related_to_type = [ModulesHelper decodeModuleForRecordId:instance.crm_related_to_id];
            [[CRMClient sharedInstance] addRecordToFetchQueue:instance.crm_related_to_id];
        }
        instance.crm_sales_stage = [dict objectForKey:kPotentialsFieldSalesStage];
        
        //Add the relationship with the current service
        instance.service = [Service getActive];
        
        
    }
    
    return instance;
}

@end
