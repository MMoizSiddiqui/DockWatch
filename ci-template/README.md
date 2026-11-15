# DockWatch CI gate: guide

Add DockWatch to **your own** GitHub repository so that every change to a compose file or a Dockerfile is checked automatically, with no one having to remember to run a scan.

You copy **one file**, `dockwatch.yml`, and that's it. You don't copy DockWatch itself: GitHub downloads and installs it on its own servers each time the check runs. All settings live inside that one file.

## What happens once it is set up

```
Someone pushes a change to docker-compose.yml (or a Dockerfile)
        │
        ▼
GitHub starts a temporary cloud computer, installs DockWatch, and scans your project
        │
        ├── risk score within your limit   →  ✅ green tick
        │
        └── risk score ABOVE your limit    →  ❌ red X
                                              GitHub emails the person who pushed
```

- It takes about 1 to 2 minutes.
- It **never changes or undoes anything** in your repository. It only reports.
- Each run shows a summary (PASS/FAIL and the main findings) and attaches the full HTML report.

---

## Step 1: add the file

The file must be at this exact path in your repository:

```
your-repo/
└── .github/            ← starts with a dot
    └── workflows/      ← exactly this name
        └── dockwatch.yml
```

**Easiest, in the browser:**

1. Open your repository on GitHub and click **Add file → Create new file**.
2. In the name box type `.github/workflows/dockwatch.yml`. Typing the `/` creates the folders.
3. Paste the contents of [`dockwatch.yml`](dockwatch.yml).
4. Click **Commit changes**.

**Or on your computer:** create the two folders, save the file there, then commit and push it.

The first check starts as soon as the file is committed. Open the **Actions** tab to watch it.

---

## Step 2: change the settings (optional)

The settings are at the top of `dockwatch.yml`, in the block marked **YOUR SETTINGS**. Every setting has a short explanation right above it in the file.

**To change a setting:**

1. On GitHub, open `.github/workflows/dockwatch.yml` in your repository.
2. Click the ✏️ pencil icon (Edit).
3. Change the value between the quotes.
4. Click **Commit changes**.

That's all. The check re-runs immediately with the new settings, and every later push uses them automatically.

| Setting | What it does | Default | Examples |
|---|---|---|---|
| `PROJECT_DIR` | Folder that contains your compose file, relative to the repository root | `"."` (the root) | `"deploy"`, `"infra/docker"` |
| `FAIL_THRESHOLD` | The check fails when the highest risk score (0 to 100) is **above** this number | `""` (means **70**) | `"60"` stricter, `"85"` more relaxed |
| `MIN_SEVERITY` | Hide findings below this severity | `""` (show everything) | `"low"`, `"medium"`, `"high"`, `"critical"` |
| `SCAN_IMAGES` | Also scan container images for known CVEs (Trivy image) and CIS checks (Dockle). Slower, because images are downloaded | `"false"` | `"true"` |
| `SKIP_SCANNERS` | Scanners to switch off, separated by spaces | `""` (run all) | `"hadolint"`, `"hadolint trivy"` |
| `AUTO_UPDATE_SCANNERS` | Use the newest scanner versions that work with DockWatch (see below) | `"true"` | `"false"` = always the same tested versions |
| `SCAN_PATIENCE` | How long DockWatch waits on a scanner (see below) | `"default"` | `"custom"` = use the two values below |
| `STALL_MINUTES` | Custom only: minutes without ANY activity before a stuck scanner is stopped (1 to 15) | `"3"` | `"5"` for a very slow network, `"1"` to fail fast |
| `MAX_MINUTES` | Custom only: absolute limit for one file or image, in minutes (10 to 240) | `"60"` | `"120"` for very large images |

Below that block, `DOCKWATCH_VERSION` chooses which DockWatch release the check downloads: `"latest"` (the default) or a fixed version such as `"1.0.0"`, if your team wants the same DockWatch on every run. Leave `DOCKWATCH_REPO` as it is.

**Scanner updates:** every run installs the scanner versions DockWatch was tested with, then (with `AUTO_UPDATE_SCANNERS: "true"`) checks GitHub for newer Hadolint and Trivy releases. A newer version is downloaded, verified against its published checksum, and **tested on a built-in sample** first. If it works, the run uses it and shows a ✅ note. If it doesn't work correctly with DockWatch, the run keeps the tested version, shows a ⚠️ warning explaining why, and adds an **Ask the developer to support it** link to the run's summary. Your result is never affected by a broken scanner release. Set `"false"` if your team wants identical scanner versions on every run.

**Example:** to make the check stricter, change

```yaml
  FAIL_THRESHOLD: ""
```

to

```yaml
  FAIL_THRESHOLD: "60"
```

and commit. From then on, any change that pushes the risk score above 60 gets a ❌.

**Rules:** keep the quotes, and spell values exactly as shown. A wrong value doesn't break anything: the check stops with **⚠️ ERROR** and names the setting to fix.

**What the risk score means:** DockWatch scores each service from 0 to 100 for "how bad would it be if an attacker took over this service". The score is based on what the service can reach, whether it is exposed to the outside, what it holds (Docker socket, privileged mode, passwords), and the scanners' findings. The check uses the **highest** service score. The default limit of 70 matches the start of the "High" band in CVSS, the standard vulnerability severity scale.

**Scan patience:** DockWatch watches every scanner while it runs (CPU, data, output). A scanner that is working is **never stopped for being slow**. With `"default"`, a scanner that does nothing at all for 3 minutes is stopped as stuck, and 60 minutes per file or image is the absolute limit. Anything stopped is listed in the run's summary and report as NOT SCANNED, with the reason, and the summary starts with a **Coverage** line (COMPLETE or INCOMPLETE).

**Image scanning note:** with `SCAN_IMAGES: "true"`, images pulled from a registry (for example `postgres:16`) are scanned. Images that your compose file builds itself (`build:`) don't exist on the cloud computer, so they are reported as skipped. Their Dockerfile is still checked by Hadolint and Trivy.

---

## Reading the result

| Where | What you see |
|---|---|
| Next to the commit or on the pull request | ✅ or ❌ **DockWatch security gate** |
| **Actions** tab → the run | Summary: PASS/FAIL, risk score, attack paths, next step |
| **Actions** tab → the run → **Artifacts** | `dockwatch-report`: the full HTML report, the SARIF file and the text output |
| **Security** tab → **Code scanning** | Each finding with the file and line. Free on public repositories; private ones need GitHub Advanced Security, otherwise this part is skipped without failing the check |

**To fix a ❌:** open your project in the DockWatch app. It shows the same score, the attack paths, and fixes you can preview and apply with one click. Commit the fixed compose file and the check turns ✅.

**To make a ❌ block merging** (optional, a GitHub setting): in your repository go to **Settings → Branches → Add branch protection rule**, choose your main branch, turn on **Require status checks to pass before merging**, and select `dockwatch`. The check must have run once before it appears in the list.

## Common problems

| Message | Meaning and fix |
|---|---|
| ⚠️ ERROR … `No compose file found` | `PROJECT_DIR` points to the wrong folder. It must contain `compose.yml`, `compose.yaml`, `docker-compose.yml` or `docker-compose.yaml` |
| ⚠️ ERROR … `invalid scan patience` | `STALL_MINUTES` or `MAX_MINUTES` is outside its range (1 to 15, and 10 to 240) |
| ⚠️ ERROR … `invalid choice: 'hgh'` | A setting is misspelled, for example `MIN_SEVERITY: "hgh"`. The message lists the allowed values |
| The check does not start | The file is not at exactly `.github/workflows/dockwatch.yml`, or the push didn't change a compose file, a Dockerfile or `dockwatch.yml`. Use **Actions → DockWatch security gate → Run workflow** to start it by hand |
| `Install DockWatch` step fails with `404` | The download comes from the DockWatch **Releases** page. Leave `DOCKWATCH_REPO` as `MMoizSiddiqui/DockWatch`; if `DOCKWATCH_VERSION` is a fixed number such as `"1.0.0"`, that release must exist (or use `"latest"`) |
| `Install DockWatch` says the checksum did not match | The download was damaged or changed on the way, so it was not used. Re-run the job; if it keeps failing, [open an issue](https://github.com/MMoizSiddiqui/DockWatch/issues) |
