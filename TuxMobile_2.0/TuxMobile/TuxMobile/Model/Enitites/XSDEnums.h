//
//  XSDEnums.h
//
//  Generated by wadl2objc 2013.09.03 12:29:30.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RoleType) { 
	RoleTypeTAILOR = 1, 
	RoleTypeSTORE_ADMIN,
	RoleTypeREGIONAL_ADMIN,
	RoleTypeSYSTEM_ADMIN,
 
};
static NSString *const kRoleTypeTAILORString = @"TAILOR";
static NSString *const kRoleTypeSTORE_ADMINString = @"STORE_ADMIN";
static NSString *const kRoleTypeREGIONAL_ADMINString = @"REGIONAL_ADMIN";
static NSString *const kRoleTypeSYSTEM_ADMINString = @"SYSTEM_ADMIN";

typedef NS_ENUM(NSUInteger, Status) { 
	StatusSAVED = 1, 
	StatusACTIVE,
	StatusSCHEDULED,
	StatusCOMPLETED,
	StatusPICKED_UP,
	StatusDELETED,
 
};
static NSString *const kStatusSAVEDString = @"SAVED";
static NSString *const kStatusACTIVEString = @"ACTIVE";
static NSString *const kStatusSCHEDULEDString = @"SCHEDULED";
static NSString *const kStatusCOMPLETEDString = @"COMPLETED";
static NSString *const kStatusPICKED_UPString = @"PICKED_UP";
static NSString *const kStatusDELETEDString = @"DELETED";

typedef NS_ENUM(NSUInteger, ContactPreferences) { 
	ContactPreferencesPHONE = 1, 
	ContactPreferencesEMAIL,
	ContactPreferencesNONE,
 
};
static NSString *const kContactPreferencesPHONEString = @"PHONE";
static NSString *const kContactPreferencesEMAILString = @"EMAIL";
static NSString *const kContactPreferencesNONEString = @"NONE";

typedef NS_ENUM(NSUInteger, Gender) { 
	GenderMAN = 1, 
	GenderFEMALE,
 
};
static NSString *const kGenderMANString = @"MAN";
static NSString *const kGenderFEMALEString = @"FEMALE";

typedef NS_ENUM(NSUInteger, AlterationStatus) { 
	AlterationStatusDELETED = 1, 
	AlterationStatusNEW,
	AlterationStatusPAID,
	AlterationStatusPAIDFREE,
	AlterationStatusCOMPLETE,
	AlterationStatusVOID,
 
};
static NSString *const kAlterationStatusDELETEDString = @"DELETED";
static NSString *const kAlterationStatusNEWString = @"NEW";
static NSString *const kAlterationStatusPAIDString = @"PAID";
static NSString *const kAlterationStatusPAIDFREEString = @"PAIDFREE";
static NSString *const kAlterationStatusCOMPLETEString = @"COMPLETE";
static NSString *const kAlterationStatusVOIDString = @"VOID";

typedef NS_ENUM(NSUInteger, GarmentType) { 
	GarmentTypeCOAT = 1, 
	GarmentTypePANTS,
	GarmentTypeVEST,
	GarmentTypeSHIRT,
	GarmentTypeOVERCOAT,
	GarmentTypeLEATHER,
	GarmentTypeSHORTS,
	GarmentTypeSKIRT,
	GarmentTypeSKORT,
	GarmentTypeDRESS,
 
};
static NSString *const kGarmentTypeCOATString = @"COAT";
static NSString *const kGarmentTypePANTSString = @"PANTS";
static NSString *const kGarmentTypeVESTString = @"VEST";
static NSString *const kGarmentTypeSHIRTString = @"SHIRT";
static NSString *const kGarmentTypeOVERCOATString = @"OVERCOAT";
static NSString *const kGarmentTypeLEATHERString = @"LEATHER";
static NSString *const kGarmentTypeSHORTSString = @"SHORTS";
static NSString *const kGarmentTypeSKIRTString = @"SKIRT";
static NSString *const kGarmentTypeSKORTString = @"SKORT";
static NSString *const kGarmentTypeDRESSString = @"DRESS";

typedef NS_ENUM(NSUInteger, DayOfWeek) { 
	DayOfWeekSUNDAY = 1, 
	DayOfWeekMONDAY,
	DayOfWeekTUESDAY,
	DayOfWeekWEDNESDAY,
	DayOfWeekTHURSDAY,
	DayOfWeekFRIDAY,
	DayOfWeekSATURDAY,
 
};
static NSString *const kDayOfWeekSUNDAYString = @"SUNDAY";
static NSString *const kDayOfWeekMONDAYString = @"MONDAY";
static NSString *const kDayOfWeekTUESDAYString = @"TUESDAY";
static NSString *const kDayOfWeekWEDNESDAYString = @"WEDNESDAY";
static NSString *const kDayOfWeekTHURSDAYString = @"THURSDAY";
static NSString *const kDayOfWeekFRIDAYString = @"FRIDAY";
static NSString *const kDayOfWeekSATURDAYString = @"SATURDAY";

typedef NS_ENUM(NSUInteger, OrderType) { 
	OrderTypeNORMAL = 1, 
	OrderTypeRFA,
 
};
static NSString *const kOrderTypeNORMALString = @"NORMAL";
static NSString *const kOrderTypeRFAString = @"RFA";


@interface XSDEnums : NSObject

+ (NSUInteger)enumValueForObject:(id)object enumName:(NSString*)enumName;
+ (id)objectForEnumValue:(NSUInteger)enumValue enumName:(NSString*)enumName;

@end