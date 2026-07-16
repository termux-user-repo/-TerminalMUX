# 🐍 pythonS

A tiny terminal toy you run with:

```bash
curl -sL https://raw.githubusercontent.com/<you>/<repo>/main/pythonS.sh | bash
```

It shows:
- Your public IP
- Your geolocation (city, region, country, ISP, etc.)
- A spinner ("Loading 🐍pythonS \|/-", rotates twice)
- A "#" progress bar ("Getting GitHub repository data")
- ASCII art banner

## Setup on GitHub

1. Create a new repo (e.g. `pythonS`).
2. Add `pythonS.sh` to the repo root, commit, push.
3. Get the **raw** file URL:
   `https://raw.githubusercontent.com/<username>/<repo>/main/pythonS.sh`
4. Anyone can now run:
   ```bash
   curl -sL <raw-url> | bash
   ```

## Notes
- Uses `api.ipify.org` / `ifconfig.me` for IP and `ip-api.com` for geolocation — no API key needed, no `jq` dependency.
- Pure bash, works on macOS/Linux terminals (uses ANSI escape codes + emoji, so a modern terminal is best).
- `curl | bash` runs arbitrary code from wherever the URL points, so only run it from repos you trust — same rule applies to anyone you share your own raw link with.
