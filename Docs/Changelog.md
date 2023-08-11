# 📰 Changelog

## Brainflip Beta 0.7.2
 
 - Added Flow as a dependency, which eliminates some code repetition.
 - Brainflip-to-C conversion *should* be imperceptibly faster.
 - The pointer and array name fields in the export settings did not correctly validate input as legal C identifiers. This has been fixed.
 - When invalid names are entered in the export settings, a warning icon appears. Clicking it will reveal a popover telling you about C identifier rules.
 - I don't know why, but the app's performance has increased significantly.

## Brainflip Beta 0.7.1

 - Removed SwiftLint dependency in favor of a simple Run Script build phase. Note that this means you will need to have SwiftLint installed on your system to get a warning-free build.
 - Removed logger messages caused by resetting settings.
 - Renamed the Quick Look extension from BFQuickLook to Brainflip Quick Look.
 - Fixed a bug where the preview in the export settings did not refresh when changing said settings.

## Brainflip Beta 0.7

 - Not much has changed on the surface, but some major refactoring has been done under the hood.

## Brainflip Alpha 0.6

 - Initial release
