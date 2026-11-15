# DockWatch on Linux: setup

One download works on **64-bit Linux (x86_64)** with glibc 2.31 or newer. That includes Ubuntu 20.04+, Debian 11+, Linux Mint 20+, Fedora, RHEL / Rocky / Alma 9+ and openSUSE Leap 15.6.
Tested on Ubuntu 20.04 and 24.04, Debian 11, Fedora 41, Rocky 9 and openSUSE 15.6. Not supported: ARM (Raspberry Pi) and Alpine (musl).

Pick your setup:

| Your Linux | Follow |
|---|---|
| A **Linux desktop**: a PC, or a VM with a desktop in VMware / VirtualBox / Hyper-V | [A. Desktop or VM with a desktop](#a-desktop-or-vm-with-a-desktop) |
| A **server or VM without a desktop**, used over SSH (also company servers) | [B. Server or headless VM](#b-server-or-headless-vm-view-the-dashboard-from-your-pc) |
| Only the command line, e.g. in a script or pipeline | [C. Command line only](#c-command-line-only) |

---

## A. Desktop or VM with a desktop

1. **Download and extract** in a terminal:
   ```bash
   cd ~
   wget https://github.com/MMoizSiddiqui/DockWatch/releases/latest/download/dockwatch-engine-linux-x86_64.tar.gz
   tar -xzf dockwatch-engine-linux-x86_64.tar.gz
   ```
   (No `wget`? Use `curl -LO <same link>`, or download the file in your browser from [Releases](https://github.com/MMoizSiddiqui/DockWatch/releases/latest) or the [`downloads`](../downloads) folder.)
2. **Start DockWatch:**
   ```bash
   cd ~/dockwatch-engine
   ./start-dockwatch
   ```
   The **first time**, it downloads and verifies the scanners (Hadolint, Trivy, Dockle, about 120 MB). Your browser then opens **http://127.0.0.1:8765/**. If it doesn't, open that address yourself.
3. **Open a project:** on the Home page, **paste the full path** of the folder that contains your `docker-compose.yml` (for example `/home/you/projects/shop`) and press **Open & scan**. On Linux there is no Browse button. You can also start directly with a project: `./start-dockwatch /home/you/projects/shop`.
4. **To stop**, press **Ctrl+C** in the terminal. **To start again**, run `./start-dockwatch`; recent projects are listed on the Home page.

**Try the demo:** the `dockertestfile` folder of this repository is a deliberately vulnerable stack. Download the repository (green **Code → Download ZIP**, or `git clone`) and open its `dockertestfile` folder. To start the demo over, run `sh dockertestfile/reset-demo.sh`.

---

## B. Server or headless VM: view the dashboard from your PC

DockWatch's dashboard only listens on the machine itself (`127.0.0.1`). It has no login, so it is never opened to the network. You reach it safely through an **SSH tunnel**: your PC forwards a local port to the server over your normal SSH connection.

On the **server** (over SSH):

1. Download and extract, as in A1.
2. Start DockWatch with your project:
   ```bash
   cd ~/dockwatch-engine
   ./start-dockwatch /path/to/your/project
   ```
   Leave it running. (To keep it running after you log out: `nohup ./start-dockwatch /path/to/project > ~/dockwatch.log 2>&1 &`, or use `tmux` / `screen`.)

On **your PC** (Windows PowerShell, macOS or Linux terminal; OpenSSH is built into Windows 10/11):

3. Open the tunnel, using the address you normally SSH to:
   ```bash
   ssh -N -L 8765:127.0.0.1:8765 you@your-server
   ```
   It shows nothing and keeps running; that's normal. (PuTTY: *Connection → SSH → Tunnels*, source port `8765`, destination `127.0.0.1:8765`, **Add**.)
4. Open **http://127.0.0.1:8765/** in your PC's browser. You now use the dashboard of the server.
5. When finished, press **Ctrl+C** in both windows.

> **VirtualBox / VMware tip:** for a local VM, use the VM's IP address (`ip addr` inside the VM), or set up port forwarding for SSH in the VM's network settings (e.g. host port 2222 → guest port 22), then `ssh -N -L 8765:127.0.0.1:8765 -p 2222 you@127.0.0.1`.

---

## C. Command line only

```bash
cd ~/dockwatch-engine
./dockwatch-engine setup                                       # once: install the scanners
./dockwatch-engine scan /path/to/project --gate --pdf report.pdf
echo $?                                                        # 1 = FAIL (risk above your limit), 0 = PASS
./dockwatch-engine --help
```

For GitHub, use the ready-made workflow instead: [CI guide](../ci-template/README.md).

---

## Optional

| Install | For |
|---|---|
| Docker Engine, plus your user in the `docker` group (`sudo usermod -aG docker $USER`, then log in again) | The image scanners (Trivy image, Dockle): turn them on in ⚙ Settings |
| `git` | The git timeline on the History page |

## Update

Download and extract the newer package over the old folder (step A1), then run `./start-dockwatch` again. Settings, history and scanners are kept.

## Uninstall

```bash
rm -rf ~/dockwatch-engine ~/.local/share/dockwatch
```

Optionally, also delete the `.dockwatch` folder inside each project you scanned.

## Problems?

| What you see | What to do |
|---|---|
| `Permission denied` when starting | Run `chmod +x start-dockwatch dockwatch-engine` in the `dockwatch-engine` folder |
| `GLIBC_2.31 not found` | Your Linux is older than Ubuntu 20.04 / Debian 11; use a newer one |
| A scanner shows *could not be installed* | Usually no internet, or a proxy blocking GitHub. Retry with `./dockwatch-engine setup` |
| Address already in use (port 8765) | DockWatch is already running; or use another port: `./start-dockwatch --port 8766` (and tunnel `8766` instead) |
| The browser does not open | Open http://127.0.0.1:8765/ yourself; on a server, use the SSH tunnel (B) |
| Image scanners are *skipped* | Docker isn't running, or your user can't use it (see Optional) |

More: [README](../README.md) · [open an issue](https://github.com/MMoizSiddiqui/DockWatch/issues)
