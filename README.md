# Void Linux Dotfiles

## Zorin OS to Void

On Zorin OS, the workflow required debloating a pre-configured base. While functional, it was ultimately limiting due to an outdated GNOME stack and fragile extensions.

Void Linux provided a clean slate:

* **Minimal Base:** Built from scratch with only the necessary packages.
* **Stability:** A highly stable rolling release that eliminates unexpected breakage.
* **Skill Progression:** Moving past a "just works" environment to actively manage and optimize the underlying system.

---

## System Organization

Configurations are managed and deployed using **GNU Stow**. This keeps the home directory organized, clean, and entirely reproducible in the event of a system rebuild.

### Current Modules:

* **Shell:** `zsh`
* **Compositor:** `niri` (Scrollable-tiling Wayland compositor)
* **Shell:** `noctalia`
