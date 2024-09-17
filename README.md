# [Multicast, Sonos, Phorus & Play-Fi Broadcast 255.255.255.255:<port> Discovery Solution](https://community.ubnt.com/t5/EdgeMAX/Multicast-Sonos-Phorus-amp-Play-Fi-Broadcast-255-255-255-255-lt/td-p/1259616)

**This repo is based on a Rust reimplementation of the udp-broadcast-relay program.** The Rust port is much more straightforward to cross-compile to the MIPS architecture of EdgeRouter devices.

Unlike the [upstream repo](https://github.com/britannic/ubnt-bcast-relay), this does not contain any prebuilt binaries among the code.

Only EdgeRouter X support has been tested and the build scripts currently only work for ER-X.

## Licenses

* GNU General Public License, version 3
* GNU Lesser General Public License, version 3

## Features

* [udp-bcast-relay-rs](https://github.com/luryus/ubnt-bcast-relay-rs)
* Integrated with EdgeOS CLI
* Can also be configured from the EdgeOS Web GUI
* Lightweight, very low overhead for home based networks

### This solution is designed to work on EdgeMAX routers.

So, like many folk who like to segregate our SOHO home networks with VLANs, subnets, etc., I was frustrated at not being able to use iOS apps, Windows drivers etc. to find and use (in my case) a Play-Fi LAN streaming speaker system on my logical networks.

First, I was able to use IGMP-PROXY for the standard broadcast protocols across my VLANs, however, although systems (NAS, Printers, etc.) were happily broadcasting, the Phorus/Play-Fi 255.255.255.255:10102 broadcasts weren't reflected across the VLANs, which is actually a good thing in general, but not for my use case.

Here is my LAN equipment configuration:

ERL3 -> ToughSwitch 8-Pro (root switch) -> Cisco SG 200-08

Definitive Technology W9 WiFi/Wired speaker is on my home user network VLAN 5 and is located in my den

Office network is VLAN 6

In order to have devices on VLAN 6 discover and use the W9 on VLAN 5, I needed to rebroadcast 255.255.255.255 on port 10102. I accomplished this, by downloading and compiling [Joachim Breitner's brilliant udp-broadcast-relay](http://www.joachim-breitner.de/udp-broadcast-relay/) on my ERL3 and then integrating it into the CLI configuration.

YMMV and of course, there is always a risk using any non Ubiquiti approved/test software, but for those of us stuck with equipment that forces a home user paradigm on our networking, this may be the antidote.

## Installation

1. Grab the latest release from [Github releases](https://github.com/luryus/ubnt-bcast-relay/releases) or build the project yourself (instructions below)
2. Copy the .tar.gz file to your router
3. Run:
    ```
    tar zxvf ./install_ubnt_bcast_relay.v1.2.tgz
    sudo bash ./install_ubnt_bcast_relay.v1.2
    # select menu option #1 if installing for the first time
    # select menu option #2 to completely remove ubnt_bcast_relay
    ```

### Manual build

1. Install nightly Rust via rustup
2. Install cross
3. Build the udp-bcast-relay-rs binary:
    ```
    ./build-relay-binary.sh
    ```
4. Build the setup script package:
    ```
    ./build
    ```
5. The built package will be stored under output/


## Removal

## Configuration

### Setup initial configuration

Using the network description above, here is a working example:

Run configure:

    set service bcast-relay id 1 description 'Play-Fi listener'
    set service bcast-relay id 1 interface eth0.5
    set service bcast-relay id 1 interface eth0.6
    set service bcast-relay id 1 port 10102
    commit
    save
    exit


This generates a configuration stanza like this:

    service {
        bcast-relay {
            id 1 {
                description "Play-Fi listener"
                interface eth0.5
                interface eth0.6
                port 10102
            }
        }
    }

### Remove configuration

Run configure
    delete service bcast-relay
    commit
    save
    exit

#### To clone UBNT Broadcast Relay:

    git clone https://github.com/britannic/ubnt-bcast-relay.git
