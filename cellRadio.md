# Cell Radio transmitter project

## Principal schema of the cellular radio transmitter

![Principal schema of cell radio transmitter](HL_cell_radio_transmitter.png)

There are 6 principal components of a radio transmitter to be implemented in a cell that are presented in the table below with the implementation option.

|Sensor |Amplifier 1|Modulator |Oscillator |Amplifier 2|Antenna |
|--     |--         |--        |--         |--         |--      |
|GPCR   |G-protein   |Protein semiconductor |Protein semiconductor |Ca+ |DNA |
| | | | |NO| |
| | | | |Redox signaling | |
| | | | | |Ferritin |

Based on [trasduction pathways](https://en.wikipedia.org/wiki/Signal_transduction), [second messengers](https://en.wikipedia.org/wiki/Second_messenger_system) we could propose the pathway we could possibly update to adopt the presented above schema. As the overall goal of the project is to make a cell to transmit significant information in radio frequency range. Currently we are headed to MHz range of radio transmission.

## The Naive implementation schema

![Naive implementation](HLD_naive_GPCR.png)

The naive approach include: 

1. GPCR triggers G-protein
1. G-protein triggers a second messenger
1. A second messenger activates coupled nuclear receptors R1 and later R2
1. Receptors acts like modulator transmitting for example ions of Ca+ through a nuclear membrane with desired frequency of GHz, that matches resonance frequency of an DNA. 
1. An oscillation produced by ions should trigger the electronic alternating current on DNA, and in its turn produce radio-waves.
