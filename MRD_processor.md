# Memristive reaction diffusion processor

Memristive devices provide interesting option to be used as electronic synapses, connecting even biological cells. It seems to be reasonable to create the analog schematic adopting metaphor of neuron cells with the richness of inhibitory and neuromodulatory mechanisms. The interest in neuromodulatory mechanisms is based on our previous research during [NeuCogAr](https://github.com/research-team/NEUCOGAR) project, that is dedicated to the reimplementation of psycho-emotional states and is based on the model of Hugo Lövheim ["cube of emotion"](https://en.wikipedia.org/wiki/L%C3%B6vheim_cube_of_emotion) and neuromodulators: dopamine, serotonin, noradrenaline.

## Neuron

Single neuron schematic is presented below: 

![Memristive inhibitory and modulatory schematic](https://raw.githubusercontent.com/research-team/memristive-brain/master/doc/HL_mod_inh_mem_neuron.png)

The complete description is available [here](https://github.com/research-team/memristive-brain/blob/master/doc/memristive-brain_technical_roadmap.md#neuron).

##  Memristive reaction diffusion neuromodulation

Reaction diffusion computers are interesting alternative for traditional silicon processing units and their use in robotics was indicated by <span id="#a1">[Adamatzky 2005](#Adamatzky_2005)</span> and <span id="#a2">[Fontana 2011](#Fontana_2011)</span>.

![MRD processor high level architecture](MRD_modulator_synchroniser.png)

Overall schematic is inspired by [nigrostriatal pathway of the dopamine subsystem of the mammalian brain](https://en.wikipedia.org/wiki/Basal_ganglia#Circuit_connections). 
The modulating subsystem is inspired by dopamine modulation of striatum via D1, D2 receptors. DA nucleus (SNc - [substancia nigra compacta](https://en.wikipedia.org/wiki/Substantia_nigra)) triggers the [Belousov–Zhabotinsky (BZ) reaction](https://en.wikipedia.org/wiki/Belousov%E2%80%93Zhabotinsky_reaction) via laser and controls it via electric field [Adamatzky 2005]. The waves of the BZ reaction spreads through the reactor (depicted as BZ circle) that contains the matrix of PANI devices [Fontana 2011]. The wave front of the maximum pH modulates increasing the conductivity of a PANI memristive devices. Memristive devices that acts as synapses of the modulatory nuclei (Striatum) increases the activity of neurons of the modulatory nuclei implemented via silicon schematic. The increased pseudo-neuronal activity of the modulatory nuclei excites more the excitatory nuclei (that corresponds to direct part of the nigrostriatal pathway) and inhibits more the inhibitory nuclei (that corresponds to indirect part of the nigrostriatal pathway). The excitatory pathway excites more the thalamus nuclei while inhibited inhibitory nuclei do not interfere with the influence of the excitatory nuclei overall this increases the pseudo-neuronal activity of the thalamus that in its turn increases the activity of thalamo-cortical loop. During the minimum pH wave front the reactor modulates the modulatory nuclei towards the activation of inhibitory nuclei and inhibition of excitatory nuclei that in its turn deactivates the thalamo-cortical loop. 

The MRD synchroniser in inspired via synchronisation mechanisms of a mammalian brain. The BZ reaction is triggered via laser and its speed thus frequency of the synchronisation is controlled via electric field where the maximum pH wave front increases the activity of the inhibitory neurons that projects their activity over thalamo-cortical loop. The synchronisation of the memristive brain parts initiates the temporal spatial patterns of pseudo-neuronal activity that build associations of for example: stimuli with actions with reward modulated by DA nucleus.

## References

<b id="Adamatzky_2005">(Adamatzky 2005)</b> Adamatzky, A., Costello, B. D. L., & Asai, T. (2005). Reaction-diffusion computers. Elsevier. [↩](#a1)

<b id="Fontana_2011">(Fontana 2011)</b> Fontana, M. P., & Erokhin, V. (2011). Thin Film Electrochemical Memristive Systems for Bio-Inspired Computation. Journal of Computational and Theoretical Nanoscience, 8(3). https://doi.org/10.1166/jctn.2011.1695 [↩](#a2)


