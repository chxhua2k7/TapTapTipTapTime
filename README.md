# TapTapTipTapTime

Tap on the time to see the date in the status bar!

A jailbreak tweak for iOS 15+ (rootless). Tap the clock in the status bar to toggle it into the current date — tap again to switch back to the time.

## Features

- Tap the status bar clock to toggle between time and date
- Time options: show/hide AM/PM, 24-hour time
- Date options: separator (`/`, `–`, `.`), show/hide year, day-before-month order
- Optional auto reset: the date switches back to the time after 10 seconds
- Preference pane in Settings with live updates (no respring needed, except for enable/disable)

## Compatibility

- iOS 15.0+
- Rootless jailbreaks (Dopamine, palera1n, etc.)
- `arm64` / `arm64e`

## Building

Requires [Theos](https://theos.dev) with an iOS SDK.

```sh
export THEOS=~/theos
make package FINALPACKAGE=1
```

The `.deb` is produced in `packages/`. To build and install directly onto a device over SSH:

```sh
make install THEOS_DEVICE_IP=<device ip>
```

## Project structure

| Path | Description |
| --- | --- |
| `Tweak.x` | SpringBoard hook (`_UIStatusBarTimeItem`) that swaps the time string for the date |
| `TapTapTipTapTime.plist` | MobileSubstrate filter (injects into SpringBoard only) |
| `TapTapTipTapTimePreferences/` | PreferenceBundle for the Settings pane |
| `control` | Debian package metadata |

Preferences are stored in `/var/mobile/Library/Preferences/com.yulkytulky.taptaptiptaptime.plist` and applied live via Darwin notifications.

## Credits

Developed by [YulkyTulky](https://github.com/YulkyTulky) & [Dimitar Nestorov](https://github.com/dimitarnestorov) | 2020

- [Source code](https://github.com/YulkyTulky/TapTapTipTapTime)
- [Discord server](https://discord.gg/gbzhzV)
