---
author: Sascha Brandt
category: Installation Guide
last_updated: November 07, 2018
license: cc-by-sa 4.0
order: 2
permalink: pool_guide
title: Using PADrend at the University Pools
---

For the CS Department Computer Pools at Paderborn University and Heinz Nixdorf Institute there is a simple install script for PADrend available, so you don't have to build it yourself (currently linux only).

To get started, simply run the script located at `/upb/groups/fg-madh/public/share/padrend/padrend_base/setup.sh`.

The script will first ask for a destination folder (default: `~/padrend`) where it will put configuration files, symbolic links to required folders, and an example project which you can use to start developing you own plugins.
It also updates your `.bashrc` and `.zshrc` with the required path variables.

After the script is done, you need to start a new terminal or re-login to update the required path variables.

To run PADrend, open a terminal, navigate to `~/padrend` (or whatever folder name you chose) and run `PADrend`.
