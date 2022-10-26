//
//  ComplicationController.swift
//  WristHome WatchKit Extension
//
//  Created by Tomas on 31.07.2022.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    let appMainColorAlaph40 = UIColor(red: 234/255, green: 188/255, blue: 188/255, alpha: 1)
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
            let descriptors = [
                CLKComplicationDescriptor(identifier: "complication", displayName: "WristHome", supportedFamilies: [CLKComplicationFamily.circularSmall, CLKComplicationFamily.graphicCircular, CLKComplicationFamily.graphicCorner])
                // Multiple complication support can be added here with more descriptors
            ]
            
            // Call the handler with the currently supported complication descriptors
            handler(descriptors)
        }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        if let template = getComplicationTemplate(for: complication, using: Date()) {
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        } else {
            handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        handler(nil)
    }

    // MARK: - Sample Templates
    func getComplicationTemplate(for complication: CLKComplication, using date: Date) -> CLKComplicationTemplate? {
            switch complication.family {
            case .graphicCorner:
                return CLKComplicationTemplateGraphicCornerCircularImage(imageProvider: CLKFullColorImageProvider(fullColorImage: (UIImage(systemName: "homekit")?.withTintColor(appMainColorAlaph40))!))
            case .graphicCircular:
                return CLKComplicationTemplateGraphicCircularImage(imageProvider: CLKFullColorImageProvider(fullColorImage: (UIImage(systemName: "homekit")?.withTintColor(appMainColorAlaph40))!))
            case .circularSmall:
                return CLKComplicationTemplateCircularSmallSimpleImage(imageProvider: CLKImageProvider(onePieceImage: (UIImage(systemName: "homekit")?.withTintColor(appMainColorAlaph40))!))
            default:
                return nil
            }
        }
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        let template = getComplicationTemplate(for: complication, using: Date())
        if let t = template {
            handler(t)
        } else {
            handler(nil)
        }
    }
}
