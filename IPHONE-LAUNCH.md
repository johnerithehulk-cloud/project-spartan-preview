# Project Spartan: first iPhone deployment

Status: **not live** until index.html and both PNG icons are committed and GitHub Pages is enabled.

## Upload the remaining three files
1. Download `project-spartan-github-remaining-files.zip` from the ATLAS conversation and unzip it on your computer.
2. Open this GitHub repository and choose **Add file → Upload files** on the default branch.
3. Upload `index.html` to the repository root.
4. Create/open an `icons` folder and upload `icon-192.png` and `icon-512.png` into it. Preserve filenames and capitalization.
5. Confirm these files exist: `index.html`, `manifest.webmanifest`, `sw.js`, `.nojekyll`, `icons/icon-192.png`, `icons/icon-512.png`.

## Turn on Pages
In **Settings → Pages**, under Build and deployment choose **Deploy from a branch**, default branch, folder **/(root)**, then Save. Wait for the deployment status to report success.

Expected URL (not verified live): https://johnerithehulk-cloud.github.io/project-spartan-preview/

## iPhone acceptance test
1. Open the actual HTTPS URL in Safari. Confirm the workout screen loads.
2. Log one clearly marked **TEST** set for Chris, reload Safari, confirm it remains.
3. Switch to Julie, confirm no Chris test set appears in Julie's history.
4. Use Safari Share → Add to Home Screen; open the installed app.
5. Check storage persistence after closing and reopening, and test an offline reopen.
6. Export a backup and verify the file appears in Files.
7. Remove the test set before real workouts.

**Safety:** This is a public code repository, not a private workout-data store. Never commit real workouts, notes, credentials, or backups. Workout records are stored locally in the browser. No automatic sync or guaranteed backup.

**Release target:** v5.7. Do not consider iPhone readiness verified until the real-device checklist passes.
