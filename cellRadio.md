# Cell Radio transmitter project

## Principal schema of the cellular radio transmitter

![Principal schema of cell radio transmitter](HL_cell_radio_transmitter-0.1.png)

There are 6 principal components of a radio transmitter to be implemented in a cell that are presented in the table below with the implementation option.

|Sensor |Amplifier 1|Modulator |Oscillator |Amplifier 2|Antenna |
|--     |--         |--        |--         |--         |--      |
|GPCR   |G-protein   |Protein semiconductor |Protein semiconductor |Ca+ |DNA |
| | | | |NO| |
| | | | |Redox signaling | |
| | | | | |Ferritin |
|GPCR   |Ligand     |Ion pump |Ion pump | Ion pump| DNA|

Based on [trasduction pathways](https://en.wikipedia.org/wiki/Signal_transduction), [second messengers](https://en.wikipedia.org/wiki/Second_messenger_system) we could propose the pathway we could possibly update to adopt the presented above schema. As the overall goal of the project is to make a cell to transmit significant information in radio frequency range. Currently we are headed to MHz range of radio transmission.

## Principal schema of synchronized cell radio transmitter

![Principal schema of cell radio transmitter](HL_cell_radio_transmitter.png)


N |Sensor |Trigger |Blocker |Synchronizer|Modulator |Amplifier |Antenna |
--|--     |--      |--      |--          |--        |--        |--      |
1.|GPCR   |Ligand  |???     |?Ions       |Ion pump  |Synch. Ion pumps |DNA |
2.|GPCR   |Ligand  |        |cAMP       |Ion pump  |Adenylyl cyclase |DNA |


## The Naive implementation schema

![Naive implementation](HLD_naive_GPCR.png)

The naive approach include: 

1. GPCR triggers G-protein
1. G-protein triggers the ligand
1. The ligand activates transforming the blocker
1. This way unblocks the ATP on the ion pump
1. The ion pump acts like modulator transmitting for example ions through a nuclear membrane with desired frequency of MHz-GHz, that matches resonance frequency of an DNA. 
1. An oscillation produced by ions should trigger the electronic alternating current on DNA, and in its turn produce radio-waves.
