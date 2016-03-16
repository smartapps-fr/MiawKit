//
//  MKFunctions.m
//  MiawKitTest
//
//  Created by Kristian Andersen on 12/03/14.
//  Copyright (c) 2014 Robocat. All rights reserved.
//

#define MK_NOT_AVAILABLE @"MK_LOCALIZED_STRING_NOT_AVAILABLE"

#import "MKFunctions.h"

#define MK_SETTING_KEY @"MiawKitLanguage"

NSString __strong *MKLocalizationFallbackLanguage = @"en";

void MKLocalizationSetPreferredLanguage(NSString *language) {
	[[NSUserDefaults standardUserDefaults] setObject:language forKey:MK_SETTING_KEY];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

void MKLocalizationRemovePreferredLanguage() {
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:MK_SETTING_KEY];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

void MKLocalizationSetFallbackLanguage(NSString *language) {
	MKLocalizationFallbackLanguage = language;
}

NSString *MKLocalizationNameForPrefferedLanguage(void) {
    return MKLocalizationNameForLanguage(MKLocalizationPreferredLanguage());
}

NSString *MKLocalizationNameForLanguage(NSString *language) {
    return MKLocalizationNameForLanguageInLanguage(language, MKLocalizationPreferredLanguage());
}

NSString *MKLocalizationNameForLanguageInLanguage(NSString *language, NSString *inLanguage) {
    NSLocale *currentLocale = [NSLocale localeWithLocaleIdentifier:inLanguage];
    NSString *languageName = [currentLocale displayNameForKey:NSLocaleIdentifier value:language];
    languageName = [languageName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[languageName uppercaseString] substringToIndex:1]];
    return languageName;
}

NSString *MKLocalizationPreferredLanguage(void) {
	NSString *languageSetting = [[NSUserDefaults standardUserDefaults] objectForKey:MK_SETTING_KEY];
	if ([languageSetting length] > 0) {
		return languageSetting;
	} else {
		return [[[NSBundle mainBundle] preferredLocalizations] firstObject];
	}
}

NSString *MKLocalized(NSString *str) {
	return MKLocalizedFromTable(str, nil);
}

NSString *MKLocalizedFromTable(NSString *str, NSString *table) {
	NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:MKLocalizationPreferredLanguage() ofType:@"lproj"]];
	NSString *string = [bundle localizedStringForKey:str value:MK_NOT_AVAILABLE table:table];
	
	if (!string || [string isEqualToString:MK_NOT_AVAILABLE]) {
		bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:MKLocalizationFallbackLanguage ofType:@"lproj"]];
		return [bundle localizedStringForKey:str value:nil table:table];
	}
	
    return string;
}

NSString *MKLocalizedWithFormat(NSString *str, ...) {
	va_list vars;
	va_start(vars, str);
	
	NSString *string = [[NSString alloc] initWithFormat:MKLocalized(str) arguments:vars];
	
	va_end(vars);
	return string;
}

NSString *MKLocalizedFromTableWithFormat(NSString *str, NSString *table, ...) {
	va_list vars;
	va_start(vars, table);
	
	NSString *string = [[NSString alloc] initWithFormat:MKLocalizedFromTable(str, table) arguments:vars];
	
	va_end(vars);
	return string;
}
