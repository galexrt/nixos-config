{ inputs, config, pkgs, ... }:

{
  home-manager.users.atrost = {
    # Import the home manager module
    imports = [
      inputs.noctalia.homeModules.default
    ];

    home.packages = with pkgs; [
      gpu-screen-recorder
    ];

    # Configure profile picture and wallpaper
    home.file."noctalia-face" = {
      executable = true;
      source = ../../assets/.face;
      target = ".face";
    };

    home.file.".cache/noctalia/wallpapers.json" = {
      text = builtins.toJSON {
        defaultWallpaper = "/home/atrost/Pictures/Wallpapers/eva-red-steel.jpg";
        wallpapers = {
          "eDP-1" = "/home/atrost/Pictures/Wallpapers/eva-red-steel.jpg";
          "eDP-2" = "/home/atrost/Pictures/Wallpapers/eva-red-steel.jpg";
        };
      };
    };

    # Configure options
    programs.noctalia-shell = {
      enable = true;

      systemd.enable = false;

      plugins = {
        sources = [
          {
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
        ];

        states = {
          screen-recorder = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
        };
        version = 1;
      };

      settings = {
        appLauncher = {
          autoPasteClipboard = false;
          clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
          clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
          clipboardWrapText = true;
          customLaunchPrefix = "";
          customLaunchPrefixEnabled = false;
          enableClipPreview = true;
          enableClipboardHistory = false;
          enableSettingsSearch = true;
          enableWindowsSearch = true;
          iconMode = "tabler";
          ignoreMouseInput = false;
          pinnedApps = [

          ];
          position = "bottom_center";
          screenshotAnnotationTool = "";
          showCategories = true;
          showIconBackground = false;
          sortByMostUsed = true;
          terminalCommand = "wezterm -e";
          useApp2Unit = false;
          viewMode = "list";
        };
        audio = {
          cavaFrameRate = 30;
          mprisBlacklist = [

          ];
          preferredPlayer = "";
          visualizerType = "linear";
          volumeFeedback = false;
          volumeOverdrive = false;
          volumeStep = 5;
        };
        bar = {
          autoHideDelay = 500;
          autoShowDelay = 150;
          backgroundOpacity = 0.65;
          barType = "simple";
          capsuleOpacity = 0.95;
          density = "compact";
          displayMode = "always_visible";
          floating = false;
          frameRadius = 12;
          frameThickness = 8;
          hideOnOverview = false;
          marginHorizontal = 4;
          marginVertical = 4;
          monitors = [

          ];
          outerCorners = true;
          position = "bottom";
          screenOverrides = [

          ];
          showCapsule = true;
          showOutline = false;
          useSeparateOpacity = false;
          widgets = {
            center = [
              {
                characterCount = 2;
                colorizeIcons = false;
                emptyColor = "secondary";
                enableScrollWheel = true;
                focusedColor = "primary";
                followFocusedScreen = false;
                groupedBorderOpacity = 1;
                hideUnoccupied = true;
                iconScale = 0.8;
                id = "Workspace";
                labelMode = "index";
                occupiedColor = "secondary";
                pillSize = 0.6;
                reverseScroll = false;
                showApplications = true;
                showBadge = true;
                showLabelsOnlyWhenOccupied = false;
                unfocusedIconsOpacity = 1;
              }
            ];
            left = [
              {
                compactMode = false;
                diskPath = "/";
                id = "SystemMonitor";
                showCpuFreq = true;
                showCpuTemp = true;
                showCpuUsage = true;
                showDiskAvailable = true;
                showDiskUsage = true;
                showDiskUsageAsPercent = false;
                showGpuTemp = false;
                showLoadAverage = true;
                showMemoryAsPercent = true;
                showMemoryUsage = true;
                showNetworkStats = false;
                showSwapUsage = false;
                useMonospaceFont = true;
                usePrimaryColor = false;
              }
              {
                displayMode = "alwaysShow";
                id = "Brightness";
              }
              {
                id = "NightLight";
              }
              {
                displayMode = "alwaysShow";
                id = "PowerProfile";
              }
              {
                colorName = "primary";
                hideWhenIdle = false;
                id = "AudioVisualizer";
                width = 125;
              }
              {
                compactMode = false;
                compactShowAlbumArt = true;
                compactShowVisualizer = false;
                hideMode = "hidden";
                hideWhenIdle = false;
                id = "MediaMini";
                maxWidth = 145;
                panelShowAlbumArt = true;
                panelShowVisualizer = true;
                scrollingMode = "hover";
                showAlbumArt = true;
                showArtistFirst = true;
                showProgressRing = true;
                showVisualizer = false;
                useFixedWidth = false;
                visualizerType = "linear";
              }
              {
                defaultSettings = {
                  audioCodec = "opus";
                  audioSource = "default_output";
                  colorRange = "limited";
                  copyToClipboard = false;
                  directory = "";
                  filenamePattern = "recording_yyyyMMdd_HHmmss";
                  frameRate = "60";
                  hideInactive = false;
                  quality = "very_high";
                  resolution = "original";
                  showCursor = true;
                  videoCodec = "h264";
                  videoSource = "portal";
                };
                id = "plugin:screen-recorder";
              }
            ];
            right = [
              {
                displayMode = "alwaysShow";
                id = "Network";
              }
              {
                compactMode = false;
                diskPath = "/";
                id = "SystemMonitor";
                showCpuFreq = false;
                showCpuTemp = false;
                showCpuUsage = false;
                showDiskAvailable = false;
                showDiskUsage = false;
                showDiskUsageAsPercent = false;
                showGpuTemp = false;
                showLoadAverage = false;
                showMemoryAsPercent = false;
                showMemoryUsage = false;
                showNetworkStats = true;
                showSwapUsage = false;
                useMonospaceFont = true;
                usePrimaryColor = false;
              }
              {
                deviceNativePath = "__default__";
                displayMode = "alwaysShow";
                hideIfIdle = false;
                hideIfNotDetected = true;
                id = "Battery";
                showNoctaliaPerformance = false;
                showPowerProfiles = true;
                warningThreshold = 30;
              }
              {
                id = "KeepAwake";
              }
              {
                displayMode = "onhover";
                id = "Bluetooth";
              }
              {
                hideWhenZero = false;
                hideWhenZeroUnread = false;
                id = "NotificationHistory";
                showUnreadBadge = true;
                unreadBadgeColor = "primary";
              }
              {
                displayMode = "alwaysShow";
                id = "Volume";
                middleClickCommand = "pwvucontrol || pavucontrol";
              }
              {
                blacklist = [

                ];
                colorizeIcons = false;
                drawerEnabled = false;
                hidePassive = false;
                id = "Tray";
                pinned = [

                ];
              }
              {
                customFont = "";
                formatHorizontal = "HH:mm ddd dd.MM.yyyy";
                formatVertical = "HH mm - dd MM";
                id = "Clock";
                tooltipFormat = "HH:mm ddd, MMM dd";
                useCustomFont = false;
                usePrimaryColor = false;
              }
              {
                colorName = "error";
                id = "SessionMenu";
              }
            ];
          };
        };
        brightness = {
          brightnessStep = 5;
          enableDdcSupport = false;
          enforceMinimum = true;
        };
        calendar = {
          cards = [
            {
              enabled = true;
              id = "calendar-header-card";
            }
            {
              enabled = true;
              id = "calendar-month-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
          ];
        };
        colorSchemes = {
          darkMode = true;
          generationMethod = "faithful";
          manualSunrise = "06:30";
          manualSunset = "18:30";
          monitorForColors = "";
          predefinedScheme = "Occult Umbral";
          schedulingMode = "off";
          useWallpaperColors = false;
        };
        controlCenter = {
          cards = [
            {
              enabled = true;
              id = "profile-card";
            }
            {
              enabled = true;
              id = "shortcuts-card";
            }
            {
              enabled = true;
              id = "audio-card";
            }
            {
              enabled = true;
              id = "brightness-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
            {
              enabled = true;
              id = "media-sysmon-card";
            }
          ];
          diskPath = "/";
          position = "close_to_bar_button";
          shortcuts = {
            left = [
              {
                id = "Network";
              }
              {
                id = "Bluetooth";
              }
              {
                id = "WallpaperSelector";
              }
              {
                id = "NoctaliaPerformance";
              }
              {
                defaultSettings = {
                  audioCodec = "opus";
                  audioSource = "default_output";
                  colorRange = "limited";
                  copyToClipboard = false;
                  directory = "";
                  filenamePattern = "recording_yyyyMMdd_HHmmss";
                  frameRate = "60";
                  hideInactive = false;
                  quality = "very_high";
                  resolution = "original";
                  showCursor = true;
                  videoCodec = "h264";
                  videoSource = "portal";
                };
                id = "plugin:screen-recorder";
              }
            ];
            right = [
              {
                id = "Notifications";
              }
              {
                id = "PowerProfile";
              }
              {
                id = "KeepAwake";
              }
              {
                id = "NightLight";
              }
            ];
          };
        };
        desktopWidgets = {
          enabled = false;
          gridSnap = false;
          monitorWidgets = [

          ];
        };
        dock = {
          animationSpeed = 1;
          backgroundOpacity = 1;
          colorizeIcons = false;
          deadOpacity = 0.6;
          displayMode = "auto_hide";
          enabled = true;
          floatingRatio = 1;
          inactiveIndicators = false;
          monitors = [

          ];
          onlySameOutput = true;
          pinnedApps = [

          ];
          pinnedStatic = false;
          position = "bottom";
          size = 1;
        };
        general = {
          allowPanelsOnScreenWithoutBar = true;
          allowPasswordWithFprintd = false;
          animationDisabled = true;
          animationSpeed = 1;
          autoStartAuth = false;
          avatarImage = "/home/atrost/.face";
          boxRadiusRatio = 1;
          compactLockScreen = false;
          dimmerOpacity = 0.2;
          enableLockScreenCountdown = true;
          enableShadows = true;
          forceBlackScreenCorners = false;
          iRadiusRatio = 1;
          language = "";
          lockOnSuspend = true;
          lockScreenCountdownDuration = 3000;
          radiusRatio = 1;
          scaleRatio = 1;
          screenRadiusRatio = 1;
          shadowDirection = "bottom_right";
          shadowOffsetX = 2;
          shadowOffsetY = 3;
          showChangelogOnStartup = false;
          showHibernateOnLockScreen = true;
          showScreenCorners = false;
          showSessionButtonsOnLockScreen = true;
          telemetryEnabled = false;
        };
        hooks = {
          darkModeChange = "";
          enabled = false;
          performanceModeDisabled = "";
          performanceModeEnabled = "";
          screenLock = "";
          screenUnlock = "";
          session = "";
          startup = "";
          wallpaperChange = "";
        };
        location = {
          analogClockInCalendar = false;
          firstDayOfWeek = -1;
          hideWeatherCityName = false;
          hideWeatherTimezone = false;
          name = "Karlsruhe, Germany";
          showCalendarEvents = true;
          showCalendarWeather = true;
          showWeekNumberInCalendar = true;
          use12hourFormat = false;
          useFahrenheit = false;
          weatherEnabled = true;
          weatherShowEffects = true;
        };
        network = {
          bluetoothDetailsViewMode = "grid";
          bluetoothHideUnnamedDevices = false;
          bluetoothRssiPollIntervalMs = 10000;
          bluetoothRssiPollingEnabled = false;
          wifiDetailsViewMode = "grid";
          wifiEnabled = true;
        };
        nightLight = {
          autoSchedule = true;
          dayTemp = "6500";
          enabled = true;
          forced = false;
          manualSunrise = "06:30";
          manualSunset = "18:30";
          nightTemp = "4000";
        };
        notifications = {
          backgroundOpacity = 1;
          criticalUrgencyDuration = 15;
          enableKeyboardLayoutToast = true;
          enableMediaToast = false;
          enabled = true;
          location = "top_right";
          lowUrgencyDuration = 3;
          monitors = [

          ];
          normalUrgencyDuration = 8;
          overlayLayer = true;
          respectExpireTimeout = false;
          saveToHistory = {
            critical = true;
            low = true;
            normal = true;
          };
          sounds = {
            criticalSoundFile = "";
            enabled = false;
            excludedApps = "discord,firefox,chrome,chromium,edge";
            lowSoundFile = "";
            normalSoundFile = "";
            separateSounds = false;
            volume = 0.5;
          };
        };
        osd = {
          autoHideMs = 2000;
          backgroundOpacity = 1;
          enabled = true;
          enabledTypes = [
            0
            1
            2
          ];
          location = "top_right";
          monitors = [

          ];
          overlayLayer = true;
        };
        sessionMenu = {
          countdownDuration = 10000;
          enableCountdown = true;
          largeButtonsLayout = "single-row";
          largeButtonsStyle = true;
          position = "center";
          powerOptions = [
            {
              action = "lock";
              enabled = true;
            }
            {
              action = "suspend";
              enabled = true;
            }
            {
              action = "hibernate";
              enabled = true;
            }
            {
              action = "reboot";
              enabled = true;
            }
            {
              action = "logout";
              enabled = true;
            }
            {
              action = "shutdown";
              enabled = true;
            }
          ];
          showHeader = true;
          showNumberLabels = true;
        };
        settingsVersion = 47;
        systemMonitor = {
          cpuCriticalThreshold = 90;
          cpuPollingInterval = 1000;
          cpuWarningThreshold = 80;
          criticalColor = "";
          diskAvailCriticalThreshold = 10;
          diskAvailWarningThreshold = 20;
          diskCriticalThreshold = 90;
          diskPollingInterval = 30000;
          diskWarningThreshold = 80;
          enableDgpuMonitoring = false;
          externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
          gpuCriticalThreshold = 90;
          gpuPollingInterval = 3000;
          gpuWarningThreshold = 80;
          loadAvgPollingInterval = 3000;
          memCriticalThreshold = 90;
          memPollingInterval = 1000;
          memWarningThreshold = 80;
          networkPollingInterval = 1000;
          swapCriticalThreshold = 90;
          swapWarningThreshold = 80;
          tempCriticalThreshold = 90;
          tempWarningThreshold = 80;
          useCustomColors = false;
          warningColor = "";
        };
        templates = {
          activeTemplates = [

          ];
          enableUserTheming = false;
        };
        ui = {
          bluetoothDetailsViewMode = "grid";
          bluetoothHideUnnamedDevices = false;
          boxBorderEnabled = false;
          fontDefault = "Sans Serif";
          fontDefaultScale = 1;
          fontFixed = "monospace";
          fontFixedScale = 1;
          networkPanelView = "wifi";
          panelBackgroundOpacity = 0.65;
          panelsAttachedToBar = true;
          settingsPanelMode = "attached";
          tooltipsEnabled = true;
          wifiDetailsViewMode = "grid";
        };
        wallpaper = {
          automationEnabled = false;
          directory = "/home/atrost/Pictures/Wallpapers";
          enableMultiMonitorDirectories = false;
          enabled = true;
          fillColor = "#000000";
          fillMode = "crop";
          hideWallpaperFilenames = false;
          monitorDirectories = [

          ];
          overviewEnabled = false;
          panelPosition = "follow_bar";
          randomIntervalSec = 300;
          setWallpaperOnAllMonitors = true;
          showHiddenFiles = false;
          solidColor = "#1a1a2e";
          sortOrder = "name";
          transitionDuration = 1500;
          transitionEdgeSmoothness = 0.05;
          transitionType = "random";
          useSolidColor = false;
          useWallhaven = false;
          viewMode = "recursive";
          wallhavenApiKey = "";
          wallhavenCategories = "111";
          wallhavenOrder = "desc";
          wallhavenPurity = "100";
          wallhavenQuery = "";
          wallhavenRatios = "";
          wallhavenResolutionHeight = "";
          wallhavenResolutionMode = "atleast";
          wallhavenResolutionWidth = "";
          wallhavenSorting = "relevance";
          wallpaperChangeMode = "alphabetical";
        };
      };
    };
  };
}
