// AppRating.swift
//
// Copyright (c) 2017 GrizzlyNT (https://github.com/grizzly/AppRating)
//
// Based on: Armchair, Copyright (c) 2014 Armchair (http://github.com/UrbanApps/Armchair)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import StoreKit
import SystemConfiguration



open class AppRating {
    
    static var appID : String = "";
    
    // Getters and Setters
    
    static let manager : AppRatingManager = {
        assert(AppRating.appID != "", "AppRating.appID(appID: String) has to be the first AppRating call made.")
        struct Singleton {
            static let instance: AppRatingManager = AppRatingManager(appID: AppRating.appID)
        }
        return Singleton.instance;
    }()
    
    public func appID(_ appID: String) {
        AppRating.appID = appID
        AppRating.manager.appID = appID
    }
    
    /*
     * Users will need to have the same version of your app installed for this many
     * days before they will be prompted to rate it.
     * Default => 3
     */
    
    public func daysUntilPrompt() -> Int {
        return AppRating.manager.daysUntilPrompt
    }
    
    public func daysUntilPrompt(_ daysUntilPrompt: Int) {
        AppRating.manager.daysUntilPrompt = daysUntilPrompt
    }
    
    /*
     * An example of a 'use' would be if the user launched the app. Bringing the app
     * into the foreground (on devices that support it) would also be considered
     * a 'use'.
     *
     * Users need to 'use' the same version of the app this many times before
     * before they will be prompted to rate it.
     * Default => 3
     */
    
    public func usesUntilPrompt() -> Int {
        return AppRating.manager.usesUntilPrompt
    }
    
    public func usesUntilPrompt(_ usesUntilPrompt: Int) {
        AppRating.manager.usesUntilPrompt = usesUntilPrompt
    }
    
    /*
     * Once the rating alert is presented to the user, they might select
     * 'Remind me later'. This value specifies how many days Armchair
     * will wait before reminding them. A value of 0 disables reminders and
     * removes the 'Remind me later' button.
     * Default => 1
     */
    
    public func daysBeforeReminding() -> Int {
        return AppRating.manager.daysBeforeReminding;
    }
    
    public func daysBeforeReminding(_ daysBeforeReminding: Int) {
        AppRating.manager.daysBeforeReminding = daysBeforeReminding
    }
    
    /*
     * By default, Armchair tracks all new bundle versions.
     * When it detects a new version, it resets the values saved for usage,
     * significant events, popup shown, user action etc...
     * By setting this to false, Armchair will ONLY track the version it
     * was initialized with. If this setting is set to true, Armchair
     * will reset after each new version detection.
     * Default => true
     */
    
    public func tracksNewVersions() -> Bool {
        return AppRating.manager.tracksNewVersions
    }
    
    public func tracksNewVersions(_ tracksNewVersions: Bool) {
        AppRating.manager.tracksNewVersions = tracksNewVersions
    }
    
    /*
     * If set to true, the main bundle will always be used to load localized strings.
     * Set this to true if you have provided your own custom localizations in
     * ArmchairLocalizable.strings in your main bundle
     * Default => false.
     */
    
    public func useMainAppBundleForLocalizations() -> Bool {
        return AppRating.manager.useMainAppBundleForLocalizations
    }
    
    public func useMainAppBundleForLocalizations(_ useMainAppBundleForLocalizations: Bool) {
        AppRating.manager.useMainAppBundleForLocalizations = useMainAppBundleForLocalizations
    }
    
    
}

open class AppRatingManager {
    
    public var appID : String = "";
    public var appName : String = "";
    public var daysUntilPrompt : Int = 3;
    public var usesUntilPrompt : Int = 3;
    public var daysBeforeReminding : Int = 1;
    public var tracksNewVersions : Bool = true;
    public var useMainAppBundleForLocalizations : Bool = false;
    
    fileprivate var operatingSystemVersion = NSString(string: UIDevice.current.systemVersion).doubleValue;
    fileprivate var currentVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    
    init(appID: String) {
        self.appID = appID;
    }
    
    
    // MARK: -
    // MARK: PRIVATE Functions
    
    fileprivate func setDefaults() {
        self.appName = self.defaultAppName();
    }
    
    fileprivate func defaultKeyPrefix() -> String {
        if !self.appID.isEmpty {
            return self.appID + "_"
        } else {
            return "_"
        }
    }
    
    fileprivate func defaultAppName() -> String {
        let mainBundle = Bundle.main
        let displayName = mainBundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        let bundleNameKey = kCFBundleNameKey as String
        let name = mainBundle.object(forInfoDictionaryKey: bundleNameKey) as? String
        return displayName ?? name ?? "This App"
    }
    
    fileprivate func defaultReviewTitle() -> String {
        var template = "Rate %@"
        // Check for a localized version of the default title
        if let bundle = self.bundle() {
            template = bundle.localizedString(forKey: template,
                                              value: bundle.localizedString(forKey: template, value:"", table: nil),
                                              table: "AppRatingLocalizable")
        }
        
        return template.replacingOccurrences(of: "%@", with: "\(self.appName)", options: NSString.CompareOptions(rawValue: 0), range: nil)
    }
    
    fileprivate func defaultReviewMessage() -> String {
        var template = "If you enjoy using %@, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!"
        // Check for a localized version of the default title
        if let bundle = self.bundle() {
            template = bundle.localizedString(forKey: template,
                                              value: bundle.localizedString(forKey: template, value:"", table: nil),
                                              table: "AppRatingLocalizable")
        }
        
        return template.replacingOccurrences(of: "%@", with: "\(self.appName)", options: NSString.CompareOptions(rawValue: 0), range: nil)
    }
    
    fileprivate func defaultCancelButtonTitle() -> String {
        var title = "No, Thanks"
        // Check for a localized version of the default title
        if let bundle = self.bundle() {
            title = bundle.localizedString(forKey: title,
                                           value: bundle.localizedString(forKey: title, value:"", table: nil),
                                           table: "AppRatingLocalizable")
        }
        
        return title
    }
    
    fileprivate func defaultRateButtonTitle() -> String {
        var template = "Rate %@"
        // Check for a localized version of the default title
        if let bundle = self.bundle() {
            template = bundle.localizedString(forKey: template,
                                              value: bundle.localizedString(forKey: template, value:"", table: nil),
                                              table: "AppRatingLocalizable")
        }
        
        return template.replacingOccurrences(of: "%@", with: "\(self.appName)", options: NSString.CompareOptions(rawValue: 0), range: nil)
    }
    
    fileprivate func defaultRemindButtonTitle() -> String? {
        //if reminders are disabled, return a nil title to supress the button
        if self.daysBeforeReminding == 0 {
            return nil
        }
        var title = "Remind me later"
        // Check for a localized version of the default title
        if let bundle = self.bundle() {
            title = bundle.localizedString(forKey: title,
                                           value: bundle.localizedString(forKey: title, value:"", table: nil),
                                           table: "AppRatingLocalizable")
        }
        
        return title
    }
    
    // MARK: -
    // MARK: PRIVATE Misc Helpers
    
    private func bundle() -> Bundle? {
        var bundle: Bundle? = nil
        
        if useMainAppBundleForLocalizations {
            bundle = Bundle.main
        } else {
            let appratingBundleURL: URL? = Bundle.main.url(forResource: "AppRating", withExtension: "bundle")
            if let url = appratingBundleURL {
                bundle = Bundle(url: url)
            } else {
                bundle = Bundle(for: type(of: self))
            }
        }
        
        return bundle
    }
}

