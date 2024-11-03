# Rocloud Fortuna
(often referred to as **Rocloud** or **Fortuna**)

> Quickly integrate the **Roblox OpenCloud** API into your Lune application.

**Rocloud Fortuna** aims to be a feature-rich wrapper for the Roblox OpenCloud API,<br>
written in pure Luau and built upon the [Lune](https://github.com/lune-org/lune) runtime.

---

## Features
- ***Pure Luau*** <br>
  &nbsp;&nbsp;&nbsp;&nbsp;Rocloud is written entirely in Luau, with the aid of Lune APIs.
- ***Similar API*** <br>
  &nbsp;&nbsp;&nbsp;&nbsp;Aims to provide similar methods to Roblox's datamodel APIs, making the learning curve smaller.
- ***Easy Integration*** <br>
  &nbsp;&nbsp;&nbsp;&nbsp;Minimal setup to get started with robust API calls.
  
## Prerequisites
- **Roblox API Key**: You'll need a valid Roblox OpenCloud API key with the necessary permissions for the endpoints you plan to use.
- **Universe ID**: Roblox requires the Universe ID of places while sending OpenCloud requests. Grab your Universe ID [here](https://create.roblox.com/dashboard/creations)!
- **Lune Runtime**: Rocloud Fortuna depends on the Lune runtime to operate. You can install the [supported Lune version](https://github.com/lune-org/lune/releases/tag/v0.8.9) here.

## Installation
Firstly, you will need the supported Lune version.
Install the [Lune 0.8.9](https://github.com/lune-org/lune/releases/tag/v0.8.9) binary for your operating system here.

> [!WARNING]
> Due to a new update released in `Lune 0.8.9` older versions are not 100% supported.

Oops, the installation guide is incomplete...<br>
I'm pretty sure you can just set it up by yourself even if you have very little experience.

## Usage
Initializing Rocloud Fortuna <br>
Create a new instance by passing your `Roblox API key` & `Universe ID` for your experience:

```luau
local Rocloud = require("RocloudFortuna") --> You may want to refer to this as Rocloud for clarity to the developers inspecting your code
local FortunaAPI = Rocloud("your-api-key", universe_id_for_the_place)

-- local CartwheelIntoDwayneJohnSimulator = Rocloud("???", 1)
```

Then select the API endpoint you want to access.

```luau
local DataStore = FortunaAPI.v1.DataStore

local TestStore = DataStoreService:GetDataStore("OpenCloudTesting")

print(TestStore:SetAsync("Message", "Hello from lune!")) --> output: "nil"
print(TestStore:GetAsync("Message")) --> output: "Hello from lune!"
```
