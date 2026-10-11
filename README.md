# Gym Planner

Gym Planner is a simple workout companion for restarting gym training. It is designed around dumbbells, with occasional barbell options, focused sessions, and a practical 45-minute target. The project includes a native SwiftUI app for iPhone and Mac plus an installable web app.

## What is included

- **Foundation:** a three-session Push, Pull + Hinge, Legs + Core rotation for easing back into training.
- **Advanced:** focused sessions for chest, back, shoulders, biceps, triceps, forearms, and lower body.
- **Planner:** a configurable seven-day week with exercise selection and optional rest days. The suggested week places lower body on Friday.
- **Workout companion:** set guidance, rest timer, exercise cues, skip controls, and local workout history.
- **Offline-minded storage:** the native app stores the plan and history on the device. The web app stores them in that browser on that device; neither version has a sign-in or cloud sync.

The workouts are suggestions, not medical advice. Begin with a manageable load, use controlled form, and stop if you feel sharp pain, dizziness, or anything concerning.

## Run the native app

1. Open `GymReset/GymReset.xcodeproj` in Xcode on a Mac.
2. Choose an iPhone simulator, a connected iPhone, or **My Mac** as the run destination.
3. For a physical iPhone, choose your development team under **Signing & Capabilities**.
4. Press **Run**.

The project currently targets iOS 17 and macOS 14 or later. Personal installation on an iPhone can use a free Apple ID with Xcode; App Store distribution requires separate Apple Developer Program enrollment.

## Use the web app

Open `Web/index.html` locally or host the contents of `Web/` on a static HTTPS host. Add it to the Home Screen from Safari to use its installable app experience. Browser data is separate from the native app and is not synced between devices.

## Verify locally

```sh
node scripts/check-web.mjs
xcodebuild -project GymReset/GymReset.xcodeproj -scheme GymReset -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
xcodebuild -project GymReset/GymReset.xcodeproj -scheme GymReset -destination 'generic/platform=macOS' CODE_SIGNING_ALLOWED=NO build
```

GitHub Actions runs the same checks for pull requests and updates to `main`. Changes should go through a pull request, and the CI build should pass before merging. Main-branch protection is not enabled yet; an owner can require pull requests and the `Build and verify` check in repository settings when the GitHub plan supports it.

## Repository layout

- `GymReset/`: SwiftUI app, Xcode project, icons, and credits.
- `Web/`: standalone web app, manifest, icons, and service worker.
- `scripts/check-web.mjs`: syntax and manifest checks for the web app.
- `.github/workflows/ci.yml`: iOS, macOS, and web CI.
