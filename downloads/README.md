# Downloads

The ready-to-run DockWatch programs. The same files are on the [Releases page](https://github.com/MMoizSiddiqui/DockWatch/releases/latest).

| File | For | Setup guide |
|---|---|---|
| [`DockWatch-1.0.0-windows-x64.zip`](DockWatch-1.0.0-windows-x64.zip) | **Windows 10 / 11** (64-bit): the app | [Windows setup](../docs/setup-windows.md) |
| [`dockwatch-engine-linux-x86_64.tar.gz`](dockwatch-engine-linux-x86_64.tar.gz) | **Linux** (64-bit): desktop, VM or server | [Linux setup](../docs/setup-linux.md) |
| [`SHA256SUMS.txt`](SHA256SUMS.txt) | Checksums to verify the two files | see below |

**How to download a file from here:** click its name, then the **download** button (⤓) at the top right of the page.

For GitHub CI you don't download anything: copy [`ci-template/dockwatch.yml`](../ci-template/dockwatch.yml) into your repository ([CI guide](../ci-template/README.md)).

## Verify a download (optional)

- **Windows, PowerShell:** `Get-FileHash DockWatch-1.0.0-windows-x64.zip`, and compare with the line in `SHA256SUMS.txt`.
- **Linux:** `sha256sum -c SHA256SUMS.txt --ignore-missing`, which prints `OK` for each file you downloaded.
