# Hyprlock

> **Platforms:** Linux only — this is a [Hyprland](https://hyprland.org/) lock
> screen (wm lock). Not used on WSL/Windows machines.

Config lives at [`.config/hypr/hyprlock.conf`](../.config/hypr/hyprlock.conf), symlinked to
`~/.config/hypr/hyprlock.conf`. It sources `colors.conf` for the palette
variables referenced below.

## What it does

```
┌────────────────────────────────────┐
│                                    │
│                                    │
│        [ • password input ]        │
│                                    │
│                          duhncan   │
│                    ╰  22:15:07     │
└────────────────────────────────────┘
```

- **Background** — live screenshot with 8px blur (2 passes), noise, contrast
  1.30, brightness 0.80, vibrancy 0.21.
- **Clock** — large (70px) label, redrawn every second via
  `cmd[update:1000]`, bottom-right with soft shadow.
- **Username** — small (20px) label above the clock.
- **Input field** — centered 250×50 round-ish field with 0.3 dot spacing;
  hides the dots when empty (`fade_on_empty`).
- **General** — `ignore_empty_input = true` so stray presses don't open the
  field.
