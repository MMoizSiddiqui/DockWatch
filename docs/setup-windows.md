# DockWatch on Windows: setup

For **Windows 10 and 11, 64-bit**. No installer, no Python, no administrator rights.
(Windows 7, 8 and 32-bit Windows are not supported.)

## Install (2 minutes)

1. **Download** `DockWatch-1.0.0-windows-x64.zip` from the [Releases page](https://github.com/MMoizSiddiqui/DockWatch/releases/latest), or from the [`downloads`](../downloads) folder of this repository.
2. **Right-click the zip → Extract All…**, for example into `Documents\DockWatch`.
   Don't run it from inside the zip: DockWatch needs the `engine` folder next to it.
3. **Double-click `DockWatch.exe`** in the extracted folder.
4. If Windows says *"Windows protected your PC"* (SmartScreen, because DockWatch is new): click **More info → Run anyway**.

## First start

5. A **DockWatch setup** window appears and downloads the scanners (Hadolint and Trivy, about 140 MB). Each file is checked against its SHA-256 checksum. If something fails, the window says why; press **Retry**.
6. Your browser opens **http://127.0.0.1:8765/** with the DockWatch dashboard. A small black **DockWatch** window stays open in the background.

## Use it

7. On the **Home** page, click **📁 Browse…**, choose the folder that contains your `docker-compose.yml`, and press **Open & scan**. Or try the included demo: the `dockertestfile` folder.
8. Follow the scan window, then read **Overview → Attack graph → Fixes**. Saving your compose file or a Dockerfile re-scans by itself.
9. **To stop DockWatch**, close the black DockWatch window. **To start it again**, double-click `DockWatch.exe`; your recent projects are listed on the Home page.

## Update

Download the newer zip, extract it into a new folder, and start the new `DockWatch.exe`. Your settings, history and scanners are kept: they live in your project folders and in `%LOCALAPPDATA%\DockWatch`, not in the program folder. You can then delete the old program folder.

## Uninstall

1. Close DockWatch.
2. Delete the program folder.
3. Optionally, delete `%LOCALAPPDATA%\DockWatch` (scanners, recent projects, logs) and the `.dockwatch` folder inside each project you scanned.

## Optional

| Install | For |
|---|---|
| [Docker Desktop](https://www.docker.com/products/docker-desktop/) | The image scanners (Trivy image, Dockle): turn them on in ⚙ Settings |
| [Git](https://git-scm.com/download/win) | The git timeline on the History page |

## Problems?

| What you see | What to do |
|---|---|
| The setup window shows an error | Read its *What to do* box; most often the internet connection or a proxy blocks GitHub. Press **Retry**. Log: `%LOCALAPPDATA%\DockWatch\setup.log` |
| "Port 8765 is already used" | DockWatch is probably already running: look for the black window. Otherwise close the other program, or restart the computer |
| Nothing happens on double-click | Extract the **whole** zip first; `DockWatch.exe` needs the `engine` folder |
| An antivirus removed a file | Restore it or allow the DockWatch folder, then extract the zip again |

More: [README](../README.md) · [open an issue](https://github.com/MMoizSiddiqui/DockWatch/issues)
