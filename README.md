# Rocloud Fortuna
(often referred to as **Rocloud** or **Fortuna**)

**Rocloud Fortuna** aims to be a feature-rich wrapper for the Roblox OpenCloud API, written in pure Luau and built upon the [Lune](https://github.com/lune-org/lune) runtime.

---

## Features
- **Pure Luau**: Rocloud is written entirely in Lune, 
- **Easy Integration**: Minimal setup to get started with robust API calls.
- **Asynchronous**: Non-blocking API calls where possible for improved performance.
  
## Prerequisites
- **Roblox API Key**: You'll need a valid Roblox OpenCloud API key with the necessary permissions for the endpoints you plan to use.
- **Lune Runtime**: Rocloud depends on the Lune runtime to operate in a pure Luau environment. You can install the [supported Lune version](https://github.com/lune-org/lune/releases/tag/v0.8.9) here.

## Installation
Firstly, you will need the supported Lune version.
Install the [Lune 0.8.9](https://github.com/lune-org/lune/releases/tag/v0.8.9) binary for your operating system here.

> [!WARNING]
> Due to a new update released in `Lune 0.8.9` older versions are not 100% supported.

Oops, installation is incomplete...<br>
Doesn't matter! Lune isn't that hard to use!<br>
I'm pretty sure you can just set it up yourself even if you have very little experience.

## Usage
Initializing Rocloud Fortuna <br>
Create a new instance by passing your Roblox API key:

```lua
local Rocloud = require("RocloudFortuna") --> You may want to refer to this as Rocloud for clarity to the developers inspecting your code
local FortunaAPI = Rocloud.new("your-api-key")
```
