// 0801: We disable automatic search from the urlbar, also see 0804
//user_pref("keyword.enabled", true);
//user_pref("browser.search.suggest.enabled", true);
//user_pref("browser.urlbar.suggest.searches", true);

// 2811: We delete history
user_pref("privacy.clearOnShutdown.history", false);

/* override recipe: RFP is not for me ***/
user_pref("privacy.resistFingerprinting", false); // 4501
user_pref("privacy.resistFingerprinting.letterboxing", false); // 4504 [pointless if not using RFP]
user_pref("webgl.disabled", false); // 4520 [mostly pointless if not using RFP]

user_pref("browser.download.useDownloadDir", true);
user_pref("general.autoScroll", true);
user_pref("browser.startup.page", 1);
user_pref("browser.startup.homepage", "about:home");
user_pref("browser.newtabpage.enabled", true);
user_pref("browser.newtab.preload", true);

user_pref("extensions.formautofill.creditCards.enabled", false);
user_pref("signon.rememberSignons", false);
user_pref("privacy.donottrackheader.enabled", true);
user_pref("privacy.globalprivacycontrol.enabled", true);

user_pref("network.http.referer.XOriginPolicy", 0);
user_pref("media.autoplay.blocking_policy", 0);
user_pref("browser.urlbar.update2.engineAliasRefresh", true);

user_pref("network.trr.mode", 3);
user_pref("network.trr.default_provider_uri", "https://dns.quad9.net/dns-query");
user_pref("network.trr.custom_uri", "https://dns.quad9.net/dns-query");
