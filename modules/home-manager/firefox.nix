{pkgs, ...}: let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in {
  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {
        DisableTelemetry = true;

        Preferences = {
          "app.normandy.api_url" = {
            Value = "";
            Status = "locked";
          };
          "app.normandy.enabled" = lock-false;
          "app.shield.optoutstudies.enabled" = lock-false;
          "app.update.auto" = lock-false;
          "beacon.enabled" = lock-false;
          "breakpad.reportURL" = {
            Value = "";
            Status = "locked";
          };
          "browser.aboutConfig.showWarning" = lock-false;
          "browser.cache.offline.enable" = lock-false;
          "browser.crashReports.unsubmittedCheck.autoSubmit" = lock-false;
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = lock-false;
          "browser.crashReports.unsubmittedCheck.enabled" = lock-false;
          "browser.disableResetPrompt" = lock-true;
          "browser.newtab.preload" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
          "browser.newtabpage.enhanced" = lock-false;
          "browser.newtabpage.introShown" = lock-true;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
          "browser.newtabpage.activity-stream.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
          "browser.safebrowsing.appRepURL" = {
            Value = "";
            Status = "locked";
          };
          "browser.safebrowsing.blockedURIs.enabled" = lock-false;
          "browser.safebrowsing.downloads.enabled" = lock-false;
          "browser.safebrowsing.downloads.remote.enabled" = lock-false;
          "browser.safebrowsing.downloads.remote.url" = {
            Value = "";
            Status = "locked";
          };
          "browser.safebrowsing.enabled" = lock-false;
          "browser.safebrowsing.malware.enabled" = lock-false;
          "browser.safebrowsing.phishing.enabled" = lock-false;
          "browser.selfsupport.url" = {
            Value = "";
            Status = "locked";
          };
          "browser.send_pings" = lock-false;
          "browser.sessionstore.privacy_level" = {
            Value = 0;
            Status = "locked";
          };
          "browser.shell.checkDefaultBrowser" = lock-false;
          "browser.startup.homepage_override.mstone" = {
            Value = "ignore";
            Status = "locked";
          };
          "browser.tabs.crashReporting.sendReport" = lock-false;
          "browser.urlbar.groupLabels.enabled" = lock-false;
          "browser.urlbar.quicksuggest.enabled" = lock-false;
          "browser.urlbar.speculativeConnect.enabled" = lock-false;
          "browser.urlbar.trimURLs" = lock-false;
          "browser.urlbar.suggest.quicksuggest.sponsored" = lock-false;
          "datareporting.healthreport.service.enabled" = lock-false;
          "datareporting.healthreport.uploadEnabled" = lock-false;
          "datareporting.policy.dataSubmissionEnabled" = lock-false;
          "device.sensors.ambientLight.enabled" = lock-false;
          "device.sensors.enabled" = lock-false;
          "device.sensors.motion.enabled" = lock-false;
          "device.sensors.orientation.enabled" = lock-false;
          "device.sensors.proximity.enabled" = lock-false;
          "dom.battery.enabled" = lock-false;
          "dom.event.clipboardevents.enabled" = lock-false;
          "dom.webaudio.enabled" = lock-false;
          "experiments.activeExperiment" = lock-false;
          "experiments.enabled" = lock-false;
          "experiments.manifest.uri" = {
            Value = "";
            Status = "locked";
          };
          "experiments.supported" = lock-false;
          "extensions.ClearURLs@kevinr.whiteList" = {
            Value = "";
            Status = "locked";
          };
          "extensions.Decentraleyes@ThomasRientjes.whiteList" = {
            Value = "";
            Status = "locked";
          };
          "extensions.FirefoxMulti-AccountContainers@mozilla.whiteList" = {
            Value = "";
            Status = "locked";
          };
          "extensions.TemporaryContainers@stoically.whiteList" = {
            Value = "";
            Status = "locked";
          };
          "extensions.autoDisableScopes" = 14;
          "extensions.getAddons.cache.enabled" = lock-false;
          "extensions.getAddons.showPane" = lock-false;
          "extensions.greasemonkey.stats.optedin" = lock-false;
          "extensions.greasemonkey.stats.url" = {
            Value = "";
            Status = "locked";
          };
          "extensions.pocket.enabled" = lock-false;
          "extensions.shield-recipe-client.api_url" = {
            Value = "";
            Status = "locked";
          };
          "extensions.shield-recipe-client.enabled" = lock-false;
          "extensions.webservice.discoverURL" = {
            Value = "";
            Status = "locked";
          };
          "media.autoplay.default" = {
            Value = 0;
            Status = "locked";
          };
          "media.autoplay.enabled" = lock-true;
          "media.eme.enabled" = lock-false;
          "media.gmp-widevinecdm.enabled" = lock-false;
          "media.navigator.enabled" = lock-false;
          "media.peerconnection.enabled" = lock-false;
          "media.video_stats.enabled" = lock-false;
          "network.IDN_show_punycode" = lock-true;
          "network.allow-experiments" = lock-false;
          "network.captive-portal-service.enabled" = lock-false;
          "network.cookie.cookieBehavior" = {
            Value = 1;
            Status = "locked";
          };
          "network.dns.disablePrefetch" = lock-true;
          "network.dns.disablePrefetchFromHTTPS" = lock-true;
          "network.http.referer.spoofSource" = lock-true;
          "network.http.speculative-parallel-limit" = {
            Value = 0;
            Status = "locked";
          };
          "network.predictor.enable-prefetch" = lock-false;
          "network.predictor.enabled" = lock-false;
          "network.prefetch-next" = lock-false;
          "network.trr.mode" = {
            Value = 5;
            Status = "locked";
          };
          "privacy.donottrackheader.enabled" = lock-true;
          "privacy.donottrackheader.value" = {
            Value = 1;
            Status = "locked";
          };
          "privacy.firstparty.isolate" = lock-true;
          "privacy.query_stripping" = lock-true;
          "privacy.trackingprotection.cryptomining.enabled" = lock-true;
          "privacy.trackingprotection.enabled" = lock-true;
          "privacy.trackingprotection.fingerprinting.enabled" = lock-true;
          "privacy.trackingprotection.pbmode.enabled" = lock-true;
          "privacy.usercontext.about_newtab_segregation.enabled" = lock-true;
          "security.ssl.disable_session_identifiers" = lock-true;
          "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSite" = lock-false;
          "signon.autofillForms" = lock-false;
          "toolkit.telemetry.archive.enabled" = lock-false;
          "toolkit.telemetry.bhrPing.enabled" = lock-false;
          "toolkit.telemetry.cachedClientID" = {
            Value = "";
            Status = "locked";
          };
          "toolkit.telemetry.enabled" = lock-false;
          "toolkit.telemetry.firstShutdownPing.enabled" = lock-false;
          "toolkit.telemetry.hybridContent.enabled" = lock-false;
          "toolkit.telemetry.newProfilePing.enabled" = lock-false;
          "toolkit.telemetry.prompted" = {
            Value = 2;
            Status = "locked";
          };
          "toolkit.telemetry.rejected" = lock-true;
          "toolkit.telemetry.reportingpolicy.firstRun" = lock-false;
          "toolkit.telemetry.server" = {
            Value = "";
            Status = "locked";
          };
          "toolkit.telemetry.shutdownPingSender.enabled" = lock-false;
          "toolkit.telemetry.unified" = lock-false;
          "toolkit.telemetry.unifiedIsOptIn" = lock-false;
          "toolkit.telemetry.updatePing.enabled" = lock-false;
          "webgl.renderer-string-override" = {
            Value = " ";
            Status = "locked";
          };
          "webgl.vendor-string-override" = {
            Value = " ";
            Status = "locked";
          };
        };

        ExtensionSettings = with builtins; let
          extension = shortId: uuid: {
            name = uuid;
            value = {
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
              installation_mode = "normal_installed";
            };
          };
        in
          listToAttrs [
            (extension "ublock-origin" "uBlock0@raymondhill.net")
            (extension "privacy-badger17" "jid1-MnnxcxisBPnSXQ@jetpack")
            (extension "1password-x-password-manager" "{d634138d-c276-4fc8-924b-40a0ea21d284}")
            (extension "firefox-color" "FirefoxColor@mozilla.com")
            (extension "multi-account-containers" "@testpilot-containers")
            (extension "temporary-containers" "{c607c8df-14a7-4f28-894f-29e8722976af}")
            (extension "styl-us" "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}")
            (extension "betterttv" "firefox@betterttv.net")
            (extension "decentraleyes" "jid1-BoFifL9Vbdl2zQ@jetpack")
            (extension "canvasblocker" "CanvasBlocker@kkapsner.de")
            (extension "clearurls" "{74145f27-f039-47ce-a470-a662b129930a}")
          ];
      };
    };
  };
}
